# Current Work Context

## Build State
- Latest `./test-hash.sh` run matches the canonical hash `6bd4760d1cf0706297ef169461ed0d7b7f0b079110a78e34d89223499e7c2fa2`.
- Run `./test-hash.sh` after each batch of label renames; the script assembles with `-nosym` and removes the temporary output automatically.
- Tooling assumes vasm 68k is installed under `~/Downloads/vasm/`; adjust `build.sh` and `test-hash.sh` if your local path differs.

## Active Refactor Threads
- `src/modules/groups/a/s/gcommand.s` now has descriptive local labels and option-parsing comments for the command/mplex/PPV routines. The older `src/modules/gcommand.s` sweep remains the reference for broader banner/preset renames. Key helpers from that pass include:
  - Banner/preset pipeline: `GCOMMAND_ComputePresetIncrement`, `GCOMMAND_ResetPresetWorkTables`, `GCOMMAND_InitPresetWorkEntry`, `GCOMMAND_LoadPresetWorkEntries`, `GCOMMAND_TickPresetWorkEntries`, `GCOMMAND_RebuildBannerTablesFromBounds`, `GCOMMAND_UpdateBannerRowPointers`, `GCOMMAND_BuildBannerRow`, `GCOMMAND_RefreshBannerTables`, `GCOMMAND_ClearBannerQueue`.
  - Banner queue/message loop: `GCOMMAND_ConsumeBannerQueueEntry`, `GCOMMAND_ServiceHighlightMessages`.
  - Banner build helpers: `GCOMMAND_BuildBannerBlock`, `GCOMMAND_CopyImageDataToBitmap`, `GCOMMAND_BuildBannerTables`, `GCOMMAND_UpdateBannerOffset`.
  - Jump stubs: `GCOMMAND_JMPTBL_ED1_WaitForFlagAndClearBit1`, `GCOMMAND_JMPTBL_ED1_WaitForFlagAndClearBit0`, `GCOMMAND_JMPTBL_DOS_SystemTagList`, `GROUP_AU_JMPTBL_BRUSH_AppendBrushNode`.
  - Control command hook: `GCOMMAND_ProcessCtrlCommand` (used by `ESQ_InvokeGcommandInit`).
- The former anonymous Niche/Mplex/PPV globals in `src/data/wdisp.s` now have semantic aliases across `22D*`, `22E*`, and `22F*` fields (workflow/detail flags, mode-cycle/search params, showtimes row span, pen/layout params, and preset work-entry aliases), with legacy labels retained underneath.
- `src/modules/groups/b/a/newgrid.s` and `src/modules/groups/b/a/newgrid1.s` received local-label cleanup in the mode-selection and pen-selection dispatch blocks (descriptive local names plus duplicate local-label removal in switch/branch glue).
- `src/modules/groups/b/a/newgrid2.s` now has improved header/comment coverage across the state/dispatch wrappers (`NEWGRID2_HandleGridState`, `NEWGRID2_DispatchGridOperation`, buffer alloc/free helpers) plus standardized jump-stub header semantics (forwarded args/returns, corrected target-call names).
- `src/modules/groups/a/o/esqpars.s` now has clearer local control-flow labels and better header semantics in early string/group cleanup helpers (`ESQPARS_ClearAliasStringPointers`, `ESQPARS_RemoveGroupEntryAndReleaseStrings`, `ESQPARS_ReplaceOwnedString`), replacing legacy `.lab_0B3*`/`.branch_*` naming in that region.
- `src/data/wdisp.s` picked up additional editor/system aliases through `220E` (`ED_EditBufferScratchShiftBase`, `ED_EditBufferLiveShiftBase`, `ED_AdNumberInputDigitTens`, `ED_AdNumberInputDigitOnes`, `ED_MaxAdNumber`, `ED_CursorColumnIndex`, `ED_ActiveIndicatorCachedState`, `ESQ_StartupStateWord2203`, `ESQ_StartupVersionBannerBuffer`, `ESQ_TickModulo60Counter`, `ESQIFF_UseCachedChecksumFlag`, `ESQSHARED_LivePlaneBase0..2`, `ESQSHARED_DisplayContextPlaneBase0..4`) with callsite propagation in `ed.s`, `ed1.s`, `ed3.s`, `esq.s`, `esqshared4.s`, and `app2.s`.
- `src/modules/groups/a/a/bitmap.s` now has descriptive local labels throughout `BITMAP_ProcessIlbmImage` (chunk dispatch/read/seek paths), replacing opaque `.lab_00EF`-style flow labels.
- `src/ESQ.asm` is in progress: core init, serial CTRL/RBF handling, and jump stubs are renamed and documented; banner helper names were added (e.g., `ESQ_AdvanceBannerCharIndex`, `ESQ_GenerateXorChecksumByte`). Continue adding header blocks/aliases after the CTRL buffer routines and audit remaining orphaned helpers/data.
- `src/modules/groups/a/m/esq.s` now has deeper startup-population annotations around `ESQ_MainInitAndRun` (argv select-code copy, startup version banner formatting, raster alias seeding, and early startup render calls). A detailed population/risk trace now includes both destination size budgets and an explicit startup `WDISP_SPrintf` headroom audit table in `CHECKPOINT_layout_coupling_population.md`.
- Non-startup formatter audit has started across `ED*`, `ESQFUNC`, and `TEXTDISP`: key `WDISP_SPrintf` callsites now include destination-capacity notes (stack-buffer sizes and `%s`/numeric risk context), and `CHECKPOINT_layout_coupling_population.md` now has a consolidated non-startup destination table.
- Provenance tracing is now documented for high-risk `%s` arguments (`ED2_*`, `TEXTDISP_HandleScriptCommand`, `ESQFUNC_DrawDiagnosticsScreen`) with concrete no-op guard insertion candidates in `CHECKPOINT_layout_coupling_population.md` section `5.9`.
- `CHECKPOINT_layout_coupling_population.md` section `5.10` now includes a row-by-row conservative byte budget for `ESQFUNC_DrawDiagnosticsScreen` (`-132(A5)`), with ranked guard-first priorities (`P0`/`P1`/`P2`).
- `CHECKPOINT_layout_coupling_population.md` section `5.11` now maps `ESQFUNC_DrawDiagnosticsScreen` high-risk rows (`P0`..`P2`) to concrete population writers (SCRIPT3/ED2/TEXTDISP2/LOCAVAIL/PARSEINI/CLEANUP/APP2) and records per-row return-length probe insertion order.
- `src/data/wdisp.s` now aliases previously anonymous diagnostics/clock fields (`CLOCK_Cache*`, `CLOCK_CacheAmPmFlag`, `LOCAVAIL_PrimaryFilterState_Field08/0C/10/14`, `LOCAVAIL_FilterCooldownTicks`), and `src/modules/groups/a/n/esqfunc.s` now uses those aliases with inline provenance comments.
- `CHECKPOINT_layout_coupling_population.md` section `5.12` now adds row-level budget/source mapping for high-risk `ED2`/`TEXTDISP` `%s` rows (`E0`/`E1`/`T0` priorities), including concrete payload-threshold formulas and guard-first order.
- `src/data/script.s` now aliases `DATA_SCRIPT_BSS_LONG_2129` as `SCRIPT_CommandTextPtr`; `script3.s` callsites in the text-display command/context paths now use the alias, and `textdisp.s` cmd-`C` notes include parser-bound budget context for `"xx%s"` into the 200-byte local buffer.
- `CHECKPOINT_layout_coupling_population.md` sections `5.13`-`5.14` cover the `220F+` and `2242`-`226F` alias passes; section `5.15` now traces `226D/226E` producers and confirms the unbounded `argv[1]` copy into `ESQ_SelectCodeBuffer` as an indirect clobber path into `Global_REF_BAUD_RATE`/`226D`/`226E`.
- Highlight cursor update helper was relocated: `KYBD_UpdateHighlightState` now lives in `src/modules/ladfunc.s` as `LADFUNC_UpdateHighlightState` (callers updated).

## Documentation Touchpoints
- `AGENTS.md` now captures module layout, naming conventions (`MODULE_ActionVerb` aliases), and the expected hash workflow. Keep it updated as you clarify additional modules.
- `README.md` summarizes the current build steps and structure (including asset paths and `src/decomp/`); update it if the layout or policies change.
- The recent module split also introduced new numbered companions (`disptext2.s`, `script2.s`–`script4.s`, etc.); keep the build include list aligned with the on-disk structure.
- Alignment/jump-table boundaries: padding after jump stubs is a useful heuristic for file/object boundaries, but it is not definitive and can appear mid-file for alignment.
- `src/modules/groups/a/j/dst2.s` and `src/modules/groups/a/j/dst.s` now have descriptive local labels and inline comments around banner queue updates and allocation paths.
- A4-based globals are being migrated to named symbols in `src/Prevue.asm` (e.g., `Global_SavedDirLock`, `Global_CommandLineSize`) and reused across modules for clarity.
- Recent A4 migrations include signal/IO globals (`Global_SignalCallbackPtr`, `Global_DosIoErr`), handle-table state, and the A4 char-class table (`Global_CharClassTable`).
- Positive A4 offsets are now named too (e.g., `Global_HandleTableBase`, `Global_PrintfBufferPtr`, `Global_ArgCount`), replacing raw `22492(A4)`/`22828(A4)` usage.

## Suggested Next Steps
1. Keep pushing through `src/ESQ.asm`, adding header blocks/aliases after the CTRL/RBF routines and documenting any orphaned helpers/data blocks.
2. Continue `src/data/wdisp.s` naming for remaining anonymous/non-`GCOMMAND_*` blocks outside the completed `22D*`/`22E*`/`22F*` option-state ranges and the newly-aliased editor/system cluster (`21F1`-`220E`; `220F` and adjacent spans still unresolved).
3. Continue NEWGRID local-label clarity passes focused on unresolved helper flow in `newgrid2.s` (dispatch/state comments are now in better shape; label naming still has room to improve).
4. Propagate new names to all call sites across `src/modules/`, `src/subroutines/`, and `src/data/` as you touch adjacent systems.
5. Re-run `./test-hash.sh` and capture the output hash in commit or PR notes for traceability.
