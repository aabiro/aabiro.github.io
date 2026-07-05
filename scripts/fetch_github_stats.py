#!/usr/bin/env python3
"""Inject quarterly GitHub contribution stats into RESUME.md."""
from __future__ import annotations

import json
import os
import re
import sys
import urllib.request
from datetime import datetime, timezone

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RESUME = os.path.join(REPO_ROOT, "RESUME.md")
STATS_JSON = os.path.join(REPO_ROOT, "assets", "github_stats.json")
USER = os.environ.get("GITHUB_USER", "aabiro")
TOKEN = os.environ.get("GITHUB_TOKEN", "")


def main() -> int:
    q = """
    query($login: String!) {
      user(login: $login) {
        repositories(first: 100, ownerAffiliations: OWNER, orderBy: {field: UPDATED_AT, direction: DESC}) {
          totalCount
          nodes { name stargazerCount updatedAt isPrivate }
        }
        contributionsCollection {
          contributionCalendar { totalContributions }
        }
      }
    }
    """
    payload = json.dumps({"query": q, "variables": {"login": USER}}).encode()
    req = urllib.request.Request(
        "https://api.github.com/graphql",
        data=payload,
        headers={
            "Content-Type": "application/json",
            "User-Agent": "aabiro-portfolio-stats",
            **({"Authorization": f"Bearer {TOKEN}"} if TOKEN else {}),
        },
    )
    with urllib.request.urlopen(req, timeout=30) as resp:
        data = json.loads(resp.read())
    user = data.get("data", {}).get("user")
    if not user:
        print("GitHub API returned no user data", file=sys.stderr)
        return 1

    repos = user["repositories"]["nodes"]
    public = [r for r in repos if not r.get("isPrivate")]
    total_contribs = user["contributionsCollection"]["contributionCalendar"]["totalContributions"]
    top = sorted(public, key=lambda r: r.get("stargazerCount", 0), reverse=True)[:8]

    stats = {
        "user": USER,
        "updated": datetime.now(timezone.utc).strftime("%Y-%m-%d"),
        "total_contributions_last_year": total_contribs,
        "public_repos": len(public),
        "top_repos": [{"name": r["name"], "stars": r["stargazerCount"]} for r in top],
    }
    os.makedirs(os.path.dirname(STATS_JSON), exist_ok=True)
    with open(STATS_JSON, "w") as f:
        json.dump(stats, f, indent=2)

    block = "\n".join([
        f"**GitHub** ({stats['updated']}): {stats['total_contributions_last_year']} contributions in the last year;",
        f"{stats['public_repos']} public repositories.",
        "Top repos: " + ", ".join(f"{r['name']} ({r['stars']}★)" for r in top[:5]) + ".",
    ])

    text = open(RESUME).read()
    replacement = f"<!-- contribution-stats:start -->\n{block}\n<!-- contribution-stats:end -->"
    new_text, n = re.subn(
        r"<!-- contribution-stats:start -->.*?<!-- contribution-stats:end -->",
        replacement,
        text,
        count=1,
        flags=re.DOTALL,
    )
    if n:
        with open(RESUME, "w") as f:
            f.write(new_text)
        print(f"→ updated RESUME.md with GitHub stats")
    print(json.dumps(stats, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())