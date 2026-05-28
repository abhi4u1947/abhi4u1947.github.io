# Hashtag research

How to suggest hashtags that actually serve the post, not generic tag soup.

## The core question

A hashtag is useful if and only if the target audience is actually reading that tag. A tag with 10 million posts and no engagement is worse than a tag with 200 posts and a tight community. The job is to find tags where the post will be seen by readers who care.

## Verification process

Before recommending a hashtag, verify two things:

**1. The tag is currently active.** Search the tag on LinkedIn and X. Look for posts in the last 7 days. If the most recent post is months old, the tag is dead — do not recommend it.

**2. The tag fits the audience.** A tag can be active but populated by the wrong crowd. `#CloudComputing` is active but dominated by vendor marketing and certification posts. `#PlatformEngineering` is active and dominated by working practitioners. The second is more useful for the kind of writing this skill reviews.

Use web_search for this. Example queries:
- `"#PlatformEngineering" LinkedIn recent posts`
- `"#DevSecOps" hashtag activity 2026`
- `KubeCon hashtag 2026`

## The three tiers

### Primary (3-5 tags)

High-traffic, broad tags the target audience already follows. These give the post reach. They are the tags people search and follow, not just the tags people add.

Good primary tag characteristics:
- 1000+ posts/month on LinkedIn
- Active community in the comments, not just one-way broadcasts
- Aligned with the post's actual subject, not just the broader field

Common primary tags by domain (verify currency before recommending):
- Platform/cloud-native: `#PlatformEngineering`, `#CloudNative`, `#Kubernetes`, `#DevOps`
- Security: `#Cybersecurity`, `#DevSecOps`, `#ZeroTrust`, `#InfoSec`
- Architecture: `#SoftwareArchitecture`, `#SystemDesign`, `#EnterpriseArchitecture`
- AI/agentic: `#AgenticAI`, `#GenerativeAI`, `#LLM` (caveat: AI tags are noisy)

### Niche (3-5 tags)

Lower-traffic, higher-fit tags. The tags where the people who actually do the work hang out. These are where you get serious comments and connections, not vanity metrics.

Good niche tag characteristics:
- 50-500 posts/month
- Comments include working practitioners debating substantive points
- Often tied to a specific tool, spec, or community

Common niche tags by domain (verify currency):
- `#SoftwareSupplyChain`, `#SLSA`, `#Sigstore`, `#SBOM`
- `#SPIFFE`, `#WorkloadIdentity`, `#ServiceMesh`
- `#OpenTelemetry`, `#Observability`, `#SiteReliabilityEngineering`
- `#InternalDeveloperPlatform`, `#IDP`, `#GoldenPath`
- `#MCP`, `#ModelContextProtocol`, `#AAIF`

### Conversation (2-5 tags)

Tags tied to active debates, conferences, or moments. These plug the post into a current conversation. They are time-sensitive and need careful verification.

Good conversation tag characteristics:
- Tied to a current event, conference, or trending debate
- Verified active in the last 14 days
- Have a clear "ends-with" — a conference ending, a release shipping, a debate cooling

Examples:
- Conference tags: `#KubeCon`, `#REInvent`, `#RSAConference` (only useful in their season)
- Release tags: `#Kubernetes132`, `#TerraformX`
- Debate tags: tags tied to current technical controversies — check before using

## Tags to avoid

- Tags so broad they're meaningless: `#AI`, `#Tech`, `#Software`, `#Cloud`, `#Innovation`
- Vendor-promoted tags that scream marketing: `#DigitalTransformation`, `#FutureOfWork`
- Tags that don't match the post's actual angle even if the keyword appears: a post critiquing MCP supply chain should not use `#MCP` as a primary tag if the MCP community will be hostile to the framing — use it as a conversation tag instead
- Tags with declining activity even if they're well-known

## Format conventions

- PascalCase: `#PlatformEngineering`, not `#platformengineering` or `#platform-engineering`
- No spaces, no special characters
- Keep tag count to 8-15 total — more is spammy, less is under-promoting
- Order in the post: place 3-5 tags in the body where natural, the rest at the end

## When to recommend zero hashtags

Some posts shouldn't have hashtags. Personal essays, deeply technical posts going to a specific subreddit or Hacker News, or posts that will mostly travel via email signature. If hashtags would feel out of place, say so in the review and explain why.

## Verification cadence

Hashtag activity shifts every quarter. A tag that was active in 2024 may be dead in 2026. Re-verify primary and niche tag activity each review — do not rely on a cached recommendation list.
