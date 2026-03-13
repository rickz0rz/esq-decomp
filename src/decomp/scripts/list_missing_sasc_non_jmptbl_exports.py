#!/usr/bin/env python3
"""
List GCC replacement exports that are still missing from the restored SAS/C lane.

This triage helper scans non-JMPTBL GCC trial files for their primary
`__attribute__((noinline, used))` export, then checks whether that symbol has
an actual function definition under `src/decomp/sas_c/`.

The older exact-word check was useful early on, but it now produces false
coverage from `extern` declarations and caller references. The current default
therefore reports missing definitions, with an optional refs-only mode for
workflow audits.
"""

from __future__ import annotations

import argparse
import pathlib
import re
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


def collect_sasc_text(root: pathlib.Path) -> str:
    chunks: list[str] = []

    for path in sorted((root / "src/decomp/sas_c").glob("*.c")):
        chunks.append(path.read_text(encoding="utf-8", errors="ignore"))

    return "\n".join(chunks)


def has_sasc_word_hit(sasc_text: str, symbol: str) -> bool:
    return re.search(rf"\b{re.escape(symbol)}\b", sasc_text) is not None


def has_sasc_definition(sasc_text: str, symbol: str) -> bool:
    return re.search(
        rf"\b{re.escape(symbol)}\s*\([^;{{}}]*\)\s*\{{",
        sasc_text,
        re.MULTILINE | re.DOTALL,
    ) is not None


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--root",
        default=pathlib.Path(__file__).resolve().parents[3],
        type=pathlib.Path,
        help="Repository root. Defaults to the current checkout root.",
    )
    parser.add_argument(
        "--mode",
        choices=("defs", "refs", "all"),
        default="defs",
        help=(
            "defs: list exports missing real SAS/C definitions (default). "
            "refs: list exports with only reference hits. "
            "all: include both categories."
        ),
    )
    args = parser.parse_args()

    sasc_text = collect_sasc_text(args.root)
    rows: list[tuple[str, str, str]] = []
    for symbol, source_name in iter_gcc_exports(args.root):
        has_def = has_sasc_definition(sasc_text, symbol)
        has_ref = has_sasc_word_hit(sasc_text, symbol)

        if args.mode == "defs":
            if not has_def:
                rows.append(("missing_def", symbol, source_name))
            continue

        if args.mode == "refs":
            if has_ref and not has_def:
                rows.append(("refs_only", symbol, source_name))
            continue

        if not has_def:
            status = "refs_only" if has_ref else "missing_def"
            rows.append((status, symbol, source_name))

    for status, symbol, source_name in rows:
        if args.mode == "all":
            print(f"{status}\t{symbol}\t{source_name}")
        else:
            print(f"{symbol}\t{source_name}")

    return 0 if not rows else 1


if __name__ == "__main__":
    sys.exit(main())
