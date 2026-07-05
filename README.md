# Aaryn Biro Portfolio

Professional Flutter web portfolio for Aaryn Biro.

## Resume PDF

The downloadable resume served by the site is:

`assets/Aaryn_Biro_Resume.pdf`

Keep this as the single resume asset path. The download code expects Flutter web
to serve it at `assets/assets/Aaryn_Biro_Resume.pdf`.

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

Useful validation checks:

```sh
flutter analyze
flutter test
flutter build web --release --base-href /
```

The built site should contain the same PDF at:

`build/web/assets/assets/Aaryn_Biro_Resume.pdf`

## Agent-ready metadata (L6)

Dual-audience portfolio for humans and LLM agents (see `pxl-registry` S5 L6):

| Asset | Path | Live URL |
|-------|------|----------|
| `llms.txt` | repo root → `web/llms.txt` | https://aabiro.github.io/llms.txt |
| Agent manifest | `.well-known/agent.json` | https://aabiro.github.io/.well-known/agent.json |
| JSON-LD | `web/index.html` | Person + CreativeWork `@graph` |
| Resume source | `RESUME.md` | built to `assets/Aaryn_Biro_Resume.pdf` in CI |

Before each web build, `scripts/sync_agent_assets.sh` copies agent files into `web/`.
`scripts/build_resume_pdf.sh` regenerates the PDF from `RESUME.md` when pandoc is available.

Quarterly GitHub contribution stats: `.github/workflows/resume-quarterly.yml`.

## Deployment

Deployment to GitHub Pages runs automatically through GitHub Actions when changes are pushed to `main`.

Check out the live site at:

[https://aabiro.github.io/](https://aabiro.github.io/)
