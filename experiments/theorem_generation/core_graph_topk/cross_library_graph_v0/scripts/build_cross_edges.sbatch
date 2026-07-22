#!/bin/bash
#SBATCH -J cross_graph
#SBATCH -A lang
#SBATCH -p lang_long
#SBATCH -c 8
#SBATCH --mem=32G
#SBATCH -t 02:00:00
#SBATCH -o /project/nlp-work11/%u/theorem_generation/cross_library_graph_v0/logs/%x-%j.out
#SBATCH -e /project/nlp-work11/%u/theorem_generation/cross_library_graph_v0/logs/%x-%j.err

set -euxo pipefail

python3 - <<'PY'
import json
import re
from pathlib import Path
from collections import Counter

user = Path.home().name

in_root = Path("/project/nlp-work11") / user / "theorem_generation/theorem_graph_topk_v0"
out_root = Path("/project/nlp-work11") / user / "theorem_generation/cross_library_graph_v0/out"
out_root.mkdir(parents=True, exist_ok=True)

nodes_path = in_root / "nodes.jsonl"
out_path = out_root / "physlib_cslib_cross_edges_topk.jsonl"
summary_path = out_root / "summary.json"

def lib_of(r):
    name = r.get("declaration_name", "")
    fp = r.get("file_path", "")
    if "Cslib" in name or "Cslib" in fp or "/cslib/" in fp.lower():
        return "CSLib"
    return "Physlib"

def toks(s):
    s = re.sub(r"[^A-Za-z0-9_α-ωΑ-Ωℏμ₀ε₀ω₀]+", " ", s)
    xs = [x for x in s.split() if len(x) >= 2]
    stop = {
        "theorem", "lemma", "def", "Prop", "Type", "Sort",
        "fun", "by", "have", "show", "exact", "simp",
        "Nat", "Int", "Rat", "Real", "Fin", "List", "Vector",
    }
    return set(x for x in xs if x not in stop)

nodes = []
for i, line in enumerate(nodes_path.open()):
    r = json.loads(line)
    r["_idx"] = i
    r["_id"] = r.get("id") or r.get("node_id") or r.get("declaration_name") or str(i)
    r["_lib"] = lib_of(r)
    text = " ".join([
        str(r.get("declaration_name", "")),
        str(r.get("statement", "")),
        str(r.get("type", "")),
        str(r.get("file_path", "")),
    ])
    r["_tokens"] = toks(text)
    nodes.append(r)

phys = [r for r in nodes if r["_lib"] == "Physlib"]
cs = [r for r in nodes if r["_lib"] == "CSLib"]

edges = []

def score_pair(a, b):
    ta, tb = a["_tokens"], b["_tokens"]
    if not ta or not tb:
        return 0.0, []
    inter = ta & tb
    if not inter:
        return 0.0, []
    union = ta | tb
    jacc = len(inter) / len(union)
    bonus = 0.0

    an = a.get("declaration_name", "")
    bn = b.get("declaration_name", "")
    af = a.get("file_path", "")
    bf = b.get("file_path", "")

    aleaf = an.split(".")[-1]
    bleaf = bn.split(".")[-1]
    if aleaf == bleaf:
        bonus += 0.50
    if aleaf.lower() == bleaf.lower():
        bonus += 0.25
    if any(x in inter for x in ["linear", "basis", "sum", "matrix", "vector", "graph", "path", "finite", "rank", "degree"]):
        bonus += 0.15
    if af.split("/")[-1] == bf.split("/")[-1]:
        bonus += 0.10

    score = jacc + bonus
    return score, sorted(inter)

for direction, left, right in [
    ("Physlib->CSLib", phys, cs),
    ("CSLib->Physlib", cs, phys),
]:
    for a in left:
        best = []
        for b in right:
            score, inter = score_pair(a, b)
            if score <= 0:
                continue
            best.append((score, a, b, inter))
        best.sort(key=lambda x: x[0], reverse=True)
        for score, a, b, inter in best[:10]:
            edges.append({
                "direction": direction,
                "source": a["_id"],
                "target": b["_id"],
                "source_name": a.get("declaration_name", ""),
                "target_name": b.get("declaration_name", ""),
                "source_file": a.get("file_path", ""),
                "target_file": b.get("file_path", ""),
                "score": round(score, 6),
                "shared_tokens": inter[:30],
            })

with out_path.open("w") as f:
    for e in edges:
        f.write(json.dumps(e, ensure_ascii=False) + "\n")

counts = Counter(e["direction"] for e in edges)

summary = {
    "physlib_nodes": len(phys),
    "cslib_nodes": len(cs),
    "cross_edges": len(edges),
    "counts": dict(counts),
    "out_path": str(out_path),
}

summary_path.write_text(json.dumps(summary, ensure_ascii=False, indent=2))

print(json.dumps(summary, ensure_ascii=False, indent=2))
print()
print("=== top 20 cross edges ===")
for e in sorted(edges, key=lambda x: x["score"], reverse=True)[:20]:
    print(e["score"], e["direction"], e["source_name"], "->", e["target_name"])
PY
