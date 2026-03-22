#!/usr/bin/env python3
"""Report replacement-map rows that are not backed by promotion/compare coverage.

This is mainly useful for scope mirrors such as include-only asm files that are
intentionally present in `src/decomp/replacements.map` but do not have callable
exports or dedicated GCC/SAS/C coverage lanes.
"""

from __future__ import annotations

import re
from pathlib import Path


RE_ORIG_ASM = re.compile(r'^ORIG_ASM="src/(?P<path>[^"]+\.s)"', re.MULTILINE)
RE_XDEF = re.compile(r"^\s*XDEF\s+(?P<sym>[A-Za-z0-9_]+)", re.MULTILINE)


def normalize_module_path(path: str) -> str:
    prefix = "decomp/replacements/"
    if path.startswith(prefix):
        return path[len(prefix) :]
    return path


def load_replacement_map(repo_root: Path) -> set[str]:
    mapped: set[str] = set()
    map_path = repo_root / "src/decomp/replacements.map"

    for raw_line in map_path.read_text().splitlines():
        line = raw_line.split("#", 1)[0].strip()
        if not line:
            continue
        fields = line.split()
        if len(fields) >= 2:
            mapped.add(fields[0])

    return mapped


def collect_covered_modules(repo_root: Path) -> set[str]:
    covered: set[str] = set()
    scripts_dir = repo_root / "src/decomp/scripts"

    for script_path in scripts_dir.glob("promote_*_target_gcc.sh"):
        content = script_path.read_text()
        match = RE_ORIG_ASM.search(content)
        if match is not None:
            covered.add(normalize_module_path(match.group("path")))

    for script_path in scripts_dir.glob("compare_sasc*_trial.sh"):
        content = script_path.read_text()
        match = RE_ORIG_ASM.search(content)
        if match is not None:
            covered.add(normalize_module_path(match.group("path")))

    return covered


def classify_module(repo_root: Path, module_path: str) -> tuple[str, int, int]:
    asm_path = repo_root / "src" / module_path
    if not asm_path.exists():
        return ("missing", 0, 0)

    all_exports = set()
    direct_exports = set()
    for match in RE_XDEF.finditer(asm_path.read_text()):
        symbol = match.group("sym")
        all_exports.add(symbol)
        if "jmptbl" not in symbol.lower():
            direct_exports.add(symbol)

    if direct_exports:
        return ("callable", len(direct_exports), len(all_exports))
    if all_exports:
        return ("wrapper-only", 0, len(all_exports))
    return ("non-callable", 0, 0)


def main() -> int:
    repo_root = Path(__file__).resolve().parents[3]
    mapped = load_replacement_map(repo_root)
    covered = collect_covered_modules(repo_root)
    replacement_only = sorted(mapped - covered)

    print(f"replacement-map entries: {len(mapped)}")
    print(f"coverage-backed modules: {len(covered & mapped)}")
    print(f"replacement-only modules: {len(replacement_only)}")
    print()

    header = f"{'status':12}  {'direct_xdefs':12}  {'all_xdefs':9}  module"
    print(header)
    print("-" * len(header))

    for module_path in replacement_only:
        status, direct_xdefs, all_xdefs = classify_module(repo_root, module_path)
        print(f"{status:12}  {direct_xdefs:12d}  {all_xdefs:9d}  {module_path}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
