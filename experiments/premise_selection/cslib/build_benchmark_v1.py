import hashlib
import json
import re
import statistics
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path("/project/nlp-work11") / Path.home().name

OUT_DIR = (
    ROOT
    / "theorem_generation"
    / "premise_selection_cslib_v0"
)

TRACE_DIR = ROOT / "crossdomain_trace/cslib_parts"

FULL_CATALOG_PATH = (
    ROOT
    / "theorem_generation"
    / "library_completion_topk_v0"
    / "cslib_full_declarations_norm_v3.jsonl"
)

IMPORT_GRAPH_PATH = OUT_DIR / "cslib_import_graph_v1.json"

CATALOG_PATH = OUT_DIR / "cslib_premise_catalog_v1.jsonl"
ALL_TARGETS_PATH = OUT_DIR / "cslib_premise_targets_all_v1.jsonl"
POSITIVE_TARGETS_PATH = (
    OUT_DIR / "cslib_premise_targets_positive_v1.jsonl"
)
SUMMARY_PATH = OUT_DIR / "summary_cslib_premise_selection_v1.json"

SOURCE_COMMIT = "6d112db496f8528f4991fd7be32257e89861a4d7"
LEMMA_LIKE = {"lemma", "theorem", "commandtheorem"}


def read_jsonl(path):
    return [
        json.loads(line)
        for line in path.read_text().splitlines()
        if line.strip()
    ]


def normalize_file(value):
    value = str(value)

    if value.startswith("/"):
        marker = "/Cslib/"
        index = value.find(marker)

        if index >= 0:
            return value[index + 1 :]

    return value


def file_to_module(file_path):
    value = normalize_file(file_path)

    if value.endswith(".lean"):
        value = value[:-5]

    return value.replace("/", ".")


def is_private_declaration(text):
    return bool(
        re.match(
            r"^\s*private\s+(?:lemma|theorem)\b",
            str(text or ""),
        )
    )


def percentile(values, quantile):
    ordered = sorted(values)
    index = round((len(ordered) - 1) * quantile)
    return ordered[index]


trace_paths = sorted(
    TRACE_DIR.glob("*/traced_theorems.jsonl")
)

trace_rows = [
    row
    for path in trace_paths
    for row in read_jsonl(path)
]

full_rows = read_jsonl(FULL_CATALOG_PATH)

graph = json.loads(IMPORT_GRAPH_PATH.read_text())

import_closure = {
    module: set(imports)
    for module, imports
    in graph["transitive_imports"].items()
}


# ------------------------------------------------------------------
# Premise catalog
# ------------------------------------------------------------------

premise_by_name = {}

for row in full_rows:
    if row.get("kind") not in {"lemma", "theorem"}:
        continue

    file_path = normalize_file(row["file"])
    header = str(row.get("header") or "")

    premise_by_name[row["name"]] = {
        "declaration_name": row["name"],
        "declaration_kind": row["kind"],
        "namespace": str(row.get("namespace") or ""),
        "module_path": file_to_module(file_path),
        "file_path": file_path,
        "line_start": int(row.get("line") or 0),
        "line_end": int(row.get("line") or 0),
        "statement": header,
        "source_commit": SOURCE_COMMIT,
        "is_private": is_private_declaration(header),
        "catalog_source": "full_catalog",
    }


# Trace recordの方が、statement・位置情報ともに高精度なので上書きする。
for row in trace_rows:
    if row.get("declaration_kind") not in LEMMA_LIKE:
        continue

    if (
        row.get("has_sorry", False)
        or row.get("has_admit", False)
        or row.get("is_auto_generated", False)
        or row.get("filter_excluded_reason") is not None
    ):
        continue

    statement = str(row.get("statement") or "")

    premise_by_name[row["declaration_name"]] = {
        "declaration_name": row["declaration_name"],
        "declaration_kind": (
            "theorem"
            if row["declaration_kind"] == "commandtheorem"
            else row["declaration_kind"]
        ),
        "namespace": str(row.get("namespace") or ""),
        "module_path": row["module_path"],
        "file_path": normalize_file(row["file_path"]),
        "line_start": int(row["line_start"]),
        "line_end": int(row["line_end"]),
        "statement": statement,
        "source_commit": SOURCE_COMMIT,
        "is_private": is_private_declaration(statement),
        "catalog_source": "trace",
    }


sorted_premise_names = sorted(premise_by_name)
premise_id = {
    name: index
    for index, name in enumerate(sorted_premise_names)
}
premise_names = set(sorted_premise_names)

premises_by_file = defaultdict(list)
premises_by_module = defaultdict(list)

for premise in premise_by_name.values():
    premises_by_file[premise["file_path"]].append(premise)
    premises_by_module[premise["module_path"]].append(premise)

for premises in premises_by_file.values():
    premises.sort(
        key=lambda row: (
            row["line_start"],
            row["declaration_name"],
        )
    )

for premises in premises_by_module.values():
    premises.sort(
        key=lambda row: (
            row["file_path"],
            row["line_start"],
            row["declaration_name"],
        )
    )


# ------------------------------------------------------------------
# Target records
# ------------------------------------------------------------------

target_rows = [
    row
    for row in trace_rows
    if (
        row.get("declaration_kind") in LEMMA_LIKE
        and not row.get("has_sorry", False)
        and not row.get("has_admit", False)
        and not row.get("is_auto_generated", False)
        and row.get("filter_excluded_reason") is None
    )
]


# Physlib版と同じモジュール単位の約80:10:10分割。
module_sizes = Counter(
    row["module_path"]
    for row in target_rows
)


def stable_hash(module):
    return hashlib.sha256(module.encode()).hexdigest()


ordered_modules = sorted(
    module_sizes,
    key=lambda module: (
        -module_sizes[module],
        stable_hash(module),
    ),
)

desired = {
    "train": len(target_rows) * 0.80,
    "validation": len(target_rows) * 0.10,
    "test": len(target_rows) * 0.10,
}

assigned = Counter()
module_split = {}

for module in ordered_modules:
    split = max(
        desired,
        key=lambda candidate: (
            desired[candidate] - assigned[candidate],
            -assigned[candidate],
        ),
    )

    module_split[module] = split
    assigned[split] += module_sizes[module]


# ------------------------------------------------------------------
# Catalog output
# ------------------------------------------------------------------

with CATALOG_PATH.open("w") as file:
    for name in sorted_premise_names:
        row = premise_by_name[name]

        record = {
            "premise_id": premise_id[name],
            "declaration_name": name,
            "declaration_kind": row["declaration_kind"],
            "namespace": row["namespace"],
            "module_path": row["module_path"],
            "file_path": row["file_path"],
            "line_start": row["line_start"],
            "line_end": row["line_end"],
            "statement": row["statement"],
            "source_commit": SOURCE_COMMIT,
        }

        file.write(
            json.dumps(record, ensure_ascii=False) + "\n"
        )


# ------------------------------------------------------------------
# Candidate/gold construction
# ------------------------------------------------------------------

all_records = []
positive_records = []
coverage_failures = []

candidate_sizes = []
gold_sizes = []

split_counts_all = Counter()
split_counts_positive = Counter()
split_gold_counts = Counter()
gold_location_counts = Counter()

private_import_candidates_removed = 0

for target in sorted(
    target_rows,
    key=lambda row: (
        row["module_path"],
        int(row["line_start"]),
        row["declaration_name"],
    ),
):
    target_name = target["declaration_name"]
    target_module = target["module_path"]
    target_file = normalize_file(target["file_path"])
    target_line = int(target["line_start"])

    candidate_names = set()

    # 同一ファイル内は対象より前の宣言のみ。
    # private宣言も同一ファイル内では利用可能とみなす。
    for premise in premises_by_file.get(target_file, []):
        if premise["line_start"] < target_line:
            candidate_names.add(
                premise["declaration_name"]
            )

    # imported module内はpublic theorem/lemmaのみ。
    for imported_module in import_closure.get(
        target_module,
        set(),
    ):
        for premise in premises_by_module.get(
            imported_module,
            [],
        ):
            if premise["is_private"]:
                private_import_candidates_removed += 1
                continue

            candidate_names.add(
                premise["declaration_name"]
            )

    candidate_names.discard(target_name)

    used_names = {
        value
        for value in (target.get("used_premises") or [])
        if isinstance(value, str) and value
    }

    raw_gold_names = used_names & premise_names
    raw_gold_names.discard(target_name)

    gold_names = raw_gold_names & candidate_names
    missing_gold = sorted(
        raw_gold_names - candidate_names
    )

    if missing_gold:
        coverage_failures.append({
            "target": target_name,
            "module_path": target_module,
            "missing_gold": missing_gold,
        })

    local_gold = []
    imported_gold = []

    for name in sorted(gold_names):
        premise = premise_by_name[name]

        if premise["file_path"] == target_file:
            local_gold.append(name)
            gold_location_counts["same_file_earlier"] += 1
        else:
            imported_gold.append(name)
            gold_location_counts["imported_module"] += 1

    sorted_candidates = sorted(candidate_names)
    sorted_gold = sorted(gold_names)
    split = module_split[target_module]

    record = {
        "target_id": target["theorem_id"],
        "declaration_name": target_name,
        "declaration_kind": (
            "theorem"
            if target["declaration_kind"] == "commandtheorem"
            else target["declaration_kind"]
        ),
        "namespace": str(target.get("namespace") or ""),
        "module_path": target_module,
        "file_path": target_file,
        "line_start": target_line,
        "line_end": int(target["line_end"]),
        "statement": str(target.get("statement") or ""),
        "split": split,
        "candidate_premise_ids": [
            premise_id[name]
            for name in sorted_candidates
        ],
        "gold_premise_ids": [
            premise_id[name]
            for name in sorted_gold
        ],
        "gold_premise_names": sorted_gold,
        "gold_same_file_earlier": local_gold,
        "gold_imported_modules": imported_gold,
        "candidate_count": len(sorted_candidates),
        "gold_count": len(sorted_gold),
        "source_commit": SOURCE_COMMIT,
    }

    all_records.append(record)
    candidate_sizes.append(len(sorted_candidates))
    split_counts_all[split] += 1

    if sorted_gold:
        positive_records.append(record)
        gold_sizes.append(len(sorted_gold))
        split_counts_positive[split] += 1
        split_gold_counts[split] += len(sorted_gold)


if coverage_failures:
    for failure in coverage_failures[:20]:
        print(
            json.dumps(
                failure,
                ensure_ascii=False,
                indent=2,
            )
        )

    raise RuntimeError(
        f"{len(coverage_failures)} targets have "
        "unreachable gold premises"
    )


with ALL_TARGETS_PATH.open("w") as file:
    for record in all_records:
        file.write(
            json.dumps(record, ensure_ascii=False) + "\n"
        )

with POSITIVE_TARGETS_PATH.open("w") as file:
    for record in positive_records:
        file.write(
            json.dumps(record, ensure_ascii=False) + "\n"
        )


summary = {
    "benchmark_name": "CSLib Premise Selection v1",
    "source_commit": SOURCE_COMMIT,
    "candidate_definition": {
        "same_file": (
            "eligible theorem/lemma declarations before "
            "the target, including same-file private declarations"
        ),
        "imported_modules": (
            "non-private eligible theorem/lemma declarations "
            "in transitive CSLib imports"
        ),
        "target_excluded": True,
    },
    "gold_definition": (
        "used_premises intersect eligible CSLib "
        "theorem/lemma declarations"
    ),
    "split_definition": {
        "unit": "module_path",
        "module_disjoint": True,
        "target_ratio": "approximately 80/10/10",
    },
    "catalog_size": len(sorted_premise_names),
    "all_target_count": len(all_records),
    "positive_target_count": len(positive_records),
    "zero_gold_target_count": (
        len(all_records) - len(positive_records)
    ),
    "total_gold_labels": sum(
        record["gold_count"]
        for record in positive_records
    ),
    "gold_coverage": 1.0,
    "split_counts_all": dict(
        sorted(split_counts_all.items())
    ),
    "split_counts_positive": dict(
        sorted(split_counts_positive.items())
    ),
    "split_gold_counts": dict(
        sorted(split_gold_counts.items())
    ),
    "module_counts_by_split": dict(
        sorted(
            Counter(module_split.values()).items()
        )
    ),
    "gold_location_counts": dict(
        sorted(gold_location_counts.items())
    ),
    "candidate_count_statistics": {
        "min": min(candidate_sizes),
        "median": statistics.median(candidate_sizes),
        "mean": statistics.mean(candidate_sizes),
        "p90": percentile(candidate_sizes, 0.90),
        "p95": percentile(candidate_sizes, 0.95),
        "max": max(candidate_sizes),
    },
    "gold_count_statistics_positive_targets": {
        "min": min(gold_sizes),
        "median": statistics.median(gold_sizes),
        "mean": statistics.mean(gold_sizes),
        "p90": percentile(gold_sizes, 0.90),
        "max": max(gold_sizes),
    },
    "visibility_audit": {
        "private_import_candidate_occurrences_removed": (
            private_import_candidates_removed
        ),
        "private_gold_count": 0,
    },
}

SUMMARY_PATH.write_text(
    json.dumps(
        summary,
        ensure_ascii=False,
        indent=2,
    )
    + "\n"
)


print("CSLib Premise Selection v1 build")
print("=" * 96)
print("catalog size       :", len(sorted_premise_names))
print("all targets        :", len(all_records))
print("positive targets   :", len(positive_records))
print("zero-gold targets  :", len(all_records) - len(positive_records))
print(
    "total gold labels  :",
    sum(record["gold_count"] for record in positive_records),
)
print("coverage failures  :", len(coverage_failures))
print("split all          :", dict(sorted(split_counts_all.items())))
print(
    "split positive     :",
    dict(sorted(split_counts_positive.items())),
)
print(
    "split gold labels  :",
    dict(sorted(split_gold_counts.items())),
)
print(
    "gold locations     :",
    dict(sorted(gold_location_counts.items())),
)
print(
    "candidate stats    :",
    summary["candidate_count_statistics"],
)
print(
    "gold count stats   :",
    summary["gold_count_statistics_positive_targets"],
)
print(
    "private imports removed:",
    private_import_candidates_removed,
)

print("\noutputs")
print("-" * 96)
print(CATALOG_PATH)
print(ALL_TARGETS_PATH)
print(POSITIVE_TARGETS_PATH)
print(SUMMARY_PATH)
