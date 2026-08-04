/* RESTORES: _NEWGRID_DrawAwaitingListingsMessage
 * MODULE:   modules/groups/b/a/newgrid_p2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: frame-pointer-and-textlength-extension
 *   ref:     4e55fffc48e72030266f0018700030390000b40853802f0072042f012f01487800072f0b610002ea41eb003c224870012c79000028584eaefeaa41eb003c43eb003c2479000075aa4a1a66fc538a95f9000075aa2f480020200a2079000075aa4eaeffca223c0000027092804a816a025281e2817024d280206b0070700030390000b40874003428001a90824a806a025280e28074003428001ad0825380487800012f39000075aa487802642f002f012f2f00346100031841eb003c700030390000b40853802e80487802b772002f012f012f084eba650e4fef003c30390000b408e2483740003472003200274100204cdf0c044e5d4e75
 *   got:     514f48e707162a6f0024700030390000000053802f0072042f012f01487800072f0d6100000041ed003c22482c790000000070014eaefeaa26790000000041ed003c224b4a1966fc538993cb2f4900302248204b202f00302c79000000004eaeffca48c0724ee78992804a816a025281e2812e017024de807000303900000000206d007072003228001a90814a806a025280e28072003228001ad0812c00538641ed003c487800012f0b487802642f062f072f086100000041ed003c700030390000000053802e80487802b772002f012f012f0861000000303900000000e2482a0030053b400034720032002b4100204fef003c4cdf68e0504f4e75
 *   summary: 252 got vs 248 ref, four regions. 6.51 drops the frame pointer (SUBQ/ADDQ #8,A7 where the original uses LINK.W A5,#-4/UNLK, -2), sign-extends the WORD result of TextLength (EXT.L D0, +2) and builds 624 as MOVEQ #78/ASL.L #3 where the original writes MOVE.L #624 (-2). Both centering divides, the inlined strlen, the RastPort at +60, the Font-baseline reads at +112/+26 and all four calls agree in order and in kind.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include <graphics/text.h>
#include <string.h>
#include "esq-graphics.h"

struct GridPanel {
    char            pad0[32];
    long            scrollBase;     /* +32 */
    char            pad36[16];
    short           halfRowHeight;  /* +52 */
    char            pad54[6];
    struct RastPort rp;             /* +60, so Font lands at +112 */
};

extern unsigned short NEWGRID_RowHeightPx;
extern char *Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION;

extern void NEWGRID_DrawGridFrame(struct GridPanel *panel, long style,
                                  long left, long top, long bottom);
extern void NEWGRID_DrawWrappedText(struct RastPort *rp, long x, long y,
                                    long width, char *text, long flag);
extern void BEVEL_DrawBevelFrameWithTopRight(
                struct RastPort *rp, long x, long y, long w, long h);

void NEWGRID_DrawAwaitingListingsMessage(struct GridPanel *panel)
{
    char *msg;
    long x, y;
    unsigned short half;

    NEWGRID_DrawGridFrame(panel, 7, 4, 4, (long)NEWGRID_RowHeightPx - 1);
    SetAPen(&panel->rp, 1);

    msg = Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION;
    x = (624 - TextLength(&panel->rp, msg, strlen(msg))) / 2 + 36;
    y = ((long)NEWGRID_RowHeightPx - panel->rp.Font->tf_Baseline) / 2
        + panel->rp.Font->tf_Baseline - 1;

    NEWGRID_DrawWrappedText(&panel->rp, x, y, 612, msg, 1);
    BEVEL_DrawBevelFrameWithTopRight(&panel->rp, 0, 0, 695,
                                                     (long)NEWGRID_RowHeightPx - 1);
    half = NEWGRID_RowHeightPx >> 1;
    panel->halfRowHeight = half;
    panel->scrollBase = half;
}
