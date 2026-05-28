# Voice lenses

Detailed calibration for the three audience lenses. The rubric does not change between lenses — only the surface presentation of the review does. The bar stays high.

## How to detect the lens from the post

Read the first 200 words and any code blocks. Look at:

- **Jargon density**: Terms used without definition. A post that drops "SVID," "X.509-SVID," "JWT-SVID," "Workload API," and "workload attestation" in two paragraphs is written for senior architects. A post that explains what a JWT is and uses "container" without "k8s" is written for general developers.
- **Code block depth**: Configuration files, RBAC YAML, Terraform, IaC — senior architect. CLI snippets and "hello world" — general developer. No code at all and lots of "should/might/consider" — engineering manager.
- **Decisions the author is asking the reader to make**: "Choose between SPIRE node attestation and TPM" — senior architect. "Choose between cloud providers" — engineering manager. "Try this tool" — general developer.
- **Length and density**: 2000+ words with sub-sections and footnotes — senior architect or manager. 800-1200 words — general developer. The length itself isn't the signal; it's whether the density rewards the length.

When uncertain, default to the senior architect lens. It is easier to soften feedback than to harden it.

## Senior architect / staff engineer lens

This is the default. The reader is a working architect, staff engineer, platform lead, security architect, SRE, or DevSecOps practitioner with 8+ years of experience.

**What this reader values**: Specificity over generality. Nuance over slogans. Honest admissions of trade-offs over confident claims. Code and configuration over diagrams. First-hand experience over surveys.

**What this reader has zero patience for**: "AI is transforming everything." "Best practices for X." Anything that reads like a vendor blog. Posts that explain what a microservice is.

**Review presentation**:
- Terse. The reviewer assumes the author can take direct feedback.
- Use specific technical vocabulary without scaffolding.
- Quote specific lines from the post by exact location.
- Point out where the author is restating widely-known content as if it were insight.
- Praise is short and earned; absent when not earned.

**Sample tone**: "Section three names CycloneDX as an SBOM format and stops there. That's a missed opportunity — the interesting question isn't what CycloneDX is, it's how to integrate SBOM generation into a build pipeline without coupling the SBOM tooling to the build system. Audience already knows what CycloneDX is. Tell them what they don't know."

## Engineering manager / director lens

The reader manages architects. They care about the same technical issues but at one level of abstraction up: how does this affect platform strategy, team structure, hiring, risk?

**What this reader values**: Strategic framing of technical decisions. Cost/benefit analysis. Anything that helps them brief leadership.

**What this reader has zero patience for**: Pure implementation detail without business framing. Posts that don't tell them what to do with the information.

**Review presentation**:
- Still terse, but framed in terms of decisions and trade-offs.
- Flag where the post does or doesn't help the reader make a decision.
- Score the same rubric, but weight clarity and engagement slightly higher in the qualitative commentary (not in the scoring weights).

**Sample tone**: "The post explains SPIFFE workload identity well but doesn't connect it to the decisions a platform team is making this quarter. Who buys SPIFFE? Who maintains the SPIRE deployment? What does the staffing look like? A platform director reading this can't bring it to their VP without doing that work themselves."

## General developer / community lens

The reader is a working developer who reads tech blogs to stay current. They have less context, but they are still technical — this is not for non-technical readers.

**What this reader values**: A clear problem statement, a clear solution, code they can try, a takeaway they can apply this week.

**What this reader has zero patience for**: Posts written for an audience they aren't part of. Posts that assume context they don't have. Posts that don't end with something actionable.

**Review presentation**:
- Friendlier in tone but still strict.
- Flag where assumed context will lose the reader.
- Flag where the post should have a "try this" section and doesn't.

**Sample tone**: "The opening assumes the reader has run SPIRE before. Most readers haven't. Either scaffold the first two paragraphs to bring them up to speed, or explicitly mark this post as 'requires prior SPIFFE experience' so people self-select."

## What does not change between lenses

The rubric weights. The scoring scale. The verdict bands. The requirement for web verification of every claim. The requirement for evidence-backed feedback.

A post can be excellent for senior architects and weak for general developers — but the score itself is against the audience the post is targeting. Identify the target audience from the post, then score against that target.
