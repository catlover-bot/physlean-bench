#!/bin/bash
#SBATCH -J cslib_topk
#SBATCH -A lang
#SBATCH -p lang_long
#SBATCH -c 2
#SBATCH --mem=8G
#SBATCH -t 01:00:00
#SBATCH -o /project/nlp-work11/%u/theorem_generation/library_completion_topk_v0/logs/%x-%j.out
#SBATCH -e /project/nlp-work11/%u/theorem_generation/library_completion_topk_v0/logs/%x-%j.err

set -euxo pipefail

cd /project/nlp-work11/$USER/theorem_generation/library_completion_topk_v0

python3 - <<'PY'
import json
import math
import re
from pathlib import Path
from collections import Counter, defaultdict

base = Path("/project/nlp-work11") / Path.home().name / "theorem_generation/library_completion_topk_v0"

inp = base / "cslib_target_declarations_norm.jsonl"
out_nodes = base / "cslib_theorem_nodes_scored.jsonl"
out_edges = base / "cslib_candidate_edges_topk.jsonl"
out_summary = base / "summary_cslib_candidate_edges_topk.json"
out_preview = base / "preview_cslib_candidate_edges_topk.txt"

rows = [json.loads(line) for line in inp.open()]
nodes = [r for r in rows if r["kind"] in {"theorem", "lemma"}]

stop = {
    "theorem", "lemma", "def", "by", "where", "class", "structure",
    "prop", "type", "sort", "state", "label", "list", "set", "fun",
    "true", "false", "iff", "and", "or", "not", "forall", "exists",
    "cslib", "basic"
}

def split_tokens(s):
    parts = re.split(r"[^A-Za-z0-9α-ωΑ-Ω_']+", s)
    toks = []
    for p in parts:
        if not p:
            continue
        # split camel-ish and underscores
        p2 = re.sub(r"([a-z])([A-Z])", r"\1 \2", p)
        for q in re.split(r"[_\s.']+", p2):
            q = q.lower()
            if len(q) >= 3 and q not in stop:
                toks.append(q)
    return toks

def enrich(n):
    header = n.get("header", "")
    name = n["name"]
    toks = split_tokens(name + " " + header)
    n = dict(n)
    n["tokens"] = sorted(set(toks))
    n["token_count"] = len(n["tokens"])
    n["is_core_lts"] = int(any(x in name.lower() for x in ["mtr", "tr", "canreach", "trace", "simulation", "bisimulation"]))
    n["is_core_automata"] = int(any(x in name.lower() for x in ["accept", "language", "regular", "buchi", "automata"]))
    n["is_core_urm"] = int(any(x in name.lower() for x in ["urm", "halt", "instr", "computable", "program"]))
    n["is_core_logic"] = int(any(x in name.lower() for x in ["hml", "satisf", "formula", "logical"]))
    n["domain_score"] = (
        2.0 * n["is_core_lts"]
        + 1.5 * n["is_core_automata"]
        + 1.2 * n["is_core_urm"]
        + 1.2 * n["is_core_logic"]
        + 0.4 * len(n["family"])
    )
    return n

nodes = [enrich(n) for n in nodes]

def motif_tags(a, b):
    s = " ".join([
        a["name"], b["name"],
        a.get("header", ""), b.get("header", ""),
        " ".join(a["family"] + b["family"]),
    ]).lower()
    tags = []

    if "transition_lts" in a["family"] and "transition_lts" in b["family"]:
        tags.append("lts_transition_api")
    if any(x in s for x in ["mtr", "trace", "str", "execution"]) and any(x in s for x in ["comp", "single", "step", "nil", "append"]):
        tags.append("trace_composition")
    if any(x in s for x in ["simulation", "bisimulation", "traceeq", "equiv"]):
        tags.append("simulation_bisimulation")
    if "reachability_steps" in a["family"] or "reachability_steps" in b["family"]:
        tags.append("reachability_steps")
    if "automata_language" in a["family"] and "automata_language" in b["family"]:
        tags.append("automata_language")
    if any(x in s for x in ["accept", "language", "regular", "buchi", "omega"]):
        tags.append("acceptance_language_bridge")
    if "urm_computability" in a["family"] and "urm_computability" in b["family"]:
        tags.append("urm_computability")
    if any(x in s for x in ["halt", "bounded", "jump", "instr", "computable"]):
        tags.append("halt_bound_computation")
    if "ccs_process" in a["family"] or "modal_logic_hml" in a["family"] or "ccs_process" in b["family"] or "modal_logic_hml" in b["family"]:
        tags.append("ccs_hml_semantics")
    if "relation_equiv" in a["family"] and "relation_equiv" in b["family"]:
        tags.append("relation_equiv")
    if any(x in s for x in ["mono", "trans", "refl", "symm", "antisymm"]):
        tags.append("order_relation_law")

    return sorted(set(tags))

def score_pair(a, b):
    if a["name"] == b["name"]:
        return None

    ta, tb = set(a["tokens"]), set(b["tokens"])
    inter = ta & tb
    union = ta | tb
    jacc = len(inter) / len(union) if union else 0.0

    fam_inter = set(a["family"]) & set(b["family"])
    fam_score = 2.0 * len(fam_inter)

    same_file = a["file"] == b["file"]
    same_dir = str(Path(a["file"]).parent) == str(Path(b["file"]).parent)

    tags = motif_tags(a, b)
    if not tags:
        return None

    motif_score = 1.4 * len(tags)

    # prefer local API completion but not only same theorem name variants
    locality = 1.5 if same_file else (0.8 if same_dir else 0.2)

    # name-shape relation
    an = a["local_name"].lower()
    bn = b["local_name"].lower()
    prefix_bonus = 0.0
    if an.split("_")[0] == bn.split("_")[0]:
        prefix_bonus += 0.6
    if any(x in an for x in ["iff", "eq", "comp", "single", "refl", "trans", "mono"]) or any(x in bn for x in ["iff", "eq", "comp", "single", "refl", "trans", "mono"]):
        prefix_bonus += 0.4

    # penalize near-duplicates but not too strongly
    duplicate_risk = 0.0
    if a["local_name"] == b["local_name"]:
        duplicate_risk += 2.0
    if an.replace("_", "") == bn.replace("_", ""):
        duplicate_risk += 1.2

    score = (
        4.0 * jacc
        + fam_score
        + motif_score
        + locality
        + prefix_bonus
        + 0.15 * (a["domain_score"] + b["domain_score"])
        - duplicate_risk
    )

    if score < 2.5:
        return None

    return {
        "source": a["name"],
        "target": b["name"],
        "source_kind": a["kind"],
        "target_kind": b["kind"],
        "source_file": a["file"],
        "target_file": b["file"],
        "source_line": a["line"],
        "target_line": b["line"],
        "source_family": a["family"],
        "target_family": b["family"],
        "shared_tokens": sorted(inter)[:40],
        "shared_token_count": len(inter),
        "motifs": tags,
        "same_file": same_file,
        "same_dir": same_dir,
        "score": round(score, 6),
        "source_header": a["header"],
        "target_header": b["header"],
    }

edges_by_source = defaultdict(list)

for i, a in enumerate(nodes):
    best = []
    for j, b in enumerate(nodes):
        if i == j:
            continue
        e = score_pair(a, b)
        if e is not None:
            best.append(e)
    best.sort(key=lambda x: x["score"], reverse=True)
    edges_by_source[a["name"]] = best[:12]

edges = [e for xs in edges_by_source.values() for e in xs]
edges.sort(key=lambda x: x["score"], reverse=True)

for rank, e in enumerate(edges, 1):
    e["rank"] = rank

with out_nodes.open("w") as f:
    for n in nodes:
        f.write(json.dumps(n, ensure_ascii=False) + "\n")

with out_edges.open("w") as f:
    for e in edges:
        f.write(json.dumps(e, ensure_ascii=False) + "\n")

summary = {
    "input_declarations": len(rows),
    "theorem_lemma_nodes": len(nodes),
    "candidate_edges": len(edges),
    "source_nodes_with_edges": len(edges_by_source),
    "target_nodes_hit": len(set(e["target"] for e in edges)),
    "family_counts": dict(Counter(f for n in nodes for f in n["family"])),
    "motif_counts": dict(Counter(m for e in edges for m in e["motifs"])),
    "score_range": [min((e["score"] for e in edges), default=None), max((e["score"] for e in edges), default=None)],
}
out_summary.write_text(json.dumps(summary, ensure_ascii=False, indent=2) + "\n")

with out_preview.open("w") as f:
    for e in edges[:120]:
        f.write(f"EDGE {e['rank']:04d} score={e['score']:.3f} motifs={','.join(e['motifs'])}\n")
        f.write(f"  SRC {e['source']}\n")
        f.write(f"      file={e['source_file']}:{e['source_line']} family={','.join(e['source_family'])}\n")
        f.write(f"      {e['source_header'].splitlines()[0][:220]}\n")
        f.write(f"  TGT {e['target']}\n")
        f.write(f"      file={e['target_file']}:{e['target_line']} family={','.join(e['target_family'])}\n")
        f.write(f"      {e['target_header'].splitlines()[0][:220]}\n")
        f.write(f"  shared={','.join(e['shared_tokens'][:20])}\n\n")

print("saved nodes:", out_nodes)
print("saved edges:", out_edges)
print("saved summary:", out_summary)
print("saved preview:", out_preview)
print("theorem_lemma_nodes:", len(nodes))
print("candidate_edges:", len(edges))
print("motif_counts:", summary["motif_counts"])
print("score_range:", summary["score_range"])
print()
print(out_preview.read_text()[:5000])
PY
