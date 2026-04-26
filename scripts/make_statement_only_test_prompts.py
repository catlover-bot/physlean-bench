import json
from pathlib import Path

OUT = Path("/project/nlp-work11/hirotaka-m/physlean_trace_rc13_week_8cpu")

INP = OUT / "test.jsonl"
DST = OUT / "eval_subsets/deepseek_prompts_test_statement_only.jsonl"

DST.parent.mkdir(parents=True, exist_ok=True)

with INP.open() as f, DST.open("w") as g:
    for line in f:
        r = json.loads(line)

        statement = r["statement"].strip()

        prompt = (
            "Complete the following Lean 4 theorem proof.\n\n"
            "You are working in the Physlib Lean 4 repository.\n"
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
            "namespace": r["namespace"],
            "statement": r["statement"],
            "gold_proof": r["proof_text"],
            "prompt": prompt,
            "prompt_setting": "statement_only",
        }

        g.write(json.dumps(item, ensure_ascii=False) + "\n")

print("wrote", DST)
