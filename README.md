# Aaryn Biro Portfolio

Professional static HTML portfolio for Aaryn Biro.

The live page source is `page/page.html`. `scripts/build_site.sh` injects SEO
metadata and gathers the supporting assets into `site/` for deployment.

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
| Resume source | `RESUME.md` | built to `assets/Aaryn_Biro_Resume.pdf` in CI |

`scripts/build_site.sh` copies agent files into `site/` alongside the HTML page.
`scripts/build_resume_pdf.sh` regenerates the PDF from `RESUME.md` when pandoc is available.

Quarterly GitHub contribution stats: `.github/workflows/resume-quarterly.yml`.

## Deployment

Deployment to GitHub Pages runs automatically through GitHub Actions when changes are pushed to `main`.

Check out the live site at:

[https://aabiro.github.io/](https://aabiro.github.io/)
