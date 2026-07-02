import json
import math
import re
from collections import defaultdict
from pathlib import Path

ROOT = Path("/home/is") / Path.home().name / "workspace/physlean-bench"
PROJECT = Path("/project/nlp-work11") / Path.home().name
OUT = PROJECT / "theorem_generation" / "theorem_graph_topk_v0"
OUT.mkdir(parents=True, exist_ok=True)

INPUTS = [
    ("physlib", ROOT / "data/physlibbench/train.jsonl"),
    ("physlib", ROOT / "data/physlibbench/valid.jsonl"),
    ("physlib", ROOT / "data/physlibbench/test.jsonl"),
    ("cslib", ROOT / "results/cslib_bench_v0/train.jsonl"),
    ("cslib", ROOT / "results/cslib_bench_v0/valid.jsonl"),
    ("cslib", ROOT / "results/cslib_bench_v0/test.jsonl"),
]

STOP = {
    "theorem", "lemma", "def", "by", "simp", "rw", "exact", "intro", "intros",
    "have", "show", "let", "fun", "Type", "Prop", "Sort", "where",
    "if", "then", "else", "match", "with", "case", "cases",
}

IDENT_RE = re.compile(r"[A-Za-z_][A-Za-z0-9_'.]*")

def read_jsonl(path):
    if not path.exists():
        return
    with path.open() as f:
        for line in f:
            if line.strip():
                yield json.loads(line)

def symbols(text):
    toks = IDENT_RE.findall(text or "")
    return sorted({t for t in toks if len(t) >= 2 and t not in STOP})

def area_from_path(path):
    parts = str(path or "").split("/")
    if len(parts) >= 2:
        return "/".join(parts[:2])
    return str(path or "")

nodes = []
seen = set()

for lib, path in INPUTS:
    for r in read_jsonl(path) or []:
        tid = r.get("theorem_id") or r.get("declaration_name")
        name = r.get("declaration_name") or tid
        if not tid or not name:
            continue
        key = (lib, tid)
        if key in seen:
            continue
        seen.add(key)

        stmt = r.get("statement", "")
        proof = r.get("proof_text") or r.get("gold_proof") or ""
        used = r.get("used_premises") or []
        acc = r.get("accessible_premises") or []

        node = {
            "library": lib,
            "theorem_id": tid,
            "declaration_name": name,
            "statement": stmt,
            "proof_text": proof,
            "file_path": r.get("file_path"),
            "module_path": r.get("module_path"),
            "namespace": r.get("namespace"),
            "area": area_from_path(r.get("file_path")),
            "symbols": symbols(stmt),
            "proof_symbols": symbols(proof)[:200],
            "used_premises": used,
            "accessible_premises": acc[:100],
        }
        nodes.append(node)

name_to_idx = {n["declaration_name"]: i for i, n in enumerate(nodes)}
id_to_idx = {n["theorem_id"]: i for i, n in enumerate(nodes)}

sym_df = defaultdict(int)
for n in nodes:
    for s in set(n["symbols"]):
        sym_df[s] += 1

N = max(1, len(nodes))
sym_idf = {s: math.log((N + 1) / (df + 1)) + 1.0 for s, df in sym_df.items()}

def weighted_jaccard(a, b):
    A, B = set(a), set(b)
    if not A and not B:
        return 0.0
    inter = A & B
    union = A | B
    num = sum(sym_idf.get(x, 1.0) for x in inter)
    den = sum(sym_idf.get(x, 1.0) for x in union)
    return num / den if den else 0.0

def same_prefix(a, b):
    if not a or not b:
        return 0.0
    aa = str(a).split(".")
    bb = str(b).split(".")
    m = 0
    for x, y in zip(aa, bb):
        if x == y:
            m += 1
        else:
            break
    return m / max(len(aa), len(bb), 1)

edges = []
TOPK = 10

for i, a in enumerate(nodes):
    scored = []
    used_names = set()
    for u in a["used_premises"]:
        if isinstance(u, dict):
            val = u.get("full_name") or u.get("name") or u.get("declaration_name")
        else:
            val = str(u)
        if val:
            used_names.add(val)

    for j, b in enumerate(nodes):
        if i == j:
            continue

        score = 0.0
        reasons = []

        sj = weighted_jaccard(a["symbols"], b["symbols"])
        if sj:
            score += 3.0 * sj
            reasons.append(f"symbol_jaccard={sj:.3f}")

        if a["file_path"] and a["file_path"] == b["file_path"]:
            score += 2.0
            reasons.append("same_file")

        ns = same_prefix(a["module_path"], b["module_path"])
        if ns:
            score += 1.5 * ns
            reasons.append(f"module_prefix={ns:.3f}")

        if a["namespace"] and a["namespace"] == b["namespace"]:
            score += 1.0
            reasons.append("same_namespace")

        if b["declaration_name"] in used_names or b["theorem_id"] in used_names:
            score += 4.0
            reasons.append("used_premise")

        if score > 0:
            scored.append((score, j, reasons))

    scored.sort(reverse=True, key=lambda x: x[0])
    for rank, (score, j, reasons) in enumerate(scored[:TOPK], 1):
        b = nodes[j]
        edges.append({
            "source": a["declaration_name"],
            "target": b["declaration_name"],
            "source_library": a["library"],
            "target_library": b["library"],
            "rank": rank,
            "score": round(score, 6),
            "reasons": reasons,
            "source_statement": a["statement"],
            "target_statement": b["statement"],
        })

(OUT / "nodes.jsonl").write_text(
    "".join(json.dumps(n, ensure_ascii=False) + "\n" for n in nodes)
)
(OUT / "edges_topk.jsonl").write_text(
    "".join(json.dumps(e, ensure_ascii=False) + "\n" for e in edges)
)

summary = {
    "nodes": len(nodes),
    "edges": len(edges),
    "topk": TOPK,
    "inputs": [str(p) for _, p in INPUTS],
    "out": str(OUT),
    "libraries": {
        lib: sum(1 for n in nodes if n["library"] == lib)
        for lib in sorted({n["library"] for n in nodes})
    },
}
(OUT / "summary.json").write_text(json.dumps(summary, ensure_ascii=False, indent=2) + "\n")

print(json.dumps(summary, ensure_ascii=False, indent=2))
print()
print("sample edges:")
for e in edges[:10]:
    print(f"{e['source']} -> {e['target']} score={e['score']} reasons={e['reasons']}")
