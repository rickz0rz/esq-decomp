typedef unsigned short UWORD;
typedef signed short WORD;
typedef signed long LONG;

extern LONG DISPTEXT_LineTableLockFlag;
extern WORD DISPTEXT_CurrentLineIndex;
extern WORD DISPTEXT_TargetLineIndex;
extern WORD DISPTEXT_LineLengthTable[];
extern char *DISPTEXT_LinePtrTable[];
extern LONG DISPTEXT_LineWidthPx;
extern LONG DISPTEXT_ControlMarkerWidthPx;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern const char DISPTEXT_STR_SINGLE_SPACE_PREFIX_1[];

extern LONG _LVOTextLength(void *gfxBase, void *rp, const char *text, LONG count);
extern char *DISPTEXT_BuildLineWithWidth(void *rp, char *src, char *scratch, LONG widthPx);

LONG DISPTEXT_LayoutSourceToLines(void *rp, char *src)
{
    LONG lineOffset = 0;
    LONG availableWidth;
    char scratch[268];
    UWORD current;

    if (DISPTEXT_LineTableLockFlag != 0) {
        return (src == (char *)0) ? -1 : 0;
    }

    current = (UWORD)DISPTEXT_CurrentLineIndex;
    if (current >= (UWORD)DISPTEXT_TargetLineIndex) {
        return (src == (char *)0) ? -1 : 0;
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

        if (src == (char *)0 || *src == 0) {
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

        if (src != (char *)0) {
            lineOffset += 1;
        }
    }

    return (src == (char *)0) ? -1 : 0;
}
