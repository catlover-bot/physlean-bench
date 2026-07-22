import json
from collections import Counter
from pathlib import Path

root = Path("/project/nlp-work11") / Path.home().name
bench = root / "theorem_generation/premise_selection_physlib_v0"
trace_root = root / "physlean_trace_rc13_week_8cpu"

catalog_path = bench / "physlib_premise_catalog_v1.jsonl"
all_targets_path = bench / "physlib_premise_targets_all_v1.jsonl"
positive_targets_path = bench / "physlib_premise_targets_positive_v1.jsonl"
trace_path = trace_root / "traced_theorems.clean.v0.jsonl"
import_graph_path = trace_root / "physlib_import_graph_v1.json"

output_path = bench / "benchmark_audit_v1.json"
preview_path = bench / "benchmark_audit_v1.txt"

def read_jsonl(path):
    return [
        json.loads(line)
        for line in path.read_text().splitlines()
        if line.strip()
    ]

catalog = read_jsonl(catalog_path)
all_targets = read_jsonl(all_targets_path)
positive_targets = read_jsonl(positive_targets_path)
trace = read_jsonl(trace_path)
import_graph = json.loads(import_graph_path.read_text())

catalog_by_id = {row["premise_id"]: row for row in catalog}
catalog_by_name = {
    row["declaration_name"]: row
    for row in catalog
}
trace_by_name = {
    row["declaration_name"]: row
    for row in trace
}

direct_imports = {
    module: set(imports)
    for module, imports in import_graph["direct_imports"].items()
}

closure_cache = {}

def transitive_imports(module):
    if module in closure_cache:
        return closure_cache[module]

    seen = set()
    stack = list(direct_imports.get(module, set()))

    while stack:
        current = stack.pop()

        if current in seen:
            continue

        seen.add(current)
        stack.extend(direct_imports.get(current, set()))

    closure_cache[module] = seen
    return seen

errors = []
warnings = []

# ------------------------------------------------------------------
# 1. Catalog uniqueness and source consistency
# ------------------------------------------------------------------

catalog_ids = [row["premise_id"] for row in catalog]
catalog_names = [row["declaration_name"] for row in catalog]

if len(catalog_ids) != len(set(catalog_ids)):
    errors.append("duplicate premise_id in catalog")

if len(catalog_names) != len(set(catalog_names)):
    errors.append("duplicate declaration_name in catalog")

missing_from_trace = sorted(set(catalog_names) - set(trace_by_name))

if missing_from_trace:
    errors.append(
        f"{len(missing_from_trace)} catalog declarations missing from trace"
    )

# ------------------------------------------------------------------
# 2. Explain 5593 versus theorem/lemma quality counts
# ------------------------------------------------------------------

trace_kind_counts = Counter(
    str(row.get("declaration_kind"))
    for row in trace
)

catalog_source_kind_counts = Counter()
catalog_quality_counts = Counter()

for row in catalog:
    source = trace_by_name.get(row["declaration_name"], {})

    catalog_source_kind_counts[
        str(source.get("declaration_kind"))
    ] += 1

    key = (
        bool(source.get("has_sorry")),
        bool(source.get("has_admit")),
        bool(source.get("is_auto_generated")),
        str(source.get("filter_excluded_reason")),
    )
    catalog_quality_counts[str(key)] += 1

lemma_like_kinds = {"lemma", "theorem", "commandtheorem"}

trace_lemma_like = [
    row
    for row in trace
    if str(row.get("declaration_kind")).lower()
    in lemma_like_kinds
]

trace_quality_lemma_like = [
    row
    for row in trace_lemma_like
    if not row.get("has_sorry")
    and not row.get("has_admit")
    and not row.get("is_auto_generated")
    and row.get("filter_excluded_reason") is None
]

catalog_non_lemma_like = []

for row in catalog:
    source = trace_by_name.get(row["declaration_name"], {})
    kind = str(source.get("declaration_kind")).lower()

    if kind not in lemma_like_kinds:
        catalog_non_lemma_like.append({
            "declaration_name": row["declaration_name"],
            "source_kind": source.get("declaration_kind"),
        })

catalog_quality_violations = []

for row in catalog:
    source = trace_by_name.get(row["declaration_name"], {})

    if (
        source.get("has_sorry")
        or source.get("has_admit")
        or source.get("is_auto_generated")
        or source.get("filter_excluded_reason") is not None
    ):
        catalog_quality_violations.append({
            "declaration_name": row["declaration_name"],
            "has_sorry": source.get("has_sorry"),
            "has_admit": source.get("has_admit"),
            "is_auto_generated": source.get("is_auto_generated"),
            "filter_excluded_reason": source.get(
                "filter_excluded_reason"
            ),
        })

# ------------------------------------------------------------------
# 3. Leakage and schema checks
# ------------------------------------------------------------------

forbidden_fields = {
    "proof_text",
    "used_premises",
    "used_local_premises",
    "accessible_premises",
}

catalog_forbidden = Counter()
target_forbidden = Counter()

for row in catalog:
    for field in forbidden_fields:
        if field in row:
            catalog_forbidden[field] += 1

for row in all_targets:
    for field in forbidden_fields:
        if field in row:
            target_forbidden[field] += 1

if catalog_forbidden:
    errors.append(
        f"forbidden leakage fields in catalog: "
        f"{dict(catalog_forbidden)}"
    )

if target_forbidden:
    errors.append(
        f"forbidden leakage fields in targets: "
        f"{dict(target_forbidden)}"
    )

# ------------------------------------------------------------------
# 4. Split disjointness
# ------------------------------------------------------------------

modules_by_split = {
    "train": set(),
    "validation": set(),
    "test": set(),
}

for target in all_targets:
    modules_by_split[target["split"]].add(target["module_path"])

split_overlaps = {}

for left, right in [
    ("train", "validation"),
    ("train", "test"),
    ("validation", "test"),
]:
    overlap = sorted(
        modules_by_split[left] & modules_by_split[right]
    )
    split_overlaps[f"{left}_{right}"] = overlap

    if overlap:
        errors.append(
            f"module split overlap {left}/{right}: {len(overlap)}"
        )

# ------------------------------------------------------------------
# 5. Candidate and gold integrity
# ------------------------------------------------------------------

target_names = set()
candidate_reference_errors = 0
gold_reference_errors = 0
gold_not_candidate_errors = 0
target_self_candidate_errors = 0
future_same_file_errors = 0
unreachable_import_candidate_errors = 0
candidate_count_mismatches = 0
gold_count_mismatches = 0

for target in all_targets:
    name = target["declaration_name"]

    if name in target_names:
        errors.append(f"duplicate target: {name}")

    target_names.add(name)

    candidate_ids = target["candidate_premise_ids"]
    gold_ids = target["gold_premise_ids"]

    if target.get("candidate_count") != len(candidate_ids):
        candidate_count_mismatches += 1

    if target.get("gold_count") != len(gold_ids):
        gold_count_mismatches += 1

    candidate_set = set(candidate_ids)
    gold_set = set(gold_ids)

    if not gold_set.issubset(candidate_set):
        gold_not_candidate_errors += 1

    target_catalog = catalog_by_name.get(name)

    if (
        target_catalog is not None
        and target_catalog["premise_id"] in candidate_set
    ):
        target_self_candidate_errors += 1

    imported_modules = transitive_imports(target["module_path"])

    for premise_id in candidate_ids:
        premise = catalog_by_id.get(premise_id)

        if premise is None:
            candidate_reference_errors += 1
            continue

        if premise["file_path"] == target["file_path"]:
            if premise["line_start"] >= target["line_start"]:
                future_same_file_errors += 1
        elif premise["module_path"] not in imported_modules:
            unreachable_import_candidate_errors += 1

    for premise_id in gold_ids:
        if premise_id not in catalog_by_id:
            gold_reference_errors += 1

if candidate_count_mismatches:
    errors.append(
        f"candidate_count mismatches: {candidate_count_mismatches}"
    )

if gold_count_mismatches:
    errors.append(
        f"gold_count mismatches: {gold_count_mismatches}"
    )

if candidate_reference_errors:
    errors.append(
        f"unknown candidate premise IDs: {candidate_reference_errors}"
    )

if gold_reference_errors:
    errors.append(
        f"unknown gold premise IDs: {gold_reference_errors}"
    )

if gold_not_candidate_errors:
    errors.append(
        f"targets with gold outside candidates: "
        f"{gold_not_candidate_errors}"
    )

if target_self_candidate_errors:
    errors.append(
        f"targets containing themselves as candidates: "
        f"{target_self_candidate_errors}"
    )

if future_same_file_errors:
    errors.append(
        f"future same-file candidates: {future_same_file_errors}"
    )

if unreachable_import_candidate_errors:
    errors.append(
        f"cross-file candidates not import-reachable: "
        f"{unreachable_import_candidate_errors}"
    )

# ------------------------------------------------------------------
# 6. Positive-file consistency
# ------------------------------------------------------------------

expected_positive_names = {
    row["declaration_name"]
    for row in all_targets
    if len(row["gold_premise_ids"]) > 0
}

actual_positive_names = {
    row["declaration_name"]
    for row in positive_targets
}

if expected_positive_names != actual_positive_names:
    errors.append(
        "positive target file does not match all-target gold filtering"
    )

result = {
    "status": "PASS" if not errors else "FAIL",
    "errors": errors,
    "warnings": warnings,
    "counts": {
        "trace": len(trace),
        "trace_lemma_like": len(trace_lemma_like),
        "trace_quality_lemma_like": len(trace_quality_lemma_like),
        "catalog": len(catalog),
        "all_targets": len(all_targets),
        "positive_targets": len(positive_targets),
    },
    "kind_analysis": {
        "trace_kind_counts": dict(trace_kind_counts),
        "catalog_source_kind_counts": dict(
            catalog_source_kind_counts
        ),
        "catalog_non_lemma_like_count": len(
            catalog_non_lemma_like
        ),
        "catalog_non_lemma_like_examples": (
            catalog_non_lemma_like[:20]
        ),
        "catalog_quality_violation_count": len(
            catalog_quality_violations
        ),
        "catalog_quality_violation_examples": (
            catalog_quality_violations[:20]
        ),
        "catalog_quality_tuple_counts": dict(
            catalog_quality_counts
        ),
    },
    "leakage": {
        "catalog_forbidden_fields": dict(catalog_forbidden),
        "target_forbidden_fields": dict(target_forbidden),
    },
    "split": {
        "module_counts": {
            key: len(value)
            for key, value in modules_by_split.items()
        },
        "overlaps": split_overlaps,
    },
    "candidate_integrity": {
        "candidate_count_mismatches": (
            candidate_count_mismatches
        ),
        "gold_count_mismatches": gold_count_mismatches,
        "unknown_candidate_ids": candidate_reference_errors,
        "unknown_gold_ids": gold_reference_errors,
        "targets_with_gold_outside_candidates": (
            gold_not_candidate_errors
        ),
        "self_candidate_targets": (
            target_self_candidate_errors
        ),
        "future_same_file_candidates": (
            future_same_file_errors
        ),
        "unreachable_cross_file_candidates": (
            unreachable_import_candidate_errors
        ),
    },
}

output_path.write_text(
    json.dumps(result, ensure_ascii=False, indent=2) + "\n"
)

with preview_path.open("w") as file:
    file.write("Physlib Premise Selection v1 — Benchmark audit\n")
    file.write("=" * 76 + "\n\n")

    file.write(f"status: {result['status']}\n\n")

    file.write("Counts\n")
    file.write("-" * 76 + "\n")

    for key, value in result["counts"].items():
        file.write(f"{key:30s} {value}\n")

    file.write("\nSource declaration kinds\n")
    file.write("-" * 76 + "\n")
    file.write(
        json.dumps(
            result["kind_analysis"]["trace_kind_counts"],
            ensure_ascii=False,
            indent=2,
        )
        + "\n"
    )

    file.write(
        "\ncatalog_non_lemma_like_count: "
        f"{len(catalog_non_lemma_like)}\n"
    )
    file.write(
        "catalog_quality_violation_count: "
        f"{len(catalog_quality_violations)}\n"
    )

    file.write("\nLeakage\n")
    file.write("-" * 76 + "\n")
    file.write(
        f"catalog forbidden fields: "
        f"{dict(catalog_forbidden)}\n"
    )
    file.write(
        f"target forbidden fields: "
        f"{dict(target_forbidden)}\n"
    )

    file.write("\nSplit overlaps\n")
    file.write("-" * 76 + "\n")
    file.write(
        json.dumps(split_overlaps, ensure_ascii=False, indent=2)
        + "\n"
    )

    file.write("\nCandidate integrity\n")
    file.write("-" * 76 + "\n")

    for key, value in result["candidate_integrity"].items():
        file.write(f"{key:42s} {value}\n")

    if errors:
        file.write("\nErrors\n")
        file.write("-" * 76 + "\n")

        for error in errors:
            file.write(f"- {error}\n")

    if catalog_non_lemma_like:
        file.write("\nNon-lemma-like catalog examples\n")
        file.write("-" * 76 + "\n")

        for row in catalog_non_lemma_like[:20]:
            file.write(
                f"{row['source_kind']}: "
                f"{row['declaration_name']}\n"
            )

print(preview_path.read_text())
print("saved:", output_path)
print("saved:", preview_path)
