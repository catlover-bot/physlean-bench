import argparse
import json
import re
from pathlib import Path

def bytes_to_unicode():
    bs = (
        list(range(ord("!"), ord("~") + 1))
        + list(range(ord("¡"), ord("¬") + 1))
        + list(range(ord("®"), ord("ÿ") + 1))
    )
    cs = bs[:]
    n = 0
    for b in range(256):
        if b not in bs:
            bs.append(b)
            cs.append(256 + n)
            n += 1
    cs = [chr(n) for n in cs]
    return dict(zip(bs, cs))

BYTE_DECODER = {v: k for k, v in bytes_to_unicode().items()}

def bytelevel_decode(text):
    if not text:
        return ""
    out = bytearray()
    for ch in text:
        if ch in BYTE_DECODER:
            out.append(BYTE_DECODER[ch])
        else:
            out.extend(ch.encode("utf-8"))
    return bytes(out).decode("utf-8", errors="replace")

def strip_code_fence(text):
    text = text.strip()
    m = re.search(r"```(?:lean4?|Lean4?)?\s*(.*?)```", text, flags=re.DOTALL)
    if m:
        return m.group(1).strip()
    return text.replace("```lean4", "").replace("```lean", "").replace("```", "").strip()

def after_coloneq(text):
    if ":=" in text:
        return text.split(":=", 1)[1].strip()
    return text.strip()

def light_lean_spacing(text):
    # よくある連結だけを保守的に補正する
    fixes = [
        (r"\bbyrfl\b", "by rfl"),
        (r"\bbyaesop\b", "by aesop"),
        (r"\bbyomega\b", "by omega"),
        (r"\bbytrivial\b", "by trivial"),
        (r"\bextsimp\b", "ext; simp"),
        (r"\bexactmem_", "exact mem_"),
        (r"\bapplyle_", "apply le_"),
        (r"\brw\[(.*?)\]apply", r"rw [\1]\napply "),
        (r"\brw\[(.*?)\]exact", r"rw [\1]\nexact "),
        (r"\bsimp\[(.*?)\]", r"simp [\1]"),
        (r"\bsimp_all\[(.*?)\]", r"simp_all [\1]"),
        (r"\brw\[(.*?)\]", r"rw [\1]"),
        (r"\binduction([A-Za-z_][A-Za-z0-9_']*)with", r"induction \1 with"),
        (r"\bbycases", "by_cases "),
        (r"\bbyinduction", "by induction "),
    ]
    for pat, rep in fixes:
        text = re.sub(pat, rep, text)
    return text

def trim_to_proof(text):
    text = text.strip()
    bad_prefixes = ("Here is", "Here’s", "The proof", "Proof:", "Answer:", "QED")
    for p in bad_prefixes:
        if text.startswith(p):
            text = text[len(p):].strip()

    lines = text.splitlines()
    out = []
    for line in lines:
        s = line.strip()
        if re.match(r"^(theorem|lemma|example|def)\b", s):
            break
        if s.startswith("QED") or s.startswith("This completes"):
            break
        out.append(line)
    return "\n".join(out).strip()

def normalize(raw):
    text = raw or ""
    text = text.replace("\r\n", "\n").replace("\r", "\n")
    text = bytelevel_decode(text)
    text = strip_code_fence(text)
    text = after_coloneq(text)
    text = light_lean_spacing(text)
    text = trim_to_proof(text)
    return text.strip()

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--input", required=True)
    ap.add_argument("--output", required=True)
    args = ap.parse_args()

    inp = Path(args.input)
    out = Path(args.output)

    n = changed = empty = 0
    first_tokens = {}

    with inp.open() as f, out.open("w") as g:
        for line in f:
            if not line.strip():
                continue
            r = json.loads(line)
            rr = dict(r)

            old = rr.get("generated_proof") or ""
            raw = rr.get("raw_generation") or old
            new = normalize(raw)

            rr["generated_proof_original"] = old
            rr["generated_proof"] = new
            rr["generated_proof_normalized"] = new
            rr["proof_normalization_applied"] = new != old

            if new != old:
                changed += 1
            if not new:
                empty += 1

            first = new.split(None, 1)[0] if new.split() else "<EMPTY>"
            first_tokens[first] = first_tokens.get(first, 0) + 1

            g.write(json.dumps(rr, ensure_ascii=False) + "\n")
            n += 1

    print(json.dumps({
        "input": str(inp),
        "output": str(out),
        "n": n,
        "changed": changed,
        "empty": empty,
        "first_tokens": first_tokens,
    }, ensure_ascii=False, indent=2))

if __name__ == "__main__":
    main()
