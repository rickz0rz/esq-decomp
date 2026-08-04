/* RESTORES: CLEANUP_DrawClockBanner
 * MODULE:   modules/groups/a/d/cleanup3.s
 * STATUS:   behavioural
 *
 * 400 bytes in the original, 408 emitted, 20 differing regions.
 *
 * Reproduces: the busy-flag early return, the 24-hour/grid format branch with
 * AdjustHoursTo24HrFormat feeding SPrintf, both RectFill calls, the bevel frame,
 * the vertical centring (34 - tf_Baseline)/2 + tf_Baseline - 1, and the
 * nine-argument BltBitMapRastPort call with the rastport's own bitmap as source.
 *
 * Two things worth noting about how the original was compiled:
 *
 *   - strlen() is INLINED as a scan loop (LEA buf,A0 / MOVEA.L A0,A1 /
 *     TST.B (A1)+ / BNE / SUBQ.L #1,A1 / SUBA.L A0,A1) rather than called. SAS/C
 *     6.51 inlines it the same way, so writing strlen(buf) is correct here and
 *     no library call is involved.
 *   - the tail relies on UNLK to discard the argument pushes rather than
 *     emitting a LEA cleanup, while the two SPrintf calls inside the branches DO
 *     get explicit LEA cleanups so the stack is balanced at the merge. Both
 *     behaviours reproduce.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff4                   LINK.W A5,#-12
 *   got:     9efc000c                   SUBA.W #12,A7
 *   summary: The A5-frame class. This also forces every local reference to move
 *            from -n(A5) to n(A7), which is most of the 20 regions.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the five cross-unit calls.
 */
#include "esq-graphics.h"
#include <string.h>

extern long PARSEINI_AdjustHoursTo24HrFormat(long hour, long ampm);
extern void WDISP_SPrintf(char *buf, char *fmt, long a, long b, long c);
extern void BEVEL_DrawBevelFrameWithTopRight(void *rp, long x0, long y0, long x1, long y1);
extern void GRAPHICS_BltBitMapRastPort(struct BitMap *src, long sx, long sy,
                                                       void *drp, long dx, long dy,
                                                       long w, long h, long minterm);
extern struct RastPort *NEWGRID_MainRastPortPtr;
extern short Global_UIBusyFlag;
extern char Global_REF_STR_USE_24_HR_CLOCK[];
extern short Global_WORD_CURRENT_HOUR;
extern short Global_WORD_CURRENT_MINUTE;
extern short Global_WORD_CURRENT_SECOND;
extern short CLOCK_CurrentAmPmFlag;
extern short NEWGRID_ColumnStartXPx;
extern char Global_STR_EXTRA_TIME_FORMAT[];
extern char Global_STR_GRID_TIME_FORMAT[];

void CLEANUP_DrawClockBanner(void)
{
    char buf[10];
    long hour;
    struct TextFont *font;
    long y;

    if (Global_UIBusyFlag)
        return;

    if (Global_REF_STR_USE_24_HR_CLOCK[0] == 'Y') {
        hour = PARSEINI_AdjustHoursTo24HrFormat(Global_WORD_CURRENT_HOUR,
                                                                CLOCK_CurrentAmPmFlag);
        WDISP_SPrintf(buf, Global_STR_EXTRA_TIME_FORMAT, hour,
                                      Global_WORD_CURRENT_MINUTE,
                                      Global_WORD_CURRENT_SECOND);
    } else {
        WDISP_SPrintf(buf, Global_STR_GRID_TIME_FORMAT,
                                      Global_WORD_CURRENT_HOUR,
                                      Global_WORD_CURRENT_MINUTE,
                                      Global_WORD_CURRENT_SECOND);
    }

    SetAPen(NEWGRID_MainRastPortPtr, 7L);
    RectFill(NEWGRID_MainRastPortPtr, 0L, 0L, 35L, 33L);
    SetAPen(NEWGRID_MainRastPortPtr, 7L);
    RectFill(NEWGRID_MainRastPortPtr, 36L, 0L, NEWGRID_ColumnStartXPx + 35L, 33L);
    BEVEL_DrawBevelFrameWithTopRight(NEWGRID_MainRastPortPtr, 0, 0,
                                     NEWGRID_ColumnStartXPx + 35L, 33L);

    font = NEWGRID_MainRastPortPtr->Font;
    y = (34 - font->tf_Baseline) / 2 + font->tf_Baseline - 1;
    Move(NEWGRID_MainRastPortPtr, 44L, y);
    SetAPen(NEWGRID_MainRastPortPtr, 1L);
    Text(NEWGRID_MainRastPortPtr, buf, (long)strlen(buf));

    GRAPHICS_BltBitMapRastPort(NEWGRID_MainRastPortPtr->BitMap, 0, 0,
                                               NEWGRID_MainRastPortPtr, 0, 34,
                                               NEWGRID_ColumnStartXPx + 36L, 34, 192);
}
