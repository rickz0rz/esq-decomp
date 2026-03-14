#!/usr/bin/env python3
"""Report hybrid replacement candidate coverage by original assembly module.

This correlates GCC promotion lanes and restored SAS/C compare lanes back to
their ORIG_ASM source modules, then cross-checks those modules against
src/decomp/replacements.map.
"""

from __future__ import annotations

import argparse
import re
import sys
from collections import defaultdict
from dataclasses import dataclass, field
from pathlib import Path


RE_COMPARE_SCRIPT = re.compile(
    r'COMPARE_SCRIPT="(?P<path>src/decomp/scripts/[^"]*compare_[^"]+\.sh)"'
)
RE_COMPARE_FALLBACK = re.compile(r"compare_[A-Za-z0-9_]+\.sh")
RE_ORIG_ASM = re.compile(r'^ORIG_ASM="src/(?P<path>[^"]+\.s)"', re.MULTILINE)
RE_ENTRY = re.compile(r'^ENTRY="(?P<entry>[^"]+)"', re.MULTILINE)


@dataclass
class ModuleStats:
    gcc_compare_scripts: set[str] = field(default_factory=set)
    promote_scripts: set[str] = field(default_factory=set)
    gcc_target_names: set[str] = field(default_factory=set)
    gcc_non_jmptbl_targets: set[str] = field(default_factory=set)
    sasc_compare_scripts: set[str] = field(default_factory=set)
    sasc_entry_names: set[str] = field(default_factory=set)
    sasc_non_jmptbl_entries: set[str] = field(default_factory=set)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Summarize GCC promotion-lane coverage and restored SAS/C compare "
            "coverage by original asm module, and show which modules are "
            "already wired into replacements.map."
        )
    )
    parser.add_argument(
        "--top",
        type=int,
        default=25,
        help="Maximum number of module rows to print when --all is not used.",
    )
    parser.add_argument(
        "--all",
        action="store_true",
        help="Print all discovered modules.",
    )
    parser.add_argument(
        "--mapped-only",
        action="store_true",
        help="Show only modules already present in replacements.map.",
    )
    parser.add_argument(
        "--unmapped-only",
        action="store_true",
        help="Show only modules missing from replacements.map.",
    )
    return parser.parse_args()


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


def normalize_module_path(path: str) -> str:
    """Map compare-script ORIG_ASM paths back to the canonical source include path."""
    prefix = "decomp/replacements/"
    if path.startswith(prefix):
        return path[len(prefix) :]
    return path


def build_compare_module_index(scripts_dir: Path) -> dict[str, str]:
    index: dict[str, str] = {}

    for compare_path in scripts_dir.glob("compare_*_trial_gcc.sh"):
        content = compare_path.read_text()
        match = RE_ORIG_ASM.search(content)
        if match:
            index[compare_path.name] = normalize_module_path(match.group("path"))

    return index


def extract_compare_script_name(content: str) -> str | None:
    match = RE_COMPARE_SCRIPT.search(content)
    if match:
        return Path(match.group("path")).name

    match = RE_COMPARE_FALLBACK.search(content)
    if match:
        return match.group(0)

    return None


def target_name_from_compare_script(compare_name: str) -> str:
    name = compare_name
    if name.startswith("compare_"):
        name = name[len("compare_") :]
    if name.endswith("_trial_gcc.sh"):
        name = name[: -len("_trial_gcc.sh")]
    elif name.endswith(".sh"):
        name = name[:-3]
    return name


def collect_module_stats(repo_root: Path) -> tuple[dict[str, ModuleStats], int]:
    scripts_dir = repo_root / "src/decomp/scripts"
    compare_index = build_compare_module_index(scripts_dir)
    modules: dict[str, ModuleStats] = defaultdict(ModuleStats)
    unresolved_promotes = 0

    for promote_path in scripts_dir.glob("promote_*_target_gcc.sh"):
        content = promote_path.read_text()
        compare_name = extract_compare_script_name(content)
        if compare_name is None:
            unresolved_promotes += 1
            continue

        module_path = compare_index.get(compare_name)
        if module_path is None:
            unresolved_promotes += 1
            continue

        stats = modules[module_path]
        stats.promote_scripts.add(promote_path.name)
        stats.gcc_compare_scripts.add(compare_name)

        target_name = target_name_from_compare_script(compare_name)
        stats.gcc_target_names.add(target_name)
        if "jmptbl" not in target_name.lower():
            stats.gcc_non_jmptbl_targets.add(target_name)

    for compare_path in scripts_dir.glob("compare_sasc*_trial.sh"):
        content = compare_path.read_text()
        asm_match = RE_ORIG_ASM.search(content)
        entry_match = RE_ENTRY.search(content)
        if asm_match is None or entry_match is None:
            continue

        module_path = asm_match.group("path")
        module_path = normalize_module_path(module_path)
        entry_name = entry_match.group("entry")
        stats = modules[module_path]
        stats.sasc_compare_scripts.add(compare_path.name)
        stats.sasc_entry_names.add(entry_name)
        if "jmptbl" not in entry_name.lower():
            stats.sasc_non_jmptbl_entries.add(entry_name)

    return modules, unresolved_promotes


def should_show(module: str, mapped_modules: set[str], args: argparse.Namespace) -> bool:
    is_mapped = module in mapped_modules
    if args.mapped_only and not is_mapped:
        return False
    if args.unmapped_only and is_mapped:
        return False
    return True


def format_samples(names: set[str], limit: int = 3) -> str:
    ordered = sorted(names)
    if len(ordered) <= limit:
        return ", ".join(ordered)
    return ", ".join(ordered[:limit]) + f", +{len(ordered) - limit} more"


def main() -> int:
    args = parse_args()
    if args.mapped_only and args.unmapped_only:
        print("error: choose at most one of --mapped-only / --unmapped-only", file=sys.stderr)
        return 2

    repo_root = Path(__file__).resolve().parents[3]
    mapped_modules = load_replacement_map(repo_root)
    modules, unresolved_promotes = collect_module_stats(repo_root)

    total_modules = len(modules)
    mapped_count = sum(1 for module in modules if module in mapped_modules)
    unmapped_count = total_modules - mapped_count
    non_jmptbl_unmapped = sum(
        1
        for module, stats in modules.items()
        if module not in mapped_modules and stats.gcc_non_jmptbl_targets
    )

    print(f"promotion modules: {total_modules}")
    print(f"mapped modules: {mapped_count}")
    print(f"unmapped modules: {unmapped_count}")
    print(f"unmapped modules with non-JMPTBL gates: {non_jmptbl_unmapped}")
    print(f"replacement-map entries: {len(mapped_modules)}")
    if unresolved_promotes:
        print(f"unresolved promote scripts: {unresolved_promotes}")
    print()

    rows = []
    for module, stats in modules.items():
        if not should_show(module, mapped_modules, args):
            continue
        rows.append(
            (
                0 if module not in mapped_modules else 1,
                -len(stats.gcc_non_jmptbl_targets),
                -len(stats.sasc_non_jmptbl_entries),
                -len(stats.gcc_target_names),
                module,
                stats,
            )
        )

    rows.sort()
    if not args.all:
        rows = rows[: args.top]

    header = (
        f"{'status':7}  {'gcc_nonjmptbl':13}  {'sasc_nonjmptbl':14}  "
        f"{'gcc_total':9}  {'sasc_total':10}  {'module':48}  sample targets"
    )
    print(header)
    print("-" * len(header))
    for _, _, _, _, module, stats in rows:
        status = "mapped" if module in mapped_modules else "unmapped"
        print(
            f"{status:7}  {len(stats.gcc_non_jmptbl_targets):13d}  "
            f"{len(stats.sasc_non_jmptbl_entries):14d}  "
            f"{len(stats.gcc_target_names):9d}  {len(stats.sasc_entry_names):10d}  "
            f"{module:48}  "
            f"{format_samples(stats.gcc_non_jmptbl_targets or stats.sasc_non_jmptbl_entries or stats.gcc_target_names)}"
        )

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
