import importlib.util
import json
import math
from collections import Counter
from itertools import product
from pathlib import Path

ROOT = Path("/project/nlp-work11") / Path.home().name
BENCH = (
    ROOT
    / "theorem_generation"
    / "premise_selection_cslib_v0"
)

BASE_SCRIPT = BENCH / "scripts/evaluate_graph_transfer_v1.py"

OUTPUT_PATH = (
    BENCH / "structure_aware_safe_results_v2.json"
)
PREVIEW_PATH = (
    BENCH / "structure_aware_safe_results_v2.txt"
)
PREDICTIONS_PATH = (
    BENCH
    / "structure_aware_safe_predictions_test_v2.jsonl"
)

spec = importlib.util.spec_from_file_location(
    "cslib_graph_transfer",
    BASE_SCRIPT,
)
base = importlib.util.module_from_spec(spec)
spec.loader.exec_module(base)

KS = [1, 5, 10, 20, 50]
RERANK_CUTOFF = 20


def common_prefix_ratio(left, right):
    left_parts = left.split(".")
    right_parts = right.split(".")

    common = 0

    for left_part, right_part in zip(
        left_parts,
        right_parts,
    ):
        if left_part != right_part:
            break

        common += 1

    denominator = max(
        len(left_parts),
        len(right_parts),
        1,
    )

    return common / denominator


def namespace_of(name):
    parts = name.split(".")
    return ".".join(parts[:-1])


def prepare_records(feature_records):
    prepared = []

    for record in feature_records:
        target = record["target"]
        features = record["features"]
        candidate_ids = target["candidate_premise_ids"]

        bm25_ranking = sorted(
            candidate_ids,
            key=lambda pid: (
                features["bm25"][pid],
                base.catalog_by_id[pid][
                    "declaration_name"
                ],
            ),
            reverse=True,
        )

        structure_scores = {}

        for pid in candidate_ids:
            premise = base.catalog_by_id[pid]

            name_score = base.name_jaccard(
                target,
                premise,
            )

            namespace_score = common_prefix_ratio(
                namespace_of(target["declaration_name"]),
                namespace_of(
                    premise["declaration_name"]
                ),
            )

            module_score = common_prefix_ratio(
                target["module_path"],
                premise["module_path"],
            )

            structure_scores[pid] = max(
                name_score,
                namespace_score,
                module_score,
            )

        gold_ids = set(target["gold_premise_ids"])

        local_names = set(
            target["gold_same_file_earlier"]
        )
        imported_names = set(
            target["gold_imported_modules"]
        )

        local_ids = {
            pid
            for pid in gold_ids
            if (
                base.catalog_by_id[pid][
                    "declaration_name"
                ]
                in local_names
            )
        }

        imported_ids = {
            pid
            for pid in gold_ids
            if (
                base.catalog_by_id[pid][
                    "declaration_name"
                ]
                in imported_names
            )
        }

        prepared.append({
            "target": target,
            "features": features,
            "bm25_ranking": bm25_ranking,
            "structure_scores": structure_scores,
            "gold_ids": gold_ids,
            "local_gold_ids": local_ids,
            "imported_gold_ids": imported_ids,
        })

    return prepared


def build_ranking(
    record,
    transfer_weight,
    structure_weight,
    protected_prefix,
    max_promotions,
    min_transfer_score,
    min_structure_score,
    replacement_margin,
    victim_max_bm25,
):
    target = record["target"]
    features = record["features"]
    bm25_ranking = record["bm25_ranking"]
    structure_scores = record["structure_scores"]

    original_top20 = bm25_ranking[:RERANK_CUTOFF]
    original_top20_set = set(original_top20)

    protected = original_top20[:protected_prefix]
    replaceable = list(
        original_top20[protected_prefix:]
    )

    candidate_scores = {}

    for pid in target["candidate_premise_ids"]:
        candidate_scores[pid] = (
            (1.0 - transfer_weight)
            * features["bm25"][pid]
            + transfer_weight
            * features["transfer"][pid]
            + structure_weight
            * structure_scores[pid]
        )

    imported_ranking = sorted(
        (
            pid
            for pid in target["candidate_premise_ids"]
            if (
                pid not in original_top20_set
                and base.catalog_by_id[pid]["file_path"]
                != target["file_path"]
            )
        ),
        key=lambda pid: (
            candidate_scores[pid],
            structure_scores[pid],
            features["transfer"][pid],
            features["bm25"][pid],
            base.catalog_by_id[pid][
                "declaration_name"
            ],
        ),
        reverse=True,
    )

    promoted = []
    removed = []

    for candidate_pid in imported_ranking:
        if len(promoted) >= max_promotions:
            break

        if not replaceable:
            break

        transfer_score = (
            features["transfer"][candidate_pid]
        )
        structure_score = (
            structure_scores[candidate_pid]
        )

        if transfer_score < min_transfer_score:
            continue

        if structure_score < min_structure_score:
            continue

        victim_pid = replaceable[-1]
        victim_bm25 = features["bm25"][victim_pid]

        if victim_bm25 > victim_max_bm25:
            break

        if (
            candidate_scores[candidate_pid]
            < victim_bm25 + replacement_margin
        ):
            continue

        promoted.append(candidate_pid)
        removed.append(victim_pid)
        replaceable.pop()

    removed_set = set(removed)

    survivors = [
        pid
        for pid in original_top20[protected_prefix:]
        if pid not in removed_set
    ]

    top_window = protected + promoted + survivors
    used = set(top_window)

    remaining = [
        pid
        for pid in bm25_ranking
        if pid not in used
    ]

    return top_window + remaining, promoted, removed


def evaluate(
    records,
    configuration=None,
    pure_bm25=False,
    save_predictions=False,
):
    recovered = Counter()
    hit_targets = Counter()
    ndcg_sum = Counter()

    reciprocal_rank_sum = 0.0
    total_gold = 0

    local_total = 0
    imported_total = 0
    local_recovered = Counter()
    imported_recovered = Counter()

    promoted_target_count = 0
    promotion_count = 0
    predictions = []

    for record in records:
        if pure_bm25:
            ranking = record["bm25_ranking"]
            promoted = []
            removed = []
        else:
            ranking, promoted, removed = build_ranking(
                record,
                **configuration,
            )

        if promoted:
            promoted_target_count += 1
            promotion_count += len(promoted)

        gold_ids = record["gold_ids"]
        local_ids = record["local_gold_ids"]
        imported_ids = record["imported_gold_ids"]

        gold_ranks = [
            rank
            for rank, pid in enumerate(ranking, 1)
            if pid in gold_ids
        ]

        reciprocal_rank_sum += (
            1.0 / min(gold_ranks)
        )

        total_gold += len(gold_ids)
        local_total += len(local_ids)
        imported_total += len(imported_ids)

        for k in KS:
            topk = set(ranking[:k])

            recovered[k] += len(gold_ids & topk)
            local_recovered[k] += len(
                local_ids & topk
            )
            imported_recovered[k] += len(
                imported_ids & topk
            )

            if gold_ids & topk:
                hit_targets[k] += 1

            dcg = sum(
                1.0 / math.log2(rank + 1.0)
                for rank in gold_ranks
                if rank <= k
            )

            ideal_count = min(len(gold_ids), k)
            idcg = sum(
                1.0 / math.log2(rank + 1.0)
                for rank in range(1, ideal_count + 1)
            )

            ndcg_sum[k] += (
                dcg / idcg if idcg else 0.0
            )

        if save_predictions:
            target = record["target"]

            predictions.append({
                "declaration_name": (
                    target["declaration_name"]
                ),
                "module_path": target["module_path"],
                "gold_premise_names": (
                    target["gold_premise_names"]
                ),
                "first_gold_rank": min(gold_ranks),
                "promoted_premise_names": [
                    base.catalog_by_id[pid][
                        "declaration_name"
                    ]
                    for pid in promoted
                ],
                "removed_premise_names": [
                    base.catalog_by_id[pid][
                        "declaration_name"
                    ]
                    for pid in removed
                ],
                "top_50_premise_names": [
                    base.catalog_by_id[pid][
                        "declaration_name"
                    ]
                    for pid in ranking[:50]
                ],
            })

    target_count = len(records)

    result = {
        "target_count": target_count,
        "MRR": reciprocal_rank_sum / target_count,
        "promoted_target_count": (
            promoted_target_count
        ),
        "promotion_count": promotion_count,
    }

    if configuration:
        result.update(configuration)

    for k in KS:
        result[f"micro_recall@{k}"] = (
            recovered[k] / total_gold
        )
        result[f"hit_rate@{k}"] = (
            hit_targets[k] / target_count
        )
        result[f"nDCG@{k}"] = (
            ndcg_sum[k] / target_count
        )
        result[f"local_recall@{k}"] = (
            local_recovered[k] / local_total
            if local_total else None
        )
        result[f"imported_recall@{k}"] = (
            imported_recovered[k] / imported_total
            if imported_total else None
        )

    return result, predictions


print("Preparing validation records...")
validation_records = prepare_records(
    base.validation_features
)

print("Preparing test records...")
test_records = prepare_records(
    base.test_features
)

validation_bm25, _ = evaluate(
    validation_records,
    pure_bm25=True,
)

test_bm25, bm25_predictions = evaluate(
    test_records,
    pure_bm25=True,
    save_predictions=True,
)

grid = []

for values in product(
    [0.40, 0.50, 0.60],
    [0.00, 0.25, 0.50, 0.75],
    [5, 10, 15],
    [1, 2, 3],
    [0.05, 0.10, 0.20, 0.40],
    [0.00, 0.20, 0.40, 0.60],
    [0.00, 0.05, 0.10],
    [0.30, 0.50, 0.70],
):
    configuration = {
        "transfer_weight": values[0],
        "structure_weight": values[1],
        "protected_prefix": values[2],
        "max_promotions": values[3],
        "min_transfer_score": values[4],
        "min_structure_score": values[5],
        "replacement_margin": values[6],
        "victim_max_bm25": values[7],
    }

    result, _ = evaluate(
        validation_records,
        configuration=configuration,
    )

    grid.append(result)

mrr_floor = validation_bm25["MRR"] - 0.005
local_floor = (
    validation_bm25["local_recall@20"] - 0.005
)

feasible = [
    result
    for result in grid
    if (
        result["MRR"] >= mrr_floor
        and result["local_recall@20"] >= local_floor
    )
]

best = max(
    feasible if feasible else grid,
    key=lambda result: (
        result["micro_recall@20"],
        result["imported_recall@20"],
        result["micro_recall@10"],
        result["MRR"],
        -result["promotion_count"],
    ),
)

configuration_keys = [
    "transfer_weight",
    "structure_weight",
    "protected_prefix",
    "max_promotions",
    "min_transfer_score",
    "min_structure_score",
    "replacement_margin",
    "victim_max_bm25",
]

best_configuration = {
    key: best[key]
    for key in configuration_keys
}

test_result, test_predictions = evaluate(
    test_records,
    configuration=best_configuration,
    save_predictions=True,
)


def recovered_at_20(prediction):
    gold = set(prediction["gold_premise_names"])
    top20 = set(
        prediction["top_50_premise_names"][:20]
    )
    return len(gold & top20)


bm25_by_name = {
    row["declaration_name"]: row
    for row in bm25_predictions
}
test_by_name = {
    row["declaration_name"]: row
    for row in test_predictions
}

wins = ties = losses = 0

for name in bm25_by_name:
    baseline = recovered_at_20(
        bm25_by_name[name]
    )
    method = recovered_at_20(
        test_by_name[name]
    )

    if method > baseline:
        wins += 1
    elif method < baseline:
        losses += 1
    else:
        ties += 1

results = {
    "method": (
        "Structure-aware candidate-level safe "
        "import replacement v2"
    ),
    "status": (
        "exploratory; feature design informed by "
        "prior CSLib test diagnostics"
    ),
    "validation_grid_size": len(grid),
    "feasible_configuration_count": len(feasible),
    "validation_bm25": validation_bm25,
    "test_bm25": test_bm25,
    "best_validation": best,
    "best_test": test_result,
    "test_per_target_recall_at_20": {
        "wins": wins,
        "ties": ties,
        "losses": losses,
    },
}

OUTPUT_PATH.write_text(
    json.dumps(results, ensure_ascii=False, indent=2)
    + "\n"
)

with PREDICTIONS_PATH.open("w") as file:
    for row in test_predictions:
        file.write(
            json.dumps(row, ensure_ascii=False) + "\n"
        )

with PREVIEW_PATH.open("w") as file:
    file.write(
        "Structure-aware safe import replacement v2\n"
    )
    file.write("=" * 104 + "\n\n")
    file.write(
        "EXPLORATORY: feature design followed "
        "inspection of CSLib test failures.\n\n"
    )

    file.write("Selected configuration\n")
    file.write("-" * 104 + "\n")
    file.write(
        json.dumps(
            best_configuration,
            ensure_ascii=False,
        )
        + "\n\n"
    )

    file.write("Validation\n")
    file.write("-" * 104 + "\n")
    file.write(
        f"BM25: MRR={validation_bm25['MRR']:.4f} "
        f"R@10={validation_bm25['micro_recall@10']:.4f} "
        f"R@20={validation_bm25['micro_recall@20']:.4f} "
        f"local@20={validation_bm25['local_recall@20']:.4f} "
        f"imported@20={validation_bm25['imported_recall@20']:.4f}\n"
    )
    file.write(
        f"V2:   MRR={best['MRR']:.4f} "
        f"R@10={best['micro_recall@10']:.4f} "
        f"R@20={best['micro_recall@20']:.4f} "
        f"local@20={best['local_recall@20']:.4f} "
        f"imported@20={best['imported_recall@20']:.4f} "
        f"promotions={best['promotion_count']}\n\n"
    )

    file.write("Test\n")
    file.write("-" * 104 + "\n")
    file.write(
        f"BM25: MRR={test_bm25['MRR']:.4f} "
        f"R@5={test_bm25['micro_recall@5']:.4f} "
        f"R@10={test_bm25['micro_recall@10']:.4f} "
        f"R@20={test_bm25['micro_recall@20']:.4f} "
        f"R@50={test_bm25['micro_recall@50']:.4f} "
        f"local@20={test_bm25['local_recall@20']:.4f} "
        f"imported@20={test_bm25['imported_recall@20']:.4f}\n"
    )
    file.write(
        f"V2:   MRR={test_result['MRR']:.4f} "
        f"R@5={test_result['micro_recall@5']:.4f} "
        f"R@10={test_result['micro_recall@10']:.4f} "
        f"R@20={test_result['micro_recall@20']:.4f} "
        f"R@50={test_result['micro_recall@50']:.4f} "
        f"local@20={test_result['local_recall@20']:.4f} "
        f"imported@20={test_result['imported_recall@20']:.4f} "
        f"promoted_targets="
        f"{test_result['promoted_target_count']}/"
        f"{test_result['target_count']} "
        f"promotions={test_result['promotion_count']}\n"
    )

    file.write(
        f"\nPer-target R@20: "
        f"wins={wins} ties={ties} losses={losses}\n"
    )

print(PREVIEW_PATH.read_text())
print("saved:", OUTPUT_PATH)
print("saved:", PREDICTIONS_PATH)
print("saved:", PREVIEW_PATH)
