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
    return dict(zip(bs, [chr(c) for c in cs]))

BYTE_DECODER = {v: k for k, v in bytes_to_unicode().items()}

def decode_bytelevel(s: str) -> str:
    bs = bytearray()
    for ch in s:
        if ch in BYTE_DECODER:
            bs.append(BYTE_DECODER[ch])
        else:
            bs.extend(ch.encode("utf-8"))
    return bs.decode("utf-8", errors="replace")

def clean_code(s: str) -> str:
    s = decode_bytelevel(s).strip()
    m = re.search(r"```(?:lean4|lean)?\s*(.*?)```", s, flags=re.DOTALL | re.IGNORECASE)
    if m:
        s = m.group(1).strip()
    return s.strip()

inp = Path("/project/nlp-work11") / Path.home().name / "graph_theorem_generation/v1/graph_v1_generations.jsonl"
out = Path("/project/nlp-work11") / Path.home().name / "graph_theorem_generation/v1/graph_v1_generations_decoded.jsonl"

n = 0
with inp.open() as f, out.open("w") as g:
    for line in f:
        r = json.loads(line)
        r["generated_proof_decoded"] = clean_code(r.get("generated_proof", ""))
        g.write(json.dumps(r, ensure_ascii=False) + "\n")
        n += 1

print("input =", inp)
print("output =", out)
print("records =", n)

print("\n=== sample decoded ===")
first = json.loads(out.read_text().splitlines()[0])
print(first["generated_proof_decoded"][:1200])
