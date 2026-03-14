#include <exec/types.h>
extern LONG DISPTEXT_LineTableLockFlag;
extern WORD DISPTEXT_CurrentLineIndex;
extern WORD DISPTEXT_TargetLineIndex;
extern WORD DISPTEXT_LineLengthTable[];
extern char *DISPTEXT_LinePtrTable[];
extern LONG DISPTEXT_LineWidthPx;
extern LONG DISPTEXT_ControlMarkerWidthPx;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern const char DISPTEXT_STR_SINGLE_SPACE_PREFIX_1[];

extern LONG _LVOTextLength(void *gfxBase, char *rp, const char *text, LONG count);
extern char *DISPTEXT_BuildLineWithWidth(char *rp, const char *src, char *scratch, LONG widthPx);

LONG DISPTEXT_LayoutSourceToLines(char *rp, const char *src)
{
    LONG lineOffset = 0;
    LONG availableWidth;
    char scratch[268];
    UWORD current;

    if (DISPTEXT_LineTableLockFlag != 0) {
        return (src == 0) ? -1 : 0;
    }

    current = (UWORD)DISPTEXT_CurrentLineIndex;
    if (current >= (UWORD)DISPTEXT_TargetLineIndex) {
        return (src == 0) ? -1 : 0;
    }

    if (DISPTEXT_LineLengthTable[current] != 0) {
        LONG measured = _LVOTextLength(
            Global_REF_GRAPHICS_LIBRARY,
            rp,
            DISPTEXT_LinePtrTable[current],
            (LONG)(UWORD)DISPTEXT_LineLengthTable[current]);
        availableWidth = DISPTEXT_LineWidthPx - measured;
    } else {
        availableWidth = DISPTEXT_LineWidthPx;
    }

    if (current < 2U) {
        availableWidth -= DISPTEXT_ControlMarkerWidthPx;
    }

    if (DISPTEXT_LineLengthTable[current] != 0) {
        LONG prefixWidth = _LVOTextLength(
            Global_REF_GRAPHICS_LIBRARY,
            rp,
            DISPTEXT_STR_SINGLE_SPACE_PREFIX_1,
            1);
        if (prefixWidth > availableWidth) {
            lineOffset += 1;
            if ((LONG)current + lineOffset < (LONG)(UWORD)DISPTEXT_TargetLineIndex) {
                availableWidth = DISPTEXT_LineWidthPx;
            }
        } else {
            availableWidth -= prefixWidth;
        }
    }

    for (;;) {
        current = (UWORD)DISPTEXT_CurrentLineIndex;

        if (src == 0 || *src == 0) {
            break;
        }
        if ((LONG)current + lineOffset >= (LONG)(UWORD)DISPTEXT_TargetLineIndex) {
            break;
        }

        src = DISPTEXT_BuildLineWithWidth(rp, src, scratch, availableWidth);
        availableWidth = DISPTEXT_LineWidthPx;

        if (current < 2U) {
            availableWidth -= DISPTEXT_ControlMarkerWidthPx;
        }

        if (src != 0) {
            lineOffset += 1;
        }
    }

    return (src == 0) ? -1 : 0;
}
