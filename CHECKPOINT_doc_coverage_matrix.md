# Documentation/Renaming Coverage Matrix

Purpose: avoid duplicate passes by tracking which modules/functions already received header docs, control-flow label cleanup, and validation.

Last updated: 2026-02-21
Validation standard: `./test-hash.sh` hash match (`6bd4760d1cf0706297ef169461ed0d7b7f0b079110a78e34d89223499e7c2fa2`).

## Coverage Status

| Module/File | Scope Covered | Status | Last Pass | Notes / Remaining |
|---|---|---|---|---|
| `src/modules/groups/b/a/newgrid2.s` | Function headers + local control-flow clarity in `NEWGRID2_ProcessGridState`, `NEWGRID2_HandleGridState`, `NEWGRID2_DispatchGridOperation` | Complete (for current target scope) | 2026-02-21 | Keep only for future semantic discoveries; avoid another naming-only pass unless new understanding appears. |
| `src/modules/groups/b/a/newgrid1.s` | Local control-flow clarity in `NEWGRID_ProcessScheduleState` plus prior helper cleanups | Mostly complete | 2026-02-21 | Minor branch-tail polish may remain; prioritize unknown behavior docs before another naming sweep. |
| `src/modules/groups/b/a/newgrid.s` | Event loop clarity in `NEWGRID_ProcessGridMessages`; helper clarity in `NEWGRID_IsGridReadyForInput`, `NEWGRID_MapSelectionToMode`, `NEWGRID_ComputeDaySlotFromClock`, `NEWGRID_ComputeDaySlotFromClockWithOffset`, `NEWGRID_ShouldOpenEditor`, `NEWGRID_SelectNextMode`; optional helper polish completed in `NEWGRID_DrawClockFormatHeader` and `NEWGRID_DrawWrappedText` | Complete (for current target scope) | 2026-02-21 | Revisit only with new semantic findings or cross-file naming conflicts. |
| `src/data/wdisp.s` | Option-state aliases and major status/pointer clusters (`220F+`, `2242-226F` subset) | Mostly complete | 2026-02-21 | Open unresolved offsets include `225E`; continue only where producer/consumer path is identified. |
| `src/Prevue.asm` (A4-negative globals) | Startup/stream alias range `-1120..-1024`, plus `-1144`, `-748` | Complete for current tranche | 2026-02-21 | Resume only with new cross-file evidence. |

## Re-pass Rules

1. Do not re-run naming-only sweeps on rows marked `Complete` unless:
   - new call-path evidence changes semantics, or
   - a conflicting name is found in another module.
2. For rows marked `Mostly complete` or `In progress`, work only the remaining note scope.
3. Every pass that edits labels/docs must append/update this matrix row and run `./test-hash.sh`.
4. If a pass is exploratory and makes no edits, add a short note under the row instead of opening a new row.

## Current Priority Queue

1. `newgrid1.s`: behavior-oriented docs for ambiguous helper tails before any extra renames.
2. `wdisp.s`: unresolved offsets (`225E` and related paths) once producer traces are confirmed.
3. `unknown7.s`: deeper behavior documentation around `UNKNOWN7_FindCharWrapper` call-path naming confidence.
