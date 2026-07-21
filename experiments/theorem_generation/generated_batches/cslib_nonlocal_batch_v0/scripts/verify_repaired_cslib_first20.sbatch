#!/bin/bash
#SBATCH -J cslib_rchk20
#SBATCH -A lang
#SBATCH -p lang_long
#SBATCH -c 4
#SBATCH --mem=16G
#SBATCH -t 03:00:00
#SBATCH -o /project/nlp-work11/%u/theorem_generation/cslib_nonlocal_batch_v0/logs/%x-%j.out
#SBATCH -e /project/nlp-work11/%u/theorem_generation/cslib_nonlocal_batch_v0/logs/%x-%j.err

set -euxo pipefail

python3 - <<'PY'
import json
import subprocess
from pathlib import Path

user = Path.home().name

base = Path("/project/nlp-work11") / user / "theorem_generation/cslib_nonlocal_batch_v0"
in_path = base / "openai_cslib_nonlocal_repaired_first20.jsonl"
lean_dir = base / "lean_files_repaired_first20"
result_path = base / "openai_cslib_nonlocal_repaired_lean_check_first20.jsonl"

cslib_work = Path("/home/is") / user / "workspace/cslib"

lean_dir.mkdir(parents=True, exist_ok=True)

rows = [json.loads(line) for line in in_path.open()]

passed = failed = timed_out = 0

with result_path.open("w") as out:
    for r in rows:
        lean_path = lean_dir / f"{r['id']}_repaired.lean"
        lean_path.write_text(r["repaired"] + "\n")

        try:
            p = subprocess.run(
                ["lake", "env", "lean", str(lean_path)],
                cwd=cslib_work,
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
            "fresh_name": r.get("fresh_name"),
            "source": r["source"],
            "target": r["target"],
            "lean_file": str(lean_path),
            "status": status,
            "returncode": returncode,
            "stdout": stdout,
            "stderr": stderr,
        }, ensure_ascii=False) + "\n")
        out.flush()

        print(status.upper(), r["id"], r.get("fresh_name"), r["source"], "->", r["target"], flush=True)

print()
print("passed:", passed)
print("failed:", failed)
print("timeout:", timed_out)
print("saved:", result_path)
PY
