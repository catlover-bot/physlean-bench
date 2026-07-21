#!/bin/bash
#SBATCH -J phys_v3_repair40
#SBATCH -A lang
#SBATCH -p lang_long
#SBATCH -c 2
#SBATCH --mem=8G
#SBATCH -t 03:00:00
#SBATCH -o /project/nlp-work11/%u/theorem_generation/nonlocal_batch_v3/logs/%x-%j.out
#SBATCH -e /project/nlp-work11/%u/theorem_generation/nonlocal_batch_v3/logs/%x-%j.err

set -euxo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv-dsp/bin/activate

python - <<'PY'
import json
import os
import time
from pathlib import Path
from dotenv import load_dotenv
from openai import OpenAI

load_dotenv(".env.llm")

client = OpenAI(api_key=os.environ["OPENAI_API_KEY"])
model = os.environ.get("OPENAI_MODEL", "gpt-5.1")

base = Path("/project/nlp-work11") / Path.home().name / "theorem_generation/nonlocal_batch_v3"

gen_path = base / "openai_physlib_nonlocal_generations_0020_0059.jsonl"
check_path = base / "openai_physlib_nonlocal_lean_check_0020_0059.jsonl"
out_path = base / "openai_physlib_nonlocal_repaired_0020_0059.jsonl"

gens = {json.loads(line)["id"]: json.loads(line) for line in gen_path.open()}
checks = [json.loads(line) for line in check_path.open()]

targets = [r for r in checks if r["status"] == "fail"]

with out_path.open("w") as out:
    for i, c in enumerate(targets, 1):
        g = gens[c["id"]]
        err = (c.get("stderr") or c.get("stdout") or "")[-5000:]

        prompt = f"""
You are repairing a Lean theorem candidate for Physlib.

The original theorem candidate failed Lean verification.
Repair it into a Lean file that is more likely to compile.

Hard constraints:
- Output Lean code only.
- Include necessary imports.
- Output exactly ONE lemma/theorem.
- Do NOT use sorry or admit.
- Do NOT define new def, structure, abbrev, notation, instance, or namespace object.
- Do NOT create a trivial theorem like x = x.
- Do NOT merely restate one existing theorem.
- Keep the theorem non-local if possible.
- Use existing Physlib names correctly.
- Prefer a smaller theorem if the original is too ambitious.
- If the theorem mixes two modules, bind all required structure instances explicitly.

Source theorem:
{g["source"]}

Target theorem:
{g["target"]}

Original generated Lean:
{g["generated"]}

Lean error:
{err}

Repair the Lean code.
"""

        print(f"[{i}/{len(targets)}] repairing {c['id']}", flush=True)

        try:
            resp = client.responses.create(
                model=model,
                input=prompt,
            )
            repaired = resp.output_text.strip()
            status = "ok"
            error = None
        except Exception as e:
            repaired = ""
            status = "error"
            error = repr(e)

        out.write(json.dumps({
            "id": c["id"],
            "model": model,
            "status": status,
            "error": error,
            "source": g["source"],
            "target": g["target"],
            "original": g["generated"],
            "lean_error": err,
            "repaired": repaired,
        }, ensure_ascii=False) + "\n")
        out.flush()

        time.sleep(1)

print("saved:", out_path)
print("repair_count:", len(targets))
PY
