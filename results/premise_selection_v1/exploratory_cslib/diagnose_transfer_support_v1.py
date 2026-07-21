import importlib.util
import json
import statistics
from pathlib import Path

ROOT = Path("/project/nlp-work11") / Path.home().name
BENCH = (
    ROOT
    / "theorem_generation"
    / "premise_selection_cslib_v0"
)

BASE_SCRIPT = BENCH / "scripts/evaluate_graph_transfer_v1.py"
SAFE_PATH = (
    BENCH
    / "safe_import_replacement_predictions_test_v1.jsonl"
)
OUTPUT_PATH = BENCH / "transfer_support_diagnosis_v1.json"

spec = importlib.util.spec_from_file_location(
    "cslib_graph_transfer",
    BASE_SCRIPT,
)
base = importlib.util.module_from_spec(spec)
spec.loader.exec_module(base)


def namespace_prefix(name):
    parts = name.split(".")
    return ".".join(parts[:-1])


def common_prefix_length(left, right):
    left_parts = left.split(".")
    right_parts = right.split(".")

    count = 0

    for left_part, right_part in zip(
        left_parts,
        right_parts,
    ):
        if left_part != right_part:
            break

        count += 1

    return count


def support_features(record, premise_id):
    target = record["target"]
    premise = base.catalog_by_id[premise_id]

    supporters = []

    for neighbor in record["neighbors"]:
        if premise_id in neighbor["transferred_premise_ids"]:
            supporters.append(neighbor)

    similarities = [
        neighbor["similarity"]
        for neighbor in supporters
    ]

    supporter_ranks = [
        neighbor["rank"]
        for neighbor in supporters
    ]

    target_name_tokens = set(
        base.tokenize(target["declaration_name"])
    )
    premise_name_tokens = set(
        base.tokenize(premise["declaration_name"])
    )

    union = target_name_tokens | premise_name_tokens

    return {
        "support_count": len(supporters),
        "max_support_similarity": (
            max(similarities) if similarities else 0.0
        ),
        "mean_support_similarity": (
            statistics.mean(similarities)
            if similarities else 0.0
        ),
        "nearest_support_rank": (
            min(supporter_ranks)
            if supporter_ranks else 999
        ),
        "name_jaccard": (
            len(target_name_tokens & premise_name_tokens)
            / len(union)
            if union else 0.0
        ),
        "namespace_prefix_length": common_prefix_length(
            namespace_prefix(target["declaration_name"]),
            namespace_prefix(premise["declaration_name"]),
        ),
        "module_prefix_length": common_prefix_length(
            target["module_path"],
            premise["module_path"],
        ),
        "same_namespace": (
            namespace_prefix(target["declaration_name"])
            == namespace_prefix(premise["declaration_name"])
        ),
        "same_top_level_domain": (
            target["declaration_name"].split(".")[0]
            == premise["declaration_name"].split(".")[0]
        ),
        "supporting_targets": [
            {
                "rank": neighbor["rank"],
                "train_target": neighbor["train_target"],
                "similarity": neighbor["similarity"],
            }
            for neighbor in supporters
        ],
    }


records_by_target = {
    record["target"]["declaration_name"]: record
    for record in base.test_features
}

safe_predictions = [
    json.loads(line)
    for line in SAFE_PATH.read_text().splitlines()
    if line.strip()
]

false_promotions = []

for prediction in safe_predictions:
    target_name = prediction["declaration_name"]
    gold = set(prediction["gold_premise_names"])
    record = records_by_target[target_name]

    name_to_id = {
        base.catalog_by_id[pid]["declaration_name"]: pid
        for pid in record["target"]["candidate_premise_ids"]
    }

    for premise_name in prediction["promoted_premise_names"]:
        if premise_name in gold:
            continue

        premise_id = name_to_id[premise_name]

        false_promotions.append({
            "target": target_name,
            "premise": premise_name,
            "transfer_score": (
                record["features"]["transfer"][premise_id]
            ),
            **support_features(record, premise_id),
        })


recoverable_gold = []

for record in base.test_features:
    target = record["target"]
    gold_ids = set(target["gold_premise_ids"])

    bm25_ranking = sorted(
        target["candidate_premise_ids"],
        key=lambda pid: (
            record["features"]["bm25"][pid],
            base.catalog_by_id[pid]["declaration_name"],
        ),
        reverse=True,
    )

    bm25_rank = {
        pid: rank
        for rank, pid in enumerate(bm25_ranking, 1)
    }

    for premise_id in gold_ids:
        transfer_score = (
            record["features"]["transfer"][premise_id]
        )

        if bm25_rank[premise_id] <= 20:
            continue

        if transfer_score <= 0:
            continue

        recoverable_gold.append({
            "target": target["declaration_name"],
            "premise": (
                base.catalog_by_id[premise_id][
                    "declaration_name"
                ]
            ),
            "bm25_rank": bm25_rank[premise_id],
            "transfer_score": transfer_score,
            **support_features(record, premise_id),
        })


def summarize(rows, key):
    values = [row[key] for row in rows]

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


metric_names = [
    "transfer_score",
    "support_count",
    "max_support_similarity",
    "mean_support_similarity",
    "nearest_support_rank",
    "name_jaccard",
    "namespace_prefix_length",
    "module_prefix_length",
]

summary = {
    metric: {
        "false_promotions": summarize(
            false_promotions,
            metric,
        ),
        "recoverable_gold": summarize(
            recoverable_gold,
            metric,
        ),
    }
    for metric in metric_names
}

output = {
    "analysis": (
        "Support-pattern comparison between false imported "
        "promotions and BM25-missed recoverable gold premises"
    ),
    "summary": summary,
    "false_promotions": false_promotions,
    "recoverable_gold": recoverable_gold,
}

OUTPUT_PATH.write_text(
    json.dumps(output, ensure_ascii=False, indent=2)
    + "\n"
)

print("CSLib transfer-support diagnosis")
print("=" * 110)
print("false promotions :", len(false_promotions))
print("recoverable gold :", len(recoverable_gold))

print("\nFeature summaries")
print("-" * 110)

for metric in metric_names:
    print(metric)
    print(
        "  false:",
        summary[metric]["false_promotions"],
    )
    print(
        "  gold :",
        summary[metric]["recoverable_gold"],
    )

print("\nFalse promotions")
print("-" * 110)

for row in false_promotions:
    print(json.dumps(row, ensure_ascii=False))

print("\nRecoverable gold")
print("-" * 110)

for row in sorted(
    recoverable_gold,
    key=lambda row: (
        -row["support_count"],
        -row["max_support_similarity"],
        -row["transfer_score"],
        row["target"],
    ),
):
    print(json.dumps(row, ensure_ascii=False))

print("\nsaved:", OUTPUT_PATH)
