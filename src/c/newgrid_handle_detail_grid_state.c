/* RESTORES: _NEWGRID_HandleDetailGridState
 * MODULE:   modules/groups/b/a/newgrid1b_p2_p1_2_p2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a7-frame-and-booleanise
 *   ref:     4e55ffc448e70330266d00082e2d000c3c2d001291c82b48fffc2b48fff8200b660c700423c000006c7a6000013e203900006c7a5980670a53806700010660000122200648c02f072f00486dfff8486dfffc6100d5004fef00102c004aadfffc670001084aadfff8670001002f390000a9fe48780014487802644eba2a304fef000c10390000aa0b724eb001662a41eb003c200648c04878000448780001487800022f002f2dfff82f2dfffc2f086100d5cc4fef001c602841eb003c200648c04878000448780001487800032f002f2dfff82f2dfffc2f086100d5a24fef001c2f390000aa024eba28fe206dfffc224843e9001345e800012e8a2f09487900006c7e486dffc64eba45b241eb003c486dffc62f084eba28d62e8b6100fd404fef00184a8067047004600270054878000223c000006c7a4eba28fc584f2740002060282f0b6100fd16584f4a80670470046002700572ff2741002023c000006c7a6008700423c000006c7a203900006c7a4cdf0cc04e5d4e75
 *   got:     9efc004448e727243c2f006a2e2f00642a6f006091c82f4800542f480058200d660c700423c0000000006000014a2039000000005980670a53806700010e60000128300648c02f072f00486f005c486f0064610000004fef00103a0048c54aaf0058660a2039000000006000010a4aaf0054660a203900000000600000fa2f39000000004878001448780264610000004fef000c103900000000724eb001662641ed003c4878000448780001487800022f052f2f00642f2f006c2f08610000004fef001c602441ed003c4878000448780001487800032f052f2f00642f2f006c2f08610000004fef001c2f390000000061000000206f005c2248d2fc001345e800012e8a2f09487900000000486f00266100000041ed003c486f002a2f08610000002e8d610000004fef00184a8057c17404940123c20000000048780002610000002b400020584f60262f0d61000000584f4a8057c17404940123c20000000070ff2b4000206008700423c0000000002039000000004cdf24e4defc00444e75
 *   summary: 384 got vs 376 ref. 6.51 forms the 4-or-5 latch value with SEQ and arithmetic where the original branches over two MOVEQ, twice. The out-parameter pair, both seven-argument DrawGridEntry arms selected by the 78 layout flag, the channel-row SPrintf over the entry at +1 and +19, the layout append and the state-5 arm with its -1 store all match in kind and order.
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

extern long NEWGRID_DetailGridStateLatch;
extern long GCOMMAND_MplexDetailLayoutPen;
extern long GCOMMAND_MplexDetailInitialLineIndex;
extern unsigned char GCOMMAND_MplexDetailLayoutFlag;
extern char NEWGRID_ChannelRowFmt[];

extern short NEWGRID_UpdatePresetEntry(char **entry, char **aux, long sel,
                                       long ctx);
extern void  DISPTEXT_SetLayoutParams(long width, long lead,
                                                      long pen);
extern void  NEWGRID_DrawGridEntry(struct RastPort *rp, char *entry, char *aux,
                                   long slot, long mode, long flag, long pen);
extern void  DISPTEXT_SetCurrentLineIndex(long index);
extern void  WDISP_SPrintf(char *buf, char *fmt, char *a,
                                           char *b);
extern void  DISPTEXT_LayoutAndAppendToBuffer(struct RastPort *rp,
                                                              char *buf);
extern long  NEWGRID_DrawGridFrameVariant2(struct GridPanel *panel);
extern long  DISPTEXT_ComputeVisibleLineCount(long mode);

long NEWGRID_HandleDetailGridState(struct GridPanel *panel, long ctx, short sel)
{
    char  buf[58];
    char *entry;
    char *aux;
    long  slot;

    entry = aux = 0;

    if (panel == 0) {
        NEWGRID_DetailGridStateLatch = 4;
        return NEWGRID_DetailGridStateLatch;
    }

    switch (NEWGRID_DetailGridStateLatch) {
    case 4:
        slot = NEWGRID_UpdatePresetEntry(&entry, &aux, (long)sel, ctx);
        if (entry == 0)
            return NEWGRID_DetailGridStateLatch;
        if (aux == 0)
            return NEWGRID_DetailGridStateLatch;

        DISPTEXT_SetLayoutParams(612, 20,
                                                 GCOMMAND_MplexDetailLayoutPen);

        if (GCOMMAND_MplexDetailLayoutFlag == 'N')
            NEWGRID_DrawGridEntry(&panel->rp, entry, aux, slot, 2, 1, 4);
        else
            NEWGRID_DrawGridEntry(&panel->rp, entry, aux, slot, 3, 1, 4);

        DISPTEXT_SetCurrentLineIndex(
            GCOMMAND_MplexDetailInitialLineIndex);
        WDISP_SPrintf(buf, NEWGRID_ChannelRowFmt, entry + 19,
                                      entry + 1);
        DISPTEXT_LayoutAndAppendToBuffer(&panel->rp, buf);
        NEWGRID_DetailGridStateLatch =
            NEWGRID_DrawGridFrameVariant2(panel) ? 4 : 5;
        panel->visibleLines =
            DISPTEXT_ComputeVisibleLineCount(2);
        break;

    case 5:
        NEWGRID_DetailGridStateLatch =
            NEWGRID_DrawGridFrameVariant2(panel) ? 4 : 5;
        panel->visibleLines = -1;
        break;

    default:
        NEWGRID_DetailGridStateLatch = 4;
        break;
    }

    return NEWGRID_DetailGridStateLatch;
}
