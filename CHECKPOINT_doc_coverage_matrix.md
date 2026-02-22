# Documentation/Renaming Coverage Matrix

Purpose: avoid duplicate passes by tracking which modules/functions already received header docs, control-flow label cleanup, and validation.

Last updated: 2026-02-21
Validation standard: `./test-hash.sh` hash match (`6bd4760d1cf0706297ef169461ed0d7b7f0b079110a78e34d89223499e7c2fa2`).

## Coverage Status

| Module/File | Scope Covered | Status | Last Pass | Notes / Remaining |
|---|---|---|---|---|
| `src/modules/groups/b/a/newgrid2.s` | Function headers + local control-flow clarity in `NEWGRID2_ProcessGridState`, `NEWGRID2_HandleGridState`, `NEWGRID2_DispatchGridOperation` | Complete (for current target scope) | 2026-02-21 | Keep only for future semantic discoveries; avoid another naming-only pass unless new understanding appears. |
| `src/modules/groups/b/a/newgrid1.s` | Local control-flow clarity in `NEWGRID_ProcessScheduleState` plus behavior docs expanded in scan helpers: `NEWGRID_FindNextEntryWithAltMarkers`, `NEWGRID_FindNextEntryWithMarkers`, `NEWGRID_FindNextEntryWithFlags` (compound gate paths, pointer/offset notes); trace-backed confirmation applied for `A0+56` as selector text/source pointer slot; confirmed fields now use `Struct_PrimaryEntry__*` / `Struct_TitleAuxRecord__*` symbols in traced paths | Complete (for current target scope) | 2026-02-21 | Revisit only if new traces change selector-metadata semantics. |
| `src/modules/groups/a/n/esqdisp.s` | Trace-backed title propagation path docs and struct-symbol adoption in `ESQDISP_PropagatePrimaryTitleMetadataToSecondary` (`Struct_PrimaryEntry__SelectionBitsetBase`, `Struct_TitleAuxRecord__SelectorFlagsByteBase`, `Struct_TitleAuxRecord__SelectorTextPtrBase`, `Struct_TitleAuxRecord__OwnedStringPtr`) | Complete (for current target scope) | 2026-02-21 | Revisit when wider title-record layouts are decoded beyond current offsets. |
| `src/modules/groups/b/a/newgrid.s` | Event loop clarity in `NEWGRID_ProcessGridMessages`; helper clarity in `NEWGRID_IsGridReadyForInput`, `NEWGRID_MapSelectionToMode`, `NEWGRID_ComputeDaySlotFromClock`, `NEWGRID_ComputeDaySlotFromClockWithOffset`, `NEWGRID_ShouldOpenEditor`, `NEWGRID_SelectNextMode`; optional helper polish completed in `NEWGRID_DrawClockFormatHeader` and `NEWGRID_DrawWrappedText` | Complete (for current target scope) | 2026-02-21 | Revisit only with new semantic findings or cross-file naming conflicts. |
| `src/modules/submodules/unknown7.s` | `STR_FindCharPtr` call-path docs tightened; legacy post-RTS scan block explicitly documented as unreachable (`STR_FindCharPtr_UnreachableLastMatchStub`) | Complete (for current target scope) | 2026-02-21 | If future traces show entry to the stub, promote to callable alias and document ABI/callers. |
| `src/data/wdisp.s` | Option-state aliases and major status/pointer clusters (`220F+`, `2242-226F` subset); `225E` documented as startup seed slot; `2256`/`226D`/`226E` notes tightened with concrete writer/reader-status caveats | Mostly complete | 2026-02-21 | Remaining confidence gaps are interpretive (intended role vs observed behavior) rather than missing callsites. |
| `src/Prevue.asm` (A4-negative globals) | Startup/stream alias range `-1120..-1024`, plus `-1144`, `-748`; confidence notes consolidated in prealloc-handle struct block (confirmed vs provisional fields) | Complete for current tranche | 2026-02-21 | Resume only with new cross-file evidence or runtime traces that refine ModeFlags/StateFlags semantics. |

## Re-pass Rules

1. Do not re-run naming-only sweeps on rows marked `Complete` unless:
   - new call-path evidence changes semantics, or
   - a conflicting name is found in another module.
2. For rows marked `Mostly complete` or `In progress`, work only the remaining note scope.
3. Every pass that edits labels/docs must append/update this matrix row and run `./test-hash.sh`.
4. If a pass is exploratory and makes no edits, add a short note under the row instead of opening a new row.

## Current Priority Queue

1. `wdisp.s`: only revisit `2256/226D/226E` if new runtime traces reveal additional producers/consumers.
2. `unknown7.s`: only revisit unreachable `STR_FindCharPtr_UnreachableLastMatchStub` if a real entry path is discovered.
3. `struct semantics`: refine unknown `Struct_PreallocHandleNode` flag-bit naming (`ModeFlags`/`StateFlags`) and open-flags masks when new runtime traces are available.
