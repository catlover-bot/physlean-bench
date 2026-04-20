"""Command line interface for physlean-bench workflows."""

from __future__ import annotations

import argparse
from datetime import datetime, timezone
import logging
import os
from pathlib import Path

from physlean_bench.dataset.extract_completion import make_completion_examples_subset
from physlean_bench.dataset.extract_retrieval import make_retrieval_examples
from physlean_bench.dataset.extract_tactic_steps import make_tactic_examples
from physlean_bench.dataset.manifests import build_manifest, write_manifest
from physlean_bench.dataset.release import package_release_candidate
from physlean_bench.dataset.split import (
    SplitConfig,
    generate_split_assignments,
    summarize_split_assignments,
)
from physlean_bench.dataset.stats import summarize_completion_examples, summarize_theorem_inventory
from physlean_bench.eval.deepseek_prover_v2 import DeepSeekProverV2Adapter, DeepSeekProverV2Config
from physlean_bench.eval.error_analysis import collect_failure_cases, summarize_failure_types
from physlean_bench.eval.prompt_builder import PromptConfig
from physlean_bench.eval.runner import RunnerConfig, run_completion_evaluation
from physlean_bench.eval.verifier import VerificationConfig
from physlean_bench.logging_utils import configure_logging
from physlean_bench.paths import ProjectPaths
from physlean_bench.reports.audit_completion import (
    AuditSampleConfig,
    build_audit_sample,
    build_traced_vs_source_scan_comparison,
    load_completion_examples,
    load_inventory_excluded,
    summarize_excluded_by_reason,
    write_audit_sample_artifacts,
    write_comparison_markdown,
)
from physlean_bench.reports.make_failure_report import make_failure_report
from physlean_bench.reports.make_tables import make_metrics_table
from physlean_bench.schemas import (
    CompletionExample,
    SourceRepoInfo,
    TracedTheoremInfo,
    read_jsonl,
    write_jsonl,
)
from physlean_bench.source.build_physlib import run_physlib_build
from physlean_bench.source.clone_physlib import prepare_source_repo
from physlean_bench.source.pin_commit import pin_or_read_commit
from physlean_bench.tracing.load_traced_repo import load_trace_metadata, load_traced_theorems
from physlean_bench.tracing.theorem_inventory import (
    create_inventory,
    create_inventory_with_decisions,
    save_inventory,
    assert_traced_only,
    write_inventory_summary_markdown,
)
from physlean_bench.tracing.trace_validation import (
    validate_trace_artifacts,
    write_trace_validation_artifacts,
)
from physlean_bench.tracing.trace_repo import TraceConfig, trace_source_repo
from physlean_bench.utils.io import read_json, read_yaml, write_json

logger = logging.getLogger(__name__)


def _parse_k_list(value: str) -> list[int]:
    return [int(item.strip()) for item in value.split(",") if item.strip()]


def _parse_csv_list(value: str | None) -> list[str]:
    if value is None:
        return []
    return [item.strip() for item in value.split(",") if item.strip()]


def _write_completion_summary_markdown(path: Path, stats: dict[str, object]) -> None:
    lines = [
        "# Completion Dataset Summary",
        "",
        f"- num_examples: `{stats.get('num_examples', 0)}`",
        f"- avg_accessible_premises: `{stats.get('avg_accessible_premises', 0)}`",
        f"- avg_used_premises: `{stats.get('avg_used_premises', 0)}`",
        f"- num_with_used_premises: `{stats.get('num_with_used_premises', 0)}`",
        "",
        "## Top Namespaces",
        "",
    ]
    for namespace, count in stats.get("top_namespaces", []):
        lines.append(f"- `{namespace}`: `{count}`")

    quality_flags = stats.get("quality_flag_counts", {})
    if isinstance(quality_flags, dict) and quality_flags:
        lines.extend(["", "## Quality Flags", ""])
        for flag, count in sorted(quality_flags.items(), key=lambda item: (-int(item[1]), str(item[0]))):
            lines.append(f"- `{flag}`: `{count}`")

    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def _source_info_from_trace_metadata(
    trace_metadata_json: Path | None,
    fallback_source_url: str,
    fallback_source_commit: str,
    fallback_source_clone_path: Path,
    fallback_tracing_tool: str,
    fallback_tracing_tool_version: str,
    fallback_lean_toolchain: str | None,
) -> tuple[str, str, Path, str, str, str | None]:
    if trace_metadata_json is None:
        return (
            fallback_source_url,
            fallback_source_commit,
            fallback_source_clone_path,
            fallback_tracing_tool,
            fallback_tracing_tool_version,
            fallback_lean_toolchain,
        )

    trace_meta = load_trace_metadata(trace_metadata_json)
    source_url = str(trace_meta.get("source_url", fallback_source_url))
    source_commit = str(trace_meta.get("source_commit", fallback_source_commit))
    source_clone_path = Path(str(trace_meta.get("repo_dir", fallback_source_clone_path)))
    tracing_tool = str(trace_meta.get("tracing_tool", fallback_tracing_tool))
    tracing_tool_version = str(trace_meta.get("tracing_tool_version", fallback_tracing_tool_version))
    lean_toolchain = trace_meta.get("lean_toolchain", fallback_lean_toolchain)
    return (
        source_url,
        source_commit,
        source_clone_path,
        tracing_tool,
        tracing_tool_version,
        str(lean_toolchain) if lean_toolchain is not None else None,
    )


def _write_dataset_manifest(
    *,
    task_family: str,
    output_jsonl: Path,
    source_url: str,
    source_commit: str,
    source_clone_path: Path,
    tracing_tool_name: str,
    tracing_tool_version: str,
    lean_toolchain: str | None,
    generation_config: dict[str, object],
    benchmark_name: str,
    manifest_path: Path | None,
    config_files: list[Path],
    extra_artifacts: list[Path],
) -> Path:
    source_info = SourceRepoInfo(
        name="leanprover-community/physlib",
        url=source_url,
        commit=source_commit,
        clone_path=source_clone_path,
        tracing_tool=tracing_tool_name,
        tracing_tool_version=tracing_tool_version,
        lean_toolchain=lean_toolchain,
        build_command=["lake", "exe", "cache", "get", "&&", "lake", "build", "PhysLean"],
        generation_timestamp_utc=datetime.now(timezone.utc).isoformat(),
    )
    artifacts = [output_jsonl] + [path for path in extra_artifacts if path.exists()]
    manifest = build_manifest(
        benchmark_name=benchmark_name,
        task_family=task_family,
        source_repo=source_info,
        generation_config=generation_config,
        artifact_paths=artifacts,
        config_paths=[path for path in config_files if path.exists()],
    )
    out = manifest_path or (output_jsonl.parent / "manifest.json")
    write_manifest(manifest, out)
    return out


def _command_clone_source(args: argparse.Namespace) -> int:
    status = prepare_source_repo(
        url=args.url,
        destination=args.destination,
        depth=args.depth,
        include_submodules=args.with_submodules,
        reuse_if_exists=not args.no_reuse,
        fetch_if_exists=not args.no_fetch,
    )

    pinned_commit = status.head_commit
    if args.commit:
        pin_result = pin_or_read_commit(
            status.repo_dir,
            args.commit,
            allow_dirty=args.allow_dirty,
            fetch_if_missing=True,
        )
        pinned_commit = pin_result.resolved_commit

    payload = {
        "repo_dir": str(status.repo_dir),
        "remote_url": status.remote_url,
        "head_commit_before_pin": status.head_commit,
        "head_commit": pinned_commit,
        "reused_existing_checkout": status.reused_existing_checkout,
        "is_dirty": status.is_dirty,
        "dirty_files": status.dirty_files,
        "generated_at_utc": datetime.now(timezone.utc).isoformat(),
    }
    if args.output_json:
        write_json(args.output_json, payload)

    logger.info("Source ready at %s (commit=%s)", status.repo_dir, pinned_commit)
    return 0


def _command_build_source(args: argparse.Namespace) -> int:
    result = run_physlib_build(
        repo_dir=args.repo_dir,
        artifacts_root=args.artifacts_dir,
        target=args.target,
        run_cache_get=not args.skip_cache_get,
        timeout_seconds=args.timeout_seconds,
        dry_run=args.dry_run,
        lake_binary=args.lake_binary,
    )
    logger.info("Build success=%s artifacts=%s", result.success, result.artifacts_dir)
    return 0


def _command_pin_commit(args: argparse.Namespace) -> int:
    result = pin_or_read_commit(
        args.repo_dir,
        args.commit,
        allow_dirty=args.allow_dirty,
        fetch_if_missing=not args.no_fetch,
    )
    payload = {
        "repo_dir": str(result.repo_dir),
        "requested_commit": result.requested_commit,
        "resolved_commit": result.resolved_commit,
        "working_tree_dirty": result.working_tree_dirty,
        "dirty_files": result.dirty_files,
        "checkout_performed": result.checkout_performed,
        "timestamp_utc": datetime.now(timezone.utc).isoformat(),
    }
    if args.output_json:
        write_json(args.output_json, payload)
    logger.info("Pinned/observed commit: %s", result.resolved_commit)
    return 0


def _command_trace_source(args: argparse.Namespace) -> int:
    config = TraceConfig(
        repo_dir=args.repo_dir,
        output_dir=args.output_dir,
        traced_jsonl_path=args.output_jsonl,
        backend=args.backend,
        tracing_tool="leandojo-v2",
        tracing_tool_version=args.tracing_tool_version,
        build_deps=args.build_deps,
        include_prefixes=_parse_csv_list(args.include_prefixes),
        exclude_prefixes=_parse_csv_list(args.exclude_prefixes),
        cache_dir=args.cache_dir,
        tmp_dir=args.tmp_dir,
        lake_binary=args.lake_binary,
        source_url=args.source_url,
        expected_source_commit=args.expected_source_commit,
        skip_preflight=args.skip_preflight,
        min_free_disk_gb=args.min_free_disk_gb,
        fail_on_preflight_error=not args.allow_preflight_fail,
        resume_if_outputs_exist=not args.no_resume,
    )
    result = trace_source_repo(config)

    logger.info("Tracing completed with %d theorem records", result.theorem_count)
    logger.info("Traced theorem JSONL: %s", result.traced_jsonl_path)
    logger.info("Trace summary markdown: %s", result.summary_md_path)
    if result.preflight_json_path is not None:
        logger.info("Trace preflight JSON: %s", result.preflight_json_path)
    return 0


def _command_inventory(args: argparse.Namespace) -> int:
    traced = load_traced_theorems(args.input_traced_jsonl)

    if args.traced_only:
        assert_traced_only(traced, required_backend="leandojo_v2")
        if args.trace_metadata_json:
            trace_meta = load_trace_metadata(args.trace_metadata_json)
            backend = str(trace_meta.get("trace_backend", ""))
            if backend != "leandojo_v2":
                raise RuntimeError(
                    "Traced-only inventory mode requires trace metadata backend `leandojo_v2`, "
                    f"but got `{backend}` from {args.trace_metadata_json}."
                )

    if args.no_filter:
        inventory, summary = create_inventory(traced, apply_filter=False)
        excluded: list[TracedTheoremInfo] = []
    else:
        inventory, excluded, summary = create_inventory_with_decisions(traced)

    save_inventory(inventory, args.output_inventory_jsonl)

    excluded_path = args.output_excluded_jsonl
    if excluded_path is None:
        excluded_path = args.output_inventory_jsonl.with_name(
            args.output_inventory_jsonl.stem + ".excluded.jsonl"
        )
    if excluded:
        write_jsonl(excluded_path, excluded)

    inventory_stats = summarize_theorem_inventory(inventory)
    if args.summary_json:
        summary_payload = {**summary, "inventory_stats": inventory_stats}
        write_json(args.summary_json, summary_payload)

    if args.summary_markdown:
        write_inventory_summary_markdown(args.summary_markdown, summary)

    logger.info("Inventory kept=%d excluded=%d", len(inventory), len(excluded))
    logger.info("Inventory JSONL: %s", args.output_inventory_jsonl)
    if excluded:
        logger.info("Excluded JSONL: %s", excluded_path)
    return 0


def _command_make_completion(args: argparse.Namespace) -> int:
    theorems = read_jsonl(args.inventory_jsonl, TracedTheoremInfo)
    if args.traced_only:
        assert_traced_only(theorems, required_backend="leandojo_v2")

    examples = make_completion_examples_subset(
        theorems,
        max_examples=args.max_examples,
        seed=args.seed,
    )  # type: ignore[arg-type]
    write_jsonl(args.output_jsonl, examples)

    stats = summarize_completion_examples(examples)
    summary_json = args.summary_json or args.output_jsonl.with_name(args.output_jsonl.stem + ".stats.json")
    write_json(summary_json, stats)

    if args.summary_markdown:
        _write_completion_summary_markdown(args.summary_markdown, stats)

    (
        source_url,
        source_commit,
        source_clone_path,
        tracing_tool_name,
        tracing_tool_version,
        lean_toolchain,
    ) = _source_info_from_trace_metadata(
        args.trace_metadata_json,
        args.source_url,
        args.source_commit,
        args.source_clone_path,
        "leandojo-v2",
        args.tracing_tool_version,
        args.lean_toolchain,
    )

    manifest_path = _write_dataset_manifest(
        task_family="theorem_completion",
        output_jsonl=args.output_jsonl,
        source_url=source_url,
        source_commit=source_commit,
        source_clone_path=source_clone_path,
        tracing_tool_name=tracing_tool_name,
        tracing_tool_version=tracing_tool_version,
        lean_toolchain=lean_toolchain,
        generation_config={
            "num_examples": len(examples),
            "max_examples": args.max_examples,
            "seed": args.seed,
            "inventory_jsonl": str(args.inventory_jsonl),
            "task_family": "theorem_completion",
            "traced_only": args.traced_only,
            "trace_backend_counts": {
                key: sum(1 for item in theorems if (item.trace_backend or "unknown") == key)
                for key in sorted({item.trace_backend or "unknown" for item in theorems})
            },
        },
        benchmark_name=args.benchmark_name,
        manifest_path=args.manifest_json,
        config_files=args.config_files,
        extra_artifacts=[summary_json, args.summary_markdown] if args.summary_markdown else [summary_json],
    )

    logger.info("Wrote %d completion examples to %s", len(examples), args.output_jsonl)
    logger.info("Completion stats JSON: %s", summary_json)
    logger.info("Manifest: %s", manifest_path)
    return 0


def _command_make_tactic(args: argparse.Namespace) -> int:
    theorems = read_jsonl(args.inventory_jsonl, TracedTheoremInfo)
    examples = make_tactic_examples(theorems)  # type: ignore[arg-type]
    write_jsonl(args.output_jsonl, examples)
    logger.info("Wrote %d tactic examples to %s", len(examples), args.output_jsonl)
    return 0


def _command_make_retrieval(args: argparse.Namespace) -> int:
    theorems = read_jsonl(args.inventory_jsonl, TracedTheoremInfo)
    examples = make_retrieval_examples(theorems)  # type: ignore[arg-type]
    write_jsonl(args.output_jsonl, examples)
    logger.info("Wrote %d retrieval examples to %s", len(examples), args.output_jsonl)
    return 0


def _command_make_splits(args: argparse.Namespace) -> int:
    theorems = read_jsonl(args.inventory_jsonl, TracedTheoremInfo)
    cfg = SplitConfig(
        strategy=args.strategy,
        seed=args.seed,
        train_fraction=args.train_fraction,
        valid_fraction=args.valid_fraction,
        test_fraction=args.test_fraction,
        namespace_depth=args.namespace_depth,
        profile=args.profile,
    )
    assignments = generate_split_assignments(theorems, cfg)  # type: ignore[arg-type]
    write_jsonl(args.output_jsonl, assignments)

    summary = summarize_split_assignments(assignments, theorems, cfg)  # type: ignore[arg-type]
    if args.summary_json:
        write_json(args.summary_json, summary)
    if args.summary_markdown:
        lines = [
            "# Split Summary",
            "",
            f"- strategy: `{summary.get('strategy')}`",
            f"- profile: `{summary.get('profile')}`",
            f"- seed: `{summary.get('seed')}`",
            f"- counts: `{summary.get('counts')}`",
            f"- missing_local_premise_records: `{summary.get('missing_local_premise_records')}`",
            "",
            "## Caveats",
            "",
        ]
        caveats = summary.get("caveats", [])
        if isinstance(caveats, list) and caveats:
            for item in caveats:
                lines.append(f"- {item}")
        else:
            lines.append("- none")
        args.summary_markdown.parent.mkdir(parents=True, exist_ok=True)
        args.summary_markdown.write_text("\n".join(lines) + "\n", encoding="utf-8")

    logger.info("Split assignment summary: %s", summary)
    return 0


def _command_eval(args: argparse.Namespace) -> int:
    config_payload = {}
    if args.config_yaml:
        config_payload = read_yaml(args.config_yaml)

    eval_cfg = config_payload.get("evaluation", {})
    model_cfg = config_payload.get("model", {})
    verify_cfg = config_payload.get("verification", {})

    dataset_raw = eval_cfg.get("input_dataset", args.dataset_jsonl)
    output_raw = eval_cfg.get("output_dir", args.output_dir)
    if dataset_raw is None:
        raise ValueError("dataset_jsonl is required via --dataset-jsonl or --config-yaml evaluation.input_dataset")
    if output_raw is None:
        raise ValueError("output_dir is required via --output-dir or --config-yaml evaluation.output_dir")
    dataset_jsonl = Path(dataset_raw)
    output_dir = Path(output_raw)

    examples = read_jsonl(dataset_jsonl, CompletionExample)
    ks_raw = eval_cfg.get("pass_at_k")
    ks = [int(item) for item in ks_raw] if isinstance(ks_raw, list) else _parse_k_list(args.ks)
    model_mode = str(model_cfg.get("mode", args.model_mode))
    model_name = str(model_cfg.get("model_name", args.model_name))
    endpoint = model_cfg.get("endpoint", args.endpoint)
    if isinstance(endpoint, str):
        endpoint = os.path.expandvars(endpoint)
    api_key_env = str(model_cfg.get("api_key_env", args.api_key_env))
    temperature = float(model_cfg.get("temperature", args.temperature))
    max_tokens = int(model_cfg.get("max_tokens", args.max_tokens))

    verify_enabled = bool(verify_cfg.get("enabled", args.verify))
    lean_check_cmd = list(verify_cfg.get("lean_check_cmd", args.lean_check_cmd))
    verify_timeout = int(verify_cfg.get("timeout_seconds", args.verify_timeout))
    run_id = args.run_id
    max_examples = eval_cfg.get("max_examples", args.max_examples)

    adapter = DeepSeekProverV2Adapter(
        DeepSeekProverV2Config(
            mode=model_mode,
            model_name=model_name,
            endpoint=endpoint,
            api_key_env=api_key_env,
        )
    )

    verification_config = None
    if verify_enabled:
        verification_config = VerificationConfig(
            source_repo_dir=args.source_repo_dir,
            work_dir=output_dir / "verification",
            lean_check_cmd=lean_check_cmd,
            timeout_seconds=verify_timeout,
            dry_run=args.verify_dry_run,
        )

    runner_cfg = RunnerConfig(
        run_id=run_id,
        ks=ks,
        output_dir=output_dir,
        verify_proofs=verify_enabled,
        prompt_config=PromptConfig(
            include_accessible_premises=not args.no_accessible_premises,
            max_premises=args.max_premises,
        ),
        verification_config=verification_config,
        max_examples=int(max_examples) if max_examples is not None else None,
    )

    results = run_completion_evaluation(
        examples=examples,  # type: ignore[arg-type]
        adapter=adapter,
        runner_config=runner_cfg,
        temperature=temperature,
        max_tokens=max_tokens,
    )

    failures = collect_failure_cases(results)
    write_jsonl(output_dir / "failure_cases.jsonl", failures)
    write_json(output_dir / "failure_summary.json", summarize_failure_types(failures))

    logger.info("Evaluation done. Results: %d, Failures: %d", len(results), len(failures))
    return 0


def _command_report(args: argparse.Namespace) -> int:
    make_metrics_table(args.metrics_json, args.output_metrics_md)
    logger.info("Wrote metrics markdown to %s", args.output_metrics_md)

    if args.failure_jsonl and args.output_failure_md:
        make_failure_report(args.failure_jsonl, args.output_failure_md, args.max_failure_cases)
        logger.info("Wrote failure markdown to %s", args.output_failure_md)
    return 0


def _command_validate_trace(args: argparse.Namespace) -> int:
    report = validate_trace_artifacts(
        traced_jsonl_path=args.traced_jsonl,
        metadata_path=args.trace_metadata_json,
        required_backend=args.required_backend,
        expected_source_url=args.expected_source_url,
        expected_source_commit=args.expected_source_commit,
        include_prefixes=_parse_csv_list(args.include_prefixes),
        exclude_prefixes=_parse_csv_list(args.exclude_prefixes),
        min_records=args.min_records,
    )
    write_trace_validation_artifacts(
        report,
        output_json=args.output_json,
        output_markdown=args.output_markdown,
    )
    logger.info("Trace validation written to %s and %s", args.output_json, args.output_markdown)
    if args.fail_on_error and not report.ok:
        return 2
    return 0


def _command_audit_completion(args: argparse.Namespace) -> int:
    examples = load_completion_examples(args.completion_jsonl)
    payload = build_audit_sample(
        examples,
        AuditSampleConfig(
            sample_size=args.sample_size,
            seed=args.seed,
            namespace_prefix=args.namespace_prefix,
            file_prefix=args.file_prefix,
            difficulty=args.difficulty,
            suspicious_only=args.suspicious_only,
        ),
    )

    if args.excluded_inventory_jsonl and args.excluded_inventory_jsonl.exists():
        excluded = load_inventory_excluded(args.excluded_inventory_jsonl)
        payload["excluded_summary"] = summarize_excluded_by_reason(excluded)

    write_audit_sample_artifacts(
        payload,
        output_json=args.output_json,
        output_markdown=args.output_markdown,
    )
    logger.info("Audit sample written to %s and %s", args.output_json, args.output_markdown)

    if args.compare_with_source_scan_jsonl:
        source_examples = load_completion_examples(args.compare_with_source_scan_jsonl)
        comparison = build_traced_vs_source_scan_comparison(examples, source_examples)
        write_json(args.comparison_json, comparison)
        write_comparison_markdown(comparison, args.comparison_markdown)
        logger.info(
            "Traced vs source-scan comparison written to %s and %s",
            args.comparison_json,
            args.comparison_markdown,
        )
    return 0


def _command_make_release(args: argparse.Namespace) -> int:
    if args.trace_metadata_json and args.trace_metadata_json.exists() and not args.allow_non_traced:
        trace_meta = read_json(args.trace_metadata_json)
        backend = str(trace_meta.get("trace_backend", ""))
        if backend != "leandojo_v2":
            raise RuntimeError(
                "Release packaging default requires traced backend `leandojo_v2`.\n"
                f"Observed backend: `{backend}` from {args.trace_metadata_json}\n"
                "Use --allow-non-traced only for non-authoritative dev packaging."
            )

    if args.trace_validation_json and args.trace_validation_json.exists():
        validation_payload = read_json(args.trace_validation_json)
        if not bool(validation_payload.get("ok", False)) and not args.allow_non_traced:
            raise RuntimeError(
                "Trace validation indicates errors; refusing to package authoritative release.\n"
                f"Validation file: {args.trace_validation_json}"
            )

    result = package_release_candidate(
        release_root=args.release_root,
        release_name=args.release_name,
        trace_files={
            "traced_jsonl": args.traced_jsonl,
            "metadata_json": args.trace_metadata_json,
            "stats_json": args.trace_stats_json,
            "validation_json": args.trace_validation_json,
            "validation_md": args.trace_validation_markdown,
        },
        inventory_files={
            "inventory_jsonl": args.inventory_jsonl,
            "inventory_excluded_jsonl": args.inventory_excluded_jsonl,
            "inventory_summary_json": args.inventory_summary_json,
            "inventory_summary_md": args.inventory_summary_markdown,
        },
        completion_files={
            "completion_jsonl": args.completion_jsonl,
            "completion_manifest_json": args.completion_manifest_json,
            "completion_stats_json": args.completion_stats_json,
            "completion_summary_md": args.completion_summary_markdown,
        },
        split_files={
            "split_assignments_jsonl": args.split_assignments_jsonl,
            "split_summary_json": args.split_summary_json,
            "split_summary_md": args.split_summary_markdown,
        },
        report_files={
            "audit_sample_json": args.audit_sample_json,
            "audit_sample_md": args.audit_sample_markdown,
            "comparison_traced_vs_source_scan_md": args.comparison_markdown,
            "comparison_traced_vs_source_scan_json": args.comparison_json,
        },
        config_paths=args.config_files,
    )
    logger.info("Release package generated at %s", result.release_dir)
    logger.info("Release manifest: %s", result.manifest_path)
    return 0


def _command_release_candidate_physlib(args: argparse.Namespace) -> int:
    run_root = args.work_dir / datetime.now(timezone.utc).strftime("run_%Y%m%dT%H%M%SZ")
    run_root.mkdir(parents=True, exist_ok=True)

    source_status = prepare_source_repo(
        url=args.source_url,
        destination=args.repo_dir,
        depth=args.clone_depth,
        include_submodules=False,
        reuse_if_exists=True,
        fetch_if_exists=not args.no_fetch,
    )
    pin_result = pin_or_read_commit(
        source_status.repo_dir,
        args.source_commit,
        allow_dirty=args.allow_dirty,
        fetch_if_missing=not args.no_fetch,
    )

    if not args.skip_build:
        run_physlib_build(
            repo_dir=args.repo_dir,
            artifacts_root=run_root / "build",
            target=args.build_target,
            run_cache_get=not args.skip_cache_get,
            timeout_seconds=args.build_timeout_seconds,
            dry_run=False,
            lake_binary=args.lake_binary,
        )

    trace_out_dir = run_root / "trace"
    trace_jsonl = trace_out_dir / "traced_theorems.jsonl"
    trace_result = trace_source_repo(
        TraceConfig(
            repo_dir=args.repo_dir,
            output_dir=trace_out_dir,
            traced_jsonl_path=trace_jsonl,
            backend="leandojo_v2",
            tracing_tool_version=args.tracing_tool_version,
            build_deps=args.trace_build_deps,
            include_prefixes=["PhysLean/", "Physlib/"],
            exclude_prefixes=["QuantumInfo/"],
            source_url=args.source_url,
            expected_source_commit=pin_result.resolved_commit,
            lake_binary=args.lake_binary,
            min_free_disk_gb=args.min_free_disk_gb,
            fail_on_preflight_error=True,
            resume_if_outputs_exist=not args.no_resume,
        )
    )

    validation_json = run_root / "trace" / "trace_validation.json"
    validation_md = run_root / "trace" / "trace_validation.md"
    validation_exit = _command_validate_trace(
        argparse.Namespace(
            traced_jsonl=trace_result.traced_jsonl_path,
            trace_metadata_json=trace_result.metadata_path,
            required_backend="leandojo_v2",
            expected_source_url=args.source_url,
            expected_source_commit=pin_result.resolved_commit,
            include_prefixes="PhysLean/,Physlib/",
            exclude_prefixes="QuantumInfo/",
            min_records=args.trace_min_records,
            output_json=validation_json,
            output_markdown=validation_md,
            fail_on_error=True,
        )
    )
    if validation_exit != 0:
        return validation_exit

    traced = load_traced_theorems(trace_result.traced_jsonl_path)
    assert_traced_only(traced)
    inventory, excluded, inv_summary = create_inventory_with_decisions(traced)

    inventory_jsonl = run_root / "inventory" / "inventory.jsonl"
    excluded_jsonl = run_root / "inventory" / "inventory.excluded.jsonl"
    inventory_summary_json = run_root / "inventory" / "inventory.summary.json"
    inventory_summary_md = run_root / "inventory" / "inventory.summary.md"
    save_inventory(inventory, inventory_jsonl)
    write_jsonl(excluded_jsonl, excluded)
    write_json(inventory_summary_json, {**inv_summary, "inventory_stats": summarize_theorem_inventory(inventory)})
    write_inventory_summary_markdown(inventory_summary_md, inv_summary)

    completion_jsonl = run_root / "completion" / "completion.release_candidate.jsonl"
    completion_stats_json = run_root / "completion" / "completion.release_candidate.stats.json"
    completion_summary_md = run_root / "completion" / "completion.release_candidate.summary.md"
    completion_manifest_json = run_root / "completion" / "manifest.json"

    completion = make_completion_examples_subset(inventory, max_examples=args.max_examples, seed=args.seed)
    write_jsonl(completion_jsonl, completion)
    completion_stats = summarize_completion_examples(completion)
    write_json(completion_stats_json, completion_stats)
    _write_completion_summary_markdown(completion_summary_md, completion_stats)
    trace_meta = read_json(trace_result.metadata_path)
    _write_dataset_manifest(
        task_family="theorem_completion",
        output_jsonl=completion_jsonl,
        source_url=args.source_url,
        source_commit=pin_result.resolved_commit,
        source_clone_path=args.repo_dir,
        tracing_tool_name=str(trace_meta.get("tracing_tool", "leandojo-v2")),
        tracing_tool_version=str(trace_meta.get("tracing_tool_version", "unknown")),
        lean_toolchain=str(trace_meta.get("lean_toolchain")) if trace_meta.get("lean_toolchain") else None,
        generation_config={
            "inventory_count": len(inventory),
            "excluded_count": len(excluded),
            "max_examples": args.max_examples,
            "seed": args.seed,
            "trace_backend": "leandojo_v2",
        },
        benchmark_name=args.benchmark_name,
        manifest_path=completion_manifest_json,
        config_files=args.config_files,
        extra_artifacts=[completion_stats_json, completion_summary_md, inventory_jsonl, inventory_summary_json],
    )

    split_jsonl = run_root / "splits" / "split_assignments.jsonl"
    split_summary_json = run_root / "splits" / "split_summary.json"
    split_summary_md = run_root / "splits" / "split_summary.md"
    _command_make_splits(
        argparse.Namespace(
            inventory_jsonl=inventory_jsonl,
            output_jsonl=split_jsonl,
            summary_json=split_summary_json,
            summary_markdown=split_summary_md,
            strategy=args.split_strategy,
            profile=args.split_profile,
            seed=args.seed,
            train_fraction=args.train_fraction,
            valid_fraction=args.valid_fraction,
            test_fraction=args.test_fraction,
            namespace_depth=args.namespace_depth,
        )
    )

    audit_json = run_root / "reports" / "audit_sample.json"
    audit_md = run_root / "reports" / "audit_sample.md"
    _command_audit_completion(
        argparse.Namespace(
            completion_jsonl=completion_jsonl,
            excluded_inventory_jsonl=excluded_jsonl,
            sample_size=args.audit_sample_size,
            seed=args.seed,
            namespace_prefix=None,
            file_prefix=None,
            difficulty=None,
            suspicious_only=False,
            output_json=audit_json,
            output_markdown=audit_md,
            compare_with_source_scan_jsonl=None,
            comparison_json=run_root / "reports" / "comparison_traced_vs_source_scan.json",
            comparison_markdown=run_root / "reports" / "comparison_traced_vs_source_scan.md",
        )
    )

    _command_make_release(
        argparse.Namespace(
            release_root=args.release_root,
            release_name=args.release_name,
            traced_jsonl=trace_result.traced_jsonl_path,
            trace_metadata_json=trace_result.metadata_path,
            trace_stats_json=trace_result.stats_path,
            trace_validation_json=validation_json,
            trace_validation_markdown=validation_md,
            inventory_jsonl=inventory_jsonl,
            inventory_excluded_jsonl=excluded_jsonl,
            inventory_summary_json=inventory_summary_json,
            inventory_summary_markdown=inventory_summary_md,
            completion_jsonl=completion_jsonl,
            completion_manifest_json=completion_manifest_json,
            completion_stats_json=completion_stats_json,
            completion_summary_markdown=completion_summary_md,
            split_assignments_jsonl=split_jsonl,
            split_summary_json=split_summary_json,
            split_summary_markdown=split_summary_md,
            audit_sample_json=audit_json,
            audit_sample_markdown=audit_md,
            comparison_json=run_root / "reports" / "comparison_traced_vs_source_scan.json",
            comparison_markdown=run_root / "reports" / "comparison_traced_vs_source_scan.md",
            config_files=args.config_files,
            allow_non_traced=False,
        )
    )

    write_json(
        run_root / "release_candidate_pipeline_summary.json",
        {
            "run_root": str(run_root),
            "source_commit": pin_result.resolved_commit,
            "trace_theorem_count": trace_result.theorem_count,
            "inventory_count": len(inventory),
            "completion_count": len(completion),
            "release_name": args.release_name,
            "release_root": str(args.release_root),
        },
    )
    logger.info("Release-candidate pipeline completed under %s", run_root)
    return 0


def _command_demo_physlib_small(args: argparse.Namespace) -> int:
    """Run a small real-data path from source checkout to completion subset."""
    run_dir = args.output_dir / datetime.now(timezone.utc).strftime("run_%Y%m%dT%H%M%SZ")
    run_dir.mkdir(parents=True, exist_ok=True)

    source_status = prepare_source_repo(
        url=args.source_url,
        destination=args.repo_dir,
        depth=args.clone_depth,
        include_submodules=False,
        reuse_if_exists=True,
        fetch_if_exists=True,
    )
    pin_result = pin_or_read_commit(
        source_status.repo_dir,
        args.source_commit,
        allow_dirty=args.allow_dirty,
        fetch_if_missing=True,
    )

    build_result = None
    if not args.skip_build:
        build_result = run_physlib_build(
            repo_dir=args.repo_dir,
            artifacts_root=run_dir / "build",
            target="PhysLean",
            run_cache_get=True,
            timeout_seconds=args.build_timeout_seconds,
            dry_run=False,
            lake_binary=args.lake_binary,
        )

    trace_result = trace_source_repo(
        TraceConfig(
            repo_dir=args.repo_dir,
            output_dir=run_dir / "trace",
            traced_jsonl_path=run_dir / "trace" / "traced_theorems.jsonl",
            backend=args.trace_backend,
            tracing_tool_version="auto",
            build_deps=args.trace_build_deps,
            include_prefixes=["PhysLean/", "Physlib/"],
            exclude_prefixes=["QuantumInfo/"],
            lake_binary=args.lake_binary,
            source_url=args.source_url,
            expected_source_commit=pin_result.resolved_commit,
            min_free_disk_gb=args.min_free_disk_gb,
            fail_on_preflight_error=not args.allow_preflight_fail,
        )
    )

    traced = load_traced_theorems(trace_result.traced_jsonl_path)
    inventory, excluded, inv_summary = create_inventory_with_decisions(traced)

    inventory_jsonl = run_dir / "inventory" / "inventory.jsonl"
    excluded_jsonl = run_dir / "inventory" / "inventory.excluded.jsonl"
    inv_summary_json = run_dir / "inventory" / "inventory.summary.json"
    inv_summary_md = run_dir / "inventory" / "inventory.summary.md"
    save_inventory(inventory, inventory_jsonl)
    write_jsonl(excluded_jsonl, excluded)
    write_json(inv_summary_json, {**inv_summary, "inventory_stats": summarize_theorem_inventory(inventory)})
    write_inventory_summary_markdown(inv_summary_md, inv_summary)

    completion_jsonl = run_dir / "completion" / "completion.small.jsonl"
    completion_stats_json = run_dir / "completion" / "completion.small.stats.json"
    completion_stats_md = run_dir / "completion" / "completion.small.summary.md"
    examples = make_completion_examples_subset(inventory, max_examples=args.max_examples, seed=args.seed)
    write_jsonl(completion_jsonl, examples)
    completion_stats = summarize_completion_examples(examples)
    write_json(completion_stats_json, completion_stats)
    _write_completion_summary_markdown(completion_stats_md, completion_stats)

    trace_meta = read_json(trace_result.metadata_path)
    manifest_path = _write_dataset_manifest(
        task_family="theorem_completion",
        output_jsonl=completion_jsonl,
        source_url=args.source_url,
        source_commit=str(trace_meta.get("source_commit", pin_result.resolved_commit)),
        source_clone_path=args.repo_dir,
        tracing_tool_name=str(trace_meta.get("tracing_tool", "leandojo-v2")),
        tracing_tool_version=str(trace_meta.get("tracing_tool_version", "unknown")),
        lean_toolchain=str(trace_meta.get("lean_toolchain")) if trace_meta.get("lean_toolchain") else None,
        generation_config={
            "run_dir": str(run_dir),
            "max_examples": args.max_examples,
            "seed": args.seed,
            "inventory_count": len(inventory),
            "excluded_count": len(excluded),
        },
        benchmark_name=args.benchmark_name,
        manifest_path=run_dir / "completion" / "manifest.json",
        config_files=[],
        extra_artifacts=[completion_stats_json, completion_stats_md, inventory_jsonl, inv_summary_json],
    )

    pipeline_summary = {
        "run_dir": str(run_dir),
        "repo_dir": str(args.repo_dir),
        "source_commit": pin_result.resolved_commit,
        "build_artifacts_dir": str(build_result.artifacts_dir) if build_result else None,
        "trace_jsonl": str(trace_result.traced_jsonl_path),
        "inventory_jsonl": str(inventory_jsonl),
        "completion_jsonl": str(completion_jsonl),
        "manifest_json": str(manifest_path),
        "trace_backend": args.trace_backend,
        "counts": {
            "traced": trace_result.theorem_count,
            "inventory": len(inventory),
            "excluded": len(excluded),
            "completion_examples": len(examples),
        },
    }
    write_json(run_dir / "pipeline_summary.json", pipeline_summary)

    logger.info("Demo pipeline completed. Run directory: %s", run_dir)
    logger.info("Completion dataset: %s", completion_jsonl)
    return 0


def build_parser() -> argparse.ArgumentParser:
    paths = ProjectPaths.from_env()
    parser = argparse.ArgumentParser(description="physlean-bench CLI")
    parser.add_argument(
        "--logging-config",
        type=Path,
        default=paths.configs_dir / "logging.example.yaml",
        help="Path to logging YAML config.",
    )

    subparsers = parser.add_subparsers(dest="command", required=True)

    clone_parser = subparsers.add_parser("clone-source", help="Clone/reuse physlib source repository and optionally pin commit.")
    clone_parser.add_argument("--url", type=str, default="https://github.com/leanprover-community/physlib.git")
    clone_parser.add_argument("--destination", type=Path, default=paths.data_dir / "source" / "physlib")
    clone_parser.add_argument("--depth", type=int, default=None)
    clone_parser.add_argument("--with-submodules", action="store_true")
    clone_parser.add_argument("--no-reuse", action="store_true", help="Fail if destination already exists.")
    clone_parser.add_argument("--no-fetch", action="store_true", help="Do not fetch origin when reusing checkout.")
    clone_parser.add_argument("--commit", type=str, default=None, help="Optional commit hash/tag/ref to pin immediately.")
    clone_parser.add_argument("--allow-dirty", action="store_true")
    clone_parser.add_argument("--output-json", type=Path, default=None)
    clone_parser.set_defaults(func=_command_clone_source)

    pin_parser = subparsers.add_parser("pin-commit", help="Pin source repo to specific commit with dirty-tree checks.")
    pin_parser.add_argument("--repo-dir", type=Path, required=True)
    pin_parser.add_argument("--commit", type=str, default=None)
    pin_parser.add_argument("--allow-dirty", action="store_true")
    pin_parser.add_argument("--no-fetch", action="store_true")
    pin_parser.add_argument("--output-json", type=Path, default=None)
    pin_parser.set_defaults(func=_command_pin_commit)

    build_parser_cmd = subparsers.add_parser("build-source", help="Run Physlib-focused build (`lake exe cache get` + `lake build PhysLean`).")
    build_parser_cmd.add_argument("--repo-dir", type=Path, required=True)
    build_parser_cmd.add_argument("--artifacts-dir", type=Path, default=paths.output_dir / "build")
    build_parser_cmd.add_argument("--target", type=str, default="PhysLean")
    build_parser_cmd.add_argument("--skip-cache-get", action="store_true")
    build_parser_cmd.add_argument("--timeout-seconds", type=int, default=None)
    build_parser_cmd.add_argument("--dry-run", action="store_true")
    build_parser_cmd.add_argument("--lake-binary", type=Path, default=None)
    build_parser_cmd.set_defaults(func=_command_build_source)

    trace_parser = subparsers.add_parser("trace-source", help="Trace source repo with LeanDojo-v2 and emit theorem JSONL.")
    trace_parser.add_argument("--repo-dir", type=Path, required=True)
    trace_parser.add_argument("--output-dir", type=Path, default=paths.output_dir / "traces")
    trace_parser.add_argument(
        "--output-jsonl",
        type=Path,
        default=paths.output_dir / "traces" / "traced_theorems.jsonl",
    )
    trace_parser.add_argument("--source-url", type=str, default="https://github.com/leanprover-community/physlib.git")
    trace_parser.add_argument("--expected-source-commit", type=str, default=None)
    trace_parser.add_argument("--backend", type=str, default="leandojo_v2", choices=["leandojo_v2", "source_scan"])
    trace_parser.add_argument("--tracing-tool-version", type=str, default="auto")
    trace_parser.add_argument("--build-deps", action="store_true", help="Build/trace dependencies too.")
    trace_parser.add_argument("--include-prefixes", type=str, default="PhysLean/,Physlib/", help="Comma-separated file path prefixes to include.")
    trace_parser.add_argument("--exclude-prefixes", type=str, default="QuantumInfo/", help="Comma-separated file path prefixes to exclude.")
    trace_parser.add_argument("--cache-dir", type=Path, default=None)
    trace_parser.add_argument("--tmp-dir", type=Path, default=None)
    trace_parser.add_argument("--lake-binary", type=Path, default=None)
    trace_parser.add_argument("--skip-preflight", action="store_true")
    trace_parser.add_argument("--allow-preflight-fail", action="store_true")
    trace_parser.add_argument("--min-free-disk-gb", type=float, default=20.0)
    trace_parser.add_argument("--no-resume", action="store_true")
    trace_parser.set_defaults(func=_command_trace_source)

    inventory_parser = subparsers.add_parser("inventory", help="Build filtered theorem inventory from traced JSONL.")
    inventory_parser.add_argument("--input-traced-jsonl", type=Path, required=True)
    inventory_parser.add_argument("--output-inventory-jsonl", type=Path, required=True)
    inventory_parser.add_argument("--output-excluded-jsonl", type=Path, default=None)
    inventory_parser.add_argument("--summary-json", type=Path, default=None)
    inventory_parser.add_argument("--summary-markdown", type=Path, default=None)
    inventory_parser.add_argument("--no-filter", action="store_true")
    inventory_parser.add_argument("--traced-only", action="store_true")
    inventory_parser.add_argument("--trace-metadata-json", type=Path, default=None)
    inventory_parser.set_defaults(func=_command_inventory)

    completion_parser = subparsers.add_parser("make-completion", help="Create theorem-completion dataset JSONL from inventory.")
    completion_parser.add_argument("--inventory-jsonl", type=Path, required=True)
    completion_parser.add_argument("--output-jsonl", type=Path, required=True)
    completion_parser.add_argument("--max-examples", type=int, default=200)
    completion_parser.add_argument("--seed", type=int, default=1337)
    completion_parser.add_argument("--summary-json", type=Path, default=None)
    completion_parser.add_argument("--summary-markdown", type=Path, default=None)
    completion_parser.add_argument("--manifest-json", type=Path, default=None)
    completion_parser.add_argument("--benchmark-name", type=str, default="physlean_completion_v0")
    completion_parser.add_argument("--trace-metadata-json", type=Path, default=None)
    completion_parser.add_argument("--source-url", type=str, default="https://github.com/leanprover-community/physlib.git")
    completion_parser.add_argument("--source-commit", type=str, default="UNKNOWN")
    completion_parser.add_argument("--source-clone-path", type=Path, default=paths.data_dir / "source" / "physlib")
    completion_parser.add_argument("--tracing-tool-version", type=str, default="unknown")
    completion_parser.add_argument("--lean-toolchain", type=str, default=None)
    completion_parser.add_argument("--config-files", type=Path, nargs="*", default=[])
    completion_parser.add_argument("--traced-only", action="store_true")
    completion_parser.set_defaults(func=_command_make_completion)

    tactic_parser = subparsers.add_parser("make-tactic", help="Create tactic prediction dataset JSONL.")
    tactic_parser.add_argument("--inventory-jsonl", type=Path, required=True)
    tactic_parser.add_argument("--output-jsonl", type=Path, required=True)
    tactic_parser.set_defaults(func=_command_make_tactic)

    retrieval_parser = subparsers.add_parser("make-retrieval", help="Create retrieval dataset JSONL.")
    retrieval_parser.add_argument("--inventory-jsonl", type=Path, required=True)
    retrieval_parser.add_argument("--output-jsonl", type=Path, required=True)
    retrieval_parser.set_defaults(func=_command_make_retrieval)

    split_parser = subparsers.add_parser("make-splits", help="Create split assignments JSONL.")
    split_parser.add_argument("--inventory-jsonl", type=Path, required=True)
    split_parser.add_argument("--output-jsonl", type=Path, required=True)
    split_parser.add_argument("--summary-json", type=Path, default=None)
    split_parser.add_argument("--summary-markdown", type=Path, default=None)
    split_parser.add_argument("--strategy", type=str, default="namespace")
    split_parser.add_argument("--profile", type=str, default=None, choices=["small", "dev", "release_candidate"])
    split_parser.add_argument("--seed", type=int, default=1337)
    split_parser.add_argument("--train-fraction", type=float, default=0.8)
    split_parser.add_argument("--valid-fraction", type=float, default=0.1)
    split_parser.add_argument("--test-fraction", type=float, default=0.1)
    split_parser.add_argument("--namespace-depth", type=int, default=2)
    split_parser.set_defaults(func=_command_make_splits)

    eval_parser = subparsers.add_parser("eval", help="Run model evaluation for completion dataset.")
    eval_parser.add_argument("--dataset-jsonl", type=Path, default=None)
    eval_parser.add_argument("--output-dir", type=Path, default=None)
    eval_parser.add_argument("--config-yaml", type=Path, default=None)
    eval_parser.add_argument("--run-id", type=str, default="run_default")
    eval_parser.add_argument("--model-mode", type=str, default="stub")
    eval_parser.add_argument("--model-name", type=str, default="deepseek-prover-v2")
    eval_parser.add_argument("--endpoint", type=str, default=None)
    eval_parser.add_argument("--api-key-env", type=str, default="DEEPSEEK_PROVER_V2_API_KEY")
    eval_parser.add_argument("--ks", type=str, default="1,5")
    eval_parser.add_argument("--temperature", type=float, default=0.0)
    eval_parser.add_argument("--max-tokens", type=int, default=1024)
    eval_parser.add_argument("--max-examples", type=int, default=None)
    eval_parser.add_argument("--verify", action="store_true")
    eval_parser.add_argument(
        "--verify-dry-run",
        action=argparse.BooleanOptionalAction,
        default=True,
    )
    eval_parser.add_argument("--source-repo-dir", type=Path, default=paths.data_dir / "source" / "physlib")
    eval_parser.add_argument("--lean-check-cmd", nargs="+", default=["lake", "env", "lean"])
    eval_parser.add_argument("--verify-timeout", type=int, default=60)
    eval_parser.add_argument("--no-accessible-premises", action="store_true")
    eval_parser.add_argument("--max-premises", type=int, default=64)
    eval_parser.set_defaults(func=_command_eval)

    report_parser = subparsers.add_parser("report", help="Generate markdown reports from eval outputs.")
    report_parser.add_argument("--metrics-json", type=Path, required=True)
    report_parser.add_argument("--output-metrics-md", type=Path, required=True)
    report_parser.add_argument("--failure-jsonl", type=Path, default=None)
    report_parser.add_argument("--output-failure-md", type=Path, default=None)
    report_parser.add_argument("--max-failure-cases", type=int, default=50)
    report_parser.set_defaults(func=_command_report)

    validate_parser = subparsers.add_parser("validate-trace", help="Validate traced outputs/provenance for release candidacy.")
    validate_parser.add_argument("--traced-jsonl", type=Path, required=True)
    validate_parser.add_argument("--trace-metadata-json", type=Path, default=None)
    validate_parser.add_argument("--required-backend", type=str, default="leandojo_v2")
    validate_parser.add_argument("--expected-source-url", type=str, default=None)
    validate_parser.add_argument("--expected-source-commit", type=str, default=None)
    validate_parser.add_argument("--include-prefixes", type=str, default="PhysLean/,Physlib/")
    validate_parser.add_argument("--exclude-prefixes", type=str, default="QuantumInfo/")
    validate_parser.add_argument("--min-records", type=int, default=1)
    validate_parser.add_argument("--output-json", type=Path, required=True)
    validate_parser.add_argument("--output-markdown", type=Path, required=True)
    validate_parser.add_argument("--fail-on-error", action=argparse.BooleanOptionalAction, default=True)
    validate_parser.set_defaults(func=_command_validate_trace)

    audit_parser = subparsers.add_parser("audit-completion", help="Sample and export completion audit bundles.")
    audit_parser.add_argument("--completion-jsonl", type=Path, required=True)
    audit_parser.add_argument("--excluded-inventory-jsonl", type=Path, default=None)
    audit_parser.add_argument("--sample-size", type=int, default=40)
    audit_parser.add_argument("--seed", type=int, default=1337)
    audit_parser.add_argument("--namespace-prefix", type=str, default=None)
    audit_parser.add_argument("--file-prefix", type=str, default=None)
    audit_parser.add_argument("--difficulty", choices=["easy", "medium", "hard"], default=None)
    audit_parser.add_argument("--suspicious-only", action="store_true")
    audit_parser.add_argument("--output-json", type=Path, required=True)
    audit_parser.add_argument("--output-markdown", type=Path, required=True)
    audit_parser.add_argument("--compare-with-source-scan-jsonl", type=Path, default=None)
    audit_parser.add_argument("--comparison-json", type=Path, default=paths.output_dir / "comparison_traced_vs_source_scan.json")
    audit_parser.add_argument(
        "--comparison-markdown",
        type=Path,
        default=paths.output_dir / "comparison_traced_vs_source_scan.md",
    )
    audit_parser.set_defaults(func=_command_audit_completion)

    release_parser = subparsers.add_parser("make-release", help="Package traced benchmark artifacts into release layout.")
    release_parser.add_argument("--release-root", type=Path, default=paths.output_dir / "releases")
    release_parser.add_argument("--release-name", type=str, required=True)
    release_parser.add_argument("--traced-jsonl", type=Path, required=True)
    release_parser.add_argument("--trace-metadata-json", type=Path, required=True)
    release_parser.add_argument("--trace-stats-json", type=Path, default=None)
    release_parser.add_argument("--trace-validation-json", type=Path, default=None)
    release_parser.add_argument("--trace-validation-markdown", type=Path, default=None)
    release_parser.add_argument("--inventory-jsonl", type=Path, required=True)
    release_parser.add_argument("--inventory-excluded-jsonl", type=Path, default=None)
    release_parser.add_argument("--inventory-summary-json", type=Path, default=None)
    release_parser.add_argument("--inventory-summary-markdown", type=Path, default=None)
    release_parser.add_argument("--completion-jsonl", type=Path, required=True)
    release_parser.add_argument("--completion-manifest-json", type=Path, default=None)
    release_parser.add_argument("--completion-stats-json", type=Path, default=None)
    release_parser.add_argument("--completion-summary-markdown", type=Path, default=None)
    release_parser.add_argument("--split-assignments-jsonl", type=Path, default=None)
    release_parser.add_argument("--split-summary-json", type=Path, default=None)
    release_parser.add_argument("--split-summary-markdown", type=Path, default=None)
    release_parser.add_argument("--audit-sample-json", type=Path, default=None)
    release_parser.add_argument("--audit-sample-markdown", type=Path, default=None)
    release_parser.add_argument("--comparison-json", type=Path, default=None)
    release_parser.add_argument("--comparison-markdown", type=Path, default=None)
    release_parser.add_argument("--config-files", type=Path, nargs="*", default=[])
    release_parser.add_argument("--allow-non-traced", action="store_true")
    release_parser.set_defaults(func=_command_make_release)

    rc_parser = subparsers.add_parser(
        "release-candidate-physlib",
        help="Run staged traced-only Physlib release-candidate pipeline and package outputs.",
    )
    rc_parser.add_argument("--source-url", type=str, default="https://github.com/leanprover-community/physlib.git")
    rc_parser.add_argument("--source-commit", type=str, required=True)
    rc_parser.add_argument("--repo-dir", type=Path, default=paths.data_dir / "source" / "physlib")
    rc_parser.add_argument("--work-dir", type=Path, default=paths.output_dir / "release_candidate_work")
    rc_parser.add_argument("--release-root", type=Path, default=paths.output_dir / "releases")
    rc_parser.add_argument("--release-name", type=str, required=True)
    rc_parser.add_argument("--benchmark-name", type=str, default="physlean_completion_release_candidate")
    rc_parser.add_argument("--clone-depth", type=int, default=None)
    rc_parser.add_argument("--no-fetch", action="store_true")
    rc_parser.add_argument("--allow-dirty", action="store_true")
    rc_parser.add_argument("--skip-build", action="store_true")
    rc_parser.add_argument("--skip-cache-get", action="store_true")
    rc_parser.add_argument("--build-target", type=str, default="PhysLean")
    rc_parser.add_argument("--build-timeout-seconds", type=int, default=None)
    rc_parser.add_argument("--trace-build-deps", action="store_true")
    rc_parser.add_argument("--tracing-tool-version", type=str, default="auto")
    rc_parser.add_argument("--trace-min-records", type=int, default=1)
    rc_parser.add_argument("--min-free-disk-gb", type=float, default=20.0)
    rc_parser.add_argument("--no-resume", action="store_true")
    rc_parser.add_argument("--lake-binary", type=Path, default=None)
    rc_parser.add_argument("--max-examples", type=int, default=500)
    rc_parser.add_argument("--seed", type=int, default=1337)
    rc_parser.add_argument("--split-strategy", type=str, default="novel_local_premise")
    rc_parser.add_argument(
        "--split-profile",
        type=str,
        default="release_candidate",
        choices=["small", "dev", "release_candidate"],
    )
    rc_parser.add_argument("--train-fraction", type=float, default=0.8)
    rc_parser.add_argument("--valid-fraction", type=float, default=0.1)
    rc_parser.add_argument("--test-fraction", type=float, default=0.1)
    rc_parser.add_argument("--namespace-depth", type=int, default=3)
    rc_parser.add_argument("--audit-sample-size", type=int, default=60)
    rc_parser.add_argument("--config-files", type=Path, nargs="*", default=[])
    rc_parser.set_defaults(func=_command_release_candidate_physlib)

    demo_parser = subparsers.add_parser(
        "demo-physlib-small",
        help="Run a small real-data pipeline (clone/build/trace/inventory/completion).",
    )
    demo_parser.add_argument("--source-url", type=str, default="https://github.com/leanprover-community/physlib.git")
    demo_parser.add_argument("--source-commit", type=str, required=True)
    demo_parser.add_argument("--repo-dir", type=Path, default=paths.data_dir / "source" / "physlib")
    demo_parser.add_argument("--output-dir", type=Path, default=paths.output_dir / "demo_physlib_small")
    demo_parser.add_argument("--max-examples", type=int, default=50)
    demo_parser.add_argument("--seed", type=int, default=1337)
    demo_parser.add_argument("--clone-depth", type=int, default=None)
    demo_parser.add_argument("--allow-dirty", action="store_true")
    demo_parser.add_argument("--trace-build-deps", action="store_true")
    demo_parser.add_argument("--trace-backend", type=str, default="leandojo_v2", choices=["leandojo_v2", "source_scan"])
    demo_parser.add_argument("--skip-build", action="store_true")
    demo_parser.add_argument("--build-timeout-seconds", type=int, default=None)
    demo_parser.add_argument("--lake-binary", type=Path, default=None)
    demo_parser.add_argument("--min-free-disk-gb", type=float, default=0.5)
    demo_parser.add_argument("--allow-preflight-fail", action="store_true")
    demo_parser.add_argument("--benchmark-name", type=str, default="physlean_completion_small_demo")
    demo_parser.set_defaults(func=_command_demo_physlib_small)

    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()

    configure_logging(args.logging_config)

    command_func = getattr(args, "func", None)
    if command_func is None:
        parser.print_help()
        return 1

    return command_func(args)


if __name__ == "__main__":
    raise SystemExit(main())
