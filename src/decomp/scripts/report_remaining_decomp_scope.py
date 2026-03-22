#!/usr/bin/env python3
"""Summarize remaining assembly scope outside the hybrid replacement map.

This complements the promotion/integration coverage reports by walking the
source tree directly instead of only considering modules that already have
compare/promotion lanes.
"""

from __future__ import annotations

import argparse
from pathlib import Path


INFRASTRUCTURE_FILES = {
    "hardware-addresses.s",
    "interrupts/constants.s",
    "lvo-offsets.s",
    "macros.s",
    "string-macros.s",
    "structs.s",
    "text-formatting.s",
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Report asm scope that is still outside replacements.map, split "
            "between code modules and known infrastructure include files."
        )
    )
    parser.add_argument(
        "--show-mapped",
        action="store_true",
        help="List mapped code modules as well as remaining scope.",
    )
    parser.add_argument(
        "--show-infra",
        action="store_true",
        help="List infrastructure include files outside replacements.map.",
    )
    return parser.parse_args()


def load_mapped_modules(repo_root: Path) -> set[str]:
    mapped: set[str] = set()
    map_path = repo_root / "src/decomp/replacements.map"
    for raw_line in map_path.read_text().splitlines():
        line = raw_line.split("#", 1)[0].strip()
        if not line:
            continue
        mapped.add(line.split()[0])
    return mapped


def collect_scope_modules(repo_root: Path) -> tuple[list[str], list[str]]:
    code_modules: set[str] = set()
    infrastructure_modules: set[str] = set()

    for path in sorted((repo_root / "src/modules").rglob("*.s")):
        code_modules.add(path.relative_to(repo_root / "src").as_posix())
    for path in sorted((repo_root / "src/subroutines").rglob("*.s")):
        code_modules.add(path.relative_to(repo_root / "src").as_posix())
    for path in sorted((repo_root / "src/interrupts").rglob("*.s")):
        rel = path.relative_to(repo_root / "src").as_posix()
        if rel in INFRASTRUCTURE_FILES:
            infrastructure_modules.add(rel)
        else:
            code_modules.add(rel)
    for path in sorted((repo_root / "src").glob("*.s")):
        rel = path.relative_to(repo_root / "src").as_posix()
        if rel in INFRASTRUCTURE_FILES:
            infrastructure_modules.add(rel)
        else:
            code_modules.add(rel)

    return sorted(code_modules), sorted(infrastructure_modules)


def print_section(title: str, rows: list[str]) -> None:
    print()
    print(f"{title}: {len(rows)}")
    for row in rows:
        print(row)


def main() -> int:
    args = parse_args()
    repo_root = Path(__file__).resolve().parents[3]

    mapped_modules = load_mapped_modules(repo_root)
    code_modules, infrastructure_modules = collect_scope_modules(repo_root)

    mapped_code = [module for module in code_modules if module in mapped_modules]
    unmapped_code = [module for module in code_modules if module not in mapped_modules]
    unmapped_infra = [
        module for module in infrastructure_modules if module not in mapped_modules
    ]

    print(f"code modules scanned: {len(code_modules)}")
    print(f"mapped code modules: {len(mapped_code)}")
    print(f"unmapped code modules: {len(unmapped_code)}")
    print(f"known infrastructure asm files outside map: {len(unmapped_infra)}")

    if unmapped_code:
        print_section("unmapped code modules", unmapped_code)
    elif args.show_mapped:
        print_section("mapped code modules", mapped_code)

    if args.show_infra and unmapped_infra:
        print_section("infrastructure asm files outside map", unmapped_infra)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
