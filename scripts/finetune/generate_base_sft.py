import argparse
import json
from pathlib import Path

import torch
from transformers import AutoTokenizer, AutoModelForCausalLM


def clean_generation(text: str) -> str:
    text = text.strip()
    text = text.replace("```lean4", "").replace("```lean", "").replace("```", "").strip()
    if ":=" in text:
        text = text.split(":=", 1)[1].strip()
    return text


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--model", default="deepseek-ai/DeepSeek-Prover-V2-7B")
    ap.add_argument("--input", required=True)
    ap.add_argument("--output", required=True)
    ap.add_argument("--max-new-tokens", type=int, default=512)
    args = ap.parse_args()

    inp = Path(args.input)
    out = Path(args.output)
    out.parent.mkdir(parents=True, exist_ok=True)

    tokenizer = AutoTokenizer.from_pretrained(args.model, trust_remote_code=True)
    if tokenizer.pad_token is None:
        tokenizer.pad_token = tokenizer.eos_token

    model = AutoModelForCausalLM.from_pretrained(
        args.model,
        torch_dtype=torch.float16,
        device_map="auto",
        trust_remote_code=True,
    )
    model.eval()

    n = 0
    with inp.open() as f, out.open("w") as g:
        for line in f:
            if not line.strip():
                continue

            r = json.loads(line)
            prompt = r["prompt"]

            inputs = tokenizer(prompt, return_tensors="pt").to(model.device)

            with torch.no_grad():
                gen = model.generate(
                    **inputs,
                    max_new_tokens=args.max_new_tokens,
                    do_sample=False,
                    pad_token_id=tokenizer.eos_token_id,
                    eos_token_id=tokenizer.eos_token_id,
                )

            new_tokens = gen[0][inputs["input_ids"].shape[1]:]
            raw = tokenizer.decode(new_tokens, skip_special_tokens=True)
            proof = clean_generation(raw)

            rr = dict(r)
            rr["raw_generation"] = raw
            rr["generated_proof"] = proof
            rr["generator"] = "base_sft_prompt"

            g.write(json.dumps(rr, ensure_ascii=False) + "\n")
            g.flush()

            n += 1
            print(f"[{n}] {r.get('declaration_name')} chars={len(proof)}")

    print("DONE", n, out)


if __name__ == "__main__":
    main()
