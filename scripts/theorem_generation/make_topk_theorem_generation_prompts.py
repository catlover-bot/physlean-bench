import json
from pathlib import Path

PROJECT = Path("/project/nlp-work11") / Path.home().name
GRAPH_DIR = PROJECT / "theorem_generation" / "theorem_graph_topk_v0"
OUT_DIR = PROJECT / "theorem_generation" / "topk_candidate_generation_v0"
OUT_DIR.mkdir(parents=True, exist_ok=True)

EDGES = GRAPH_DIR / "edges_topk.jsonl"
OUT = OUT_DIR / "topk_theorem_generation_prompts_v0.jsonl"

MAX_PER_LIBRARY = 30
MIN_SCORE = 3.0

selected = []
counts = {"physlib": 0, "cslib": 0}

with EDGES.open() as f:
    for line in f:
        e = json.loads(line)
        lib = e["source_library"]

        if lib != e["target_library"]:
            continue
        if e["score"] < MIN_SCORE:
            continue
        if counts.get(lib, 0) >= MAX_PER_LIBRARY:
            continue

        src_stmt = (e.get("source_statement") or "").strip()
        tgt_stmt = (e.get("target_statement") or "").strip()

        if not src_stmt or not tgt_stmt:
            continue

        counts[lib] += 1

        prompt = f"""You are generating new Lean theorem candidates for a library-specific formalization project.

Target library: {lib}

You are given two related existing theorems selected by a top-K theorem graph.

Source theorem:
- name: {e['source']}
- statement:
{src_stmt}

Related theorem:
- name: {e['target']}
- statement:
{tgt_stmt}

Task:
Generate exactly one NEW Lean theorem candidate that is plausibly derivable from these two related facts.

Rules:
1. Use the same library style and namespace implied by the theorem names.
2. Do not use `sorry`, `admit`, or natural language explanation.
3. Do not invent unrelated concepts.
4. Prefer one of these candidate types:
   - corollary
   - specialization
   - bridge lemma
   - rewrite lemma
   - nonneg/pos/ne_zero consequence
   - transitive composition
5. Return only Lean code.
6. The theorem should be useful as an intermediate lemma, even if it is simple.
"""

        selected.append({
            "theorem_id": f"topk_gen_v0_{len(selected):04d}",
            "declaration_name": f"topk_generated_candidate_{len(selected):04d}",
            "file_path": f"generated/{lib}/topk_generated_candidate_{len(selected):04d}.lean",
            "module_path": f"Generated.{lib}.TopK",
            "namespace": None,
            "statement": "new theorem candidate generated from top-K related existing theorems",
            "gold_proof": "",
            "source_library": lib,
            "source_theorem": e["source"],
            "target_theorem": e["target"],
            "topk_score": e["score"],
            "topk_reasons": e["reasons"],
            "prompt": prompt,
        })

with OUT.open("w") as g:
    for r in selected:
        g.write(json.dumps(r, ensure_ascii=False) + "\n")

print("output =", OUT)
print("records =", len(selected))
print("counts =", counts)
print()
print("=== sample ===")
print(json.dumps(selected[0], ensure_ascii=False, indent=2)[:2000])
