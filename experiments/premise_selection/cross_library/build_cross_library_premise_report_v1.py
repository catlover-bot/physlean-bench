import json
from pathlib import Path

ROOT = Path("/project/nlp-work11") / Path.home().name
BASE = ROOT / "theorem_generation"

PHYSLIB = BASE / "premise_selection_physlib_v0"
CSLIB = BASE / "premise_selection_cslib_v0"

OUTPUT_JSON = BASE / "cross_library_premise_selection_report_v1.json"
OUTPUT_TXT = BASE / "cross_library_premise_selection_report_v1.txt"


def load(path):
    return json.loads(path.read_text())


phys_summary = load(
    PHYSLIB / "summary_physlib_premise_selection_v1.json"
)
cslib_summary = load(
    CSLIB / "summary_cslib_premise_selection_v1.json"
)

phys_graph = load(
    PHYSLIB / "graph_transfer_results_v1.json"
)
cslib_graph = load(
    CSLIB / "graph_transfer_results_v1.json"
)

phys_quota = load(
    PHYSLIB / "import_quota_results_v1.json"
)
cslib_quota = load(
    CSLIB / "import_quota_results_v1.json"
)

phys_safe = load(
    PHYSLIB / "safe_import_replacement_results_v1.json"
)
cslib_safe = load(
    CSLIB / "safe_import_replacement_results_v1.json"
)

phys_bootstrap = load(
    PHYSLIB / "bootstrap_import_quota_vs_bm25_v1.json"
)
cslib_bootstrap = load(
    CSLIB / "paired_bootstrap_results_v1.json"
)

cslib_v2 = load(
    CSLIB / "structure_aware_safe_results_v2.json"
)


def selected_metrics(row):
    return {
        "MRR": row["MRR"],
        "R@5": row["micro_recall@5"],
        "R@10": row["micro_recall@10"],
        "R@20": row["micro_recall@20"],
        "R@50": row["micro_recall@50"],
        "local@20": row["local_recall@20"],
        "imported@20": row["imported_recall@20"],
        "imported@50": row["imported_recall@50"],
    }


def metric_delta(method, baseline):
    result = {}

    for key in [
        "MRR",
        "R@5",
        "R@10",
        "R@20",
        "R@50",
        "local@20",
        "imported@20",
        "imported@50",
    ]:
        result[key] = method[key] - baseline[key]

    return result


phys_bm25 = selected_metrics(
    phys_quota["test_bm25"]
)
phys_balanced = selected_metrics(
    phys_quota["best_balanced_test"]
)
phys_recall = selected_metrics(
    phys_quota["best_recall_test"]
)
phys_safe_test = selected_metrics(
    phys_safe["best_safe_test"]
)

cslib_bm25 = selected_metrics(
    cslib_quota["test_bm25"]
)
cslib_quota_test = selected_metrics(
    cslib_quota["best_balanced_test"]
)
cslib_safe_test = selected_metrics(
    cslib_safe["best_safe_test"]
)
cslib_v2_test = selected_metrics(
    cslib_v2["best_test"]
)


report = {
    "title": (
        "Cross-library premise-selection evaluation: "
        "Physlib and CSLib"
    ),
    "evaluation_scope": {
        "task": (
            "Retrieve gold theorem/lemma premises from the "
            "legally visible candidate set"
        ),
        "metric_interpretation": (
            "Recall@K is premise-label recovery, not Lean proof success"
        ),
        "split_policy": (
            "approximately 80/10/10 module-disjoint splits"
        ),
    },
    "datasets": {
        "Physlib": {
            "catalog_size": phys_summary["catalog_size"],
            "positive_targets": (
                phys_summary["positive_target_count"]
            ),
            "test_positive_targets": (
                phys_summary["split_counts_positive"]["test"]
            ),
            "test_gold_labels": (
                phys_summary["split_gold_counts"]["test"]
            ),
            "candidate_statistics": (
                phys_summary["candidate_count_statistics"]
            ),
            "gold_locations": (
                phys_summary["gold_location_counts"]
            ),
        },
        "CSLib": {
            "catalog_size": cslib_summary["catalog_size"],
            "positive_targets": (
                cslib_summary["positive_target_count"]
            ),
            "test_positive_targets": (
                cslib_summary["split_counts_positive"]["test"]
            ),
            "test_gold_labels": (
                cslib_summary["split_gold_counts"]["test"]
            ),
            "candidate_statistics": (
                cslib_summary["candidate_count_statistics"]
            ),
            "gold_locations": (
                cslib_summary["gold_location_counts"]
            ),
        },
    },
    "official_validation_selected_results": {
        "Physlib": {
            "baseline_bm25": phys_bm25,
            "balanced_import_quota": phys_balanced,
            "balanced_delta": metric_delta(
                phys_balanced,
                phys_bm25,
            ),
            "recall_oriented_import_quota": phys_recall,
            "recall_oriented_delta": metric_delta(
                phys_recall,
                phys_bm25,
            ),
            "balanced_configuration": {
                "protected_prefix": (
                    phys_quota[
                        "best_balanced_test"
                    ]["protected_prefix"]
                ),
                "imported_quota": (
                    phys_quota[
                        "best_balanced_test"
                    ]["imported_quota"]
                ),
                "transfer_weight": (
                    phys_quota[
                        "best_balanced_test"
                    ]["transfer_weight"]
                ),
            },
            "recall_configuration": {
                "protected_prefix": (
                    phys_quota[
                        "best_recall_test"
                    ]["protected_prefix"]
                ),
                "imported_quota": (
                    phys_quota[
                        "best_recall_test"
                    ]["imported_quota"]
                ),
                "transfer_weight": (
                    phys_quota[
                        "best_recall_test"
                    ]["transfer_weight"]
                ),
            },
        },
        "CSLib": {
            "baseline_bm25": cslib_bm25,
            "import_quota": cslib_quota_test,
            "quota_delta": metric_delta(
                cslib_quota_test,
                cslib_bm25,
            ),
            "configuration": {
                "protected_prefix": (
                    cslib_quota[
                        "best_balanced_test"
                    ]["protected_prefix"]
                ),
                "imported_quota": (
                    cslib_quota[
                        "best_balanced_test"
                    ]["imported_quota"]
                ),
                "transfer_weight": (
                    cslib_quota[
                        "best_balanced_test"
                    ]["transfer_weight"]
                ),
            },
        },
    },
    "feature_only_test": {
        "Physlib": {
            name: selected_metrics(row)
            for name, row in (
                phys_graph["feature_only_test"].items()
            )
        },
        "CSLib": {
            name: selected_metrics(row)
            for name, row in (
                cslib_graph["feature_only_test"].items()
            )
        },
    },
    "statistical_evidence": {
        "Physlib": {
            "balanced": phys_bootstrap["balanced"],
            "recall_oriented": (
                phys_bootstrap["recall_oriented"]
            ),
        },
        "CSLib": {
            "paired_bootstrap": (
                cslib_bootstrap["statistics"]
            ),
            "per_target_recall_at_20": (
                cslib_bootstrap[
                    "per_target_recall_at_20"
                ]
            ),
        },
    },
    "secondary_results": {
        "Physlib_safe_replacement": {
            "selection_policy": (
                phys_safe["selection_policy"]
            ),
            "test": phys_safe_test,
            "delta": metric_delta(
                phys_safe_test,
                phys_bm25,
            ),
            "per_target": (
                phys_safe[
                    "test_per_target_recall_at_20"
                ]
            ),
        },
        "CSLib_safe_replacement": {
            "selection_policy": (
                cslib_safe["selection_policy"]
            ),
            "test": cslib_safe_test,
            "delta": metric_delta(
                cslib_safe_test,
                cslib_bm25,
            ),
            "per_target": (
                cslib_safe[
                    "test_per_target_recall_at_20"
                ]
            ),
        },
    },
    "exploratory_posthoc_results": {
        "CSLib_structure_aware_safe_v2": {
            "status": cslib_v2["status"],
            "test": cslib_v2_test,
            "delta": metric_delta(
                cslib_v2_test,
                cslib_bm25,
            ),
            "per_target": (
                cslib_v2[
                    "test_per_target_recall_at_20"
                ]
            ),
            "formal_main_result": False,
        },
    },
    "conclusions": [
        (
            "The raw structural graph feature alone does not "
            "outperform BM25 in either library."
        ),
        (
            "Physlib shows a robust Top-20 gain from the "
            "import-aware dual-channel ranking."
        ),
        (
            "CSLib does not reproduce the Top-20 gain, but "
            "does show statistically supported Top-50 and "
            "imported-Top-50 gains."
        ),
        (
            "CSLib Top-10 recall decreases, showing that "
            "dependency transfer can improve broad coverage "
            "while disturbing early precision."
        ),
        (
            "The cross-library evidence supports a conditional "
            "rather than universal claim: dependency transfer "
            "is useful, but its optimal reranking depth and "
            "strength depend on library structure."
        ),
        (
            "Structure-aware Safe v2 is post-hoc exploratory "
            "analysis and must not be reported as an untouched-"
            "test result."
        ),
    ],
}

OUTPUT_JSON.write_text(
    json.dumps(
        report,
        ensure_ascii=False,
        indent=2,
    )
    + "\n"
)


def fmt(value):
    return f"{value:.4f}"


lines = []

lines.append(
    "Cross-library premise-selection evaluation v1"
)
lines.append("=" * 112)
lines.append("")

lines.append("Dataset scale")
lines.append("-" * 112)
lines.append(
    f"{'Library':10s} "
    f"{'Catalog':>9s} "
    f"{'Positive':>9s} "
    f"{'Test':>7s} "
    f"{'Test gold':>10s} "
    f"{'Candidate median':>18s} "
    f"{'Candidate max':>14s}"
)

for library in ["Physlib", "CSLib"]:
    row = report["datasets"][library]

    lines.append(
        f"{library:10s} "
        f"{row['catalog_size']:9d} "
        f"{row['positive_targets']:9d} "
        f"{row['test_positive_targets']:7d} "
        f"{row['test_gold_labels']:10d} "
        f"{row['candidate_statistics']['median']:18.1f} "
        f"{row['candidate_statistics']['max']:14d}"
    )

lines.append("")
lines.append("Official validation-selected test results")
lines.append("-" * 112)
lines.append(
    f"{'Library / Method':36s} "
    f"{'MRR':>8s} "
    f"{'R@10':>8s} "
    f"{'R@20':>8s} "
    f"{'R@50':>8s} "
    f"{'local@20':>10s} "
    f"{'import@20':>10s} "
    f"{'import@50':>10s}"
)


def add_result(label, row):
    lines.append(
        f"{label:36s} "
        f"{fmt(row['MRR']):>8s} "
        f"{fmt(row['R@10']):>8s} "
        f"{fmt(row['R@20']):>8s} "
        f"{fmt(row['R@50']):>8s} "
        f"{fmt(row['local@20']):>10s} "
        f"{fmt(row['imported@20']):>10s} "
        f"{fmt(row['imported@50']):>10s}"
    )


add_result("Physlib / BM25", phys_bm25)
add_result("Physlib / Balanced quota", phys_balanced)
add_result("Physlib / Recall quota", phys_recall)
add_result("CSLib / BM25", cslib_bm25)
add_result("CSLib / Import quota", cslib_quota_test)

lines.append("")
lines.append("Official deltas against BM25")
lines.append("-" * 112)

for label, delta in [
    (
        "Physlib balanced",
        metric_delta(phys_balanced, phys_bm25),
    ),
    (
        "Physlib recall-oriented",
        metric_delta(phys_recall, phys_bm25),
    ),
    (
        "CSLib quota",
        metric_delta(cslib_quota_test, cslib_bm25),
    ),
]:
    lines.append(
        f"{label:28s} "
        f"ΔMRR={delta['MRR']:+.4f} "
        f"ΔR@10={delta['R@10']:+.4f} "
        f"ΔR@20={delta['R@20']:+.4f} "
        f"ΔR@50={delta['R@50']:+.4f} "
        f"Δimport@20={delta['imported@20']:+.4f} "
        f"Δimport@50={delta['imported@50']:+.4f}"
    )

lines.append("")
lines.append("CSLib paired-bootstrap evidence")
lines.append("-" * 112)

for metric in [
    "MRR",
    "micro_recall@10",
    "micro_recall@20",
    "micro_recall@50",
    "imported_recall@20",
    "imported_recall@50",
]:
    row = cslib_bootstrap["statistics"][metric]
    low, high = row["ci95"]

    lines.append(
        f"{metric:22s} "
        f"delta={row['delta']:+.4f} "
        f"CI95=[{low:+.4f}, {high:+.4f}] "
        f"P(delta>0)="
        f"{row['bootstrap_probability_delta_gt_0']:.4f}"
    )

lines.append("")
lines.append("Interpretation")
lines.append("-" * 112)

for index, conclusion in enumerate(
    report["conclusions"],
    1,
):
    lines.append(f"{index}. {conclusion}")

lines.append("")
lines.append(
    "Important: Recall@K measures gold-premise retrieval, "
    "not end-to-end Lean proof success."
)

OUTPUT_TXT.write_text("\n".join(lines) + "\n")

print(OUTPUT_TXT.read_text())
print("saved:", OUTPUT_JSON)
print("saved:", OUTPUT_TXT)
