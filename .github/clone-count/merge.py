"""Recompute the install counter from silimon release asset downloads.

Every `brew install silimon` downloads the release tarball named in the
formula, so summed asset download_count is a direct install proxy - and the
releases API is public, so this needs no PAT and cannot expire.

Writes .github/clone-count/clone.json with a top-level "count" key, which is
what the shields.io badge queries.
"""
import json
import os
import pathlib
import urllib.request

REPO = os.environ.get("SOURCE_REPO", "odfalik/silimon")
TOKEN = os.environ.get("GH_TOKEN")
OUT = pathlib.Path(__file__).parent / "clone.json"


def fetch(url):
    req = urllib.request.Request(url, headers={
        "Accept": "application/vnd.github+json",
        "User-Agent": "silimon-install-counter",
        **({"Authorization": f"Bearer {TOKEN}"} if TOKEN else {}),
    })
    with urllib.request.urlopen(req, timeout=30) as r:
        return json.load(r), r.headers.get("Link", "")


releases, page = [], 1
while True:
    batch, link = fetch(f"https://api.github.com/repos/{REPO}/releases?per_page=100&page={page}")
    releases.extend(batch)
    if not batch or 'rel="next"' not in link:
        break
    page += 1

per_release = {}
total = 0
for rel in releases:
    n = sum(int(a["download_count"]) for a in rel.get("assets", []))
    if n:
        per_release[rel["tag_name"]] = n
    total += n

SOURCE = f"{REPO} release asset downloads"

# Only trust a previous count that came from THIS source. The file used to hold
# a clone count from a different metric entirely; comparing against that would
# pin the badge forever.
previous = 0
if OUT.exists():
    try:
        prior = json.loads(OUT.read_text())
        if prior.get("source") == SOURCE:
            previous = int(prior.get("count", 0))
    except (ValueError, json.JSONDecodeError):
        previous = 0

# The counter is monotonic: GitHub can drop a release, but an install that
# already happened did happen. Never let the badge go backwards.
count = max(total, previous)

OUT.write_text(json.dumps({
    "count": count,
    "downloads": total,
    "releases": len(releases),
    "per_release": per_release,
    "source": SOURCE,
}, indent=4) + "\n")
print(f"count={count} downloads={total} releases={len(releases)} previous={previous}")
