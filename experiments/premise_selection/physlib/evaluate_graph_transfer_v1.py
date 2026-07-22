import json
import math
import re
import statistics
from collections import Counter, defaultdict, deque
from itertools import product
from pathlib import Path

root = Path("/project/nlp-work11") / Path.home().name
bench_dir = root / "theorem_generation/premise_selection_physlib_v0"

catalog_path = bench_dir / "physlib_premise_catalog_v1.jsonl"
targets_path = bench_dir / "physlib_premise_targets_positive_v1.jsonl"
import_graph_path = (
    root
    / "physlean_trace_rc13_week_8cpu"
    / "physlib_import_graph_v1.json"
)

output_path = bench_dir / "graph_transfer_results_v1.json"
preview_path = bench_dir / "graph_transfer_results_v1.txt"
predictions_path = bench_dir / "graph_transfer_predictions_test_v1.jsonl"

catalog = [
    json.loads(line)
    for line in catalog_path.read_text().splitlines()
    if line.strip()
]

targets = [
    json.loads(line)
    for line in targets_path.read_text().splitlines()
    if line.strip()
]

train_targets = [row for row in targets if row["split"] == "train"]
validation_targets = [
    row for row in targets if row["split"] == "validation"
]
test_targets = [row for row in targets if row["split"] == "test"]

catalog_by_id = {
    row["premise_id"]: row
    for row in catalog
}

import_graph = json.loads(import_graph_path.read_text())
direct_imports = {
    module: set(imports)
    for module, imports in import_graph["direct_imports"].items()
}

stopwords = {
    "theorem", "lemma", "by", "where", "let", "have", "show",
    "from", "fun", "forall", "exists", "true", "false", "and",
    "or", "not", "iff", "then", "else", "match", "with",
    "type", "prop", "sort", "self", "physlib", "variable",
    "namespace", "section", "open", "public", "private",
}

def tokenize(text):
    text = re.sub(r"([a-z])([A-Z])", r"\1 \2", text)

    parts = re.split(
        r"[^\wα-ωΑ-Ω₀-₉ℝℂℕβγδφψωτμνσλ']+",
        text,
        flags=re.UNICODE,
    )

    result = []

    for part in parts:
        for token in re.split(r"[_.'₀-₉]+", part):
            token = token.lower()

            if len(token) >= 2 and token not in stopwords:
                result.append(token)

    return result

def target_text(row):
    return row["declaration_name"] + " " + row["statement"]

def premise_text(row):
    return row["declaration_name"] + " " + row["statement"]

def namespace_prefix(name):
    parts = name.split(".")
    return ".".join(parts[:-1])

# ----------------------------------------------------------------------
# Premise BM25
# ----------------------------------------------------------------------

premise_tf = {}
premise_lengths = {}
premise_df = Counter()

for premise in catalog:
    pid = premise["premise_id"]
    counts = Counter(tokenize(premise_text(premise)))

    premise_tf[pid] = counts
    premise_lengths[pid] = sum(counts.values())

    for token in counts:
        premise_df[token] += 1

premise_count = len(catalog)
average_premise_length = statistics.mean(premise_lengths.values())

def bm25_score(query_tokens, premise_id):
    k1 = 1.5
    b = 0.75

    tf = premise_tf[premise_id]
    document_length = premise_lengths[premise_id]
    score = 0.0

    for token in set(query_tokens):
        frequency = tf.get(token, 0)

        if frequency == 0:
            continue

        df = premise_df[token]
        idf = math.log(
            1.0
            + (premise_count - df + 0.5) / (df + 0.5)
        )

        denominator = frequency + k1 * (
            1.0 - b
            + b * document_length / average_premise_length
        )

        score += idf * (
            frequency * (k1 + 1.0) / denominator
        )

    return score

# ----------------------------------------------------------------------
# Target TF-IDF vectors for nearest-theorem dependency transfer
# IDF is fitted only on train targets.
# ----------------------------------------------------------------------

train_target_tf = {}
target_df = Counter()

for target in train_targets:
    counts = Counter(tokenize(target_text(target)))
    train_target_tf[target["declaration_name"]] = counts

    for token in counts:
        target_df[token] += 1

train_count = len(train_targets)

def target_idf(token):
    return math.log(
        (train_count + 1.0) / (target_df.get(token, 0) + 1.0)
    ) + 1.0

def make_tfidf_vector(text):
    counts = Counter(tokenize(text))
    vector = {
        token: count * target_idf(token)
        for token, count in counts.items()
    }

    norm = math.sqrt(sum(value * value for value in vector.values()))

    if norm == 0:
        return {}

    return {
        token: value / norm
        for token, value in vector.items()
    }

train_vectors = {
    target["declaration_name"]: make_tfidf_vector(target_text(target))
    for target in train_targets
}

train_gold = {
    target["declaration_name"]: target["gold_premise_ids"]
    for target in train_targets
}

def cosine(left, right):
    if len(left) > len(right):
        left, right = right, left

    return sum(
        value * right.get(token, 0.0)
        for token, value in left.items()
    )

def dependency_transfer_scores(target, candidate_set, neighbor_k=32):
    query_vector = make_tfidf_vector(target_text(target))

    similarities = []

    for train_target in train_targets:
        name = train_target["declaration_name"]
        similarity = cosine(query_vector, train_vectors[name])

        if similarity > 0:
            similarities.append((similarity, name))

    similarities.sort(reverse=True)
    similarities = similarities[:neighbor_k]

    scores = defaultdict(float)
    neighbors = []

    for rank, (similarity, train_name) in enumerate(
        similarities,
        1,
    ):
        weight = similarity / math.log2(rank + 1.0)
        transferred = []

        for premise_id in train_gold[train_name]:
            if premise_id in candidate_set:
                scores[premise_id] += weight
                transferred.append(premise_id)

        neighbors.append({
            "rank": rank,
            "train_target": train_name,
            "similarity": similarity,
            "transferred_premise_ids": transferred,
        })

    return dict(scores), neighbors

# ----------------------------------------------------------------------
# Structural graph features
# ----------------------------------------------------------------------

distance_cache = {}

def module_distance(source, target):
    key = (source, target)

    if key in distance_cache:
        return distance_cache[key]

    if source == target:
        distance_cache[key] = 0
        return 0

    visited = {source}
    queue = deque([(source, 0)])

    while queue:
        current, distance = queue.popleft()

        for imported in direct_imports.get(current, set()):
            if imported == target:
                distance_cache[key] = distance + 1
                return distance + 1

            if imported not in visited:
                visited.add(imported)
                queue.append((imported, distance + 1))

    distance_cache[key] = None
    return None

def graph_score(target, premise):
    score = 0.0

    if premise["file_path"] == target["file_path"]:
        line_gap = max(
            1,
            target["line_start"] - premise["line_start"],
        )

        score += 3.0
        score += 1.0 / math.log2(line_gap + 2.0)
    else:
        distance = module_distance(
            target["module_path"],
            premise["module_path"],
        )

        if distance is not None and distance > 0:
            score += 2.0 / distance

    target_namespace = namespace_prefix(
        target["declaration_name"]
    )
    premise_namespace = namespace_prefix(
        premise["declaration_name"]
    )

    if target_namespace == premise_namespace:
        score += 1.5
    elif (
        target_namespace.startswith(premise_namespace)
        or premise_namespace.startswith(target_namespace)
    ):
        score += 0.75

    target_parts = target["module_path"].split(".")
    premise_parts = premise["module_path"].split(".")

    shared_prefix = 0

    for left, right in zip(target_parts, premise_parts):
        if left != right:
            break

        shared_prefix += 1

    score += 0.1 * shared_prefix
    return score

def name_jaccard(target, premise):
    left = set(tokenize(target["declaration_name"]))
    right = set(tokenize(premise["declaration_name"]))
    union = left | right

    return len(left & right) / len(union) if union else 0.0

def minmax(values):
    if not values:
        return {}

    minimum = min(values.values())
    maximum = max(values.values())

    if maximum == minimum:
        return {
            key: 0.0
            for key in values
        }

    return {
        key: (value - minimum) / (maximum - minimum)
        for key, value in values.items()
    }

# ----------------------------------------------------------------------
# Precompute four feature families for validation and test.
# ----------------------------------------------------------------------

def build_features(eval_targets):
    records = []

    for index, target in enumerate(eval_targets, 1):
        candidate_ids = target["candidate_premise_ids"]
        candidate_set = set(candidate_ids)
        query_tokens = tokenize(target_text(target))

        bm25 = {}
        graph = {}
        name = {}

        for premise_id in candidate_ids:
            premise = catalog_by_id[premise_id]

            bm25[premise_id] = bm25_score(
                query_tokens,
                premise_id,
            )
            graph[premise_id] = graph_score(target, premise)
            name[premise_id] = name_jaccard(target, premise)

        transfer, neighbors = dependency_transfer_scores(
            target,
            candidate_set,
        )

        transfer = {
            premise_id: transfer.get(premise_id, 0.0)
            for premise_id in candidate_ids
        }

        records.append({
            "target": target,
            "features": {
                "bm25": minmax(bm25),
                "graph": minmax(graph),
                "name": minmax(name),
                "transfer": minmax(transfer),
            },
            "neighbors": neighbors,
        })

        if index % 50 == 0:
            print(
                f"feature extraction "
                f"{index}/{len(eval_targets)}"
            )

    return records

print("=== validation features ===")
validation_features = build_features(validation_targets)

print("\n=== test features ===")
test_features = build_features(test_targets)

# ----------------------------------------------------------------------
# Evaluation
# ----------------------------------------------------------------------

KS = [1, 5, 10, 20, 50]
feature_names = ["bm25", "graph", "name", "transfer"]

def evaluate(feature_records, weights, save_predictions=False):
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

        local_names = set(target["gold_same_file_earlier"])
        imported_names = set(target["gold_imported_modules"])

        local_ids = {
            premise_id
            for premise_id in gold_ids
            if catalog_by_id[premise_id]["declaration_name"]
            in local_names
        }
        imported_ids = {
            premise_id
            for premise_id in gold_ids
            if catalog_by_id[premise_id]["declaration_name"]
            in imported_names
        }

        scores = {}

        for premise_id in candidate_ids:
            scores[premise_id] = sum(
                weights[name] * features[name][premise_id]
                for name in feature_names
            )

        ranking = sorted(
            candidate_ids,
            key=lambda premise_id: (
                scores[premise_id],
                catalog_by_id[premise_id]["declaration_name"],
            ),
            reverse=True,
        )

        gold_ranks = [
            rank
            for rank, premise_id in enumerate(ranking, 1)
            if premise_id in gold_ids
        ]

        reciprocal_rank_sum += 1.0 / min(gold_ranks)
        total_gold += len(gold_ids)
        local_gold_total += len(local_ids)
        imported_gold_total += len(imported_ids)

        for k in KS:
            topk = set(ranking[:k])
            count = len(gold_ids & topk)

            recovered[k] += count
            local_recovered[k] += len(local_ids & topk)
            imported_recovered[k] += len(imported_ids & topk)

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
            predictions.append({
                "declaration_name": target["declaration_name"],
                "module_path": target["module_path"],
                "gold_premise_names": target["gold_premise_names"],
                "top_50_premise_names": [
                    catalog_by_id[premise_id]["declaration_name"]
                    for premise_id in ranking[:50]
                ],
                "first_gold_rank": min(gold_ranks),
                "nearest_train_targets": record["neighbors"][:10],
            })

    target_count = len(feature_records)

    result = {
        "weights": weights,
        "MRR": reciprocal_rank_sum / target_count,
    }

    for k in KS:
        result[f"micro_recall@{k}"] = recovered[k] / total_gold
        result[f"hit_rate@{k}"] = hit_targets[k] / target_count
        result[f"nDCG@{k}"] = ndcg_sum[k] / target_count
        result[f"local_recall@{k}"] = (
            local_recovered[k] / local_gold_total
            if local_gold_total else None
        )
        result[f"imported_recall@{k}"] = (
            imported_recovered[k] / imported_gold_total
            if imported_gold_total else None
        )

    return result, predictions

# 0.25刻みで、4特徴の重みの総和を1にする。
weight_grid = []

for bm25_weight, graph_weight, name_weight, transfer_weight in product(
    range(5),
    repeat=4,
):
    if (
        bm25_weight
        + graph_weight
        + name_weight
        + transfer_weight
        != 4
    ):
        continue

    weight_grid.append({
        "bm25": bm25_weight / 4.0,
        "graph": graph_weight / 4.0,
        "name": name_weight / 4.0,
        "transfer": transfer_weight / 4.0,
    })

validation_results = []

for weights in weight_grid:
    result, _ = evaluate(validation_features, weights)
    validation_results.append(result)

best_overall = max(
    validation_results,
    key=lambda result: (
        result["micro_recall@20"],
        result["imported_recall@20"],
        result["MRR"],
    ),
)

best_imported = max(
    validation_results,
    key=lambda result: (
        result["imported_recall@20"],
        result["micro_recall@20"],
        result["MRR"],
    ),
)

feature_only_validation = {}
feature_only_test = {}

for feature_name in feature_names:
    weights = {
        name: 1.0 if name == feature_name else 0.0
        for name in feature_names
    }

    feature_only_validation[feature_name], _ = evaluate(
        validation_features,
        weights,
    )
    feature_only_test[feature_name], _ = evaluate(
        test_features,
        weights,
    )

test_overall, predictions = evaluate(
    test_features,
    best_overall["weights"],
    save_predictions=True,
)

test_imported, _ = evaluate(
    test_features,
    best_imported["weights"],
)

results = {
    "method": "Graph-guided nearest-theorem premise transfer v1",
    "train_positive_targets": len(train_targets),
    "validation_positive_targets": len(validation_targets),
    "test_positive_targets": len(test_targets),
    "neighbor_k": 32,
    "weight_grid_step": 0.25,
    "selection_policy": (
        "weights selected only on validation; test used once with fixed weights"
    ),
    "feature_only_validation": feature_only_validation,
    "feature_only_test": feature_only_test,
    "best_overall_validation": best_overall,
    "best_overall_test": test_overall,
    "best_imported_validation": best_imported,
    "best_imported_test": test_imported,
}

output_path.write_text(
    json.dumps(results, ensure_ascii=False, indent=2) + "\n"
)

with predictions_path.open("w") as file:
    for prediction in predictions:
        file.write(
            json.dumps(prediction, ensure_ascii=False) + "\n"
        )

with preview_path.open("w") as file:
    file.write(
        "Graph-guided nearest-theorem premise transfer v1\n"
    )
    file.write("=" * 78 + "\n\n")

    file.write("Feature-only test results\n")
    file.write("-" * 78 + "\n")

    for name in feature_names:
        result = feature_only_test[name]

        file.write(
            f"{name:12s} "
            f"MRR={result['MRR']:.4f} "
            f"R@5={result['micro_recall@5']:.4f} "
            f"R@10={result['micro_recall@10']:.4f} "
            f"R@20={result['micro_recall@20']:.4f} "
            f"R@50={result['micro_recall@50']:.4f} "
            f"imported@20={result['imported_recall@20']:.4f}\n"
        )

    file.write("\nBest overall validation weights\n")
    file.write("-" * 78 + "\n")
    file.write(
        json.dumps(
            best_overall["weights"],
            ensure_ascii=False,
        )
        + "\n"
    )

    file.write(
        f"validation: "
        f"MRR={best_overall['MRR']:.4f} "
        f"R@20={best_overall['micro_recall@20']:.4f} "
        f"imported@20={best_overall['imported_recall@20']:.4f}\n"
    )
    file.write(
        f"test:       "
        f"MRR={test_overall['MRR']:.4f} "
        f"R@5={test_overall['micro_recall@5']:.4f} "
        f"R@10={test_overall['micro_recall@10']:.4f} "
        f"R@20={test_overall['micro_recall@20']:.4f} "
        f"R@50={test_overall['micro_recall@50']:.4f} "
        f"local@20={test_overall['local_recall@20']:.4f} "
        f"imported@20={test_overall['imported_recall@20']:.4f}\n"
    )

    file.write("\nBest imported-recall validation weights\n")
    file.write("-" * 78 + "\n")
    file.write(
        json.dumps(
            best_imported["weights"],
            ensure_ascii=False,
        )
        + "\n"
    )

    file.write(
        f"validation: "
        f"MRR={best_imported['MRR']:.4f} "
        f"R@20={best_imported['micro_recall@20']:.4f} "
        f"imported@20={best_imported['imported_recall@20']:.4f}\n"
    )
    file.write(
        f"test:       "
        f"MRR={test_imported['MRR']:.4f} "
        f"R@5={test_imported['micro_recall@5']:.4f} "
        f"R@10={test_imported['micro_recall@10']:.4f} "
        f"R@20={test_imported['micro_recall@20']:.4f} "
        f"R@50={test_imported['micro_recall@50']:.4f} "
        f"local@20={test_imported['local_recall@20']:.4f} "
        f"imported@20={test_imported['imported_recall@20']:.4f}\n"
    )

print(preview_path.read_text())
print("saved:", output_path)
print("saved:", predictions_path)
print("saved:", preview_path)
