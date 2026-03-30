#include <exec/types.h>

#include "wdisp_accumulator_rows.h"

#define WDISP_BRUSH_WIDTH_OFFSET 176
#define WDISP_BRUSH_HEIGHT_OFFSET 178
#define WDISP_BRUSH_PLANE_DEPTH_OFFSET 184
#define WDISP_BRUSH_ACCUMULATOR_ROWS_OFFSET 200
#define WDISP_BRUSH_PALETTE_BYTES_OFFSET 0xE8
#define WDISP_BRUSH_ROW_COUNT 4
#define WDISP_BRUSH_ROW_SIZE 8
#define WDISP_UNKNOWN_TEMP (-999)

typedef struct WeatherDayEntry {
    LONG unk0;
    LONG brushIndex;
    LONG highTemp;
    LONG lowTemp;
    LONG mode;
} WeatherDayEntry;

typedef struct WDISP_WeatherBrush {
    UBYTE pad0[WDISP_BRUSH_WIDTH_OFFSET];
    UWORD width;
    UWORD height;
    UBYTE padB4[WDISP_BRUSH_PLANE_DEPTH_OFFSET - WDISP_BRUSH_HEIGHT_OFFSET - 2];
    UBYTE planeDepth;
    UBYTE padB9[WDISP_BRUSH_ACCUMULATOR_ROWS_OFFSET - WDISP_BRUSH_PLANE_DEPTH_OFFSET - 1];
    UBYTE accumulatorRows[WDISP_BRUSH_ROW_COUNT * WDISP_BRUSH_ROW_SIZE];
    UBYTE paletteBytes[WDISP_BRUSH_PALETTE_BYTES_OFFSET - WDISP_BRUSH_ACCUMULATOR_ROWS_OFFSET];
} WDISP_WeatherBrush;

extern LONG AbsExecBase;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_HANDLE_PREVUEC_FONT;

extern WeatherDayEntry WDISP_StatusDayEntry0[];
extern const char *ESQFUNC_STR_I5[];
extern ULONG ESQFUNC_PwBrushListHead;
extern const char Global_STR_PERCENT_D_SLASH[];
extern const char Global_STR_PERCENT_D[];
extern const char WDISP_STR_UNKNOWN_NUM_WITH_SLASH[];
extern const char WDISP_STR_UNKNOWN_NUM[];
extern char *P_TYPE_WeatherForecastMsgPtr;
extern UBYTE WDISP_CharClassTable[];
extern WORD CLOCK_CurrentDayOfWeekIndex;
extern const char *Global_JMPTBL_DAYS_OF_WEEK[];
extern WORD WDISP_AccumulatorCaptureActive;
extern WORD WDISP_AccumulatorFlushPending;
extern UBYTE WDISP_PaletteTriplesRBase[];

extern void *WDISP_JMPTBL_BRUSH_FindBrushByPredicate(void *predicate, void *listHead);
extern ULONG WDISP_JMPTBL_BRUSH_PlaneMaskForIndex(LONG planeIndex);
extern void WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples(void);
extern LONG WDISP_JMPTBL_BRUSH_SelectBrushSlot(
    UBYTE *brush,
    LONG srcX0,
    LONG srcY0,
    LONG srcX1,
    LONG srcY1,
    char *dstRp,
    LONG forcedDstY);
extern char *WDISP_JMPTBL_NEWGRID_DrawWrappedText(
    char *rastport,
    LONG x,
    LONG y,
    LONG maxWidth,
    const char *text,
    LONG drawEnable);
extern char *STRING_AppendAtNull(char *dst, const char *src);
extern LONG MATH_DivS32(LONG a, LONG b);
extern LONG MATH_Mulu32(LONG a, LONG b);
extern LONG WDISP_SPrintf(char *dst, const char *fmt, LONG value);
extern void _LVOCopyMem(void *execBase, const void *src, void *dst, LONG size);
extern void _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOSetDrMd(void *gfxBase, char *rastPort, LONG drawMode);
extern void _LVOMove(void *gfxBase, char *rastPort, LONG x, LONG y);
extern void _LVOText(void *gfxBase, char *rastPort, const char *text, LONG len);
extern LONG _LVOTextLength(void *gfxBase, char *rastPort, const char *text, LONG len);

static LONG half_toward_zero(LONG value)
{
    if (value < 0) {
        value += 1;
    }

    return value >> 1;
}

static LONG string_length(const char *text)
{
    const char *scan;

    scan = text;
    while (*scan != 0) {
        ++scan;
    }

    return (LONG)(scan - text);
}

void WDISP_DrawWeatherStatusDayEntry(char *rastPort, LONG dayIndex, LONG xSpan, LONG ySpan)
{
    WeatherDayEntry *entry;
    WDISP_WeatherBrush *brush;
    LONG panelWidth;
    LONG panelX;
    LONG brushIndex;
    LONG brushHeight;
    LONG brushWidth;
    LONG drawBrush;
    char tempHiBuf[20];
    char tempLoBuf[20];
    LONG tempLen;
    LONG tempX;
    LONG tempY;
    const char *weekdayText;
    LONG weekdayLen;
    LONG weekdayX;
    LONG weekdayY;

    if (dayIndex < 0 || dayIndex >= 4) {
        return;
    }

    panelWidth = MATH_DivS32(xSpan, 3);
    panelX = MATH_Mulu32(dayIndex, panelWidth);
    entry = &WDISP_StatusDayEntry0[MATH_Mulu32(dayIndex, 20) / 20];

    brush = (WDISP_WeatherBrush *)0;
    drawBrush = 1;
    brushIndex = entry->brushIndex;

    if (entry->mode != 1 && (brushIndex < 2 || brushIndex > 6)) {
        brushIndex = 2;
        drawBrush = 0;
    }

    brush = (WDISP_WeatherBrush *)WDISP_JMPTBL_BRUSH_FindBrushByPredicate(
        (void *)ESQFUNC_STR_I5[(ULONG)brushIndex],
        (void *)&ESQFUNC_PwBrushListHead);

    if (brush != (WDISP_WeatherBrush *)0) {
        brushHeight = (LONG)brush->height;
        brushWidth = (LONG)brush->width;
    } else {
        brushHeight = 90;
        brushWidth = 0;
        drawBrush = 0;
    }

    if (entry->mode != 0) {
        char *forecastPtr;
        LONG lineCount;
        LONG lineY;

        forecastPtr = P_TYPE_WeatherForecastMsgPtr;
        panelWidth -= 20;
        lineCount = 0;
        lineY = 140;

        _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rastPort, 1);
        _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rastPort, 0);

        while (forecastPtr != (char *)0 && lineCount < 4) {
            char *wrapped;

            while (*forecastPtr != 0 &&
                   (WDISP_CharClassTable[(ULONG)(UBYTE)*forecastPtr] & 8U) != 0) {
                ++forecastPtr;
            }

            wrapped = WDISP_JMPTBL_NEWGRID_DrawWrappedText(
                rastPort,
                panelX,
                lineY,
                panelWidth,
                forecastPtr,
                0);

            if (wrapped != (char *)0) {
                char savedChar;
                LONG lineLen;
                LONG lineX;

                savedChar = *wrapped;
                *wrapped = 0;
                lineLen = string_length(forecastPtr);
                *wrapped = savedChar;

                lineX = panelX
                    + half_toward_zero(panelWidth
                        - _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, rastPort, forecastPtr, lineLen)
                        + 20);

                wrapped = WDISP_JMPTBL_NEWGRID_DrawWrappedText(
                    rastPort,
                    lineX,
                    lineY,
                    panelWidth,
                    forecastPtr,
                    1);

                lineY += (LONG)*(UWORD *)((UBYTE *)Global_HANDLE_PREVUEC_FONT + 20) + 4;
                lineCount += 1;
                forecastPtr = wrapped;
            } else {
                LONG lineX;

                lineX = panelX
                    + half_toward_zero(panelWidth
                        - _LVOTextLength(
                            Global_REF_GRAPHICS_LIBRARY,
                            rastPort,
                            forecastPtr,
                            string_length(forecastPtr))
                        + 20);

                forecastPtr = WDISP_JMPTBL_NEWGRID_DrawWrappedText(
                    rastPort,
                    lineX,
                    lineY,
                    panelWidth,
                    forecastPtr,
                    1);
            }
        }

        panelWidth += 20;
    } else {
        if (drawBrush == 0) {
            WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples();
        } else {
            LONG copyLimit;
            LONG brushLimit;
            LONG copyIndex;
            LONG brushX;
            LONG brushY;

            WDISP_AccumulatorCaptureActive = 1;
            WDISP_AccumulatorFlushPending = 0;

            copyLimit = (LONG)(WDISP_JMPTBL_BRUSH_PlaneMaskForIndex(5) * 3UL);
            brushLimit = (LONG)(WDISP_JMPTBL_BRUSH_PlaneMaskForIndex((LONG)brush->planeDepth) * 3UL);
            copyIndex = 0;
            while (copyIndex < copyLimit && copyIndex < brushLimit) {
                WDISP_PaletteTriplesRBase[copyIndex] = brush->paletteBytes[copyIndex];
                ++copyIndex;
            }

            copyIndex = 0;
            while (copyIndex < WDISP_BRUSH_ROW_COUNT) {
                _LVOCopyMem(
                    (void *)AbsExecBase,
                    &brush->accumulatorRows[MATH_Mulu32(copyIndex, WDISP_BRUSH_ROW_SIZE)],
                    &WDISP_AccumulatorRowTable[copyIndex],
                    WDISP_BRUSH_ROW_SIZE);
                ++copyIndex;
            }

            WDISP_AccumulatorCaptureActive = 0;
            WDISP_AccumulatorFlushPending = 1;

            brushX = panelX + half_toward_zero(panelWidth - brushWidth);
            brushY = ySpan
                - brushHeight
                - (LONG)*(UWORD *)((UBYTE *)Global_HANDLE_PREVUEC_FONT + 26)
                - 5;

            WDISP_JMPTBL_BRUSH_SelectBrushSlot(
                (UBYTE *)brush,
                brushX,
                brushY,
                brushX + brushWidth,
                brushY + brushHeight,
                rastPort,
                0);
        }

        if (entry->highTemp == WDISP_UNKNOWN_TEMP) {
            tempHiBuf[0] = WDISP_STR_UNKNOWN_NUM_WITH_SLASH[0];
            tempHiBuf[1] = WDISP_STR_UNKNOWN_NUM_WITH_SLASH[1];
            tempHiBuf[2] = WDISP_STR_UNKNOWN_NUM_WITH_SLASH[2];
            tempHiBuf[3] = 0;
        } else {
            WDISP_SPrintf(tempHiBuf, Global_STR_PERCENT_D_SLASH, entry->highTemp);
        }

        if (entry->lowTemp == WDISP_UNKNOWN_TEMP) {
            tempLoBuf[0] = WDISP_STR_UNKNOWN_NUM[0];
            tempLoBuf[1] = WDISP_STR_UNKNOWN_NUM[1];
            tempLoBuf[2] = WDISP_STR_UNKNOWN_NUM[2];
            tempLoBuf[3] = 0;
        } else {
            WDISP_SPrintf(tempLoBuf, Global_STR_PERCENT_D, entry->lowTemp);
        }

        STRING_AppendAtNull(tempHiBuf, tempLoBuf);
        tempLen = string_length(tempHiBuf);

        _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rastPort, 1);
        _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rastPort, 0);

        tempX = panelX
            + half_toward_zero(
                panelWidth
                    - _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, rastPort, tempHiBuf, tempLen));
        tempY = ySpan - 5;

        _LVOMove(Global_REF_GRAPHICS_LIBRARY, rastPort, tempX, tempY);
        _LVOText(Global_REF_GRAPHICS_LIBRARY, rastPort, tempHiBuf, tempLen);
    }

    weekdayText =
        Global_JMPTBL_DAYS_OF_WEEK[(ULONG)((CLOCK_CurrentDayOfWeekIndex + dayIndex + 1) % 7)];
    weekdayLen = string_length(weekdayText);
    weekdayX = panelX
        + half_toward_zero(
            panelWidth
                - _LVOTextLength(
                    Global_REF_GRAPHICS_LIBRARY,
                    rastPort,
                    weekdayText,
                    weekdayLen));
    weekdayY = ySpan
        - brushHeight
        - (LONG)*(UWORD *)((UBYTE *)Global_HANDLE_PREVUEC_FONT + 20)
        - 5;

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rastPort, 3);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rastPort, 0);
    _LVOMove(Global_REF_GRAPHICS_LIBRARY, rastPort, weekdayX, weekdayY);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, rastPort, weekdayText, weekdayLen);
}
