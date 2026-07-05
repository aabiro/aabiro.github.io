#!/usr/bin/env bash
# Copy agent-readable assets into web/ before `flutter build web`.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cp "$ROOT/llms.txt" "$ROOT/web/llms.txt"
mkdir -p "$ROOT/web/.well-known"
cp "$ROOT/.well-known/agent.json" "$ROOT/web/.well-known/agent.json"
# GitHub Pages runs Jekyll by default; .nojekyll is required to serve .well-known/
touch "$ROOT/web/.nojekyll"

echo "→ synced llms.txt, .well-known/agent.json, .nojekyll → web/"