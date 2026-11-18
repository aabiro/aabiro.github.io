#!/usr/bin/env python3
"""Fail when the committed resume PDF no longer matches what built it.

The PDF is generated from assets/Aaryn_Biro_Resume.docx plus
assets/github_stats.json by scripts/build_resume_pdf.sh, which records the
hashes of all three in assets/resume.lock.json. Editing the DOCX or refreshing
the stats without rebuilding leaves the published PDF stale, and nothing else
notices: that is how the shipped resume fell two weeks behind its own source
and stayed there for four months.

Pure stdlib on purpose. The runner needs no LibreOffice, no pandoc and no PDF
tooling to run this check.
"""
from __future__ import annotations

import hashlib
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LOCK = os.path.join(ROOT, "assets", "resume.lock.json")
TRACKED = {
    "docx_sha256": os.path.join(ROOT, "assets", "Aaryn_Biro_Resume.docx"),
    "stats_sha256": os.path.join(ROOT, "assets", "github_stats.json"),
    "pdf_sha256": os.path.join(ROOT, "assets", "Aaryn_Biro_Resume.pdf"),
}


def sha256(path: str) -> str | None:
    if not os.path.exists(path):
        return None
    with open(path, "rb") as fh:
        return hashlib.sha256(fh.read()).hexdigest()


def main() -> int:
    if not os.path.exists(LOCK):
        print(f"missing {os.path.relpath(LOCK, ROOT)}; run scripts/build_resume_pdf.sh", file=sys.stderr)
        return 1
    with open(LOCK) as fh:
        lock = json.load(fh)

    stale = []
    for key, path in TRACKED.items():
        rel = os.path.relpath(path, ROOT)
        if lock.get(key) != sha256(path):
            stale.append(rel)

    if stale:
        print("The committed resume PDF is out of date with its sources:", file=sys.stderr)
        for rel in stale:
            print(f"  changed since the PDF was built: {rel}", file=sys.stderr)
        print("\nRebuild it locally (LibreOffice does the conversion, so it is not a CI step):",
              file=sys.stderr)
        print("    bash scripts/build_resume_pdf.sh", file=sys.stderr)
        print("    git add assets/Aaryn_Biro_Resume.pdf assets/resume.lock.json", file=sys.stderr)
        return 1

    print("resume PDF matches its DOCX source and the committed GitHub stats")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
