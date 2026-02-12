# Template Pointer NULL-Guard Audit

Date: 2026-02-12

## Scope
Audited dereference paths for:
- `GCOMMAND_DigitalNicheListingsTemplatePtr`
- `GCOMMAND_MplexListingsTemplatePtr`
- `GCOMMAND_MplexAtTemplatePtr`
- `GCOMMAND_PPVListingsTemplatePtr`
- `GCOMMAND_PPVPeriodTemplatePtr`

Across:
- `src/modules/groups/a/s/gcommand.s`
- `src/modules/groups/a/s/flib2.s`
- `src/modules/groups/b/a/newgrid1.s`
- relevant callees for guard verification:
  - `src/modules/groups/b/a/newgrid1.s` (`NEWGRID_HandleGridEditorState`)
  - `src/modules/groups/a/i/disptext.s` (`DISPTEXT_LayoutAndAppendToBuffer`)
  - `src/modules/submodules/unknown10.s` (`WDISP_SPrintf`)

## Dereference Map

1. `GCOMMAND_MplexAtTemplatePtr`
- `src/modules/groups/a/s/gcommand.s:560` + `src/modules/groups/a/s/gcommand.s:561`
  - direct deref (`MOVEA.L ptr,A0` + `TST.B (A0)`)
  - Guard status: guarded by `TST.L GCOMMAND_MplexAtTemplatePtr` at `src/modules/groups/a/s/gcommand.s:557`
- `src/modules/groups/a/s/gcommand.s:1278` + `src/modules/groups/a/s/gcommand.s:1279`
  - direct deref (`MOVEA.L ptr,A0` + `TST.B (A0)`)
  - Guard status: guarded by `TST.L GCOMMAND_MplexAtTemplatePtr` at `src/modules/groups/a/s/gcommand.s:1275`
- `src/modules/groups/a/s/gcommand.s:1298` + `src/modules/groups/a/s/gcommand.s:1301`
  - pointer arithmetic/write relative to pointer base (`SUB.L ptr,D0`, `MOVEA.L ptr,A0`)
  - Guard status: guarded by earlier pointer/content checks in same block
- `src/modules/groups/b/a/newgrid1.s:6222`
  - indirect deref path (passed as format string into `WDISP_SPrintf`)
  - Guard status: **no local NULL guard**
  - Callee note: `WDISP_SPrintf` loads format pointer directly (`MOVEA.L 20(A7),A2`) with no NULL check in `src/modules/submodules/unknown10.s:337`

2. `GCOMMAND_PPVPeriodTemplatePtr`
- `src/modules/groups/b/a/newgrid1.s:7803`
  - direct deref path begins (`MOVEA.L ptr,A0`)
- `src/modules/groups/b/a/newgrid1.s:7806`
  - direct byte deref loop (`TST.B (A0)+`)
- `src/modules/groups/b/a/newgrid1.s:7810`
  - base-relative pointer arithmetic (`SUBA.L ptr,A0`)
- `src/modules/groups/b/a/newgrid1.s:7817`
  - pointer passed to `_LVOTextLength` after direct load
- `src/modules/groups/b/a/newgrid1.s:7842`
  - pointer passed to `_LVOTextLength` again after direct load
- `src/modules/groups/b/a/newgrid1.s:7882`
  - pointer passed to `_LVOText` after direct load
  - Guard status for all above: **no NULL guard in function**

3. `GCOMMAND_DigitalNicheListingsTemplatePtr`, `GCOMMAND_MplexListingsTemplatePtr`, `GCOMMAND_PPVListingsTemplatePtr`
- Callers:
  - `src/modules/groups/b/a/newgrid1.s:4826`
  - `src/modules/groups/b/a/newgrid1.s:4967`
  - `src/modules/groups/b/a/newgrid1.s:6979`
  - `src/modules/groups/b/a/newgrid1.s:7144`
  - `src/modules/groups/b/a/newgrid1.s:9437`
  - `src/modules/groups/b/a/newgrid1.s:9543`
  - all pass pointer to `NEWGRID_HandleGridEditorState`
- Local callsite guard status: no explicit `TST.L ptr` at callsite
- Downstream guard status: guarded in callee chain
  - `NEWGRID_HandleGridEditorState` forwards pointer arg (`A2`) to layout routine (`src/modules/groups/b/a/newgrid1.s:4541`)
  - `DISPTEXT_LayoutAndAppendToBuffer` checks null and empty before deref:
    - `MOVE.L A2,D0 / BEQ` at `src/modules/groups/a/i/disptext.s:965`
    - `TST.B (A2)` at `src/modules/groups/a/i/disptext.s:968`

## Findings (No Local NULL Guard)

1. High risk: unguarded direct deref of `GCOMMAND_PPVPeriodTemplatePtr`
- Location: `src/modules/groups/b/a/newgrid1.s:7803`
- Reason: direct byte read loop starts immediately with no pointer null check.

2. High risk: unguarded format-pointer use of `GCOMMAND_MplexAtTemplatePtr`
- Location: `src/modules/groups/b/a/newgrid1.s:6222`
- Reason: passed to `WDISP_SPrintf` without local check; `WDISP_SPrintf` itself has no NULL check.

## Lower-Risk/Guarded Paths
- `GCOMMAND_MplexAtTemplatePtr` derefs in `src/modules/groups/a/s/gcommand.s` are guarded locally.
- `*_ListingsTemplatePtr` editor paths are unguarded at callsite but guarded downstream in `DISPTEXT_LayoutAndAppendToBuffer`.

## Suggested Fix Targets (Behavior-Changing, Not Applied Yet)
1. Add `TST.L`/fallback before `NEWGRID_DrawGridMessageAlt` uses `GCOMMAND_PPVPeriodTemplatePtr`.
2. Add `TST.L`/fallback before `NEWGRID_DrawStatusMessage` passes `GCOMMAND_MplexAtTemplatePtr` to `WDISP_SPrintf`.
3. Optionally add fallback format string defaults near those callsites to avoid blank/NULL failures.
