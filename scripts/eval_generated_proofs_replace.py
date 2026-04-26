import argparse
import json
import subprocess
from pathlib import Path


def clean_proof(s: str) -> str:
    s = (s or "").strip()
    # Remove markdown fences if still present.
    lines = []
    for line in s.splitlines():
        if line.strip().startswith("```"):
            continue
        lines.append(line)
    s = "\n".join(lines).strip()
    return s


def tail_text(s: str, n: int = 4000) -> str:
    s = s or ""
    return s[-n:]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--work-repo", required=True)
    ap.add_argument("--generations", required=True)
    ap.add_argument("--metadata", required=True)
    ap.add_argument("--output", required=True)
    ap.add_argument("--proof-field", default="generated_proof")
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--timeout", type=int, default=60)
    args = ap.parse_args()

    work_repo = Path(args.work_repo)
    gens_path = Path(args.generations)
    meta_path = Path(args.metadata)
    out_path = Path(args.output)
    out_path.parent.mkdir(parents=True, exist_ok=True)

    meta_by_id = {}
    with meta_path.open() as f:
        for line in f:
            r = json.loads(line)
            meta_by_id[r["theorem_id"]] = r

    generations = []
    with gens_path.open() as f:
        for line in f:
            r = json.loads(line)
            m = meta_by_id.get(r["theorem_id"])
            if not m:
                raise RuntimeError(f"metadata not found for theorem_id={r['theorem_id']}")
            r.update({
                "line_start": m["line_start"],
                "line_end": m["line_end"],
                "file_path": m["file_path"],
                "statement": m["statement"],
                "gold_proof": m["proof_text"],
            })
            generations.append(r)

    if args.limit and args.limit > 0:
        generations = generations[:args.limit]

    # Load pristine source text for all touched files.
    pristine = {}
    for r in generations:
        fp = r["file_path"]
        p = work_repo / fp
        if fp not in pristine:
            pristine[fp] = p.read_text()

    n = passed = failed = timed_out = 0

    with out_path.open("w") as out:
        for i, r in enumerate(generations):
            n += 1
            fp = r["file_path"]
            path = work_repo / fp

            original_text = pristine[fp]
            original_lines = original_text.splitlines(keepends=True)

            line_start = int(r["line_start"])
            line_end = int(r["line_end"])

            proof = clean_proof(r.get(args.proof_field, ""))
            statement = (r["statement"] or "").strip()

            candidate_block = statement + "\n" + proof + "\n"
            candidate_lines = candidate_block.splitlines(keepends=True)

            # line_start / line_end are 1-indexed and inclusive.
            new_lines = (
                original_lines[: line_start - 1]
                + candidate_lines
                + original_lines[line_end:]
            )

            path.write_text("".join(new_lines))

            try:
                proc = subprocess.run(
                    ["lake", "env", "lean", fp],
                    cwd=work_repo,
                    text=True,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    timeout=args.timeout,
                )
                success = proc.returncode == 0
                timeout_flag = False
            except subprocess.TimeoutExpired as e:
                success = False
                timeout_flag = True
                proc = None

            # Restore file immediately.
            path.write_text(original_text)

            if success:
                passed += 1
            elif timeout_flag:
                timed_out += 1
            else:
                failed += 1

            result = {
                "idx": r.get("idx", i),
                "theorem_id": r["theorem_id"],
                "declaration_name": r.get("declaration_name"),
                "file_path": fp,
                "proof_field": args.proof_field,
                "success": success,
                "timeout": timeout_flag,
                "returncode": None if proc is None else proc.returncode,
                "stdout_tail": "" if proc is None else tail_text(proc.stdout),
                "stderr_tail": "" if proc is None else tail_text(proc.stderr),
                "generated_proof": proof,
                "gold_proof": r.get("gold_proof", ""),
            }
            out.write(json.dumps(result, ensure_ascii=False) + "\n")
            out.flush()

            print(
                f"[{i+1}/{len(generations)}] "
                f"{r.get('declaration_name')} "
                f"success={success} timeout={timeout_flag}",
                flush=True,
            )

    summary = {
        "n": n,
        "passed": passed,
        "failed": failed,
        "timeout": timed_out,
        "pass_rate": passed / n if n else 0.0,
        "proof_field": args.proof_field,
    }
    print(json.dumps(summary, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
