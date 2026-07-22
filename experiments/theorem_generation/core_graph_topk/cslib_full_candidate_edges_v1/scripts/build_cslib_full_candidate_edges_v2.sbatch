#!/bin/bash
#SBATCH -J cslib_full_topk2
#SBATCH -A lang
#SBATCH -p lang_long
#SBATCH -c 2
#SBATCH --mem=12G
#SBATCH -t 02:00:00
#SBATCH -o /project/nlp-work11/%u/theorem_generation/library_completion_topk_v0/logs/%x-%j.out
#SBATCH -e /project/nlp-work11/%u/theorem_generation/library_completion_topk_v0/logs/%x-%j.err

set -euo pipefail

cd /project/nlp-work11/$USER/theorem_generation/library_completion_topk_v0

python3 - <<'PY'
import json
import os
import re
from collections import Counter, defaultdict
from pathlib import Path

user = os.environ["USER"]
base = Path("/project/nlp-work11") / user / "theorem_generation/library_completion_topk_v0"

inp = base / "cslib_full_declarations_norm_v3.jsonl"
out_nodes = base / "cslib_full_theorem_nodes_scored_v2.jsonl"
out_edges = base / "cslib_full_candidate_edges_topk_v2.jsonl"
out_summary = base / "summary_cslib_full_candidate_edges_topk_v2.json"
out_preview = base / "preview_cslib_full_candidate_edges_topk_v2.txt"

rows = [
    json.loads(line)
    for line in inp.read_text().splitlines()
    if line.strip()
]

private_re = re.compile(r"^\s*(?:@\[[^\]]*\]\s*)*private\s+")

nodes = [
    row for row in rows
    if row["kind"] in {"theorem", "lemma"}
    and not private_re.match(row.get("header", ""))
]

def primary_area(file_name):
    rules = [
        ("Cslib/Languages/LambdaCalculus/", "lambda_calculus"),
        ("Cslib/Languages/CombinatoryLogic/", "combinatory_logic"),
        ("Cslib/Languages/CCS/", "ccs"),
        ("Cslib/Computability/Automata/", "automata"),
        ("Cslib/Computability/Languages/", "formal_languages"),
        ("Cslib/Computability/URM/", "urm"),
        ("Cslib/Computability/Machines/", "turing_machine"),
        ("Cslib/Logics/HML/", "hml"),
        ("Cslib/Logics/LinearLogic/", "linear_logic"),
        ("Cslib/Logics/Propositional/", "propositional_logic"),
        ("Cslib/Crypto/", "crypto"),
        ("Cslib/Foundations/Semantics/LTS/", "lts"),
        ("Cslib/Foundations/Semantics/FLTS/", "flts"),
        ("Cslib/Foundations/Syntax/", "syntax"),
        ("Cslib/Foundations/Data/", "foundations_data"),
        ("Cslib/Foundations/Logic/", "foundations_logic"),
        ("Cslib/Foundations/Control/", "control"),
        ("Cslib/Foundations/Combinatorics/", "combinatorics"),
        ("Cslib/Algorithms/", "algorithms"),
    ]

    for prefix, area in rules:
        if file_name.startswith(prefix):
            return area

    return "other"

stop = {
    "theorem", "lemma", "private", "protected", "def", "by",
    "where", "class", "structure", "prop", "type", "sort",
    "list", "set", "fun", "true", "false", "and", "or",
    "not", "forall", "exists", "cslib", "basic", "self",
    "some", "none", "left", "right", "variable", "section",
    "namespace", "open", "scoped", "simp", "grind"
}

def tokens(text):
    parts = re.split(r"[^\wα-ωΑ-Ω₀-₉εωβητ']+", text, flags=re.UNICODE)
    result = []

    for part in parts:
        if not part:
            continue

        part = re.sub(r"([a-z])([A-Z])", r"\1 \2", part)

        for token in re.split(r"[_\s.']+", part):
            token = token.lower()

            if len(token) >= 2 and token not in stop:
                result.append(token)

    return sorted(set(result))

def local_api_prefix(name):
    local = name.rsplit(".", 1)[-1].lower()
    parts = [part for part in re.split(r"[_₀-₉]+", local) if part]
    return parts[0] if parts else local

def motif_tags(a, b):
    text = (
        a["local_name"].lower() + " "
        + b["local_name"].lower() + " "
        + a["header"].lower() + " "
        + b["header"].lower()
    )

    groups = {
        "composition_bridge": [
            "comp", "compose", "trans", "append", "concat",
            "map_map", "bind", "step"
        ],
        "base_case_bridge": [
            "single", "singleton", "refl", "nil", "empty",
            "zero", "one"
        ],
        "iff_characterization": [
            "iff", "equiv", "exists", "unique"
        ],
        "preservation_bridge": [
            "preserv", "closed", "closure", "stable",
            "invariant", "congr"
        ],
        "typing_reduction_bridge": [
            "typing", "progress", "preservation", "safety",
            "wellformed", "reduction", "subtyping"
        ],
        "acceptance_language_bridge": [
            "accept", "language", "regular", "buchi", "omega"
        ],
        "execution_reachability_bridge": [
            "execution", "reach", "multistep", "halt", "normal"
        ],
        "substitution_context_bridge": [
            "substitution", "subst", "opening", "context",
            "alpha", "rename"
        ],
        "proof_equivalence_bridge": [
            "proof", "equiv", "cut", "inversion", "sequent"
        ],
        "map_functor_bridge": [
            "map", "map_id", "map_map", "functor"
        ],
    }

    tags = []

    for tag, terms in groups.items():
        if sum(term in text for term in terms) >= 2:
            tags.append(tag)

    return sorted(set(tags))

enriched = []

for row in nodes:
    rec = dict(row)
    rec["primary_area"] = primary_area(rec["file"])
    rec["directory"] = str(Path(rec["file"]).parent)
    rec["tokens"] = tokens(rec["local_name"] + " " + rec["header"])
    rec["api_prefix"] = local_api_prefix(rec["local_name"])
    enriched.append(rec)

nodes = enriched

def score_pair(a, b):
    if a["name"] == b["name"]:
        return None

    ta = set(a["tokens"])
    tb = set(b["tokens"])
    shared = ta & tb
    union = ta | tb

    jaccard = len(shared) / len(union) if union else 0.0

    same_area = a["primary_area"] == b["primary_area"]
    same_file = a["file"] == b["file"]
    same_dir = a["directory"] == b["directory"]
    same_prefix = a["api_prefix"] == b["api_prefix"]

    motifs = motif_tags(a, b)

    # 異分野候補は、明確な共有語とモチーフがある場合だけ残す。
    if not same_area and (len(shared) < 3 or not motifs):
        return None

    # 同分野でも、共有概念または明確なAPIモチーフを要求する。
    if len(shared) < 1 and not motifs:
        return None

    locality = (
        1.4 if same_file
        else 0.8 if same_dir
        else 0.35 if same_area
        else 0.0
    )

    area_score = 2.2 if same_area else 0.3
    prefix_score = 0.8 if same_prefix else 0.0
    motif_score = 1.25 * len(motifs)

    local_a = a["local_name"].lower()
    local_b = b["local_name"].lower()

    normalized_a = re.sub(r"[^a-z0-9α-ω]", "", local_a)
    normalized_b = re.sub(r"[^a-z0-9α-ω]", "", local_b)

    duplicate_penalty = 0.0

    if local_a == local_b:
        duplicate_penalty += 3.0
    elif normalized_a == normalized_b:
        duplicate_penalty += 2.0

    score = (
        6.0 * jaccard
        + 0.45 * min(len(shared), 8)
        + area_score
        + locality
        + prefix_score
        + motif_score
        - duplicate_penalty
    )

    if score < 3.2:
        return None

    return {
        "source": a["name"],
        "target": b["name"],
        "source_file": a["file"],
        "target_file": b["file"],
        "source_line": a["line"],
        "target_line": b["line"],
        "source_area": a["primary_area"],
        "target_area": b["primary_area"],
        "shared_tokens": sorted(shared),
        "shared_token_count": len(shared),
        "motifs": motifs,
        "same_area": same_area,
        "same_file": same_file,
        "same_dir": same_dir,
        "same_api_prefix": same_prefix,
        "score": round(score, 6),
        "source_header": a["header"],
        "target_header": b["header"],
    }

# 逆向きの同一ペアを1件へ統合する。
best_by_unordered_pair = {}

for i, source in enumerate(nodes):
    for j in range(i + 1, len(nodes)):
        target = nodes[j]
        edge = score_pair(source, target)

        if edge is None:
            continue

        pair = tuple(sorted((source["name"], target["name"])))
        previous = best_by_unordered_pair.get(pair)

        if previous is None or edge["score"] > previous["score"]:
            best_by_unordered_pair[pair] = edge

all_edges = list(best_by_unordered_pair.values())

# 各ノードが高得点候補を最大15件持つように制限する。
incident = defaultdict(list)

for edge in all_edges:
    incident[edge["source"]].append(edge)
    incident[edge["target"]].append(edge)

selected_pairs = set()

for node_name, candidates in incident.items():
    candidates.sort(
        key=lambda edge: (
            edge["score"],
            edge["shared_token_count"]
        ),
        reverse=True,
    )

    for edge in candidates[:15]:
        selected_pairs.add(tuple(sorted((
            edge["source"],
            edge["target"],
        ))))

edges = [
    edge
    for edge in all_edges
    if tuple(sorted((edge["source"], edge["target"]))) in selected_pairs
]

edges.sort(
    key=lambda edge: (
        edge["score"],
        edge["shared_token_count"],
        edge["source"],
        edge["target"],
    ),
    reverse=True,
)

for rank, edge in enumerate(edges, 1):
    edge["rank"] = rank

with out_nodes.open("w") as file:
    for node in nodes:
        file.write(json.dumps(node, ensure_ascii=False) + "\n")

with out_edges.open("w") as file:
    for edge in edges:
        file.write(json.dumps(edge, ensure_ascii=False) + "\n")

summary = {
    "input_declarations": len(rows),
    "public_theorem_lemma_nodes": len(nodes),
    "candidate_edges_before_per_node_limit": len(all_edges),
    "candidate_edges": len(edges),
    "reciprocal_pairs_removed": True,
    "per_node_limit": 15,
    "node_area_counts": dict(sorted(Counter(
        node["primary_area"] for node in nodes
    ).items())),
    "edge_source_area_counts": dict(sorted(Counter(
        edge["source_area"] for edge in edges
    ).items())),
    "motif_counts": dict(sorted(Counter(
        motif for edge in edges for motif in edge["motifs"]
    ).items())),
    "score_range": [
        min((edge["score"] for edge in edges), default=None),
        max((edge["score"] for edge in edges), default=None),
    ],
}

out_summary.write_text(
    json.dumps(summary, ensure_ascii=False, indent=2) + "\n"
)

with out_preview.open("w") as file:
    for edge in edges[:200]:
        file.write(
            f"EDGE {edge['rank']:05d} "
            f"score={edge['score']:.3f} "
            f"area={edge['source_area']}->{edge['target_area']} "
            f"motifs={','.join(edge['motifs'])}\n"
        )
        file.write(f"  SRC {edge['source']}\n")
        file.write(f"  TGT {edge['target']}\n")
        file.write(
            f"  shared={','.join(edge['shared_tokens'][:20])}\n\n"
        )

print("saved_nodes:", out_nodes)
print("saved_edges:", out_edges)
print("saved_summary:", out_summary)
print("saved_preview:", out_preview)
print(json.dumps(summary, ensure_ascii=False, indent=2))
PY
