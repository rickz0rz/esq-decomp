/* RESTORES: WDISP_DrawWeatherStatusDayEntry
 * MODULE:   modules/groups/b/a/wdisp.s
 * STATUS:   behavioural
 * DO-NOT-LINK: address error (Guru 8000 0003) within 50 seconds of boot
 *
 * MEASURED, NOT SUSPECTED, and measured SEPARATELY from its sibling. After
 * src/c/wdisp_draw_weather_status_overlay.c was excluded the build still
 * gurued, and a second tools/bisect_added.sh run over the remaining six entries
 * named this file. The confirmation build -- the verified baseline plus this
 * ONE restoration -- gurus as well.
 *
 * TWO SIBLINGS, ONE FAULT CLASS. Both failing files are the only two
 * restorations that call BRUSH_SelectBrushSlot and BRUSH_PlaneMaskForIndex, and
 * both paint a brush palette and four accumulator rows through the same brush
 * record. The seven NEWGRID restorations in the same tranche, which touch none
 * of that, all pass. So the fault is in the brush block the two share, not in
 * either file's own layout code. That is the strongest lead and it is why these
 * two are recorded together.
 *
 * The brush field offsets used here (176 width, 178 height, 184 plane selector,
 * 200 accumulator rows, 232 palette) are all even, so none of them explains an
 * ODD-address fault by itself. Re-derive them from a listing before assuming
 * they are right -- AGENTS.md warns that DATA=FAR hides a wrong struct offset
 * from cdiff entirely.
 *
 * It still counts toward coverage, which is read from these headers. It must
 * not go into a manifest until the address error is found and fixed.
 *
 * One of the four day panels of the weather display. The panel is a third of
 * the total width, positioned by the day index, and it holds a condition
 * brush, a high/low temperature line, and the weekday name.
 *
 * A day entry whose `forecast` field is non-zero replaces the brush and the
 * temperature line with up to four wrapped lines of forecast text. The weekday
 * name is drawn in both cases, which is why it sits after the two arms rather
 * than inside them.
 *
 * The brush selector is clamped to 2 when the entry asks for a forecast, or
 * when the value is outside 2..6. A clamped selector also clears usePalette, so
 * the panel restores the base palette instead of taking the brush's own.
 *
 * A temperature of -999 means "not known" and selects a fixed string instead of
 * a number.
 *
 * NOTE the palette path leaves WDISP_AccumulatorCaptureActive SET. The flag is
 * raised before the usePalette test and only lowered inside the arm that copies
 * the brush palette. That asymmetry is in the original and is reproduced.
 *
 * The forecast loop calls NEWGRID_DrawWrappedText twice per line: once with the
 * draw flag clear, to find where the line breaks, and once to draw it. Between
 * the two it writes a NUL at the break point to measure the line, then puts the
 * original character back.
 *
 * SASC-MISMATCH: a5-frame-and-runtime-arithmetic
 *   ref:     4e55ff8c                   LINK.W A5,#-116
 *   got:     9efc0074                   SUBA.W #116,A7
 *   summary: 1348 bytes in the original against 1424 emitted, +76 over 63
 *            regions. The frame class leads. The original also calls
 *            MATH_DivS32 once and MATH_Mulu32 six times with register
 *            arguments, where 6.51 calls __CXD33/__CXM33 or strength-reduces.
 *            The weekday index needs the REMAINDER of that divide, which a C
 *            return value cannot carry, so this file uses `%`. The rest is
 *            block ordering and is NOT itemised -- see AGENTS.md rule 3.
 *   scope:   program-wide.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include "esq-exec.h"
#include "esq-graphics.h"
#include <string.h>

struct WBrush {
    char           pad0[176];
    unsigned short w;               /* 176 */
    unsigned short h;               /* 178 */
    char           pad1[4];
    unsigned char  planeSel;        /* 184 */
    char           pad2[15];
    unsigned char  rows[32];        /* 200 */
    unsigned char  pal[124];        /* 232 */
};
struct WBrushHead { struct WBrush *first; };

struct WDayEntry {                  /* 20 bytes */
    long f0;
    long kind;                      /* 4  brush selector */
    long high;                      /* 8  -999 = unknown */
    long low;                       /* 12 -999 = unknown */
    long forecast;                  /* 16 non-zero = multi-line forecast */
};

extern struct WBrush *WDISP_JMPTBL_BRUSH_FindBrushByPredicate(char *name,
                                                  struct WBrushHead *head);
extern long WDISP_JMPTBL_BRUSH_PlaneMaskForIndex(long index);
extern void WDISP_JMPTBL_BRUSH_SelectBrushSlot(struct WBrush *b, long x0,
                                               long y0, long x1, long y1,
                                               struct RastPort *rp, long z);
extern void WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples(void);
extern char *WDISP_JMPTBL_NEWGRID_DrawWrappedText(struct RastPort *rp, long x,
                                                  long y, long width,
                                                  char *text, long draw);
extern void WDISP_SPrintf(char *buf, char *fmt, ...);
extern void STRING_AppendAtNull(char *dst, char *src);

extern struct WBrushHead ESQFUNC_PwBrushListHead;
extern char  *ESQFUNC_STR_I5[];
extern struct WDayEntry WDISP_StatusDayEntry0[];
extern char  *P_TYPE_WeatherForecastMsgPtr;
extern char  *Global_JMPTBL_DAYS_OF_WEEK[];
extern char   WDISP_STR_UNKNOWN_NUM_WITH_SLASH[];
extern char   WDISP_STR_UNKNOWN_NUM[];
extern char   Global_STR_PERCENT_D_SLASH[];
extern char   Global_STR_PERCENT_D[];
extern unsigned char WDISP_CharClassTable[];
extern unsigned char WDISP_PaletteTriplesRBase[];
extern unsigned char WDISP_AccumulatorRowTable[];
extern short  WDISP_AccumulatorCaptureActive;
extern short  WDISP_AccumulatorFlushPending;
extern short  CLOCK_CurrentDayOfWeekIndex;
extern struct TextFont *Global_HANDLE_PREVUEC_FONT;

void WDISP_DrawWeatherStatusDayEntry(struct RastPort *rp, long day,
                                     long totalWidth, long panelHeight)
{
    char hi[20], lo[10];
    struct WBrush *brush;
    struct WDayEntry *e;
    char *p, *split, saved;
    long colWidth, colX, brushWidth, brushHeight;
    long usePalette, brushIndex, lineIndex, yOffset;
    long planeA, planeB, i, len, drawn, x, y;

    brush = 0;
    lineIndex = yOffset = 0;
    usePalette = 1;

    if (day < 0 || day >= 4)
        return;

    colWidth = totalWidth / 3;
    colX = colWidth * day;

    e = &WDISP_StatusDayEntry0[day];
    brushIndex = e->kind;
    if (e->forecast == 1 || brushIndex < 2 || brushIndex > 6) {
        usePalette = 0;
        brushIndex = 2;
    }

    brush = WDISP_JMPTBL_BRUSH_FindBrushByPredicate(ESQFUNC_STR_I5[brushIndex],
                                                    &ESQFUNC_PwBrushListHead);
    if (brush != 0) {
        brushHeight = brush->h;
        brushWidth  = brush->w;
    } else {
        brushHeight = 90;
        usePalette  = 0;
        brushWidth  = 0;
    }

    e = &WDISP_StatusDayEntry0[day];
    if (e->forecast == 0) {
        WDISP_AccumulatorCaptureActive = 1;
        WDISP_AccumulatorFlushPending = 0;

        if (usePalette == 0) {
            WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples();
        } else {
            planeA = WDISP_JMPTBL_BRUSH_PlaneMaskForIndex(5L) * 3;
            planeB = WDISP_JMPTBL_BRUSH_PlaneMaskForIndex(
                         (long)brush->planeSel) * 3;

            for (i = 0; i < planeB && i < planeA; i++)
                WDISP_PaletteTriplesRBase[i] = brush->pal[i];
            for (i = 0; i < 4; i++)
                CopyMem(&brush->rows[i * 8], &WDISP_AccumulatorRowTable[i * 8],
                        8L);

            WDISP_AccumulatorCaptureActive = 0;
            WDISP_AccumulatorFlushPending = 1;

            x = colX + (colWidth - brushWidth) / 2;
            y = panelHeight - brushHeight
                - (long)Global_HANDLE_PREVUEC_FONT->tf_Baseline - 5;
            WDISP_JMPTBL_BRUSH_SelectBrushSlot(brush, x, y, x + brushWidth,
                                               y + brushHeight, rp, 0L);
        }

        e = &WDISP_StatusDayEntry0[day];
        if (e->high == -999)
            strcpy(hi, WDISP_STR_UNKNOWN_NUM_WITH_SLASH);
        else
            WDISP_SPrintf(hi, Global_STR_PERCENT_D_SLASH,
                          WDISP_StatusDayEntry0[day].high);

        if (WDISP_StatusDayEntry0[day].low == -999)
            strcpy(lo, WDISP_STR_UNKNOWN_NUM);
        else
            WDISP_SPrintf(lo, Global_STR_PERCENT_D,
                          WDISP_StatusDayEntry0[day].low);

        STRING_AppendAtNull(hi, lo);
        SetAPen(rp, 1L);
        SetDrMd(rp, 0L);
        len = (long)strlen(hi);
        drawn = TextLength(rp, hi, len);
        x = colX + (colWidth - drawn) / 2;
        y = panelHeight - 5;
        Move(rp, x, y);
        Text(rp, hi, len);
    } else {
        p = P_TYPE_WeatherForecastMsgPtr;
        colWidth -= 20;
        lineIndex = 0;
        yOffset = 0x8c;
        SetAPen(rp, 1L);
        SetDrMd(rp, 0L);

        while (p != 0 && lineIndex < 4) {
            while (WDISP_CharClassTable[*p] & 8)
                p++;

            split = WDISP_JMPTBL_NEWGRID_DrawWrappedText(rp, colX, yOffset,
                                                         colWidth, p, 0L);
            if (split != 0) {
                saved = *split;
                *split = 0;
                len = (long)strlen(p);
                *split = saved;
                drawn = TextLength(rp, p, len);
                x = colX + (colWidth - drawn + 20) / 2;
                p = WDISP_JMPTBL_NEWGRID_DrawWrappedText(rp, x, yOffset,
                                                         colWidth, p, 1L);
                yOffset += (long)Global_HANDLE_PREVUEC_FONT->tf_YSize + 4;
                lineIndex++;
            } else {
                len = (long)strlen(p);
                drawn = TextLength(rp, p, len);
                x = colX + (colWidth - drawn + 20) / 2;
                p = WDISP_JMPTBL_NEWGRID_DrawWrappedText(rp, x, yOffset,
                                                         colWidth, p, 1L);
            }
        }
        colWidth += 20;
    }

    strcpy(hi, Global_JMPTBL_DAYS_OF_WEEK[
               ((long)CLOCK_CurrentDayOfWeekIndex + day + 1) % 7]);
    len = (long)strlen(hi);
    drawn = TextLength(rp, hi, len);
    x = colX + (colWidth - drawn) / 2;
    y = panelHeight - brushHeight
        - (long)Global_HANDLE_PREVUEC_FONT->tf_YSize - 5;
    SetAPen(rp, 3L);
    SetDrMd(rp, 0L);
    Move(rp, x, y);
    Text(rp, hi, len);
}
