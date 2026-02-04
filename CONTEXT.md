# Current Work Context

## Build State
- Latest `./test-hash.sh` run matches the canonical hash `6bd4760d1cf0706297ef169461ed0d7b7f0b079110a78e34d89223499e7c2fa2DST_CallJump_066F
- Run `./test-hash.sh` after each batch of label renames; the script assembles with `-nosym` and removes the temporary output automatically.
- Tooling assumes vasm 68k is installed under `~/Downloads/vasm/`; adjust `build.sh` and `test-hash.sh` if your local path differs.

## Active Refactor Threads
- `src/modules/groups/a/s/gcommand.s` now has descriptive local labels and option-parsing comments for the command/mplex/PPV routines. The older `src/modules/gcommand.s` sweep remains the reference for broader banner/preset renames. Key helpers from that pass include:
  - Banner/preset pipeline: `GCOMMAND_ComputePresetIncrement`, `GCOMMAND_ResetPresetWorkTables`, `GCOMMAND_InitPresetWorkEntry`, `GCOMMAND_LoadPresetWorkEntries`, `GCOMMAND_TickPresetWorkEntries`, `GCOMMAND_RebuildBannerTablesFromBounds`, `GCOMMAND_UpdateBannerRowPointers`, `GCOMMAND_BuildBannerRow`, `GCOMMAND_RefreshBannerTables`, `GCOMMAND_ClearBannerQueue`.
  - Banner queue/message loop: `GCOMMAND_ConsumeBannerQueueEntry`, `GCOMMAND_ServiceHighlightMessages`.
  - Banner build helpers: `GCOMMAND_BuildBannerBlock`, `GCOMMAND_CopyImageDataToBitmap`, `GCOMMAND_BuildBannerTables`, `GCOMMAND_UpdateBannerOffset`.
  - Jump stubs: `GCOMMAND_JMPTBL_LAB_071A`, `GCOMMAND_JMPTBL_LAB_071B`, `GCOMMAND_JMPTBL_DOS_SystemTagList`, `GROUP_AU_JMPTBL_BRUSH_AppendBrushNode`.
  - Control command hook: `GCOMMAND_ProcessCtrlCommand` (used by `ESQ_InvokeGcommandInit`).
- Associated data tables in `src/data/wdisp.s` still carry anonymous `LAB_22F*` symbols. Many are now annotated as likely switch/jump tables; name them as their purpose becomes clear during gcommand work (e.g., highlight flag tables, banner presets).
- `src/modules/newgrid.s` remains largely unaliased with raw `LAB_` labels; new splits (`newgrid1.s`, `newgrid2.s`) should follow the same naming pass once the gcommand/wdisp path settles.
- `src/ESQ.asm` is in progress: core init, serial CTRL/RBF handling, and jump stubs are renamed and documented; banner helper names were added (e.g., `ESQ_AdvanceBannerCharIndex`, `ESQ_GenerateXorChecksumByte`). Continue adding header blocks/aliases after the CTRL buffer routines and audit remaining orphaned helpers/data.
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
2. Revisit `src/data/wdisp.s` to formalize `LAB_22F*` table names now that the gcommand banner/preset path is named.
3. Schedule an alias/comment sweep for `src/modules/newgrid.s` and its related tables once the UI naming stabilizes.
4. Propagate new names to all call sites across `src/modules/`, `src/subroutines/`, and `src/data/` as you touch adjacent systems.
5. Re-run `./test-hash.sh` and capture the output hash in commit or PR notes for traceability.
