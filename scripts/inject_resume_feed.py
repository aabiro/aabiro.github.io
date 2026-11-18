#!/usr/bin/env python3
"""Resolve the {{GITHUB_CONTRIBUTIONS}} placeholder in the resume DOCX.

The DOCX carries the placeholder so the source stays a plain Word document that
opens and edits normally; the number is filled in on the way to the PDF from
assets/github_stats.json, which scripts/fetch_github_stats.py refreshes.

Only the contribution count goes on the resume. The repository count and star
counts live in RESUME.md and the stats JSON: "6 public repositories, top repo
2 stars" reads weaker than saying nothing at all, while a year's contribution
total stands on its own.
"""
from __future__ import annotations

import json
import os
import sys
import zipfile

PLACEHOLDER = "{{GITHUB_CONTRIBUTIONS}}"
MONTHS = ("January", "February", "March", "April", "May", "June",
          "July", "August", "September", "October", "November", "December")


def feed_line(stats_path: str) -> str | None:
    """The sentence that replaces the placeholder, or None to drop the line."""
    if not os.path.exists(stats_path):
        return None
    with open(stats_path) as fh:
        stats = json.load(fh)
    total = stats.get("total_contributions_last_year")
    if not total:
        return None
    updated = str(stats.get("updated", ""))
    asof = ""
    parts = updated.split("-")
    if len(parts) >= 2 and parts[0].isdigit() and parts[1].isdigit():
        asof = f" (as of {MONTHS[int(parts[1]) - 1]} {parts[0]})"
    return f"{total:,} contributions in the last year{asof}"


def main() -> int:
    src, stats_path, dst = sys.argv[1:4]
    line = feed_line(stats_path)

    zin = zipfile.ZipFile(src)
    with zipfile.ZipFile(dst, "w", zipfile.ZIP_DEFLATED) as zout:
        for item in zin.infolist():
            data = zin.read(item.filename)
            if item.filename == "word/document.xml":
                xml = data.decode("utf-8")
                if PLACEHOLDER not in xml:
                    print(f"warning: {PLACEHOLDER} not found in {src}", file=sys.stderr)
                elif line is None:
                    # No usable stats: drop the whole paragraph rather than ship
                    # a resume with a visible template token on it.
                    start = xml.rfind("<w:p>", 0, xml.index(PLACEHOLDER))
                    end = xml.index("</w:p>", xml.index(PLACEHOLDER)) + len("</w:p>")
                    xml = xml[:start] + xml[end:]
                    print("no stats available; omitted the GitHub line")
                else:
                    xml = xml.replace(PLACEHOLDER, line)
                    print(f"-> GitHub line: {line}")
                data = xml.encode("utf-8")
            zout.writestr(item, data)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
