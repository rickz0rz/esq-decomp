typedef unsigned short UWORD;
typedef signed short WORD;
typedef signed long LONG;

extern WORD DISPTEXT_LineTableLockFlag;
extern WORD DISPTEXT_CurrentLineIndex;
extern WORD DISPTEXT_TargetLineIndex;

extern void DISPTEXT_FinalizeLineTable(void);
extern void DISPLIB_CommitCurrentLinePenAndAdvance(void);

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
