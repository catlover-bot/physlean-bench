#!/bin/bash
#SBATCH -J phys_v3_chk40
#SBATCH -A lang
#SBATCH -p lang_long
#SBATCH -c 4
#SBATCH --mem=16G
#SBATCH -t 03:00:00
#SBATCH -o /project/nlp-work11/%u/theorem_generation/nonlocal_batch_v3/logs/%x-%j.out
#SBATCH -e /project/nlp-work11/%u/theorem_generation/nonlocal_batch_v3/logs/%x-%j.err

set -euxo pipefail

python3 - <<'PY'
import json
import subprocess
from pathlib import Path

user = Path.home().name

base = Path("/project/nlp-work11") / user / "theorem_generation/nonlocal_batch_v3"
in_path = base / "openai_physlib_nonlocal_generations_0020_0059.jsonl"
lean_dir = base / "lean_files_0020_0059"
result_path = base / "openai_physlib_nonlocal_lean_check_0020_0059.jsonl"

physlib_work = Path("/project/nlp-work11") / user / "physlean_eval_work/physlib_eval_smoke_built"

lean_dir.mkdir(parents=True, exist_ok=True)

rows = [json.loads(line) for line in in_path.open()]

passed = failed = timed_out = 0

with result_path.open("w") as out:
    for r in rows:
        lean_path = lean_dir / f"{r['id']}.lean"
        lean_path.write_text(r["generated"] + "\n")

        try:
            p = subprocess.run(
                ["lake", "env", "lean", str(lean_path)],
                cwd=physlib_work,
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                timeout=90,
            )
            status = "pass" if p.returncode == 0 else "fail"
            stdout = p.stdout[-2000:]
            stderr = p.stderr[-2000:]
            returncode = p.returncode
        except subprocess.TimeoutExpired as e:
            status = "timeout"
            stdout = (e.stdout or "")[-2000:] if isinstance(e.stdout, str) else ""
            stderr = (e.stderr or "")[-2000:] if isinstance(e.stderr, str) else ""
            returncode = None

        passed += int(status == "pass")
        failed += int(status == "fail")
        timed_out += int(status == "timeout")

        out.write(json.dumps({
            "id": r["id"],
            "source": r["source"],
            "target": r["target"],
            "lean_file": str(lean_path),
            "status": status,
            "returncode": returncode,
            "stdout": stdout,
            "stderr": stderr,
        }, ensure_ascii=False) + "\n")
        out.flush()

        print(status.upper(), r["id"], r["source"], "->", r["target"], flush=True)

print()
print("passed:", passed)
print("failed:", failed)
print("timeout:", timed_out)
print("saved:", result_path)
PY
