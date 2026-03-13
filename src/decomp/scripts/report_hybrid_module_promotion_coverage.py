#!/usr/bin/env python3
"""Report GCC promotion-lane coverage by original assembly module.

This correlates promote_*_target_gcc.sh scripts with their compare_*_trial_gcc.sh
scripts, resolves each compare lane back to its ORIG_ASM source module, and then
cross-checks that module against src/decomp/replacements.map.
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


@dataclass
class ModuleStats:
    compare_scripts: set[str] = field(default_factory=set)
    promote_scripts: set[str] = field(default_factory=set)
    target_names: set[str] = field(default_factory=set)
    non_jmptbl_targets: set[str] = field(default_factory=set)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Summarize GCC promotion-lane coverage by original asm module and "
            "show which modules are already wired into replacements.map."
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


def build_compare_module_index(scripts_dir: Path) -> dict[str, str]:
    index: dict[str, str] = {}

    for compare_path in scripts_dir.glob("compare_*_trial_gcc.sh"):
        content = compare_path.read_text()
        match = RE_ORIG_ASM.search(content)
        if match:
            index[compare_path.name] = match.group("path")

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
        stats.compare_scripts.add(compare_name)

        target_name = target_name_from_compare_script(compare_name)
        stats.target_names.add(target_name)
        if "jmptbl" not in target_name.lower():
            stats.non_jmptbl_targets.add(target_name)

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
        if module not in mapped_modules and stats.non_jmptbl_targets
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
                -len(stats.non_jmptbl_targets),
                -len(stats.target_names),
                module,
                stats,
            )
        )

    rows.sort()
    if not args.all:
        rows = rows[: args.top]

    header = (
        f"{'status':7}  {'nonjmptbl':10}  {'total':5}  {'module':48}  sample targets"
    )
    print(header)
    print("-" * len(header))
    for _, _, _, module, stats in rows:
        status = "mapped" if module in mapped_modules else "unmapped"
        print(
            f"{status:7}  {len(stats.non_jmptbl_targets):10d}  "
            f"{len(stats.target_names):5d}  {module:48}  "
            f"{format_samples(stats.non_jmptbl_targets or stats.target_names)}"
        )

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
