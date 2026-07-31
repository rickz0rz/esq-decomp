/* RESTORES: _NEWGRID_DrawGridMessageAlt
 * MODULE:   modules/groups/b/a/newgrid1b_p2_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: volatile-base-reload
 *   ref:     4e55fff448e72110266f00204878002120390000aa262f002f00487800072f0b4ebabdc041eb003c700030390000b40c7223d081487800212f0072002f012f012f084eba207241eb003c700030390000b40c7224d08148780021487802b742a72f002f084eba20504fef003c41eb003c224820390000aa222c79000028584eaefeaa41eb003c224870004eaefe9e20790000aa444a1866fc538891f90000aa442e0841eb003c2248200720790000aa442c79000028584eaeffca32390000b40ec2fc0003740c9282b0816f04538760d241eb003c700030390000b40c32390000b40ec2fc000343eb003c2f4000102f4100142f48000c200720790000aa442c79000028584eaeffca222f001492804a816a025281e281202f0010d0817224d081206b007072003228001a742294814a826a025282e28272003228001ad48153822202226f000c4eaeff1041eb003c2248200720790000aa444eaeffc47011374000347200320027410020487800442f0b6100c47c4ced0884ffe84e5d4e75
 *   got:     594f48e72f062a6f0024487800212039000000002f002f00487800072f0d6100000041ed003c70003039000000007223d081487800212f0072002f012f012f086100000041ed003c70003039000000007224d08148780021487802b742a72f002f08610000004fef003c41ed003c22482039000000002c79000000004eaefeaa41ed003c22482c790000000070004eaefe9e20790000000020084a1866fc538891c02e0841ed003c224820790000000020072c79000000004eaeffca3239000000004841424148412401d482d481720c948148c0b0826f04538760c870003039000000003239000000004841424148412401d482d48141ed003c2f40001c224820790000000020072c79000000004eaeffca48c094804a826a025282e282202f001cd0822c007224dc81206d007070003028001a722292804a816a025281e28170003028001ad2802a01538541ed003c2248200622052c79000000004eaeff1041ed003c224820790000000020072c79000000004eaeffc4781130043b400034720032002b410020487800442f0d61000000504f4cdf60f4584f4e75
 *   summary: 412 got vs 382 ref. The original loads the graphics base three times; esq-graphics.h reloads before each of the seven library calls, and 6.51 sign-extends the WORD from TextLength at both sites. The frame, both bevels split at the column start, the shrink-to-fit loop against three column widths minus twelve, the centring divide, the font-baseline vertical centring and the 17-pixel half-row store match in kind and order.
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

extern long  GCOMMAND_PpvMessageFramePen;
extern long  GCOMMAND_PpvMessageTextPen;
extern char *GCOMMAND_PPVPeriodTemplatePtr;
extern unsigned short NEWGRID_ColumnStartXPx;
extern unsigned short NEWGRID_ColumnWidthPx;

extern void NEWGRID_DrawGridFrame(struct GridPanel *panel, long style, long a,
                                  long b, long c);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(struct RastPort *rp,
                long x0, long y0, long x1, long y1);
extern void NEWGRID_ValidateSelectionCode(struct GridPanel *panel, long code);

void NEWGRID_DrawGridMessageAlt(struct GridPanel *panel)
{
    long len;
    long x;
    long y;
    unsigned short half;

    NEWGRID_DrawGridFrame(panel, 7, GCOMMAND_PpvMessageFramePen,
                          GCOMMAND_PpvMessageFramePen, 33);

    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(&panel->rp, 0, 0,
        (long)NEWGRID_ColumnStartXPx + 35, 33);
    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(&panel->rp,
        (long)NEWGRID_ColumnStartXPx + 36, 0, 695, 33);

    SetAPen(&panel->rp, GCOMMAND_PpvMessageTextPen);
    SetDrMd(&panel->rp, 0);

    len = strlen(GCOMMAND_PPVPeriodTemplatePtr);
    while (TextLength(&panel->rp, GCOMMAND_PPVPeriodTemplatePtr, len)
           > (long)(NEWGRID_ColumnWidthPx * 3) - 12)
        len--;

    x = (long)NEWGRID_ColumnStartXPx
      + ((long)(NEWGRID_ColumnWidthPx * 3)
         - TextLength(&panel->rp, GCOMMAND_PPVPeriodTemplatePtr, len)) / 2 + 36;
    y = (34 - panel->rp.Font->tf_Baseline) / 2
      + panel->rp.Font->tf_Baseline - 1;

    Move(&panel->rp, x, y);
    Text(&panel->rp, GCOMMAND_PPVPeriodTemplatePtr, len);

    half = 17;
    panel->halfRow = half;
    panel->visibleLines = half;

    NEWGRID_ValidateSelectionCode(panel, 68);
}
