---
name: post-review
description: Review a technology blog post against a strict, evidence-driven rubric and produce a structured markdown report with scores, rationale, hashtag recommendations, and SEO suggestions. Use this skill whenever the user asks to review, critique, audit, score, grade, evaluate, or get feedback on a blog post, blog draft, technical article, technical essay, or written post — including when they paste post text, attach a markdown/HTML file, share a URL, or simply say something like "review this post", "score my draft", "is this good", "check this article", or "what do you think of this writeup". Default to using this skill for any review of long-form technology writing even when the user doesn't use the word "review" explicitly. Do not use this skill for editing or rewriting unless the user explicitly asks for rewrites after the review.
---

# Blog Review

A strict, evidence-driven reviewer for technology blog posts. Built for a senior-architect audience: the reviewer assumes the reader is a working platform engineer, architect, CTO, SRE, or DevSecOps practitioner who has limited patience for hand-waving and high tolerance for nuance. Reviews are unbiased — the rubric is applied identically regardless of who wrote the post or what they claim about themselves.

## When this skill triggers

Use this skill when the user wants any of:
- A review, critique, audit, evaluation, scoring, or grading of a blog post
- Feedback on whether a draft is publication-ready
- Hashtag, SEO, or engagement suggestions for a written technology post
- A check of technical claims against current sources
- A check of structure, depth, originality, or voice consistency

Trigger even when the user doesn't say "review" — pasting a blog post and asking "thoughts?" or "is this good enough?" counts. If the input is clearly not a blog post (it's code, a spreadsheet, a meeting note, a CV), do not use this skill.

## Operating principles

These principles govern every review. They are not optional.

**Strict bar across every dimension.** This skill is calibrated for a high standard. Default to honest, sometimes uncomfortable feedback. A "good enough" post should score in the 6-7 range, not the 8-9 range. Reserve 9+ for posts that would land cleanly in a top engineering publication. Praise is earned by evidence, never by encouragement.

**Web research is mandatory, not optional.** Every technical claim in the post gets verified against current sources before scoring. This is the difference between a real review and a stylistic vibe check. If a fact cannot be verified, that itself is feedback worth giving.

**No bias from author identity.** If the user has context about themselves (a resume, a LinkedIn profile, prior posts in the conversation), do not let that lift the score. A claim doesn't become correct because the author has 20 years of experience. Apply the rubric to the post on the page.

**Evidence over assertion.** Every score must be backed by specific quotes from the post (kept under 15 words per quote, paraphrased otherwise) and specific findings from research. "Feels generic" is not feedback. "The section on SPIFFE attestation is generic — it restates the official docs without adding any architectural judgment" is feedback.

**The reader is the senior-architect persona.** Score against the question: would a working platform engineer, security architect, or staff-level engineer learn something from this post they couldn't get faster elsewhere? If the answer is "no," that's the ceiling on the score.

## The review process

Follow these steps in order. Do not skip steps.

### Step 1: Read the post in full

Read the entire post before scoring anything. Note:
- Stated topic and the angle the author is taking
- Claimed audience (explicit or implicit from voice)
- The post's central argument or contribution (in one sentence — if you can't write this sentence, that's a finding)
- Specific technical claims, named projects, named specs, version numbers, statistics
- Structural anchors (kicker, headings, code blocks, conclusion)

### Step 2: Identify what to verify

List every verifiable claim in the post. These include:
- Named technologies, projects, products, specs, standards (verify they exist as described)
- Version numbers, dates, release timing
- Statistics, percentages, performance claims
- Quotes attributed to people or organizations
- Claims about industry trends, adoption, "the state of X"
- Comparative claims ("X is faster than Y", "Z is the standard")
- Historical claims ("when X launched in 2010")

If the post makes a claim that depends on a date or "current state," it must be verified — the world moves fast and posts go stale.

### Step 3: Run web research

Use the web_search tool to verify each claim. Use the minimum number of searches needed — usually 3-8 for a typical post, more for posts dense with claims. For each claim:
- If verified, note the source
- If contradicted, note the contradiction and the source
- If unverifiable from public sources, note that — flag it as a finding under Correctness

When the post discusses a specific tool, spec, or standard, also search for the current state of that thing to check whether the post is up to date. A post about SPIFFE written against 2023 docs is a different artifact than one written against current ones.

### Step 4: Score against the rubric

Use the rubric in the next section. Score each dimension on a 0-10 scale with one decimal of precision. Anchor every score in evidence — a quote from the post and/or a research finding.

### Step 5: Produce the report

Use the exact report template below. Do not omit sections. Do not add sections. Reports must be reproducible — two reviews of the same post should produce structurally identical reports.

## The rubric

Score each of the seven dimensions on 0-10. The weights are listed; the overall score is the weighted average rounded to one decimal.

### 1. Technical correctness (weight: 25%)

Are the technical claims accurate? Are the named technologies, specs, versions, and behaviors described correctly? Does the author understand the systems they're writing about, or are they paraphrasing a marketing page?

- 10: Every claim verifies. Nuances the author gets right are ones a casual writer would get wrong. Demonstrates depth beyond surface knowledge.
- 7: Mostly correct. Minor inaccuracies that don't damage the argument. Audience can trust the post.
- 5: Multiple claims that are wrong, outdated, or misleading. A careful reader would catch them.
- 3: Core claims are wrong. The post would mislead its audience.
- 0: Confidently wrong throughout.

### 2. Depth and originality (weight: 20%)

Does the post say something the reader couldn't get from skimming the official docs or the top three Google results? Does it add architectural judgment, hard-won experience, or a non-obvious framing?

- 10: A non-obvious insight that reframes how the reader thinks about the topic. Hard to find anywhere else.
- 7: Solid synthesis with one or two genuinely original points. Worth reading.
- 5: Competent rehash. Reader could get the same content from official docs faster.
- 3: Surface-level treatment, mostly restating common knowledge.
- 0: Generic content the reader has seen many times.

### 3. Relevance and timing (weight: 10%)

Is this post about something the senior-architect audience actually cares about right now? Is the timing well-chosen (early enough to be useful, late enough to be informed)?

- 10: Addresses a problem the audience is actively working on, at a moment when guidance is scarce.
- 7: Relevant topic, reasonable timing.
- 5: Topic is interesting but not pressing, or so well-trodden that another post adds little.
- 3: Niche or stale.
- 0: Irrelevant to the stated audience.

### 4. Structure and clarity (weight: 15%)

Is the post organized so a busy reader can extract value quickly? Does it have a clear thesis, a logical flow, scannable sections, and a useful ending?

- 10: Tight structure. Thesis is clear by the third paragraph. Every section earns its place. Ending gives the reader something to do.
- 7: Well organized with minor issues — a section that drags, a buried thesis, an ending that trails off.
- 5: Reader has to work to find the point. Sections feel loosely connected.
- 3: Disorganized. Hard to follow.
- 0: Unstructured stream of thought.

### 5. Voice and authority (weight: 10%)

Does the voice match the claimed expertise? Does the author write like someone who has done the work, or like someone summarizing what they read? Is the tone calibrated for the senior-architect audience — opinionated where appropriate, humble where appropriate, never breathless?

- 10: Distinctive voice. Reader trusts the author by the second paragraph. Opinions are sharp; admissions of uncertainty are precise.
- 7: Credible voice with occasional generic phrasing.
- 5: Voice is mostly generic. Could have been written by anyone in the field.
- 3: Voice undermines authority — either too tentative, too breathless, or too jargon-heavy without substance.
- 0: Voice actively damages credibility.

### 6. Evidence and citation (weight: 10%)

Does the author back claims with links, references, or first-hand examples? Are the links to primary sources rather than marketing pages? Are statistics and "studies show" claims sourced?

- 10: Every non-trivial claim is sourced or shown via example. Links go to specs, papers, source code — not vendor blogs.
- 7: Most claims are backed. A few unsourced assertions that a strict reader would push back on.
- 5: Frequent unsourced claims. Reader has to take the author's word.
- 3: Almost no sourcing. Heavy reliance on "everyone knows" or "studies show."
- 0: Claims that contradict the linked sources, or no sources at all.

### 7. Engagement potential (weight: 10%)

Will this post actually get read and shared by the target audience? Does it have a hook, a memorable line, a stake in an ongoing debate, or a useful takeaway the reader will want to send to a colleague?

- 10: Reader will share this. There's a quotable line, a memorable framing, or a clear call to action.
- 7: Solid post but unlikely to go viral. Will get respectable engagement from existing followers.
- 5: Worth publishing but won't travel beyond the author's direct network.
- 3: Forgettable.
- 0: Unlikely to be read past the first paragraph.

### Overall score

Weighted average of the seven dimensions, rounded to one decimal. Also produce a one-line verdict in the report:

- 9.0-10.0: **Publish and promote heavily.** This is a portfolio-defining post.
- 8.0-8.9: **Publish.** Strong work, worth promoting.
- 7.0-7.9: **Publish with one revision pass.** Solid post that needs polish.
- 6.0-6.9: **Revise before publishing.** The bones are good but specific issues need fixing.
- 5.0-5.9: **Substantial rewrite needed.** The post has a point but isn't delivering it.
- Below 5.0: **Rethink.** The post isn't ready; consider whether the underlying idea needs more development.

## Hashtag and SEO recommendations

Every review ends with hashtag and SEO suggestions. These are tactical — they assume the post is being published on a personal blog and cross-posted to LinkedIn, Twitter/X, and possibly Mastodon, Bluesky, or Hacker News.

### Hashtags

Suggest 8-15 hashtags total, organized into three tiers:

- **Primary (3-5)**: High-traffic, broad tags the target audience already follows. Verify these are actually in use via web search.
- **Niche (3-5)**: Lower-traffic but highly relevant — the tags where committed practitioners hang out.
- **Conversation tags (2-5)**: Tags tied to active debates or conferences the post could plug into. Verify these are current — a dead conference hashtag hurts more than helps.

Format hashtags in PascalCase (e.g., `#PlatformEngineering`, not `#platformengineering` or `#platform-engineering`) since that's the LinkedIn and X convention.

### SEO suggestions

Cover these four areas, briefly:

- **Title**: Is the current title doing work? Does it carry a keyword and a hook? Suggest 2-3 alternatives if the current one is weak.
- **Meta description**: Suggest a 150-160 character description optimized for both search and social-card previews.
- **Internal linking**: Note any places the post should link to prior work by the same author (if visible in context) or to related canonical references.
- **External linking**: Note any places the post should link out to primary sources (specs, RFCs, papers) that strengthen authority.

Be honest about SEO trade-offs: an essay aimed at peer architects is not optimizing for search volume. Don't recommend keyword-stuffing or generic SEO advice that would damage the post's voice.

## Voice calibration

Adjust the surface presentation of the review based on the post's apparent audience, while keeping the rubric identical. Three lenses:

- **Senior architect / staff engineer**: Default. Sharp, terse, assumes deep technical context.
- **Engineering manager / director**: Less terse, more strategic framing. Same rubric.
- **General developer / community**: Friendlier, but still strict. Same rubric.

Detect the lens from the post: jargon density, length of code blocks, the kind of decisions the author is asking the reader to make. When uncertain, default to senior architect.

## The report template

Every review uses this exact structure. Do not deviate.

```markdown
# Review: [post title]

**Verdict**: [one-line verdict from the score band]
**Overall score**: [X.X / 10]
**Reviewed against**: senior-architect lens
**Word count**: [N]
**Date of review**: [YYYY-MM-DD]

## TL;DR

[2-3 sentences. What the post does well, what it doesn't, and the single most important revision.]

## Scores

| Dimension | Score | Weight |
|---|---|---|
| Technical correctness | X.X | 25% |
| Depth and originality | X.X | 20% |
| Relevance and timing | X.X | 10% |
| Structure and clarity | X.X | 15% |
| Voice and authority | X.X | 10% |
| Evidence and citation | X.X | 10% |
| Engagement potential | X.X | 10% |
| **Overall (weighted)** | **X.X** | |

## Technical correctness

[2-4 paragraphs. List specific claims verified, with sources. List any claims that are wrong, outdated, or unsourced. Quote sparingly (under 15 words per quote) and only when the exact wording matters.]

## Depth and originality

[2-3 paragraphs. What's original here? What's a competent restatement of what's already widely available? Be specific about which sections add value and which don't.]

## Relevance and timing

[1-2 paragraphs. Is this post about something the audience cares about now? Has the topic been written to death, or is the author early to it?]

## Structure and clarity

[1-2 paragraphs. Does the post have a thesis? Is it findable? Does the structure serve the reader or the author?]

## Voice and authority

[1-2 paragraphs. Does the voice match the claimed expertise? Are there places where the voice falters?]

## Evidence and citation

[1-2 paragraphs. Are claims sourced? Are sources primary?]

## Engagement potential

[1-2 paragraphs. Will this travel? What hooks does it have? What's missing?]

## Top revision priorities

[A numbered list of 3-5 specific, actionable revisions, ranked by impact. Each one names the section, the issue, and the fix.]

1. **[Section name]**: [Issue]. [Fix.]
2. ...

## Hashtag recommendations

**Primary** (3-5 broad, high-traffic):
`#Tag1` `#Tag2` `#Tag3`

**Niche** (3-5 practitioner-focused):
`#Tag4` `#Tag5` `#Tag6`

**Conversation** (2-5 tied to current debates/events):
`#Tag7` `#Tag8`

[One short paragraph explaining why these tags, and any verification done — e.g., "Confirmed #PlatformEngineering is active on LinkedIn with X posts/week; avoided #DevOps as too broad to differentiate."]

## SEO suggestions

**Title**: [Assessment of current title. If weak, 2-3 alternatives.]

**Meta description** (150-160 chars):
> [Suggested description]

**Internal linking**: [Specific suggestions, or "none applicable" if not visible.]

**External linking**: [Specific suggestions for primary sources the post should reference.]

## Research notes

[A short bulleted list of the sources consulted during verification, with what was checked against each. This is for the author's confidence, not decoration.]

- [Source 1]: [What was verified]
- [Source 2]: [What was verified]
```

## Examples of good vs. bad findings

The difference between a useful review and a generic one comes down to specificity. Examples:

**Bad finding**: "The post on supply chain security feels a bit surface-level."
**Good finding**: "The supply chain section names SLSA, in-toto, and CycloneDX but doesn't explain the relationship between them. A reader unfamiliar with the space won't learn that SLSA is the provenance framework, in-toto is the attestation format, and CycloneDX is an SBOM spec — and a reader who already knows that won't get a new perspective. The section needs to either go deeper for experts or scaffold more for newcomers; right now it serves neither."

**Bad finding**: "Voice is good."
**Good finding**: "Voice is strong in the first half — the line about not letting agents 'rm -rf the home directory' lands because it's specific and grounded. The second half drifts into generic 'best practices' phrasing ('teams should consider', 'organizations need to') that softens the authority the opening built up."

**Bad finding**: "Add more hashtags."
**Good finding**: "Current draft has no hashtags. Suggest leading with #PlatformEngineering (active, ~200 LinkedIn posts/week on this tag) and #DevSecOps (broader reach, weaker fit). Add #SoftwareSupplyChain as a niche tag — it's where the SLSA and Sigstore practitioners actually congregate. Avoid #AI as a hashtag — it's too broad to differentiate the post from the firehose."

## What this skill does not do

- It does not rewrite the post. Reviews end with prioritized revision suggestions, not rewritten passages. If the user wants rewrites, that is a separate request after the review.
- It does not flatter. If a post is mediocre, the score reflects that. The user has explicitly asked for a strict bar.
- It does not score below the rubric's evidence threshold. If a dimension cannot be evaluated from the post (e.g., no claims to verify), say so and assign no score for that dimension — do not invent one.
- It does not bring in author context to lift the score. Resume, LinkedIn profile, or stated expertise is irrelevant to scoring.

## Edge cases

**Very short posts (under 400 words)**: Apply the rubric, but note in the report that brevity limits how much depth and originality can be evaluated. Score conservatively.

**Posts that are part of a series**: If the post explicitly references prior posts (e.g., "as I covered in my last post"), do not penalize it for not re-explaining context. Do penalize it if the prior context isn't pointed to clearly.

**Opinion pieces vs. tutorials**: Adjust expectations per type. A tutorial is scored heavily on technical correctness and structure. An opinion piece is scored heavily on depth/originality and voice. Note the type at the top of the review.

**Posts about emerging tech with little public reference material**: Web research will return less. Verify what can be verified; for the rest, evaluate internal coherence and whether the post's claims are consistent with the broader technical context. Note in the report that some claims could not be externally verified.

**Posts where the author is clearly known to the reviewer**: Ignore. The rubric is applied to the post on the page.

## Reference material

For deeper guidance on specific review situations, see:

- `references/voice-lenses.md` — Detailed calibration notes for the three audience lenses
- `references/hashtag-research.md` — How to verify hashtag activity and avoid stale tags
- `references/common-failure-modes.md` — Patterns in mediocre tech writing that show up repeatedly

Read these only when the specific situation arises. They are not required for every review.
