import importlib.util
import json
import random
import statistics
from pathlib import Path

root = Path("/project/nlp-work11") / Path.home().name
bench_dir = root / "theorem_generation/premise_selection_physlib_v0"

method_script = bench_dir / "scripts/evaluate_import_quota_v1.py"
baseline_path = bench_dir / "baseline_predictions_test_v1.jsonl"
targets_path = bench_dir / "physlib_premise_targets_positive_v1.jsonl"

output_path = bench_dir / "bootstrap_import_quota_vs_bm25_v1.json"
preview_path = bench_dir / "bootstrap_import_quota_vs_bm25_v1.txt"
balanced_predictions_path = (
    bench_dir / "import_quota_balanced_predictions_test_v1.jsonl"
)
recall_predictions_path = (
    bench_dir / "import_quota_recall_predictions_test_v1.jsonl"
)

spec = importlib.util.spec_from_file_location(
    "import_quota_method",
    method_script,
)
method = importlib.util.module_from_spec(spec)
spec.loader.exec_module(method)

_, balanced_predictions = method.evaluate_import_quota(
    method.base.test_features,
    method.best_balanced["protected_prefix"],
    method.best_balanced["imported_quota"],
    method.best_balanced["transfer_weight"],
    save_predictions=True,
)

_, recall_predictions = method.evaluate_import_quota(
    method.base.test_features,
    method.best_recall["protected_prefix"],
    method.best_recall["imported_quota"],
    method.best_recall["transfer_weight"],
    save_predictions=True,
)

for path, rows in [
    (balanced_predictions_path, balanced_predictions),
    (recall_predictions_path, recall_predictions),
]:
    with path.open("w") as file:
        for row in rows:
            file.write(json.dumps(row, ensure_ascii=False) + "\n")

baseline_rows = {
    row["declaration_name"]: row
    for row in (
        json.loads(line)
        for line in baseline_path.read_text().splitlines()
        if line.strip()
    )
}

target_rows = {
    row["declaration_name"]: row
    for row in (
        json.loads(line)
        for line in targets_path.read_text().splitlines()
        if line.strip()
    )
    if row["split"] == "test"
}

method_rows = {
    "balanced": {
        row["declaration_name"]: row
        for row in balanced_predictions
    },
    "recall_oriented": {
        row["declaration_name"]: row
        for row in recall_predictions
    },
}

KS = [5, 10, 20, 50]
ITERATIONS = 10000
SEED = 20260712

def build_records(predictions):
    names = sorted(
        set(baseline_rows)
        & set(predictions)
        & set(target_rows)
    )

    if len(names) != 308:
        raise RuntimeError(
            f"expected 308 matched targets, found {len(names)}"
        )

    records = []

    for name in names:
        baseline = baseline_rows[name]
        prediction = predictions[name]
        target = target_rows[name]

        gold = set(target["gold_premise_names"])
        local_gold = set(target["gold_same_file_earlier"])
        imported_gold = set(target["gold_imported_modules"])

        bm25_ranking = baseline["rankings"]["bm25"][
            "top_50_premise_names"
        ]
        method_ranking = prediction["top_50_premise_names"]

        row = {
            "gold_count": len(gold),
            "local_gold_count": len(local_gold),
            "imported_gold_count": len(imported_gold),
            "bm25_rr": (
                1.0
                / baseline["rankings"]["bm25"]["first_gold_rank"]
            ),
            "method_rr": 1.0 / prediction["first_gold_rank"],
        }

        for k in KS:
            bm25_topk = set(bm25_ranking[:k])
            method_topk = set(method_ranking[:k])

            row[f"bm25_recovered@{k}"] = len(
                gold & bm25_topk
            )
            row[f"method_recovered@{k}"] = len(
                gold & method_topk
            )

            row[f"bm25_local@{k}"] = len(
                local_gold & bm25_topk
            )
            row[f"method_local@{k}"] = len(
                local_gold & method_topk
            )

            row[f"bm25_imported@{k}"] = len(
                imported_gold & bm25_topk
            )
            row[f"method_imported@{k}"] = len(
                imported_gold & method_topk
            )

        records.append(row)

    return records

def aggregate(records):
    result = {
        "MRR": {
            "bm25": statistics.mean(
                row["bm25_rr"] for row in records
            ),
            "method": statistics.mean(
                row["method_rr"] for row in records
            ),
        }
    }

    for k in KS:
        gold_total = sum(
            row["gold_count"] for row in records
        )
        local_total = sum(
            row["local_gold_count"] for row in records
        )
        imported_total = sum(
            row["imported_gold_count"] for row in records
        )

        result[f"Recall@{k}"] = {
            "bm25": sum(
                row[f"bm25_recovered@{k}"]
                for row in records
            ) / gold_total,
            "method": sum(
                row[f"method_recovered@{k}"]
                for row in records
            ) / gold_total,
        }

        result[f"LocalRecall@{k}"] = {
            "bm25": sum(
                row[f"bm25_local@{k}"]
                for row in records
            ) / local_total,
            "method": sum(
                row[f"method_local@{k}"]
                for row in records
            ) / local_total,
        }

        result[f"ImportedRecall@{k}"] = {
            "bm25": sum(
                row[f"bm25_imported@{k}"]
                for row in records
            ) / imported_total,
            "method": sum(
                row[f"method_imported@{k}"]
                for row in records
            ) / imported_total,
        }

    return result

def percentile(values, fraction):
    ordered = sorted(values)
    index = round((len(ordered) - 1) * fraction)
    return ordered[index]

def compare(predictions, method_name):
    records = build_records(predictions)
    observed = aggregate(records)

    differences = {
        metric: []
        for metric in observed
    }

    random.seed(SEED)

    for _ in range(ITERATIONS):
        sample = [
            records[random.randrange(len(records))]
            for _ in range(len(records))
        ]

        metrics = aggregate(sample)

        for metric, values in metrics.items():
            differences[metric].append(
                values["method"] - values["bm25"]
            )

    comparisons = {}

    for metric, values in observed.items():
        bootstrap_values = differences[metric]
        low = percentile(bootstrap_values, 0.025)
        high = percentile(bootstrap_values, 0.975)

        comparisons[metric] = {
            "bm25": values["bm25"],
            method_name: values["method"],
            "difference": (
                values["method"] - values["bm25"]
            ),
            "ci95": [low, high],
            "probability_method_better": (
                sum(value > 0 for value in bootstrap_values)
                / ITERATIONS
            ),
            "significant_at_0.05": (
                low > 0 or high < 0
            ),
        }

    win_loss = {}

    for k in KS:
        wins = 0
        ties = 0
        losses = 0

        for row in records:
            difference = (
                row[f"method_recovered@{k}"]
                - row[f"bm25_recovered@{k}"]
            )

            if difference > 0:
                wins += 1
            elif difference < 0:
                losses += 1
            else:
                ties += 1

        win_loss[f"Recall@{k}"] = {
            "method_wins": wins,
            "ties": ties,
            "method_losses": losses,
        }

    return {
        "method_name": method_name,
        "target_count": len(records),
        "metrics": comparisons,
        "per_target_win_loss": win_loss,
    }

results = {
    "comparison": "BM25 vs import-aware dual-channel rankings",
    "bootstrap_iterations": ITERATIONS,
    "random_seed": SEED,
    "balanced_configuration": {
        "protected_prefix": (
            method.best_balanced["protected_prefix"]
        ),
        "imported_quota": (
            method.best_balanced["imported_quota"]
        ),
        "transfer_weight": (
            method.best_balanced["transfer_weight"]
        ),
    },
    "recall_oriented_configuration": {
        "protected_prefix": (
            method.best_recall["protected_prefix"]
        ),
        "imported_quota": (
            method.best_recall["imported_quota"]
        ),
        "transfer_weight": (
            method.best_recall["transfer_weight"]
        ),
    },
    "balanced": compare(
        method_rows["balanced"],
        "balanced",
    ),
    "recall_oriented": compare(
        method_rows["recall_oriented"],
        "recall_oriented",
    ),
}

output_path.write_text(
    json.dumps(results, ensure_ascii=False, indent=2) + "\n"
)

selected_metrics = [
    "MRR",
    "Recall@5",
    "Recall@10",
    "Recall@20",
    "Recall@50",
    "LocalRecall@20",
    "ImportedRecall@20",
]

with preview_path.open("w") as file:
    file.write(
        "Paired bootstrap: BM25 vs import-aware rankings\n"
    )
    file.write("=" * 104 + "\n")
    file.write(
        f"targets=308 iterations={ITERATIONS}\n\n"
    )

    for key, title in [
        ("balanced", "Balanced"),
        ("recall_oriented", "Recall-oriented"),
    ]:
        comparison = results[key]
        method_name = comparison["method_name"]

        file.write(title + "\n")
        file.write("-" * 104 + "\n")
        file.write(
            f"{'metric':24s} "
            f"{'BM25':>9s} "
            f"{title:>16s} "
            f"{'Diff':>9s} "
            f"{'95% CI':>23s} "
            f"{'P(method>BM25)':>17s}\n"
        )

        for metric in selected_metrics:
            row = comparison["metrics"][metric]
            low, high = row["ci95"]

            file.write(
                f"{metric:24s} "
                f"{row['bm25']:9.4f} "
                f"{row[method_name]:16.4f} "
                f"{row['difference']:+9.4f} "
                f"[{low:+.4f}, {high:+.4f}] "
                f"{row['probability_method_better']:17.4f}\n"
            )

        file.write("\nPer-target wins/losses\n")

        for metric, values in (
            comparison["per_target_win_loss"].items()
        ):
            file.write(
                f"{metric:12s} "
                f"wins={values['method_wins']:3d} "
                f"ties={values['ties']:3d} "
                f"losses={values['method_losses']:3d}\n"
            )

        file.write("\n")

print(preview_path.read_text())
print("saved:", output_path)
print("saved:", preview_path)
print("saved:", balanced_predictions_path)
print("saved:", recall_predictions_path)
