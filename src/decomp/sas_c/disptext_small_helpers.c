typedef unsigned short UWORD;
typedef signed short WORD;
typedef signed long LONG;

extern WORD DISPTEXT_LineTableLockFlag;
extern WORD DISPTEXT_CurrentLineIndex;
extern WORD DISPTEXT_TargetLineIndex;
extern void *DISPTEXT_LinePtrTable[];
extern WORD DISPTEXT_LineLengthTable[];
extern void *Global_REF_GRAPHICS_LIBRARY;

extern void DISPTEXT_FinalizeLineTable(void);
extern void DISPLIB_CommitCurrentLinePenAndAdvance(void);
extern LONG _LVOTextLength(void);

void DISPTEXT_SetCurrentLineIndex(LONG lineIndex)
{
    if (DISPTEXT_LineTableLockFlag != 0) {
        return;
    }

    if (lineIndex < 1) {
        return;
    }

    if (lineIndex > 3) {
        return;
    }

    DISPLIB_CommitCurrentLinePenAndAdvance(lineIndex);
}

LONG DISPTEXT_GetTotalLineCount(void)
{
    DISPTEXT_FinalizeLineTable();
    return (LONG)(UWORD)DISPTEXT_TargetLineIndex;
}

LONG DISPTEXT_HasMultipleLines(void)
{
    DISPTEXT_FinalizeLineTable();

    if (DISPTEXT_CurrentLineIndex != 0) {
        return 0;
    }

    if ((UWORD)DISPTEXT_TargetLineIndex <= 0) {
        return 0;
    }

    return 1;
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
        return -1;
    }
    return 0;
}

LONG DISPTEXT_IsCurrentLineLast(void)
{
    LONG current;
    LONG target;

    DISPTEXT_FinalizeLineTable();

    current = (LONG)(UWORD)DISPTEXT_CurrentLineIndex;
    target = (LONG)(UWORD)DISPTEXT_TargetLineIndex;

    if (current == target) {
        return -1;
    }
    return 0;
}

LONG DISPTEXT_MeasureCurrentLineLength(void *rp)
{
    LONG lineIndex;
    void *linePtr;
    LONG charCount;

    DISPTEXT_FinalizeLineTable();

    lineIndex = (LONG)(UWORD)DISPTEXT_CurrentLineIndex;
    linePtr = DISPTEXT_LinePtrTable[lineIndex];
    charCount = (LONG)(UWORD)DISPTEXT_LineLengthTable[lineIndex];

    return _LVOTextLength(rp, linePtr, charCount);
}
