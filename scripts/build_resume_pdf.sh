#!/usr/bin/env bash
# Build assets/Aaryn_Biro_Resume.pdf from the DOCX source, with the quarterly
# GitHub feed injected.
#
#     assets/Aaryn_Biro_Resume.docx  (design + text, the source of truth)
#       + assets/github_stats.json   (refreshed by scripts/fetch_github_stats.py)
#       -> LibreOffice -> assets/Aaryn_Biro_Resume.pdf
#       -> assets/resume.lock.json   (what CI checks for staleness)
#
# This runs locally, not in CI, and that is deliberate. The PDF's line breaks
# depend on the fonts installed on the converting machine, so rendering it on a
# Linux runner would reflow the page. The committed PDF is pixel-identical to
# the one this repository has shipped since June; keeping the conversion on the
# machine that produced it is what keeps it that way. CI verifies the lock
# instead, which needs no LibreOffice.
#
# It does NOT build from RESUME.md. An earlier version ran
# `pandoc RESUME.md -o <the PDF>`, which would have silently replaced the
# designed one-page resume with a plain pandoc render the moment pandoc was
# installed, dropping Education, Certifications and the phone number. RESUME.md
# is a separate, shorter document for the web page and for agents.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DOCX="$ROOT/assets/Aaryn_Biro_Resume.docx"
PDF="$ROOT/assets/Aaryn_Biro_Resume.pdf"
STATS="$ROOT/assets/github_stats.json"
LOCK="$ROOT/assets/resume.lock.json"

[[ -f "$DOCX" ]] || { echo "missing $DOCX" >&2; exit 1; }

SOFFICE="${SOFFICE:-}"
if [[ -z "$SOFFICE" ]]; then
  for cand in soffice libreoffice /Applications/LibreOffice.app/Contents/MacOS/soffice; do
    if command -v "$cand" >/dev/null 2>&1; then SOFFICE="$cand"; break; fi
    if [[ -x "$cand" ]]; then SOFFICE="$cand"; break; fi
  done
fi
if [[ -z "$SOFFICE" ]]; then
  echo "LibreOffice not found. Install it (brew install --cask libreoffice) or set SOFFICE." >&2
  echo "Refusing to fall back to another converter: that would restyle the resume." >&2
  exit 1
fi

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

python3 "$ROOT/scripts/inject_resume_feed.py" "$DOCX" "$STATS" "$WORK/Aaryn_Biro_Resume.docx"
"$SOFFICE" --headless --convert-to pdf --outdir "$WORK" "$WORK/Aaryn_Biro_Resume.docx" >/dev/null 2>&1
[[ -f "$WORK/Aaryn_Biro_Resume.pdf" ]] || { echo "LibreOffice produced no PDF" >&2; exit 1; }
cp "$WORK/Aaryn_Biro_Resume.pdf" "$PDF"

python3 - "$DOCX" "$STATS" "$PDF" "$LOCK" <<'PY'
import hashlib, json, sys, os
docx, stats, pdf, lock = sys.argv[1:5]
def sha(p):
    return hashlib.sha256(open(p, 'rb').read()).hexdigest() if os.path.exists(p) else None
json.dump({
    "note": "Written by scripts/build_resume_pdf.sh. CI fails when these no longer match the committed files.",
    "docx_sha256": sha(docx),
    "stats_sha256": sha(stats),
    "pdf_sha256": sha(pdf),
}, open(lock, 'w'), indent=2)
open(lock, 'a').write("\n")
print("-> wrote", os.path.basename(lock))
PY

echo "-> built $PDF from $(basename "$DOCX")"
