---
title: "Scoping Goose for production-adjacent ops work"
date: 2026-05-08
kicker: "Tutorial"
tags: [tutorial, goose, kubernetes, devsecops, platform-engineering]
description: "A walkthrough of how I configured Goose with read-only Kubernetes access, ran a real triage session, and what I learned about what to lock down."
---

There's a pattern I keep seeing in tutorials for [Goose](https://github.com/aaif-goose/goose): the author installs it, gives it their default kubeconfig or shell, and runs a demo. In my [first post]({{ '/2026/05/architect-notes-on-agentic-ai/' | relative_url }}) I framed agents as a new class of workload -- here's what that means in practice. The demo works, the screenshots look great, and somewhere in the comments is a question like *"how do you keep this from `rm -rf`-ing your home directory?"* that nobody answers.

I'm an architect. That question is the entire interesting part for me. So this post is the inverse of the usual tutorial - it spends most of its words on the *configuration*, not the demo. The demo is at the end and is honestly the less important section.

> **TL;DR**: Before letting Goose touch anything real, scope its access through a dedicated service account with read-only RBAC, run it in a working directory it can't escape from, and treat the boundary between "investigate" and "apply" as something enforced by IAM, not by trust in the agent's judgment.

## The threat model I'm working from

Goose is a local agent with shell access and MCP-based tool integrations. From a platform-security perspective, that means:

- Anything in my shell environment is in scope for the agent.
- Anything my user can do, the agent can attempt.
- Anything the configured MCP servers can do is part of the agent's reach.
- The LLM behind it can produce confidently wrong commands. It will eventually do this. Plan for it.

The boundary I want is roughly the boundary I'd want for a competent junior engineer on their first week: investigate freely, propose changes, but apply nothing to shared infrastructure without a human in the loop. The way I enforce that boundary should not depend on the agent following instructions - it should be enforced where the credentials live.

## The setup

For this session I configured Goose to triage a misbehaving service in a staging Kubernetes cluster. Here's the full configuration, with reasoning.

### 1. A dedicated service account with read-only RBAC ([Kubernetes RBAC docs](https://kubernetes.io/docs/reference/access-authn-authz/rbac/))

I created a dedicated service account in the cluster, scoped to a single namespace, with read-only permissions:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: goose-triage
  namespace: staging
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: goose-triage-readonly
  namespace: staging
rules:
  - apiGroups: [""]
    resources: ["pods", "pods/log", "events", "configmaps", "services", "endpoints"]
    verbs: ["get", "list", "watch"]
  - apiGroups: ["apps"]
    resources: ["deployments", "replicasets", "statefulsets"]
    verbs: ["get", "list", "watch"]
  - apiGroups: ["metrics.k8s.io"]
    resources: ["pods"]
    verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: goose-triage-binding
  namespace: staging
subjects:
  - kind: ServiceAccount
    name: goose-triage
    namespace: staging
roleRef:
  kind: Role
  name: goose-triage-readonly
  apiGroup: rbac.authorization.k8s.io
```

I then generated a dedicated kubeconfig pointing at that service account's token, scoped to that namespace, with `current-context` already set. No admin context, no other clusters, no other namespaces.

This took maybe ten minutes. If you skip this step, you're not using an agent - you're using a very fast autocomplete with root.

### 2. A scoped working directory

I created `~/goose-sessions/triage-2026-05-22/` and launched Goose from there. The Developer extension's shell tool can run anywhere your user can, so the right move is to give it a directory that doesn't have your dotfiles, SSH keys, or git credentials in scope of its working set.

### 3. An explicit prompt about boundaries

I started the session with this:

```
You have a read-only kubectl context configured (KUBECONFIG=./kubeconfig-goose-triage).
You have shell access in this working directory.
You do not have permission to apply any changes to the cluster, modify any files
outside this directory, or take any actions that affect shared infrastructure.

When you identify a likely root cause or recommend a fix, summarize it for me
to review - do not attempt to apply it yourself, even if you think the read-only
context will prevent harm.

Walk me through your reasoning before running each command.
```

The "walk me through your reasoning before running each command" line is important. Without it, Goose will sometimes batch 4-5 commands together and present results. Faster, but harder to interrupt when the reasoning is going somewhere wrong.

## The session

The actual investigation took about 12 minutes. I'm going to summarize rather than paste the whole transcript, since the configuration is the part that's worth your time.

**The scenario**: a Node.js service in the `staging` namespace had been crash-looping for two weeks. Standard "we keep meaning to look at this" backlog item.

**What Goose did**:

1. `kubectl describe` and `kubectl logs --previous` on the pod. Standard. Found `Last State: Terminated, Reason: OOMKilled`.
2. Pulled the deployment manifest. Noted `limits.memory: 512Mi`.
3. Inspected the container's command: `node index.js`. Noted no `--max-old-space-size` flag.
4. Inferred - correctly - that V8 was sizing its heap from the host's total visible memory rather than the container's cgroup limit -- Node.js doesn't read cgroup boundaries by default -- so the OOM killer fired before V8's garbage collector got aggressive.

That inference is the interesting one. I knew the V8/cgroup interaction existed in theory but hadn't connected it to this pod. Goose got from "OOMKilled" to "V8 doesn't respect container limits unless you tell it to" in about 90 seconds. I'd estimate I'd have spent 20-30 minutes on it, starting from a different hypothesis (queue consumer memory leak).

**Where I had to step in**: Goose suggested patching the deployment to add `--max-old-space-size=384` ([Node.js CLI docs](https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes)). The suggestion was reasonable. Two reasons I didn't let it try:

1. The real fix lives in our GitOps repo, not in `kubectl edit`. A patched cluster that drifts from git is a worse problem than the OOM.
2. 384Mi is a guess. The right number comes from actually profiling heap behavior under load.

I asked Goose to write a one-paragraph summary I could paste into a Jira ticket. It did, accurately.

## What I learned about scoping

A few things were clearer to me after this session than before:

**The read-only boundary is the whole game.** Not because I expect Goose to act maliciously, but because the moment "investigate" and "apply" become the same operation, you've lost the ability to keep a human in the loop. RBAC enforces this whether the agent agrees with it or not. That's the property I want.

**The "walk me through your reasoning" prompt matters.** It's the difference between an agent and an opaque oracle. It also produces text I can paste into a ticket or runbook, which is real ongoing value beyond the one session.

**Don't let the agent write to shared state, ever.** Even with read-only RBAC, the agent could in principle write to your local filesystem in ways that affect later sessions. Use a fresh working directory per session, or at minimum understand which files in your environment are reachable.

**The MCP integration is where this gets interesting and scary.** Goose's power comes from the 70+ MCP extensions it can talk to. Each one is a new permission surface. If you add an AWS MCP server, you now need to think about IAM policies on the role its credentials use. If you add a GitHub MCP server, that's a token with some scope attached that the agent can invoke on your behalf. The right mental model is not "I've secured Goose" -- it's "I've secured this specific set of MCP integrations for this specific session." Most of this isn't documented yet. I go deeper on the supply chain angle in [the next post]({{ '/2026/05/supply-chain-questions-for-agents/' | relative_url }}).

## A checklist I'm settling on

For anyone running Goose on infrastructure that matters:

1. **Dedicated service account per session type**, with the minimum RBAC for the workflow.
2. **A dedicated kubeconfig**, not your daily-driver one, with the SA token and a single context.
3. **A scoped working directory**, ideally inside a container or VM if you're paranoid.
4. **An explicit boundary prompt** that names what the agent can and can't do.
5. **A "summarize, don't apply" rule** for any change to shared infrastructure.
6. **Audit logs.** If your platform doesn't yet capture what the agent did, that's the next project after this one.

## What's next

I want to do the same kind of writeup for a few other workflows: Terraform drift detection (the agent investigating against a real cloud account), CI pipeline triage, and the supply chain question - how do you treat MCP servers as part of your software supply chain?

If you have an ops workflow you've been curious whether Goose could help with - especially anything platform-engineering-shaped - [tell me]({{ '/about/' | relative_url }}). I'll add it to the queue.

The [Goose docs](https://goose-docs.ai/) cover the basics. The [AAIF Discord](https://discord.com/invite/9zTwngHAMy) is where the real conversations happen. I'm `@{{ site.github_username }}` in #goose.
