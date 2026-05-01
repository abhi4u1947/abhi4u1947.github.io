---
title: "Agents as workloads: notes from the platform side"
date: 2026-05-01
kicker: "Welcome"
tags: [platform-engineering, agentic-ai, devsecops, iam, supply-chain, mcp, a2a, harness-engineering]
description: "Why a Cloud, Platform & Security Architect is writing about agentic AI - and what the current wave of writing on Goose, MCP, A2A, APM, and AGENTS.md still mostly misses."
---

I've spent twenty years designing and evolving large-scale, business-critical systems. Mostly platform engineering, DevSecOps, IAM, and lately software supply chain security. The kind of work where you spend a year designing centralized authentication, workload identity with PKI, and zero-trust networking, and then another year building it into platforms that real product teams actually adopt across ten-plus customer accounts and ten-plus product lines.

When I look at the current wave of agentic AI tools, I don't see them the way most of the writing about them frames them. I don't see "a smart assistant for developers." I see a new class of workload - one that will run inside the platforms I help build, with all the IAM, audit, observability, supply-chain, cost, and governance questions that implies.

That perspective is largely missing from the agentic-AI conversation. I want to add it.

## What's missing from the existing writing

If you search for tutorials on [Goose](https://github.com/aaif-goose/goose) - the open-source agent now hosted by the [Agentic AI Foundation](https://aaif.io) at the Linux Foundation alongside [MCP](https://modelcontextprotocol.io) and [AGENTS.md](https://agentsmd.org) - you'll find a lot of the same post. *Install Goose. Ask it to write a Python script. Watch it generate code. Marvel at the AI.* The framing is consistently "Goose is an AI coding assistant."

That's accurate, but it's the least interesting thing about it. Goose is something rarer:

> A local agent with a real shell, real filesystem access, and a growing stack of MCP integrations - that can be pointed at production-adjacent infrastructure and asked to do real work.

That's not a Copilot. From a platform architect's seat, that's a new kind of workload identity problem. A new kind of audit trail problem. A new kind of supply chain question - because if my pipelines are now executing reasoning produced by an LLM that called MCP servers I didn't write, what does provenance even mean here?

When Goose calls `kubectl exec` through an MCP server, the Kubernetes audit log records *my user identity* - not the agent's, not the session's, not the tool call that triggered it. There is no provenance connecting that API call back to the model reasoning that produced it. That's the gap.

And the gap is no longer purely conceptual. The specs and tooling to close it have started landing - fast - and most of the platform community hasn't caught up.

## What the last six months brought

Three things converged in the last six months that change how this conversation should be framed:

1. **The Agentic AI Foundation formed** at the Linux Foundation in December 2025, with platinum support from AWS, Anthropic, Block, Bloomberg, Cloudflare, Google, Microsoft, and OpenAI. MCP, Goose, and AGENTS.md are now under neutral governance. That removes the "which standard do we bet on" objection that was slowing enterprise adoption.

2. **Agent identity moved from blog posts to IETF drafts.** In March 2026, `draft-klrc-aiagent-auth-00` was published, composing the IETF WIMSE working group's work with [SPIFFE](https://spiffe.io) and OAuth 2.0 into a framework called AIMS (Agent Identity Management System). Separately, Dick Hardt (author of the original OAuth 2.0 RFC) has been developing [aauth.dev](https://aauth.dev) - a specification that treats agents as first-class identities rather than as OAuth clients known at build time. The MCP authorization spec itself, built collaboratively with Anthropic, Microsoft, Okta/Auth0, Arcade.dev and others, now defines OAuth-style protected resources with audience binding via [RFC 8707 resource indicators](https://datatracker.ietf.org/doc/html/rfc8707) and delegation via [RFC 8693 token exchange](https://datatracker.ietf.org/doc/html/rfc8693). That last bit matters a lot - and I'll come back to why.

3. **Microsoft shipped [APM](https://github.com/microsoft/apm) - Agent Package Manager.** One `apm.yml`, every harness, every machine. Lockfiles with content hashes. A policy file (`apm-policy.yml`) enforced at install time, including for transitive MCP servers. Tighten-only inheritance from enterprise to org to repo. This is the first piece of agent infrastructure that looks like it was designed by someone who has actually run an enterprise software supply chain program. It maps cleanly onto the SBOM / SLSA / in-toto thinking I've been doing for years - but applied to an entirely new artifact class: skills, prompts, plugins, and MCP server bindings.

4. **The extension and skills layer is taking shape.** The [Agent Skills Specification](https://agentskills.io/specification) defines a standard for how agents declare, discover, and invoke reusable capabilities across harnesses. Alongside it, the [Open Plugins](https://open-plugins.com) standard covers packaging and distribution - skills, commands, agents, hooks, and MCP server bindings as installable, namespaced artifacts with content-addressed lockfiles. Together they form a skills layer that sits between the protocol (MCP) and the identity layer (AIMS) - and it's the missing middle of the emerging platform stack that neither MCP nor APM fully addresses on its own.

The conversation about agents is no longer "look what it can write." It is: *how do we identify them, how do we package them, how do we govern them, and how do we keep them from setting our cloud bill on fire?* Those are platform engineering questions.

## How I got here

A few years ago I started looking seriously at how AI was actually getting wired into enterprise SDLC pipelines. At Amdocs I integrated OpenAI's GenAI into developer workflows and saw how quickly the conversation moves from "this is interesting" to "this is in production, who owns the failure modes?" I wrote about adjacent topics on LinkedIn in late 2024 - the CNCF End User Reference Architecture, NIST's post-quantum cryptography work - but agentic AI specifically needed a different format. Long form, with code, configs, and references to the actual specifications. Somewhere I could think out loud.

So this site.

## What I'm planning to write

The questions cut across the whole agentic AI stack. Here are the threads, with the actual specifications and projects each one touches - because none of this exists in isolation anymore.

### Identity and delegation: the unsolved problem

OAuth 2.0 was designed for clients known at build time. Agents are not that. They make runtime decisions, spawn sub-agents, and traverse trust boundaries. The cracks are visible.

The interesting question isn't "can we authenticate an agent." [SPIFFE](https://spiffe.io)/[SPIRE](https://spiffe.io/docs/latest/spire-about/) solved workload identity for non-human callers years ago, and the CNCF's 2026 recommendation for service-to-service auth is now explicitly *"SPIFFE for identity, OAuth 2.0 for access delegation, OPA for policy."* The hard problem is **delegation chains**. When an orchestrator agent spawns a sub-agent that calls a tool that calls an external API, under whose authority is the final action taken? Does a user's consent to the orchestrator flow automatically to the sub-agent? To what depth? Can a sub-agent end up with more permissions than its parent?

RFC 8693 token exchange supports nested delegation, but the IETF OAuth WG formally documented a delegation-chain-splicing weakness in early 2026, and the AIMS draft is solid on authentication but explicitly weaker on delegation. That gap is where the real platform-engineering work lives - and it's where almost nothing is written from the perspective of someone who's actually run an IAM program at scale. I want to write that.

### Software supply chain: from SBOM to agent manifests

I've spent the last year embedding SBOM ([CycloneDX](https://cyclonedx.org)), [SLSA](https://slsa.dev) provenance, and [in-toto](https://in-toto.io) attestation into release pipelines at Netcracker, with measurable results - issue detection up to six months pre-release, CVE-driven redeployments cut in half. That mental model maps almost too cleanly onto Microsoft's APM.

An `apm.yml` declares agent dependencies - skills, plugins, MCP servers, agent primitives - and the lockfile pins content hashes so a clone reproduces byte-for-byte. `apm-policy.yml` is enforced at install time, *including for transitive MCP servers*, with tighten-only inheritance. That last property is exactly the design pattern enterprise security teams asked for, and almost never got, in package manager history.

But agent manifests open new questions a normal SBOM doesn't touch:

- What's the equivalent of SLSA build provenance for a *skill* - a file containing prompts and instructions that change agent behaviour?
- How do you attest the integrity of an MCP server when its surface area is a set of tools, each with permissions implications? CVE scanning doesn't cover "this tool can `kubectl delete pod`."
- Hidden-Unicode injection is now a baseline scan in APM. What's the equivalent for skill instructions that don't trigger normal lint?
- And the research is already pointing in uncomfortable directions: a 2026 study by Gloaguen et al. on 138 real-world repositories found that *LLM-generated AGENTS.md files reduce task success and inflate inference cost by over 20%*. The agent follows the file faithfully. If your supply chain ships skills generated by another LLM, your performance and cost regression isn't a bug - it's a property of the artifact.

### Cost: the single biggest production problem in 2026

This is the question nobody was asking eighteen months ago and that everybody is asking now. Deloitte's 2026 tokenomics work has finance leaders treating AI spend with the rigor they used to reserve for energy or capital. Gartner predicts more than 40% of agentic AI projects will be cancelled by the end of 2027 - and the cited reasons are cost, unclear business value, and inadequate risk controls. None of those are model problems.

The specific failure modes I've seen referenced in production retrospectives:

- **Token maxing.** Defaulting to the most capable model for every task, with no routing logic. One healthcare enterprise reportedly consumed a trillion tokens in six months - over $6M unplanned - before finance understood what was driving it.
- **Orchestration loops.** A LangChain multi-agent system ran an infinite loop for eleven days before being noticed. The bill: $47,000.
- **Context bloat.** Naive memory injection scales linearly; production traces hit 80-120K token contexts within two to three weeks.
- **Tool definition tax.** MCP tool metadata can consume 40-50% of the context window on every call, regardless of relevance.

The platform answer isn't "pick a cheaper model." It is structural: model routing layers, per-workflow token budgets, prompt caching for stable system prompts, hierarchical multi-agent topologies (frontier model for the orchestrator, cheap models for workers - published architectures hit ~97% of full-frontier accuracy at ~61% of the cost), and hard iteration caps on every agent loop.

This is where platform engineering earns its keep. *"Cost is an architectural concern, not an operational one"* - that's the right frame, and it's the natural extension of the FinOps work platform teams have already been doing on cloud spend.

### Harness engineering: the new layer

This is the discipline that didn't have a name two years ago.

In phase one (~2022-2023), the conversation was prompt engineering. In phase two (2024-2025), context engineering - feeding the model the right files, project rules, and architectural constraints. The 2026 conversation is **harness engineering**: the non-model runtime that wraps the model with tool orchestration, verification loops, context management, guardrails, and observability. Mitchell Hashimoto put it bluntly: *"Anytime you find an agent makes a mistake, you take the time to engineer a solution so that the agent never makes that mistake again."* Most of the time, that solution lives in the harness, not in the model.

The implication is significant for platform teams. As frontier models converge in raw capability, competitive advantage shifts away from *which* model and toward *how good your harness is*. That's good news - it means the model layer becomes commoditised, business logic and guardrail rules live in your harness code, and lock-in becomes manageable. It also means platform teams now own a new layer in the stack: the deterministic execution loop that wraps a non-deterministic component.

I'll be writing about what that looks like - and where today's harness designs still have unsolved problems, particularly around the inferential controls (LLM-as-judge) that don't behave like the computational ones (linters, tests, type checkers) we know how to reason about.

### Multi-agent trust and A2A

Google's Agent2Agent protocol, now under the Linux Foundation, defines how agents from different vendors discover each other (via `/.well-known/agent.json` Agent Cards) and exchange tasks over HTTP + JSON-RPC + SSE. MCP and A2A are complementary: MCP is how an agent connects to tools and data; A2A is how agents connect to other agents.

The trust questions multiply at A2A boundaries. When an Agent Card claims certain capabilities and authentication requirements, who attests that claim? When the orchestrator delegates to a third-party A2A agent that then calls its own MCP servers, what does the audit trail look like end-to-end? The Riptides work on SPIFFE-for-MCP and SPIFFE-for-A2A is one of the few honest attempts to answer this with a real implementation, not a slide deck - and it's where I think the next two years of interesting standards work will happen.

### Observability for agent workflows

Distributed tracing exists for microservices. What's the equivalent for an agent that calls five tools, spawns a sub-task, modifies a file, and pauses for a six-hour async operation? OpenTelemetry has GenAI semantic conventions in progress, and a 2026 reverse-engineering of Claude Code's architecture documented a five-stage progressive compaction strategy for context - that kind of internal state is mostly invisible to current tracing tools.

I led enterprise OpenTelemetry adoption at Amdocs and cut defect investigation time by 30% in microservices contexts. The agent-tracing problem is harder for reasons that should be intuitive to anyone who's instrumented a stateful workload - but most of the published agent-observability writeups don't engage with that depth.

### Compliance and audit at scale

When agents run in production at volume, the audit trail question stops being theoretical. Today's tooling still can't tell you: which model reasoning produced which API call, under whose authorisation, with what context, through which chain of delegation. That answer exists for human users in mature IAM platforms. It does not exist for agents yet - not at the level of evidentiary quality a regulated industry actually needs. I want to map out what a real compliance story would look like, and what concrete things would need to change in the stack to support it.

### Guardrails: layered, not bolted on

The framing I've found most useful, from the production retrospectives: *AI accuracy first, then layered guardrails matched to business risk.* Most teams add walls before optimising what the agent knows and how it reasons. That leads to brittle systems that are both expensive and unsafe.

The architecturally honest answer has three pillars: identity scoping (who/what can act, under whose delegation), runtime enforcement (policy at the gateway between agent and backend systems - OPA fits naturally), and behavioural monitoring (deviation detection over agent trajectories, not just output content filtering). Output filters like LlamaGuard solve a real but narrow problem; the harder one is *unreasonable but technically permitted* actions - what AgentDoG's authors call the lack of agentic risk awareness in current guardrail models.

This is where platform teams and security teams need to converge, and it's the cleanest argument I can make for why DevSecOps thinking maps onto agents better than pure ML-ops thinking does.

### Real ops transcripts

Less abstract: incident triage sessions with Goose, including the parts where it was wrong and the parts where I had to override it. Configs that worked. Configs that broke production-adjacent things in interesting ways.

### Platform engineering view

How agentic AI fits into an Internal Developer Platform. What changes about your golden paths. What new capabilities you'd want to expose as self-service - agent provisioning with bounded identity, scoped MCP server access, cost budgets, audit policy templates - and what you absolutely should not.

## What I'm not going to do

- Write "the future of AI" essays. Other people are better at those.
- Pretend agents are magic. They are tools with failure modes. The failure modes are the interesting part.
- Ship demos that work in a sandbox and fall apart anywhere real.
- Treat the existing specs as either gospel or noise. AIMS, aauth.dev, the MCP auth spec, APM, A2A - each is a serious piece of work with real gaps. Engaging with them honestly is how the field gets better.
- Hide my mistakes. Twenty years in, I've made enough of them to know that writeups of failures are more useful than writeups of successes.

## Who this is for

If you're a platform engineer, architect, SRE, or DevSecOps person - this is for you. If you care about IAM, supply chain security, zero-trust, FinOps, or how to build platforms real teams actually adopt, you'll find things here that aren't on the agentic-AI hype circuit. Agentic AI is the current thread, not the permanent scope. The underlying interests - IAM, zero-trust, software supply chain, observability, Internal Developer Platforms - have been the work for twenty years. Agents are just the current place where those questions are getting harder, faster, and more interesting.

If you're an AI researcher or an app developer looking for hot takes on model capability, this is probably not your blog. There are better people writing for you.

If the perspective here - agents as workloads, not assistants - is one you haven't seen framed this way before, that's the opening thread. Next: how I scoped Goose for production-adjacent work, what I locked down before letting it touch anything, what the APM manifests and policy files actually look like, and where the AIMS-style identity model breaks down when you try to apply it to a real delegation chain.

Onward.
