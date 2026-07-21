#!/bin/bash
#SBATCH -J cross_topk_v2
#SBATCH -A lang
#SBATCH -p lang_long
#SBATCH -c 8
#SBATCH --mem=32G
#SBATCH -t 02:00:00
#SBATCH -o /project/nlp-work11/%u/theorem_generation/cross_library_graph_v2/logs/%x-%j.out
#SBATCH -e /project/nlp-work11/%u/theorem_generation/cross_library_graph_v2/logs/%x-%j.err

set -euxo pipefail

python3 - <<'PY'
import json
import math
import re
from pathlib import Path
from collections import Counter, defaultdict

user = Path.home().name

TOPK = 10

in_root = Path("/project/nlp-work11") / user / "theorem_generation/theorem_graph_topk_v0"
nodes_path = in_root / "nodes.jsonl"

out_root = Path("/project/nlp-work11") / user / "theorem_generation/cross_library_graph_v2/out"
out_root.mkdir(parents=True, exist_ok=True)

out_edges = out_root / "cross_library_edges_topk_complete.jsonl"
out_nodes = out_root / "cross_library_nodes.jsonl"
out_summary = out_root / "summary.json"
out_top = out_root / "top_edges_preview.txt"

generic = {
    "lean", "basic", "theorem", "lemma", "def", "prop", "type", "sort",
    "sum", "inl", "inr", "left", "right", "fst", "snd",
    "ext", "mk", "coe", "symm", "refl", "trans", "congr",
    "zero", "one", "add", "sub", "mul", "div", "neg", "inv",
    "map", "map_id", "map_map", "comp", "id", "rfl",
    "h", "h1", "h2", "ha", "hb", "this",
    "nat", "int", "rat", "real", "fin", "list", "set",
    "eq", "ne", "lt", "le", "gt", "ge", "iff", "forall", "exists",
    "apply", "simp", "exact", "using", "intro",
}

concept_words = {
    "linear", "basis", "vector", "matrix", "rank", "finite", "dimension",
    "state", "transition", "relation", "steps", "path", "graph",
    "language", "regular", "grammar", "automaton", "sequence", "word",
    "logic", "proof", "term", "machine", "register", "urm", "ski",
    "tensor", "permutation", "perm", "cycle",
    "charge", "anomaly", "spectrum", "field", "space", "time",
    "lorentz", "quantum", "classical", "mechanics", "electromagnetism",
    "potential", "frequency", "oscillator", "temperature", "boltzmann",
    "bounded", "bisimulation", "program", "semantics", "syntax",
}

bad_leaf = {
    "ext", "mk", "coe", "symm", "refl", "trans", "congr",
    "map_id", "map_map", "comp", "zero", "one", "le_def", "inv",
    "add", "sub", "mul", "neg", "ofNat", "default",
}

def split_words(s):
    s = str(s)
    s = re.sub(r"([a-z])([A-Z])", r"\1 \2", s)
    s = re.sub(r"[^A-Za-z0-9_α-ωΑ-Ωℏμ₀ε₀ω₀]+", " ", s)
    out = []
    for x in s.split():
        x = x.strip("_")
        xl = x.lower()
        if len(xl) < 3:
            continue
        if xl in generic:
            continue
        out.append(xl)
    return set(out)

def lib_of(r):
    name = r.get("declaration_name", "")
    fp = r.get("file_path", "")
    if "Cslib" in name or "Cslib" in fp or "/cslib/" in fp.lower():
        return "CSLib"
    return "Physlib"

def leaf(name):
    return str(name).split(".")[-1]

def namespace_tokens(name):
    parts = str(name).split(".")[:-1]
    return split_words(" ".join(parts))

def jacc(a, b):
    if not a or not b:
        return 0.0
    return len(a & b) / len(a | b)

nodes = []
for i, line in enumerate(nodes_path.open()):
    r = json.loads(line)

    name = r.get("declaration_name", "")
    fp = r.get("file_path", "")
    stmt = r.get("statement", "") or r.get("type", "")

    rr = {
        "id": r.get("id") or r.get("node_id") or name or str(i),
        "declaration_name": name,
        "file_path": fp,
        "library": lib_of(r),
        "statement": stmt,
    }

    rr["leaf"] = leaf(name)
    rr["decl_tokens"] = split_words(name)
    rr["path_tokens"] = split_words(fp)
    rr["namespace_tokens"] = namespace_tokens(name)
    rr["statement_tokens"] = split_words(stmt)
    rr["semantic_tokens"] = rr["decl_tokens"] | rr["path_tokens"] | rr["namespace_tokens"]
    rr["concept_tokens"] = rr["semantic_tokens"] & concept_words
    rr["all_tokens"] = rr["semantic_tokens"] | rr["statement_tokens"]

    nodes.append(rr)

phys = [n for n in nodes if n["library"] == "Physlib"]
cs = [n for n in nodes if n["library"] == "CSLib"]

def score(a, b):
    if a["leaf"] in bad_leaf or b["leaf"] in bad_leaf:
        return 0.0, []

    shared_concepts = a["concept_tokens"] & b["concept_tokens"]
    shared_semantic = a["semantic_tokens"] & b["semantic_tokens"]
    shared_stmt = a["statement_tokens"] & b["statement_tokens"]
    shared_all = (a["all_tokens"] & b["all_tokens"]) - generic

    if not shared_all:
        return 0.0, []

    s = 0.0
    reasons = []

    if shared_concepts:
        s += 2.5 * len(shared_concepts)
        reasons.append("shared_concepts=" + ",".join(sorted(shared_concepts)))

    if shared_semantic:
        s += 1.2 * len(shared_semantic)
        reasons.append("shared_semantic=" + ",".join(sorted(shared_semantic)[:12]))

    if shared_stmt:
        s += 0.35 * len(shared_stmt)
        reasons.append("shared_statement=" + ",".join(sorted(shared_stmt)[:12]))

    s += 1.5 * jacc(a["semantic_tokens"], b["semantic_tokens"])
    s += 0.5 * jacc(a["all_tokens"], b["all_tokens"])

    if a["leaf"].lower() == b["leaf"].lower():
        s += 0.75
        reasons.append("same_leaf")

    if a["file_path"].split("/")[-1] == b["file_path"].split("/")[-1]:
        s += 0.25
        reasons.append("same_file_leaf")

    # 完全に表面的な一致だけの候補を弱める
    if shared_all <= {"linear", "space"}:
        s *= 0.6
        reasons.append("penalty_too_broad_linear_space")

    if shared_all <= {"sum", "inl", "inr"}:
        s = 0.0

    return s, reasons

edges = []

def add_topk_edges(left, right, direction):
    for a in left:
        scored = []
        for b in right:
            s, reasons = score(a, b)
            if s <= 0:
                continue
            scored.append((s, a, b, reasons))

        scored.sort(key=lambda x: x[0], reverse=True)

        for rank, (s, a, b, reasons) in enumerate(scored[:TOPK], 1):
            edges.append({
                "direction": direction,
                "rank": rank,
                "source": a["id"],
                "target": b["id"],
                "source_name": a["declaration_name"],
                "target_name": b["declaration_name"],
                "source_file": a["file_path"],
                "target_file": b["file_path"],
                "score": round(s, 6),
                "shared_concepts": sorted(a["concept_tokens"] & b["concept_tokens"]),
                "shared_semantic_tokens": sorted(a["semantic_tokens"] & b["semantic_tokens"])[:30],
                "shared_statement_tokens": sorted(a["statement_tokens"] & b["statement_tokens"])[:30],
                "reasons": reasons,
            })

add_topk_edges(phys, cs, "Physlib->CSLib")
add_topk_edges(cs, phys, "CSLib->Physlib")

with out_nodes.open("w") as f:
    for n in nodes:
        slim = {
            "id": n["id"],
            "library": n["library"],
            "declaration_name": n["declaration_name"],
            "file_path": n["file_path"],
            "leaf": n["leaf"],
            "concept_tokens": sorted(n["concept_tokens"]),
            "semantic_tokens": sorted(n["semantic_tokens"])[:80],
        }
        f.write(json.dumps(slim, ensure_ascii=False) + "\n")

with out_edges.open("w") as f:
    for e in edges:
        f.write(json.dumps(e, ensure_ascii=False) + "\n")

direction_counts = Counter(e["direction"] for e in edges)
source_degree = Counter(e["source"] for e in edges)
target_degree = Counter(e["target"] for e in edges)

summary = {
    "topk": TOPK,
    "physlib_nodes": len(phys),
    "cslib_nodes": len(cs),
    "cross_edges": len(edges),
    "direction_counts": dict(direction_counts),
    "source_nodes_with_edges": len(source_degree),
    "target_nodes_hit": len(target_degree),
    "avg_out_degree_over_all_nodes": len(edges) / max(1, len(phys) + len(cs)),
    "max_score": max((e["score"] for e in edges), default=0),
    "min_score": min((e["score"] for e in edges), default=0),
    "nodes_path": str(out_nodes),
    "edges_path": str(out_edges),
}

out_summary.write_text(json.dumps(summary, ensure_ascii=False, indent=2))

top_edges = sorted(edges, key=lambda e: e["score"], reverse=True)[:100]
with out_top.open("w") as f:
    for e in top_edges:
        f.write(
            f'{e["score"]}\t{e["direction"]}\t{e["rank"]}\t'
            f'{e["source_name"]} -> {e["target_name"]}\t'
            f'concepts={",".join(e["shared_concepts"])}\n'
        )

print(json.dumps(summary, ensure_ascii=False, indent=2))
print()
print("=== top 40 complete cross-library top-k edges ===")
for e in top_edges[:40]:
    print(
        e["score"],
        e["direction"],
        "rank", e["rank"],
        e["source_name"],
        "->",
        e["target_name"],
        "| concepts:",
        ",".join(e["shared_concepts"]),
    )
PY
