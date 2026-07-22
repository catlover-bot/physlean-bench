import importlib.util
import json
import math
from collections import Counter
from itertools import product
from pathlib import Path

root = Path("/project/nlp-work11") / Path.home().name
bench_dir = root / "theorem_generation/premise_selection_physlib_v0"

base_script = bench_dir / "scripts/evaluate_graph_transfer_v1.py"

output_path = bench_dir / "safe_import_replacement_results_v1.json"
preview_path = bench_dir / "safe_import_replacement_results_v1.txt"
predictions_path = (
    bench_dir / "safe_import_replacement_predictions_test_v1.jsonl"
)

spec = importlib.util.spec_from_file_location(
    "graph_transfer_base",
    base_script,
)
base = importlib.util.module_from_spec(spec)
spec.loader.exec_module(base)

KS = [1, 5, 10, 20, 50]
RERANK_CUTOFF = 20


def prepare_records(feature_records, transfer_weights):
    prepared = []

    for record in feature_records:
        target = record["target"]
        features = record["features"]

        candidate_ids = target["candidate_premise_ids"]
        target_file = target["file_path"]
        bm25_scores = features["bm25"]

        bm25_ranking = sorted(
            candidate_ids,
            key=lambda pid: (
                bm25_scores[pid],
                base.catalog_by_id[pid]["declaration_name"],
            ),
            reverse=True,
        )

        original_top20 = set(bm25_ranking[:RERANK_CUTOFF])

        hybrid_scores_by_weight = {}
        imported_rankings_by_weight = {}

        for transfer_weight in transfer_weights:
            hybrid_scores = {
                pid: (
                    (1.0 - transfer_weight)
                    * features["bm25"][pid]
                    + transfer_weight
                    * features["transfer"][pid]
                )
                for pid in candidate_ids
            }

            imported_ranking = sorted(
                (
                    pid
                    for pid in candidate_ids
                    if pid not in original_top20
                    and base.catalog_by_id[pid]["file_path"]
                    != target_file
                ),
                key=lambda pid: (
                    hybrid_scores[pid],
                    features["transfer"][pid],
                    features["bm25"][pid],
                    base.catalog_by_id[pid]["declaration_name"],
                ),
                reverse=True,
            )

            hybrid_scores_by_weight[transfer_weight] = hybrid_scores
            imported_rankings_by_weight[transfer_weight] = (
                imported_ranking
            )

        gold_ids = set(target["gold_premise_ids"])

        local_gold_names = set(
            target["gold_same_file_earlier"]
        )
        imported_gold_names = set(
            target["gold_imported_modules"]
        )

        local_gold_ids = {
            pid
            for pid in gold_ids
            if base.catalog_by_id[pid]["declaration_name"]
            in local_gold_names
        }

        imported_gold_ids = {
            pid
            for pid in gold_ids
            if base.catalog_by_id[pid]["declaration_name"]
            in imported_gold_names
        }

        prepared.append({
            "target": target,
            "features": features,
            "gold_ids": gold_ids,
            "local_gold_ids": local_gold_ids,
            "imported_gold_ids": imported_gold_ids,
            "bm25_ranking": bm25_ranking,
            "hybrid_scores_by_weight": hybrid_scores_by_weight,
            "imported_rankings_by_weight": imported_rankings_by_weight,
        })

    return prepared


def build_safe_ranking(
    record,
    transfer_weight,
    protected_prefix,
    max_promotions,
    min_transfer_score,
    replacement_margin,
    victim_max_bm25,
):
    features = record["features"]
    bm25_ranking = record["bm25_ranking"]
    hybrid_scores = (
        record["hybrid_scores_by_weight"][transfer_weight]
    )
    imported_ranking = (
        record["imported_rankings_by_weight"][transfer_weight]
    )

    original_top20 = bm25_ranking[:RERANK_CUTOFF]
    protected = original_top20[:protected_prefix]
    replaceable = list(original_top20[protected_prefix:])

    promoted = []
    removed = []

    for candidate_pid in imported_ranking:
        if len(promoted) >= max_promotions:
            break

        if not replaceable:
            break

        # 現在のBM25 Top-20内で最下位の未保護候補。
        victim_pid = replaceable[-1]

        victim_bm25 = features["bm25"][victim_pid]
        candidate_transfer = features["transfer"][candidate_pid]
        candidate_hybrid = hybrid_scores[candidate_pid]

        # BM25スコアが高い候補は追い出さない。
        if victim_bm25 > victim_max_bm25:
            break

        # 転送根拠が弱いimported候補は採用しない。
        if candidate_transfer < min_transfer_score:
            continue

        # imported候補が、追い出すBM25候補を十分上回る場合だけ置換。
        if candidate_hybrid < victim_bm25 + replacement_margin:
            # imported_rankingはhybrid降順なので、
            # これ以降の候補もmargin条件を満たしにくい。
            break

        promoted.append(candidate_pid)
        removed.append(victim_pid)
        replaceable.pop()

    removed_set = set(removed)

    survivors = [
        pid
        for pid in original_top20[protected_prefix:]
        if pid not in removed_set
    ]

    # 上位BM25 prefixを維持し、確信度の高いimported候補だけを挿入。
    top_window = protected + promoted + survivors
    top_window_set = set(top_window)

    # Top-20以降は元のBM25順を維持する。
    remaining = [
        pid
        for pid in bm25_ranking
        if pid not in top_window_set
    ]

    ranking = top_window + remaining

    return ranking, promoted, removed


def evaluate(
    prepared_records,
    configuration=None,
    pure_bm25=False,
    save_predictions=False,
):
    recovered = Counter()
    hit_targets = Counter()
    ndcg_sum = Counter()

    reciprocal_rank_sum = 0.0
    total_gold = 0

    local_gold_total = 0
    imported_gold_total = 0
    local_recovered = Counter()
    imported_recovered = Counter()

    promoted_target_count = 0
    promotion_count = 0
    predictions = []

    for record in prepared_records:
        if pure_bm25:
            ranking = record["bm25_ranking"]
            promoted = []
            removed = []
        else:
            ranking, promoted, removed = build_safe_ranking(
                record,
                **configuration,
            )

        if promoted:
            promoted_target_count += 1
            promotion_count += len(promoted)

        gold_ids = record["gold_ids"]
        local_gold_ids = record["local_gold_ids"]
        imported_gold_ids = record["imported_gold_ids"]

        gold_ranks = [
            rank
            for rank, pid in enumerate(ranking, 1)
            if pid in gold_ids
        ]

        first_gold_rank = min(gold_ranks) if gold_ranks else 999

        if gold_ranks:
            reciprocal_rank_sum += 1.0 / first_gold_rank

        total_gold += len(gold_ids)
        local_gold_total += len(local_gold_ids)
        imported_gold_total += len(imported_gold_ids)

        for k in KS:
            topk = set(ranking[:k])
            count = len(gold_ids & topk)

            recovered[k] += count
            local_recovered[k] += len(
                local_gold_ids & topk
            )
            imported_recovered[k] += len(
                imported_gold_ids & topk
            )

            if count > 0:
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

            ndcg_sum[k] += dcg / idcg if idcg else 0.0

        if save_predictions:
            target = record["target"]

            predictions.append({
                "declaration_name": target["declaration_name"],
                "module_path": target["module_path"],
                "gold_premise_names": target["gold_premise_names"],
                "first_gold_rank": first_gold_rank,
                "promoted_premise_names": [
                    base.catalog_by_id[pid]["declaration_name"]
                    for pid in promoted
                ],
                "removed_premise_names": [
                    base.catalog_by_id[pid]["declaration_name"]
                    for pid in removed
                ],
                "top_50_premise_names": [
                    base.catalog_by_id[pid]["declaration_name"]
                    for pid in ranking[:50]
                ],
            })

    target_count = len(prepared_records)

    result = {
        "target_count": target_count,
        "MRR": reciprocal_rank_sum / target_count,
        "promoted_target_count": promoted_target_count,
        "promoted_target_fraction": (
            promoted_target_count / target_count
        ),
        "promotion_count": promotion_count,
    }

    if configuration is not None:
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
            local_recovered[k] / local_gold_total
            if local_gold_total else None
        )
        result[f"imported_recall@{k}"] = (
            imported_recovered[k] / imported_gold_total
            if imported_gold_total else None
        )

    return result, predictions


transfer_weights = [0.40, 0.50, 0.60]

print("Preparing validation records...")
validation_records = prepare_records(
    base.validation_features,
    transfer_weights,
)

print("Preparing test records...")
test_records = prepare_records(
    base.test_features,
    transfer_weights,
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

protected_prefixes = [5, 10, 15]
max_promotions_values = [1, 2, 3, 4]
min_transfer_scores = [0.00, 0.10, 0.20, 0.40]
replacement_margins = [0.00, 0.05, 0.10]
victim_max_bm25_values = [0.30, 0.40, 0.50, 0.60, 0.70]

validation_grid = []

for (
    transfer_weight,
    protected_prefix,
    max_promotions,
    min_transfer_score,
    replacement_margin,
    victim_max_bm25,
) in product(
    transfer_weights,
    protected_prefixes,
    max_promotions_values,
    min_transfer_scores,
    replacement_margins,
    victim_max_bm25_values,
):
    configuration = {
        "transfer_weight": transfer_weight,
        "protected_prefix": protected_prefix,
        "max_promotions": max_promotions,
        "min_transfer_score": min_transfer_score,
        "replacement_margin": replacement_margin,
        "victim_max_bm25": victim_max_bm25,
    }

    result, _ = evaluate(
        validation_records,
        configuration=configuration,
    )

    validation_grid.append(result)

# BM25に対してMRRとlocal Recall@20を0.005以上落とさない。
mrr_floor = validation_bm25["MRR"] - 0.005
local_floor = validation_bm25["local_recall@20"] - 0.005

feasible = [
    result
    for result in validation_grid
    if result["MRR"] >= mrr_floor
    and result["local_recall@20"] >= local_floor
]

if feasible:
    best_safe = max(
        feasible,
        key=lambda result: (
            result["micro_recall@20"],
            result["imported_recall@20"],
            result["micro_recall@10"],
            result["MRR"],
            -result["promotion_count"],
        ),
    )
else:
    best_safe = max(
        validation_grid,
        key=lambda result: (
            result["local_recall@20"],
            result["micro_recall@20"],
            result["MRR"],
        ),
    )

best_configuration = {
    key: best_safe[key]
    for key in [
        "transfer_weight",
        "protected_prefix",
        "max_promotions",
        "min_transfer_score",
        "replacement_margin",
        "victim_max_bm25",
    ]
}

safe_test, safe_predictions = evaluate(
    test_records,
    configuration=best_configuration,
    save_predictions=True,
)


def recall_at_20(prediction):
    gold = set(prediction["gold_premise_names"])
    top20 = set(prediction["top_50_premise_names"][:20])

    return len(gold & top20) / len(gold) if gold else 0.0


bm25_by_name = {
    row["declaration_name"]: row
    for row in bm25_predictions
}

safe_by_name = {
    row["declaration_name"]: row
    for row in safe_predictions
}

wins = ties = losses = 0

for name in sorted(set(bm25_by_name) & set(safe_by_name)):
    baseline = recall_at_20(bm25_by_name[name])
    method = recall_at_20(safe_by_name[name])

    if method > baseline:
        wins += 1
    elif method < baseline:
        losses += 1
    else:
        ties += 1

fixed_results_path = bench_dir / "import_quota_results_v1.json"

fixed_test = None

if fixed_results_path.exists():
    fixed_results = json.loads(
        fixed_results_path.read_text()
    )
    fixed_test = fixed_results.get("best_balanced_test")

results = {
    "method": (
        "Candidate-level safe imported-premise replacement"
    ),
    "selection_policy": (
        "all hyperparameters selected on validation only"
    ),
    "rerank_cutoff": RERANK_CUTOFF,
    "validation_grid_size": len(validation_grid),
    "feasible_configuration_count": len(feasible),
    "constraints": {
        "mrr_floor": mrr_floor,
        "local_recall_at_20_floor": local_floor,
    },
    "validation_bm25": validation_bm25,
    "test_bm25": test_bm25,
    "best_safe_validation": best_safe,
    "best_safe_test": safe_test,
    "fixed_balanced_test": fixed_test,
    "test_per_target_recall_at_20": {
        "wins": wins,
        "ties": ties,
        "losses": losses,
    },
}

output_path.write_text(
    json.dumps(results, ensure_ascii=False, indent=2) + "\n"
)

with predictions_path.open("w") as file:
    for prediction in safe_predictions:
        file.write(
            json.dumps(prediction, ensure_ascii=False) + "\n"
        )

with preview_path.open("w") as file:
    file.write("Candidate-level safe import replacement v1\n")
    file.write("=" * 96 + "\n\n")

    file.write("Selected validation configuration\n")
    file.write("-" * 96 + "\n")
    file.write(
        f"transfer_weight="
        f"{best_safe['transfer_weight']} "
        f"protected_prefix="
        f"{best_safe['protected_prefix']} "
        f"max_promotions="
        f"{best_safe['max_promotions']} "
        f"min_transfer_score="
        f"{best_safe['min_transfer_score']} "
        f"replacement_margin="
        f"{best_safe['replacement_margin']} "
        f"victim_max_bm25="
        f"{best_safe['victim_max_bm25']}\n"
    )
    file.write(
        f"validation: "
        f"MRR={best_safe['MRR']:.4f} "
        f"R@10={best_safe['micro_recall@10']:.4f} "
        f"R@20={best_safe['micro_recall@20']:.4f} "
        f"R@50={best_safe['micro_recall@50']:.4f} "
        f"local@20={best_safe['local_recall@20']:.4f} "
        f"imported@20="
        f"{best_safe['imported_recall@20']:.4f} "
        f"promotions={best_safe['promotion_count']}\n\n"
    )

    file.write("Test comparison\n")
    file.write("-" * 96 + "\n")
    file.write(
        f"BM25: "
        f"MRR={test_bm25['MRR']:.4f} "
        f"R@5={test_bm25['micro_recall@5']:.4f} "
        f"R@10={test_bm25['micro_recall@10']:.4f} "
        f"R@20={test_bm25['micro_recall@20']:.4f} "
        f"R@50={test_bm25['micro_recall@50']:.4f} "
        f"local@20={test_bm25['local_recall@20']:.4f} "
        f"imported@20={test_bm25['imported_recall@20']:.4f}\n"
    )
    file.write(
        f"Safe: "
        f"MRR={safe_test['MRR']:.4f} "
        f"R@5={safe_test['micro_recall@5']:.4f} "
        f"R@10={safe_test['micro_recall@10']:.4f} "
        f"R@20={safe_test['micro_recall@20']:.4f} "
        f"R@50={safe_test['micro_recall@50']:.4f} "
        f"local@20={safe_test['local_recall@20']:.4f} "
        f"imported@20={safe_test['imported_recall@20']:.4f} "
        f"promoted_targets="
        f"{safe_test['promoted_target_count']}/"
        f"{safe_test['target_count']} "
        f"promotions={safe_test['promotion_count']}\n"
    )

    if fixed_test is not None:
        file.write(
            f"Fixed: "
            f"MRR={fixed_test['MRR']:.4f} "
            f"R@5={fixed_test['micro_recall@5']:.4f} "
            f"R@10={fixed_test['micro_recall@10']:.4f} "
            f"R@20={fixed_test['micro_recall@20']:.4f} "
            f"R@50={fixed_test['micro_recall@50']:.4f} "
            f"local@20={fixed_test['local_recall@20']:.4f} "
            f"imported@20="
            f"{fixed_test['imported_recall@20']:.4f}\n"
        )

    file.write("\nPer-target Recall@20: Safe vs BM25\n")
    file.write("-" * 96 + "\n")
    file.write(
        f"wins={wins} ties={ties} losses={losses}\n"
    )

print(preview_path.read_text())
print("saved:", output_path)
print("saved:", predictions_path)
print("saved:", preview_path)
