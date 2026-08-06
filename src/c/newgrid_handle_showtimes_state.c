/* RESTORES: _NEWGRID_HandleShowtimesState
 * MODULE:   modules/groups/b/a/newgrid1bb.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a7-frame-and-booleanise
 *   ref:     4e55ff7c48e70130266d0008246d000c200b660c700423c000006cb060000118203900006cb05980670a5380670000e0600000fc4a92670000fe4aaa0004670000f62f390000aa3248780014487802644eba16024fef000c3e2a00147030be406f040447003010390000aa3f724eb001662841eb003c200748c04878ffff48780001487800022f002f2a00042f122f086100c1924fef001c602641eb003c200748c04878ffff48780001487800032f002f2a00042f122f086100c16a4fef001c2f390000aa364eba14c6486dff7e2f0a2f0b6100f93241eb003c486dff7e2f084eba14b22e8b6100f5924fef00184a8067047004600270054878000223c000006cb04eba14d8584f2740002060282f0b6100f568584f4a80670470046002700572ff2741002023c000006cb06008700423c000006cb0203900006cb04cdf0c804e5d4e75
 *   got:     9efc008448e72114266f009c2a6f0098200d660c700423c0000000006000012a2039000000005980670a5380670000ee600001084a93660a203900000000600001084aab0004660a203900000000600000f82f39000000004878001448780264610000004fef000c3e2b00147030be406f0404470030103900000000724eb001662841ed003c300748c04878ffff48780001487800022f002f2b00042f132f08610000004fef001c602641ed003c300748c04878ffff48780001487800032f002f2b00042f132f08610000004fef001c2f390000000061000000486f00162f0b2f0d6100000041ed003c486f00222f08610000002e8d610000004fef00184a8057c17404940123c20000000048780002610000002b400020584f60262f0d61000000584f4a8057c17404940123c20000000070ff2b4000206008700423c0000000002039000000004cdf2884defc00844e754e71
 *   summary: 340 got vs 324 ref. 6.51 computes the 4-or-5 state from the frame-draw result with SEQ / MOVEQ #4 / SUBQ (57c1 7404 9401), six bytes, where the original branches over a pair of MOVEQ, four -- twice. The rest is the frame register and the 130-byte text buffer moving from A5 to A7 displacements. Both null guards, the layout parameters, the 48-offset selector normalisation, both seven-argument DrawGridEntry arms, the build-and-append pair and the state-5 arm with its -1 store match in kind and order.
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

struct ShowtimesCtx {
    char *entry;                    /* +0 */
    char *aux;                      /* +4 */
    char  pad8[12];
    short selector;                 /* +20 */
};

extern long NEWGRID_ShowtimesWorkflowStateLatch;
extern long GCOMMAND_PpvShowtimesLayoutPen;
extern long GCOMMAND_PpvShowtimesInitialLineIndex;
extern unsigned char GCOMMAND_PpvDetailLayoutFlag;

extern void DISPTEXT_SetLayoutParams(long width, long lead,
                                                     long pen);
extern void NEWGRID_DrawGridEntry(struct RastPort *rp, char *entry, char *aux,
                                  long selector, long mode, long flag,
                                  long pen);
extern void DISPTEXT_SetCurrentLineIndex(long index);
extern void NEWGRID_BuildShowtimesText(struct GridPanel *panel,
                                       struct ShowtimesCtx *ctx, char *buf);
extern void DISPTEXT_LayoutAndAppendToBuffer(struct RastPort *rp,
                                                             char *buf);
extern long NEWGRID_DrawGridFrameVariant3(struct GridPanel *panel);
extern long DISPTEXT_ComputeVisibleLineCount(long mode);

long NEWGRID_HandleShowtimesState(struct GridPanel *panel,
                                  struct ShowtimesCtx *ctx)
{
    char  buf[130];
    short selector;

    if (panel == 0) {
        NEWGRID_ShowtimesWorkflowStateLatch = 4;
        return NEWGRID_ShowtimesWorkflowStateLatch;
    }

    switch (NEWGRID_ShowtimesWorkflowStateLatch) {
    case 4:
        if (ctx->entry == 0)
            return NEWGRID_ShowtimesWorkflowStateLatch;
        if (ctx->aux == 0)
            return NEWGRID_ShowtimesWorkflowStateLatch;

        DISPTEXT_SetLayoutParams(612, 20,
                                                 GCOMMAND_PpvShowtimesLayoutPen);
        selector = ctx->selector;
        if (selector > 48)
            selector -= 48;

        if (GCOMMAND_PpvDetailLayoutFlag == 'N')
            NEWGRID_DrawGridEntry(&panel->rp, ctx->entry, ctx->aux,
                                  (long)selector, 2, 1, -1);
        else
            NEWGRID_DrawGridEntry(&panel->rp, ctx->entry, ctx->aux,
                                  (long)selector, 3, 1, -1);

        DISPTEXT_SetCurrentLineIndex(
            GCOMMAND_PpvShowtimesInitialLineIndex);
        NEWGRID_BuildShowtimesText(panel, ctx, buf);
        DISPTEXT_LayoutAndAppendToBuffer(&panel->rp, buf);
        NEWGRID_ShowtimesWorkflowStateLatch =
            NEWGRID_DrawGridFrameVariant3(panel) ? 4 : 5;
        panel->visibleLines = DISPTEXT_ComputeVisibleLineCount(2);
        break;

    case 5:
        NEWGRID_ShowtimesWorkflowStateLatch =
            NEWGRID_DrawGridFrameVariant3(panel) ? 4 : 5;
        panel->visibleLines = -1;
        break;

    default:
        NEWGRID_ShowtimesWorkflowStateLatch = 4;
        break;
    }

    return NEWGRID_ShowtimesWorkflowStateLatch;
}
