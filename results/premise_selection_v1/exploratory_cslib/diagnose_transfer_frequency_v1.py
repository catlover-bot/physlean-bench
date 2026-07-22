import importlib.util
import json
import math
import statistics
from collections import Counter
from pathlib import Path

ROOT = Path("/project/nlp-work11") / Path.home().name
BENCH = (
    ROOT
    / "theorem_generation"
    / "premise_selection_cslib_v0"
)

BASE_SCRIPT = BENCH / "scripts/evaluate_graph_transfer_v1.py"
SAFE_PRED_PATH = (
    BENCH
    / "safe_import_replacement_predictions_test_v1.jsonl"
)
RECOVER_PATH = BENCH / "transfer_recoverability_diagnosis_v1.json"
OUTPUT_PATH = BENCH / "transfer_frequency_diagnosis_v1.json"

spec = importlib.util.spec_from_file_location(
    "cslib_graph_transfer",
    BASE_SCRIPT,
)
base = importlib.util.module_from_spec(spec)
spec.loader.exec_module(base)

train_gold_frequency = Counter()

for target in base.train_targets:
    for premise_id in target["gold_premise_ids"]:
        name = base.catalog_by_id[premise_id]["declaration_name"]
        train_gold_frequency[name] += 1

safe_predictions = [
    json.loads(line)
    for line in SAFE_PRED_PATH.read_text().splitlines()
    if line.strip()
]

recoverability = json.loads(RECOVER_PATH.read_text())

false_promotions = []

for row in safe_predictions:
    gold = set(row["gold_premise_names"])

    for name in row["promoted_premise_names"]:
        if name not in gold:
            false_promotions.append({
                "target": row["declaration_name"],
                "premise": name,
                "train_gold_frequency": train_gold_frequency[name],
            })

recoverable_gold = [
    {
        "target": row["target"],
        "premise": row["premise"],
        "bm25_rank": row["bm25_rank"],
        "transfer_rank": row["transfer_rank"],
        "transfer_score": row["transfer_score"],
        "train_gold_frequency": train_gold_frequency[row["premise"]],
    }
    for row in recoverability["missed_gold_records"]
    if row["transfer_score"] > 0
]


def summarize(values):
    if not values:
        return {
            "count": 0,
            "min": None,
            "median": None,
            "mean": None,
            "max": None,
        }

    return {
        "count": len(values),
        "min": min(values),
        "median": statistics.median(values),
        "mean": statistics.mean(values),
        "max": max(values),
    }


false_frequencies = [
    row["train_gold_frequency"]
    for row in false_promotions
]

gold_frequencies = [
    row["train_gold_frequency"]
    for row in recoverable_gold
]

train_target_count = len(base.train_targets)


def inverse_frequency_weight(frequency):
    return math.log(
        (train_target_count + 1.0) / (frequency + 1.0)
    ) + 1.0


for row in false_promotions:
    row["inverse_frequency_weight"] = (
        inverse_frequency_weight(
            row["train_gold_frequency"]
        )
    )

for row in recoverable_gold:
    row["inverse_frequency_weight"] = (
        inverse_frequency_weight(
            row["train_gold_frequency"]
        )
    )
    row["specificity_adjusted_transfer"] = (
        row["transfer_score"]
        * row["inverse_frequency_weight"]
    )

output = {
    "analysis": (
        "Training gold-frequency comparison between false "
        "safe promotions and recoverable missed gold premises"
    ),
    "train_positive_target_count": train_target_count,
    "false_promotion_frequency_statistics": summarize(
        false_frequencies
    ),
    "recoverable_gold_frequency_statistics": summarize(
        gold_frequencies
    ),
    "false_promotions": false_promotions,
    "recoverable_gold": recoverable_gold,
}

OUTPUT_PATH.write_text(
    json.dumps(output, ensure_ascii=False, indent=2)
    + "\n"
)

print("CSLib transfer-frequency diagnosis")
print("=" * 108)
print("train positive targets:", train_target_count)

print("\nFrequency statistics")
print("-" * 108)
print(
    "false promotions :",
    output["false_promotion_frequency_statistics"],
)
print(
    "recoverable gold :",
    output["recoverable_gold_frequency_statistics"],
)

print("\nFalse promotions")
print("-" * 108)

for row in sorted(
    false_promotions,
    key=lambda x: (
        -x["train_gold_frequency"],
        x["premise"],
        x["target"],
    ),
):
    print(json.dumps(row, ensure_ascii=False))

print("\nRecoverable missed gold")
print("-" * 108)

for row in sorted(
    recoverable_gold,
    key=lambda x: (
        -x["specificity_adjusted_transfer"],
        x["transfer_rank"],
        x["target"],
    ),
):
    print(json.dumps({
        "target": row["target"],
        "premise": row["premise"],
        "bm25_rank": row["bm25_rank"],
        "transfer_rank": row["transfer_rank"],
        "transfer_score": round(
            row["transfer_score"],
            6,
        ),
        "train_gold_frequency": (
            row["train_gold_frequency"]
        ),
        "inverse_frequency_weight": round(
            row["inverse_frequency_weight"],
            6,
        ),
        "specificity_adjusted_transfer": round(
            row["specificity_adjusted_transfer"],
            6,
        ),
    }, ensure_ascii=False))

print("\nsaved:", OUTPUT_PATH)
