/* RESTORES: _NEWGRID_UpdateGridState
 * MODULE:   modules/groups/b/a/newgrid1b_p1_2_p0.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55fff848e70310266d00082e2d000c3c2d0012200b660c700423c000006c46600000fc203900006c467205b081660a72ff27410020600000c85980660000ba200648c02f072f00486dfff8486dfffc6100f7ea4fef00102c004aadfffc670000a04aadfff867000098206dfffc41e8001c200648c02f002f084eba4d06504f5280667c200648c02f002f2dfff82f2dfffc4eba4ce22c002eadfffc610008844fef000c206dfff82248d2c623c00000b4500829000200076708700523c00000b45043eb003c200648c0220648c1e581d1c12f390000b4542f2800382f002f2dfffc2f096100fc6642974eba4c304fef0014274000206008700423c000006c462f390000b4502f0b6100fcee504f4a80670470046002700523c000006c464cdf08c04e5d4e75
 *   got:     514f48e727243c2f002e2e2f00282a6f0024200d660c700423c000000000600000ee2039000000007205b081660a72ff2b410020600000bc5980660000ae300648c02f072f00486f0020486f0028610000004fef00103a0048c5202f001c670000924aaf00186700008a2040d0fc001c2f052f0861000000504f528066742f052f2f001c2f2f0024610000002a002eaf00286100000023c0000000004fef000c206f00182248d3c50829000200076708700523c00000000043ed003c2005e580d1c045e800382f39000000002f122f052f2f00282f09610000004297610000002b4000204fef00146008700423c0000000002f39000000002f0d61000000504f4a8057c17404940123c2000000004cdf24e4504f4e754e71
 *   summary: 280 got vs 294 ref, fourteen bytes short. The original spills the two out-pointers to the A5 frame and reloads them for each of their five uses; 6.51 reloads three of them. The null-panel arm, the three-way latch dispatch, the out-parameter preset call, the bit test that must answer -1, the previous-valid-entry search, the pen selection with its bit-2 override to 5, the five-argument badge draw and the frame-and-rows call that recomputes the latch match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>

struct GridPanel {
    char            pad0[32];
    long            visibleLines;   /* +32 */
    char            pad36[24];
    struct RastPort rp;             /* +60 */
};

struct GridAux {
    char          pad0[7];
    unsigned char selectorFlags[49];    /* +7 */
};

extern long NEWGRID_GridStateFrameLatch;
extern long NEWGRID_SelectedGridEntryPtr;
extern long NEWGRID_OverridePenIndex;

extern short NEWGRID_UpdatePresetEntry(char **entry, struct GridAux **aux,
                                       long sel, long ctx);
extern long  NEWGRID2_JMPTBL_ESQ_TestBit1Based(char *bits, long slot);
extern long  NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(char *entry,
                 struct GridAux *aux, long index);
extern long  NEWGRID_SelectEntryPen(char *entry);
extern void  NEWGRID_DrawEntryFlagBadge(struct RastPort *rp, char *entry,
                 long index, long slotPtr, long pen);
extern long  NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(long mode);
extern long  NEWGRID_DrawGridFrameAndRows(struct GridPanel *panel, long selected);

void NEWGRID_UpdateGridState(struct GridPanel *panel, long ctx, short sel)
{
    char           *entry;
    struct GridAux *aux;
    long            index;

    if (panel == 0) {
        NEWGRID_GridStateFrameLatch = 4;
        return;
    }

    if (NEWGRID_GridStateFrameLatch == 5) {
        panel->visibleLines = -1;
    } else if (NEWGRID_GridStateFrameLatch == 4) {
        index = NEWGRID_UpdatePresetEntry(&entry, &aux, (long)sel, ctx);
        if (entry != 0 && aux != 0
            && NEWGRID2_JMPTBL_ESQ_TestBit1Based(entry + 28, index) == -1) {
            index = NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(entry,
                        aux, index);
            NEWGRID_SelectedGridEntryPtr = NEWGRID_SelectEntryPen(entry);
            if (aux->selectorFlags[index] & 4)
                NEWGRID_SelectedGridEntryPtr = 5;
            NEWGRID_DrawEntryFlagBadge(&panel->rp, entry, index,
                *(long *)((char *)aux + index * 4 + 56),
                NEWGRID_OverridePenIndex);
            panel->visibleLines =
                NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(0);
        }
    } else {
        NEWGRID_GridStateFrameLatch = 4;
    }

    NEWGRID_GridStateFrameLatch =
        NEWGRID_DrawGridFrameAndRows(panel, NEWGRID_SelectedGridEntryPtr) ? 4 : 5;
}
