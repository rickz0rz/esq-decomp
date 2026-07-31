/* RESTORES: TEXTDISP_UpdateHighlightOrPreview
 * MODULE:   modules/groups/b/a/textdisp2_p0_p0.s
 * STATUS:   behavioural
 *
 * Decides, once per tick, whether to advance an external asset frame, draw the
 * next entry preview, or reset the selection.
 *
 * The structure is two near-identical three-way decisions, one for filter mode
 * 1 and one for everything else. The mode-1 arm adds a class-id test to each
 * branch; the other arm has the same shape with those tests removed. They are
 * written out separately because the original does -- the two blocks do not
 * share a tail.
 *
 * The class id defaults through: FilterClassId is used unless it is -1, in
 * which case FilterPrevClassId takes over. That fallback happens ONCE, before
 * either test, not per branch.
 *
 * 78 is 'N' -- ED_DiagGraphModeChar is compared against it as a byte, and the
 * sense is that 'N' means "not the asset player", so the asset frame advances
 * only when the character is something else.
 *
 * WDISP_HighlightActive is tested as SUBQ.W #1 / BNE, which is `== 1` exactly
 * rather than a non-zero test.
 *
 * The literal 1 passed to the asset player is the same D0 the mode compare
 * loaded, which is why the original never reloads it.
 *
 * 138 ref vs 136 got. Both blocks, all four ED_DiagGraphModeChar tests against
 * 78, both SUBQ.W #1 highlight tests, all four calls and the class-id fallback
 * match in kind and size.
 *
 * SASC-MISMATCH: shared-constant-vs-reloaded
 *   ref:     7001 b0b9....  ... 2f00 4eba0144
 *            MOVEQ #1,D0 for the mode compare, and the SAME D0 pushed as the
 *            asset-player argument at both call sites
 *   got:     7001 b0b9....  ... 48780001
 *            the 1 is re-materialised as PEA 1.W at each call
 *   summary: the original notices that the constant it compared against is the
 *            argument it needs and reuses the register; 6.51 pushes a fresh
 *            immediate. Same value, and it costs 6.51 two bytes at each of the
 *            two call sites while saving elsewhere.
 *   tried:   nothing from the source side -- the 1 in the comparison and the 1
 *            in the call are unrelated in the C, and making them one variable
 *            would be writing to defeat the register allocator.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: case-body-layout
 *   ref:     the mode-1 block places the reset tail after the preview arm
 *   got:     the two arms are emitted in the opposite order with the branch
 *            conditions inverted
 *   summary: same three outcomes, same conditions, different fall-through.
 *   scope:   program-wide. docs/compiler-version.md, "Parameter and case
 *            layout".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern void TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame(long which);
extern void TEXTDISP_DrawNextEntryPreview(void);
extern void TEXTDISP_ResetSelectionAndRefresh(void);

extern long  LOCAVAIL_FilterModeFlag;
extern long  LOCAVAIL_FilterClassId;
extern long  LOCAVAIL_FilterPrevClassId;
extern unsigned char ED_DiagGraphModeChar;
extern short WDISP_HighlightActive;

void TEXTDISP_UpdateHighlightOrPreview(void)
{
    long cls;

    if (LOCAVAIL_FilterModeFlag == 1) {
        cls = LOCAVAIL_FilterClassId;
        if (cls == -1)
            cls = LOCAVAIL_FilterPrevClassId;

        if (ED_DiagGraphModeChar != 'N' && cls == 2)
            TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame(1L);
        else if (WDISP_HighlightActive == 1 && cls == 3)
            TEXTDISP_DrawNextEntryPreview();
        else
            TEXTDISP_ResetSelectionAndRefresh();
    } else {
        if (ED_DiagGraphModeChar != 'N')
            TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame(1L);
        else if (WDISP_HighlightActive == 1)
            TEXTDISP_DrawNextEntryPreview();
        else
            TEXTDISP_ResetSelectionAndRefresh();
    }
}
