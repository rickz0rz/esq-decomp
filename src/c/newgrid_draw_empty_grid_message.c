/* RESTORES: NEWGRID_DrawEmptyGridMessage
 * MODULE:   modules/groups/b/a/newgrid1b_p2_p1_2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: volatile-base-reload
 *   ref:     4e55ff5448e72132266d00083e2d00124878002170062f002f00487800072f0b4ebad38020790000754a43edff8012d866fc200748c0486dff612f004eba367a486dff61486dff804eba52ca41eb003c700030390000b40c7223d081487800212f0072002f012f012f084eba360a41eb003c700030390000b40c7224d08148780021487802b742a72f002f084eba35e84fef004c41eb003c224870032c79000028584eaefeaa41eb003c224870004eaefe9e41eb003c700030390000b40c32390000b40ec2fc000343eb003c45edff802c4a4a1e66fc538e9dca2f4000182f41001c2f480014204a200e2c79000028584eaeffca222f001c92804a816a025281e281202f0018d0817224d081206b007072003228001a742294814a826a025282e28272003228001ad48153822202226f00144eaeff1041eb003c224a4a1966fc538993ca2f4900182248204a202f00184eaeffc47011374000347200320027410020487800412f0b6100da444ced4c84ff404e5d4e75
 *   got:     9efc00a448e72f263e2f00d22a6f00c84878002170062f002f00487800072f0d6100000020790000000043ef005812d866fc300748c0486f00392f0061000000486f0041486f00646100000041ed003c70003039000000007223d081487800212f0072002f012f012f086100000041ed003c70003039000000007224d08148780021487802b742a72f002f08610000004fef004c41ed003c22482c790000000070034eaefeaa41ed003c22482c790000000070004eaefe9e70003039000000003239000000004841424148412401d482d48141ed003c43ef004424494a1a66fc538a95c92f4000202248200a41ef00442c79000000004eaeffca48c094804a826a025282e282202f0020d0822c007224dc81206d007070003028001a722292804a816a025281e28170003028001ad2802a01538541ed003c2248200622052c79000000004eaeff1041ed003c43ef004424494a1a66fc538a95c92248200a41ef00442c79000000004eaeffc4781130043b400034720032002b410020487800412f0d61000000504f4cdf64f4defc00a44e754e71
 *   summary: 404 got vs 374 ref. The original loads the graphics base twice; esq-graphics.h reloads before each of the five library calls. 6.51 also sign-extends the WORD result of TextLength. The grid frame, the prefix copy with its clock-stamp append, both bevel frames split at the column start, the centring divide over three column widths and the font-baseline vertical centring all match in kind and order.
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
    long            visibleLines;   /* +32 */
    char            pad36[16];
    short           halfRow;        /* +52 */
    char            pad54[6];
    struct RastPort rp;             /* +60, rp_Font lands at +112 */
};

extern char *SCRIPT_PtrMovieSummaryForPrefix;
extern unsigned short NEWGRID_ColumnStartXPx;
extern unsigned short NEWGRID_ColumnWidthPx;

extern void NEWGRID_DrawGridFrame(struct GridPanel *panel, long style, long a,
                                  long b, long c);
extern void NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry(long slot, char *out);
extern void PARSEINI_JMPTBL_STRING_AppendAtNull(char *dst, char *src);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(struct RastPort *rp,
                long x0, long y0, long x1, long y1);
extern void NEWGRID_ValidateSelectionCode(struct GridPanel *panel, long code);

void NEWGRID_DrawEmptyGridMessage(struct GridPanel *panel, long unused,
                                  short slot)
{
    char msg[128];
    char stamp[31];
    long x;
    long y;
    unsigned short half;

    NEWGRID_DrawGridFrame(panel, 7, 6, 6, 33);

    strcpy(msg, SCRIPT_PtrMovieSummaryForPrefix);
    NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry((long)slot, stamp);
    PARSEINI_JMPTBL_STRING_AppendAtNull(msg, stamp);

    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(&panel->rp, 0, 0,
        (long)NEWGRID_ColumnStartXPx + 35, 33);
    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(&panel->rp,
        (long)NEWGRID_ColumnStartXPx + 36, 0, 695, 33);

    SetAPen(&panel->rp, 3);
    SetDrMd(&panel->rp, 0);

    x = (long)NEWGRID_ColumnStartXPx
      + ((long)(NEWGRID_ColumnWidthPx * 3)
         - TextLength(&panel->rp, msg, strlen(msg))) / 2 + 36;
    y = (34 - panel->rp.Font->tf_Baseline) / 2
      + panel->rp.Font->tf_Baseline - 1;

    Move(&panel->rp, x, y);
    Text(&panel->rp, msg, strlen(msg));

    half = 17;
    panel->halfRow = half;
    panel->visibleLines = half;

    NEWGRID_ValidateSelectionCode(panel, 65);
}
