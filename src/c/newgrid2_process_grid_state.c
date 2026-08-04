/* RESTORES: NEWGRID2_ProcessGridState
 * MODULE:   modules/groups/b/a/newgrid2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55fff848e70330266d0008246d000c2e2d001091c82b48fffa200b660c700423c000006cc86000015a203900006cc85980670a5380670001226000013e4a92670001404aaa0004670001384878000148780014487802644eba05704fef000c3c2a00147030bc406f04044600304a7900006c266738200648c02f122f006100ff1c504f4a40662641eb003c200648c04878000372012f012f012f002f2a00042f122f086100b0f44fef001c602441eb003c200648c072032f01487800012f012f002f2a00042f122f086100b0ce4fef001c2f3c00010001487807d048780f6b487900006ccc4eba275c4fef00102b40fffa673e487800034eba040a2e872f2dfffa2f0a2f0b6100f6ae41eb003c2eadfffa2f084eba03f4487807d02f2dfffa48780f71487900006cd84eba27064fef00242f0b6100fcc4584f4a8067047004600270054878000223c000006cc84eba0402584f2740002060282f0b6100fc9c584f4a80670470046002700572ff2741002023c000006cc86008700423c000006cc8203900006cc84cdf0cc04e5d4e75
 *   got:     48e723342e2f0024266f00202a6f001c95ca200d660c700423c000000000600001662039000000005980670a53806700012a600001444a93660a203900000000600001444aab0004660a20390000000060000134487800014878001448780264610000004fef000c3c2b00147030bc406f04044600303039000000006738300648c02f132f0061000000504f4a40662641ed003c300648c04878000372012f012f012f002f2b00042f132f08610000004fef001c602441ed003c300648c072032f01487800012f012f002f2b00042f132f08610000004fef001c2f3c00010001487807d048780f6b4879000000006100000024404a804fef0010673848780003610000002e872f0a2f0b2f0d6100000041ed003c2e8a2f0861000000487807d02f0a48780f71487900000000610000004fef00242f0d61000000584f4a8057c17404940123c20000000048780002610000002b400020584f60262f0d61000000584f4a8057c17404940123c20000000070ff2b4000206008700423c0000000002039000000004cdf2cc44e75
 *   summary: 396 got vs 400 ref, four bytes short. The original keeps the showtimes buffer pointer in an A5 frame slot and reloads it before each of its four uses; 6.51 reloads it three times. The two context null guards, the layout parameters, the 48-offset selector normalisation, the prime-time gate selecting between the mode-1 and mode-3 seven-argument draws, the 2000-byte scratch allocation with its matching deallocate, the append-and-layout pair and the state-5 arm with its -1 store match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>

#define MEMF_PUBLIC 1L
#define MEMF_CLEAR  0x10000L

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

extern long  NEWGRID_RenderStateLatch;
extern short NEWGRID_PrimeTimeLayoutEnable;
extern char  Global_STR_NEWGRID2_C_1[];
extern char  Global_STR_NEWGRID2_C_2[];

extern void  DISPTEXT_SetLayoutParams(long width, long lead,
                                                      long pen);
extern short NEWGRID_TestPrimeTimeWindow(long slot, char *entry);
extern void  NEWGRID_DrawGridEntry(struct RastPort *rp, char *entry, char *aux,
                                   long slot, long mode, long flag, long pen);
extern char *MEMORY_AllocateMemory(char *who, long line,
                                                 long size, long flags);
extern void  MEMORY_DeallocateMemory(char *who, long line,
                                                   char *ptr, long size);
extern void  DISPTEXT_SetCurrentLineIndex(long index);
extern void  NEWGRID_AppendShowtimesForRow(struct GridPanel *panel,
                 struct ShowtimesCtx *ctx, char *buf, long extra);
extern void  DISPTEXT_LayoutAndAppendToBuffer(struct RastPort *rp,
                                                              char *buf);
extern long  NEWGRID_DrawGridFrameVariant4(struct GridPanel *panel);
extern long  DISPTEXT_ComputeVisibleLineCount(long mode);

long NEWGRID2_ProcessGridState(struct GridPanel *panel, struct ShowtimesCtx *ctx,
                               long extra)
{
    char *buf;
    short slot;

    buf = 0;

    if (panel == 0) {
        NEWGRID_RenderStateLatch = 4;
        return NEWGRID_RenderStateLatch;
    }

    switch (NEWGRID_RenderStateLatch) {
    case 4:
        if (ctx->entry == 0)
            return NEWGRID_RenderStateLatch;
        if (ctx->aux == 0)
            return NEWGRID_RenderStateLatch;

        DISPTEXT_SetLayoutParams(612, 20, 1);

        slot = ctx->selector;
        if (slot > 48)
            slot -= 48;

        if (NEWGRID_PrimeTimeLayoutEnable != 0
            && NEWGRID_TestPrimeTimeWindow((long)slot, ctx->entry) == 0)
            NEWGRID_DrawGridEntry(&panel->rp, ctx->entry, ctx->aux, (long)slot,
                                  1, 1, 3);
        else
            NEWGRID_DrawGridEntry(&panel->rp, ctx->entry, ctx->aux, (long)slot,
                                  3, 1, 3);

        buf = MEMORY_AllocateMemory(Global_STR_NEWGRID2_C_1, 3947,
                  2000, MEMF_PUBLIC + MEMF_CLEAR);
        if (buf != 0) {
            DISPTEXT_SetCurrentLineIndex(3);
            NEWGRID_AppendShowtimesForRow(panel, ctx, buf, extra);
            DISPTEXT_LayoutAndAppendToBuffer(&panel->rp, buf);
            MEMORY_DeallocateMemory(Global_STR_NEWGRID2_C_2, 3953,
                                                  buf, 2000);
        }

        NEWGRID_RenderStateLatch =
            NEWGRID_DrawGridFrameVariant4(panel) ? 4 : 5;
        panel->visibleLines =
            DISPTEXT_ComputeVisibleLineCount(2);
        break;

    case 5:
        NEWGRID_RenderStateLatch =
            NEWGRID_DrawGridFrameVariant4(panel) ? 4 : 5;
        panel->visibleLines = -1;
        break;

    default:
        NEWGRID_RenderStateLatch = 4;
        break;
    }

    return NEWGRID_RenderStateLatch;
}
