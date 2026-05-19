import json
import re
from pathlib import Path

BASE = Path("/project/nlp-work11/hirotaka-m/crossdomain_trace/cslib_bench_v0")
SRC = BASE / "deepseek_v2_7b_generations_test_statement_only_full.jsonl"
DST = BASE / "deepseek_v2_7b_generations_test_statement_only_full.normalized.jsonl"
SUMMARY = BASE / "deepseek_v2_7b_generations_test_statement_only_full.normalization_summary.json"

PROOF_START_RE = re.compile(
    r"^\s*(by\b|exact\b|rfl\b|simp\b|omega\b|aesop\b|constructor\b|intro\b|intros\b|apply\b|refine\b|rw\b|simpa\b|have\b|calc\b)"
)

BAD_LINE_PREFIXES = (
    "Here is",
    "Here’s",
    "The proof",
    "Proof:",
    "Answer:",
    "We need",
    "This theorem",
)

def strip_code_fence(text: str) -> str:
    text = text.strip()

    # Prefer content inside the first markdown fence if present.
    m = re.search(r"```(?:lean4?|Lean4?)?\s*(.*?)```", text, flags=re.DOTALL)
    if m:
        return m.group(1).strip()

    # Remove unmatched fences.
    text = text.replace("```lean4", "").replace("```lean", "").replace("```", "")
    return text.strip()

def after_coloneq(text: str) -> str:
    # If model restates theorem: theorem ... := by ...
    if ":=" in text:
        return text.split(":=", 1)[1].strip()
    return text.strip()

def trim_to_proof_start(text: str) -> str:
    lines = text.splitlines()

    # Remove obvious prose lines at top.
    while lines and (not lines[0].strip() or any(lines[0].strip().startswith(p) for p in BAD_LINE_PREFIXES)):
        lines.pop(0)

    # If proof starts later, drop preceding theorem/prose lines.
    for i, line in enumerate(lines):
        if PROOF_START_RE.match(line):
            return "\n".join(lines[i:]).strip()

    return "\n".join(lines).strip()

def remove_trailing_prose(text: str) -> str:
    lines = text.splitlines()
    out = []

    for line in lines:
        s = line.strip()

        # Stop if another declaration starts.
        if re.match(r"^(theorem|lemma|example|def)\b", s):
            break

        # Stop on common markdown/prose after proof.
        if s.startswith("This completes") or s.startswith("Therefore,") or s.startswith("QED"):
            break

        out.append(line)

    return "\n".join(out).strip()

def normalize(raw: str) -> str:
    text = raw or ""
    text = text.replace("\r\n", "\n").replace("\r", "\n")
    text = strip_code_fence(text)
    text = after_coloneq(text)
    text = trim_to_proof_start(text)
    text = remove_trailing_prose(text)
    return text.strip()

n = 0
changed = 0
empty = 0
starts = {}

with SRC.open() as f, DST.open("w") as g:
    for line in f:
        r = json.loads(line)
        rr = dict(r)

        raw = rr.get("raw_generation") or rr.get("generated_proof") or ""
        old = rr.get("generated_proof") or ""
        new = normalize(raw)

        rr["generated_proof_original"] = old
        rr["generated_proof"] = new
        rr["generated_proof_normalized"] = new
        rr["normalization_applied"] = (new != old)

        if new != old:
            changed += 1
        if not new:
            empty += 1

        first = new.split(None, 1)[0] if new.split() else "<EMPTY>"
        starts[first] = starts.get(first, 0) + 1

        g.write(json.dumps(rr, ensure_ascii=False) + "\n")
        n += 1

summary = {
    "source": str(SRC),
    "output": str(DST),
    "n": n,
    "changed": changed,
    "empty": empty,
    "first_token_counts": starts,
}

SUMMARY.write_text(json.dumps(summary, indent=2, ensure_ascii=False))

print(json.dumps(summary, indent=2, ensure_ascii=False))
print("wrote", DST)
