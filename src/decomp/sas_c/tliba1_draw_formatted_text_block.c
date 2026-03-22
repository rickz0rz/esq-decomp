#include <graphics/rastport.h>
#include <graphics/text.h>

extern WORD TEXTDISP_LinePenOverrideEnabledFlag;
extern UBYTE CLOCK_AlignedInsetRenderGateFlag;
extern UBYTE CLEANUP_AlignedInsetNibblePrimary;
extern void *Global_HANDLE_PREVUE_FONT;
extern const char Global_STR_TLIBA1_C_3[];
extern const char TLIBA1_STR_TLIBA1_DOT_C[];

extern ULONG MATH_Mulu32(ULONG a, ULONG b);
extern LONG MATH_DivS32(LONG dividend, LONG divisor);
extern void *MEMORY_AllocateMemory(const char *owner, LONG line, LONG bytes, ULONG flags);
extern void MEMORY_DeallocateMemory(const char *owner, LONG line, void *ptr, ULONG bytes);
extern LONG _LVOTextLength(char *rastPort, const char *text, LONG len);
extern void _LVOSetAPen(char *rastPort, LONG pen);
extern void _LVOSetFont(char *rastPort, void *font);
extern void TLIBA1_DrawInlineStyledText(char *rastPort, LONG x, LONG y, char *text);

struct TLIBA1_DrawFormattedTextRecord {
    WORD pen;
    WORD textOffset;
    WORD usePrevueFont;
    WORD unused6;
    WORD addExtraSpacing;
};

void TLIBA1_DrawFormattedTextBlock(char *rastPort, char *text, WORD left, WORD top, WORD right, WORD bottom)
{
    struct RastPort *rp;
    struct TextFont *savedFont;
    struct TLIBA1_DrawFormattedTextRecord *records;
    struct TLIBA1_DrawFormattedTextRecord *record;
    ULONG allocSize;
    WORD boxWidth;
    WORD boxHeight;
    WORD recordCount;
    WORD recordIndex;
    WORD lineDivisor;
    WORD lineIndex;
    WORD totalHeight;
    WORD currentYOffset;
    WORD lineWidth;
    WORD isMarkerRunActive;
    WORD isUsingPrevueFont;
    WORD isDone;
    char *cursor;
    BYTE savedPen;

    rp = (struct RastPort *)rastPort;
    savedPen = rp->FgPen;
    savedFont = rp->Font;
    boxWidth = right - left + 1;
    boxHeight = bottom - top + 1;
    cursor = text;
    recordCount = 0;
    isMarkerRunActive = 0;

    while (*cursor != 0) {
        UBYTE c;

        c = (UBYTE)*cursor;
        if (c == 24 || c == 25 || c == 6) {
            if (isMarkerRunActive == 0) {
                ++recordCount;
                isMarkerRunActive = 1;
            }
        } else {
            isMarkerRunActive = 0;
        }
        ++cursor;
    }

    if (recordCount == 0) {
        return;
    }

    allocSize = MATH_Mulu32((ULONG)recordCount, 10UL);
    records = (struct TLIBA1_DrawFormattedTextRecord *)
        MEMORY_AllocateMemory(Global_STR_TLIBA1_C_3, 2115, (LONG)allocSize, 0x10001UL);
    if (records == (struct TLIBA1_DrawFormattedTextRecord *)0) {
        return;
    }

    cursor = text;
    recordIndex = 0;
    lineDivisor = 2;
    lineIndex = 0;
    totalHeight = 0;
    currentYOffset = 0;
    isMarkerRunActive = 0;
    isUsingPrevueFont = 0;
    isDone = 0;

    while (isDone == 0) {
        WORD c;

        c = (WORD)(UBYTE)*cursor;
        if (c == 0) {
            ++lineDivisor;
            isDone = 1;
        } else if (c == 6) {
            if (isMarkerRunActive != 0) {
                --recordIndex;
            }

            record = &records[recordIndex];
            record->usePrevueFont = 1;
            record->pen = 1;
            record->textOffset = (WORD)(lineIndex + 1);
            if (isUsingPrevueFont != 0) {
                record->addExtraSpacing = 0;
            } else {
                record->addExtraSpacing = 1;
                ++lineDivisor;
            }

            ++recordIndex;
            *cursor = 0;
            totalHeight += ((struct TextFont *)Global_HANDLE_PREVUE_FONT)->tf_YSize;
            isMarkerRunActive = 0;
            isUsingPrevueFont = 1;
        } else if (c == 18) {
            if (isUsingPrevueFont == 0) {
                *cursor = ' ';
            }
        } else if (c == 24) {
            if (isMarkerRunActive != 0) {
                --recordIndex;
                record = &records[recordIndex];
                record->pen = 1;
                record->textOffset = (WORD)(lineIndex + 1);
                ++recordIndex;
            } else {
                record = &records[recordIndex];
                record->usePrevueFont = 0;
                record->pen = 1;
                record->textOffset = (WORD)(lineIndex + 1);
                record->addExtraSpacing = 1;
                ++recordIndex;
                *cursor = 0;
                totalHeight += savedFont->tf_YSize + 1;
                ++lineDivisor;
                isUsingPrevueFont = 0;
                isMarkerRunActive = 1;
            }
        } else if (c == 25) {
            if (isMarkerRunActive != 0) {
                --recordIndex;
                record = &records[recordIndex];
                record->pen = 3;
                record->textOffset = (WORD)(lineIndex + 1);
                ++recordIndex;
            } else {
                record = &records[recordIndex];
                record->usePrevueFont = 0;
                record->pen = 3;
                record->textOffset = (WORD)(lineIndex + 1);
                record->addExtraSpacing = 1;
                ++recordIndex;
                *cursor = 0;
                totalHeight += savedFont->tf_YSize + 1;
                ++lineDivisor;
                isMarkerRunActive = 1;
                isUsingPrevueFont = 0;
            }
        } else {
            isMarkerRunActive = 0;
        }

        ++lineIndex;
        ++cursor;
    }

    currentYOffset = MATH_DivS32(boxHeight - totalHeight, lineDivisor);
    totalHeight = currentYOffset;

    for (lineIndex = 0; lineIndex < recordCount; ++lineIndex) {
        char *lineText;
        char *lineTextEnd;
        LONG drawX;
        LONG drawY;
        LONG lineLength;

        record = &records[lineIndex];

        if (TEXTDISP_LinePenOverrideEnabledFlag != 0) {
            _LVOSetAPen(rastPort, (LONG)record->pen);
        }

        if (record->usePrevueFont != 0) {
            _LVOSetFont(rastPort, Global_HANDLE_PREVUE_FONT);
        } else {
            _LVOSetFont(rastPort, savedFont);
        }

        lineText = text + record->textOffset;
        lineTextEnd = lineText;
        while (*lineTextEnd != 0) {
            ++lineTextEnd;
        }
        lineLength = (LONG)(lineTextEnd - lineText);
        lineWidth = (WORD)_LVOTextLength(rastPort, lineText, lineLength);
        if (CLOCK_AlignedInsetRenderGateFlag != 0 && CLEANUP_AlignedInsetNibblePrimary != 0xFF) {
            lineWidth += 8;
        }
        if (lineWidth > boxWidth) {
            lineWidth = boxWidth;
        }

        if (record->addExtraSpacing != 0) {
            totalHeight += currentYOffset + 1;
        }
        totalHeight += rp->TxBaseline;

        drawX = boxWidth - lineWidth;
        if (drawX < 0) {
            ++drawX;
        }
        drawX = left + (drawX >> 1);
        drawY = top + totalHeight;

        TLIBA1_DrawInlineStyledText(rastPort, drawX, drawY, lineText);
    }

    _LVOSetAPen(rastPort, (LONG)savedPen);
    _LVOSetFont(rastPort, savedFont);

    MEMORY_DeallocateMemory(TLIBA1_STR_TLIBA1_DOT_C, 2385, records, allocSize);
}
