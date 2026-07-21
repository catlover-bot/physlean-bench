import hashlib
import json
import statistics
from collections import Counter, defaultdict, deque
from pathlib import Path

root = Path("/project/nlp-work11") / Path.home().name
out_dir = root / "theorem_generation/premise_selection_physlib_v0"

trace_path = (
    root
    / "physlean_trace_rc13_week_8cpu"
    / "traced_theorems.clean.v0.jsonl"
)
import_graph_path = (
    root
    / "physlean_trace_rc13_week_8cpu"
    / "physlib_import_graph_v1.json"
)

catalog_path = out_dir / "physlib_premise_catalog_v1.jsonl"
all_targets_path = out_dir / "physlib_premise_targets_all_v1.jsonl"
positive_targets_path = out_dir / "physlib_premise_targets_positive_v1.jsonl"
summary_path = out_dir / "summary_physlib_premise_selection_v1.json"
preview_path = out_dir / "preview_physlib_premise_selection_v1.txt"

rows = [
    json.loads(line)
    for line in trace_path.read_text().splitlines()
    if line.strip()
]

import_graph = json.loads(import_graph_path.read_text())
direct_imports = {
    module: set(imports)
    for module, imports in import_graph["direct_imports"].items()
}

by_name = {
    row["declaration_name"]: row
    for row in rows
}

if len(by_name) != len(rows):
    raise RuntimeError("duplicate declaration names found")

lemma_like_kinds = {"lemma", "theorem", "commandtheorem"}

def eligible(row):
    return (
        row["declaration_kind"] in lemma_like_kinds
        and not row.get("has_sorry", False)
        and not row.get("has_admit", False)
        and not row.get("is_auto_generated", False)
        and row.get("filter_excluded_reason") is None
    )

premise_rows = [row for row in rows if eligible(row)]
target_rows = list(premise_rows)

premise_names = {
    row["declaration_name"]
    for row in premise_rows
}

sorted_premise_names = sorted(premise_names)
premise_id = {
    name: index
    for index, name in enumerate(sorted_premise_names)
}

premises_by_module = defaultdict(list)
premises_by_file = defaultdict(list)

for name in sorted_premise_names:
    row = by_name[name]
    premises_by_module[row["module_path"]].append(row)
    premises_by_file[row["file_path"]].append(row)

for items in premises_by_file.values():
    items.sort(
        key=lambda row: (
            row["line_start"],
            row["declaration_name"],
        )
    )

local_modules = set(premises_by_module)

def transitive_local_imports(module):
    visited = set()
    queue = deque(direct_imports.get(module, set()))

    while queue:
        current = queue.popleft()

        if current in visited:
            continue

        visited.add(current)

        for parent in direct_imports.get(current, set()):
            if parent not in visited:
                queue.append(parent)

    return visited & local_modules

import_closure = {
    module: transitive_local_imports(module)
    for module in {
        row["module_path"]
        for row in target_rows
    }
}

# モジュール単位で約80:10:10に分割する。
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

with catalog_path.open("w") as file:
    for name in sorted_premise_names:
        row = by_name[name]

        record = {
            "premise_id": premise_id[name],
            "declaration_name": name,
            "declaration_kind": (
                "theorem"
                if row["declaration_kind"] == "commandtheorem"
                else row["declaration_kind"]
            ),
            "namespace": row["namespace"],
            "module_path": row["module_path"],
            "file_path": row["file_path"],
            "line_start": row["line_start"],
            "line_end": row["line_end"],
            "statement": row["statement"],
            "source_commit": row["source_commit"],
        }

        file.write(
            json.dumps(record, ensure_ascii=False) + "\n"
        )

all_records = []
positive_records = []
coverage_failures = []

candidate_sizes = []
gold_sizes = []
split_counts_all = Counter()
split_counts_positive = Counter()
split_gold_counts = Counter()
gold_location_counts = Counter()

for target in sorted(
    target_rows,
    key=lambda row: (
        row["module_path"],
        row["line_start"],
        row["declaration_name"],
    ),
):
    target_name = target["declaration_name"]
    target_module = target["module_path"]
    target_file = target["file_path"]
    target_line = target["line_start"]

    candidate_names = set()

    # 同一ファイルでは、対象定理より前の補題だけを候補にする。
    for premise in premises_by_file[target_file]:
        if premise["line_start"] < target_line:
            candidate_names.add(premise["declaration_name"])

    # 推移的にimportされたPhyslibモジュールの補題を追加する。
    for imported_module in import_closure.get(target_module, set()):
        for premise in premises_by_module[imported_module]:
            candidate_names.add(premise["declaration_name"])

    candidate_names.discard(target_name)

    used = {
        value
        for value in (target.get("used_premises") or [])
        if isinstance(value, str) and value
    }

    raw_gold_names = used & premise_names
    raw_gold_names.discard(target_name)

    gold_names = raw_gold_names & candidate_names
    missing_gold = sorted(raw_gold_names - candidate_names)

    if missing_gold:
        coverage_failures.append({
            "target": target_name,
            "missing_gold": missing_gold,
        })

    local_gold = []
    imported_gold = []

    for name in sorted(gold_names):
        premise = by_name[name]

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
        "namespace": target["namespace"],
        "module_path": target_module,
        "file_path": target_file,
        "line_start": target_line,
        "line_end": target["line_end"],
        "statement": target["statement"],
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
        "source_commit": target["source_commit"],
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
        print(json.dumps(
            failure,
            ensure_ascii=False,
            indent=2,
        ))

    raise RuntimeError(
        f"{len(coverage_failures)} targets have unreachable gold premises"
    )

with all_targets_path.open("w") as file:
    for record in all_records:
        file.write(
            json.dumps(record, ensure_ascii=False) + "\n"
        )

with positive_targets_path.open("w") as file:
    for record in positive_records:
        file.write(
            json.dumps(record, ensure_ascii=False) + "\n"
        )

def percentile(values, fraction):
    values = sorted(values)

    if not values:
        return None

    index = round((len(values) - 1) * fraction)
    return values[index]

summary = {
    "benchmark_name": "Physlib Premise Selection v1",
    "source_commit": rows[0]["source_commit"],
    "candidate_definition": {
        "same_file": "eligible theorem/lemma declarations before the target",
        "imported_modules": "eligible theorem/lemma declarations in transitive Physlib imports",
        "target_excluded": True,
    },
    "gold_definition": (
        "used_premises intersect eligible Physlib theorem/lemma declarations"
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
    "split_counts_all": dict(sorted(split_counts_all.items())),
    "split_counts_positive": dict(
        sorted(split_counts_positive.items())
    ),
    "split_gold_counts": dict(sorted(split_gold_counts.items())),
    "module_counts_by_split": dict(sorted(Counter(
        module_split.values()
    ).items())),
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
}

summary_path.write_text(
    json.dumps(summary, ensure_ascii=False, indent=2) + "\n"
)

with preview_path.open("w") as file:
    for record in positive_records[:30]:
        statement = record["statement"].replace("\n", " ")

        file.write(
            f"TARGET {record['declaration_name']}\n"
            f"  split={record['split']} "
            f"module={record['module_path']}\n"
            f"  candidates={record['candidate_count']} "
            f"gold={record['gold_count']}\n"
            f"  gold_names={','.join(record['gold_premise_names'])}\n"
            f"  statement={statement[:300]}\n\n"
        )

print("=== Physlib Premise Selection v1 ===")
print(json.dumps(summary, ensure_ascii=False, indent=2))

print("\n=== outputs ===")
for path in [
    catalog_path,
    all_targets_path,
    positive_targets_path,
    summary_path,
    preview_path,
]:
    print(path)
