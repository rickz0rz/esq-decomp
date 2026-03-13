#!/usr/bin/env python3
"""
List GCC replacement exports that do not appear anywhere under src/decomp/sas_c.

This is a triage helper for the decomp workflow. It scans non-JMPTBL GCC trial
files for their primary `__attribute__((noinline, used))` export, then checks
whether that exact symbol appears in the restored SAS/C lane.
"""

from __future__ import annotations

import argparse
import pathlib
import re
import subprocess
import sys


DECL_RE = re.compile(
    r"^(?:[A-Za-z_][\w\s\*]*\s+)?(?P<name>[A-Za-z_][A-Za-z0-9_]*)\s*"
    r"\([^;]*\)\s*__attribute__\(\(noinline, used\)\);"
)


def iter_gcc_exports(root: pathlib.Path) -> list[tuple[str, str]]:
    exports: list[tuple[str, str]] = []

    for path in sorted((root / "src/decomp/c/replacements").glob("*_gcc.c")):
        if "jmptbl" in path.name.lower():
            continue

        with path.open("r", encoding="utf-8", errors="ignore") as infile:
            for line in infile:
                match = DECL_RE.match(line.strip())
                if match is not None:
                    exports.append((match.group("name"), path.name))
                    break

    return exports


def has_sasc_hit(root: pathlib.Path, symbol: str) -> bool:
    result = subprocess.run(
        ["rg", "-q", "-w", symbol, str(root / "src/decomp/sas_c")],
        check=False,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    return result.returncode == 0


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--root",
        default=pathlib.Path(__file__).resolve().parents[3],
        type=pathlib.Path,
        help="Repository root. Defaults to the current checkout root.",
    )
    args = parser.parse_args()

    missing: list[tuple[str, str]] = []
    for symbol, source_name in iter_gcc_exports(args.root):
        if not has_sasc_hit(args.root, symbol):
            missing.append((symbol, source_name))

    for symbol, source_name in missing:
        print(f"{symbol}\t{source_name}")

    return 0 if not missing else 1


if __name__ == "__main__":
    sys.exit(main())
