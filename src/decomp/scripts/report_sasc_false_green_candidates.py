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
import subprocess
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
SASC_SRC_RE = re.compile(r"SASC_SRC=\"([^\"]+)\"")
ALIAS_WRAPPER_RE = re.compile(
    r"compare_sasc_alias_wrapper\.sh\s+(src/decomp/scripts/compare_sasc_[^\s\"']+)"
)


@dataclass(frozen=True)
class LaneRow:
    base: str
    raw_bytes: int
    semantic_bytes: int
    filter_mode: str
    filter_path: str
    compare_script: str
    effective_compare_script: str
    sasc_source: str
    dirty_paths: tuple[str, ...]


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
    parser.add_argument(
        "--only-clean",
        action="store_true",
        help="only include rows whose compare/filter/source paths are clean in git status",
    )
    parser.add_argument(
        "--show-dirty",
        action="store_true",
        help="append dirty path annotations to each printed row",
    )
    return parser.parse_args()


def read_git_dirty_paths() -> set[str]:
    try:
        result = subprocess.run(
            ["git", "status", "--short"],
            cwd=ROOT,
            check=True,
            capture_output=True,
            text=True,
        )
    except (OSError, subprocess.CalledProcessError):
        return set()

    dirty_paths: set[str] = set()

    for line in result.stdout.splitlines():
        if not line:
            continue
        path = line[3:]
        if " -> " in path:
            path = path.split(" -> ", 1)[1]
        dirty_paths.add(path)

    return dirty_paths


def load_script_metadata(script_path: Path) -> tuple[str, str, str, str]:
    visited: set[Path] = set()
    current_path = script_path
    first_mode = "missing"
    first_filter_path = "-"

    while current_path not in visited:
        visited.add(current_path)

        try:
            text = current_path.read_text(errors="ignore")
        except OSError:
            return ("missing", "-", "-", "-")

        match = DIRECT_FILTER_RE.search(text)
        if match:
            filter_path = match.group(1)
            sasc_match = SASC_SRC_RE.search(text)
            sasc_source = (
                f"src/decomp/sas_c/{sasc_match.group(1)}"
                if sasc_match
                else "-"
            )
            if first_mode == "missing":
                first_mode = "direct"
                first_filter_path = filter_path
            return (
                first_mode,
                first_filter_path,
                current_path.relative_to(ROOT).as_posix(),
                sasc_source,
            )

        alias_match = ALIAS_WRAPPER_RE.search(text)
        if alias_match:
            first_mode = "delegate"
            first_filter_path = alias_match.group(1)
            current_path = ROOT / alias_match.group(1)
            continue

        match = DELEGATE_RE.search(text)
        if match:
            if first_mode == "missing":
                first_mode = "delegate"
                first_filter_path = match.group(1)
            current_path = ROOT / match.group(1)
            continue

        sasc_match = SASC_SRC_RE.search(text)
        sasc_source = (
            f"src/decomp/sas_c/{sasc_match.group(1)}"
            if sasc_match
            else "-"
        )
        if first_mode == "missing":
            first_mode = "none"
            first_filter_path = "-"
        return (
            first_mode,
            first_filter_path,
            current_path.relative_to(ROOT).as_posix(),
            sasc_source,
        )

    return ("missing", "-", "-", "-")


def find_script(base: str) -> Path | None:
    path = SCRIPTS_DIR / f"compare_sasc_{base}_trial.sh"
    if path.exists():
        return path
    return None


def collect_rows(trial_dir: Path, dirty_paths: set[str]) -> list[LaneRow]:
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
            filter_mode, filter_path, effective_compare_script, sasc_source = (
                "missing",
                "-",
                "-",
                "-",
            )
        else:
            compare_script = script_path.relative_to(ROOT).as_posix()
            (
                filter_mode,
                filter_path,
                effective_compare_script,
                sasc_source,
            ) = load_script_metadata(script_path)

        row_dirty_paths = tuple(
            path
            for path in (
                compare_script,
                filter_path,
                effective_compare_script,
                sasc_source,
            )
            if path != "-" and path in dirty_paths
        )

        rows.append(
            LaneRow(
                base=base,
                raw_bytes=raw_path.stat().st_size,
                semantic_bytes=semantic_bytes,
                filter_mode=filter_mode,
                filter_path=filter_path,
                compare_script=compare_script,
                effective_compare_script=effective_compare_script,
                sasc_source=sasc_source,
                dirty_paths=row_dirty_paths,
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
    if args.only_clean and row.dirty_paths:
        return False
    return True


def main() -> int:
    args = parse_args()
    trial_dir = args.trial_dir.resolve()

    if not trial_dir.is_dir():
        raise SystemExit(f"missing trial dir: {trial_dir}")

    dirty_paths = read_git_dirty_paths()
    rows = [row for row in collect_rows(trial_dir, dirty_paths) if want_row(row, args)]

    print(f"trial dir: {trial_dir.relative_to(ROOT)}")
    print(f"rows matched: {len(rows)}")
    print(
        "filters: "
        f"min_raw_bytes={args.min_raw_bytes}, "
        f"max_semantic_bytes={args.max_semantic_bytes}, "
        f"substring={args.substring or '-'}, "
        f"only_direct_filter={int(args.only_direct_filter)}, "
        f"only_no_filter={int(args.only_no_filter)}, "
        f"only_clean={int(args.only_clean)}"
    )
    print()
    print(
        f"{'raw_bytes':>9}  {'semantic':>8}  {'mode':<8}  {'base':<54} compare/filter/source"
    )
    print("-" * 160)

    for row in rows[: args.limit]:
        semantic_text = str(row.semantic_bytes)
        compare_filter = row.compare_script
        if (
            row.effective_compare_script != "-"
            and row.effective_compare_script != row.compare_script
        ):
            compare_filter = f"{compare_filter} -> {row.effective_compare_script}"
        if row.filter_path != "-" and row.filter_path != row.effective_compare_script:
            compare_filter = f"{compare_filter} -> {row.filter_path}"
        if row.sasc_source != "-":
            compare_filter = f"{compare_filter} [src: {row.sasc_source}]"
        if args.show_dirty and row.dirty_paths:
            compare_filter = (
                f"{compare_filter} [dirty: {', '.join(row.dirty_paths)}]"
            )

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
