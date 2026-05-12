import json
from pathlib import Path
from collections import Counter, defaultdict

base = Path("/project/nlp-work11/hirotaka-m/crossdomain_trace/cslib_bench_v0")
p = base / "eval_deepseek_v2_7b_test_statement_only_full_bytelevel_normalized_timeout600.jsonl"

rows = [json.loads(l) for l in p.open()]
passed = sum(r["success"] for r in rows)

def classify(r):
    text = ((r.get("stdout_tail") or "") + "\n" + (r.get("stderr_tail") or "")).lower()
    if r["success"]:
        return "passed"
    if r.get("timeout"):
        return "timeout"
    if "unknown identifier" in text or "unknown constant" in text:
        return "unknown_identifier"
    if "unsolved goals" in text:
        return "unsolved_goals"
    if "tactic" in text and "failed" in text:
        return "tactic_failed"
    if "unexpected token" in text or "expected command" in text or "invalid" in text:
        return "syntax_or_parser"
    if "failed to synthesize" in text:
        return "typeclass"
    return "other"

by_file = defaultdict(lambda: [0, 0])
for r in rows:
    fp = r.get("file_path", "UNKNOWN")
    by_file[fp][0] += 1
    by_file[fp][1] += int(r["success"])

error_types = Counter(classify(r) for r in rows)

md = []
md.append("# CSLibBench v0: DeepSeek-Prover-V2-7B Baseline\n")
md.append("## Overall result\n")
md.append("| item | value |")
md.append("|---|---:|")
md.append(f"| n | {len(rows)} |")
md.append(f"| passed | {passed} |")
md.append(f"| failed | {len(rows) - passed} |")
md.append(f"| pass@1 | {passed / len(rows):.4f} |")
md.append(f"| timeouts | {sum(r.get('timeout') for r in rows)} |")
md.append("")

md.append("## Error types\n")
md.append("| type | count |")
md.append("|---|---:|")
for k, v in error_types.most_common():
    md.append(f"| {k} | {v} |")
md.append("")

md.append("## By file\n")
md.append("| file | passed | n | pass_rate |")
md.append("|---|---:|---:|---:|")
for fp, (n, s) in sorted(by_file.items()):
    md.append(f"| `{fp}` | {s} | {n} | {s/n:.3f} |")
md.append("")

md.append("## Passed theorems\n")
for r in rows:
    if r["success"]:
        md.append(f"- `{r['declaration_name']}`")

out = base / "report_deepseek_v2_7b_statement_only.md"
out.write_text("\n".join(md))

print("==== CSLibBench v0 / DeepSeek-Prover-V2-7B ====")
print(f"n        = {len(rows)}")
print(f"passed   = {passed}")
print(f"failed   = {len(rows) - passed}")
print(f"pass@1   = {passed / len(rows):.4f}")
print(f"timeouts = {sum(r.get('timeout') for r in rows)}")
print()
print("error_types:")
for k, v in error_types.most_common():
    print(f"  {k:20s} {v}")
print()
print("wrote:", out)
