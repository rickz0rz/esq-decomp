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
- `DATA_ESQFUNC_STR_I5_1EDD` used as base for indexed longword lookup (`index * 4`).
- `CTASKS_STR_TERM_DL_TOO_LARGE_TAIL` used as base for indexed longword lookup.
- `DATA_SCRIPT_STR_ESDAYS_FRIDAYS_20ED` used as base for indexed longword lookup.

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
