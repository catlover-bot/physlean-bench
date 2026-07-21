#!/bin/bash
#SBATCH -J cslib_full_topk
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
import math
import os
import re
from collections import Counter, defaultdict
from pathlib import Path

user = os.environ["USER"]
base = (
    Path("/project/nlp-work11")
    / user
    / "theorem_generation/library_completion_topk_v0"
)

inp = base / "cslib_full_declarations_norm_v3.jsonl"
out_nodes = base / "cslib_full_theorem_nodes_scored_v1.jsonl"
out_edges = base / "cslib_full_candidate_edges_topk_v1.jsonl"
out_summary = base / "summary_cslib_full_candidate_edges_topk_v1.json"
out_preview = base / "preview_cslib_full_candidate_edges_topk_v1.txt"

rows = [
    json.loads(line)
    for line in inp.read_text().splitlines()
    if line.strip()
]

private_re = re.compile(
    r"^\s*(?:@\[[^\]]*\]\s*)*private\s+"
)

all_theorem_nodes = [
    row
    for row in rows
    if row["kind"] in {"theorem", "lemma"}
]

nodes = [
    row
    for row in all_theorem_nodes
    if not private_re.match(row.get("header", ""))
]

stop = {
    "theorem", "lemma", "private", "protected", "def", "by",
    "where", "class", "structure", "prop", "type", "sort",
    "state", "label", "list", "set", "fun", "true", "false",
    "iff", "and", "or", "not", "forall", "exists", "cslib",
    "basic", "left", "right", "some", "none", "self"
}

def split_tokens(text):
    parts = re.split(r"[^\wα-ωΑ-Ω₀-₉εω']+", text, flags=re.UNICODE)
    tokens = []

    for part in parts:
        if not part:
            continue

        expanded = re.sub(r"([a-z])([A-Z])", r"\1 \2", part)

        for token in re.split(r"[_\s.']+", expanded):
            token = token.lower()

            if len(token) >= 2 and token not in stop:
                tokens.append(token)

    return tokens

core_terms = {
    "transition_lts": [
        "mtr", "str", "trace", "transition", "execution",
        "simulation", "bisimulation"
    ],
    "automata_language": [
        "accept", "language", "regular", "buchi", "automata",
        "omega", "ωlanguage"
    ],
    "urm_computability": [
        "urm", "halt", "instr", "program", "computable"
    ],
    "modal_logic_hml": [
        "hml", "satisf", "formula", "logical"
    ],
    "lambda_calculus": [
        "lambda", "typing", "reduction", "substitution",
        "progress", "preservation", "safety", "normal"
    ],
    "combinatory_logic": [
        "combinator", "evaluation", "confluence", "recursion"
    ],
    "linear_logic": [
        "proof", "sequent", "cut", "tensor", "parr",
        "oplus", "with", "equiv"
    ],
    "propositional_logic": [
        "deduction", "derive", "provable", "formula", "inference"
    ],
    "crypto": [
        "encrypt", "decrypt", "secrecy", "onetimepad", "key"
    ],
    "turing_machine": [
        "turing", "tape", "machine", "configuration", "step"
    ],
    "syntax_substitution": [
        "syntax", "substitution", "alpha", "context", "wellformed"
    ],
}

def enrich(node):
    rec = dict(node)
    search_text = (
        rec["name"]
        + " "
        + rec.get("header", "")
        + " "
        + " ".join(rec.get("family", []))
    )

    tokens = sorted(set(split_tokens(search_text)))
    name_lower = rec["name"].lower()

    rec["tokens"] = tokens
    rec["token_count"] = len(tokens)
    rec["search_text_lower"] = search_text.lower()
    rec["directory"] = str(Path(rec["file"]).parent)

    rec["domain_score"] = 0.4 * len(rec.get("family", []))

    for family, terms in core_terms.items():
        if family in rec.get("family", []):
            rec["domain_score"] += 1.0

        if any(term in name_lower for term in terms):
            rec["domain_score"] += 0.6

    return rec

nodes = [enrich(node) for node in nodes]

family_motifs = {
    "relation_equiv": "relation_equivalence_api",
    "transition_lts": "lts_transition_api",
    "reachability_steps": "reachability_composition_api",
    "automata_language": "automata_language_api",
    "ccs_process": "ccs_semantics_api",
    "urm_computability": "urm_computability_api",
    "modal_logic_hml": "hml_semantics_api",
    "lambda_calculus": "lambda_typing_reduction_api",
    "combinatory_logic": "combinatory_reduction_api",
    "linear_logic": "linear_logic_proof_api",
    "propositional_logic": "propositional_derivation_api",
    "crypto": "crypto_correctness_security_api",
    "turing_machine": "turing_execution_api",
    "syntax_substitution": "syntax_substitution_api",
    "algorithms": "algorithm_correctness_api",
    "combinatorics": "combinatorics_api",
    "control_monad": "free_monad_api",
}

def motif_tags(a, b):
    text = a["search_text_lower"] + " " + b["search_text_lower"]
    shared_families = set(a["family"]) & set(b["family"])
    tags = []

    for family in sorted(shared_families):
        motif = family_motifs.get(family)
        if motif:
            tags.append(motif)

    pattern_groups = {
        "composition_bridge": [
            "comp", "compose", "trans", "append", "concat",
            "map_map", "bind", "seq"
        ],
        "singleton_base_bridge": [
            "single", "singleton", "refl", "nil", "zero", "one"
        ],
        "iff_characterization": [
            "iff", "equiv", "characterization", "exists",
            "unique"
        ],
        "closure_preservation": [
            "preserve", "closed", "closure", "stable",
            "invariant", "congr"
        ],
        "typing_safety_bridge": [
            "typing", "progress", "preservation", "safety",
            "wellformed", "reduction"
        ],
        "acceptance_language_bridge": [
            "accept", "language", "regular", "buchi", "omega",
            "ωlanguage"
        ],
        "execution_reachability_bridge": [
            "execution", "reach", "step", "multistep", "halt"
        ],
        "substitution_context_bridge": [
            "substitution", "subst", "opening", "context",
            "alpha", "rename"
        ],
        "proof_equivalence_bridge": [
            "proof", "equiv", "cut", "inversion", "sequent"
        ],
        "map_functor_law": [
            "map", "map_id", "map_map", "functor"
        ],
    }

    for tag, terms in pattern_groups.items():
        hits = sum(term in text for term in terms)
        if hits >= 2:
            tags.append(tag)

    return sorted(set(tags))

def score_pair(a, b):
    if a["name"] == b["name"]:
        return None

    tokens_a = set(a["tokens"])
    tokens_b = set(b["tokens"])

    intersection = tokens_a & tokens_b
    union = tokens_a | tokens_b

    jaccard = len(intersection) / len(union) if union else 0.0

    shared_families = set(a["family"]) & set(b["family"])
    family_score = 2.2 * len(shared_families)

    same_file = a["file"] == b["file"]
    same_dir = a["directory"] == b["directory"]

    motifs = motif_tags(a, b)
    if not motifs:
        return None

    locality_score = (
        1.6 if same_file
        else 0.9 if same_dir
        else 0.25
    )

    source_local = a["local_name"].lower()
    target_local = b["local_name"].lower()

    name_score = 0.0

    source_prefix = re.split(r"[_.'₀-₉]+", source_local)[0]
    target_prefix = re.split(r"[_.'₀-₉]+", target_local)[0]

    if source_prefix and source_prefix == target_prefix:
        name_score += 0.7

    api_terms = [
        "iff", "eq", "comp", "single", "refl", "trans",
        "mono", "map", "append", "subst", "preserve",
        "injective", "surjective", "equiv", "congr"
    ]

    if any(term in source_local for term in api_terms):
        name_score += 0.35

    if any(term in target_local for term in api_terms):
        name_score += 0.35

    duplicate_risk = 0.0

    normalized_source = re.sub(r"[^a-z0-9]", "", source_local)
    normalized_target = re.sub(r"[^a-z0-9]", "", target_local)

    if source_local == target_local:
        duplicate_risk += 2.5
    elif normalized_source == normalized_target:
        duplicate_risk += 1.8

    length_penalty = 0.0
    if len(intersection) == 0:
        length_penalty += 0.8

    score = (
        5.0 * jaccard
        + family_score
        + 1.25 * len(motifs)
        + locality_score
        + name_score
        + 0.12 * (a["domain_score"] + b["domain_score"])
        - duplicate_risk
        - length_penalty
    )

    if score < 2.8:
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
        "shared_families": sorted(shared_families),
        "shared_tokens": sorted(intersection)[:50],
        "shared_token_count": len(intersection),
        "motifs": motifs,
        "same_file": same_file,
        "same_dir": same_dir,
        "score": round(score, 6),
        "source_header": a["header"],
        "target_header": b["header"],
    }

edges_by_source = defaultdict(list)

for index, source in enumerate(nodes):
    candidates = []

    for target_index, target in enumerate(nodes):
        if index == target_index:
            continue

        edge = score_pair(source, target)

        if edge is not None:
            candidates.append(edge)

    candidates.sort(
        key=lambda edge: (
            edge["score"],
            edge["shared_token_count"],
            edge["target"]
        ),
        reverse=True,
    )

    edges_by_source[source["name"]] = candidates[:20]

edges = [
    edge
    for source_edges in edges_by_source.values()
    for edge in source_edges
]

edges.sort(
    key=lambda edge: (
        edge["score"],
        edge["shared_token_count"],
        edge["source"],
        edge["target"]
    ),
    reverse=True,
)

for rank, edge in enumerate(edges, 1):
    edge["rank"] = rank

with out_nodes.open("w") as file:
    for node in nodes:
        rec = dict(node)
        rec.pop("search_text_lower", None)
        file.write(json.dumps(rec, ensure_ascii=False) + "\n")

with out_edges.open("w") as file:
    for edge in edges:
        file.write(json.dumps(edge, ensure_ascii=False) + "\n")

summary = {
    "input_declarations": len(rows),
    "all_theorem_lemma_nodes": len(all_theorem_nodes),
    "private_theorem_lemma_nodes_excluded": (
        len(all_theorem_nodes) - len(nodes)
    ),
    "public_theorem_lemma_nodes": len(nodes),
    "candidate_edges": len(edges),
    "source_nodes_with_edges": sum(
        bool(items) for items in edges_by_source.values()
    ),
    "target_nodes_hit": len({
        edge["target"] for edge in edges
    }),
    "family_counts": dict(sorted(Counter(
        family
        for node in nodes
        for family in node["family"]
    ).items())),
    "motif_counts": dict(sorted(Counter(
        motif
        for edge in edges
        for motif in edge["motifs"]
    ).items())),
    "score_range": [
        min((edge["score"] for edge in edges), default=None),
        max((edge["score"] for edge in edges), default=None),
    ],
    "per_source_limit": 20,
}

out_summary.write_text(
    json.dumps(summary, ensure_ascii=False, indent=2) + "\n"
)

with out_preview.open("w") as file:
    for edge in edges[:200]:
        file.write(
            f"EDGE {edge['rank']:05d} "
            f"score={edge['score']:.3f} "
            f"motifs={','.join(edge['motifs'])}\n"
        )
        file.write(f"  SRC {edge['source']}\n")
        file.write(
            f"      {edge['source_file']}:{edge['source_line']}\n"
        )
        file.write(f"  TGT {edge['target']}\n")
        file.write(
            f"      {edge['target_file']}:{edge['target_line']}\n"
        )
        file.write(
            f"  families={','.join(edge['shared_families'])}\n"
        )
        file.write(
            f"  shared={','.join(edge['shared_tokens'][:25])}\n\n"
        )

print("saved_nodes:", out_nodes)
print("saved_edges:", out_edges)
print("saved_summary:", out_summary)
print("saved_preview:", out_preview)
print(json.dumps(summary, ensure_ascii=False, indent=2))
PY
