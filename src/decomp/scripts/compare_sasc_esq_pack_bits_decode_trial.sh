#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

bash src/decomp/scripts/compare_sasc_esq_packbits_decode_trial.sh "$@"
