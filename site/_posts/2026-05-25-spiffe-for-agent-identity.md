---
title: "Zero-trust for local agents: what SPIFFE gets right, and the session identity gap it leaves open"
date: 2026-05-25
kicker: "Essay"
tags: [devsecops, platform-engineering, spiffe, zero-trust, agentic-ai, workload-identity]
description: "SPIFFE/SPIRE solves workload identity for microservices cleanly. Here is where it transfers to agentic workloads - and where the session identity gap requires something it doesn't yet provide."
---

Every Goose session I run that touches infrastructure is authenticated with my credentials. My kubeconfig, my AWS profile, my GitHub token sitting in the shell environment. When I type a command, I'm accountable for it. When Goose runs one - via a shell tool, an MCP server, a kubectl invocation - the auth log shows me. There's no separation between my identity and the agent's identity, no session boundary, no scope enforced at the credential layer.

For the kind of work I described in my [scoping post]({{ '/2026/05/scoping-goose-for-ops/' | relative_url }}), that's acceptable in the short term because I constrained access at the RBAC level. RBAC-only is not workload identity though. It's a permission boundary with no traceability. When I'm running agents in environments that matter, I want what I'd want for any other workload: cryptographic identity, short-lived credentials, a clear audit trail.

[SPIFFE](https://spiffe.io) is the framework I'd reach for first. I've used SPIRE to issue workload identity for service meshes - mTLS between services, JWT-SVIDs for cross-cluster API calls, workload attestation tied to k8s pod metadata. The question I've been sitting with: does the same model transfer to agent workloads?

Partly. Here's where I've landed.

## What SPIFFE/SPIRE actually does

The quick version, for readers who haven't wired it up. SPIFFE defines a standard for workload identity: each workload gets a SPIFFE ID in the format `spiffe://<trust-domain>/<path>`, and a SVID (SPIFFE Verifiable Identity Document) that proves it. [SPIRE](https://spiffe.io/docs/latest/spire-about/) is the reference implementation that issues and rotates them.

Two SVID types matter here:

- **X.509-SVIDs** are TLS certificates. They enable mTLS - mutual authentication where both sides prove identity. TTL defaults to 1 hour; SPIRE auto-rotates via a streaming Workload API connection, so workloads get fresh certs before expiry without polling.
- **JWT-SVIDs** are signed tokens with mandatory `aud` (audience) and `exp` (expiry) claims ([per the SPIFFE JWT-SVID spec](https://spiffe.io/docs/latest/spiffe-specs/jwt-svid/)). Short-lived, single-audience. Better for discrete API calls where you want to scope the credential to one downstream service.

Attestation is how SPIRE knows a workload is who it claims to be. Node attestation verifies the underlying host: cloud instance identity documents, k8s projected service account tokens, TPM. Workload attestation verifies the process: Unix UID/GID, k8s pod metadata, docker labels, systemd unit name. The combination gives you: this specific process, running in this specific pod, on this specific node, with this specific identity.

## Where it fits for agents

An agent binary running in a known environment attests cleanly with existing SPIRE selectors. A Goose process in a k8s pod gets a SPIFFE ID like `spiffe://prod/agents/goose-worker`, backed by a certificate issued to that pod's identity. It auto-rotates. Any internal service configured to trust the same SPIRE server can verify it.

For tool calls specifically, JWT-SVIDs with audience binding are a real improvement over long-lived API keys. Instead of a static `GITHUB_TOKEN` sitting in the environment, the agent requests a JWT-SVID with `aud: github-proxy` before each call - short-lived, audience-scoped, auditable on the receiving end by checking the `aud` claim. The receiving service sees exactly which SPIFFE ID made the call and when.

I've done this for batch jobs calling internal services. The setup transfers directly to a Goose process running in a pod.

## The session identity gap

Here's where it gets complicated. SPIFFE's attestation model is process-centric. The SVID belongs to the running process. One agent binary can run hundreds of sessions over its lifetime - from SPIFFE's perspective, they're all the same workload.

Three things break when you need session-level accountability:

**The audit trail problem.** Your API gateway log shows `spiffe://prod/agents/goose-worker` called `kubectl get pods` 47 times. You can't tell which session produced each call, which user prompt triggered it, or what chain of reasoning the model was following when it ran. For incident investigation, that's not enough. For compliance, it's useless. This is the same gap I named in the [supply chain post]({{ '/2026/05/supply-chain-questions-for-agents/' | relative_url }}) -- no attestation connecting executed commands back to the reasoning that produced them.

**The blast radius problem.** If a session goes wrong - prompt injection, bad tool call, a model that decided to `kubectl delete` something it shouldn't - you can't revoke that session's credentials independently of the agent process. Revoking the SVID kills all active sessions on that agent. You're choosing between "leave the compromised session running" and "take down everything."

**The subprocess identity problem.** When Goose spawns a shell tool that calls `aws s3 ls`, that subprocess is not the attested workload. It inherits the parent's environment. The Workload API socket binding is to the agent PID; child processes get nothing from SPIRE. If the subprocess needs to authenticate to something, it's back to environment-variable credentials.

SPIFFE gives you process identity. Agents need session identity as a first-class concept. JWT-SVIDs are the closest fit - short-lived, audience-bound, can carry additional claims - but SPIRE issues them for the process, not the session. Minting a fresh JWT with session-scoped claims requires custom logic above the SPIFFE layer.

## What a session-identity layer looks like

A pattern I've been sketching sits on top of SPIFFE rather than extending it. The rough shape:

1. **Process attestation via SPIRE.** The agent binary gets a SPIFFE X.509-SVID the standard way - workload attestation, auto-rotating, 1-hour TTL. This is the base credential: it proves the agent is what it claims to be, running where it claims to be running.

2. **A session minting service.** A lightweight internal service, itself identified via SPIFFE, that issues session tokens. At session start, the agent presents its process SVID and gets back a short-lived JWT with session-scoped claims: `session_id`, `user_id`, `initiated_at`, `allowed_tools[]`, `max_ttl`. The session JWT is signed by the minting service's key, not SPIRE's. TTL is per-session policy. A receiving service that enforces `allowed_tools[]` rejects calls to any tool not in the session's approved list -- so a session scoped to read-only Kubernetes access literally cannot call an AWS or GitHub tool, even if the agent process has those MCP servers configured. The minting service populates this claim at session start based on the session's declared scope, which can be derived from the user prompt, a session policy file, or both.

3. **Session JWT on all tool calls.** Every downstream call carries the session JWT as a bearer token. The receiving service validates it against the minting service's public key, extracts the `session_id`, and logs it. The audit trail is now session-granular, not process-granular.

4. **Minting service as revocation point.** To kill a session, you invalidate its `session_id` at the minting service. Other sessions on the same agent process are unaffected.

This is not SPIFFE. It's a pattern that uses SPIFFE for base attestation and adds the session layer on top. I've built analogous things for batch job pipelines that needed per-job credential scope; the mechanics are the same, the agent-specific claims (`allowed_tools[]`, `initiated_at`) are new.

The piece I haven't solved: subprocess identity. Getting a spawned shell tool to carry the session JWT rather than fall back to environment credentials requires either a wrapper that injects the JWT into the subprocess environment, or an MCP server that brokers all tool calls through the session-aware layer. The second option is cleaner but requires more infrastructure. I want to prototype both before recommending one.

## What the ecosystem needs

SPIFFE and SPIRE are the right foundation. Platform-agnostic attestation, auto-rotating credentials, a standard Workload API - all of it transfers cleanly to agents at the process level.

The missing piece is session identity as a standard abstraction rather than a custom per-deployment pattern. What would help: a SPIFFE profile for agentic workloads that formalizes session token minting on top of SVIDs - the same way the existing k8s and AWS profiles define how attestation works in those environments. An "agent session" profile could specify the minting exchange, the required JWT claims, and the revocation mechanism, so every platform team doesn't have to design this from scratch. This is the kind of standardization work that belongs at a neutral body -- CNCF's successor to TAG Security, or the AAIF working groups already convening around agent standards -- rather than re-invented by every platform team.

I'm planning to prototype the session minting pattern in a future post - a real SPIRE setup, a real minting service, a real Goose session where every tool call carries a verifiable session JWT. I want to see where the subprocess identity problem bites in practice before writing up the solution.

If you're already working on something in this space, [reach out]({{ '/about/' | relative_url }}).
