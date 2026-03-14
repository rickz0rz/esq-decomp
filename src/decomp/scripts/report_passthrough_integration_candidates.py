#!/usr/bin/env python3
"""Report mapped modules that are fully covered but still passthrough replacements.

This narrows the broader SAS/C integration-candidate list to module boundaries
whose replacement files still just include the original asm module verbatim.
Those rows are the cleanest next targets for object-level hybrid integration.
"""

from __future__ import annotations

import argparse
import re
from collections import defaultdict
from dataclasses import dataclass, field
from pathlib import Path


RE_ORIG_ASM = re.compile(r'^ORIG_ASM="src/(?P<path>[^"]+\.s)"', re.MULTILINE)
RE_ENTRY = re.compile(r'^ENTRY="(?P<entry>[^"]+)"', re.MULTILINE)
RE_SASC_SRC = re.compile(r'^SASC_SRC="(?P<src>[^"]+\.c)"', re.MULTILINE)
RE_XDEF = re.compile(r"^\s*XDEF\s+(?P<sym>[A-Za-z0-9_]+)", re.MULTILINE)
RE_INCLUDE_ONLY = re.compile(r'^\s*include\s+"(?P<path>[^"]+)"')


@dataclass
class ModuleStats:
    asm_direct_exports: set[str] = field(default_factory=set)
    sasc_direct_entries: set[str] = field(default_factory=set)
    direct_sasc_sources: set[str] = field(default_factory=set)

    @property
    def covered_export_count(self) -> int:
        return len(self.asm_direct_exports & self.sasc_direct_entries)

    @property
    def direct_export_count(self) -> int:
        return len(self.asm_direct_exports)

    @property
    def missing_exports(self) -> set[str]:
        return self.asm_direct_exports - self.sasc_direct_entries

    @property
    def is_complete(self) -> bool:
        return bool(self.asm_direct_exports) and not self.missing_exports


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "List mapped modules whose replacement files still passthrough to "
            "the canonical asm include even though their direct exports are "
            "already fully covered by restored SAS/C compare lanes."
        )
    )
    parser.add_argument(
        "--all",
        action="store_true",
        help="Show all mapped modules instead of only complete passthrough candidates.",
    )
    parser.add_argument(
        "--top",
        type=int,
        default=30,
        help="Maximum number of rows to print when --all is not used.",
    )
    parser.add_argument(
        "--module-filter",
        metavar="SUBSTR",
        help="Only show modules whose path contains SUBSTR.",
    )
    return parser.parse_args()


def normalize_module_path(path: str) -> str:
    prefix = "decomp/replacements/"
    if path.startswith(prefix):
        return path[len(prefix) :]
    return path


def format_ratio(covered: int, total: int) -> str:
    if total == 0:
        return "0/0"
    return f"{covered}/{total}"


def format_samples(values: set[str], limit: int = 3) -> str:
    ordered = sorted(values)
    if len(ordered) <= limit:
        return ", ".join(ordered)
    return ", ".join(ordered[:limit]) + f", +{len(ordered) - limit} more"


def load_replacement_map(repo_root: Path) -> dict[str, str]:
    mapped: dict[str, str] = {}
    map_path = repo_root / "src/decomp/replacements.map"

    for raw_line in map_path.read_text().splitlines():
        line = raw_line.split("#", 1)[0].strip()
        if not line:
            continue
        fields = line.split()
        if len(fields) >= 2:
            mapped[fields[0]] = fields[1]

    return mapped


def load_asm_direct_exports(repo_root: Path, module_path: str) -> set[str]:
    asm_path = repo_root / "src" / module_path
    if not asm_path.exists():
        return set()

    exports: set[str] = set()
    for match in RE_XDEF.finditer(asm_path.read_text()):
        symbol = match.group("sym")
        if "jmptbl" in symbol.lower():
            continue
        exports.add(symbol)
    return exports


def collect_sasc_compare_stats(repo_root: Path) -> dict[str, ModuleStats]:
    stats_by_module: dict[str, ModuleStats] = defaultdict(ModuleStats)
    scripts_dir = repo_root / "src/decomp/scripts"

    for compare_path in scripts_dir.glob("compare_sasc*_trial.sh"):
        content = compare_path.read_text()
        asm_match = RE_ORIG_ASM.search(content)
        entry_match = RE_ENTRY.search(content)
        src_match = RE_SASC_SRC.search(content)
        if asm_match is None or entry_match is None or src_match is None:
            continue

        module_path = normalize_module_path(asm_match.group("path"))
        entry_name = entry_match.group("entry")
        sasc_src = src_match.group("src")

        if "jmptbl" in entry_name.lower():
            continue

        stats = stats_by_module[module_path]
        stats.sasc_direct_entries.add(entry_name)
        stats.direct_sasc_sources.add(sasc_src)

    return stats_by_module


def replacement_is_passthrough(repo_root: Path, module_path: str, replacement_path: str) -> bool:
    path = repo_root / "src" / replacement_path
    if not path.exists():
        return False

    include_targets: list[str] = []
    for raw_line in path.read_text().splitlines():
        line = raw_line.strip()
        if not line or line.startswith(";"):
            continue
        match = RE_INCLUDE_ONLY.match(line)
        if match:
            include_targets.append(match.group("path"))
            continue
        return False

    return include_targets == [module_path]


def main() -> int:
    args = parse_args()
    repo_root = Path(__file__).resolve().parents[3]
    mapped_modules = load_replacement_map(repo_root)
    stats_by_module = collect_sasc_compare_stats(repo_root)

    rows = []
    complete_passthrough = 0

    for module_path, replacement_path in sorted(mapped_modules.items()):
        if args.module_filter and args.module_filter not in module_path:
            continue

        stats = stats_by_module[module_path]
        stats.asm_direct_exports = load_asm_direct_exports(repo_root, module_path)
        passthrough = replacement_is_passthrough(repo_root, module_path, replacement_path)

        if passthrough and stats.is_complete:
            complete_passthrough += 1

        if not args.all and not (passthrough and stats.is_complete):
            continue

        rows.append(
            (
                0 if passthrough and stats.is_complete else 1,
                len(stats.direct_sasc_sources),
                stats.direct_export_count,
                module_path,
                replacement_path,
                passthrough,
                stats,
            )
        )

    rows.sort()
    if not args.all:
        rows = rows[: args.top]

    print(f"mapped modules considered: {len(mapped_modules)}")
    print(f"complete passthrough candidates: {complete_passthrough}")
    print()

    header = (
        f"{'status':10}  {'coverage':8}  {'sasc_srcs':9}  "
        f"{'direct_xdefs':12}  {'module':48}  {'replacement':48}  {'sample sas_c files'}"
    )
    print(header)
    print("-" * len(header))

    for _, _, _, module_path, replacement_path, passthrough, stats in rows:
        if passthrough and stats.is_complete:
            status = "ready"
        elif passthrough:
            status = "partial"
        else:
            status = "custom"

        print(
            f"{status:10}  "
            f"{format_ratio(stats.covered_export_count, stats.direct_export_count):8}  "
            f"{len(stats.direct_sasc_sources):9d}  "
            f"{stats.direct_export_count:12d}  "
            f"{module_path:48}  "
            f"{replacement_path:48}  "
            f"{format_samples(stats.direct_sasc_sources)}"
        )

        if args.all and stats.missing_exports:
            print(f"  missing: {format_samples(stats.missing_exports, limit=6)}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
