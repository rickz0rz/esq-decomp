#!/usr/bin/env python3
"""Report semantic-clean SAS/C compare lanes that still have large raw diffs.

This is a triage helper for the maintained `build/decomp/sasc_trial/` artifacts.
It highlights targets whose `.semantic.diff` is empty but whose raw `.diff`
output is still large enough to merit inspection or filter review.
"""

from __future__ import annotations

import argparse
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


ROOT = Path(__file__).resolve().parents[3]
DEFAULT_TRIAL_DIR = ROOT / "build" / "decomp" / "sasc_trial"
SCRIPTS_DIR = ROOT / "src" / "decomp" / "scripts"
CORE_SWEEP_PATH = SCRIPTS_DIR / "run_sasc_core_sweep.sh"
RE_ORIG_ASM = re.compile(r'^ORIG_ASM="src/(?P<path>[^"]+\.s)"', re.MULTILINE)
RE_ENTRY = re.compile(r'^ENTRY="(?P<entry>[^"]+)"', re.MULTILINE)
RE_ENTRY_ORIG = re.compile(r'^ENTRY_ORIG="(?P<entry>[^"]+)"', re.MULTILINE)
RE_ENTRY_LABEL = re.compile(r'^ENTRY_LABEL="(?P<entry>[^"]+)"', re.MULTILINE)
RE_ENTRY_CANONICAL = re.compile(r'^ENTRY_CANONICAL="(?P<entry>[^"]+)"', re.MULTILINE)
RE_TARGET = re.compile(r'^TARGET="(?P<entry>[^"]+)"', re.MULTILINE)
RE_CORE_SWEEP_SCRIPT = re.compile(r'"(?P<path>src/decomp/scripts/compare_sasc_[^"]+_trial\.sh)"')
RE_DELEGATE_COMPARE = re.compile(
    r"\b(?:exec\s+)?bash\s+(?P<path>src/decomp/scripts/compare_sasc_[^\s\"']+)"
)
RE_ALIAS_WRAPPER_TARGET = re.compile(
    r"compare_sasc_alias_wrapper\.sh\s+(?P<path>src/decomp/scripts/compare_sasc_[^\s\"']+)"
)


@dataclass(frozen=True)
class DiffRow:
    base: str
    raw_bytes: int
    semantic_bytes: int
    compare_script: str | None
    effective_compare_script: str | None
    in_core_sweep: bool
    orig_asm: str | None
    entry_names: tuple[str, ...]


def collect_rows(trial_dir: Path) -> list[DiffRow]:
    rows: list[DiffRow] = []
    core_sweep_scripts = load_core_sweep_scripts()

    for raw_path in sorted(trial_dir.glob("*.diff")):
        if raw_path.name.endswith(".semantic.diff"):
            continue

        base = raw_path.stem
        semantic_path = raw_path.with_name(f"{base}.semantic.diff")
        raw_bytes = raw_path.stat().st_size
        semantic_bytes = semantic_path.stat().st_size if semantic_path.exists() else -1
        compare_script = find_compare_script(base)
        effective_compare_script = resolve_compare_script(compare_script)
        script_meta = load_compare_metadata(effective_compare_script)

        rows.append(
            DiffRow(
                base=base,
                raw_bytes=raw_bytes,
                semantic_bytes=semantic_bytes,
                compare_script=compare_script,
                effective_compare_script=effective_compare_script,
                in_core_sweep=compare_script in core_sweep_scripts,
                orig_asm=script_meta.orig_asm,
                entry_names=script_meta.entry_names,
            )
        )

    rows.sort(key=lambda row: (-row.raw_bytes, row.base))
    return rows


@dataclass(frozen=True)
class CompareMetadata:
    orig_asm: str | None
    entry_names: tuple[str, ...]


def find_compare_script(base: str) -> str | None:
    script = SCRIPTS_DIR / f"compare_sasc_{base}_trial.sh"
    if script.exists():
        return script.relative_to(ROOT).as_posix()
    return None


def load_core_sweep_scripts() -> set[str]:
    if not CORE_SWEEP_PATH.exists():
        return set()

    content = CORE_SWEEP_PATH.read_text()
    return {
        match.group("path")
        for match in RE_CORE_SWEEP_SCRIPT.finditer(content)
    }


def resolve_compare_script(compare_script: str | None) -> str | None:
    current = compare_script
    seen: set[str] = set()

    while current is not None and current not in seen:
        seen.add(current)
        script_path = ROOT / current
        if not script_path.exists():
            break

        content = script_path.read_text(errors="ignore")
        alias_match = RE_ALIAS_WRAPPER_TARGET.search(content)
        if alias_match is not None:
            current = alias_match.group("path")
            continue

        delegate_match = RE_DELEGATE_COMPARE.search(content)
        if delegate_match is not None:
            next_script = delegate_match.group("path")
            if next_script != current:
                current = next_script
                continue

        break

    return current


def extract_effective_entry_names(content: str) -> tuple[str, ...]:
    entries: list[str] = []

    for regex in (
        RE_TARGET,
        RE_ENTRY,
        RE_ENTRY_ORIG,
        RE_ENTRY_CANONICAL,
    ):
        match = regex.search(content)
        if match is not None:
            entries.append(match.group("entry"))

    entries.extend(match.group("entry") for match in RE_ENTRY_LABEL.finditer(content))
    return tuple(dict.fromkeys(entries))


def load_compare_metadata(compare_script: str | None) -> CompareMetadata:
    if compare_script is None:
        return CompareMetadata(orig_asm=None, entry_names=())

    script_path = ROOT / compare_script
    if not script_path.exists():
        return CompareMetadata(orig_asm=None, entry_names=())

    content = script_path.read_text(errors="ignore")
    orig_asm_match = RE_ORIG_ASM.search(content)
    orig_asm = orig_asm_match.group("path") if orig_asm_match is not None else None
    return CompareMetadata(
        orig_asm=orig_asm,
        entry_names=extract_effective_entry_names(content),
    )


def filter_rows(
    rows: Iterable[DiffRow],
    *,
    min_raw_bytes: int,
    max_semantic_bytes: int | None,
    substring: str | None,
    core_only: bool,
    non_core_only: bool,
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
        if core_only and not row.in_core_sweep:
            continue
        if non_core_only and row.in_core_sweep:
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
    parser.add_argument(
        "--core-only",
        action="store_true",
        help="only include compare lanes that are part of run_sasc_core_sweep.sh",
    )
    parser.add_argument(
        "--non-core-only",
        action="store_true",
        help="only include compare lanes that are outside run_sasc_core_sweep.sh",
    )
    return parser


def main() -> int:
    args = build_parser().parse_args()
    trial_dir = args.trial_dir.resolve()

    if not trial_dir.is_dir():
        raise SystemExit(f"missing trial directory: {trial_dir}")
    if args.core_only and args.non_core_only:
        raise SystemExit("cannot use --core-only and --non-core-only together")

    semantic_limit = None if args.max_semantic_bytes < 0 else args.max_semantic_bytes
    rows = filter_rows(
        collect_rows(trial_dir),
        min_raw_bytes=args.min_raw_bytes,
        max_semantic_bytes=semantic_limit,
        substring=args.substring,
        core_only=args.core_only,
        non_core_only=args.non_core_only,
    )

    print(f"trial dir: {trial_dir.relative_to(ROOT)}")
    print(f"rows matched: {len(rows)}")
    print(
        "filters: "
        f"min_raw_bytes={args.min_raw_bytes}, "
        f"max_semantic_bytes={semantic_limit if semantic_limit is not None else 'any'}, "
        f"substring={args.substring or '-'}, "
        f"core_only={int(args.core_only)}, "
        f"non_core_only={int(args.non_core_only)}"
    )
    print()
    print(
        f"{'raw_bytes':>9}  {'semantic':>8}  {'core':<4}  {'base':<48} "
        f"{'entry':<32} compare/orig"
    )
    print("-" * 180)

    for row in rows[: args.limit]:
        semantic_text = "missing" if row.semantic_bytes < 0 else str(row.semantic_bytes)
        entry_text = ",".join(row.entry_names) if row.entry_names else "-"
        compare_text = row.compare_script or "-"
        if (
            row.compare_script is not None
            and row.effective_compare_script is not None
            and row.effective_compare_script != row.compare_script
        ):
            compare_text = f"{compare_text} -> {row.effective_compare_script}"
        if row.orig_asm is not None:
            compare_text = f"{compare_text} [{row.orig_asm}]"
        print(
            f"{row.raw_bytes:9d}  {semantic_text:>8}  "
            f"{'yes' if row.in_core_sweep else 'no':<4}  "
            f"{row.base:<48.48}  {entry_text:<32.32} {compare_text}"
        )

    if len(rows) > args.limit:
        print()
        print(f"... truncated {len(rows) - args.limit} additional rows")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
