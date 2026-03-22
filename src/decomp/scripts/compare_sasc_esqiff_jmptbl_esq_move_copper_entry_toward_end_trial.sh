#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

exec bash src/decomp/scripts/compare_sasc_esqiff_jmptbl_esq_movecopperentrytowardend_trial.sh
