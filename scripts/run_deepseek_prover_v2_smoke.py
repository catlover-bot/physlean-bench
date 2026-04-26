import argparse
import json
import re
from pathlib import Path

import torch
from transformers import AutoModelForCausalLM, AutoTokenizer


def clean_output(text: str) -> str:
    text = text.strip()
    m = re.search(r"```(?:lean4|lean)?\s*(.*?)```", text, flags=re.DOTALL | re.IGNORECASE)
    if m:
        text = m.group(1).strip()
    return text.strip()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--input", required=True)
    ap.add_argument("--output", required=True)
    ap.add_argument("--model", default="deepseek-ai/DeepSeek-Prover-V2-7B")
    ap.add_argument("--max-new-tokens", type=int, default=512)
    ap.add_argument("--temperature", type=float, default=0.2)
    ap.add_argument("--top-p", type=float, default=0.95)
    ap.add_argument("--num-samples", type=int, default=1)
    args = ap.parse_args()

    torch.manual_seed(42)

    in_path = Path(args.input)
    out_path = Path(args.output)
    out_path.parent.mkdir(parents=True, exist_ok=True)

    print(f"loading tokenizer: {args.model}", flush=True)
    tokenizer = AutoTokenizer.from_pretrained(args.model, trust_remote_code=True)

    print(f"loading model: {args.model}", flush=True)
    model = AutoModelForCausalLM.from_pretrained(
        args.model,
        device_map="auto",
        dtype=torch.float16,
        trust_remote_code=True,
    )
    model.eval()

    records = [json.loads(l) for l in in_path.open()]
    print(f"records={len(records)}", flush=True)

    done = set()
    if out_path.exists():
        with out_path.open() as f:
            for line in f:
                try:
                    obj = json.loads(line)
                    done.add((obj["theorem_id"], obj.get("sample_id", 0)))
                except Exception:
                    pass
        print(f"resume: already_done={len(done)}", flush=True)

    with out_path.open("a") as g:
        for idx, r in enumerate(records):
            for sample_id in range(args.num_samples):
                key = (r["theorem_id"], sample_id)
                if key in done:
                    continue

                chat = [{"role": "user", "content": r["prompt"]}]

                # Robust path: first build chat text, then tokenize normally.
                prompt_text = tokenizer.apply_chat_template(
                    chat,
                    tokenize=False,
                    add_generation_prompt=True,
                )

                inputs = tokenizer(
                    prompt_text,
                    return_tensors="pt",
                    truncation=True,
                    max_length=8192,
                )
                inputs = {k: v.to(model.device) for k, v in inputs.items()}
                prompt_len = inputs["input_ids"].shape[-1]

                with torch.inference_mode():
                    outputs = model.generate(
                        **inputs,
                        max_new_tokens=args.max_new_tokens,
                        do_sample=args.temperature > 0,
                        temperature=args.temperature,
                        top_p=args.top_p,
                        pad_token_id=tokenizer.eos_token_id,
                    )

                gen_ids = outputs[0][prompt_len:]
                raw = tokenizer.decode(gen_ids, skip_special_tokens=True)
                proof = clean_output(raw)

                item = {
                    "idx": idx,
                    "sample_id": sample_id,
                    "theorem_id": r["theorem_id"],
                    "declaration_name": r["declaration_name"],
                    "file_path": r["file_path"],
                    "module_path": r["module_path"],
                    "namespace": r.get("namespace"),
                    "statement": r["statement"],
                    "gold_proof": r["gold_proof"],
                    "prompt": r["prompt"],
                    "raw_generation": raw,
                    "generated_proof": proof,
                    "model": args.model,
                    "max_new_tokens": args.max_new_tokens,
                    "temperature": args.temperature,
                    "top_p": args.top_p,
                }

                g.write(json.dumps(item, ensure_ascii=False) + "\n")
                g.flush()

                print(
                    f"[{idx + 1}/{len(records)}] sample={sample_id} {r['declaration_name']}",
                    flush=True,
                )


if __name__ == "__main__":
    main()
