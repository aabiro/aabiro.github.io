#!/usr/bin/env python3
"""Fail when web/sitemap.xml claims a freshness date older than the site itself.

<lastmod> is a freshness signal for crawlers, and a wrong one is worse than
none: it tells Google the page has not changed when it has. Nothing updates it
automatically, because it cannot be - the build has to be reproducible from the
committed files alone, and a date derived from the current commit would differ
between the build that produced docs/ and the build CI runs to verify it.

So it is maintained by hand and checked here.

    python3 scripts/check_sitemap_lastmod.py          # check
    python3 scripts/check_sitemap_lastmod.py --fix    # stamp today and move on
"""
from __future__ import annotations

import datetime
import os
import re
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SITEMAP = os.path.join(ROOT, "web", "sitemap.xml")
# What a visitor actually sees. docs/ is excluded: it is the build output, so
# including it would make every rebuild demand a new lastmod.
SOURCES = ["page", "web", "llms.txt", ".well-known", "assets"]


def last_source_change() -> str | None:
    out = subprocess.run(
        ["git", "log", "-1", "--format=%cs", "--"] + SOURCES,
        cwd=ROOT, capture_output=True, text=True,
    )
    return out.stdout.strip() or None


def main() -> int:
    text = open(SITEMAP).read()
    dates = re.findall(r"<lastmod>(\d{4}-\d{2}-\d{2})</lastmod>", text)
    if not dates:
        print("web/sitemap.xml has no <lastmod>", file=sys.stderr)
        return 1

    if "--fix" in sys.argv:
        today = datetime.date.today().isoformat()
        open(SITEMAP, "w").write(re.sub(r"<lastmod>\d{4}-\d{2}-\d{2}</lastmod>",
                                        f"<lastmod>{today}</lastmod>", text))
        print(f"-> stamped web/sitemap.xml with {today}")
        return 0

    changed = last_source_change()
    if changed is None:
        print("no git history for the site sources; skipping")
        return 0

    newest = max(dates)
    if newest < changed:
        print(f"web/sitemap.xml says {newest}, but the site last changed {changed}.",
              file=sys.stderr)
        print("Crawlers are being told the page is older than it is. Update it with:",
              file=sys.stderr)
        print("    python3 scripts/check_sitemap_lastmod.py --fix", file=sys.stderr)
        return 1

    print(f"sitemap lastmod {newest} is current (site last changed {changed})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
