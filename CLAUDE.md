# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

All commands run from the `site/` directory:

```bash
bundle install                  # Install Ruby/Jekyll dependencies
bundle exec jekyll serve        # Dev server at http://localhost:4000 (auto-rebuilds on save)
bundle exec jekyll build        # Build static output to _site/
```

## Architecture

This is a Jekyll static site targeting GitHub Pages deployment. Content is authored in Markdown, processed by Jekyll with Liquid templating, and deployed as static HTML.

**Template hierarchy**: `_layouts/default.html` (base HTML shell) → `_layouts/post.html` (wraps default for posts) → `_includes/header.html` + `_includes/footer.html` (partials injected into default).

**Styling**: A single file, `assets/css/main.scss`, contains all styles using CSS custom properties for theming. Light/dark mode is handled via `prefers-color-scheme` media queries. Design tokens (colors, fonts, spacing) are defined as `--` variables at the top of that file.

**Content flow**: Blog posts in `_posts/` use the filename convention `YYYY-MM-DD-slug.md`. Jekyll injects them into `index.html` via the paginator. The `_config.yml` permalink pattern is `/:year/:month/:title/`.

**Key config**: `site/_config.yml` controls site identity (title, tagline, social handles). The `url` and `github_username` fields are currently placeholder values that need updating before deploying to GitHub Pages.

## Post Frontmatter

Posts require this frontmatter structure:

```yaml
---
layout: post
title: "Post title"
date: YYYY-MM-DD
kicker: "Short label shown above title"
tags: [tag1, tag2]
description: "Used for SEO meta description"
image: /assets/images/posts/YYYY-MM-DD-slug.png   # optional - LinkedIn infographic / og:image
---
```

The first paragraph in each post automatically receives drop-cap styling via CSS. The optional `image:` field, when present, renders as a cover above the post body and is auto-emitted as `og:image` and `twitter:image` by jekyll-seo-tag.

## Writing or editing posts

When creating or editing any file under `site/_posts/`, invoke the
`post-writer` skill before finishing. It covers voice calibration
(reading the existing posts to match register), planning, frontmatter,
drafting, a humanization pass, and a forensic Unicode scrub
(em dashes, smart quotes, zero-width characters, NBSP, BOM, soft
hyphens). The full procedure - voice traits, structural patterns,
checklist, codepoint table - is at
[.claude/skills/post-writer/SKILL.md](.claude/skills/post-writer/SKILL.md).

Before writing, read [.claude/content-strategy.md](.claude/content-strategy.md)
for the site niche, active content threads, audience assumptions, and
depth conventions per register.

