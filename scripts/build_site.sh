#!/usr/bin/env bash
# Assemble the static deploy directory (site/) that GitHub Pages serves.
#
# The page itself is the Claude Design export (page/page.html); this injects the
# portfolio's SEO / agent <head> into it and gathers the supporting assets
# (favicon, icons, manifest, robots, sitemap, OG image, llms.txt,
# .well-known/agent.json, resume PDF) alongside it. The resume is expected to
# already be built by scripts/build_resume_pdf.sh.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SITE="$ROOT/site"

rm -rf "$SITE"
mkdir -p "$SITE" "$SITE/.well-known" "$SITE/assets"

# 1. The page, with SEO / agent metadata injected into its <head>.
python3 "$ROOT/scripts/inject_seo.py" "$ROOT/page/page.html" "$SITE/index.html"

# 2. Favicon + PWA icons + manifest.
cp "$ROOT/web/favicon.png" "$SITE/favicon.png"
cp -R "$ROOT/web/icons" "$SITE/icons"
cp "$ROOT/web/manifest.json" "$SITE/manifest.json"

# 3. Crawler + social assets.
cp "$ROOT/web/robots.txt" "$SITE/robots.txt"
cp "$ROOT/web/sitemap.xml" "$SITE/sitemap.xml"
cp "$ROOT/web/og-image.jpg" "$SITE/og-image.jpg"

# 4. Agent-readable assets.
cp "$ROOT/llms.txt" "$SITE/llms.txt"
cp "$ROOT/.well-known/agent.json" "$SITE/.well-known/agent.json"

# 5. Downloadable resume (referenced by the page's download button).
cp "$ROOT/assets/Aaryn_Biro_Resume.pdf" "$SITE/assets/Aaryn_Biro_Resume.pdf"

# 6. GitHub Pages runs Jekyll by default; .nojekyll is required to serve
#    .well-known/ and any underscore-prefixed paths.
touch "$SITE/.nojekyll"

echo "-> built site/ (index.html + SEO assets + resume)"
