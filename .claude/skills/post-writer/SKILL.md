---
name: post-writer
description: End-to-end blog post authoring for site/_posts/ - voice calibration, drafting, humanization, and forensic Unicode scrub. Invoke whenever creating or editing any file under site/_posts/.
allowed-tools: Read, Edit, Write
---

# post-writer

Use this skill whenever you create or edit a post under
[site/_posts/](../../../site/_posts/). It covers the full lifecycle:
calibrating to the author's voice, structuring the post, drafting the
prose, and scrubbing the typographic and linguistic fingerprints that
give LLM writing away.

The author is a Cloud, Platform & Security Architect with twenty years
of experience. The site's audience is platform engineers, SREs,
DevSecOps people, and architects. Posts are technical, opinionated, and
written in the first person. Voice preservation is the single most
important constraint - don't make the prose slick, don't make it
generic, don't make it slangy. When in doubt, do less.

---

## Phase 0 - Calibrate to the author's voice

**Before you write anything**, read at least one published post in full:

- [site/_posts/2026-05-01-architect-notes-on-agentic-ai.md](../../../site/_posts/2026-05-01-architect-notes-on-agentic-ai.md) - "notes" / opinion register
- [site/_posts/2026-05-08-scoping-goose-for-ops.md](../../../site/_posts/2026-05-08-scoping-goose-for-ops.md) - tutorial / walkthrough register
- [site/_posts/2026-05-15-supply-chain-questions-for-agents.md](../../../site/_posts/2026-05-15-supply-chain-questions-for-agents.md) - essay / argument register

Also read [.claude/content-strategy.md](../../../.claude/content-strategy.md)
- it maps the active content threads, depth conventions, and audience
assumptions for this site.

These are the calibration samples. Your draft should sound like it
belongs next to them on the same site. If the user gives you a topic
and no register, default to the one that fits the topic - tutorials
get the goose-ops shape, opinion pieces get the architect-notes shape,
essays get the supply-chain shape.

Voice traits to preserve:

- **First person, plain register.** "I spent a year designing X" - not
  "In my experience, designing X involves Y."
- **Specifics over abstractions.** Real cluster names, real exit codes,
  real minute counts ("about 12 minutes", "90 seconds"). Numbers are
  load-bearing; do not round them to "a few" if the original said
  three.
- **Confident but not certain.** "I mostly don't, yet" / "as far as I
  can tell" / "I'd estimate" - the author hedges where they should and
  doesn't where they shouldn't.
- **Short asides.** Standalone short paragraphs, sometimes one
  sentence, used to land a point. ("So this site." / "Onward." / "Two
  reasons.")
- **Architect framing.** Posts almost always name a vantage point in
  the opening - "from a platform architect's seat", "I'm an architect.
  That question is the entire interesting part for me." Don't skip
  this if the topic invites it.
- **Bold-led summary lines.** Inside lists or in conclusions:
  `**The read-only boundary is the whole game.** Not because...`. Use
  these where a list item is a claim plus an explanation, not a
  definition.

Voice traits to *avoid*:

- AI-style transitions (`Additionally`, `Furthermore`, `Moreover`, `In
  conclusion`, `Overall,`, `That said,`, `It is important to note`).
  Full list in Phase 4.
- Marketing verbs (`leverage`, `utilize`, `streamline`, `seamless`).
- Five-paragraphs-in-a-row of the same word count. Read your draft
  and check.
- Hedging that sounds insecure ("I'm not sure but maybe..."). The
  author hedges with precision, not with apology.

---

## Phase 1 - Plan the post

Before drafting, decide:

1. **Register.** Notes / tutorial / essay. This determines length
   (notes ~800 words, tutorial ~1200, essay ~1300) and shape.
2. **The vantage point.** What's the one-sentence framing that says
   *why this post is from this author and not someone else*? Write it
   down before you draft.
3. **The thing the post argues or shows.** A tutorial shows a
   procedure and what was learned from running it. An essay argues a
   claim. Notes catalogue questions or observations. Pick one.
4. **The sections.** Three to six `##` headings. Each heading is
   sentence-cased, no terminal punctuation, and names the section's
   work in the author's voice (`What I'm planning to write`, not
   `Future Plans`; `The threat model I'm working from`, not
   `Threat Model`).
5. **The sign-off.** Almost every post ends with a short forward-look
   ("Next post will be...") or a single-line landing ("Onward.",
   "If we can agree the questions are worth taking seriously, the
   answers will follow.") Pick which.

Write a one-line outline before you draft. If the user is dictating
the outline, follow it.

---

## Phase 2 - Frontmatter

Every post requires this structure:

```yaml
---
title: "Sentence-style title in quotes"
date: YYYY-MM-DD
kicker: "Welcome | Tutorial | Essay | Notes | (one word)"
tags: [lowercase, hyphenated, list]
description: "One-sentence SEO meta description, written like a teaser, not a summary."
---
```

Notes on each field:

- `title` is sentence-cased, with quotes only because YAML needs them
  when the value contains a colon or starts with a non-alphanumeric.
  Examples in the corpus: `"A platform architect's notes on agentic AI"`,
  `"Scoping Goose for production-adjacent ops work"`,
  `"The supply chain questions nobody is asking about MCP yet"`.
- `date` is the planned publish date, not the file creation date.
  Match it to the filename's `YYYY-MM-DD` prefix.
- `kicker` is the single word shown above the title in the rendered
  hero. Keep it to one word in most cases.
- `tags` are lowercase, hyphenated, no `#` prefix, no spaces. 3-6
  tags per post.
- `description` is one sentence, written like a teaser line on a
  newsletter, not a summary of the post. It should make a reader want
  to click. Do not put curly quotes in it.

The post body uses `layout: post` *implicitly* - Jekyll's
`_config.yml` sets it as the default for `_posts/`. You don't need to
declare it.

---

## Phase 3 - Draft the body

### Opening paragraph

The opening paragraph gets a drop cap automatically (CSS rule in
[site/assets/css/main.scss](../../../site/assets/css/main.scss)). It
should:

- Be 2-4 sentences.
- Establish the author's vantage point or the thing they've been
  doing.
- *Not* announce the topic ("In this post we will..."). Show, don't
  declare.

Good openings from the corpus:

> I've spent twenty years designing and evolving large-scale,
> business-critical systems. Mostly platform engineering, DevSecOps,
> IAM, and lately software supply chain security.

> There's a pattern I keep seeing in tutorials for [Goose]: the
> author installs it, gives it their default kubeconfig or shell, and
> runs a demo.

### Paragraph rhythm

Mix paragraph lengths deliberately. A long paragraph (5-7 sentences)
followed by a one-sentence paragraph is the signature beat. Don't
write five paragraphs in a row at the same length. After drafting,
read each paragraph's word count and break the run.

**Develop the original insight.** After drafting, identify the post's
most non-obvious claim - the synthesis that only this author would
make, the architectural pattern that hasn't been written up elsewhere,
the specific gap no one else has named. That claim needs at least one
of:

- A concrete example: a real command, a real log line, a real
  consequence ("when Goose calls `kubectl exec` through an MCP server,
  the audit log records my user identity - not the agent's")
- An explanation of *why*, not just *that* ("V8 doesn't read cgroup
  boundaries - that's why the OOM killer fires before GC gets
  aggressive")
- A brief sketch of what it means for the reader's own systems

If the post's best insight is a single sentence with no grounding,
expand it before the humanization pass. A non-obvious claim left
unexplained is the most common reason an essay scores below 8 on
depth.

### Sentence rhythm

Vary sentence length. One short sentence (under 8 words) per ~5
paragraphs reads as human. The author often closes a paragraph with a
short sentence: "Plan for it." / "RBAC enforces this whether the
agent agrees with it or not. That's the property I want." Use it
sparingly; overusing it makes the prose feel performative.

### Lists and bolds

Use markdown lists for genuinely list-shaped content. The corpus uses
two patterns:

1. **Numbered lists** for sequences of actions taken or questions
   asked. Each item starts with a verb or a noun, no period at the
   end if the item is a fragment.
2. **Bolded-claim bullets** when each item is a claim plus a short
   explanation:
   ```
   **The read-only boundary is the whole game.** Not because I expect
   Goose to act maliciously, but because the moment...
   ```
   This is the most distinctive list shape on the site. Use it in
   "what I learned" or "checklist" sections.

**List of questions or gaps (essay pattern).** When the post presents
a list of open questions or identified gaps, add a framing sentence
before the list that tells the reader how to read it:

- Which items are solvable today with existing tooling, and which
  require new standards work? Say so.
- Are the items in the list a layered stack or independent
  alternatives? Say so.
- Are they ordered by priority or urgency? Say so.

Without framing, a flat list of four questions reads as auto-generated
and forces the reader to work out the structure themselves. One
sentence before the list solves this:

> Some of these are solvable today with existing tooling; others
> require new conventions that don't exist yet.

### Blockquotes

Use blockquotes (`>`) for a single sharp claim that earns its own
visual weight. One per post is plenty. Two is the maximum. Examples
from the corpus:

> A local agent with a real shell, real filesystem access, and a
> growing stack of MCP integrations - that can be pointed at
> production-adjacent infrastructure and asked to do real work.

> **TL;DR**: Before letting Goose touch anything real, scope its
> access through a dedicated service account...

### Code blocks

Always fenced, always with a language tag:
```` ```yaml ````, ```` ```bash ````, ```` ```python ````,
```` ``` ```` (no tag) for plain transcripts.

Inside code blocks, use real values. If the post is a tutorial, the
code should be the actual code that ran, not a sanitized template.
If secrets need redaction, redact them with obvious placeholders
(`<your-cluster-name>`) and call out the redaction in prose.

### Links

Inline markdown links, no reference-style. Link to the canonical
source (GitHub repo, foundation page, official docs). Internal site
links use relative paths: `[about page](/about/)`. Do not include
`utm_*` parameters.

### Citation and links

**Every named external project, tool, standard, or organization gets
an inline link at first mention.** The target audience is skeptical;
they will click through to verify. Make it easy.

Canonical URLs for the ecosystem this site covers most:

| Tool / Project | Canonical URL |
|---|---|
| Goose | `https://github.com/aaif-goose/goose` |
| AAIF | `https://aaif.io` |
| MCP | `https://modelcontextprotocol.io` |
| AGENTS.md | `https://agentsmd.org` |
| Open Plugins | `https://open-plugins.com` |
| SLSA | `https://slsa.dev` |
| in-toto | `https://in-toto.io` |
| Sigstore | `https://sigstore.dev` |
| CycloneDX | `https://cyclonedx.org` |
| SPIFFE | `https://spiffe.io` |
| SPIRE | `https://spiffe.io/docs/latest/spire-about/` |
| Kubernetes RBAC docs | `https://kubernetes.io/docs/reference/access-authn-authz/rbac/` |

**Description rule.** If a tool appears in content-strategy.md under
"Explain even if familiar," add a one-sentence parenthetical at first
mention. Example:

> ...attestation with [in-toto](https://in-toto.io) - a CNCF
> framework for recording who did what at each pipeline step...

Tools the audience takes as given (Kubernetes, Docker, Git) need a
link but no description.

**List relationship rule.** When four or more tools appear together as
a set of asks or recommendations, add a framing sentence before the
list that explains how they relate - stack vs. alternatives, near-term
vs. long-term, etc. A flat list of four tools without a relationship
sentence reads as auto-generated and leaves the reader to work out the
architecture themselves. Example from the supply chain essay:

> These aren't competing solutions - they're a stack. Sigstore handles
> signing. in-toto attests the pipeline steps. SLSA provides the level
> framework. CycloneDX provides the artifact inventory format.

### Pre-publish fact-check

Before finalizing the draft, verify each of these claim categories.
If a claim cannot be confirmed from a public primary source, leave a
`TODO: verify [claim]` inline rather than asserting it confidently.

- **Named versions and defaults** (e.g., "default TTL is 1 hour",
  "V8 allocates 1.7Gi on 64-bit") - check current docs; version
  behavior changes and figures go stale fast.
- **Organizational affiliations** (e.g., "X is maintained by Y",
  "X is an AAIF project") - check the project's repo or website;
  projects move between foundations.
- **Active working groups or community bodies** (e.g., "TAG Security
  is working on this") - verify the group is still active; groups get
  archived without announcement.
- **Dates in timelines** (e.g., "npm added signing in 2021") - look
  it up; approximate years are commonly off by one or two.
- **Statistics and performance claims** - find a primary source (a
  spec, a benchmark, official docs) or leave a TODO.

### Sign-off

Every post ends with one of two shapes - pick one, don't use both:

1. **Single-line landing**: `Onward.` / one short claim that closes
   the argument. Cleaner when the post is self-contained.
2. **Forward-look with re-anchor**: Close by naming what the reader
   gained from *this* post, then gesture at what comes next. Example:
   > If the perspective here - agents as workloads, not assistants -
   > is one you haven't seen framed this way before, that's the
   > thread. Next: how I scoped Goose for real ops work.

**Do not undersell the current post.** A closing like "next post will
be a real one" implies the current post was a warmup - it wasn't.
Re-anchor the reader in what they learned before pointing forward.

### Series linkback

Before finalizing, check the published posts list in
`content-strategy.md`. If any published post:

- Established the framing or context this post builds on - add a
  back-link woven into a sentence: "For the kind of work I described
  in my [scoping post](...)" or "As I argued in [the supply chain
  essay](...)..."
- Will be the natural next post the reader turns to - add a
  forward-link at a natural transition point in the text.

Links should add meaning in context, not appear as "see also" at the
end. The series tells a coherent story; individual posts should read
as chapters, not standalone documents.

---

## Phase 4 - Humanization pass

After the draft is written, review against this checklist. Each item
names the pattern and the recast rule. Do not run global replacements;
read the surrounding sentence first.

### Mechanical transitions

These almost always either delete cleanly or replace with a comma or
period. They are the strongest linguistic LLM tells.

- `Additionally` -> drop, or use `Also`
- `Furthermore` -> drop
- `Moreover` -> drop
- `However` (sentence-initial) -> often drop or move; `But` works
- `Overall,` -> drop
- `In conclusion` -> drop and let the conclusion stand on its own
- `That said,` -> drop, or replace with `Still,`
- `It is important to note (that)` -> drop entirely; the next clause
  is the point
- `It's worth noting (that)` -> drop entirely
- `In today's (fast-paced/world/landscape)` -> rewrite the sentence;
  this is pure cliche

### Generic corporate verbs and marketing adjectives

Replace with the plainer word the author would type into chat:

- `leverage` -> `use`
- `utilize` -> `use`
- `streamline` -> `simplify`, or just cut
- `optimize` -> often just cut
- `robust` -> usually cut; `solid` or `working` if needed
- `seamless` / `seamlessly` -> usually cut
- `ensure that` -> `ensure`
- `delve into` -> `look at` or `dig into`
- `tapestry` -> never; rephrase
- `navigate the (complexities of)` -> rewrite plainly
- `crucial` -> `important`, or cut

### Structural tells

Read the draft for these:

1. **Repetitive sentence openings.** First three words of every
   paragraph in a row. Two adjacent paragraphs both starting with
   `The...` or `When...` - recast one.
2. **Paragraph rhythm.** Five paragraphs in a row within +/- 15% of
   the same word count - break one in half or merge it with the
   next.
3. **Over-explaining.** Cut lines that recap what the previous
   paragraph just said.
4. **Symmetric list items.** If every item in a list is the same
   length and shape, it reads as auto-generated. Vary length; vary
   whether items are fragments or sentences.

---

## Phase 5 - Forensic Unicode scrub

LLMs and rich-text editors leak typographic codepoints that no one
types from a keyboard. Find them and replace them.

Search the file for any of these codepoints:

```bash
grep -nP '[\x{2013}\x{2014}\x{2018}\x{2019}\x{201C}\x{201D}\x{2026}\x{00A0}\x{202F}\x{2009}\x{200A}\x{200B}\x{200C}\x{200D}\x{FEFF}\x{00AD}\x{2032}\x{2033}\x{2212}\x{2022}\x{00B7}]' site/_posts/<file>.md
```

For each match, Edit the file with the replacement from this table.
Frontmatter and fenced code blocks are in scope - a padded em dash
inside a multi-line system-prompt block is the same artifact as one
in prose.

| Codepoint | Glyph | Replacement | Why it's flagged |
|---|---|---|---|
| U+2014 | em dash | ` - ` (space, hyphen, space) | The single strongest LLM-polish fingerprint. |
| U+2013 | en dash | `-` | Typographic range marker. |
| U+2212 | math minus | `-` | Same family. |
| U+2018 | left curly single quote | `'` | Smart-quote autocorrect. |
| U+2019 | right curly single quote / apostrophe | `'` | Same. |
| U+201C | left curly double quote | `"` | Same. |
| U+201D | right curly double quote | `"` | Same. |
| U+2032 | prime | `'` | Typographic. |
| U+2033 | double prime | `"` | Same. |
| U+2026 | horizontal ellipsis | `...` | Autocorrected from three dots. |
| U+00A0 | non-breaking space | regular space | Copy-paste from web editors. |
| U+202F | narrow no-break space | regular space | Same. |
| U+2009 | thin space | regular space | Same. |
| U+200A | hair space | regular space | Same. |
| U+200B | zero-width space | strip | Invisible junk; prompt-injection vector. |
| U+200C | zero-width non-joiner | strip | Same. |
| U+200D | zero-width joiner | strip | Same. |
| U+FEFF | byte-order mark | strip | Invisible. |
| U+00AD | soft hyphen | strip | Invisible. |
| U+2022 | bullet | `*` | Use markdown `*` or `-`. |
| U+00B7 | middle dot | `-` | Same. |

After replacing em dashes, search the file for `"  -  "` (two spaces,
hyphen, two spaces) - this is the artifact left when a *padded* em
dash gets converted - and collapse it to `" - "`. Do not collapse
other multi-space runs; YAML and code rely on indentation.

When done, re-run the grep above. It must return zero matches.

---

## What not to do

- Do not make the prose slick. The author's voice is plain, direct,
  occasionally blunt. Slick reads as fake.
- Do not introduce slang or fake casualness. No `gonna`, no `kinda`,
  no `lol`. The author's casualness is structural (short sentences,
  asides), not lexical.
- Do not modify technical claims, code blocks, frontmatter, or link
  targets when humanizing. Phase 5 codepoint substitutions are the
  only edits allowed inside code blocks.
- Do not change the post's structure (section order, headings, list
  shape) once the user has approved the outline.
- Do not pad. If the post says what it needs to say in 700 words,
  don't stretch it to 1200.
- Do not write "the future of AI" essays unless the user explicitly
  asks for one. The author's stated stance: *Other people are better
  at those.*
- Do not invent quotes, citations, or numbers. If the post needs a
  fact you don't have, leave a `TODO:` for the user to fill in.

