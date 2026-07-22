#!/bin/bash
#SBATCH -J phys_v3_gen40
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

in_path = base / "physlib_nonlocal_prompts_v3_forbid_verified.jsonl"
out_path = base / "openai_physlib_nonlocal_generations_0020_0059.jsonl"

records = [json.loads(line) for line in in_path.open()][20:60]

with out_path.open("w") as f:
    for i, r in enumerate(records, 1):
        print(f"[{i}/{len(records)}] {r['id']} {r['source']} -> {r['target']}", flush=True)

        try:
            resp = client.responses.create(
                model=model,
                input=r["prompt"],
            )
            text = resp.output_text.strip()
            status = "ok"
            error = None
        except Exception as e:
            text = ""
            status = "error"
            error = repr(e)

        f.write(json.dumps({
            "id": r["id"],
            "model": model,
            "status": status,
            "error": error,
            "source": r["source"],
            "target": r["target"],
            "source_file": r["source_file"],
            "target_file": r["target_file"],
            "score": r["score"],
            "reasons": r["reasons"],
            "generated": text,
        }, ensure_ascii=False) + "\n")
        f.flush()

        time.sleep(1)

print("saved:", out_path)
print("generated_count:", len(records))
PY
