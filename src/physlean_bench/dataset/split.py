"""Leakage-aware split assignment logic for benchmark examples."""

from __future__ import annotations

from dataclasses import dataclass
import random
from typing import Any

from physlean_bench.schemas import SplitAssignment, TracedTheoremInfo


@dataclass
class SplitConfig:
    strategy: str
    seed: int = 1337
    train_fraction: float = 0.8
    valid_fraction: float = 0.1
    test_fraction: float = 0.1
    namespace_depth: int = 2
    profile: str | None = None

    def normalized(self) -> "SplitConfig":
        total = self.train_fraction + self.valid_fraction + self.test_fraction
        if total <= 0:
            raise ValueError("Split fractions must sum to positive value.")
        return SplitConfig(
            strategy=self.strategy,
            seed=self.seed,
            train_fraction=self.train_fraction / total,
            valid_fraction=self.valid_fraction / total,
            test_fraction=self.test_fraction / total,
            namespace_depth=self.namespace_depth,
            profile=self.profile,
        )

    def with_profile_defaults(self) -> "SplitConfig":
        if self.profile is None:
            return self
        profile = self.profile.lower()
        if profile == "small":
            return SplitConfig(
                strategy=self.strategy,
                seed=self.seed,
                train_fraction=0.7,
                valid_fraction=0.15,
                test_fraction=0.15,
                namespace_depth=2,
                profile=self.profile,
            )
        if profile == "dev":
            return SplitConfig(
                strategy=self.strategy,
                seed=self.seed,
                train_fraction=0.75,
                valid_fraction=0.1,
                test_fraction=0.15,
                namespace_depth=2,
                profile=self.profile,
            )
        if profile == "release_candidate":
            return SplitConfig(
                strategy=self.strategy,
                seed=self.seed,
                train_fraction=0.8,
                valid_fraction=0.1,
                test_fraction=0.1,
                namespace_depth=3,
                profile=self.profile,
            )
        raise ValueError(f"Unsupported split profile: {self.profile}")


def _target_counts(num_items: int, config: SplitConfig) -> tuple[int, int, int]:
    cfg = config.normalized()
    train_target = int(round(num_items * cfg.train_fraction))
    valid_target = int(round(num_items * cfg.valid_fraction))
    train_target = min(train_target, num_items)
    valid_target = min(valid_target, max(0, num_items - train_target))
    test_target = max(0, num_items - train_target - valid_target)
    return train_target, valid_target, test_target


def _finalize(
    split_map: dict[str, str],
    strategy: str,
    group_map: dict[str, str],
    seed: int,
) -> list[SplitAssignment]:
    return [
        SplitAssignment(
            example_id=example_id,
            split=split,
            strategy=strategy,
            group_key=group_map[example_id],
            random_seed=seed,
        )
        for example_id, split in split_map.items()
    ]


def _assign_by_groups(
    item_ids: list[str],
    group_keys: list[str],
    config: SplitConfig,
) -> list[SplitAssignment]:
    rng = random.Random(config.seed)
    id_to_group = dict(zip(item_ids, group_keys))

    grouped: dict[str, list[str]] = {}
    for item_id, group_key in zip(item_ids, group_keys):
        grouped.setdefault(group_key, []).append(item_id)

    groups = list(grouped.keys())
    rng.shuffle(groups)

    normalized_cfg = config.with_profile_defaults()
    train_target, valid_target, _test_target = _target_counts(len(item_ids), normalized_cfg)
    split_map: dict[str, str] = {}

    for group in groups:
        group_ids = grouped[group]
        current_train = sum(1 for value in split_map.values() if value == "train")
        current_valid = sum(1 for value in split_map.values() if value == "valid")

        if current_train + len(group_ids) <= train_target:
            split = "train"
        elif current_valid + len(group_ids) <= valid_target:
            split = "valid"
        else:
            split = "test"

        for item_id in group_ids:
            split_map[item_id] = split

    return _finalize(split_map, normalized_cfg.strategy, id_to_group, normalized_cfg.seed)


def random_split(theorems: list[TracedTheoremInfo], config: SplitConfig) -> list[SplitAssignment]:
    config = config.with_profile_defaults()
    ids = [theorem.theorem_id for theorem in theorems]
    rng = random.Random(config.seed)
    shuffled = list(ids)
    rng.shuffle(shuffled)

    train_target, valid_target, _test_target = _target_counts(len(shuffled), config)
    split_map: dict[str, str] = {}

    for idx, theorem_id in enumerate(shuffled):
        if idx < train_target:
            split = "train"
        elif idx < train_target + valid_target:
            split = "valid"
        else:
            split = "test"
        split_map[theorem_id] = split

    group_map = {theorem_id: theorem_id for theorem_id in ids}
    return _finalize(split_map, "random", group_map, config.seed)


def file_split(theorems: list[TracedTheoremInfo], config: SplitConfig) -> list[SplitAssignment]:
    config = config.with_profile_defaults()
    ids = [theorem.theorem_id for theorem in theorems]
    groups = [theorem.file_path for theorem in theorems]
    config = SplitConfig(**{**config.__dict__, "strategy": "file"})
    return _assign_by_groups(ids, groups, config)


def namespace_split(theorems: list[TracedTheoremInfo], config: SplitConfig) -> list[SplitAssignment]:
    config = config.with_profile_defaults()
    ids = [theorem.theorem_id for theorem in theorems]
    groups: list[str] = []
    for theorem in theorems:
        parts = theorem.namespace.split(".") if theorem.namespace else ["_global"]
        group = ".".join(parts[: config.namespace_depth])
        groups.append(group)
    config = SplitConfig(**{**config.__dict__, "strategy": "namespace"})
    return _assign_by_groups(ids, groups, config)


def novel_local_premise_split(theorems: list[TracedTheoremInfo], config: SplitConfig) -> list[SplitAssignment]:
    """Split by preferring unseen local premises in test.

    Heuristic algorithm:
    1. Seed train with shuffled items until train target reached.
    2. Place remaining items into test if they introduce local premise novelty vs train.
    3. Remaining items go to valid then train to satisfy size targets.
    """
    rng = random.Random(config.seed)
    config = config.with_profile_defaults()
    shuffled = list(theorems)
    rng.shuffle(shuffled)

    train_target, valid_target, test_target = _target_counts(len(shuffled), config)
    split_map: dict[str, str] = {}
    group_map: dict[str, str] = {}

    seen_train_local_premises: set[str] = set()

    for theorem in shuffled:
        if len([value for value in split_map.values() if value == "train"]) >= train_target:
            break
        split_map[theorem.theorem_id] = "train"
        group_map[theorem.theorem_id] = theorem.theorem_id
        seen_train_local_premises.update(_local_premises(theorem))

    remainder = [theorem for theorem in shuffled if theorem.theorem_id not in split_map]

    for theorem in remainder:
        current_test = sum(1 for value in split_map.values() if value == "test")
        novelty = set(_local_premises(theorem)) - seen_train_local_premises
        if novelty and current_test < test_target:
            split_map[theorem.theorem_id] = "test"
        else:
            current_valid = sum(1 for value in split_map.values() if value == "valid")
            if current_valid < valid_target:
                split_map[theorem.theorem_id] = "valid"
            else:
                split_map[theorem.theorem_id] = "train"
                seen_train_local_premises.update(_local_premises(theorem))
        group_map[theorem.theorem_id] = theorem.theorem_id

    return _finalize(split_map, "novel_local_premise", group_map, config.seed)


def generate_split_assignments(theorems: list[TracedTheoremInfo], config: SplitConfig) -> list[SplitAssignment]:
    strategy = config.strategy.lower()
    if strategy == "random":
        return random_split(theorems, config)
    if strategy == "file":
        return file_split(theorems, config)
    if strategy == "namespace":
        return namespace_split(theorems, config)
    if strategy in {"novel_local_premise", "novel-local-premise"}:
        return novel_local_premise_split(theorems, config)
    raise ValueError(f"Unsupported split strategy: {config.strategy}")


def summarize_split_assignments(
    assignments: list[SplitAssignment],
    theorems: list[TracedTheoremInfo],
    config: SplitConfig,
) -> dict[str, Any]:
    theorem_map = {item.theorem_id: item for item in theorems}

    counts = {"train": 0, "valid": 0, "test": 0}
    local_premise_counts = {"train": 0, "valid": 0, "test": 0}
    missing_local_premise_records = 0
    for assignment in assignments:
        counts[assignment.split] = counts.get(assignment.split, 0) + 1
        theorem = theorem_map.get(assignment.example_id)
        if theorem is None:
            continue
        local = _local_premises(theorem)
        if local:
            local_premise_counts[assignment.split] = local_premise_counts.get(assignment.split, 0) + 1
        else:
            missing_local_premise_records += 1

    caveats: list[str] = []
    if config.strategy in {"novel_local_premise", "novel-local-premise"} and missing_local_premise_records:
        caveats.append(
            "Some records do not have local premise data; novelty split used available premise fields only."
        )

    return {
        "strategy": config.strategy,
        "profile": config.profile,
        "seed": config.seed,
        "counts": counts,
        "num_assignments": len(assignments),
        "local_premise_record_counts_by_split": local_premise_counts,
        "missing_local_premise_records": missing_local_premise_records,
        "caveats": caveats,
    }


def _local_premises(theorem: TracedTheoremInfo) -> list[str]:
    if theorem.used_local_premises:
        return theorem.used_local_premises
    local_prefixes = ("PhysLean", "Physlib")
    return [
        premise
        for premise in theorem.used_premises
        if any(premise.startswith(prefix) for prefix in local_prefixes)
    ]
