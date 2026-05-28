# Common failure modes

Patterns that show up repeatedly in mediocre technology writing. Use this reference when a post feels off but the specific issue isn't obvious. None of these are automatic failures — they're starting points for investigation.

## The "USB-C of X" framing

When a post explains a complex technology by saying it's "the USB-C of [field]" or "the npm of [field]" or "the GitHub of [field]." Sometimes useful for a non-technical reader; almost never useful for a senior-architect reader. The framing tells the reader the author either doesn't have a better one or is performing accessibility rather than informing.

**How to flag**: Name the analogy, ask what specific question it answers, point out what it papers over. "The 'USB-C of AI integrations' analogy is in the second paragraph, repeated implicitly through the post. It does no real work — a reader who needs the analogy isn't the audience, and a reader who is the audience gets nothing from it."

## The "everyone knows" / "of course" tic

Authors who want to sound senior often use "of course," "naturally," "as everyone knows" before a claim that, in fact, not everyone knows. It signals to the reader that the author either hasn't checked or is gatekeeping.

**How to flag**: Quote the phrase, ask whether the claim that follows is universally known, and if not, suggest scaffolding instead.

## The unsourced statistic

"40% of teams report..." "Studies show..." "Most enterprises now..." without a citation. The number is almost always plausible-sounding but unverifiable.

**How to flag**: List every unsourced statistic in the post. Note that even one unsourced statistic shifts the reader's trust meaningfully.

## The vendor-blog drift

A post starts with a sharp original framing and then drifts into territory that reads like a vendor blog — capabilities-listing, "imagine the possibilities," exhortations to "leverage" something. Often this happens in the back third of an essay when the author runs out of original material.

**How to flag**: Identify the exact paragraph where the drift starts. Often it's the third or fourth section, after the strong opening has been delivered. The fix is usually to cut, not to rewrite.

## The "best practices" trap

Sections titled "Best Practices for X" almost always fail the rubric because they restate what's in every other "best practices" post. Best practices are a genre, not an insight.

**How to flag**: If the post has a "best practices" section, ask whether the practices listed are different from what the reader could get from the official docs or a top Google result. If not, the section should be cut or rewritten as opinionated guidance with stakes ("here's what I'd choose and why").

## The buried thesis

The reader can't tell what the post is about until paragraph six. This often happens when the author is thinking out loud through the introduction and didn't go back to compress it.

**How to flag**: Find the sentence that, if moved to paragraph two, would orient the entire post. Recommend moving it.

## The non-ending

The post stops rather than ends. No takeaway, no call to action, no synthesis. Often the last paragraph is "Anyway, hope this was useful" or "There's more to explore here."

**How to flag**: Read the last paragraph. Ask: what does the reader do now? If there's no answer, the ending needs to do work.

## The trade-off-free recommendation

A post recommends a technology, pattern, or approach without naming what it costs. Real senior writing always names the trade-off. "Use X" is junior writing. "Use X when Y, accepting cost Z" is senior writing.

**How to flag**: Find every recommendation in the post. Check whether each one names its cost. Flag the ones that don't.

## The version-free claim

"Kubernetes does X." Which version? "AWS does Y." Verified when? "MCP supports Z." As of which spec revision? Cloud-native and AI ecosystems move fast enough that version-free claims go stale within months.

**How to flag**: List every claim that should be version-pinned and isn't. This often interacts with the technical correctness score — an outdated claim is wrong, not just under-specified.

## The Diagram That Adds Nothing

A diagram that just re-renders the prose visually. Boxes labeled with the same nouns the paragraph already names, connected by arrows that don't carry information. Diagrams should answer questions the prose can't answer cleanly — relationships between many components, sequence, scale.

**How to flag**: Cover the diagram and ask whether the prose loses anything. If not, the diagram is decorative.

## The Self-Reference Spiral

A post that cites the author's own prior posts more than it cites external sources. Self-reference is useful when it spares the reader from re-reading context the author has already covered. It is a failure mode when it substitutes for external evidence.

**How to flag**: Count self-references vs. external references. If self-references outnumber external by more than 2:1, suggest re-balancing.

## The Cautious-To-The-Point-Of-Useless Hedge

Every claim is wrapped in "might," "could," "in some cases," "depending on context," to the point that the reader can't extract any actual guidance. Often this is a fear of being wrong on the internet.

**How to flag**: Find the strongest sentence in the post — the one with the clearest claim. Then find the weakest hedged sentence. Suggest converting at least two hedged sentences to direct claims, even if it requires more research to back them.

## How to use this reference

When a review feels stuck — when the post "feels off" but the specific issue isn't obvious — scan this list. Map the post's symptoms to the patterns here, then write specific, evidence-backed findings. Do not just say "this post has the 'best practices trap'" — that's jargon-as-feedback. Say what the post does and what it should do instead.
