/* RESTORES: WDISP_DrawWeatherStatusOverlay
 * MODULE:   modules/groups/b/a/wdisp.s
 * STATUS:   behavioural
 * RETESTED 2026-08-02: the address error NO LONGER REPRODUCES, so the
 * DO-NOT-LINK marker is lifted and this file is in `replacements-all.txt`.
 * Linked at 770 entries it survives two 150-second soaks and one of 300 -- all
 * far past the 50-second window in which the guru used to be certain -- plus
 * the ESC open/close/open probe and a sweep of all six ESC-menu items.
 * `guru_detect.py` exits 0 on every shot set. Nothing in this file changed, so
 * the cause was elsewhere. Between the two measurements this project fixed the
 * register-argument class, the extern-width class, the extern-shape class and
 * the far-call branch-target defect. Any of them could have been the cause.
 * The analysis below is kept because it is still the record of what was ruled
 * out, and because a fault that stopped reproducing is not a fault that was
 * understood. If the guru returns, start here.
 *
 * MEASURED, NOT SUSPECTED. tools/bisect_added.sh over the 14 entries this
 * tranche added named this file, and the confirmation build -- the 272-entry
 * verified baseline plus this ONE restoration -- gurus as well. The alert is
 * `Software Failure. Error: 8000 0003`, which is a 68000 ADDRESS ERROR: a word
 * or long access at an odd address. It appears with no key pressed, so it is
 * the ordinary display cycle that trips it, not the ESC menu.
 *
 * Nothing else can see it. The file compiles, `cdiff` puts it 70 bytes over the
 * original across 54 regions with the control flow aligned, it links,
 * verify_restorations locates every byte of it, a6_audit passes, and
 * check_pcrel_range is clean. The emulator is the only oracle that disagrees.
 *
 * WHAT WAS RULED OUT by re-reading the original against this file: the argument
 * order and count of all six calls, the brush field offsets 176/178/184/200/232
 * /356/360 (all even, so none of them can be the odd access on their own), the
 * palette and accumulator copy bounds, the three guard tests, the line-split
 * loop, and the fallback arm. The fault is therefore NOT one of the obvious
 * shapes and needs a real hunt -- most likely with a memory watch on the
 * emulator rather than by reading more assembly.
 *
 * The restoration stays here because the analysis above is worth keeping and
 * because it counts toward coverage, which is read from these headers.
 *
 * The weather overlay: a status brush, one status line above it, and up to ten
 * body lines laid out in left/right pairs below it. When no weather data is
 * live the whole body is skipped and one centered fallback line is drawn
 * instead.
 *
 * The body text arrives as ONE string with character 24 as the line separator.
 * The function copies it, rewrites every separator to a NUL in place, and then
 * walks the pieces. That is why it frees the copy at the end through
 * MEMORY_DeallocateMemory with the length it measured at the start.
 *
 * Brush index 1 selects the brush by predicate name and draws NO brush; any
 * other index selects by table lookup and paints the brush, its palette
 * triples, and four 8-byte accumulator rows. The palette copy stops at the
 * SMALLER of two plane-mask products, so a brush with fewer planes than the
 * base copies fewer bytes.
 *
 * The line pairs alternate side: the even line is centered inside halfWidth,
 * the odd line is right-aligned against the full width. Both use the same y.
 *
 * MATH_Mulu32 and MATH_DivS32 are register-argument helpers, so this file uses
 * C operators and SAS/C calls its own __CXM33/__CXD33. See
 * src/c/datetime_adjust_month_index.c for why calling them from C is wrong.
 *
 * SASC-MISMATCH: a5-frame-and-runtime-arithmetic
 *   ref:     4e55ff1c                   LINK.W A5,#-228
 *   got:     9efc00d4                   SUBA.W #212,A7
 *   summary: 1378 bytes in the original against 1448 emitted, +70 over 54
 *            regions. The frame class leads. The multiply and the two divides
 *            also differ: the original calls MATH_Mulu32/MATH_DivS32 with the
 *            arguments already in D0/D1, and 6.51 calls __CXM33/__CXD33 with
 *            its own sequence. The remainder is block ordering and is NOT
 *            itemised -- see AGENTS.md rule 3.
 *   scope:   program-wide; every restoration that divides pays the same.
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
    long           slotFlagA;       /* 356 */
    long           slotFlagB;       /* 360 */
};
struct WBrushHead { struct WBrush *first; };

extern struct WBrush *BRUSH_FindBrushByPredicate(char *name,
                                                  struct WBrushHead *head);
extern long BRUSH_PlaneMaskForIndex(long index);
extern void BRUSH_SelectBrushSlot(struct WBrush *b, long a,
                                               long y, long w, long h,
                                               struct RastPort *rp, long z);
extern long ESQFUNC_TrimTextToPixelWidthWordBoundary(
                                struct RastPort *rp, long width, char *text);
extern char *ESQPARS_ReplaceOwnedString(char *src, char *old);
extern void MEMORY_DeallocateMemory(char *who, long line, char *p, long size);

extern struct WBrushHead ESQFUNC_PwBrushListHead;
extern char  *ESQFUNC_WeatherBrushPredicateNames;
extern char  *ESQFUNC_STR_I5[];
extern char  *WDISP_WeatherStatusOverlayTextPtr;
extern char  *WDISP_WeatherStatusTextPtr;
extern char  *P_TYPE_WeatherCurrentMsgPtr;
extern char  *Global_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE;
extern unsigned char WDISP_WeatherStatusCountdown;
extern unsigned char WDISP_WeatherStatusBrushIndex;
extern short  WDISP_WeatherStatusDigitChar;
extern unsigned char WDISP_PaletteTriplesRBase[];
extern unsigned char WDISP_AccumulatorRowTable[];
extern short  WDISP_AccumulatorCaptureActive;
extern short  WDISP_AccumulatorFlushPending;
extern struct TextFont *Global_HANDLE_PREVUEC_FONT;

void WDISP_DrawWeatherStatusOverlay(struct RastPort *rp, long width, long height)
{
    char statusText[128];
    char *dup, *cur, *fallback;
    struct WBrush *brush;
    long brushWidth, brushHeight, dupLen1;
    long lineCount, lineIndex, baseY, y, halfWidth;
    long fontYSize, half, rowStep, planeA, planeB, i;
    long textLen, drawn, x;

    dup = 0;
    lineIndex = lineCount = 0;

    if (WDISP_WeatherStatusCountdown != 0 &&
        WDISP_WeatherStatusDigitChar != '0') {

        if (WDISP_WeatherStatusBrushIndex == 1)
            brush = BRUSH_FindBrushByPredicate(
                        ESQFUNC_WeatherBrushPredicateNames,
                        &ESQFUNC_PwBrushListHead);
        else
            brush = BRUSH_FindBrushByPredicate(
                        ESQFUNC_STR_I5[WDISP_WeatherStatusBrushIndex],
                        &ESQFUNC_PwBrushListHead);

        if (brush != 0) {
            brushWidth  = brush->w;
            brushHeight = brush->h;
        } else {
            brushHeight = 90;
            brushWidth  = 0xaa;
        }

        dup = ESQPARS_ReplaceOwnedString(
                  WDISP_WeatherStatusOverlayTextPtr, dup);
        dupLen1 = (long)strlen(dup) + 1;
        cur = dup;

        while (*cur) {
            if (*cur == 24) {
                *cur = 0;
                lineCount++;
            }
            cur++;
        }

        cur = dup;
        if (*dup == 0) {
            cur++;
            lineCount--;
        }
        if (lineCount > 10)
            lineCount = 10;

        SetRast(rp, 0L);
        SetDrMd(rp, 0L);
        SetAPen(rp, 1L);
        SetFont(rp, Global_HANDLE_PREVUEC_FONT);

        baseY = height - (long)Global_HANDLE_PREVUEC_FONT->tf_Baseline
                       - brushHeight - 5;

        if (WDISP_WeatherStatusBrushIndex != 1 && brush != 0) {
            brush->slotFlagA = 1;
            brush->slotFlagB = 1;
            planeA = BRUSH_PlaneMaskForIndex(5L) * 3;
            planeB = BRUSH_PlaneMaskForIndex(
                         (long)brush->planeSel) * 3;

            for (i = 0; i < planeB && i < planeA; i++)
                WDISP_PaletteTriplesRBase[i] = brush->pal[i];

            WDISP_AccumulatorCaptureActive = 1;
            WDISP_AccumulatorFlushPending = 0;
            for (i = 0; i < 4; i++)
                CopyMem(&brush->rows[i * 8], &WDISP_AccumulatorRowTable[i * 8],
                        8L);
            WDISP_AccumulatorCaptureActive = 0;
            WDISP_AccumulatorFlushPending = 1;

            y = baseY;
            BRUSH_SelectBrushSlot(brush, 0L, baseY, width, height,
                                               rp, 0L);
        }

        if (WDISP_WeatherStatusTextPtr != 0 && *WDISP_WeatherStatusTextPtr != 0)
            strcpy(statusText, WDISP_WeatherStatusTextPtr);
        else
            statusText[0] = 0;

        textLen = (long)strlen(statusText);
        if (textLen > 0) {
            drawn = TextLength(rp, statusText, textLen);
            x = (width - drawn) / 2;
            y = height - (long)Global_HANDLE_PREVUEC_FONT->tf_YSize
                       - brushHeight - 5;
            SetAPen(rp, 3L);
            SetDrMd(rp, 0L);
            Move(rp, x, y);
            Text(rp, statusText, textLen);
        }

        fontYSize = Global_HANDLE_PREVUEC_FONT->tf_YSize;
        half = (lineCount + 1) / 2;
        rowStep = ((long)Global_HANDLE_PREVUEC_FONT->tf_Baseline + brushHeight
                   - fontYSize * half + 5) / (half + 1);
        halfWidth = (width - brushWidth) / 2;

        SetAPen(rp, 1L);
        SetDrMd(rp, 0L);

        while (lineIndex < lineCount) {
            y = baseY + (lineIndex / 2) * (fontYSize + rowStep) + rowStep
                + (long)Global_HANDLE_PREVUEC_FONT->tf_Baseline;
            if (y + (long)Global_HANDLE_PREVUEC_FONT->tf_YSize
                  - (long)Global_HANDLE_PREVUEC_FONT->tf_Baseline >= height)
                break;

            textLen = ESQFUNC_TrimTextToPixelWidthWordBoundary(
                          rp, halfWidth, cur);
            drawn = TextLength(rp, cur, textLen);
            x = (halfWidth - drawn - 1) / 2;
            Move(rp, x, y);
            Text(rp, cur, textLen);
            lineIndex++;

            if (lineIndex < lineCount) {
                cur += strlen(cur) + 1;
                textLen = ESQFUNC_TrimTextToPixelWidthWordBoundary(
                              rp, halfWidth, cur);
                drawn = TextLength(rp, cur, textLen);
                x = width - (halfWidth + drawn) / 2 - 1;
                Move(rp, x, y);
                Text(rp, cur, textLen);
                lineIndex++;
            }
            cur += strlen(cur) + 1;
        }

        MEMORY_DeallocateMemory("WDISP.c", 301L, dup, dupLen1);
        return;
    }

    if (P_TYPE_WeatherCurrentMsgPtr != 0)
        fallback = P_TYPE_WeatherCurrentMsgPtr;
    else
        fallback = Global_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE;

    textLen = (long)strlen(fallback);
    SetAPen(rp, 1L);
    SetDrMd(rp, 0L);
    drawn = TextLength(rp, fallback, textLen);
    x = (width - drawn) / 2;
    y = (height - (long)Global_HANDLE_PREVUEC_FONT->tf_YSize) / 2
        + (long)Global_HANDLE_PREVUEC_FONT->tf_Baseline;
    Move(rp, x, y);
    Text(rp, fallback, textLen);
}
