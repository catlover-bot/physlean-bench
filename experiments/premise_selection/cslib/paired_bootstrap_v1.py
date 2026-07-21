import importlib.util
import json
import math
import random
from pathlib import Path

ROOT = Path("/project/nlp-work11") / Path.home().name
BENCH = (
    ROOT
    / "theorem_generation"
    / "premise_selection_cslib_v0"
)

SCRIPT = BENCH / "scripts/evaluate_import_quota_v1.py"
RESULT_PATH = BENCH / "import_quota_results_v1.json"
OUTPUT_PATH = BENCH / "paired_bootstrap_results_v1.json"

BOOTSTRAP_SAMPLES = 10_000
RANDOM_SEED = 20260721
KS = [10, 20, 50]

spec = importlib.util.spec_from_file_location(
    "cslib_import_quota",
    SCRIPT,
)
quota_module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(quota_module)

base = quota_module.base
results = json.loads(RESULT_PATH.read_text())
config = results["best_balanced_validation"]

bm25_weights = {
    "bm25": 1.0,
    "graph": 0.0,
    "name": 0.0,
    "transfer": 0.0,
}


def rank_bm25(record):
    target = record["target"]
    features = record["features"]

    return sorted(
        target["candidate_premise_ids"],
        key=lambda premise_id: (
            features["bm25"][premise_id],
            base.catalog_by_id[premise_id][
                "declaration_name"
            ],
        ),
        reverse=True,
    )


def rank_quota(record):
    target = record["target"]
    features = record["features"]
    candidate_ids = target["candidate_premise_ids"]

    bm25_scores = features["bm25"]

    hybrid_scores = {
        premise_id: (
            (1.0 - config["transfer_weight"])
            * features["bm25"][premise_id]
            + config["transfer_weight"]
            * features["transfer"][premise_id]
        )
        for premise_id in candidate_ids
    }

    bm25_ranking = sorted(
        candidate_ids,
        key=lambda premise_id: (
            bm25_scores[premise_id],
            base.catalog_by_id[premise_id][
                "declaration_name"
            ],
        ),
        reverse=True,
    )

    protected = bm25_ranking[
        : config["protected_prefix"]
    ]
    used = set(protected)

    imported_tail = [
        premise_id
        for premise_id in candidate_ids
        if (
            premise_id not in used
            and base.catalog_by_id[premise_id]["file_path"]
            != target["file_path"]
        )
    ]

    imported_tail.sort(
        key=lambda premise_id: (
            hybrid_scores[premise_id],
            bm25_scores[premise_id],
            base.catalog_by_id[premise_id][
                "declaration_name"
            ],
        ),
        reverse=True,
    )

    selected_imported = imported_tail[
        : config["imported_quota"]
    ]

    top_window = list(protected)
    top_window.extend(selected_imported)
    used.update(selected_imported)

    for premise_id in bm25_ranking:
        if len(top_window) >= quota_module.RERANK_CUTOFF:
            break

        if premise_id in used:
            continue

        top_window.append(premise_id)
        used.add(premise_id)

    remaining = [
        premise_id
        for premise_id in candidate_ids
        if premise_id not in used
    ]

    remaining.sort(
        key=lambda premise_id: (
            hybrid_scores[premise_id],
            bm25_scores[premise_id],
            base.catalog_by_id[premise_id][
                "declaration_name"
            ],
        ),
        reverse=True,
    )

    return top_window + remaining


def target_metrics(record, ranking):
    target = record["target"]
    gold_ids = set(target["gold_premise_ids"])

    imported_names = set(
        target["gold_imported_modules"]
    )
    imported_ids = {
        premise_id
        for premise_id in gold_ids
        if (
            base.catalog_by_id[premise_id][
                "declaration_name"
            ]
            in imported_names
        )
    }

    ranks = {
        premise_id: rank
        for rank, premise_id in enumerate(ranking, 1)
        if premise_id in gold_ids
    }

    metrics = {
        "rr": 1.0 / min(ranks.values()),
        "gold_count": len(gold_ids),
        "imported_gold_count": len(imported_ids),
    }

    for k in KS:
        topk = set(ranking[:k])

        metrics[f"recovered@{k}"] = len(
            gold_ids & topk
        )
        metrics[f"imported_recovered@{k}"] = len(
            imported_ids & topk
        )

    return metrics


pairs = []

for record in base.test_features:
    pairs.append({
        "target": record["target"]["declaration_name"],
        "bm25": target_metrics(
            record,
            rank_bm25(record),
        ),
        "quota": target_metrics(
            record,
            rank_quota(record),
        ),
    })


def aggregate(indices, method):
    selected = [pairs[index][method] for index in indices]

    total_gold = sum(row["gold_count"] for row in selected)
    total_imported = sum(
        row["imported_gold_count"]
        for row in selected
    )

    result = {
        "MRR": sum(row["rr"] for row in selected)
        / len(selected),
    }

    for k in KS:
        result[f"micro_recall@{k}"] = (
            sum(row[f"recovered@{k}"] for row in selected)
            / total_gold
        )

        result[f"imported_recall@{k}"] = (
            sum(
                row[f"imported_recovered@{k}"]
                for row in selected
            )
            / total_imported
            if total_imported
            else None
        )

    return result


def quantile(values, q):
    ordered = sorted(values)
    position = (len(ordered) - 1) * q
    lower = math.floor(position)
    upper = math.ceil(position)

    if lower == upper:
        return ordered[lower]

    fraction = position - lower
    return (
        ordered[lower] * (1.0 - fraction)
        + ordered[upper] * fraction
    )


all_indices = list(range(len(pairs)))
bm25_observed = aggregate(all_indices, "bm25")
quota_observed = aggregate(all_indices, "quota")

official_bm25 = results["test_bm25"]
official_quota = results["best_balanced_test"]

for metric in [
    "MRR",
    "micro_recall@10",
    "micro_recall@20",
    "micro_recall@50",
    "imported_recall@20",
    "imported_recall@50",
]:
    if abs(
        bm25_observed[metric] - official_bm25[metric]
    ) > 1e-12:
        raise RuntimeError(
            f"BM25 reconstruction mismatch for {metric}: "
            f"{bm25_observed[metric]} != "
            f"{official_bm25[metric]}"
        )

    if abs(
        quota_observed[metric] - official_quota[metric]
    ) > 1e-12:
        raise RuntimeError(
            f"quota reconstruction mismatch for {metric}: "
            f"{quota_observed[metric]} != "
            f"{official_quota[metric]}"
        )

print("official metric reconstruction: PASS")

metric_names = [
    "MRR",
    "micro_recall@10",
    "micro_recall@20",
    "micro_recall@50",
    "imported_recall@20",
    "imported_recall@50",
]

observed_deltas = {
    metric: quota_observed[metric] - bm25_observed[metric]
    for metric in metric_names
}

rng = random.Random(RANDOM_SEED)

bootstrap_deltas = {
    metric: []
    for metric in metric_names
}

for _ in range(BOOTSTRAP_SAMPLES):
    sample = [
        rng.randrange(len(pairs))
        for _ in pairs
    ]

    bm25_sample = aggregate(sample, "bm25")
    quota_sample = aggregate(sample, "quota")

    for metric in metric_names:
        bootstrap_deltas[metric].append(
            quota_sample[metric] - bm25_sample[metric]
        )

statistics = {}

for metric in metric_names:
    values = bootstrap_deltas[metric]

    statistics[metric] = {
        "bm25": bm25_observed[metric],
        "quota": quota_observed[metric],
        "delta": observed_deltas[metric],
        "ci95": [
            quantile(values, 0.025),
            quantile(values, 0.975),
        ],
        "bootstrap_probability_delta_gt_0": (
            sum(value > 0 for value in values)
            / len(values)
        ),
        "bootstrap_probability_delta_ge_0": (
            sum(value >= 0 for value in values)
            / len(values)
        ),
    }

per_target_recall20 = {
    "improved": 0,
    "degraded": 0,
    "tied": 0,
}

for pair in pairs:
    delta = (
        pair["quota"]["recovered@20"]
        - pair["bm25"]["recovered@20"]
    )

    if delta > 0:
        per_target_recall20["improved"] += 1
    elif delta < 0:
        per_target_recall20["degraded"] += 1
    else:
        per_target_recall20["tied"] += 1

output = {
    "analysis": (
        "CSLib paired target bootstrap: "
        "validation-selected import quota versus BM25"
    ),
    "selection_policy": (
        "quota hyperparameters selected on validation only"
    ),
    "test_target_count": len(pairs),
    "bootstrap_samples": BOOTSTRAP_SAMPLES,
    "random_seed": RANDOM_SEED,
    "configuration": {
        "protected_prefix": config["protected_prefix"],
        "imported_quota": config["imported_quota"],
        "transfer_weight": config["transfer_weight"],
    },
    "per_target_recall_at_20": per_target_recall20,
    "statistics": statistics,
}

OUTPUT_PATH.write_text(
    json.dumps(output, ensure_ascii=False, indent=2)
    + "\n"
)

print("CSLib paired bootstrap v1")
print("=" * 96)
print("test targets:", len(pairs))
print("configuration:", output["configuration"])
print(
    "R@20 target outcomes:",
    per_target_recall20,
)

print("\nPaired bootstrap results")
print("-" * 96)

for metric in metric_names:
    row = statistics[metric]
    low, high = row["ci95"]

    print(
        f"{metric:22s} "
        f"BM25={row['bm25']:.4f} "
        f"quota={row['quota']:.4f} "
        f"delta={row['delta']:+.4f} "
        f"CI95=[{low:+.4f}, {high:+.4f}] "
        f"P(delta>0)={row['bootstrap_probability_delta_gt_0']:.4f}"
    )

print("\nsaved:", OUTPUT_PATH)
