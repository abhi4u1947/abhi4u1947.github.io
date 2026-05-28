# Content strategy

Read this before planning or writing any post. It covers what the site
is, who reads it, the active content threads, and depth conventions per
register.

---

## What this site is

A practitioner blog written by a Cloud, Platform & Security Architect
with twenty years of experience. The specific lens: applying proven
platform-security fundamentals - workload identity, supply chain
security, zero-trust, audit - to the emerging agentic AI ecosystem,
specifically the AAIF/Goose/MCP stack. Posts come from real hands-on
work and name the things that are missing or broken. Not a predictions
blog. Not a tutorial farm.

---

## Active content threads

| Thread | What it covers | Typical register | Depth convention |
|--------|---------------|-----------------|-----------------|
| **Agentic AI platforms** | Goose configuration, MCP integration, agent scoping for real ops workflows | Tutorial + Essay | Show the actual config; explain the threat model before the demo |
| **Software supply chain for agents** | SLSA, sigstore, in-toto, SBOMs applied to MCP servers, agent binaries, session logs | Essay / Analysis | Raise the question precisely; name the specific gaps; compare to how supply chain was solved elsewhere |
| **Workload identity for agents** | SPIFFE/SPIRE, session identity, credential scoping, audit trail for agent tool calls | Essay + Tutorial | Sketch the architectural pattern first; prototype in a follow-up |
| **Platform security fundamentals** | RBAC, threat models, zero-trust applied to developer tooling and agentic workflows | Tutorial + Notes | Real configs and exit codes; no hand-waving |
| **Ecosystem standards critique** | Open Plugins, MCP spec evolution, CNCF working groups - what's right and what's missing | Essay / Critique | Engage the spec concretely; separate "wrong" from "early and needs to grow" |

Posts written to date and which thread they belong to:

- `2026-05-01-architect-notes-on-agentic-ai.md` - Agentic AI platforms (Notes)
- `2026-05-08-scoping-goose-for-ops.md` - Agentic AI platforms / Platform security (Tutorial)
- `2026-05-15-supply-chain-questions-for-agents.md` - Software supply chain (Essay)
- `2026-05-22-open-plugins-standard.md` - Ecosystem standards critique (Essay)
- `2026-05-25-spiffe-for-agent-identity.md` - Workload identity (Essay)

---

## Audience assumptions

**Take as given - no explanation needed:**

- Kubernetes: pods, namespaces, RBAC, service accounts, kubeconfig, `kubectl`
- IAM patterns: roles, least-privilege, short-lived credentials, assume-role
- Git-based workflows: GitOps, PRs, CI/CD pipeline stages
- Basic supply chain vocabulary: SBOM, provenance, attestation, signing
- Docker and container basics

**Explain even if familiar to some readers:**

- SPIFFE/SPIRE internals (most k8s practitioners have not wired it)
- in-toto link metadata format (less widely known than Sigstore)
- SLSA level framework (platform engineers know the name; most don't
  know the Build Track / level structure)
- MCP protocol specifics (growing but not yet universal)
- AGENTS.md convention
- Open Plugins standard (new; not yet widely adopted)

**What this audience is skeptical of:**

- Hype without a threat model
- "Just add AI to it" solutions
- Tools that work in demos but not in production
- Posts that don't name what can go wrong

---

## Citation conventions

- Every named external project, tool, standard, or organization gets
  an inline markdown link at first mention. No exceptions.
- Link to primary sources: project website, official docs, GitHub repo.
  Not blog posts about the tool, not vendor landing pages.
- Supply-chain tools (SLSA, in-toto, Sigstore, CycloneDX) always get
  links - the supply-chain audience will click through; the
  agent/platform audience may not know them yet.
- When a group of tools appears as a set of asks or recommendations,
  add a relationship sentence before the list: are they a layered
  stack, independent alternatives, or ordered by priority? One
  sentence prevents the list from reading as auto-generated.
- Canonical URLs for common ecosystem references are in
  `post-writer/SKILL.md` under "Citation and links."

---

## Depth conventions per register

**Tutorial (~1200 words):** Must include real configs, real commands,
real output or a session transcript. The procedure should be
reproducible. What was learned goes at the end as bolded-claim bullets.
No hand-waving ("you could also use X" without showing X).

**Essay (~1300 words):** Argues one claim. Opens with a vantage point.
Has 4-6 sections with named headings. Ends with a forward-pointer or a
single-line landing. Does not try to be a comprehensive survey. The
post's most original insight - the synthesis that only this author
could make - must be developed with a concrete example or a "why not
just that" explanation. A non-obvious claim left as a single sentence
is the most common reason an essay scores below 8 on depth.

**Notes (~800 words):** Catalogues observations or open questions.
Looser structure. Can end without a resolution - the open question is
the point.

---

## What this site doesn't write

- "The future of AI" prediction essays
- Tool comparisons without hands-on use
- Posts that primarily summarize someone else's docs
- Anything that could be titled "Getting Started with X"
