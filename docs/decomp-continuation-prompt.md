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
- Current triage note (March 13, 2026): `src/decomp/scripts/list_missing_sasc_non_jmptbl_exports.py` currently prints no rows in this checkout, so do not assume a non-`JMPTBL` GCC trial is still missing from `src/decomp/sas_c` without checking first.
- Current maintained-sweep note (re-validated locally on March 13, 2026 in this checkout): the previously reported maintained-sweep blockers are already green here. Targeted `run_sasc_core_sweep.sh --strict --filter ...` reruns for `string_append_at_null`, `newgrid_init_grid_resources`, `cleanup_build_and_render_aligned_status_banner`, `cleanup_render_aligned_status_screen`, and `diskio1_dump_default_coi_info_block` all currently produce zero-byte semantic diffs, and `compare_sasc_diskio1_dump_default_coi_info_block_trial.sh` compiles successfully.
- Current broader-triage note (March 13, 2026, later re-validated): the maintained baseline is green, and the previously listed out-of-sweep semantic diffs in `disptext_is_current_line_last`, `disptext_is_last_line_selected`, and `newgrid_update_grid_state` also now resolve to zero-byte semantic diffs in this checkout. Re-triage broader SAS/C mismatch work from fresh sweep output instead of reusing that older short list.
- Current hybrid-integration note (March 13, 2026): `modules/groups/a/a/app.s` is now seeded in `src/decomp/replacements.map` as a passthrough hybrid boundary. Treat the APP serial/control helper cluster as integration-ready at the module boundary, even though the replacement file still includes the canonical asm module verbatim for now.
- Current hybrid-integration note (March 13, 2026): `modules/groups/a/u/gcommand3.s` is now seeded in `src/decomp/replacements.map` as a passthrough hybrid boundary. Treat the GCOMMAND3 banner/highlight helper cluster as integration-ready at the module boundary, even though the replacement file still includes the canonical asm module verbatim for now.
- Current hybrid-integration note (March 13, 2026, later re-validated): `modules/groups/b/a/parseini.s` is now seeded in `src/decomp/replacements.map` as a passthrough hybrid boundary. Treat the PARSEINI config/weather/font helper cluster as integration-ready at the module boundary, even though the replacement file still includes the canonical asm module verbatim for now.
- Current hybrid-integration note (March 13, 2026, later re-validated): `modules/groups/a/w/ladfunc.s` is now seeded in `src/decomp/replacements.map` as a passthrough hybrid boundary. Treat the LADFUNC text-ad/highlight helper cluster as integration-ready at the module boundary, even though the replacement file still includes the canonical asm module verbatim for now.
- Remaining work often means either:
  1. tightening an existing SAS/C file to better match the original assembly/disassembly, or
  2. creating a new `src/decomp/sas_c/*.c` file for a target that currently exists only as a GCC trial in `src/decomp/c/replacements`.
- The broader build-integration project is still ahead of the function-level decomp work. `decomp-build.sh` is still a hybrid assembly build driven by `src/decomp/replacements.map`, not a full pure-SAS/C executable pipeline.
- Treat `*JMPTBL*` exports as likely compiler artifacts unless there is evidence they need separate handling.
- For now, avoid jump-table recreation work. Prefer direct calls to the real target from restored C unless a wrapper is strictly required for build glue or an existing validation lane.
- Keep `_main` work in scope. The `_main` wrappers/stubs have some coverage already; prefer spending time on behavior-heavy `_main` routines and tightening existing non-`JMPTBL` ports.

How to work:
1. Read `AGENTS.md`, `README.md`, and `src/decomp/README.md` first.
2. Inspect the repo before making assumptions.
3. Before starting any new target, confirm the maintained SAS/C baseline is still green in the current checkout. Do not assume older March 13 notes are still current.
4. If a SAS/C file already exists, build it with `./sc-build-with-dis.sh <file>.c` and run its `compare_sasc_*` script or `run_sasc_core_sweep.sh --filter <substring>` before assuming it still needs code changes.
5. After local target fixes, rerun the maintained sweep. Treat `run_sasc_core_sweep.sh --strict` with zero compare-script failures and zero non-empty semantic diffs as the required baseline before broader reruns.
6. With the maintained sweep green, prefer either:
   - fresh broader SAS/C mismatch reduction based on current non-empty semantic diffs from new sweep output, or
   - module-level build integration work that increases hybrid replacement coverage.
7. If only a GCC candidate exists, use `src/decomp/c/replacements/*_gcc.c` plus its compare script as the starting behavioral reference, but land the work in `src/decomp/sas_c` when appropriate.
8. When a restored C file currently calls a jump-table wrapper and the underlying target already exists and is callable, prefer simplifying it to a direct call.
9. Preserve “mostly equivalent” behavior: avoid cleanup or optimization unless required for equivalence.
10. Update any relevant documentation when you discover or clarify workflow/state, especially when local validation disproves older March 13, 2026 notes.
11. After the maintained SAS/C lane is green, shift priority from isolated function ports to build integration:
   - consolidate restored SAS/C functions into replacement-ready module/object boundaries
   - expand hybrid replacement coverage module by module
   - keep `decomp-build.sh` hash-stable while replacement coverage grows
   - only then plan a true whole-program SAS/C build/link path

Execution preference:
- Do not stop at planning. Start from the currently verified state in the checkout, not from stale blocker notes.
- Prefer keeping the maintained SAS/C baseline green before starting new broad sweeps or new target families.
- Once the maintained sweep is green, prefer work that increases module-level replacement/build coverage over adding more isolated wrapper ports.
