import json
from pathlib import Path

OUT = Path("/project/nlp-work11/hirotaka-m/physlean_trace_rc13_week_8cpu")

INP = OUT / "eval_subsets/test_smoke_50.jsonl"
DST = OUT / "eval_subsets/deepseek_prompts_smoke_50.oracle_premises.jsonl"

with INP.open() as f, DST.open("w") as g:
    for line in f:
        r = json.loads(line)

        used_premises = r.get("used_premises") or []
        accessible_premises = r.get("accessible_premises") or []

        used_text = "\n".join(f"- {p}" for p in used_premises)
        accessible_text = "\n".join(f"- {p}" for p in accessible_premises[:60])

        statement = r["statement"].strip()

        prompt = (
            "You are proving a Lean 4 theorem in the Physlib repository.\n\n"
            "Return only the proof body after `:=`.\n"
            "Your answer must start with `by` or `exact`.\n"
            "Do not restate the theorem.\n"
            "Do not include Markdown fences.\n"
            "Do not use `sorry` or `admit`.\n\n"
            "The following premise names were used in the reference proof. "
            "You may use them in your proof:\n"
            f"{used_text}\n\n"
            "The following additional accessible premise names may also be available:\n"
            f"{accessible_text}\n\n"
            "Now complete the proof of the following theorem.\n"
            "Return only the replacement for `<PROOF>`.\n\n"
            "```lean4\n"
            f"{statement}\n"
            "<PROOF>\n"
            "```\n"
        )

        item = {
            "theorem_id": r["theorem_id"],
            "declaration_name": r["declaration_name"],
            "file_path": r["file_path"],
            "module_path": r["module_path"],
            "namespace": r["namespace"],
            "statement": r["statement"],
            "gold_proof": r["proof_text"],
            "used_premises": used_premises,
            "accessible_premises": accessible_premises,
            "prompt": prompt,
            "prompt_setting": "oracle_premises",
        }

        g.write(json.dumps(item, ensure_ascii=False) + "\n")

print("wrote", DST)
