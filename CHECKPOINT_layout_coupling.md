# Layout-Coupling Checkpoint

Date: 2026-02-12

## Current Goal
Document and isolate places where apparent string labels are actually used as table/record anchors, without changing runtime behavior.

## What Was Completed
- Identified and documented high-risk layout-coupled anchor patterns.
- Kept code behavior unchanged (canonical hash preserved).
- Added explicit alias labels for hidden pointer-table regions in data files.
- Added inline callsite comments where indexed address math uses those anchors.

## Verified Build State
- `./test-hash.sh` run after changes.
- Current hash: `6bd4760d1cf0706297ef169461ed0d7b7f0b079110a78e34d89223499e7c2fa2`
- Matches canonical hash.

## Files Changed (Behavior-Preserving)
- `src/data/esqfunc.s`
- `src/data/ctasks.s`
- `src/data/script.s`
- `src/modules/groups/a/n/esqiff.s`
- `src/modules/groups/b/a/wdisp.s`
- `src/modules/groups/a/g/diskio.s`
- `src/modules/groups/a/d/cleanup3.s`
- `src/modules/groups/b/a/textdisp.s`

## Data-Side Alias Labels Added
- `ESQFUNC_PwBrushNamePtrTable` at `src/data/esqfunc.s`
- `CTASKS_TerminationReasonPtrTable` at `src/data/ctasks.s`
- `SCRIPT_ChannelLabelPtrTable` at `src/data/script.s`

## Callsite Comments Added (Layout-Coupled Anchors)
- `src/modules/groups/a/n/esqiff.s`
- `src/modules/groups/b/a/wdisp.s` (3 callsites)
- `src/modules/groups/a/g/diskio.s`
- `src/modules/groups/a/d/cleanup3.s`
- `src/modules/groups/b/a/textdisp.s`

## Confirmed High-Risk Anchor Patterns
- `ESQFUNC_STR_I5_1EDD` used as base for indexed longword lookup (`index * 4`).
- `CTASKS_TerminationReasonPtrTable` used as base for indexed longword lookup.
- `SCRIPT_STR_TUESDAYS_FRIDAYS_20ED` used as base for indexed longword lookup.

## Important Decisions Made
- Reverted earlier index-normalization runtime edits because they changed behavior/hash.
- Kept only documentation/alias changes in this checkpoint.

## Next Work Recommended
1. Produce a compact report of all obvious offset-based address calculations:
   - `LEA label,A*` followed by nonzero `<offset>(A*)`
   - `ASL #2` + `ADDA` + `MOVE.L (A0)` patterns
   - `labelA-labelB` delta expressions
2. For each suspicious anchor, classify as:
   - explicit/intentional table
   - legacy hidden table anchor
   - struct-field offset usage
3. Where safe, add alias symbols only (no opcode changes) for hidden table anchors.
4. Keep running `./test-hash.sh` after each logical batch.

## Notes
- There is an untracked `scripts/` path in working tree (`?? scripts/`) that was present during this session and left untouched.
- Population/writer trace continuation is tracked in `CHECKPOINT_layout_coupling_population.md`.
- `CHECKPOINT_layout_coupling_population.md` now includes `ESQFUNC_DrawDiagnosticsScreen` conservative budget/provenance detail in sections `5.10` and `5.11` (including `P0`/`P1`/`P2` guard priority and writer-map notes), plus `ED2`/`TEXTDISP` row-level `%s` budget/source mapping in section `5.12`, `wdisp.s` `220F+` pointer-state alias mapping in section `5.13`, `wdisp.s` `2242`-`226F` alias/status-state mapping in section `5.14`, explicit `226D/226E` producer tracing (including `argv[1]` overflow path) in section `5.15`, and A4 prealloc-handle refinement in sections `5.16` and `5.17`.
- Follow-on annotation work after this checkpoint added non-behavioral editor/system aliases in `src/data/wdisp.s` (`21F1`-`220E` cluster) and propagated selected callsites in ED/ESQ modules.
- Follow-on annotation work also resumed A4-negative global naming in `src/Prevue.asm` and submodules: startup preallocated handle-node cluster (`-1120..-1024`), stream buffer allocation size (`-748`), and first tracked memlist allocation node (`-1144`), documented in `CHECKPOINT_layout_coupling_population.md` section `5.16`.
