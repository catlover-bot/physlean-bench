import importlib.util
import json
import math
from collections import Counter
from itertools import product
from pathlib import Path

root = Path("/project/nlp-work11") / Path.home().name
bench_dir = root / "theorem_generation/premise_selection_physlib_v0"

base_script = bench_dir / "scripts/evaluate_graph_transfer_v1.py"
output_path = bench_dir / "import_quota_results_v1.json"
preview_path = bench_dir / "import_quota_results_v1.txt"
predictions_path = bench_dir / "import_quota_predictions_test_v1.jsonl"

spec = importlib.util.spec_from_file_location(
    "graph_transfer_base",
    base_script,
)
base = importlib.util.module_from_spec(spec)
spec.loader.exec_module(base)

KS = [1, 5, 10, 20, 50]
RERANK_CUTOFF = 20

def evaluate_import_quota(
    feature_records,
    protected_prefix,
    imported_quota,
    transfer_weight,
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

    predictions = []

    for record in feature_records:
        target = record["target"]
        features = record["features"]

        candidate_ids = target["candidate_premise_ids"]
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

        bm25_scores = features["bm25"]

        hybrid_scores = {
            pid: (
                (1.0 - transfer_weight)
                * features["bm25"][pid]
                + transfer_weight
                * features["transfer"][pid]
            )
            for pid in candidate_ids
        }

        bm25_ranking = sorted(
            candidate_ids,
            key=lambda pid: (
                bm25_scores[pid],
                base.catalog_by_id[pid]["declaration_name"],
            ),
            reverse=True,
        )

        protected = bm25_ranking[:protected_prefix]
        used = set(protected)

        imported_tail = [
            pid
            for pid in candidate_ids
            if pid not in used
            and base.catalog_by_id[pid]["file_path"]
            != target["file_path"]
        ]

        imported_tail.sort(
            key=lambda pid: (
                hybrid_scores[pid],
                bm25_scores[pid],
                base.catalog_by_id[pid]["declaration_name"],
            ),
            reverse=True,
        )

        selected_imported = imported_tail[:imported_quota]

        top_window = list(protected)
        top_window.extend(selected_imported)
        used.update(selected_imported)

        # 残りのTop-20枠は元のBM25順位で埋める。
        for pid in bm25_ranking:
            if len(top_window) >= RERANK_CUTOFF:
                break

            if pid in used:
                continue

            top_window.append(pid)
            used.add(pid)

        # Top-20以降はBM25＋依存転送で順位付けする。
        remaining = [
            pid
            for pid in candidate_ids
            if pid not in used
        ]

        remaining.sort(
            key=lambda pid: (
                hybrid_scores[pid],
                bm25_scores[pid],
                base.catalog_by_id[pid]["declaration_name"],
            ),
            reverse=True,
        )

        ranking = top_window + remaining

        gold_ranks = [
            rank
            for rank, pid in enumerate(ranking, 1)
            if pid in gold_ids
        ]

        reciprocal_rank_sum += 1.0 / min(gold_ranks)
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

            ndcg_sum[k] += (
                dcg / idcg if idcg else 0.0
            )

        if save_predictions:
            predictions.append({
                "declaration_name": target["declaration_name"],
                "module_path": target["module_path"],
                "gold_premise_names": (
                    target["gold_premise_names"]
                ),
                "protected_prefix": protected_prefix,
                "imported_quota": imported_quota,
                "transfer_weight": transfer_weight,
                "top_50_premise_names": [
                    base.catalog_by_id[pid]["declaration_name"]
                    for pid in ranking[:50]
                ],
                "first_gold_rank": min(gold_ranks),
            })

    target_count = len(feature_records)

    result = {
        "protected_prefix": protected_prefix,
        "imported_quota": imported_quota,
        "transfer_weight": transfer_weight,
        "MRR": reciprocal_rank_sum / target_count,
    }

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

bm25_weights = {
    "bm25": 1.0,
    "graph": 0.0,
    "name": 0.0,
    "transfer": 0.0,
}

validation_bm25, _ = base.evaluate(
    base.validation_features,
    bm25_weights,
)

test_bm25, _ = base.evaluate(
    base.test_features,
    bm25_weights,
)

protected_prefixes = [5, 10]
imported_quotas = [0, 1, 2, 3, 4, 5, 6]
transfer_weights = [0.20, 0.30, 0.40, 0.50, 0.60]

validation_grid = []

for protected_prefix, imported_quota, transfer_weight in product(
    protected_prefixes,
    imported_quotas,
    transfer_weights,
):
    # Top-20枠を超えない。
    if protected_prefix + imported_quota > RERANK_CUTOFF:
        continue

    result, _ = evaluate_import_quota(
        base.validation_features,
        protected_prefix,
        imported_quota,
        transfer_weight,
    )

    validation_grid.append(result)

# BM25に対して、MRRと同一ファイルRecall@20を
# それぞれ0.005以上低下させない。
mrr_floor = validation_bm25["MRR"] - 0.005
local_floor = (
    validation_bm25["local_recall@20"] - 0.005
)

feasible = [
    result
    for result in validation_grid
    if result["MRR"] >= mrr_floor
    and result["local_recall@20"] >= local_floor
]

if feasible:
    best_balanced = max(
        feasible,
        key=lambda result: (
            result["micro_recall@20"],
            result["imported_recall@20"],
            result["micro_recall@50"],
            result["MRR"],
        ),
    )
else:
    # 制約を満たす設定がない場合は、局所Recall低下を最小化する。
    best_balanced = max(
        validation_grid,
        key=lambda result: (
            result["local_recall@20"],
            result["micro_recall@20"],
            result["MRR"],
        ),
    )

best_recall = max(
    validation_grid,
    key=lambda result: (
        result["micro_recall@20"],
        result["imported_recall@20"],
        result["micro_recall@50"],
        result["MRR"],
    ),
)

balanced_test, balanced_predictions = evaluate_import_quota(
    base.test_features,
    best_balanced["protected_prefix"],
    best_balanced["imported_quota"],
    best_balanced["transfer_weight"],
    save_predictions=True,
)

recall_test, _ = evaluate_import_quota(
    base.test_features,
    best_recall["protected_prefix"],
    best_recall["imported_quota"],
    best_recall["transfer_weight"],
)

results = {
    "method": "BM25 local channel plus imported-premise quota",
    "rerank_cutoff": RERANK_CUTOFF,
    "selection_policy": (
        "all hyperparameters selected only on validation"
    ),
    "validation_bm25": validation_bm25,
    "test_bm25": test_bm25,
    "constraints": {
        "mrr_floor": mrr_floor,
        "local_recall_at_20_floor": local_floor,
    },
    "feasible_configuration_count": len(feasible),
    "validation_grid": validation_grid,
    "best_balanced_validation": best_balanced,
    "best_balanced_test": balanced_test,
    "best_recall_validation": best_recall,
    "best_recall_test": recall_test,
}

output_path.write_text(
    json.dumps(results, ensure_ascii=False, indent=2) + "\n"
)

with predictions_path.open("w") as file:
    for prediction in balanced_predictions:
        file.write(
            json.dumps(prediction, ensure_ascii=False) + "\n"
        )

with preview_path.open("w") as file:
    file.write(
        "Import-aware dual-channel premise ranking v1\n"
    )
    file.write("=" * 86 + "\n\n")

    file.write("Validation BM25\n")
    file.write(
        f"MRR={validation_bm25['MRR']:.4f} "
        f"R@20={validation_bm25['micro_recall@20']:.4f} "
        f"local@20={validation_bm25['local_recall@20']:.4f} "
        f"imported@20={validation_bm25['imported_recall@20']:.4f}\n\n"
    )

    file.write(
        f"feasible configurations: {len(feasible)}\n\n"
    )

    file.write("Balanced configuration\n")
    file.write("-" * 86 + "\n")
    file.write(
        f"protected_prefix="
        f"{best_balanced['protected_prefix']} "
        f"imported_quota="
        f"{best_balanced['imported_quota']} "
        f"transfer_weight="
        f"{best_balanced['transfer_weight']}\n"
    )

    file.write(
        f"validation: "
        f"MRR={best_balanced['MRR']:.4f} "
        f"R@20={best_balanced['micro_recall@20']:.4f} "
        f"R@50={best_balanced['micro_recall@50']:.4f} "
        f"local@20={best_balanced['local_recall@20']:.4f} "
        f"imported@20={best_balanced['imported_recall@20']:.4f}\n"
    )

    file.write(
        f"test:       "
        f"MRR={balanced_test['MRR']:.4f} "
        f"R@5={balanced_test['micro_recall@5']:.4f} "
        f"R@10={balanced_test['micro_recall@10']:.4f} "
        f"R@20={balanced_test['micro_recall@20']:.4f} "
        f"R@50={balanced_test['micro_recall@50']:.4f} "
        f"local@20={balanced_test['local_recall@20']:.4f} "
        f"imported@20={balanced_test['imported_recall@20']:.4f}\n\n"
    )

    file.write("Recall-oriented configuration\n")
    file.write("-" * 86 + "\n")
    file.write(
        f"protected_prefix="
        f"{best_recall['protected_prefix']} "
        f"imported_quota="
        f"{best_recall['imported_quota']} "
        f"transfer_weight="
        f"{best_recall['transfer_weight']}\n"
    )

    file.write(
        f"validation: "
        f"MRR={best_recall['MRR']:.4f} "
        f"R@20={best_recall['micro_recall@20']:.4f} "
        f"R@50={best_recall['micro_recall@50']:.4f} "
        f"local@20={best_recall['local_recall@20']:.4f} "
        f"imported@20={best_recall['imported_recall@20']:.4f}\n"
    )

    file.write(
        f"test:       "
        f"MRR={recall_test['MRR']:.4f} "
        f"R@5={recall_test['micro_recall@5']:.4f} "
        f"R@10={recall_test['micro_recall@10']:.4f} "
        f"R@20={recall_test['micro_recall@20']:.4f} "
        f"R@50={recall_test['micro_recall@50']:.4f} "
        f"local@20={recall_test['local_recall@20']:.4f} "
        f"imported@20={recall_test['imported_recall@20']:.4f}\n"
    )

print(preview_path.read_text())
print("saved:", output_path)
print("saved:", predictions_path)
print("saved:", preview_path)
