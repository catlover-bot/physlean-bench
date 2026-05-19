import json
from pathlib import Path

BASE = Path("/project/nlp-work11/hirotaka-m/crossdomain_trace/cslib_bench_v0")

SRC = BASE / "test.model_eval.jsonl"
DST = BASE / "deepseek_prompts_test_statement_only.jsonl"

def make_prompt(statement: str) -> str:
    statement = statement.strip()

    return f"""You are proving a Lean 4 theorem in the CSLib repository.

Task:
Return only the proof body after `:=`.

Rules:
- Do not restate the theorem.
- Do not include Markdown.
- Do not include code fences.
- Do not use `sorry`.
- Do not use `admit`.
- The answer should be valid Lean 4 code.
- Prefer a proof body starting with `by`, `exact`, `rfl`, or another valid Lean proof term.

Theorem:
{statement}
"""

n = 0

with SRC.open() as f, DST.open("w") as g:
    for line in f:
        r = json.loads(line)
        rr = dict(r)

        statement = rr.get("statement") or ""
        rr["prompt"] = make_prompt(statement)
        rr["prompt_style"] = "statement_only_no_markdown_fence"

        if "gold_proof" not in rr:
            rr["gold_proof"] = rr.get("proof_text", "")

        g.write(json.dumps(rr, ensure_ascii=False) + "\n")
        n += 1

print("input:", SRC)
print("output:", DST)
print("records:", n)
