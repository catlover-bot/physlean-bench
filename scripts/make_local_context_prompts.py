import json
from pathlib import Path

OUT = Path("/project/nlp-work11/hirotaka-m/physlean_trace_rc13_week_8cpu")
WORK = Path("/project/nlp-work11/hirotaka-m/physlean_eval_work/physlib_eval_smoke_built")

INP = OUT / "eval_subsets/test_smoke_50.jsonl"
DST = OUT / "eval_subsets/deepseek_prompts_smoke_50.local_context_80.jsonl"

CONTEXT_LINES = 80

with INP.open() as f, DST.open("w") as g:
    for line in f:
        r = json.loads(line)

        fp = r["file_path"]
        source_lines = (WORK / fp).read_text().splitlines()

        line_start = int(r["line_start"])
        ctx_start = max(1, line_start - CONTEXT_LINES)
        ctx_end = line_start - 1

        local_context = "\n".join(
            f"{i}: {source_lines[i - 1]}"
            for i in range(ctx_start, ctx_end + 1)
        )

        statement = r["statement"].strip()

        prompt = (
            "You are proving a Lean 4 theorem in the Physlib repository.\n\n"
            "Return only the proof body after `:=`.\n"
            "Your answer must start with `by` or `exact`.\n"
            "Do not restate the theorem.\n"
            "Do not include Markdown fences.\n"
            "Do not use `sorry` or `admit`.\n\n"
            "Here is the local context immediately before the theorem:\n\n"
            "```lean4\n"
            f"{local_context}\n"
            "```\n\n"
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
            "prompt": prompt,
            "prompt_setting": "local_context_80",
            "context_lines": CONTEXT_LINES,
            "context_start": ctx_start,
            "context_end": ctx_end,
        }

        g.write(json.dumps(item, ensure_ascii=False) + "\n")

print("wrote", DST)
