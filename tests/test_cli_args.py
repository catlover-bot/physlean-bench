from __future__ import annotations

from pathlib import Path

from physlean_bench.cli import build_parser


def test_trace_source_args_parse() -> None:
    parser = build_parser()
    args = parser.parse_args(
        [
            "trace-source",
            "--repo-dir",
            "/tmp/physlib",
            "--output-dir",
            "/tmp/trace",
            "--output-jsonl",
            "/tmp/trace/traced.jsonl",
            "--backend",
            "source_scan",
            "--include-prefixes",
            "Physlib/",
            "--exclude-prefixes",
            "QuantumInfo/",
        ]
    )

    assert args.command == "trace-source"
    assert args.repo_dir == Path("/tmp/physlib")
    assert args.output_jsonl == Path("/tmp/trace/traced.jsonl")
    assert args.backend == "source_scan"


def test_demo_command_args_parse() -> None:
    parser = build_parser()
    args = parser.parse_args(
        [
            "demo-physlib-small",
            "--source-commit",
            "abcdef0123456789abcdef0123456789abcdef01",
        ]
    )
    assert args.command == "demo-physlib-small"
    assert args.source_commit.startswith("abcdef")


def test_validate_trace_args_parse() -> None:
    parser = build_parser()
    args = parser.parse_args(
        [
            "validate-trace",
            "--traced-jsonl",
            "/tmp/trace/traced.jsonl",
            "--output-json",
            "/tmp/trace/trace_validation.json",
            "--output-markdown",
            "/tmp/trace/trace_validation.md",
        ]
    )
    assert args.command == "validate-trace"
    assert args.required_backend == "leandojo_v2"


def test_make_release_args_parse() -> None:
    parser = build_parser()
    args = parser.parse_args(
        [
            "make-release",
            "--release-name",
            "rc_test",
            "--traced-jsonl",
            "/tmp/trace/traced.jsonl",
            "--trace-metadata-json",
            "/tmp/trace/meta.json",
            "--inventory-jsonl",
            "/tmp/inventory.jsonl",
            "--completion-jsonl",
            "/tmp/completion.jsonl",
        ]
    )
    assert args.command == "make-release"
    assert args.release_name == "rc_test"


def test_release_candidate_helper_args_parse() -> None:
    parser = build_parser()
    args = parser.parse_args(
        [
            "release-candidate-physlib",
            "--source-commit",
            "abcdef0123456789abcdef0123456789abcdef01",
            "--release-name",
            "rc0",
        ]
    )
    assert args.command == "release-candidate-physlib"
    assert args.release_name == "rc0"
