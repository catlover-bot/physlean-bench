import json
import hashlib
from pathlib import Path
from collections import Counter

BASE = Path("/project/nlp-work11/hirotaka-m/crossdomain_trace/cslib_bench_v0")
src = BASE / "clean.jsonl"

rows = [json.loads(l) for l in src.open()]

def hfile(fp: str) -> int:
    h = hashlib.sha256(fp.encode()).hexdigest()
    return int(h[:8], 16) % 100

splits = {"train": [], "valid": [], "test": []}

# File-level split to reduce leakage across nearby theorems in the same file.
for r in rows:
    h = hfile(r.get("file_path", ""))
    if h < 75:
        s = "train"
    elif h < 87:
        s = "valid"
    else:
        s = "test"

    rr = dict(r)
    rr["split"] = s
    splits[s].append(rr)

for s, data in splits.items():
    with (BASE / f"{s}.jsonl").open("w") as f:
        for r in data:
            f.write(json.dumps(r, ensure_ascii=False) + "\n")

summary = {
    "benchmark": "cslib_bench_v0",
    "n": len(rows),
    "split_counts": {k: len(v) for k, v in splits.items()},
    "files_by_split": {
        k: len(set(r.get("file_path") for r in v))
        for k, v in splits.items()
    },
    "subdomain_by_split": {
        k: dict(Counter(r.get("subdomain") for r in v))
        for k, v in splits.items()
    },
    "subdomain2_by_split": {
        k: dict(Counter(f"{r.get('subdomain')}/{r.get('subdomain2')}" for r in v))
        for k, v in splits.items()
    },
}

(BASE / "split_summary.json").write_text(json.dumps(summary, indent=2, ensure_ascii=False))
print(json.dumps(summary, indent=2, ensure_ascii=False))
