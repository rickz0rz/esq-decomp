/* RESTORES: CLEANUP_DrawGridTimeBanner
 * MODULE:   modules/groups/a/d/cleanup3.s
 * STATUS:   behavioural
 *
 * 464 bytes in the original, 468 emitted, 23 differing regions.
 *
 * Reproduces: the timestamp format call, the rp->Flags &= 0xfff7 masking through
 * the struct, the RectFill spanning to TxHeight-1, the save/NUL/restore of
 * buf[9] that splits the time from its AM/PM suffix, both TextLength
 * measurements (9 chars for "12:44:44 ", 11 for "12:44:44 PM"), the (216 -
 * width)/2 centring, both inlined-strlen Text calls, and the nine-argument
 * BltBitMapRastPort with x+448 as the destination.
 *
 * The RastPort field offsets in the original decode as the standard struct: 32
 * Flags, 58 TxHeight, 62 TxBaseline, 4 BitMap.
 *
 * NOTE on the original's constant materialisation, refining what
 * ed_draw_diagnostic_mode_text.c recorded. That file concluded the original only
 * ever doubles (MOVEQ + ADD.L). This function shows a second trick:
 *
 *     215 -> 7428 4602      MOVEQ #40,D2 / NOT.B D2      (~40 = 0xD7 = 215)
 *     216 -> 706c d080      MOVEQ #108,D0 / ADD.L D0,D0
 *
 * so the rule is broader than "doubling only": the original will also
 * bit-invert a small constant to reach a large one, still in four bytes against
 * MOVE.L's six. It remains narrower than SAS/C's arbitrary ASL.L #n. Anyone
 * testing a candidate compiler should check both forms.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ffd8                   LINK.W A5,#-40
 *   got:     9efc0024                   SUBA.W #36,A7
 *   summary: The A5-frame class, which also moves every local from -n(A5) to
 *            n(A7) and accounts for most of the 23 regions.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the four cross-unit calls.
 */
#include "esq-graphics.h"
#include <string.h>

extern void ESQ_FormatTimeStamp(char *buf, void *dayIndex);
extern long GROUP_AC_JMPTBL_PARSEINI_AdjustHoursTo24HrFormat(long hour, long ampm);
extern void GROUP_AE_JMPTBL_WDISP_SPrintf(char *buf, char *fmt, long a, long b, long c);
extern void GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(struct BitMap *src, long sx, long sy,
                                                       void *drp, long dx, long dy,
                                                       long w, long h, long minterm);
extern struct RastPort *Global_REF_RASTPORT_1;
extern short CLOCK_CurrentDayOfWeekIndex;
extern char Global_REF_STR_USE_24_HR_CLOCK[];
extern short Global_WORD_CURRENT_HOUR;
extern short Global_WORD_CURRENT_MINUTE;
extern short Global_WORD_CURRENT_SECOND;
extern short CLOCK_CurrentAmPmFlag;
extern char Global_STR_GRID_TIME_FORMAT_DUPLICATE[];
extern char Global_STR_12_44_44_SINGLE_SPACE[];
extern char Global_STR_12_44_44_PM[];

void CLEANUP_DrawGridTimeBanner(void)
{
    char buf[32];
    register long ampmWidth = 0;
    register long timeWidth;
    register long x;
    register char savedAmPm;
    long hour;

    ESQ_FormatTimeStamp(buf, &CLOCK_CurrentDayOfWeekIndex);
    SetAPen(Global_REF_RASTPORT_1, 7L);
    Global_REF_RASTPORT_1->Flags &= 0xfff7;
    SetDrMd(Global_REF_RASTPORT_1, 0L);
    RectFill(Global_REF_RASTPORT_1, 0L, 0L, 215L,
             (long)Global_REF_RASTPORT_1->TxHeight - 1);
    SetAPen(Global_REF_RASTPORT_1, 3L);

    savedAmPm = buf[9];
    buf[9] = 0;

    if (Global_REF_STR_USE_24_HR_CLOCK[0] == 'Y') {
        hour = GROUP_AC_JMPTBL_PARSEINI_AdjustHoursTo24HrFormat(Global_WORD_CURRENT_HOUR,
                                                                CLOCK_CurrentAmPmFlag);
        GROUP_AE_JMPTBL_WDISP_SPrintf(buf, Global_STR_GRID_TIME_FORMAT_DUPLICATE, hour,
                                      Global_WORD_CURRENT_MINUTE,
                                      Global_WORD_CURRENT_SECOND);
    }

    timeWidth = TextLength(Global_REF_RASTPORT_1, Global_STR_12_44_44_SINGLE_SPACE, 9L);
    if (Global_REF_STR_USE_24_HR_CLOCK[0] == 'N')
        ampmWidth = TextLength(Global_REF_RASTPORT_1, Global_STR_12_44_44_PM, 11L);
    else
        ampmWidth = timeWidth;

    x = (216 - ampmWidth) / 2;
    Move(Global_REF_RASTPORT_1, x, (long)Global_REF_RASTPORT_1->TxBaseline);
    Text(Global_REF_RASTPORT_1, buf, (long)strlen(buf));

    if (Global_REF_STR_USE_24_HR_CLOCK[0] == 'N') {
        buf[9] = savedAmPm;
        Move(Global_REF_RASTPORT_1, x + timeWidth,
             (long)Global_REF_RASTPORT_1->TxBaseline);
        Text(Global_REF_RASTPORT_1, &buf[9], (long)strlen(&buf[9]));
    }

    GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(Global_REF_RASTPORT_1->BitMap, x, 0,
                                               Global_REF_RASTPORT_1, x + 448, 40,
                                               ampmWidth,
                                               (long)Global_REF_RASTPORT_1->TxHeight - 2,
                                               192);
}
