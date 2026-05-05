import json
from pathlib import Path
from collections import Counter, defaultdict

OUT = Path("/project/nlp-work11/hirotaka-m/crossdomain_trace/cslib_bench_v0")
OUT.mkdir(parents=True, exist_ok=True)

sources = []

# Automata run is outside cslib_parts.
auto = Path("/project/nlp-work11/hirotaka-m/crossdomain_trace/cslib_automata_rc2/traced_theorems.jsonl")
if auto.exists():
    sources.append(auto)

# All successful prefix/file-level trace outputs.
parts_dir = Path("/project/nlp-work11/hirotaka-m/crossdomain_trace/cslib_parts")
sources.extend(sorted(parts_dir.glob("*/traced_theorems.jsonl")))

seen = set()
rows = []
dups = 0
source_counts = {}

for src in sources:
    n_src = 0
    for line in src.open():
        r = json.loads(line)

        key = r.get("theorem_id") or (
            r.get("declaration_name"),
            r.get("file_path"),
            r.get("line_start"),
            r.get("line_end"),
        )

        if key in seen:
            dups += 1
            continue
        seen.add(key)

        rr = dict(r)
        rr["benchmark"] = "cslib_bench_v0"
        rr["source_library"] = "cslib"
        rr["domain"] = "computer_science"
        rr["trace_source_jsonl"] = str(src)

        fp = rr.get("file_path", "")
        parts = fp.split("/")
        rr["top_dir"] = parts[0] if len(parts) > 0 else "UNKNOWN"
        rr["subdomain"] = parts[1] if len(parts) > 1 else "UNKNOWN"
        rr["subdomain2"] = parts[2] if len(parts) > 2 else "UNKNOWN"
        rr["subdomain3"] = parts[3] if len(parts) > 3 else "UNKNOWN"

        rows.append(rr)
        n_src += 1

    source_counts[str(src)] = n_src

clean = []
for r in rows:
    if r.get("has_sorry") or r.get("has_admit"):
        continue
    if not r.get("statement"):
        continue
    if not r.get("proof_text"):
        continue
    clean.append(r)

def write_jsonl(path: Path, data):
    with path.open("w") as f:
        for r in data:
            f.write(json.dumps(r, ensure_ascii=False) + "\n")

write_jsonl(OUT / "merged_raw.jsonl", rows)
write_jsonl(OUT / "clean.jsonl", clean)

by_file = Counter(r.get("file_path") for r in clean)
by_subdomain = Counter(r.get("subdomain") for r in clean)
by_subdomain2 = Counter(f"{r.get('subdomain')}/{r.get('subdomain2')}" for r in clean)
by_subdomain3 = Counter(f"{r.get('subdomain')}/{r.get('subdomain2')}/{r.get('subdomain3')}" for r in clean)

premise_lengths = [len(r.get("used_premises") or []) for r in clean]

summary = {
    "benchmark": "cslib_bench_v0",
    "source_library": "cslib",
    "num_sources": len(sources),
    "source_counts": source_counts,
    "raw_records": len(rows),
    "clean_records": len(clean),
    "duplicates_removed": dups,
    "files": len(by_file),
    "by_subdomain": dict(by_subdomain),
    "by_subdomain2": dict(by_subdomain2),
    "by_subdomain3": dict(by_subdomain3),
    "proof_extraction_method_counts": dict(Counter(r.get("proof_extraction_method") for r in clean)),
    "used_premises": {
        "nonempty": sum(bool(r.get("used_premises")) for r in clean),
        "avg": sum(premise_lengths) / len(premise_lengths) if premise_lengths else 0,
        "max": max(premise_lengths) if premise_lengths else 0,
    },
}

(OUT / "summary.json").write_text(json.dumps(summary, indent=2, ensure_ascii=False))

print(json.dumps(summary, indent=2, ensure_ascii=False))
print("wrote:", OUT)
