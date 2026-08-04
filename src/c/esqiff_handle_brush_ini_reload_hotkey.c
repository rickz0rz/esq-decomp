/* RESTORES: ESQIFF_HandleBrushIniReloadHotkey
 * MODULE:   modules/groups/a/n/esqiff.s
 * STATUS:   behavioural
 *
 * On the 'a' hotkey, reloads brush.ini from scratch: frees the current brush
 * list, re-parses the file, repopulates the list from the parsed descriptors, and
 * re-selects the DT brush. If nothing ended up selected it falls back to the
 * first dither brush, and either way refreshes the cached type-3 brush node.
 *
 * Any other key returns immediately.
 *
 * 128 bytes against 128, and the closest match in this directory that is not
 * promoted to exact: of nine differing regions, EIGHT are the call encoding and
 * nothing else. Every other instruction -- the argument fetch, the compare, all
 * eight argument frames, the batched LEA 24(A7),A7 cleanup, the two ADDQ pops,
 * the null test, both stores -- is byte-identical in sequence.
 *
 * It is not exact only because the sole remaining divergence is unreachable: the
 * original's calls are all JSR (d16,PC), which is what its compiler emitted for a
 * callee in another translation unit, and a one-function-per-file restoration
 * emits BSR.W for every call. Both are 4 bytes, so the sizes agree exactly.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba00ae 4eba00ba 4eba9bd6 4eba73b2 4eba00fc 4eba0074 4eba006e
 *            4eba00d0                       JSR (d16,PC), 8 sites
 *   got:     61000000                       BSR.W
 *   summary: the standard call-encoding class, and here it is the ONLY class
 *            present. If a candidate compiler emits JSR (d16,PC) for an extern,
 *            this function should go byte-exact immediately -- which makes it a
 *            useful acceptance test in its own right, alongside the two in
 *            docs/compiler-version.md.
 *
 * SASC-MISMATCH: stack-pop-placement
 *   ref:     4eba0074 504f 23c0<glob>   JSR / ADDQ.W #8,A7 / MOVE.L D0,glob
 *   got:     61000000 23c0<glob> 504f   BSR.W / MOVE.L D0,glob / ADDQ.W #8,A7
 *   summary: the original pops the argument frame before storing the result,
 *            SAS/C after. Same instructions, same bytes, different order.
 */
extern void  DISKIO_ForceUiRefreshIfIdle(void);
extern void  DISKIO_ResetCtrlInputStateIfIdle(void);
extern void  BRUSH_FreeBrushList(void *head, long mode);
extern void  PARSEINI_ParseIniBufferAndDispatch(char *path);
extern void  BRUSH_PopulateBrushList(void *descriptors, void *head);
extern void  BRUSH_SelectBrushByLabel(char *tag);
extern void *BRUSH_FindBrushByPredicate(char *tag, void *head);
extern void *BRUSH_FindType3Brush(void *head);

extern void *ESQIFF_BrushIniListHead;
extern void *PARSEINI_ParsedDescriptorListHead;
extern void *BRUSH_SelectedNode;
extern void *ESQFUNC_FallbackType3BrushNode;
extern char  Global_STR_DF0_BRUSH_INI_2[];
extern char  ESQIFF_TAG_DT[];
extern char  ESQIFF_TAG_DITHER[];

void ESQIFF_HandleBrushIniReloadHotkey(char key)
{
    if (key != 'a')
        return;

    DISKIO_ForceUiRefreshIfIdle();
    BRUSH_FreeBrushList(&ESQIFF_BrushIniListHead, 0);
    PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_BRUSH_INI_2);
    BRUSH_PopulateBrushList(PARSEINI_ParsedDescriptorListHead,
                                            &ESQIFF_BrushIniListHead);
    BRUSH_SelectBrushByLabel(ESQIFF_TAG_DT);

    if (BRUSH_SelectedNode == 0)
        BRUSH_SelectedNode = BRUSH_FindBrushByPredicate(
                                 ESQIFF_TAG_DITHER, &ESQIFF_BrushIniListHead);

    ESQFUNC_FallbackType3BrushNode =
        BRUSH_FindType3Brush(&ESQIFF_BrushIniListHead);

    DISKIO_ResetCtrlInputStateIfIdle();
}
