"""Abstract model adapter interfaces for prover backends."""

from __future__ import annotations

from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from typing import Any


@dataclass
class GenerationRequest:
    prompt: str
    num_samples: int
    temperature: float = 0.0
    max_tokens: int = 1024
    stop_sequences: list[str] = field(default_factory=list)


@dataclass
class GenerationResponse:
    generations: list[str]
    raw_response: dict[str, Any] | None = None


class ModelAdapter(ABC):
    """Abstract base class for theorem-prover generation adapters."""

    @abstractmethod
    def generate(self, request: GenerationRequest) -> GenerationResponse:
        raise NotImplementedError
