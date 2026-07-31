/* RESTORES: NEWGRID_DrawGridFrameVariant4
 * MODULE:   modules/groups/b/a/newgrid1bb_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a5-frame-and-shared-height
 *   ref:     4e55ffec48e73f10266d000841eb003c4878000642a72f0b2b48ffec6100abec4fef000c226dffec2c79000028584eaefeaa700030390000b40856802600226dffec70002200243c000002b74eaefece7c2a7e0028077002be806c0001084eba07404a80660000fe2a044eba076a4a806756700030390000b40853802f00487802b772002f012f012f2dffec4eba06ac4fef0014700030390000b4084a806a025280e280206b007072003228001a908159804a806a025280e28072003228001ad0815680da80606e4eba06dc4a806736700030390000b40822004a816a025281e281206b007074003428001a928259814a816a025281e28174003428001ad2825381da816030700030390000b4084a806a025280e280206b007072003228001a90814a806a025280e28072003228001ad0815380da802f052f062f2dffec4eba06244fef000c5287700030390000b4084a806a025280e280d0b900001b4cd8806000fef44eba063a4a80671c200453802f00487802b772002f012f012f2dffec4eba065a4fef001420044a806a025280e280374000344eba06084cdf08fc4e5d4e75
 *   got:     48e73f162a6f002847ed003c4878000642a72f0d610000004fef000c224b2c79000000004eaefeaa700030390000000056802600224b2c790000000070002200243c000002b74eaefece782a7e002c077002be806c000102610000004a80660000f82a06610000004a806754700030390000000053802f00487802b772002f012f012f0b610000004fef001470003039000000004a806a025280e280206d007072003228001a908159804a806a025280e28072003228001ad0815680da80606c610000004a806734700030390000000022006a025281e281206d007074003428001a928259814a816a025281e28174003428001ad2825381da81603070003039000000004a806a025280e280206d007072003228001a90814a806a025280e28072003228001ad0815380da802f052f042f0b610000004fef000c528770003039000000004a806a025280e280d0b900000000dc806000fefa610000004a80661a200653802f00487802b772002f012f012f0b610000004fef001420066a025280e2803b400034610000004cdf68fc4e75
 *   summary: 400 got vs 418 ref, eighteen bytes short. The original recomputes the halved row height and rereads the font baseline separately in each of the three vertical-offset arms and keeps the rastport pointer in an A5 frame slot; 6.51 shares part of the arithmetic between the arms. The row-colour call feeding SetAPen, the full-width RectFill, the two-row loop with its last-line guard, all three baseline formulas (multi-line +3, last-line-selected -1 with the four-pixel inset, plain -1 without it), the vertical and horizontal bevels and the halved height store match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include <graphics/text.h>
#include "esq-graphics.h"

struct GridPanel {
    char            pad0[52];
    short           halfHeight;     /* +52 */
    char            pad54[6];
    struct RastPort rp;             /* +60, rp_Font lands at +112 */
};

extern unsigned short NEWGRID_RowHeightPx;
extern long DISPTEXT_ControlMarkerXOffsetPx;

extern long NEWGRID_SetRowColor(struct GridPanel *panel, long col, long pen);
extern long NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(void);
extern long NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines(void);
extern long NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(void);
extern void NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel(struct RastPort *rp, long x0,
                long y0, long x1, long y1);
extern void NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel(struct RastPort *rp,
                long x0, long y0, long x1, long y1);
extern void NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(struct RastPort *rp,
                long x, long y);

long NEWGRID_DrawGridFrameVariant4(struct GridPanel *panel)
{
    struct RastPort *rp;
    long row;
    long top;
    long baseY;
    long x;

    rp = &panel->rp;
    SetAPen(rp, NEWGRID_SetRowColor(panel, 0, 6));
    RectFill(rp, 0, 0, 695, (long)NEWGRID_RowHeightPx + 3);

    x = 42;
    row = 0;
    top = row;

    while (row < 2 && NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast() == 0) {
        baseY = top;

        if (NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines() != 0) {
            NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel(rp, 0, 0, 695,
                (long)NEWGRID_RowHeightPx - 1);
            baseY += ((long)NEWGRID_RowHeightPx / 2
                      - panel->rp.Font->tf_Baseline - 4) / 2
                     + panel->rp.Font->tf_Baseline + 3;
        } else if (NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected() != 0) {
            baseY += ((long)NEWGRID_RowHeightPx / 2
                      - panel->rp.Font->tf_Baseline - 4) / 2
                     + panel->rp.Font->tf_Baseline - 1;
        } else {
            baseY += ((long)NEWGRID_RowHeightPx / 2
                      - panel->rp.Font->tf_Baseline) / 2
                     + panel->rp.Font->tf_Baseline - 1;
        }

        NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(rp, x, baseY);
        row++;
        top += (long)NEWGRID_RowHeightPx / 2 + DISPTEXT_ControlMarkerXOffsetPx;
    }

    if (NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast() == 0)
        NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel(rp, 0, 0, 695, top - 1);

    panel->halfHeight = top / 2;
    return NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast();
}
