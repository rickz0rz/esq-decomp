# Verification Tracker — clean, trusted C

Goal: every C function proven equivalent to the original ASM (fix/rewrite where
it fails), verified against the ASM ground truth. Prior C is treated as an
UNVERIFIED DRAFT — trust nothing until it passes. Working the hot path first
(startup + per-frame VERTB), because that's what a running build needs correct
*and* where the current `AN_MemCorrupt` (8100 0005) crash lives.

Status legend: `TODO` unverified · `PASS` verified equivalent · `FIX` bug found+fixed
· `HARNESS` behaviorally verified via differential harness · `SKIP` not hot (cold path)

Verification method per function:
1. Read the original ASM (authority) and the current C side by side.
2. Check: same memory writes (offsets, counts, strides, sizes), same call
   sequence/args, same control flow, correct signedness/extension. These are the
   bug classes found so far (wrong counts, wrong offsets, sign errors, wrong
   alloc/free sizes, bad pointers).
3. Where isolatable, run the differential harness (`run_global_diff.sh` /
   `gen_leaf_diff.py`) for behavioral proof.
4. Verdict PASS / FIX. Re-verify after any fix. Record here.

## VERTB per-frame hot path (`ESQ_TickGlobalCounters` call tree — 17 fns)

| depth | function | status | notes |
|------:|----------|--------|-------|
| 0 | ESQ_TickGlobalCounters | TODO | VERTB body; clock-ptr writes + accumulator; reviewed, re-verify writes |
| 1 | ESQ_ColdReboot | SKIP | only on tick==0x5460 (~6h); cold path |
| 1 | ESQIFF_ServicePendingCopperPaletteMoves | PASS | copper-entry moves only, no heap write (audited 2026-07-14) |
| 1 | ESQSHARED4_TickCopperAndBannerTransitions | TODO | dispatcher; re-verify the ReadModeFlags branch ladder vs ASM |
| 2 | ESQ_MoveCopperEntryTowardEnd | PASS | shift-up copper digits; arg order/bounds/secondary-copy match ASM (audited 07-14)
| 2 | ESQ_MoveCopperEntryTowardStart | PASS | shift-down; arg order/bounds/conditions match ASM (audited 07-14)
| 2 | ESQSHARED4_BlitBannerRowsForActiveField | PASS | dispatcher; leaves verified (audited) |
| 2 | ESQSHARED4_ProgramDisplayWindowAndCopper | FIX | **BUG FOUND+FIXED**: DDFSTRT/DDFSTOP hardcoded 0x38/0xD0 (std lores) instead of DDFSTRT_WIDE/DDFSTOP_WIDE = 0x30/0xD8 (wide overscan) → wrong DMA fetch window → the visual corruption. Rest of the fn (DIW/mod/copper ptr words/DMACON) matches ASM. |
| 2 | GCOMMAND_TickHighlightState | TODO | highlight tick (memory's prior suspect) |
| 2 | SCRIPT_UpdateBannerCharTransition | PASS | scroll-offset only, no raster write (audited) |
| 3 | ESQSHARED4_CopyBannerRowsWithByteOffset | PASS | 16+1 rows × (word+17 longs); 18→17 fix present (audited) |
| 3 | ESQSHARED4_CopyInterleavedRowWordsFromOffset | PASS | 16+1 three-word blocks (audited) |
| 3 | ESQSHARED4_LoadDefaultPaletteToCopper_NoOp | TODO | name implies no-op; verify |
| 3 | GCOMMAND_AdjustBannerCopperOffset | TODO | banner scroll copper offset |
| 3 | GCOMMAND_GetBannerChar | TODO | banner char source (scales with content) |
| 4 | ESQSHARED4_LoadCopperColorWordsFromNibbleTable | PASS | 8-iter loop, offset+=4, banner/tail special-cases match ASM (audited 07-14)
| 5 | ESQSHARED4_DecodeRgbNibbleTriplet | HARNESS | verified equivalent via differential harness |

Also verified this session (not in this tree, banner setup): ComputeBannerRowBlitGeometry (PASS),
ClearBannerWorkRasterWithOnes (PASS), BindAndClearBannerWorkRaster (PASS),
CopyLivePlanesToSnapshot (HARNESS), CopyPlanesFromContextToSnapshot (HARNESS),
banner raster allocation sizes in ESQ_MainInitAndRun (PASS: 696×509/241/15/2, +0x5C20).
