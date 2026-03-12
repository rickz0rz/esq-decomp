You are continuing work in /Users/rj/Downloads/Git/github.com/rickz0rz/esq-decomp.

Project goal:
- Produce mostly equivalent C from the existing Amiga assembly/disassembly.
- The restored SAS/C-oriented C sources live in `src/decomp/sas_c`.
- `./sc-build-with-dis.sh <filename>.c` takes a filename from `src/decomp/sas_c` and emits matching `.o` and `.dis` files beside that source.
- Existing `src/decomp/sas_c` files are the reference style for new work.
- Overall scope includes the root `src/*.s` files, `src/Prevue.asm`, and everything under `src/interrupts/`, `src/data/`, and `src/modules/` recursively.

Important current state:
- Many existing SAS/C compare lanes are already populated; do not assume a missing decomp just because a target exists in `TARGETS.md`.
- Before writing code, inspect whether the target already exists in `src/decomp/sas_c` and whether it already has a `.dis`.
- Many checked `compare_sasc_*` lanes now have empty semantic diffs even when their raw asm diffs are still noisy from SAS/C scaffolding. Use the semantic diff, not the raw diff size, to decide whether a lane still needs tightening.
- Remaining work often means either:
  1. tightening an existing SAS/C file to better match the original assembly/disassembly, or
  2. creating a new `src/decomp/sas_c/*.c` file for a target that currently exists only as a GCC trial in `src/decomp/c/replacements`.
- Treat `*JMPTBL*` exports as likely compiler artifacts unless there is evidence they need separate handling.
- For now, avoid jump-table recreation work. Prefer direct calls to the real target from restored C unless a wrapper is strictly required for build glue or an existing validation lane.
- Keep `_main` work in scope. The `_main` wrappers/stubs have some coverage already; prefer spending time on behavior-heavy `_main` routines and tightening existing non-`JMPTBL` ports.

How to work:
1. Read `AGENTS.md`, `README.md`, and `src/decomp/README.md` first.
2. Inspect the repo before making assumptions.
3. Prefer a bounded non-`JMPTBL` target with an existing compare script under `src/decomp/scripts/`.
4. If a SAS/C file already exists, build it with `./sc-build-with-dis.sh <file>.c` and run its `compare_sasc_*` script or `run_sasc_core_sweep.sh --filter <substring>` before assuming it still needs code changes.
5. If only a GCC candidate exists, use `src/decomp/c/replacements/*_gcc.c` plus its compare script as the starting behavioral reference, but land the work in `src/decomp/sas_c` when appropriate.
6. When a restored C file currently calls a jump-table wrapper and the underlying target already exists and is callable, prefer simplifying it to a direct call.
7. Preserve “mostly equivalent” behavior: avoid cleanup or optimization unless required for equivalence.
8. Update any relevant documentation when you discover or clarify workflow/state.
9. After edits, run the narrowest useful validation first, then broader verification if applicable.

Execution preference:
- Do not stop at planning. Pick the next concrete decomp target, implement it, run the local validation workflow, and summarize what changed and what remains.
- Prefer continuing from existing in-progress areas before starting new broad sweeps, especially `_main` behavior code and existing SAS/C files that already compile but still need tightening.
