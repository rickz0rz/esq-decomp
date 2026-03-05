typedef unsigned short UWORD;
typedef signed short WORD;
typedef signed long LONG;

extern LONG DISPTEXT_LineTableLockFlag;
extern WORD DISPTEXT_CurrentLineIndex;
extern WORD DISPTEXT_TargetLineIndex;
extern WORD DISPTEXT_LineLengthTable[];
extern LONG DISPTEXT_LinePenTable[];
extern char *DISPTEXT_LinePtrTable[];
extern LONG DISPTEXT_LineWidthPx;
extern LONG DISPTEXT_ControlMarkerWidthPx;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern char Global_REF_1000_BYTES_ALLOCATED_2[];
extern const char DISPTEXT_STR_SINGLE_SPACE_PREFIX_2[];
extern const char DISPTEXT_STR_SINGLE_SPACE_COPY_PREFIX[];

extern LONG _LVOTextLength(void *gfxBase, void *rp, const char *text, LONG count);
extern char *DISPTEXT_BuildLineWithWidth(void *rp, char *src, char *scratch, LONG widthPx);
extern char *GROUP_AI_JMPTBL_STRING_AppendAtNull(char *dst, const char *src);
extern void DISPLIB_CommitCurrentLinePenAndAdvance(LONG pen);
extern LONG DISPTEXT_AppendToBuffer(char *src);
extern void DISPTEXT_BuildLinePointerTable(LONG lockValue);

LONG DISPTEXT_LayoutAndAppendToBuffer(void *rp, char *src)
{
    LONG availableWidth;
    char lineScratch[268];

    if (DISPTEXT_LineTableLockFlag != 0) {
        return (src == (char *)0) ? -1 : 0;
    }

    if ((UWORD)DISPTEXT_CurrentLineIndex >= (UWORD)DISPTEXT_TargetLineIndex) {
        return (src == (char *)0) ? -1 : 0;
    }

    if (DISPTEXT_LineLengthTable[(UWORD)DISPTEXT_CurrentLineIndex] != 0) {
        LONG idx = (LONG)(UWORD)DISPTEXT_CurrentLineIndex;
        LONG measured = _LVOTextLength(
            Global_REF_GRAPHICS_LIBRARY,
            rp,
            DISPTEXT_LinePtrTable[idx],
            (LONG)(UWORD)DISPTEXT_LineLengthTable[(UWORD)idx]);
        availableWidth = DISPTEXT_LineWidthPx - measured;
    } else {
        availableWidth = DISPTEXT_LineWidthPx;
    }

    if ((UWORD)DISPTEXT_CurrentLineIndex < 2U) {
        availableWidth -= DISPTEXT_ControlMarkerWidthPx;
    }

    Global_REF_1000_BYTES_ALLOCATED_2[0] = 0;

    if (DISPTEXT_LineLengthTable[(UWORD)DISPTEXT_CurrentLineIndex] != 0) {
        LONG prefixWidth = _LVOTextLength(
            Global_REF_GRAPHICS_LIBRARY,
            rp,
            DISPTEXT_STR_SINGLE_SPACE_PREFIX_2,
            1);

        if (prefixWidth > availableWidth) {
            LONG idx = (LONG)(UWORD)DISPTEXT_CurrentLineIndex;
            DISPLIB_CommitCurrentLinePenAndAdvance(DISPTEXT_LinePenTable[idx]);
            if ((UWORD)DISPTEXT_CurrentLineIndex < (UWORD)DISPTEXT_TargetLineIndex) {
                availableWidth = DISPTEXT_LineWidthPx;
            }
        } else {
            char *dst = Global_REF_1000_BYTES_ALLOCATED_2;
            const char *srcPrefix = DISPTEXT_STR_SINGLE_SPACE_COPY_PREFIX;
            while ((*dst++ = *srcPrefix++) != 0) {
            }
            availableWidth -= prefixWidth;
            DISPTEXT_LineLengthTable[(UWORD)DISPTEXT_CurrentLineIndex] =
                (WORD)(DISPTEXT_LineLengthTable[(UWORD)DISPTEXT_CurrentLineIndex] + 1);
        }
    }

    for (;;) {
        if (src == (char *)0 || *src == 0) {
            break;
        }
        if ((UWORD)DISPTEXT_CurrentLineIndex >= (UWORD)DISPTEXT_TargetLineIndex) {
            break;
        }

        src = DISPTEXT_BuildLineWithWidth(rp, src, lineScratch, availableWidth);
        GROUP_AI_JMPTBL_STRING_AppendAtNull(Global_REF_1000_BYTES_ALLOCATED_2, lineScratch);

        {
            WORD idx = DISPTEXT_CurrentLineIndex;
            WORD added = 0;
            char *p = lineScratch;
            while (*p++ != 0) {
                added++;
            }
            DISPTEXT_LineLengthTable[(UWORD)idx] = (WORD)(DISPTEXT_LineLengthTable[(UWORD)idx] + added);
        }

        availableWidth = DISPTEXT_LineWidthPx;
        if ((UWORD)DISPTEXT_CurrentLineIndex < 2U) {
            availableWidth -= DISPTEXT_ControlMarkerWidthPx;
        }

        if (src != (char *)0) {
            LONG idx = (LONG)(UWORD)DISPTEXT_CurrentLineIndex;
            DISPLIB_CommitCurrentLinePenAndAdvance(DISPTEXT_LinePenTable[idx]);
        }
    }

    if (Global_REF_1000_BYTES_ALLOCATED_2[0] != 0) {
        DISPTEXT_AppendToBuffer(Global_REF_1000_BYTES_ALLOCATED_2);
        DISPTEXT_BuildLinePointerTable(0);
    }

    return (src == (char *)0) ? -1 : 0;
}
