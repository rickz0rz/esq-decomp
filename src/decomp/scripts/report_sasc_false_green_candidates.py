#!/usr/bin/env python3
"""Report SAS/C compare lanes that are likely semantic-filter false greens.

This helper scans `build/decomp/sasc_trial/` for compare outputs whose
`.semantic.diff` is empty or tiny while the raw `.diff` remains large. It also
annotates each lane with whether the compare script appears to use a semantic
filter directly, delegates to another compare script, or has no obvious filter.
"""

from __future__ import annotations

import argparse
import re
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
DEFAULT_TRIAL_DIR = ROOT / "build" / "decomp" / "sasc_trial"
SCRIPTS_DIR = ROOT / "src" / "decomp" / "scripts"

COMPARE_RE = re.compile(r"^compare_sasc_(?P<base>.+)_trial\.sh$")
# Compare lanes commonly pass `-v` metadata before `-f semantic_filter...`.
# Match any single-line awk argument sequence that eventually names a filter.
DIRECT_FILTER_RE = re.compile(
    r"\bawk\b[^\n]*?\s-f\s+(src/decomp/scripts/semantic_filter[^\s\"']+)"
)
DELEGATE_RE = re.compile(r"bash\s+(src/decomp/scripts/compare_sasc_[^\s\"']+)")


@dataclass(frozen=True)
class LaneRow:
    base: str
    raw_bytes: int
    semantic_bytes: int
    filter_mode: str
    filter_path: str
    compare_script: str


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Report semantic-clean SAS/C compare lanes whose raw diffs are still "
            "large enough to merit filter or implementation review."
        )
    )
    parser.add_argument(
        "--trial-dir",
        type=Path,
        default=DEFAULT_TRIAL_DIR,
        help=f"compare artifact directory (default: {DEFAULT_TRIAL_DIR})",
    )
    parser.add_argument(
        "--min-raw-bytes",
        type=int,
        default=4096,
        help="minimum raw .diff size in bytes to report (default: 4096)",
    )
    parser.add_argument(
        "--max-semantic-bytes",
        type=int,
        default=0,
        help="maximum semantic .diff size in bytes to include (default: 0)",
    )
    parser.add_argument(
        "--limit",
        type=int,
        default=40,
        help="maximum number of rows to print (default: 40)",
    )
    parser.add_argument(
        "--filter",
        dest="substring",
        help="only include bases containing this substring",
    )
    parser.add_argument(
        "--only-direct-filter",
        action="store_true",
        help="only include rows whose compare script uses a semantic filter directly",
    )
    parser.add_argument(
        "--only-no-filter",
        action="store_true",
        help="only include rows with no obvious direct filter or delegation",
    )
    return parser.parse_args()


def load_script_metadata(script_path: Path) -> tuple[str, str]:
    try:
        text = script_path.read_text(errors="ignore")
    except OSError:
        return ("missing", "-")

    match = DIRECT_FILTER_RE.search(text)
    if match:
        return ("direct", match.group(1))

    match = DELEGATE_RE.search(text)
    if match:
        return ("delegate", match.group(1))

    return ("none", "-")


def find_script(base: str) -> Path | None:
    path = SCRIPTS_DIR / f"compare_sasc_{base}_trial.sh"
    if path.exists():
        return path
    return None


def collect_rows(trial_dir: Path) -> list[LaneRow]:
    rows: list[LaneRow] = []

    for raw_path in sorted(trial_dir.glob("*.diff")):
        if raw_path.name.endswith(".semantic.diff"):
            continue

        base = raw_path.stem
        semantic_path = raw_path.with_name(f"{base}.semantic.diff")
        semantic_bytes = semantic_path.stat().st_size if semantic_path.exists() else -1

        script_path = find_script(base)
        if script_path is None:
            compare_script = "-"
            filter_mode, filter_path = ("missing", "-")
        else:
            compare_script = script_path.relative_to(ROOT).as_posix()
            filter_mode, filter_path = load_script_metadata(script_path)

        rows.append(
            LaneRow(
                base=base,
                raw_bytes=raw_path.stat().st_size,
                semantic_bytes=semantic_bytes,
                filter_mode=filter_mode,
                filter_path=filter_path,
                compare_script=compare_script,
            )
        )

    rows.sort(key=lambda row: (-row.raw_bytes, row.base))
    return rows


def want_row(row: LaneRow, args: argparse.Namespace) -> bool:
    if row.raw_bytes < args.min_raw_bytes:
        return False
    if row.semantic_bytes < 0 or row.semantic_bytes > args.max_semantic_bytes:
        return False
    if args.substring and args.substring.lower() not in row.base.lower():
        return False
    if args.only_direct_filter and row.filter_mode != "direct":
        return False
    if args.only_no_filter and row.filter_mode != "none":
        return False
    return True


def main() -> int:
    args = parse_args()
    trial_dir = args.trial_dir.resolve()

    if not trial_dir.is_dir():
        raise SystemExit(f"missing trial dir: {trial_dir}")

    rows = [row for row in collect_rows(trial_dir) if want_row(row, args)]

    print(f"trial dir: {trial_dir.relative_to(ROOT)}")
    print(f"rows matched: {len(rows)}")
    print(
        "filters: "
        f"min_raw_bytes={args.min_raw_bytes}, "
        f"max_semantic_bytes={args.max_semantic_bytes}, "
        f"substring={args.substring or '-'}, "
        f"only_direct_filter={int(args.only_direct_filter)}, "
        f"only_no_filter={int(args.only_no_filter)}"
    )
    print()
    print(
        f"{'raw_bytes':>9}  {'semantic':>8}  {'mode':<8}  {'base':<54} compare/filter"
    )
    print("-" * 160)

    for row in rows[: args.limit]:
        semantic_text = str(row.semantic_bytes)
        compare_filter = row.compare_script
        if row.filter_path != "-":
            compare_filter = f"{compare_filter} -> {row.filter_path}"

        print(
            f"{row.raw_bytes:9d}  {semantic_text:>8}  {row.filter_mode:<8}  "
            f"{row.base:<54} {compare_filter}"
        )

    if len(rows) > args.limit:
        print()
        print(f"... truncated {len(rows) - args.limit} additional rows")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
