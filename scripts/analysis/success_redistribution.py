import json
import re
from pathlib import Path
from collections import Counter, defaultdict

def load_jsonl(path):
    rows = []
    with open(path) as f:
        for line in f:
            if line.strip():
                rows.append(json.loads(line))
    return rows

def name_of(r):
    return r.get("declaration_name") or r.get("theorem_id") or r.get("name")

def proof_of(r):
    return r.get("generated_proof") or r.get("proof") or ""

def stdout_of(r):
    return r.get("stdout_tail") or r.get("stderr_tail") or r.get("stdout") or r.get("stderr") or ""

def area_of(name):
    parts = name.split(".")

    if name.startswith("Cslib."):
        if len(parts) >= 3 and parts[1] == "Logic":
            return ".".join(parts[:3])
        if len(parts) >= 3 and parts[1] == "LambdaCalculus":
            return ".".join(parts[:3])
        if len(parts) >= 3 and parts[1] == "URM":
            return ".".join(parts[:3])
        if len(parts) >= 3 and parts[1] == "SKI":
            return ".".join(parts[:3])
        if len(parts) >= 2:
            return ".".join(parts[:2])
        return name

    if name.startswith("Physlib."):
        return ".".join(parts[:2]) if len(parts) >= 2 else name

    return parts[0]

def error_type(r):
    if r.get("timeout"):
        return "timeout"
    s = stdout_of(r)
    if "unknownIdentifier" in s or "Unknown identifier" in s or "Unknown constant" in s:
        return "unknown_identifier"
    if "unexpected token" in s or "expected command" in s or "syntax" in s.lower():
        return "syntax_error"
    if "unsolved goals" in s:
        return "unsolved_goals"
    if "type mismatch" in s:
        return "type_mismatch"
    if not r.get("success"):
        return "other_failure"
    return "success"

def analyze(split, base_path, lora_path, out_dir):
    base_rows = load_jsonl(base_path)
    lora_rows = load_jsonl(lora_path)

    base = {name_of(r): r for r in base_rows}
    lora = {name_of(r): r for r in lora_rows}

    names = sorted(set(base) | set(lora))
    base_pass = {n for n, r in base.items() if r.get("success")}
    lora_pass = {n for n, r in lora.items() if r.get("success")}

    groups = {
        "both_pass": sorted(base_pass & lora_pass),
        "base_only": sorted(base_pass - lora_pass),
        "lora_only": sorted(lora_pass - base_pass),
        "both_fail": sorted(set(names) - base_pass - lora_pass),
    }

    out_dir.mkdir(parents=True, exist_ok=True)

    md = []
    md.append(f"# {split}")
    md.append("")
    md.append("| category | count |")
    md.append("|---|---:|")
    for k, v in groups.items():
        md.append(f"| {k} | {len(v)} |")

    md.append("")
    md.append("## Area counts")
    md.append("")
    md.append("| category | area | count |")
    md.append("|---|---|---:|")
    for cat, ns in groups.items():
        c = Counter(area_of(n) for n in ns)
        for area, count in c.most_common():
            md.append(f"| {cat} | {area} | {count} |")

    md.append("")
    md.append("## Theorem lists")
    for cat, ns in groups.items():
        md.append("")
        md.append(f"### {cat}")
        for n in ns:
            md.append(f"- {n}")

    out_md = out_dir / f"{split.replace(' ', '_').lower()}.success_redistribution.md"
    out_md.write_text("\n".join(md) + "\n")

    err_rows = []
    for n in names:
        br = base.get(n, {})
        lr = lora.get(n, {})
        err_rows.append({
            "name": n,
            "area": area_of(n),
            "base_success": bool(br.get("success")),
            "lora_success": bool(lr.get("success")),
            "base_error": error_type(br),
            "lora_error": error_type(lr),
            "base_proof": proof_of(br)[:200].replace("\n", "\\n"),
            "lora_proof": proof_of(lr)[:200].replace("\n", "\\n"),
        })

    out_jsonl = out_dir / f"{split.replace(' ', '_').lower()}.success_redistribution.jsonl"
    with open(out_jsonl, "w") as f:
        for r in err_rows:
            f.write(json.dumps(r, ensure_ascii=False) + "\n")

    print(split)
    print("  n =", len(names))
    print("  both_pass =", len(groups["both_pass"]))
    print("  base_only =", len(groups["base_only"]))
    print("  lora_only =", len(groups["lora_only"]))
    print("  both_fail =", len(groups["both_fail"]))
    print("  wrote =", out_md)
    print("  wrote =", out_jsonl)

if __name__ == "__main__":
    print("success_redistribution.py created")
