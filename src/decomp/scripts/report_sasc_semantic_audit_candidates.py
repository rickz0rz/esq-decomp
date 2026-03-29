#!/usr/bin/env python3
"""Rank SAS/C lanes whose semantic diffs are green but raw diffs stay large.

These rows are good candidates for semantic-filter review or deeper asm/C audit:
the current lane reports semantic-clean output, but the normalized raw diff is
still large enough that a too-permissive filter is plausible.
"""

from __future__ import annotations

import argparse
import re
from dataclasses import dataclass
from pathlib import Path


RE_BASE = re.compile(r'^BASE="(?P<base>[^"]+)"', re.MULTILINE)
RE_ORIG_ASM = re.compile(r'^ORIG_ASM="src/(?P<path>[^"]+\.s)"', re.MULTILINE)
RE_SASC_SRC = re.compile(r'^SASC_SRC="(?P<src>[^"]+\.c)"', re.MULTILINE)
RE_SEMANTIC_FILTER = re.compile(
    r'awk -f (?P<path>src/decomp/scripts/semantic_filter[^ \t"\']+\.awk)',
    re.MULTILINE,
)


@dataclass
class CompareMeta:
    compare_script: str
    base: str
    module: str | None
    sasc_src: str | None
    semantic_filter: str | None


@dataclass
class AuditRow:
    base: str
    raw_bytes: int
    semantic_bytes: int
    compare_script: str | None
    module: str | None
    sasc_src: str | None
    semantic_filter: str | None


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Report large raw-diff SAS/C lanes whose semantic diffs are already "
            "empty, so future hardening work can start from the current checkout "
            "instead of stale blocker notes."
        )
    )
    parser.add_argument(
        "--top",
        type=int,
        default=30,
        help="Maximum number of rows to print.",
    )
    parser.add_argument(
        "--min-raw-bytes",
        type=int,
        default=8192,
        help="Only report lanes whose raw diff is at least this large.",
    )
    parser.add_argument(
        "--include-nonzero-semantic",
        action="store_true",
        help="Include rows whose semantic diff is non-zero instead of only semantic-clean lanes.",
    )
    parser.add_argument(
        "--base-filter",
        metavar="SUBSTR",
        help="Only report lanes whose diff base name contains SUBSTR.",
    )
    return parser.parse_args()


def derive_base_from_script_name(name: str) -> str | None:
    prefix = "compare_sasc_"
    suffix = "_trial.sh"
    if not (name.startswith(prefix) and name.endswith(suffix)):
        return None
    return name[len(prefix) : -len(suffix)]


def collect_compare_metadata(repo_root: Path) -> dict[str, CompareMeta]:
    scripts_dir = repo_root / "src/decomp/scripts"
    metadata: dict[str, CompareMeta] = {}

    for script_path in scripts_dir.glob("compare_sasc*_trial.sh"):
        content = script_path.read_text()
        base_match = RE_BASE.search(content)
        base = base_match.group("base") if base_match else derive_base_from_script_name(script_path.name)
        if not base:
            continue

        module_match = RE_ORIG_ASM.search(content)
        sasc_match = RE_SASC_SRC.search(content)
        semantic_filter_match = RE_SEMANTIC_FILTER.search(content)
        semantic_filter_path = None
        if semantic_filter_match:
            semantic_filter_path = repo_root / semantic_filter_match.group("path")
        else:
            fallback_path = scripts_dir / f"semantic_filter_sasc_{base}.awk"
            if fallback_path.exists():
                semantic_filter_path = fallback_path

        metadata[base] = CompareMeta(
            compare_script=script_path.name,
            base=base,
            module=module_match.group("path") if module_match else None,
            sasc_src=sasc_match.group("src") if sasc_match else None,
            semantic_filter=(
                semantic_filter_path.relative_to(repo_root).as_posix()
                if semantic_filter_path and semantic_filter_path.exists()
                else None
            ),
        )

    return metadata


def collect_audit_rows(repo_root: Path, args: argparse.Namespace) -> list[AuditRow]:
    trial_dir = repo_root / "build/decomp/sasc_trial"
    metadata = collect_compare_metadata(repo_root)
    rows: list[AuditRow] = []

    for raw_diff_path in trial_dir.glob("*.diff"):
        if raw_diff_path.name.endswith(".semantic.diff"):
            continue

        base = raw_diff_path.stem
        if args.base_filter and args.base_filter not in base:
            continue

        raw_bytes = raw_diff_path.stat().st_size
        if raw_bytes < args.min_raw_bytes:
            continue

        semantic_path = trial_dir / f"{base}.semantic.diff"
        semantic_bytes = semantic_path.stat().st_size if semantic_path.exists() else -1
        if not args.include_nonzero_semantic and semantic_bytes != 0:
            continue

        meta = metadata.get(base)
        rows.append(
            AuditRow(
                base=base,
                raw_bytes=raw_bytes,
                semantic_bytes=semantic_bytes,
                compare_script=meta.compare_script if meta else None,
                module=meta.module if meta else None,
                sasc_src=meta.sasc_src if meta else None,
                semantic_filter=meta.semantic_filter if meta else None,
            )
        )

    rows.sort(key=lambda row: (-row.raw_bytes, row.base))
    return rows


def main() -> int:
    args = parse_args()
    repo_root = Path(__file__).resolve().parents[3]
    rows = collect_audit_rows(repo_root, args)

    if args.include_nonzero_semantic:
        mode = "all lanes meeting raw-diff threshold"
    else:
        mode = "semantic-clean lanes meeting raw-diff threshold"

    print(f"mode: {mode}")
    print(f"min raw diff bytes: {args.min_raw_bytes}")
    print(f"matching lanes: {len(rows)}")

    if not rows:
        print("next step: no audit candidates matched the current filters.")
        return 0

    header = (
        "raw_bytes  sem_bytes  base"
        "                                               compare_script"
        "                                         sasc_src"
    )
    print()
    print(header)
    print("-" * len(header))

    for row in rows[: args.top]:
        compare_script = row.compare_script or "-"
        sasc_src = row.sasc_src or "-"
        print(
            f"{row.raw_bytes:9d}  {row.semantic_bytes:9d}  "
            f"{row.base:<49.49} {compare_script:<52.52} {sasc_src}"
        )
        module = row.module or "-"
        semantic_filter = row.semantic_filter or "-"
        print(f"module: {module}")
        print(f"semantic filter: {semantic_filter}")

    if len(rows) > args.top:
        print()
        print(f"... {len(rows) - args.top} more rows omitted")

    print()
    print("next step: inspect the largest rows first and verify that the semantic filter")
    print("still distinguishes real behavior from frame setup, constant-pool movement,")
    print("or other codegen-only noise in the current checkout.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
