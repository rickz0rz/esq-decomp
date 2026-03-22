#!/usr/bin/env python3
"""Report large semantic-clean SAS/C lanes that are safe to tighten next.

This combines the "large raw diff" view with git-dirty awareness so a dirty
checkout can still surface useful next candidates without colliding with
already in-flight compare/filter/source edits.
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
CORE_SWEEP_PATH = SCRIPTS_DIR / "run_sasc_core_sweep.sh"

RE_CORE_SWEEP_SCRIPT = re.compile(
    r'"(?P<path>src/decomp/scripts/compare_sasc_[^"]+_trial\.sh)"'
)
RE_DIRECT_FILTER = re.compile(
    r"\bawk\b[^\n]*?\s-f\s+(?P<path>src/decomp/scripts/semantic_filter[^\s\"']+)"
)
RE_DELEGATE_COMPARE = re.compile(
    r"\b(?:exec\s+)?bash\s+(?P<path>src/decomp/scripts/compare_sasc_[^\s\"']+)"
)
RE_ALIAS_WRAPPER = re.compile(
    r"compare_sasc_alias_wrapper\.sh\s+(?P<path>src/decomp/scripts/compare_sasc_[^\s\"']+)"
)
RE_ORIG_ASM = re.compile(r'^ORIG_ASM="src/(?P<path>[^"]+\.s)"', re.MULTILINE)
RE_ENTRY = re.compile(r'^ENTRY="(?P<entry>[^"]+)"', re.MULTILINE)
RE_ENTRY_ORIG = re.compile(r'^ENTRY_ORIG="(?P<entry>[^"]+)"', re.MULTILINE)
RE_ENTRY_LABEL = re.compile(r'^ENTRY_LABEL="(?P<entry>[^"]+)"', re.MULTILINE)
RE_ENTRY_CANONICAL = re.compile(r'^ENTRY_CANONICAL="(?P<entry>[^"]+)"', re.MULTILINE)
RE_TARGET = re.compile(r'^TARGET="(?P<entry>[^"]+)"', re.MULTILINE)
RE_SASC_SRC = re.compile(r'SASC_SRC="(?P<path>[^"]+)"')


@dataclass(frozen=True)
class CandidateRow:
    base: str
    raw_bytes: int
    semantic_bytes: int
    in_core_sweep: bool
    filter_mode: str
    compare_script: str
    effective_compare_script: str
    filter_path: str
    sasc_source: str
    orig_asm: str
    entry_names: tuple[str, ...]
    dirty_paths: tuple[str, ...]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Report semantic-clean SAS/C compare lanes with large raw diffs while "
            "tracking whether their compare/filter/source paths are already dirty."
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
        help="only include base names containing this substring",
    )
    parser.add_argument(
        "--only-clean",
        action="store_true",
        help="only include rows whose compare/filter/source paths are clean in git",
    )
    parser.add_argument(
        "--only-dirty",
        action="store_true",
        help="only include rows that touch at least one dirty path",
    )
    parser.add_argument(
        "--core-only",
        action="store_true",
        help="only include lanes in run_sasc_core_sweep.sh",
    )
    parser.add_argument(
        "--non-core-only",
        action="store_true",
        help="only include lanes outside run_sasc_core_sweep.sh",
    )
    parser.add_argument(
        "--show-dirty",
        action="store_true",
        help="append dirty path annotations to each row",
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


def load_core_sweep_scripts() -> set[str]:
    if not CORE_SWEEP_PATH.exists():
        return set()
    content = CORE_SWEEP_PATH.read_text(errors="ignore")
    return {match.group("path") for match in RE_CORE_SWEEP_SCRIPT.finditer(content)}


def extract_entry_names(content: str) -> tuple[str, ...]:
    entries: list[str] = []
    for regex in (RE_TARGET, RE_ENTRY, RE_ENTRY_ORIG, RE_ENTRY_CANONICAL):
        match = regex.search(content)
        if match is not None:
            entries.append(match.group("entry"))
    entries.extend(match.group("entry") for match in RE_ENTRY_LABEL.finditer(content))
    return tuple(dict.fromkeys(entries))


def load_script_metadata(script_path: Path) -> tuple[str, str, str, str, str, tuple[str, ...]]:
    visited: set[Path] = set()
    current_path = script_path
    first_mode = "missing"
    first_filter_path = "-"

    while current_path not in visited:
        visited.add(current_path)

        try:
            content = current_path.read_text(errors="ignore")
        except OSError:
            return ("missing", "-", "-", "-", "-", ())

        direct_match = RE_DIRECT_FILTER.search(content)
        if direct_match is not None:
            filter_path = direct_match.group("path")
            sasc_match = RE_SASC_SRC.search(content)
            sasc_source = (
                f"src/decomp/sas_c/{sasc_match.group('path')}"
                if sasc_match is not None
                else "-"
            )
            orig_match = RE_ORIG_ASM.search(content)
            orig_asm = orig_match.group("path") if orig_match is not None else "-"
            if first_mode == "missing":
                first_mode = "direct"
                first_filter_path = filter_path
            return (
                first_mode,
                first_filter_path,
                current_path.relative_to(ROOT).as_posix(),
                sasc_source,
                orig_asm,
                extract_entry_names(content),
            )

        alias_match = RE_ALIAS_WRAPPER.search(content)
        if alias_match is not None:
            first_mode = "delegate"
            first_filter_path = alias_match.group("path")
            current_path = ROOT / alias_match.group("path")
            continue

        delegate_match = RE_DELEGATE_COMPARE.search(content)
        if delegate_match is not None:
            if first_mode == "missing":
                first_mode = "delegate"
                first_filter_path = delegate_match.group("path")
            current_path = ROOT / delegate_match.group("path")
            continue

        sasc_match = RE_SASC_SRC.search(content)
        sasc_source = (
            f"src/decomp/sas_c/{sasc_match.group('path')}"
            if sasc_match is not None
            else "-"
        )
        orig_match = RE_ORIG_ASM.search(content)
        orig_asm = orig_match.group("path") if orig_match is not None else "-"
        if first_mode == "missing":
            first_mode = "none"
            first_filter_path = "-"
        return (
            first_mode,
            first_filter_path,
            current_path.relative_to(ROOT).as_posix(),
            sasc_source,
            orig_asm,
            extract_entry_names(content),
        )

    return ("missing", "-", "-", "-", "-", ())


def collect_rows(trial_dir: Path) -> list[CandidateRow]:
    dirty_paths = read_git_dirty_paths()
    core_sweep_scripts = load_core_sweep_scripts()
    rows: list[CandidateRow] = []

    for raw_path in sorted(trial_dir.glob("*.diff")):
        if raw_path.name.endswith(".semantic.diff"):
            continue

        base = raw_path.stem
        semantic_path = raw_path.with_name(f"{base}.semantic.diff")
        semantic_bytes = semantic_path.stat().st_size if semantic_path.exists() else -1

        compare_path = SCRIPTS_DIR / f"compare_sasc_{base}_trial.sh"
        compare_script = compare_path.relative_to(ROOT).as_posix() if compare_path.exists() else "-"

        if compare_path.exists():
            (
                filter_mode,
                filter_path,
                effective_compare_script,
                sasc_source,
                orig_asm,
                entry_names,
            ) = load_script_metadata(compare_path)
        else:
            filter_mode = "missing"
            filter_path = "-"
            effective_compare_script = "-"
            sasc_source = "-"
            orig_asm = "-"
            entry_names = ()

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
            CandidateRow(
                base=base,
                raw_bytes=raw_path.stat().st_size,
                semantic_bytes=semantic_bytes,
                in_core_sweep=compare_script in core_sweep_scripts,
                filter_mode=filter_mode,
                compare_script=compare_script,
                effective_compare_script=effective_compare_script,
                filter_path=filter_path,
                sasc_source=sasc_source,
                orig_asm=orig_asm,
                entry_names=entry_names,
                dirty_paths=row_dirty_paths,
            )
        )

    rows.sort(key=lambda row: (-row.raw_bytes, row.base))
    return rows


def main() -> int:
    args = parse_args()
    trial_dir = args.trial_dir.resolve()

    if not trial_dir.is_dir():
        raise SystemExit(f"missing trial directory: {trial_dir}")
    if args.only_clean and args.only_dirty:
        raise SystemExit("cannot use --only-clean and --only-dirty together")
    if args.core_only and args.non_core_only:
        raise SystemExit("cannot use --core-only and --non-core-only together")

    needle = args.substring.lower() if args.substring else None
    rows = []
    for row in collect_rows(trial_dir):
        if row.raw_bytes < args.min_raw_bytes:
            continue
        if row.semantic_bytes > args.max_semantic_bytes:
            continue
        if needle and needle not in row.base.lower():
            continue
        if args.only_clean and row.dirty_paths:
            continue
        if args.only_dirty and not row.dirty_paths:
            continue
        if args.core_only and not row.in_core_sweep:
            continue
        if args.non_core_only and row.in_core_sweep:
            continue
        rows.append(row)

    print(f"trial dir: {trial_dir.relative_to(ROOT)}")
    print(f"rows matched: {len(rows)}")
    print(
        "filters: "
        f"min_raw_bytes={args.min_raw_bytes}, "
        f"max_semantic_bytes={args.max_semantic_bytes}, "
        f"substring={args.substring or '-'}, "
        f"only_clean={int(args.only_clean)}, "
        f"only_dirty={int(args.only_dirty)}, "
        f"core_only={int(args.core_only)}, "
        f"non_core_only={int(args.non_core_only)}"
    )
    print()
    print(
        "raw_bytes  semantic  core  mode      base"
        "                                                   compare/filter/source"
    )
    print("-" * 152)

    for row in rows[: args.limit]:
        core = "yes" if row.in_core_sweep else " no"
        compare_filter = f"{row.compare_script} -> {row.filter_path} [{row.sasc_source}]"
        print(
            f"{row.raw_bytes:9d}  {row.semantic_bytes:8d}  {core:>4}  "
            f"{row.filter_mode:<8}  {row.base:<54}  {compare_filter}"
        )
        if args.show_dirty and row.dirty_paths:
            print(f"{'':89}dirty: {', '.join(row.dirty_paths)}")
        if row.entry_names:
            print(f"{'':89}entries: {', '.join(row.entry_names)}")
        if row.orig_asm != "-":
            print(f"{'':89}orig: {row.orig_asm}")

    remaining = len(rows) - min(len(rows), args.limit)
    if remaining > 0:
        print()
        print(f"... truncated {remaining} additional rows")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
