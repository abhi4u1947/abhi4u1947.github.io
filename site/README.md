# Your personal site

Jekyll site for GitHub Pages. Editorial design, content-forward, ready to ship.

## Deploy in 10 minutes (GitHub Pages, no build setup)

### 1. Create the repo

Go to GitHub and create a new **public** repository named exactly:

```
yourusername.github.io
```

Replace `yourusername` with your actual GitHub username. The name **must** match, or GitHub Pages will use a subpath.

### 2. Push this folder to the repo

From inside this folder:

```bash
git init
git add .
git commit -m "Initial site"
git branch -M main
git remote add origin https://github.com/yourusername/yourusername.github.io.git
git push -u origin main
```

### 3. Turn on Pages

In your repo settings → **Pages** → set the source to **Deploy from a branch**, branch `main`, folder `/ (root)`. Save.

Within 1–2 minutes your site will be live at `https://yourusername.github.io`.

### 4. Edit `_config.yml`

This is the only file you must edit. Open it and replace the placeholder values:

- `title` — your name
- `tagline` — your one-line description
- `author`, `email` — yours
- `url` — `https://yourusername.github.io`
- `github_username`, `twitter_username`, `linkedin_username` — yours

Commit, push, and the changes go live in ~1 minute.

### 5. Edit `about.md`

Fill in the placeholders. Be honest about where you are in your journey — learning in public is a recognized and valued archetype in open source.

### 6. Write your three posts

Open the files in `_posts/`. Each one has:

- Real frontmatter (don't touch the structure)
- A `<!-- PLACEHOLDER NOTES -->` block at the bottom (delete before publishing)
- Inline `[PROJECT_NAME]` and `[bracketed]` prompts to replace

**Dates matter.** The filenames are `YYYY-MM-DD-slug.md`. Keep them as today's dates or later. **Do not backdate.** Real timestamps build real credibility.

## Run locally (optional but recommended before pushing)

```bash
# install ruby + bundler first if you don't have them
bundle install
bundle exec jekyll serve
```

Open http://localhost:4000.

## Writing tips

- Filename must be `YYYY-MM-DD-slug.md`
- Frontmatter `date:` must match the filename date
- Markdown is standard kramdown; code fences with language tags work
- Save drafts in `_drafts/` (create the folder); they won't publish until you move them to `_posts/`
- The first paragraph gets a drop cap automatically — write a strong opener

## Folder map

```
.
├── _config.yml          # site settings (edit this)
├── _layouts/            # HTML templates
├── _includes/           # header, footer partials
├── _posts/              # blog posts (markdown)
├── assets/css/main.scss # all the styles
├── about.md             # about page
├── index.html           # home page
├── 404.html             # not-found page
└── Gemfile              # Ruby dependencies
```

## Going further (after the application)

- Add a custom domain (Settings → Pages → Custom domain). Costs ~$12/year.
- Add Plausible or GoatCounter for privacy-friendly analytics.
- Add `<meta>` social cards (currently handled by jekyll-seo-tag).
- Cross-post to dev.to and Hashnode with canonical URLs pointing back here.
