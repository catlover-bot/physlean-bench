#!/bin/bash
#SBATCH -J sg_safe_seeds
#SBATCH -A lang
#SBATCH -p lang_long
#SBATCH -c 2
#SBATCH --mem=8G
#SBATCH -t 00:30:00
#SBATCH -o /project/nlp-work11/%u/theorem_generation/graph_theory_topk_v0/logs/%x-%j.out
#SBATCH -e /project/nlp-work11/%u/theorem_generation/graph_theory_topk_v0/logs/%x-%j.err

set -euxo pipefail

python3 - <<'PY'
import json
from pathlib import Path
from collections import Counter

base = Path("/project/nlp-work11") / Path.home().name / "theorem_generation/graph_theory_topk_v0"

in_path = base / "simplegraph_topk_seeds_v0.jsonl"
out_path = base / "simplegraph_template_safe_seeds_v0.jsonl"
summary_path = base / "summary_template_safe_seeds_v0.json"
preview_path = base / "preview_template_safe_seeds_v0.txt"

seeds = [json.loads(line) for line in in_path.open()]

def classify_template(e):
    motifs = set(e["motifs"])
    sf = set(e["source_family"])
    tf = set(e["target_family"])
    both = sf | tf

    # Prefer local, API-completion-style candidates.
    if "subgraph_monotonicity" in motifs and {"subgraph", "adjacency"} <= both:
        return "subgraph_adjacency_lift"

    if "subgraph_monotonicity" in motifs and "walk" in both:
        return "subgraph_walk_lift"

    if "subgraph_monotonicity" in motifs and ("path" in both or "connectivity" in both):
        return "subgraph_path_connectivity_lift"

    if "adj_edgeSet_bridge" in motifs and {"adjacency", "edgeSet"} <= both:
        return "adj_edgeSet_bridge"

    if "complement_duality" in motifs and "complement" in both and "adjacency" in both:
        return "complement_adjacency_dual"

    if "finite_cardinality" in motifs and ("degree_neighbor" in both or "edgeSet" in both):
        return "finite_degree_edge_cardinality"

    if "walk_path_connectivity" in motifs and "walk" in both and ("path" in both or "connectivity" in both):
        return "walk_path_connectivity"

    if "map_transport" in motifs and "map" in both and ("walk" in both or "adjacency" in both or "subgraph" in both):
        return "map_transport"

    return None

def safe_score(e, template):
    score = e["score"]

    # avoid too remote matching-specific / laplacian-heavy seeds in first proof experiment
    risky_files = ["Matching.lean", "LapMatrix.lean", "Ends/Defs.lean"]
    if any(r in e["source_file"] for r in risky_files):
        score -= 4.0
    if any(r in e["target_file"] for r in risky_files):
        score -= 4.0

    # prefer same directory or nearby API files
    if Path(e["source_file"]).parent == Path(e["target_file"]).parent:
        score += 1.5

    # prefer clear API-completion templates
    template_bonus = {
        "subgraph_adjacency_lift": 4.0,
        "subgraph_walk_lift": 3.5,
        "adj_edgeSet_bridge": 3.5,
        "walk_path_connectivity": 3.0,
        "complement_adjacency_dual": 2.8,
        "finite_degree_edge_cardinality": 2.5,
        "map_transport": 2.0,
        "subgraph_path_connectivity_lift": 2.0,
    }
    score += template_bonus.get(template, 0.0)

    return round(score, 6)

safe = []
for e in seeds:
    template = classify_template(e)
    if template is None:
        continue
    e = dict(e)
    e["template"] = template
    e["safe_score"] = safe_score(e, template)
    safe.append(e)

safe.sort(key=lambda e: e["safe_score"], reverse=True)

# diversity cap by template and source/target file pair
selected = []
template_count = Counter()
file_pair_count = Counter()
source_count = Counter()
target_count = Counter()

for e in safe:
    fp = (e["source_file"], e["target_file"])
    if template_count[e["template"]] >= 12:
        continue
    if file_pair_count[fp] >= 3:
        continue
    if source_count[e["source"]] >= 2:
        continue
    if target_count[e["target"]] >= 2:
        continue

    e = dict(e)
    e["safe_rank"] = len(selected) + 1
    selected.append(e)

    template_count[e["template"]] += 1
    file_pair_count[fp] += 1
    source_count[e["source"]] += 1
    target_count[e["target"]] += 1

    if len(selected) >= 50:
        break

with out_path.open("w") as f:
    for e in selected:
        f.write(json.dumps(e, ensure_ascii=False) + "\n")

summary = {
    "input_seeds": len(seeds),
    "safe_candidates": len(safe),
    "selected": len(selected),
    "template_counts": dict(template_count),
    "source_files": dict(Counter(e["source_file"] for e in selected)),
    "target_files": dict(Counter(e["target_file"] for e in selected)),
    "safe_score_range": [
        min(e["safe_score"] for e in selected) if selected else None,
        max(e["safe_score"] for e in selected) if selected else None,
    ],
}
summary_path.write_text(json.dumps(summary, ensure_ascii=False, indent=2) + "\n")

with preview_path.open("w") as f:
    for e in selected:
        f.write(f"SAFE {e['safe_rank']:03d} template={e['template']} safe_score={e['safe_score']:.3f} original_score={e['score']:.3f}\n")
        f.write(f"  SRC {e['source']}\n")
        f.write(f"      {e['source_file']}\n")
        f.write(f"      {e['source_header'].splitlines()[0][:220]}\n")
        f.write(f"  TGT {e['target']}\n")
        f.write(f"      {e['target_file']}\n")
        f.write(f"      {e['target_header'].splitlines()[0][:220]}\n\n")

print("saved safe seeds:", out_path)
print("saved summary:", summary_path)
print("saved preview:", preview_path)
print("input_seeds:", len(seeds))
print("safe_candidates:", len(safe))
print("selected:", len(selected))
print("template_counts:", dict(template_count))
print("safe_score_range:", summary["safe_score_range"])
PY
