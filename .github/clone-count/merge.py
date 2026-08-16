"""Merge the 14-day traffic window into the cumulative clone history.

Vendored from MShawon/github-clone-count-badge (MIT) instead of curl-ing it
into CI at runtime, so a change upstream cannot alter what this workflow runs.
"""
import json
import pathlib

HERE = pathlib.Path(__file__).parent
STORE = HERE / "clone.json"
LATEST = pathlib.Path("clone_latest.json")

now = json.loads(LATEST.read_text())
before = json.loads(STORE.read_text()) if STORE.exists() else {"clones": []}

merged = dict(before)
merged.setdefault("clones", [])
index = {bucket["timestamp"]: i for i, bucket in enumerate(merged["clones"])}

for bucket in now.get("clones", []):
    stamp = bucket["timestamp"]
    if stamp in index:
        merged["clones"][index[stamp]] = bucket
    else:
        index[stamp] = len(merged["clones"])
        merged["clones"].append(bucket)

merged["count"] = sum(int(b["count"]) for b in merged["clones"])
merged["uniques"] = sum(int(b["uniques"]) for b in merged["clones"])

STORE.write_text(json.dumps(merged, ensure_ascii=False, indent=4) + "\n")
print(f"count={merged['count']} uniques={merged['uniques']} buckets={len(merged['clones'])}")
