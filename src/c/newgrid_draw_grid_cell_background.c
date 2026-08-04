/* RESTORES: _NEWGRID_DrawGridCellBackground
 * MODULE:   modules/groups/b/a/newgrid1b_p1_2_p0.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: reserved-a5-frame
 *   ref:     4e55ffec48e73f10266d00083e2d000e3c2d00122a2d001441eb003c700030390000b40c32390000b40ec2c7d08128007224d88142adfff8200748c0220648c1d0812b48ffec7203b0816d08203c000002b7601030390000b40ec0c62204d28053812001720032390000b40853812b40fff42b41fff070004600ba806736200748c02f052f002f0b6100ed924fef000c226dffec2c79000028584eaefeaa2004226dffec222dfff8242dfff4262dfff04eaefece7003bc4066281039000006067259b001661c2f2dfff02f2dfff42f2dfff82f042f2dffec4eba48e44fef0014601a2f2dfff02f2dfff42f2dfff82f042f2dffec4eba484a4fef00144cdf08fc4e5d4e75
 *   got:     9efc001048e737162a2f00403c2f003e3e2f003a2a6f003470003039000000003207343900000000c4c1d0827424d08242af002847ed003c48c1340648c2d2822f40002c7403b2826c143206343900000000c4c1d08253802f40002460082f7c000002b700247000303900000000538048ef0001002070004600ba80673a300748c02f052f002f0d610000004fef000c224b2c79000000004eaefeaa224b202f002c222f0028242f0024262f00202c79000000004eaefece2006574066281039000000007259b001661c2f2f00202f2f00282f2f00302f2f00382f0b610000004fef0014601a2f2f00202f2f00282f2f00302f2f00382f0b610000004fef00144cdf68ecdefc00104e754e71
 *   summary: 268 got vs 260 ref. The original opens LINK.W A5,#-20 and holds five values in negative A5 displacements; 6.51 opens SUBA.W #16,A7 and spills the same five to A7 displacements, which costs the extra bytes (one store becomes MOVEM.L D0,32(A7), 6 bytes against MOVE.L D1,-16(A5), 4). Both column multiplies are MULU, as in the original -- written as short*short they became calls to the 32x32 helper and the function was 296 bytes. The 255 pen guard, the col+span<3 width choice, the nested SetRowColor result feeding SetAPen, the RectFill and the two bevel calls all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include "esq-graphics.h"

struct GridPanel {
    char            pad0[60];
    struct RastPort rp;             /* +60 */
};

extern unsigned short NEWGRID_ColumnStartXPx;
extern unsigned short NEWGRID_ColumnWidthPx;
extern unsigned short NEWGRID_RowHeightPx;
extern char           CONFIG_NewgridPlaceholderBevelFlag;

extern long NEWGRID_SetRowColor(struct GridPanel *panel, long col, long pen);
extern void BEVEL_DrawBeveledFrame(struct RastPort *rp,
                long x0, long y0, long x1, long y1);
extern void BEVEL_DrawBevelFrameWithTopRight(struct RastPort *rp,
                long x0, long y0, long x1, long y1);

void NEWGRID_DrawGridCellBackground(struct GridPanel *panel, short col,
                                    short span, long pen)
{
    struct RastPort *rp;
    long x0, y0, x1, y1;

    x0 = (long)NEWGRID_ColumnStartXPx + NEWGRID_ColumnWidthPx * (unsigned short)col + 36;
    y0 = 0;
    rp = &panel->rp;
    if ((long)col + (long)span < 3)
        x1 = x0 + NEWGRID_ColumnWidthPx * (unsigned short)span - 1;
    else
        x1 = 695;
    y1 = (long)NEWGRID_RowHeightPx - 1;

    if (pen != 255) {
        SetAPen(rp, NEWGRID_SetRowColor(panel, (long)col, pen));
        RectFill(rp, x0, y0, x1, y1);
    }

    if (span == 3 && CONFIG_NewgridPlaceholderBevelFlag == 89)
        BEVEL_DrawBeveledFrame(rp, x0, y0, x1, y1);
    else
        BEVEL_DrawBevelFrameWithTopRight(rp, x0, y0, x1, y1);
}
