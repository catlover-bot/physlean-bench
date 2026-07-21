#!/bin/bash
#SBATCH -J cslib_repair20
#SBATCH -A lang
#SBATCH -p lang_long
#SBATCH -c 2
#SBATCH --mem=8G
#SBATCH -t 03:00:00
#SBATCH -o /project/nlp-work11/%u/theorem_generation/cslib_nonlocal_batch_v0/logs/%x-%j.out
#SBATCH -e /project/nlp-work11/%u/theorem_generation/cslib_nonlocal_batch_v0/logs/%x-%j.err

set -euxo pipefail

cd /home/is/$USER/workspace/physlean-bench
source .venv-dsp/bin/activate

python - <<'PY'
import json
import os
import re
import time
from pathlib import Path
from dotenv import load_dotenv
from openai import OpenAI

load_dotenv(".env.llm")

client = OpenAI(api_key=os.environ["OPENAI_API_KEY"])
model = os.environ.get("OPENAI_MODEL", "gpt-5.1")

user = Path.home().name
base = Path("/project/nlp-work11") / user / "theorem_generation/cslib_nonlocal_batch_v0"

gen_path = base / "openai_cslib_nonlocal_generations_first20.jsonl"
check_path = base / "openai_cslib_nonlocal_lean_check_first20.jsonl"
out_path = base / "openai_cslib_nonlocal_repaired_first20.jsonl"

gens = {json.loads(line)["id"]: json.loads(line) for line in gen_path.open()}
checks = [json.loads(line) for line in check_path.open()]

targets = [r for r in checks if r["status"] != "pass"]

def fresh_name(cid: str) -> str:
    m = re.search(r"(\d+)$", cid)
    return f"cslib_nonlocal_candidate_{m.group(1) if m else cid.replace('-', '_')}"

with out_path.open("w") as out:
    for i, c in enumerate(targets, 1):
        g = gens[c["id"]]
        err = ((c.get("stderr") or "") + "\n" + (c.get("stdout") or ""))[-5000:]
        thm_name = fresh_name(c["id"])

        prompt = f"""
You are repairing a Lean theorem candidate for CSLib.

The original theorem candidate failed Lean verification.
Repair it into a Lean file that is more likely to compile in the CSLib project.

Hard constraints:
- Output Lean code only.
- Include necessary imports.
- Output exactly ONE theorem or lemma.
- The theorem/lemma name must be exactly: {thm_name}
- Do NOT use an existing CSLib theorem name.
- Do NOT use sorry or admit.
- Do NOT define new def, structure, abbrev, notation, instance, namespace, or section.
- Do NOT create a trivial theorem like x = x, True, or p -> p.
- Do NOT merely restate one existing theorem.
- Prefer a smaller theorem if the original is too ambitious.
- Use existing CSLib names correctly.
- Make all implicit variables and assumptions explicit when needed.

Source theorem:
{g["source"]}

Target theorem:
{g["target"]}

Original generated Lean:
{g["generated"]}

Lean error / timeout info:
{err}

Repair the Lean code.
"""

        print(f"[{i}/{len(targets)}] repairing {c['id']} as {thm_name}", flush=True)

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
            "fresh_name": thm_name,
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
