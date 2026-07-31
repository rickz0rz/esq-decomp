/* RESTORES: _ED_DrawScrollSpeedMenuText
 * MODULE:   modules/groups/a/l/ed3bb_p1_p0.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: volatile-base-reload
 *   ref:     4e55ffb022790000870270012c79000028584eaefeaa22790000870270004eaefe9e70001039000028d22f00487900002456486dffb04eba226c486dffb04878005a487800282f39000087024ebaa96c48790000247c48780078487800282f39000087024ebaa95448790000249248780096487800282f39000087024ebaa93c4879000024a8487800b4487800282f39000087024ebaa9244fef004c4879000024c4487800d2487800282f39000087024ebaa9084879000024e0487800f0487800282f39000087024ebaa8f04879000024f24878010e487800282f39000087024ebaa8d84879000025044878012c487800282f39000087024ebaa8c04879000025164878014a487800282f39000087024ebaa8a84fef005022790000870270012c79000028584eaefe9e4e5d4e75
 *   got:     9efc00502f0e2279000000002c790000000070014eaefeaa2279000000002c790000000070004eaefe9e70001039000000002f00487900000000486f000c61000000486f00104878005a487800282f39000000006100000048790000000048780078487800282f39000000006100000048790000000048780096487800282f390000000061000000487900000000487800b4487800282f3900000000610000004fef004c487900000000487800d2487800282f390000000061000000487900000000487800f0487800282f3900000000610000004879000000004878010e487800282f3900000000610000004879000000004878012c487800282f3900000000610000004879000000004878014a487800282f3900000000610000004fef00502279000000002c790000000070014eaefe9e2c5fdefc00504e754e71
 *   summary: 316 got vs 302 ref. The original loads the graphics base twice, once for the opening SetAPen/SetDrMd pair and once for the closing SetDrMd; the volatile esq-graphics.h base forces a third reload because a DISPLIB call sits between the two opening calls and the closing one, +6. 6.51 also saves and restores A6 around the body, +4, and pads the object to a longword, +2. The nine DISPLIB_DisplayTextAtPosition calls, the WDISP_SPrintf into the 80-byte frame buffer and both draw-mode changes match in kind, order and argument count. esq-graphics-leaf.h is NOT usable here: ESQ calls sit between library calls, which is exactly the case a6_audit flags.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include "esq-graphics.h"

extern struct RastPort *Global_REF_RASTPORT_1;
extern unsigned char ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED;
extern char ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED_PCT_C[];
extern char Global_STR_SPEED_ZERO_NOT_AVAILABLE[];
extern char Global_STR_SPEED_ONE_NOT_AVAILABLE[];
extern char Global_STR_SCROLL_SPEED_2[];
extern char Global_STR_SCROLL_SPEED_3[];
extern char Global_STR_SCROLL_SPEED_4[];
extern char Global_STR_SCROLL_SPEED_5[];
extern char Global_STR_SCROLL_SPEED_6[];
extern char Global_STR_SCROLL_SPEED_7[];

extern void GROUP_AM_JMPTBL_WDISP_SPrintf(char *buf, char *fmt, long value);
extern void DISPLIB_DisplayTextAtPosition(struct RastPort *rp, long x, long y,
                                          char *text);

void ED_DrawScrollSpeedMenuText(void)
{
    char line[80];

    SetAPen(Global_REF_RASTPORT_1, 1);
    SetDrMd(Global_REF_RASTPORT_1, 0);

    GROUP_AM_JMPTBL_WDISP_SPrintf(line,
        ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED_PCT_C,
        (long)ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 90, line);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 120, Global_STR_SPEED_ZERO_NOT_AVAILABLE);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 150, Global_STR_SPEED_ONE_NOT_AVAILABLE);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 180, Global_STR_SCROLL_SPEED_2);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 210, Global_STR_SCROLL_SPEED_3);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 240, Global_STR_SCROLL_SPEED_4);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 270, Global_STR_SCROLL_SPEED_5);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 300, Global_STR_SCROLL_SPEED_6);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 330, Global_STR_SCROLL_SPEED_7);

    SetDrMd(Global_REF_RASTPORT_1, 1);
}
