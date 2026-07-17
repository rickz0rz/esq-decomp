#include <exec/types.h>

#define WDISP_BRUSH_WIDTH_OFFSET 176
#define WDISP_BRUSH_HEIGHT_OFFSET 178
#define WDISP_BRUSH_PLANE_DEPTH_OFFSET 184
#define WDISP_BRUSH_ACCUMULATOR_ROWS_OFFSET 200
#define WDISP_BRUSH_PALETTE_BYTES_OFFSET 0xE8
#define WDISP_BRUSH_ALIGN_X_MODE_OFFSET 356
#define WDISP_BRUSH_ALIGN_Y_MODE_OFFSET 360
#define WDISP_FONT_HEIGHT_OFFSET 20
#define WDISP_FONT_BASELINE_OFFSET 26
#define WDISP_BRUSH_DEFAULT_WIDTH 0xAA
#define WDISP_BRUSH_DEFAULT_HEIGHT 90
#define WDISP_TEXT_POOL_ID 301
#define WDISP_DELIMITER_CHAR 24
#define WDISP_MAX_OVERLAY_LINES 10
#define WDISP_ACCUMULATOR_ROW_SIZE 8
#define WDISP_ACCUMULATOR_ROW_COUNT 4
#define WDISP_ALIGN_CENTER 1

typedef struct WDISP_WeatherBrush {
    UBYTE pad0[WDISP_BRUSH_WIDTH_OFFSET];
    UWORD width;
    UWORD height;
    UBYTE padB4[WDISP_BRUSH_PLANE_DEPTH_OFFSET - WDISP_BRUSH_HEIGHT_OFFSET - 2];
    UBYTE planeDepth;
    UBYTE padB9[WDISP_BRUSH_ACCUMULATOR_ROWS_OFFSET - WDISP_BRUSH_PLANE_DEPTH_OFFSET - 1];
    UBYTE accumulatorRows[WDISP_ACCUMULATOR_ROW_SIZE * WDISP_ACCUMULATOR_ROW_COUNT];
    UBYTE paletteBytes[WDISP_BRUSH_ALIGN_X_MODE_OFFSET - WDISP_BRUSH_PALETTE_BYTES_OFFSET];
    LONG alignXMode;
    LONG alignYMode;
} WDISP_WeatherBrush;

extern LONG AbsExecBase;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_HANDLE_PREVUEC_FONT;

extern UBYTE WDISP_WeatherStatusCountdown;
extern UWORD WDISP_WeatherStatusDigitChar;
extern UBYTE WDISP_WeatherStatusBrushIndex;
extern char *WDISP_WeatherStatusTextPtr;
extern char *WDISP_WeatherStatusOverlayTextPtr;
extern WORD WDISP_AccumulatorCaptureActive;
extern WORD WDISP_AccumulatorFlushPending;
extern UBYTE WDISP_AccumulatorRowTable[];
extern UBYTE WDISP_PaletteTriplesRBase[];
extern char *P_TYPE_WeatherCurrentMsgPtr;
extern const char *Global_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE;

extern ULONG ESQFUNC_PwBrushListHead;
extern ULONG ESQFUNC_WeatherBrushPredicateNames;
extern const char *ESQFUNC_STR_I5[];
extern const char Global_STR_WDISP_C[];

extern void *BRUSH_FindBrushByPredicate(void *predicate, void *listHead);
extern ULONG BRUSH_PlaneMaskForIndex(LONG planeIndex);
extern LONG BRUSH_SelectBrushSlot(
    UBYTE *brush,
    LONG srcX0,
    LONG srcY0,
    LONG srcX1,
    LONG srcY1,
    char *dstRp,
    LONG forcedDstY);
extern char *ESQPARS_ReplaceOwnedString(const char *src, char *oldPtr);
extern LONG ESQFUNC_TrimTextToPixelWidthWordBoundary(
    char *rastPort,
    LONG maxWidth,
    char *text);
extern LONG MATH_DivS32(LONG dividend, LONG divisor);
extern LONG MATH_Mulu32(LONG multiplicand, LONG multiplier);
extern void MEMORY_DeallocateMemory(void *ptr, long bytes);
extern void _LVOCopyMem(void *execBase, const void *src, void *dst, LONG size);
extern void _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOSetDrMd(void *gfxBase, char *rastPort, LONG drawMode);
extern void _LVOSetFont(void *gfxBase, char *rastPort, void *font);
extern void _LVOSetRast(void *gfxBase, char *rastPort, LONG pen);
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

void WDISP_DrawWeatherStatusOverlay(char *rastPort, LONG xSpan, LONG ySpan)
{
    WDISP_WeatherBrush *brush;
    char *ownedOverlayText;
    char *linePtr;
    char *scan;
    const char *fallbackText;
    char statusText[128];
    LONG brushWidth;
    LONG brushHeight;
    LONG brushTopY;
    LONG lineCount;
    LONG ownedTextSize;
    LONG statusLen;
    LONG lineSpacing;
    LONG halfBrushWidth;
    LONG currentLine;
    LONG i;

    brush = (WDISP_WeatherBrush *)0;
    ownedOverlayText = (char *)0;
    lineCount = 0;

    if (WDISP_WeatherStatusCountdown == 0 || WDISP_WeatherStatusDigitChar == 48) {
        fallbackText = P_TYPE_WeatherCurrentMsgPtr;
        if (fallbackText == (const char *)0) {
            fallbackText = Global_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE;
        }

        statusLen = 0;
        while (fallbackText[statusLen] != 0) {
            statusLen++;
        }

        _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rastPort, 1);
        _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rastPort, 0);

        brushWidth = _LVOTextLength(
            Global_REF_GRAPHICS_LIBRARY,
            rastPort,
            fallbackText,
            statusLen);
        brushWidth = half_toward_zero(xSpan - brushWidth);
        brushHeight = half_toward_zero(
            ySpan - (LONG)*(UWORD *)((UBYTE *)Global_HANDLE_PREVUEC_FONT + WDISP_FONT_HEIGHT_OFFSET));
        brushHeight += (LONG)*(UWORD *)((UBYTE *)Global_HANDLE_PREVUEC_FONT + WDISP_FONT_BASELINE_OFFSET);

        _LVOMove(Global_REF_GRAPHICS_LIBRARY, rastPort, brushWidth, brushHeight);
        _LVOText(Global_REF_GRAPHICS_LIBRARY, rastPort, fallbackText, statusLen);
        return;
    }

    if (WDISP_WeatherStatusBrushIndex == 1) {
        brush = (WDISP_WeatherBrush *)BRUSH_FindBrushByPredicate(
            (void *)ESQFUNC_WeatherBrushPredicateNames,
            (void *)&ESQFUNC_PwBrushListHead);
    } else {
        brush = (WDISP_WeatherBrush *)BRUSH_FindBrushByPredicate(
            (void *)ESQFUNC_STR_I5[(ULONG)WDISP_WeatherStatusBrushIndex],
            (void *)&ESQFUNC_PwBrushListHead);
    }

    if (brush != (WDISP_WeatherBrush *)0) {
        brushWidth = (LONG)brush->width;
        brushHeight = (LONG)brush->height;
    } else {
        brushWidth = WDISP_BRUSH_DEFAULT_WIDTH;
        brushHeight = WDISP_BRUSH_DEFAULT_HEIGHT;
    }

    ownedOverlayText = ESQPARS_ReplaceOwnedString(
        WDISP_WeatherStatusOverlayTextPtr,
        (char *)0);

    linePtr = ownedOverlayText;
    scan = ownedOverlayText;
    while (*scan++ != 0) {
    }

    ownedTextSize = (LONG)((scan - ownedOverlayText) - 1);
    ownedTextSize += 1;

    scan = linePtr;
    while (*scan != 0) {
        if (*scan == WDISP_DELIMITER_CHAR) {
            *scan = 0;
            lineCount++;
        }
        scan++;
    }

    if (*linePtr == 0) {
        linePtr++;
        lineCount--;
    }

    if (lineCount > WDISP_MAX_OVERLAY_LINES) {
        lineCount = WDISP_MAX_OVERLAY_LINES;
    }

    _LVOSetRast(Global_REF_GRAPHICS_LIBRARY, rastPort, 0);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rastPort, 0);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rastPort, 1);
    _LVOSetFont(Global_REF_GRAPHICS_LIBRARY, rastPort, Global_HANDLE_PREVUEC_FONT);

    brushTopY = ySpan
        - (LONG)*(UWORD *)((UBYTE *)Global_HANDLE_PREVUEC_FONT + WDISP_FONT_BASELINE_OFFSET)
        - brushHeight
        - 5;

    if (WDISP_WeatherStatusBrushIndex != 1 && brush != (WDISP_WeatherBrush *)0) {
        ULONG copyLimit;
        ULONG brushLimit;
        ULONG copyIndex;

        brush->alignXMode = WDISP_ALIGN_CENTER;
        brush->alignYMode = WDISP_ALIGN_CENTER;

        copyLimit = BRUSH_PlaneMaskForIndex(5) * 3UL;
        brushLimit = BRUSH_PlaneMaskForIndex((LONG)brush->planeDepth) * 3UL;

        copyIndex = 0;
        while (copyIndex < copyLimit && copyIndex < brushLimit) {
            WDISP_PaletteTriplesRBase[copyIndex] = brush->paletteBytes[copyIndex];
            copyIndex++;
        }

        WDISP_AccumulatorCaptureActive = 1;
        WDISP_AccumulatorFlushPending = 0;
        for (i = 0; i < WDISP_ACCUMULATOR_ROW_COUNT; i++) {
            _LVOCopyMem(
                (void *)AbsExecBase,
                &brush->accumulatorRows[i * WDISP_ACCUMULATOR_ROW_SIZE],
                &WDISP_AccumulatorRowTable[i * WDISP_ACCUMULATOR_ROW_SIZE],
                WDISP_ACCUMULATOR_ROW_SIZE);
        }
        WDISP_AccumulatorCaptureActive = 0;
        WDISP_AccumulatorFlushPending = 1;

        BRUSH_SelectBrushSlot(
            (UBYTE *)brush,
            0,
            brushTopY,
            xSpan,
            ySpan,
            rastPort,
            0);
    }

    if (WDISP_WeatherStatusTextPtr != (char *)0 && *WDISP_WeatherStatusTextPtr != 0) {
        char *src;
        char *dst;

        src = WDISP_WeatherStatusTextPtr;
        dst = statusText;
        do {
            *dst++ = *src;
        } while (*src++ != 0);
    } else {
        statusText[0] = 0;
    }

    statusLen = 0;
    while (statusText[statusLen] != 0) {
        statusLen++;
    }

    if (statusLen > 0) {
        LONG textWidth;
        LONG textX;
        LONG textY;

        textWidth = _LVOTextLength(
            Global_REF_GRAPHICS_LIBRARY,
            rastPort,
            statusText,
            statusLen);
        textX = half_toward_zero(xSpan - textWidth);
        textY = ySpan
            - (LONG)*(UWORD *)((UBYTE *)Global_HANDLE_PREVUEC_FONT + WDISP_FONT_HEIGHT_OFFSET)
            - brushHeight
            - 5;

        _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rastPort, 3);
        _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rastPort, 0);
        _LVOMove(Global_REF_GRAPHICS_LIBRARY, rastPort, textX, textY);
        _LVOText(Global_REF_GRAPHICS_LIBRARY, rastPort, statusText, statusLen);
    }

    lineSpacing = MATH_DivS32(
        (LONG)*(UWORD *)((UBYTE *)Global_HANDLE_PREVUEC_FONT + WDISP_FONT_BASELINE_OFFSET)
            + brushHeight
            - MATH_Mulu32(
                (LONG)*(UWORD *)((UBYTE *)Global_HANDLE_PREVUEC_FONT + WDISP_FONT_HEIGHT_OFFSET),
                half_toward_zero(lineCount + 1) + 1)
            + 5,
        half_toward_zero(lineCount + 1) + 1);
    halfBrushWidth = half_toward_zero(xSpan - brushWidth);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rastPort, 1);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rastPort, 0);

    currentLine = 0;
    while (currentLine < lineCount) {
        LONG lineIndex;
        LONG textY;
        LONG lineLen;
        LONG textWidth;
        LONG textX;

        lineIndex = half_toward_zero(currentLine);
        textY = brushTopY
            + MATH_Mulu32(
                lineIndex,
                lineSpacing
                    + (LONG)*(UWORD *)((UBYTE *)Global_HANDLE_PREVUEC_FONT + WDISP_FONT_HEIGHT_OFFSET))
            + lineSpacing
            + (LONG)*(UWORD *)((UBYTE *)Global_HANDLE_PREVUEC_FONT + WDISP_FONT_BASELINE_OFFSET);

        if (textY
                + (LONG)*(UWORD *)((UBYTE *)Global_HANDLE_PREVUEC_FONT + WDISP_FONT_HEIGHT_OFFSET)
                - (LONG)*(UWORD *)((UBYTE *)Global_HANDLE_PREVUEC_FONT + WDISP_FONT_BASELINE_OFFSET)
            >= ySpan) {
            break;
        }

        lineLen = ESQFUNC_TrimTextToPixelWidthWordBoundary(
            rastPort,
            halfBrushWidth,
            linePtr);
        textWidth = _LVOTextLength(
            Global_REF_GRAPHICS_LIBRARY,
            rastPort,
            linePtr,
            lineLen);
        textX = half_toward_zero(halfBrushWidth - textWidth - 1);

        _LVOMove(Global_REF_GRAPHICS_LIBRARY, rastPort, textX, textY);
        _LVOText(Global_REF_GRAPHICS_LIBRARY, rastPort, linePtr, lineLen);

        currentLine++;
        if (currentLine < lineCount) {
            while (*linePtr++ != 0) {
            }

            lineLen = ESQFUNC_TrimTextToPixelWidthWordBoundary(
                rastPort,
                halfBrushWidth,
                linePtr);
            textWidth = _LVOTextLength(
                Global_REF_GRAPHICS_LIBRARY,
                rastPort,
                linePtr,
                lineLen);
            textX = xSpan - half_toward_zero(halfBrushWidth + textWidth) - 1;

            _LVOMove(Global_REF_GRAPHICS_LIBRARY, rastPort, textX, textY);
            _LVOText(Global_REF_GRAPHICS_LIBRARY, rastPort, linePtr, lineLen);

            currentLine++;
        }

        while (*linePtr++ != 0) {
        }
    }

    MEMORY_DeallocateMemory(ownedOverlayText,
        ownedTextSize);
}
