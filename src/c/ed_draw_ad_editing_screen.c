/* RESTORES: _ED_DrawAdEditingScreen
 * MODULE:   modules/groups/a/l/ed3bbbb_p2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: volatile-base-reload
 *   ref:     4e55ffd448e73000487800066100f36822790000870270002c79000028584eaefe9e22790000870270014eaefeaa4879000026484878014a487800282f39000087024eba9e8c48790000266e48780168487800282f39000087024eba9e7448790000269448780186487800282f39000087024eba9e5c2eb9000081906100fc2c2eb9000023286100fba422790000870270072c79000028584eaefeaa700890b9000085ca721e4eba52d2223c0000012e92802279000087027028243c00000280263c000001344eaefece22790000870270014eaefeaa22790000870270074eaefea42eb90000860a4879000026ba486dffd74eba16c6486dffd74878012c487800be2f39000087024eba9dc64fef004c22790000870270012c79000028584eaefe9e22790000870270024eaefea44cdf000c4e5d4e75
 *   got:     9efc002c48e731027e1e48780006610000002279000000002c790000000070004eaefe9e2279000000002c790000000070014eaefeaa4879000000004878014a487800282f39000000006100000048790000000048780168487800282f39000000006100000048790000000048780186487800282f3900000000610000002eb900000000610000002eb900000000610000002279000000002c790000000070074eaefeaa700890b900000000220761000000223c0000012e92802279000000002c790000000070287450e78a764de58b4eaefece2279000000002c790000000070014eaefeaa2279000000002c790000000070074eaefea42eb900000000487900000000486f004b61000000486f004f4878012c487800be2f3900000000610000004fef004c2279000000002c790000000070014eaefe9e2279000000002c790000000070024eaefea44cdf408cdefc002c4e75
 *   summary: 340 got vs 310 ref. The original loads the graphics base three times; esq-graphics.h reloads before each of the eight library calls. The row height of 30 is held in a local so the fill-height scaling calls the 32x32 helper as the original does. The help panel, the three status lines, both draw helpers fed from their globals, the RectFill whose top edge scales with the text limit, the ad-number label and the two pen restores match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include "esq-graphics.h"

extern struct RastPort *Global_REF_RASTPORT_1;
extern long ED_TextLimit;
extern long Global_REF_BOOL_IS_LINE_OR_PAGE;
extern long Global_REF_BOOL_IS_TEXT_OR_CURSOR;
extern long Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;
extern char Global_STR_PUSH_ESC_TO_MAKE_ANOTHER_SELECTION[];
extern char Global_STR_PUSH_HELP_FOR_OTHER_EDIT_FUNCTIONS[];
extern char Global_STR_LINE_MODE_ON_TEXT_COLOR_MODE[];
extern char Global_STR_EDITING_AD_NUMBER_FORMATTED_1[];

extern void ED_DrawHelpPanels(long mode);
extern void DISPLIB_DisplayTextAtPosition(struct RastPort *rp, long x, long y,
                                          char *text);
extern void SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE(long mode);
extern void SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR(long mode);
extern long __asm MATH_Mulu32(register __d0 long a,
                        register __d1 long b);
extern void WDISP_SPrintf(char *buf, char *fmt, long n);

void ED_DrawAdEditingScreen(void)
{
    char label[41];
    long rows;

    rows = 30;

    ED_DrawHelpPanels(6);

    SetDrMd(Global_REF_RASTPORT_1, 0);
    SetAPen(Global_REF_RASTPORT_1, 1);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 330,
                                  Global_STR_PUSH_ESC_TO_MAKE_ANOTHER_SELECTION);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 360,
                                  Global_STR_PUSH_HELP_FOR_OTHER_EDIT_FUNCTIONS);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 390,
                                  Global_STR_LINE_MODE_ON_TEXT_COLOR_MODE);

    SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE(Global_REF_BOOL_IS_LINE_OR_PAGE);
    SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR(Global_REF_BOOL_IS_TEXT_OR_CURSOR);

    SetAPen(Global_REF_RASTPORT_1, 7);
    RectFill(Global_REF_RASTPORT_1, 40, 302 - (8 - ED_TextLimit) * rows, 640,
             308);
    SetAPen(Global_REF_RASTPORT_1, 1);
    SetBPen(Global_REF_RASTPORT_1, 7);

    WDISP_SPrintf(label,
        Global_STR_EDITING_AD_NUMBER_FORMATTED_1,
        Global_REF_LONG_CURRENT_EDITING_AD_NUMBER);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 190, 300, label);

    SetDrMd(Global_REF_RASTPORT_1, 1);
    SetBPen(Global_REF_RASTPORT_1, 2);
}
