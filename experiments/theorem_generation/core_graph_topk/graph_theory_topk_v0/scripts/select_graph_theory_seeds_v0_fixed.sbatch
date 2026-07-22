#!/bin/bash
#SBATCH -J sg_seed100_fix
#SBATCH -A lang
#SBATCH -p lang_long
#SBATCH -c 2
#SBATCH --mem=8G
#SBATCH -t 01:00:00
#SBATCH -o /project/nlp-work11/%u/theorem_generation/graph_theory_topk_v0/logs/%x-%j.out
#SBATCH -e /project/nlp-work11/%u/theorem_generation/graph_theory_topk_v0/logs/%x-%j.err

set -euxo pipefail

python3 - <<'PY'
import json
from pathlib import Path
from collections import Counter

base = Path("/project/nlp-work11") / Path.home().name / "theorem_generation/graph_theory_topk_v0"

in_edges = base / "simplegraph_candidate_edges_topk.jsonl"
out_seeds = base / "simplegraph_topk_seeds_v0.jsonl"
out_summary = base / "summary_topk_seeds_v0.json"
out_preview = base / "preview_topk_seeds_v0.txt"

edges = [json.loads(line) for line in in_edges.open()]
edges.sort(key=lambda e: e["score"], reverse=True)

target_k = 100
selected = []
remaining = edges[:]

source_count = Counter()
target_count = Counter()
motif_count = Counter()
family_pair_count = Counter()
file_pair_count = Counter()

def key_family(e):
    return tuple(sorted(set(e["source_family"] + e["target_family"])))

def key_file_pair(e):
    return (e["source_file"], e["target_file"])

def diversity_penalty(e):
    penalty = 0.0
    penalty += 2.5 * source_count[e["source"]]
    penalty += 2.5 * target_count[e["target"]]
    penalty += 1.2 * family_pair_count[key_family(e)]
    penalty += 1.0 * file_pair_count[key_file_pair(e)]
    for m in e["motifs"]:
        penalty += 0.8 * motif_count[m]
    if e["source_file"] == e["target_file"]:
        penalty += 0.8
    return penalty

def value_bonus(e):
    motifs = set(e["motifs"])
    bonus = 0.0
    if "subgraph_monotonicity" in motifs:
        bonus += 2.5
    if "adj_edgeSet_bridge" in motifs:
        bonus += 2.0
    if "walk_path_connectivity" in motifs:
        bonus += 2.0
    if "complement_duality" in motifs:
        bonus += 1.8
    if "finite_cardinality" in motifs:
        bonus += 1.5
    if "map_transport" in motifs:
        bonus += 1.2
    if e["source_file"] != e["target_file"]:
        bonus += 1.0
    return bonus

while remaining and len(selected) < target_k:
    best_idx = None
    best_score = None

    scan_n = min(5000, len(remaining))
    for idx in range(scan_n):
        e = remaining[idx]
        mmr_score = e["score"] + value_bonus(e) - diversity_penalty(e)
        if best_score is None or mmr_score > best_score:
            best_idx = idx
            best_score = mmr_score

    if best_idx is None:
        break

    raw_best = remaining.pop(best_idx)
    best = dict(raw_best)
    best["seed_rank"] = len(selected) + 1
    best["mmr_score"] = round(best_score, 6)
    selected.append(best)

    source_count[best["source"]] += 1
    target_count[best["target"]] += 1
    family_pair_count[key_family(best)] += 1
    file_pair_count[key_file_pair(best)] += 1
    for m in best["motifs"]:
        motif_count[m] += 1

with out_seeds.open("w") as f:
    for e in selected:
        f.write(json.dumps(e, ensure_ascii=False) + "\n")

summary = {
    "input_edges": len(edges),
    "selected": len(selected),
    "motif_counts": dict(motif_count),
    "source_family_counts": dict(Counter(f for e in selected for f in e["source_family"])),
    "target_family_counts": dict(Counter(f for e in selected for f in e["target_family"])),
    "unique_sources": len(set(e["source"] for e in selected)),
    "unique_targets": len(set(e["target"] for e in selected)),
    "unique_source_files": len(set(e["source_file"] for e in selected)),
    "unique_target_files": len(set(e["target_file"] for e in selected)),
    "score_range": [
        min(e["score"] for e in selected) if selected else None,
        max(e["score"] for e in selected) if selected else None,
    ],
    "mmr_score_range": [
        min(e["mmr_score"] for e in selected) if selected else None,
        max(e["mmr_score"] for e in selected) if selected else None,
    ],
}
out_summary.write_text(json.dumps(summary, ensure_ascii=False, indent=2) + "\n")

with out_preview.open("w") as f:
    for e in selected:
        f.write(f"SEED {e['seed_rank']:03d} score={e['score']:.3f} mmr={e['mmr_score']:.3f} motifs={','.join(e['motifs'])}\n")
        f.write(f"  SRC {e['source']}\n")
        f.write(f"      family={','.join(e['source_family'])} file={e['source_file']}\n")
        f.write(f"      {e['source_header'].splitlines()[0][:220]}\n")
        f.write(f"  TGT {e['target']}\n")
        f.write(f"      family={','.join(e['target_family'])} file={e['target_file']}\n")
        f.write(f"      {e['target_header'].splitlines()[0][:220]}\n\n")

print("saved seeds:", out_seeds)
print("saved summary:", out_summary)
print("saved preview:", out_preview)
print("selected:", len(selected))
print("motif_counts:", dict(motif_count))
print("unique_sources:", summary["unique_sources"])
print("unique_targets:", summary["unique_targets"])
print("unique_source_files:", summary["unique_source_files"])
print("unique_target_files:", summary["unique_target_files"])
print("score_range:", summary["score_range"])
print("mmr_score_range:", summary["mmr_score_range"])
PY
