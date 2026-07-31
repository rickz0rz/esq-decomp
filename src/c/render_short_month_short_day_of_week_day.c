/* RESTORES: _RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY
 * MODULE:   modules/groups/a/c/cleanup2_p1_p0.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: volatile-base-reload
 *   ref:     4e55ffdc48e73700207900008702217c00008732000430390000a31248c0e58041f9000072ccd1c030390000a31448c0e58043f900007218d3c030390000a31648c02f002f112f10487900000366486dffe04eba338e4fef001422790000870270072c79000028584eaefeaa207900008702302800200240fff720790000870231400020224870002c79000028584eaefe9e70002079000087023028003a53802248260070002200742846024eaefece22790000870270034eaefeaa41edffe022484a1966fc538993c82c0920062279000087024eaeffca2a00706cd08090854a806a025280e2802e0070002079000087023028003e2f40001422482007222f00144eaeff10200622790000870241edffe04eaeffc470002079000087023028003a5580487800c02f00487800d0487800284878002c2f0872002f012f012f2800044eba0b684ced00ecffc84e5d4e75
 *   got:     9efc002048e73702207900000000217c00000000000430390000000048c02200e58141f900000000d1c130390000000048c02200e58143f900000000d3c130390000000048c02f002f112f10487900000000486f0028610000002279000000002c790000000070074eaefeaa70002079000000003028002002800000fff72079000000003140002022482c790000000070004eaefe9e70002079000000003028003a5380224826002c790000000070002200742846024eaefece2279000000002c790000000070034eaefeaa41ef002c22484a1966fc538993c82e0922790000000020072c79000000004eaeffca48c0726cd28192804a816a025281e2812c017a002079000000003a28003e2248200622052c79000000004eaeff1022790000000041ef002c20072c79000000004eaeffc470002079000000003028003a5580487800c02f00487800d0487800284878002c2f0872002f012f012f280004610000004fef00384cdf40ecdefc00204e75
 *   summary: 368 got vs 336 ref. The original loads the graphics base three times; esq-graphics.h reloads before each of the seven library calls, and the RastPort pointer global is reloaded per use in both. The bitmap swap, the SPrintf with its two table lookups, the Flags AND, the 216-wide RectFill, the centring divide against 216 and the nine-argument BltBitMapRastPort match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include <string.h>
#include "esq-graphics.h"

extern struct RastPort *Global_REF_RASTPORT_1;
extern struct BitMap    Global_REF_696_400_BITMAP;
extern short CLOCK_CurrentDayOfWeekIndex;
extern short CLOCK_CurrentMonthIndex;
extern short CLOCK_CurrentDayOfMonth;
extern char *Global_JMPTBL_SHORT_DAYS_OF_WEEK[];
extern char *Global_JMPTBL_SHORT_MONTHS[];
extern char  Global_STR_SHORT_MONTH_SHORT_DAY_OF_WEEK_FORMATTED[];

extern void GROUP_AE_JMPTBL_WDISP_SPrintf(char *buf, char *fmt, char *day,
                                          char *month, long dom);
extern void GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(struct BitMap *src,
                long sx, long sy, struct RastPort *rp, long dx, long dy,
                long w, long h, long minterm);

void RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY(void)
{
    char buf[32];
    long len;
    long x;
    long y;

    Global_REF_RASTPORT_1->BitMap = &Global_REF_696_400_BITMAP;

    GROUP_AE_JMPTBL_WDISP_SPrintf(buf,
        Global_STR_SHORT_MONTH_SHORT_DAY_OF_WEEK_FORMATTED,
        Global_JMPTBL_SHORT_DAYS_OF_WEEK[CLOCK_CurrentDayOfWeekIndex],
        Global_JMPTBL_SHORT_MONTHS[CLOCK_CurrentMonthIndex],
        (long)CLOCK_CurrentDayOfMonth);

    SetAPen(Global_REF_RASTPORT_1, 7);
    Global_REF_RASTPORT_1->Flags = Global_REF_RASTPORT_1->Flags & 0xfff7;
    SetDrMd(Global_REF_RASTPORT_1, 0);
    RectFill(Global_REF_RASTPORT_1, 0, 0, 215,
             (long)Global_REF_RASTPORT_1->TxHeight - 1);
    SetAPen(Global_REF_RASTPORT_1, 3);

    len = strlen(buf);
    x = (216 - TextLength(Global_REF_RASTPORT_1, buf, len)) / 2;
    y = Global_REF_RASTPORT_1->TxBaseline;
    Move(Global_REF_RASTPORT_1, x, y);
    Text(Global_REF_RASTPORT_1, buf, len);

    GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(Global_REF_RASTPORT_1->BitMap,
        0, 0, Global_REF_RASTPORT_1, 44, 40, 208,
        (long)Global_REF_RASTPORT_1->TxHeight - 2, 192);
}
