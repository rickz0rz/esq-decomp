You are continuing work in `/Users/rj/Downloads/esq-asm`.

## Objective

Advance the Amiga assembly restoration by producing mostly equivalent SAS/C-style C and integrating that work into the hybrid build without breaking the maintained baseline.

## Read First

Before changing code, read:

1. `AGENTS.md`
2. `README.md`
3. `src/decomp/README.md`

Treat those files as the live source of project status. Do not rely on older checkpoint notes or copied status summaries.

## Ground Rules

- The main restored C sources live in `src/decomp/sas_c/`.
- Run `./sc-build-with-dis.sh <filename>.c` only for files that already exist in `src/decomp/sas_c/`.
- Existing `src/decomp/sas_c/*.c` files are the style guide for new decomp work.
- Prefer canonical SAS/C headers from `/Users/RJ/Downloads/SAS-C-hdd/sc/include` when they match the real AmigaOS layout.
- Do not reintroduce local duplicate definitions for standard types such as `RastPort`, `TextFont`, `BitMap`, `MinList`, `MsgPort`, `Message`, `IOStdReq`, or `Library` when shipped SAS/C headers already cover them.
- Keep local overlay structs only where the code truly depends on nonstandard cached or overlaid fields. The known active exceptions are:
  - `src/decomp/sas_c/cleanup_draw_grid_time_banner.c`
  - `src/decomp/sas_c/render_short_month_short_day_of_week_day.c`
- Treat `*JMPTBL*` exports as probable compiler artifacts unless there is evidence they need separate handling.
- Prefer direct calls to the real target over recreating jump-table wrappers unless a wrapper is required for build glue or an existing validation lane.
- Preserve behavior. Do not clean up, optimize, or reorganize code unless equivalence requires it.

## Roadmap

Work toward the full C application in this order:

1. Restore behaviorally equivalent SAS/C functions and small modules.
   Validate them with the narrowest compare lane available, semantic filters, and compiled C disassembly checks against the original assembly.
2. Consolidate those restored functions into module-level hybrid replacements.
   The current build is still hybrid, so this integration stage is the main bridge between isolated decomp wins and a full C executable.
3. As restored coverage grows, normalize shared interfaces.
   Centralize external variables, shared structs, and function declarations in reusable headers or common declarations where that improves correctness and integration.
4. After enough module coverage is stable, build toward a true full-program C link.
   The end goal is a functioning C application that matches the assembly behavior, but do not skip the hybrid integration stage to chase whole-program linking too early.

## Working Plan

1. Inspect the current checkout before choosing work.
2. Confirm the maintained SAS/C baseline is still green in this checkout.
3. If a target already exists in `src/decomp/sas_c/`, rebuild and compare it before assuming it still needs work.
4. If the maintained baseline is green, choose the next task from one of these two buckets:
   - tighten an existing SAS/C port whose semantic coverage still needs work
   - promote already-covered restored code into module-level hybrid replacement coverage
5. Make the narrowest change that improves equivalence or replacement coverage.
6. Re-run the relevant target compare script or sweep.
7. Reconfirm the maintained baseline after the change.
8. Update docs if the workflow, validation expectations, or project state materially changed.

## How To Choose Work

Prefer this order:

1. Keep the maintained SAS/C baseline green.
2. With the baseline green, prioritize module-level hybrid replacement progress over isolated wrapper work.
3. Only add brand-new SAS/C targets when existing ports and integration opportunities are not the better next step.

Useful checks:

- If a SAS/C file already exists, run its `compare_sasc_*` script or a filtered `run_sasc_core_sweep.sh` pass before editing.
- If only a GCC version exists under `src/decomp/c/replacements`, use it as behavioral reference, but land new work in `src/decomp/sas_c` when appropriate.
- Use semantic diffs, not raw diff size alone, to judge whether a lane still needs tightening.
- Use `src/decomp/scripts/report_passthrough_integration_candidates.py` to find replacement-ready module boundaries that are still asm passthroughs.

## Validation Expectations

- For local function work, run the narrowest relevant compare/build script first.
- For broader verification, use `run_sasc_core_sweep.sh --strict` and relevant `--filter` reruns.
- Treat a green maintained sweep as the required baseline before starting broader triage or more integration work.
- Keep `decomp-build.sh` and the overall project build hash-stable while replacement coverage grows.
- Run `./test-hash.sh` only when your change modifies assembly-side files or otherwise affects the integrated assembly build. If you only edited C decomp files, do not run it.

## Scope Reminder

The long-term target includes the root `src/*.s` files, `src/Prevue.asm`, and everything under `src/interrupts/`, `src/data/`, and `src/modules/` recursively.

The project is still a hybrid build. `decomp-build.sh` is not yet a pure SAS/C full-program pipeline, so favor work that increases replacement coverage cleanly and safely while preparing the eventual full-C link path.
