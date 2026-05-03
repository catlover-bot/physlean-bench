import json
from pathlib import Path

XOUT = Path("/project/nlp-work11/hirotaka-m/physlean_trace_rc13_week_8cpu/cross_domain_physlib_v0")

INP = XOUT / "test.cross_domain_pilot_100.jsonl"
DST = XOUT / "deepseek_prompts_cross_domain_pilot_100.statement_only.jsonl"

if not INP.exists():
    raise FileNotFoundError(f"missing input: {INP}")

with INP.open() as f, DST.open("w") as g:
    for line in f:
        r = json.loads(line)
        statement = r["statement"].strip()

        prompt = (
            "Complete the following Lean 4 theorem proof.\n\n"
            "You are working in the Physlib Lean 4 repository.\n"
            "This theorem may require concepts or lemmas from multiple domains.\n"
            "Return only Lean code for the proof body after := .\n"
            "Your answer must start with `by` or `exact`.\n"
            "Do not restate the theorem.\n"
            "Do not include Markdown fences.\n"
            "Do not use `sorry` or `admit`.\n\n"
            "The theorem statement is:\n\n"
            f"{statement}\n"
        )

        item = {
            "theorem_id": r["theorem_id"],
            "declaration_name": r["declaration_name"],
            "file_path": r["file_path"],
            "module_path": r["module_path"],
            "namespace": r.get("namespace"),
            "statement": r["statement"],
            "gold_proof": r.get("proof_text") or r.get("gold_proof"),
            "domains": r.get("domains", []),
            "primary_domain": r.get("primary_domain"),
            "used_premise_domains": r.get("used_premise_domains", []),
            "cross_domain_type": r.get("cross_domain_type"),
            "cross_domain_score": r.get("cross_domain_score"),
            "prompt": prompt,
            "prompt_setting": "cross_domain_statement_only",
        }

        g.write(json.dumps(item, ensure_ascii=False) + "\n")

print("wrote", DST)
