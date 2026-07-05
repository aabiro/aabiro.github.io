#!/usr/bin/env bash
# Build assets/Aaryn_Biro_Resume.pdf from RESUME.md (CI + local).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/assets/Aaryn_Biro_Resume.pdf"
MD="$ROOT/RESUME.md"

if [[ ! -f "$MD" ]]; then
  echo "RESUME.md not found" >&2
  exit 1
fi

if command -v pandoc >/dev/null 2>&1; then
  if pandoc "$MD" -o "$OUT" --pdf-engine=wkhtmltopdf 2>/dev/null; then
    echo "→ built $OUT (pandoc + wkhtmltopdf)"
    exit 0
  fi
  if pandoc "$MD" -o "$OUT" --pdf-engine=xelatex 2>/dev/null; then
    echo "→ built $OUT (pandoc + xelatex)"
    exit 0
  fi
fi

if command -v npx >/dev/null 2>&1; then
  npx --yes md-to-pdf "$MD" --dest "$OUT" 2>/dev/null && {
    echo "→ built $OUT (md-to-pdf)"
    exit 0
  }
fi

if [[ -f "$OUT" ]]; then
  echo "→ PDF build tools unavailable; keeping existing $OUT"
  exit 0
fi

echo "No PDF engine available and no existing resume PDF" >&2
exit 1