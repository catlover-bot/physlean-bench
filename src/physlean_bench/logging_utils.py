"""Logging configuration utilities."""

from __future__ import annotations

import logging
import logging.config
from pathlib import Path
from typing import Any

import yaml


def configure_logging(config_path: Path | None = None, default_level: int = logging.INFO) -> None:
    """Configure logging from YAML if available, otherwise fallback to basicConfig."""
    if config_path is None:
        logging.basicConfig(
            level=default_level,
            format="%(asctime)s | %(levelname)s | %(name)s | %(message)s",
        )
        return

    if not config_path.exists():
        logging.basicConfig(
            level=default_level,
            format="%(asctime)s | %(levelname)s | %(name)s | %(message)s",
        )
        logging.getLogger(__name__).warning(
            "Logging config not found at %s. Using basic logging.", config_path
        )
        return

    with config_path.open("r", encoding="utf-8") as handle:
        raw_config: dict[str, Any] = yaml.safe_load(handle) or {}

    logging.config.dictConfig(raw_config)
