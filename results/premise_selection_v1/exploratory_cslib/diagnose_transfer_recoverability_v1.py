import importlib.util
import json
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
OUTPUT_PATH = BENCH / "transfer_recoverability_diagnosis_v1.json"

spec = importlib.util.spec_from_file_location(
    "cslib_graph_transfer",
    BASE_SCRIPT,
)
base = importlib.util.module_from_spec(spec)
spec.loader.exec_module(base)

counts = Counter()
missed_gold_rows = []
target_rows = []

for record in base.test_features:
    target = record["target"]
    features = record["features"]
    candidate_ids = target["candidate_premise_ids"]
    gold_ids = set(target["gold_premise_ids"])

    bm25_ranking = sorted(
        candidate_ids,
        key=lambda pid: (
            features["bm25"][pid],
            base.catalog_by_id[pid]["declaration_name"],
        ),
        reverse=True,
    )

    transfer_ranking = sorted(
        candidate_ids,
        key=lambda pid: (
            features["transfer"][pid],
            features["bm25"][pid],
            base.catalog_by_id[pid]["declaration_name"],
        ),
        reverse=True,
    )

    bm25_rank = {
        pid: rank
        for rank, pid in enumerate(bm25_ranking, 1)
    }
    transfer_rank = {
        pid: rank
        for rank, pid in enumerate(transfer_ranking, 1)
    }

    imported_gold_names = set(
        target["gold_imported_modules"]
    )

    imported_gold_ids = {
        pid
        for pid in gold_ids
        if (
            base.catalog_by_id[pid]["declaration_name"]
            in imported_gold_names
        )
    }

    missed_ids = {
        pid
        for pid in gold_ids
        if bm25_rank[pid] > 20
    }

    target_recoverable = 0

    for pid in sorted(missed_ids):
        premise = base.catalog_by_id[pid]
        transfer_score = features["transfer"][pid]
        imported = pid in imported_gold_ids

        counts["missed_gold_total"] += 1
        counts[
            "missed_gold_imported"
            if imported
            else "missed_gold_local"
        ] += 1

        if transfer_score > 0:
            counts["missed_gold_transfer_positive"] += 1
            target_recoverable += 1

            if imported:
                counts[
                    "missed_imported_gold_transfer_positive"
                ] += 1
        else:
            counts["missed_gold_transfer_zero"] += 1

        if transfer_rank[pid] <= 5:
            counts["missed_gold_transfer_top5"] += 1
        if transfer_rank[pid] <= 10:
            counts["missed_gold_transfer_top10"] += 1
        if transfer_rank[pid] <= 20:
            counts["missed_gold_transfer_top20"] += 1
        if transfer_rank[pid] <= 50:
            counts["missed_gold_transfer_top50"] += 1

        missed_gold_rows.append({
            "target": target["declaration_name"],
            "module": target["module_path"],
            "premise": premise["declaration_name"],
            "location": (
                "imported" if imported else "same_file"
            ),
            "bm25_rank": bm25_rank[pid],
            "bm25_score": features["bm25"][pid],
            "transfer_rank": transfer_rank[pid],
            "transfer_score": transfer_score,
            "candidate_count": target["candidate_count"],
            "nearest_train_targets": [
                {
                    "rank": neighbor["rank"],
                    "train_target": neighbor["train_target"],
                    "similarity": neighbor["similarity"],
                    "transferred_this_gold": (
                        pid
                        in neighbor[
                            "transferred_premise_ids"
                        ]
                    ),
                }
                for neighbor in record["neighbors"][:10]
            ],
        })

    if missed_ids:
        counts["targets_with_missed_gold"] += 1

        if target_recoverable:
            counts[
                "targets_with_transfer_recoverable_gold"
            ] += 1

    target_rows.append({
        "target": target["declaration_name"],
        "gold_count": len(gold_ids),
        "missed_at_20": len(missed_ids),
        "transfer_positive_missed": target_recoverable,
    })

positive_scores = [
    row["transfer_score"]
    for row in missed_gold_rows
    if row["transfer_score"] > 0
]

transfer_ranks = [
    row["transfer_rank"]
    for row in missed_gold_rows
    if row["transfer_score"] > 0
]

output = {
    "analysis": (
        "Recoverability of BM25 Top-20 missed CSLib gold "
        "premises using nearest-theorem transfer"
    ),
    "test_target_count": len(base.test_features),
    "counts": dict(sorted(counts.items())),
    "positive_transfer_score_statistics": {
        "count": len(positive_scores),
        "min": min(positive_scores) if positive_scores else None,
        "median": (
            statistics.median(positive_scores)
            if positive_scores else None
        ),
        "max": max(positive_scores) if positive_scores else None,
    },
    "positive_transfer_rank_statistics": {
        "min": min(transfer_ranks) if transfer_ranks else None,
        "median": (
            statistics.median(transfer_ranks)
            if transfer_ranks else None
        ),
        "max": max(transfer_ranks) if transfer_ranks else None,
    },
    "missed_gold_records": missed_gold_rows,
    "target_records": target_rows,
}

OUTPUT_PATH.write_text(
    json.dumps(output, ensure_ascii=False, indent=2) + "\n"
)

print("CSLib transfer recoverability diagnosis")
print("=" * 104)
print("test targets:", len(base.test_features))

for key, value in sorted(counts.items()):
    print(f"{key:44s}: {value}")

print("\nPositive transfer-score statistics")
print("-" * 104)
print(output["positive_transfer_score_statistics"])

print("\nPositive transfer-rank statistics")
print("-" * 104)
print(output["positive_transfer_rank_statistics"])

print("\nMissed gold premises with positive transfer signal")
print("-" * 104)

for row in sorted(
    (
        row
        for row in missed_gold_rows
        if row["transfer_score"] > 0
    ),
    key=lambda row: (
        row["transfer_rank"],
        row["bm25_rank"],
        row["target"],
    ),
)[:40]:
    print(json.dumps({
        "target": row["target"],
        "premise": row["premise"],
        "location": row["location"],
        "bm25_rank": row["bm25_rank"],
        "transfer_rank": row["transfer_rank"],
        "transfer_score": round(
            row["transfer_score"],
            6,
        ),
        "supporting_neighbors": [
            neighbor
            for neighbor in row["nearest_train_targets"]
            if neighbor["transferred_this_gold"]
        ],
    }, ensure_ascii=False))

print("\nsaved:", OUTPUT_PATH)
