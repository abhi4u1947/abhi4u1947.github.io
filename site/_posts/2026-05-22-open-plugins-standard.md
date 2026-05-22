---
title: "What Open Plugins gets right, and what it still needs"
date: 2026-05-22
kicker: "Essay"
tags: [opinion, open-plugins, mcp, supply-chain, platform-engineering, goose]
description: "The Open Plugins standard takes a real swing at the agent extension distribution problem. Here is what it gets right - and the supply chain questions it still needs to answer."
---

Every MCP server I've added to my Goose setup has been its own small project. Some are a `git clone` and a config path. Some need `pip install` and the right virtual environment. A few are remote URLs I'm trusting based on the GitHub star count and a five-minute README scan. There is no standard shape, no standard install, no standard way to know what a server actually does before you've already run it.

[Open Plugins](https://open-plugins.com/agent-builders) is trying to fix that.

## The distribution problem

The agent tooling ecosystem has a packaging gap. We have [MCP](https://modelcontextprotocol.io) for the protocol, [AGENTS.md](https://agentsmd.org) for behavior declarations, and a growing catalog of Goose extensions - but no standard answer to the question: *how does a plugin get from the author's repo to a running agent, in a way that's reproducible, inspectable, and safe to do on a shared machine?*

That gap is what Open Plugins is addressing. The spec defines a convention-based system for discovering, packaging, installing, and namespacing agent extensions. It covers skills, commands, agents, hooks, MCP servers, and LSP servers - essentially everything that runs alongside an agent and extends its capabilities. The goal is that any conformant agent tool can install and run any conformant plugin, without custom integration work on either end.

## How the standard works

At its core, a plugin is a directory with a predictable layout. A plugin manifest lives at `.plugin/plugin.json` and declares the plugin name plus any non-standard component paths. The manifest is optional - if a plugin follows the directory conventions, a conformant tool can discover everything without it.

Component discovery uses these default paths:

- Skills: `/skills/*/SKILL.md`
- Commands: `/commands/*.md`
- Agents: `/agents/*.md`
- Hooks: `/hooks/hooks.json`
- MCP Servers: `/.mcp.json`
- LSP Servers: `/.lsp.json`

Installation copies the plugin to a local cache directory and adds it to the `enabledPlugins` list in the tool's settings. Plugins are expected to be self-contained - no external dependencies resolved at install time.

Path references inside the plugin use a `${PLUGIN_ROOT}` placeholder that expands to the plugin's absolute path after installation. Hook commands, MCP configs, and LSP settings all use this mechanism. It's the same problem npm solved with `__dirname`, and the Open Plugins answer is correct: lock the root at install, expand everywhere.

Namespacing uses a `pluginName:componentName` format. A `deploy-tools` plugin's `status` skill becomes `deploy-tools:status`. This prevents collisions when multiple plugins expose components with the same name.

The spec ships with a reference CLI: `npx plugin-ref validate ./my-plugin` checks conformance, `npx plugin-ref inspect` shows what a tool would discover. Shipping a validator alongside the spec is exactly the right call.

Specs without reference implementations drift.

## What it gets right

Convention over configuration is the right default here. The manifest is optional, and the directory conventions are simple enough that most plugin authors will follow them without thinking about it. Adoption requires zero friction for the common case; Open Plugins mostly delivers that.

The minimal conformance requirements also help. A conformant tool only needs to handle one component type; it doesn't have to implement the full spec to be useful. That's a pragmatic choice for a young ecosystem where adoption matters more than completeness.

The `${PLUGIN_ROOT}` expansion solves a real portability problem. Without it, plugins either hardcode absolute paths (breaks on any machine that isn't the author's) or use relative paths (breaks when the plugin gets copied to a cache directory). The expansion mechanism is clean, and the path traversal protection - `../` sequences that escape the plugin root are rejected - is the right boundary.

Namespacing is underrated. I've already had skill name collisions in my Goose setup. Having a canonical format for disambiguation is going to matter once there are hundreds of plugins in circulation.

## The security questions it still needs to answer

This is where I put my platform-security hat on, and where I want to be careful to separate "this is wrong" from "this is appropriate for where the ecosystem is, and here's what needs to happen next."

The current trust model is roughly: install the plugin, hooks and MCP commands run with your user-level permissions, and the recommended mitigations are advisory. That's not a critique of the spec authors - it's the same pragmatism that got npm to adoption in 2010. But it's worth naming the gaps precisely, because this is the point in the ecosystem's lifecycle where they're cheapest to fix.

The specific gaps I see:

**Hook execution at user level, with advisory mitigations.** A plugin's hooks run as the installing user. The spec recommends sandboxing, allowlisting, and user confirmation before enabling hooks - but these are implementation guidance, not conformance requirements. A tool that installs plugins and runs hooks with none of those controls is still conformant. The threat surface is roughly equivalent to `curl | bash`, and the spec treats it as a UX choice rather than a security boundary.

**No signing story.** Nothing in the current spec tells a conformant tool how to verify that a plugin came from who it claims to come from. A release could be tampered with between the author's repo and a user's machine, and a conformant tool has no way to detect it. This is the same gap npm had in 2012.

**No SBOM.** A plugin's `/.mcp.json` can reference a remote MCP server. That server has its own dependencies, its own update cadence, its own author. The "self-contained" requirement covers the plugin package itself, but the MCP servers it configures are effectively untracked transitive dependencies. There's no standard way to produce or consume a software bill of materials for a plugin.

**Path traversal protection as guidance, not requirement.** The spec says implementations *should* reject `../` sequences that escape the plugin root. I'd like to see this as a *must*. "Should" in a security control means "optional in practice."

I raised similar questions in my [supply chain post]({{ '/2026/05/supply-chain-questions-for-agents/' | relative_url }}) about the MCP ecosystem in general. Open Plugins makes those questions concrete. Here's the spec. Here are the specific places where the supply chain story is thin.

## Why the timing matters

The standard is early. That's the good news.

npm shipped without package signing in 2010. Sigstore-based provenance support arrived in 2023 -- thirteen years later -- and still isn't universally enforced. Thirteen years of retrofitting security into an ecosystem that had grown around the gaps. The JavaScript community is still paying for decisions made when npm was a side project.

Open Plugins is at the beginning of that curve. Open Plugins is not currently an AAIF project -- it is maintained by Vercel Labs -- but the AAIF community is exactly the right group to adopt and endorse these norms before the ecosystem grows around the absence of them. Goose, MCP, and AGENTS.md already have the Linux Foundation governance structure and the audience that cares about supply chain security. The tooling ([Sigstore](https://sigstore.dev), [in-toto](https://in-toto.io), [CycloneDX](https://cyclonedx.org)) exists. The question is whether the spec reaches for it before the install base gets large enough to make breaking changes painful.

## What I'd like to see

Concrete asks, in rough priority order:

- **Signing for plugin releases.** [Sigstore](https://sigstore.dev)-style, with a transparency log the community can verify. The `plugin-ref` CLI already validates structure; a `plugin-ref attest` subcommand that checks signatures would be a natural extension. Make signature verification a conformance requirement for enterprise-tier tools, advisory for community tools.
- **An SBOM requirement for plugins that reference external MCP servers.** [CycloneDX](https://cyclonedx.org) or SPDX format, generated at build time, included in the plugin package. Not optional for any plugin that ships a `/.mcp.json`.
- **A trust-level field in the manifest.** Something like `community`, `verified`, `enterprise` that conformant tools surface to users before installation. The details can be worked out - the point is that install should not be binary.
- **Path traversal as a conformance requirement, not a recommendation.**

None of these are blockers for adoption today. They're the difference between a standard that enterprises can reference in a security policy and one that stays in developer-only workflows.

I'm planning to prototype some of this - signing a plugin release, generating an SBOM for a Goose configuration. If you're working on any of it already, [reach out]({{ '/about/' | relative_url }}).

The standard is worth engaging with seriously. That's why I'm raising the gaps.
