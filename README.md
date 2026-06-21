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

## Deployment

Deployment to GitHub Pages runs automatically through GitHub Actions when changes are pushed to `main`.

Check out the live site at:

[https://aabiro.github.io/](https://aabiro.github.io/)
