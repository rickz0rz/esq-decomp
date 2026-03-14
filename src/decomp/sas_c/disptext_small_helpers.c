#include <exec/types.h>
#define DISPTEXT_MIN_SELECTABLE_LINE_INDEX 1
#define DISPTEXT_MAX_SELECTABLE_LINE_INDEX 3
#define DISPTEXT_RESULT_FALSE 0
#define DISPTEXT_RESULT_TRUE 1
#define DISPTEXT_RESULT_SELECTED -1

extern WORD DISPTEXT_LineTableLockFlag;
extern WORD DISPTEXT_CurrentLineIndex;
extern WORD DISPTEXT_TargetLineIndex;
extern char *DISPTEXT_LinePtrTable[];
extern WORD DISPTEXT_LineLengthTable[];
extern void *Global_REF_GRAPHICS_LIBRARY;

extern void DISPTEXT_FinalizeLineTable(void);
extern void DISPLIB_CommitCurrentLinePenAndAdvance(LONG lineIndex);
extern LONG _LVOTextLength(void *gfxBase, char *rp, const char *text, LONG len);

void DISPTEXT_SetCurrentLineIndex(LONG lineIndex)
{
    if (DISPTEXT_LineTableLockFlag != 0) {
        return;
    }

    if (lineIndex < DISPTEXT_MIN_SELECTABLE_LINE_INDEX) {
        return;
    }

    if (lineIndex > DISPTEXT_MAX_SELECTABLE_LINE_INDEX) {
        return;
    }

    DISPLIB_CommitCurrentLinePenAndAdvance(lineIndex);
}

LONG DISPTEXT_GetTotalLineCount(void)
{
    DISPTEXT_FinalizeLineTable();
    return (UWORD)DISPTEXT_TargetLineIndex;
}

LONG DISPTEXT_HasMultipleLines(void)
{
    DISPTEXT_FinalizeLineTable();

    if (DISPTEXT_CurrentLineIndex != DISPTEXT_RESULT_FALSE) {
        return DISPTEXT_RESULT_FALSE;
    }

    if ((UWORD)DISPTEXT_TargetLineIndex <= 0) {
        return DISPTEXT_RESULT_FALSE;
    }

    return DISPTEXT_RESULT_TRUE;
}

LONG DISPTEXT_IsLastLineSelected(void)
{
    LONG lastIndex;
    LONG current;

    DISPTEXT_FinalizeLineTable();

    lastIndex = (LONG)(UWORD)DISPTEXT_TargetLineIndex;
    lastIndex -= 1;
    current = (LONG)(UWORD)DISPTEXT_CurrentLineIndex;

    if (current == lastIndex) {
        return DISPTEXT_RESULT_SELECTED;
    }
    return DISPTEXT_RESULT_FALSE;
}

LONG DISPTEXT_IsCurrentLineLast(void)
{
    LONG current;
    LONG target;

    DISPTEXT_FinalizeLineTable();

    current = (LONG)(UWORD)DISPTEXT_CurrentLineIndex;
    target = (LONG)(UWORD)DISPTEXT_TargetLineIndex;

    if (current == target) {
        return DISPTEXT_RESULT_SELECTED;
    }
    return DISPTEXT_RESULT_FALSE;
}

LONG DISPTEXT_MeasureCurrentLineLength(char *rp)
{
    LONG lineIndex;
    char *linePtr;
    LONG charCount;

    DISPTEXT_FinalizeLineTable();

    lineIndex = (LONG)(UWORD)DISPTEXT_CurrentLineIndex;
    linePtr = DISPTEXT_LinePtrTable[lineIndex];
    charCount = (LONG)(UWORD)DISPTEXT_LineLengthTable[lineIndex];

    return _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, rp, linePtr, charCount);
}
