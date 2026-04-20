#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p "${ROOT_DIR}/data/source"
mkdir -p "${ROOT_DIR}/outputs/traces"
mkdir -p "${ROOT_DIR}/outputs/datasets"
mkdir -p "${ROOT_DIR}/outputs/eval"
mkdir -p "${ROOT_DIR}/logs"

for cfg in physlib_source split_strategy deepseek_prover_v2 logging release_candidate; do
  src="${ROOT_DIR}/configs/${cfg}.example.yaml"
  dst="${ROOT_DIR}/configs/${cfg}.yaml"
  if [[ -f "${src}" && ! -f "${dst}" ]]; then
    cp "${src}" "${dst}"
    echo "Created ${dst}"
  fi
done

if [[ -f "${ROOT_DIR}/.env.example" && ! -f "${ROOT_DIR}/.env" ]]; then
  cp "${ROOT_DIR}/.env.example" "${ROOT_DIR}/.env"
  echo "Created ${ROOT_DIR}/.env"
fi

echo "Bootstrap complete. Review configs/ and .env before running heavy jobs."
