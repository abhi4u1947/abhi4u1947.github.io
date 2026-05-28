#!/usr/bin/env bash
# Fail if Jekyll output is missing key pages or matches the broken github-pages build.
set -euo pipefail

SITE="${1:-site/_site}"

die() { echo "verify-site-build: $*" >&2; exit 1; }

[[ -d "$SITE" ]] || die "directory not found: $SITE"

required=(
  "$SITE/index.html"
  "$SITE/about/index.html"
  "$SITE/blog/index.html"
  "$SITE/resume/index.html"
  "$SITE/assets/css/main.css"
  "$SITE/feed.xml"
  "$SITE/2026/05/architect-notes-on-agentic-ai/index.html"
  "$SITE/2026/05/scoping-goose-for-ops/index.html"
  "$SITE/2026/05/supply-chain-questions-for-agents/index.html"
  "$SITE/2026/05/open-plugins-standard/index.html"
  "$SITE/2026/05/spiffe-for-agent-identity/index.html"
)

for f in "${required[@]}"; do
  [[ -f "$f" ]] || die "missing required file: $f"
done

# Wrong artifact layout from jekyll-build-pages (nested site/ tree)
[[ ! -f "$SITE/site/index.html" ]] || die "nested site/index.html (wrong build)"
[[ ! -f "$SITE/CLAUDE.html" ]] || die "repo junk in artifact: CLAUDE.html"

home="$SITE/index.html"
about="$SITE/about/index.html"

grep -q 'site-header' "$home" || die "index.html missing custom layout (site-header)"
grep -q 'main\.css' "$home" || die "index.html does not reference main.css"
grep -q 'hero-tagline' "$home" || die "index.html missing homepage hero"

grep -q 'main\.css' "$about" || die "about/index.html does not reference main.css"
grep -q 'site-header' "$about" || die "about/index.html missing custom layout"
grep -q 'abhi4u1947' "$about" || die "about page: Liquid did not render site.github_username"
grep -q 'github\.com//' "$about" && die "about page has broken empty GitHub URL"

if grep -q 'markdown-body' "$home" && ! grep -q 'site-header' "$home"; then
  die "index.html looks like GitHub Pages default theme, not custom site"
fi

echo "verify-site-build: OK ($SITE)"
