#!/usr/bin/env python3
"""Report semantic-clean SAS/C compare lanes that still have large raw diffs.

This is a triage helper for the maintained `build/decomp/sasc_trial/` artifacts.
It highlights targets whose `.semantic.diff` is empty but whose raw `.diff`
output is still large enough to merit inspection or filter review.
"""

from __future__ import annotations

import argparse
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


ROOT = Path(__file__).resolve().parents[3]
DEFAULT_TRIAL_DIR = ROOT / "build" / "decomp" / "sasc_trial"


@dataclass(frozen=True)
class DiffRow:
    base: str
    raw_bytes: int
    semantic_bytes: int
    compare_script: str | None


def collect_rows(trial_dir: Path) -> list[DiffRow]:
    rows: list[DiffRow] = []

    for raw_path in sorted(trial_dir.glob("*.diff")):
        if raw_path.name.endswith(".semantic.diff"):
            continue

        base = raw_path.stem
        semantic_path = raw_path.with_name(f"{base}.semantic.diff")
        raw_bytes = raw_path.stat().st_size
        semantic_bytes = semantic_path.stat().st_size if semantic_path.exists() else -1
        compare_script = find_compare_script(base)

        rows.append(
            DiffRow(
                base=base,
                raw_bytes=raw_bytes,
                semantic_bytes=semantic_bytes,
                compare_script=compare_script,
            )
        )

    rows.sort(key=lambda row: (-row.raw_bytes, row.base))
    return rows


def find_compare_script(base: str) -> str | None:
    script = ROOT / "src" / "decomp" / "scripts" / f"compare_sasc_{base}_trial.sh"
    if script.exists():
        return script.relative_to(ROOT).as_posix()
    return None


def filter_rows(
    rows: Iterable[DiffRow],
    *,
    min_raw_bytes: int,
    max_semantic_bytes: int | None,
    substring: str | None,
) -> list[DiffRow]:
    filtered: list[DiffRow] = []
    needle = substring.lower() if substring else None

    for row in rows:
        if row.raw_bytes < min_raw_bytes:
            continue
        if max_semantic_bytes is not None and row.semantic_bytes > max_semantic_bytes:
            continue
        if needle and needle not in row.base.lower():
            continue
        filtered.append(row)

    return filtered


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description=(
            "List SAS/C compare lanes whose raw diff is still large. "
            "Defaults to semantic-clean rows only."
        )
    )
    parser.add_argument(
        "--trial-dir",
        type=Path,
        default=DEFAULT_TRIAL_DIR,
        help=f"directory containing compare artifacts (default: {DEFAULT_TRIAL_DIR})",
    )
    parser.add_argument(
        "--limit",
        type=int,
        default=40,
        help="maximum number of rows to print (default: 40)",
    )
    parser.add_argument(
        "--min-raw-bytes",
        type=int,
        default=1,
        help="minimum raw .diff size in bytes (default: 1)",
    )
    parser.add_argument(
        "--max-semantic-bytes",
        type=int,
        default=0,
        help=(
            "maximum semantic .diff size in bytes; use -1 to include all rows "
            "(default: 0, i.e. semantic-clean only)"
        ),
    )
    parser.add_argument(
        "--filter",
        dest="substring",
        help="only include rows whose base name contains this substring",
    )
    return parser


def main() -> int:
    args = build_parser().parse_args()
    trial_dir = args.trial_dir.resolve()

    if not trial_dir.is_dir():
        raise SystemExit(f"missing trial directory: {trial_dir}")

    semantic_limit = None if args.max_semantic_bytes < 0 else args.max_semantic_bytes
    rows = filter_rows(
        collect_rows(trial_dir),
        min_raw_bytes=args.min_raw_bytes,
        max_semantic_bytes=semantic_limit,
        substring=args.substring,
    )

    print(f"trial dir: {trial_dir.relative_to(ROOT)}")
    print(f"rows matched: {len(rows)}")
    print(
        "filters: "
        f"min_raw_bytes={args.min_raw_bytes}, "
        f"max_semantic_bytes={semantic_limit if semantic_limit is not None else 'any'}, "
        f"substring={args.substring or '-'}"
    )
    print()
    print(
        f"{'raw_bytes':>9}  {'semantic':>8}  {'base':<64} compare script"
    )
    print("-" * 120)

    for row in rows[: args.limit]:
        semantic_text = "missing" if row.semantic_bytes < 0 else str(row.semantic_bytes)
        print(
            f"{row.raw_bytes:9d}  {semantic_text:>8}  "
            f"{row.base:<64} {row.compare_script or '-'}"
        )

    if len(rows) > args.limit:
        print()
        print(f"... truncated {len(rows) - args.limit} additional rows")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
