#!/usr/bin/env python3
"""Snapshot the GitHub contribution calendar the portfolio's heatmap draws.

The page fetches github-contributions-api.jogruber.de live. That is one
person's free API: when it is down, rate-limiting, or simply slow, the page
shows an "unavailable" panel where the strongest proof point on the site should
be. This writes a snapshot next to the site so the chart always has something
to draw, and the page falls back to it only when the live call fails.

    python3 scripts/fetch_contributions.py

The shape matches the API's own response, so the page's parser needs no second
code path.
"""
from __future__ import annotations

import json
import os
import sys
import urllib.request
from datetime import date

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(ROOT, "assets", "github_contributions.json")
USER = os.environ.get("GITHUB_USER", "aabiro")
# Must match `since` in page/page.html: the chart starts where the activity does.
SINCE = date(2025, 6, 1)


def main() -> int:
    years = range(SINCE.year, date.today().year + 1)
    url = (f"https://github-contributions-api.jogruber.de/v4/{USER}?"
           + "&".join(f"y={y}" for y in years))
    req = urllib.request.Request(url, headers={"User-Agent": "aabiro-portfolio-snapshot"})
    with urllib.request.urlopen(req, timeout=30) as resp:
        data = json.loads(resp.read())

    today = date.today()
    kept = [
        {"date": e["date"], "count": e["count"], "level": e["level"]}
        for e in data.get("contributions", [])
        if SINCE <= date.fromisoformat(e["date"]) <= today
    ]
    if not kept:
        print("no contributions in range; refusing to write an empty snapshot", file=sys.stderr)
        return 1

    with open(OUT, "w") as fh:
        json.dump({"snapshot_taken": today.isoformat(), "contributions": kept}, fh, separators=(",", ":"))
        fh.write("\n")
    total = sum(e["count"] for e in kept)
    print(f"-> {os.path.relpath(OUT, ROOT)}: {len(kept)} days, {total} contributions since {SINCE}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
