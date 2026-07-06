#!/usr/bin/env python3
"""Inject the site's SEO / agent <head> metadata into the Claude Design page.

The Claude Design export ships a minimal <head> (title "Bundled Page", no OG /
Twitter / JSON-LD). This rewrites that head with the portfolio's full metadata
so serving the HTML does not regress the SEO / agent-readiness work. Runs as
part of scripts/build_site.sh; safe to re-run (idempotent on a fresh export).
"""
import sys

SEO_HEAD = """<title>Aaryn Biro - Principal Engineer &amp; Founder</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <!-- Primary SEO -->
  <meta name="description"
    content="Aaryn Biro is a founder and principal engineer specialising in GPU compute orchestration, AI media pipelines, and production-grade backend systems.">
  <meta name="keywords"
    content="Aaryn Biro, software engineer, GPU compute, AI media, backend, platform engineering, founder">
  <meta name="author" content="Aaryn Biro">
  <meta name="robots" content="index, follow">
  <link rel="canonical" href="https://aabiro.github.io/">

  <!-- Theme -->
  <meta name="theme-color" content="#0F766E">

  <!-- Open Graph / Facebook / LinkedIn -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://aabiro.github.io/">
  <meta property="og:site_name" content="Aaryn Biro">
  <meta property="og:title" content="Aaryn Biro - Principal Engineer &amp; Founder">
  <meta property="og:description"
    content="Principal engineer and founder specializing in GPU compute orchestration, AI media pipelines, backend systems, and high-performance product engineering.">
  <meta property="og:image" content="https://aabiro.github.io/og-image.jpg">
  <meta property="og:image:width" content="1200">
  <meta property="og:image:height" content="630">
  <meta property="og:image:alt" content="Aaryn Biro - Principal Engineer &amp; Founder">
  <meta property="og:locale" content="en_US">

  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="Aaryn Biro - Principal Engineer &amp; Founder">
  <meta name="twitter:description"
    content="Principal engineer and founder building production-grade GPU compute, AI media, and full-stack platform systems.">
  <meta name="twitter:image" content="https://aabiro.github.io/og-image.jpg">
  <meta name="twitter:image:alt" content="Aaryn Biro - Principal Engineer &amp; Founder">

  <!-- iOS / PWA -->
  <meta name="mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
  <meta name="apple-mobile-web-app-title" content="Aaryn Biro">
  <link rel="apple-touch-icon" href="icons/Icon-192.png">

  <!-- Favicon -->
  <link rel="icon" type="image/png" href="favicon.png">
  <link rel="shortcut icon" href="favicon.png">

  <link rel="manifest" href="manifest.json">

  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@graph": [
      {
        "@type": "Person",
        "@id": "https://aabiro.github.io/#person",
        "name": "Aaryn Biro",
        "url": "https://aabiro.github.io/",
        "jobTitle": "Principal Engineer & Founder",
        "email": "mailto:aaryn.alexander@gmail.com",
        "description": "Principal engineer and founder specializing in GPU compute orchestration, AI media pipelines, backend systems, and product engineering.",
        "address": {
          "@type": "PostalAddress",
          "addressLocality": "London",
          "addressRegion": "ON",
          "addressCountry": "CA"
        },
        "sameAs": [
          "https://github.com/aabiro",
          "https://www.linkedin.com/in/aabiro/"
        ],
        "knowsAbout": [
          "GPU compute orchestration",
          "AI media pipelines",
          "FastAPI",
          "Next.js",
          "Flutter",
          "Distributed systems"
        ]
      },
      {
        "@type": "WebSite",
        "@id": "https://aabiro.github.io/#website",
        "url": "https://aabiro.github.io/",
        "name": "Aaryn Biro Portfolio",
        "description": "Professional portfolio for Aaryn Biro - principal engineer and founder.",
        "publisher": { "@id": "https://aabiro.github.io/#person" },
        "inLanguage": "en"
      },
      {
        "@type": "CreativeWork",
        "@id": "https://aabiro.github.io/#xcelsior",
        "name": "Xcelsior",
        "url": "https://xcelsior.ca",
        "description": "Distributed GPU workload orchestration platform with secure worker admission, scheduling, billing, and Canadian data sovereignty.",
        "creator": { "@id": "https://aabiro.github.io/#person" },
        "keywords": ["GPU orchestration", "FastAPI", "PostgreSQL", "marketplace", "PIPEDA"],
        "dateCreated": "2025"
      },
      {
        "@type": "CreativeWork",
        "@id": "https://aabiro.github.io/#pixelenhance",
        "name": "PixelEnhance Labs",
        "description": "AI media enhancement platform with async GPU jobs, model registry, and hybrid cloud routing.",
        "creator": { "@id": "https://aabiro.github.io/#person" },
        "keywords": ["AI media", "FastAPI", "PyTorch", "TensorRT", "video enhancement"],
        "dateCreated": "2024"
      },
      {
        "@type": "CreativeWork",
        "@id": "https://aabiro.github.io/#portfolio",
        "name": "Aaryn Biro Portfolio",
        "url": "https://aabiro.github.io/",
        "description": "Web portfolio with agent-ready documentation and downloadable resume.",
        "creator": { "@id": "https://aabiro.github.io/#person" },
        "encoding": {
          "@type": "MediaObject",
          "contentUrl": "https://aabiro.github.io/assets/Aaryn_Biro_Resume.pdf",
          "encodingFormat": "application/pdf",
          "name": "Aaryn Biro Resume"
        }
      }
    ]
  }
  </script>"""


def main(src: str, dst: str) -> None:
    with open(src, "r", encoding="utf-8") as fh:
        html = fh.read()

    marker = "<title>Bundled Page</title>"
    if marker not in html:
        if "Aaryn Biro - Principal Engineer" in html:
            print("inject_seo: SEO head already present, copying through")
        else:
            sys.exit(f"inject_seo: expected marker {marker!r} not found in {src}")
    else:
        html = html.replace(marker, SEO_HEAD, 1)

    # Set the document language for accessibility / SEO.
    html = html.replace("<html>\n", '<html lang="en">\n', 1)

    with open(dst, "w", encoding="utf-8") as fh:
        fh.write(html)
    print(f"inject_seo: wrote {dst}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit("usage: inject_seo.py <src.html> <dst.html>")
    main(sys.argv[1], sys.argv[2])
