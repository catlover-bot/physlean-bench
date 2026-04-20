from __future__ import annotations

from physlean_bench.dataset.split import SplitConfig, generate_split_assignments, summarize_split_assignments
from physlean_bench.schemas import TracedTheoremInfo


def _mk_theorem(
    theorem_id: str,
    namespace: str,
    file_path: str,
    local_premises: list[str],
) -> TracedTheoremInfo:
    return TracedTheoremInfo(
        theorem_id=theorem_id,
        declaration_name=theorem_id,
        namespace=namespace,
        module_path=namespace,
        file_path=file_path,
        statement=f"theorem {theorem_id} : True",
        proof_text="by trivial",
        used_premises=local_premises,
        used_local_premises=local_premises,
    )


def test_namespace_split_groups_namespaces() -> None:
    theorems = [
        _mk_theorem("t1", "PhysLean.Electromagnetism.Maxwell", "A.lean", []),
        _mk_theorem("t2", "PhysLean.Electromagnetism.Gauge", "B.lean", []),
        _mk_theorem("t3", "PhysLean.Quantum.Hilbert", "C.lean", []),
    ]
    cfg = SplitConfig(strategy="namespace", seed=1, namespace_depth=2)
    assignments = generate_split_assignments(theorems, cfg)

    key_map = {item.example_id: item.group_key for item in assignments}
    assert key_map["t1"] == "PhysLean.Electromagnetism"
    assert key_map["t2"] == "PhysLean.Electromagnetism"
    assert key_map["t3"] == "PhysLean.Quantum"


def test_novel_local_premise_split_emits_test_items() -> None:
    theorems = [
        _mk_theorem("t1", "PhysLean.A", "A.lean", ["PhysLean.P1"]),
        _mk_theorem("t2", "PhysLean.B", "B.lean", ["PhysLean.P2"]),
        _mk_theorem("t3", "PhysLean.C", "C.lean", ["PhysLean.P3"]),
        _mk_theorem("t4", "PhysLean.D", "D.lean", ["PhysLean.P4"]),
    ]

    cfg = SplitConfig(
        strategy="novel_local_premise",
        seed=0,
        train_fraction=0.25,
        valid_fraction=0.25,
        test_fraction=0.5,
    )
    assignments = generate_split_assignments(theorems, cfg)

    split_counts = {"train": 0, "valid": 0, "test": 0}
    for item in assignments:
        split_counts[item.split] += 1

    assert split_counts["test"] >= 1
    assert sum(split_counts.values()) == len(theorems)


def test_split_summary_contains_counts_and_caveats() -> None:
    theorems = [
        _mk_theorem("t1", "PhysLean.A", "A.lean", []),
        _mk_theorem("t2", "PhysLean.B", "B.lean", []),
    ]
    cfg = SplitConfig(strategy="novel_local_premise", seed=0, profile="small")
    assignments = generate_split_assignments(theorems, cfg)
    summary = summarize_split_assignments(assignments, theorems, cfg)
    assert summary["num_assignments"] == len(theorems)
    assert "counts" in summary
