import argparse
import json
from pathlib import Path

import torch
from torch.utils.data import Dataset

from transformers import AutoTokenizer, AutoModelForCausalLM, Trainer, TrainingArguments
from peft import LoraConfig, get_peft_model, TaskType


class JsonlSFTDataset(Dataset):
    def __init__(self, path, tokenizer, max_length=1024, limit=None):
        self.rows = []
        self.tokenizer = tokenizer
        self.max_length = max_length

        with Path(path).open() as f:
            for line in f:
                if line.strip():
                    self.rows.append(json.loads(line))
                if limit is not None and len(self.rows) >= limit:
                    break

    def __len__(self):
        return len(self.rows)

    def __getitem__(self, idx):
        r = self.rows[idx]
        prompt = r["prompt"].strip()
        proof = r["proof"].strip()

        text = prompt + "\n" + proof + self.tokenizer.eos_token

        prompt_ids = self.tokenizer(prompt, add_special_tokens=False)["input_ids"]

        enc = self.tokenizer(
            text,
            add_special_tokens=False,
            truncation=True,
            max_length=self.max_length,
        )

        input_ids = enc["input_ids"]
        attention_mask = enc["attention_mask"]

        labels = input_ids.copy()
        labels[: min(len(prompt_ids), len(labels))] = [-100] * min(len(prompt_ids), len(labels))

        return {
            "input_ids": torch.tensor(input_ids),
            "attention_mask": torch.tensor(attention_mask),
            "labels": torch.tensor(labels),
        }


class Collator:
    def __init__(self, tokenizer):
        self.tokenizer = tokenizer

    def __call__(self, batch):
        max_len = max(len(x["input_ids"]) for x in batch)
        pad_id = self.tokenizer.pad_token_id

        out = {"input_ids": [], "attention_mask": [], "labels": []}

        for x in batch:
            pad = max_len - len(x["input_ids"])

            out["input_ids"].append(torch.cat([
                x["input_ids"],
                torch.full((pad,), pad_id, dtype=torch.long),
            ]))

            out["attention_mask"].append(torch.cat([
                x["attention_mask"],
                torch.zeros(pad, dtype=torch.long),
            ]))

            out["labels"].append(torch.cat([
                x["labels"],
                torch.full((pad,), -100, dtype=torch.long),
            ]))

        return {k: torch.stack(v) for k, v in out.items()}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--model", default="deepseek-ai/DeepSeek-Prover-V2-7B")
    ap.add_argument("--train-jsonl", required=True)
    ap.add_argument("--valid-jsonl", required=True)
    ap.add_argument("--output-dir", required=True)
    ap.add_argument("--max-length", type=int, default=1024)
    ap.add_argument("--epochs", type=float, default=1.0)
    ap.add_argument("--limit-train", type=int, default=None)
    ap.add_argument("--limit-valid", type=int, default=None)
    ap.add_argument("--lr", type=float, default=2e-4)
    ap.add_argument("--lora-r", type=int, default=16)
    ap.add_argument("--lora-alpha", type=int, default=32)
    ap.add_argument("--lora-dropout", type=float, default=0.05)
    args = ap.parse_args()

    out = Path(args.output_dir)
    out.mkdir(parents=True, exist_ok=True)

    tokenizer = AutoTokenizer.from_pretrained(args.model, trust_remote_code=True)
    if tokenizer.pad_token is None:
        tokenizer.pad_token = tokenizer.eos_token

    model = AutoModelForCausalLM.from_pretrained(
        args.model,
        torch_dtype=torch.float16,
        device_map="auto",
        trust_remote_code=True,
    )

    model.config.use_cache = False
    model.gradient_checkpointing_enable()

    lora = LoraConfig(
        task_type=TaskType.CAUSAL_LM,
        r=args.lora_r,
        lora_alpha=args.lora_alpha,
        lora_dropout=args.lora_dropout,
        target_modules=[
            "q_proj", "k_proj", "v_proj", "o_proj",
            "gate_proj", "up_proj", "down_proj",
        ],
    )

    model = get_peft_model(model, lora)
    model.print_trainable_parameters()

    train_ds = JsonlSFTDataset(args.train_jsonl, tokenizer, args.max_length, args.limit_train)
    valid_ds = JsonlSFTDataset(args.valid_jsonl, tokenizer, args.max_length, args.limit_valid)

    training_args = TrainingArguments(
        output_dir=str(out),
        num_train_epochs=args.epochs,
        per_device_train_batch_size=1,
        per_device_eval_batch_size=1,
        gradient_accumulation_steps=8,
        learning_rate=args.lr,
        logging_steps=5,
        eval_steps=25,
        save_steps=25,
        save_total_limit=2,
        eval_strategy="steps",
        save_strategy="steps",
        fp16=True,
        gradient_checkpointing=True,
        optim="adamw_torch",
        report_to=[],
        remove_unused_columns=False,
    )

    trainer = Trainer(
        model=model,
        args=training_args,
        train_dataset=train_ds,
        eval_dataset=valid_ds,
        data_collator=Collator(tokenizer),
    )

    trainer.train()

    adapter_dir = out / "adapter"
    model.save_pretrained(adapter_dir)
    tokenizer.save_pretrained(adapter_dir)

    config = vars(args)
    config["train_size"] = len(train_ds)
    config["valid_size"] = len(valid_ds)

    (out / "run_config.json").write_text(json.dumps(config, indent=2, ensure_ascii=False))

    print("DONE")
    print(json.dumps(config, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
