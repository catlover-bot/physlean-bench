"""DeepSeek-Prover-V2 adapter scaffold.

This module defines adapter boundaries without assuming one serving stack.
"""

from __future__ import annotations

from dataclasses import dataclass
import os

from physlean_bench.eval.model_adapter import GenerationRequest, GenerationResponse, ModelAdapter


@dataclass
class DeepSeekProverV2Config:
    mode: str = "stub"
    model_name: str = "deepseek-prover-v2"
    endpoint: str | None = None
    api_key_env: str = "DEEPSEEK_PROVER_V2_API_KEY"


class DeepSeekProverV2Adapter(ModelAdapter):
    def __init__(self, config: DeepSeekProverV2Config):
        self.config = config

    def generate(self, request: GenerationRequest) -> GenerationResponse:
        mode = self.config.mode.lower()
        if mode == "stub":
            # Deterministic synthetic outputs for dry-run plumbing checks.
            return GenerationResponse(
                generations=[
                    "by\n  simp",
                    "by\n  aesop",
                    "by\n  exact?",
                ][: request.num_samples],
                raw_response={"mode": "stub", "model_name": self.config.model_name},
            )

        if mode == "http_api":
            api_key = os.getenv(self.config.api_key_env, "")
            raise NotImplementedError(
                "TODO: Implement HTTP API call for DeepSeek-Prover-V2. "
                f"Expected endpoint={self.config.endpoint!r}, api_key_present={bool(api_key)}"
            )

        if mode == "local_server":
            raise NotImplementedError(
                "TODO: Implement local inference server integration for DeepSeek-Prover-V2."
            )

        raise ValueError(f"Unsupported DeepSeek-Prover-V2 mode: {self.config.mode}")
