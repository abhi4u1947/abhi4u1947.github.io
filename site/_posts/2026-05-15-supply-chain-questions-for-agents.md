---
title: "The supply chain questions nobody is asking about MCP yet"
date: 2026-05-15
kicker: "Tutorial"
tags: [opinion, mcp, supply-chain, devsecops, goose]
description: "If we treated MCP servers and agent workflows the way we treat any other code in our supply chain, what would we be doing differently?"
---

I spent a big part of the last year integrating supply chain security into SDLC pipelines - provenance with [SLSA](https://slsa.dev), attestation with [in-toto](https://in-toto.io), SBOMs with [CycloneDX](https://cyclonedx.org), signing with [Sigstore](https://sigstore.dev), the whole modern stack. The goal was the same as everyone else's: when something shows up in production, I want to be able to answer *where did this come from, who signed off on it, and what was it built from*.

Then I started using [Goose](https://github.com/aaif-goose/goose) and connecting it to MCP servers -- first in the [scoped ops setup I wrote about last week]({{ '/2026/05/scoping-goose-for-ops/' | relative_url }}) -- and I realized none of that thinking has been applied here yet.

Almost every post you can find on MCP frames it the same way: *MCP is the USB-C of AI integrations*. Plug in any server, your agent gains capabilities. It's slick, it's growing fast, and 70+ extensions exist for [Goose](https://aaif.io/projects/goose/) alone.

What nobody seems to be writing about: every MCP server you install is code from somewhere, running in your environment, with tools your agent will invoke based on natural language reasoning produced by an LLM. From a supply chain perspective, that is not a small surface.

Let me try to name the questions, because I think we need to start asking them out loud.

## What "supply chain" even means for an agent workflow

When a Goose session does something - say, "find the drift between our Terraform state and the AWS console" - the chain of things that produced that outcome looks roughly like:

1. **The model**. A specific LLM, with a specific version, behind a specific API. Its training data, its safety tuning, its tool-calling behavior - all part of what shaped the output.
2. **The agent code**. Goose itself: Rust binary, version-pinned, signed (or not) at distribution.
3. **The MCP servers**. Each one is its own piece of software, running locally or remote, with its own dependencies, its own update cadence, its own author.
4. **The tool definitions**. The schema and natural-language descriptions exposed by each MCP server, which the agent uses to decide what to call.
5. **The natural-language reasoning** produced by the model and conditioned on a prompt - yours, the system prompt, and any context retrieved during the session.
6. **The commands executed**, which are downstream of all of the above.

In a traditional CI/CD pipeline, we'd want provenance for every step. Here, we mostly have it for step 2 (the agent binary) and not much else.

## The questions I think we should be asking

Some of these are solvable today with existing tooling applied to a new context; others require new conventions that don't exist yet. I'll call that out as we go.

### Provenance for MCP servers

When I add an MCP server to my Goose configuration, I'm adding code that will run on my machine and decide which of my files, APIs, and credentials to interact with. Right now, the equivalent of `pip install` for MCP servers - `goose configure` and add the path or URL - has roughly the same security model as curling a bash script and piping to sudo.

The questions:

- Who signed this MCP server's release? Is the signature checkable? Is there a key transparency mechanism?
- What's the source-of-truth repo, and has the binary I'm running been built from the commit it claims?
- What dependencies did it pull in at build time? Where's the SBOM?
- If the server is remote, what's the attestation that the running instance matches the published source?

[Sigstore](https://sigstore.dev), [SLSA](https://slsa.dev), and [in-toto](https://in-toto.io) have made enormous progress on these questions for traditional artifacts. As far as I can tell, none of that has been threaded through the MCP ecosystem yet.

### Attestation for tool calls

When an agent calls a tool - `kubectl get pods`, or an MCP server's `read_file` - that call should ideally be attestable. We should be able to say, after the fact: this command was issued by this agent, in this session, under this user, with this set of arguments, and the model's stated reasoning was X.

We have most of the building blocks. Goose can already produce session logs. MCP servers can produce structured records of their tool invocations. What I haven't seen is a coherent attestation format that ties them together in a way that survives later audit.

This matters for the same reason audit logs matter for human admins: when something goes wrong in production, you want to be able to reconstruct who or what did it.

### The prompt as a build artifact

A working agent session is partly defined by its prompts - the system prompt, the user prompts, any retrieved context. From a supply chain view, the prompt is closer to source code than it is to configuration. It determines behavior. It should probably be versioned, reviewed, and signed.

I don't see any serious treatment of this yet for production agentic systems. Most prompt management tooling today is product-focused (analytics, A/B testing) rather than supply-chain-focused (provenance, review, audit). This one requires new conventions, not just new tooling applied to a new context.

### The model as a dependency

If my Goose session calls Anthropic's Claude, OpenAI's GPT, or a local Llama via Ollama, each of those is, in supply chain terms, a dependency. Different versions of the same model can behave meaningfully differently. Switching providers mid-session can produce different outputs from identical prompts.

We do not currently have anything resembling a version-pinned, attested model dependency in most real deployments. We have model names, sometimes with version suffixes, often without. That's not enough. Like the prompt question, this one requires new standards work -- there is no existing tooling to apply here.

## Why this matters now, not later

Two reasons.

**First, the agentic AI ecosystem is at a critical moment.** Goose and MCP are growing fast and being adopted by real teams. The standards we set now - or fail to set - are the ones that get baked in. We did this badly with npm and the JavaScript ecosystem in the 2010s, and we're still paying for it. We have a chance to not repeat that here, because the AAIF projects are open source, they're hosted at the Linux Foundation, and the audience that cares about supply chain security knows what good looks like.

**Second, agents make the consequences worse, not better.** A traditional pipeline executes deterministic code. An agent pipeline executes the output of natural-language reasoning conditioned on tool descriptions written by people you didn't vet. If your supply chain has gaps now, agentic AI will exploit them at machine speed.

## What I'd love to see

I'd love to see the AAIF community - Goose, MCP, AGENTS.md - start treating supply chain security as a first-class concern, not a "later" item. Specifically:

These aren't competing solutions -- they're a stack. [Sigstore](https://sigstore.dev) handles signing and key transparency. [in-toto](https://in-toto.io) attests the pipeline steps. [SLSA](https://slsa.dev) provides the level framework for what "attested" means at each stage. [CycloneDX](https://cyclonedx.org) provides the artifact inventory format. Used together, they give you the same supply chain posture for agentic workflows that mature CI/CD pipelines already have.

- An SBOM standard for MCP servers, with CycloneDX or SPDX format, generated at build time.
- Sigstore-style signing for MCP server releases, with a trust root the community can verify.
- in-toto attestation for agent tool invocations, with a structured format that integrates into existing supply chain tooling.
- A reference implementation of an "agentic supply chain" - Goose configured with attested MCP servers, producing signed session logs, integrated into an SLSA-style provenance chain.

Some of this exists in pieces, in adjacent ecosystems. None of it is wired together yet for agentic AI specifically.

I'm going to start prototyping some of this in upcoming posts. Pinning MCP servers to specific signed releases. Generating SBOMs for Goose configurations. Producing structured session attestations. The [next post]({{ '/2026/05/open-plugins-standard/' | relative_url }}) looks at the Open Plugins standard -- the first concrete attempt at a distribution spec for agent extensions -- and asks these same questions of a specific artifact.

If anyone is working on this already, please reach me - [about page]({{ '/about/' | relative_url }}) has my coordinates. If you're at AAIF and reading this, I'd love to talk about whether any of this is on the roadmap.

## A note on tone

I'm aware this post is more "raising questions" than "providing answers." That's deliberate. I've seen too many supply chain conversations get derailed because someone showed up with a half-built solution before the community had agreed on the problem. The point of this post is to put the problem on the table for the agentic AI community in the language platform-security people speak.

If we can agree the questions are worth taking seriously, the answers will follow.
