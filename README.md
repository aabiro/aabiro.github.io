# Aaryn Biro Portfolio

Professional static HTML portfolio for Aaryn Biro.

The live page source is `page/page.html`. `scripts/build_site.sh` injects SEO
metadata and gathers the supporting assets into a deploy directory - `site/` by
default, or `docs/`, which is the copy GitHub Pages serves (see Deployment).

## Resume PDF

The downloadable resume served by the site is:

`assets/Aaryn_Biro_Resume.pdf`

Keep this as the single resume asset path. The download code serves it at
`assets/Aaryn_Biro_Resume.pdf`.

To preserve the SCRUFF resume layout, update the DOCX template first, then
export it to PDF with LibreOffice. Do not recreate the PDF layout from scratch
unless the DOCX template is unavailable.

Current wording requirements:

- Professional summary uses the Next.js/Python wording, not the old Ruby/Rails
  summary.
- Technical skills `Languages` starts with Python.
- Technical skills `Backend` does not list Ruby on Rails.
- Technical skills `Frontend & Mobile` starts with Next.js.
- The Xcelsior first bullet includes `Next.js interfaces`.
- Ruby/Rails should appear only in the realxdata experience bullet.

Useful validation and preview commands:

```sh
bash scripts/build_site.sh
python3 -m http.server 8000 --directory site
```

The built site should contain the same PDF at:

`site/assets/Aaryn_Biro_Resume.pdf`

## Agent-ready metadata (L6)

Dual-audience portfolio for humans and LLM agents (see `pxl-registry` S5 L6):

| Asset | Path | Live URL |
|-------|------|----------|
| `llms.txt` | repo root → `site/llms.txt` | https://aabiro.github.io/llms.txt |
| Agent manifest | `.well-known/agent.json` | https://aabiro.github.io/.well-known/agent.json |
| JSON-LD | `scripts/inject_seo.py` | Person + CreativeWork `@graph` |
| No-JavaScript copy | `scripts/inject_static_profile.py` | `<main id="static-profile">` in `index.html` |
| Resume source | `RESUME.md` | built to `assets/Aaryn_Biro_Resume.pdf` by `scripts/build_resume_pdf.sh` |

The Claude Design export renders only with JavaScript, so on its own a crawler,
link previewer, recruiter tool or agent fetching the page sees an empty loader.
`scripts/inject_static_profile.py` reads the page's own copy and component data
(experience, work, capabilities, stack, contact) out of the bundled template and
writes it into `index.html` as plain HTML. Browsers with JavaScript still swap in
the designed page as before. Re-exporting `page/page.html` keeps the static copy
in sync automatically; the build fails if it can no longer find the experience
or work data.

`scripts/build_site.sh` copies agent files into `site/` alongside the HTML page.
`scripts/build_resume_pdf.sh` regenerates the PDF from `RESUME.md` when pandoc is available.

Quarterly GitHub contribution stats: `.github/workflows/resume-quarterly.yml`.

## Deployment

GitHub Pages serves the site from the committed `docs/` directory on `main`, so
deploying is `git push`. Rebuild `docs/` whenever `page/`, `web/`, `llms.txt`,
`.well-known/` or the resume PDF changes, and commit it alongside the change:

```sh
SITE_OUTPUT_DIR="$PWD/docs" bash scripts/build_site.sh
```

This used to deploy through Actions, with `actions/upload-pages-artifact` and
`actions/deploy-pages`. That path is blocked: the upload needs Actions artifact
storage, which this account's billing has cut off, so the job failed at the
upload step with "Artifact storage quota has been hit" after an otherwise green
build. Serving `docs/` from the branch needs no artifact storage and no hosted
runner, and keeps the same URL.

`.github/workflows/github-pages.yml` verifies rather than deploys: it rebuilds
the site and fails if the committed `docs/` differs from a fresh build, which is
the only thing that catches a stale `docs/`.

GitHub-hosted runners are blocked on this account too, so that check runs on the
sandboxed self-hosted runner from `aabiro/xcelsior` (`scripts/ci-runner/`). Start
one from the xcelsior checkout; it serves the one job and exits:

```sh
XCELSIOR_CI_REPO=aabiro/aabiro.github.io ./scripts/ci-runner/run-runner.sh
```

A push with no runner up just queues the check. The site is live either way.

The workflow has no `pull_request` trigger on purpose: on a public repository,
that trigger would let anyone's pull request run code on the self-hosted runner.

Check out the live site at:

[https://aabiro.github.io/](https://aabiro.github.io/)
