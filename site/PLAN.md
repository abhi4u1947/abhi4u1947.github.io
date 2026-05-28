# Your 14-Day Plan: From Zero to AAIF Application

**Profile**: Abhishek Dadhich — Architect & Technology Leader (20 years), Pune. Focus: Goose / agentic AI. ~3–4 hours per day available.

## Your application is genuinely strong — here's why

Re-reading the AAIF "Who we're looking for" list with your full background:

- **Technical credibility** — 20 years, current Senior Solutions Architect in a Platform Engineering Group, hands-on with SLSA/SBOM/in-toto in production, "de facto SME on IAM strategy" per a former colleague's public recommendation
- **Community presence** — 1K LinkedIn followers, 500+ connections, 7 written recommendations from senior people. Modest but real. We'll add to this in 14 days.
- **Educational content creator** — **Two published LinkedIn articles from November 2024** (CNCF End User Reference Architecture; NIST Post-Quantum Cryptography). You are not "starting from zero." You have an 18-month track record of technical thought leadership; the blog extends it.
- **Interest in agentic AI** — Azure AI Fundamentals certification (June 2024), GenAI integration into SDLC at Amdocs (publicly documented), public LinkedIn headline includes "GenAI"
- **Clear communicator** — Recommendations specifically call out "North-Star vision and ability to communicate trends" (Nir Makmal) and "strategic guidance on Architecture" (Jean-François Lombardo)
- **Open source enthusiast** — moderate, but your platform engineering work is in the open-source-adjacent space (Kubernetes, Terraform, ArgoCD, OpenTelemetry, Crossplane all named in your skills)
- **AAIF project alignment** — Platform Engineering + DevSecOps + Supply Chain Security is *exactly* the angle the AAIF community needs strengthened

You don't have to compete with developer-influencers on follower count. You compete on a specific, hard-to-imitate combination: senior architect + supply chain expertise + already-publishing track record.

---

## The honest narrative for your application

Most first-cohort applicants will be one of two profiles:
1. Developer with thousands of Twitter followers and a few demo posts
2. Open source contributor with PRs but no audience

You are a third profile: **senior architect with deep enterprise platform experience, an established publishing habit, and the exact kind of perspective (supply chain, IAM, platform engineering) the AAIF community is currently missing.**

That's the story to tell.

---

## Week 1: Make it real

### Day 1 — Setup (3 hours)

- [ ] Unzip the site, edit `_config.yml`: replace YOURUSERNAME/YOURHANDLE with your real GitHub handle and Twitter handle. (LinkedIn already correct as `dadhichabhishek`.)
- [ ] Create GitHub repo `<yourusername>.github.io` (public), push the site, enable Pages
- [ ] Verify site loads at `https://<yourusername>.github.io`
- [ ] Install Goose locally. [Docs](https://goose-docs.ai/). CLI will probably feel more natural to you.
- [ ] Configure Goose with an LLM
- [ ] Join [AAIF Discord](https://discord.com/invite/9zTwngHAMy). Lurk #goose, #mcp, and any platform/security channels.
- [ ] Read `about.md` and verify every detail is accurate. Adjust anything stale or that you'd phrase differently.

**End-of-day check**: site live, Goose running, Discord joined.

### Day 2 — Use Goose for real (4 hours)

**Do not skip. The posts only work if they're based on real sessions.**

Best fits for your background:

1. **Kubernetes triage with read-only RBAC** (matches post 2): deploy a deliberately broken service to a kind/k3d cluster, configure scoped access, run the triage
2. **MCP server inspection** (informs post 3): install an MCP server, dig into its source, dependencies, what it actually does — this gives you real material for the supply chain post

Do #1 fully (90+ minutes). Do a smaller version of #2 (45 minutes) for authenticity on post 3.

Take detailed notes — commands, outputs, surprises. These become the posts.

### Day 3 — Write post 1 + launch (3 hours)

- Read `_posts/2026-05-01-architect-notes-on-agentic-ai.md` as a stranger. Edit until it sounds like you. Push.
- **LinkedIn post** announcing it. This is your strongest channel — 1K followers, history of technical articles. Suggested:
  > "Starting to write at long-form on agentic AI — a topic I've been working with since integrating OpenAI into SDLC workflows at Amdocs in 2023. Specifically focusing on how platform engineering, DevSecOps, and supply chain security thinking applies to projects like Goose and MCP. First post here: [link]"
- Cross-post the article preview / link as a LinkedIn article too, with canonical pointing to your blog
- AAIF Discord #showcase: one line and the link

### Day 4 — Goose PR + Discord engagement (3 hours)

- Find a docs gap, typo, or "good first issue" on [github.com/aaif-goose/goose](https://github.com/aaif-goose/goose). Open a PR.
- Post one substantive observation in AAIF Discord #goose from Day 2's session
- Connect on LinkedIn with at least three people from the AAIF/Goose community. Don't pitch — just connect with a brief, specific note ("Enjoyed your talk on X, am exploring the same area")

### Day 5 — Write post 2 (4 hours)

Replace `_posts/2026-05-08-scoping-goose-for-ops.md` with your actual Day 2 session. Keep the structure (TL;DR, configs first, threat model, session, lessons) but use *your* RBAC config, *your* prompts, *your* findings.

Target 2000–2500 words. Push.

Cross-post to dev.to and LinkedIn (full article on LinkedIn — your audience there will engage with this).

### Day 6 — Engagement (2 hours)

Respond to comments. Help newcomers in AAIF Discord. Reach out personally to one or two people who reacted to your LinkedIn post.

### Day 7 — Buffer (variable)

Catch up if behind. Otherwise draft post 3.

---

## Week 2: Sharpen and ship

### Day 8 — Write post 3 (4 hours)

Edit `_posts/2026-05-15-supply-chain-questions-for-agents.md`. This is your most distinctive post. Your professional credibility in supply chain (SLSA, SBOM, in-toto, sigstore — all in your skills list, all current) means this post can be sharp and authoritative.

Target 1500–2000 words. Push.

**LinkedIn post on this one will likely outperform the others.** Tag relevant people if appropriate (CNCF supply chain WG folks, sigstore community).

### Day 9 — Companion repo (3 hours)

Create public GitHub repo. Best fits for your background:

- `goose-safe-scoping` — RBAC configs, kubeconfig templates, IAM policies for production-adjacent Goose deployment
- `mcp-supply-chain-checklist` — structured questions/criteria for evaluating MCP servers from a supply chain perspective. Goes directly with post 3.
- `goose-platform-patterns` — patterns for integrating Goose into Internal Developer Platforms

The second is most uniquely yours. Even a basic v0.1 README-only repo with structured thinking is valuable — it shows you're moving from "writing about it" to "building artifacts around it."

### Day 10 — Outreach + events (3 hours)

- LinkedIn connection requests with brief notes: Bradley Axen (Goose maintainer at Block), Angie Jones (Block), AAIF leadership team
- **MCP Dev Summit Bengaluru, June 9–10** — Pune to Bengaluru is doable. If you can attend in person, do. If not, register and engage online. This event is days before the application review window for the June cohort.
- Re-publish post 3 as a full LinkedIn article. Use the platform you already have.

### Day 11 — Application draft (3 hours)

Application form: [forms.gle/UPjnopVhACiTa8my7](https://forms.gle/UPjnopVhACiTa8my7). Screenshot every question, draft answers in a doc, refine.

For "examples of content":
1. Post 1 — Architect intro
2. Post 2 — Scoping tutorial (your strongest)
3. Post 3 — Supply chain essay (uniquely yours)
4. **LinkedIn article: Unlocking the Cloud-Native (Nov 2024)** — this is real evidence of pre-existing publishing
5. **LinkedIn article: NIST Post-Quantum Cryptography (Nov 2024)** — same
6. Your companion repo
7. Your Goose PR
8. Your LinkedIn post launching the blog

That's 8 dated, real links. Most first-cohort applicants will have fewer.

### Day 12 — Refine (2 hours)

Re-read with fresh eyes. Cut anything generic. Get a second pair of eyes — a colleague who knows your work, or a careful AI review.

Ship one extra thing if possible: a 5–10 minute Loom or YouTube walkthrough of your Day 2 Goose session. Even unlisted, the link is what matters.

### Day 13 — Submit (1 hour)

Submit. LinkedIn post:
> "Just applied to the AAIF Ambassador program. Excited about contributing to the platform engineering and supply chain security conversation around agentic AI."

### Day 14 — Plan beyond (2 hours)

Whether accepted or not, the cadence continues. List the next 10 post ideas. Calendar them.

---

## Application answers — using YOUR background

### "Tell us about yourself"

> I'm a Cloud, Platform & Security Architect with 20 years of experience designing and evolving large-scale, business-critical systems. Currently Senior Solutions Architect in the Platform Engineering Group at Netcracker, where I lead initiatives to deliver core platform capabilities as internal SaaS to 10+ customer accounts and 10 product teams. My recent work has focused on software supply chain security in production SDLC pipelines — adopting SLSA provenance, in-toto attestation, and CycloneDX SBOMs. Previously at Amdocs, I integrated OpenAI's GenAI into developer workflows and led enterprise-wide OpenTelemetry adoption. Based in Pune, India.

### "Why do you want to be an AAIF Ambassador?"

> The current conversation around agentic AI is dominated by app developers and AI researchers. What's largely missing is the platform and security architect's perspective — how do these tools integrate into enterprise platforms, what guardrails actually matter, and how do we apply software supply chain security thinking (SLSA, SBOMs, attestation) to MCP servers and agent workflows? I see Goose, MCP, and AGENTS.md as exactly the kind of open, standards-driven projects that need this perspective baked in early, before the patterns get set. I've been publishing thought leadership on adjacent topics (CNCF, post-quantum cryptography) on LinkedIn since 2024, and I want to bring that same lens to the AAIF community at a moment where the standards are still being shaped.

### "Examples of content you've created about agentic AI"

> Recent (May 2026), specifically on agentic AI:
> - [Post 1 link] — A platform architect's notes on agentic AI
> - [Post 2 link] — Scoping Goose for production-adjacent ops work
> - [Post 3 link] — The supply chain questions nobody is asking about MCP yet
> - [Companion repo link]
> - [Goose PR link]
>
> Earlier publishing on adjacent topics (November 2024):
> - Unlocking the Cloud-Native: CNCF's End User Reference Architecture
> - The National Institute of Standards: NIST Post-Quantum Cryptography
>
> I started writing on agentic AI specifically in May 2026, building on 18+ months of prior technical publishing in cloud-native and security adjacents.

### "Monthly contribution plan"

> **Month 1**: A two-part tutorial series on integrating Goose into an Internal Developer Platform — workload identity patterns, scoped RBAC templates, and the IAM model needed to deploy agents safely in shared platform environments.
>
> **Month 2**: A reference implementation and accompanying writeup of SBOM generation for MCP server configurations — bringing CycloneDX-style provenance into the agentic workflow. Public repo + blog post.
>
> **Month 3**: A talk submission for a platform engineering or DevSecOps meetup/conference — "Agentic AI from the Architect's Seat: What Platform Teams Need to Build Before Goose Hits Production." Recorded talk + companion blog post.

---

## Priority order if you fall behind

1. **Post 2 (scoping tutorial)** — must ship. Centerpiece.
2. **Post 1 (architect intro)** — must ship.
3. **LinkedIn posts referencing all of the above** — your strongest channel; do not skip.
4. **Goose PR or companion repo** — at least one must exist.
5. **Post 3 (supply chain essay)** — strongly preferred. Your most unique angle.
6. **Discord presence** — nice to have.

Even if you only ship 1–3, you have a credible application — *especially* because your two LinkedIn articles from November 2024 give you a real publishing track record that most first-cohort applicants won't have. Don't undersell that in the application.
