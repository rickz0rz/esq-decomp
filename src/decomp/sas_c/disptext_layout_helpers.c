typedef unsigned short UWORD;
typedef signed short WORD;
typedef signed long LONG;

extern LONG DISPTEXT_LineTableLockFlag;
extern WORD DISPTEXT_CurrentLineIndex;
extern WORD DISPTEXT_TargetLineIndex;
extern WORD DISPTEXT_LineLengthTable[];
extern LONG DISPTEXT_LineWidthPx;

extern void DISPTEXT_BuildLinePointerTable(void);
extern void DISPLIB_ResetTextBufferAndLineTables(void);
extern void DISPLIB_CommitCurrentLinePenAndAdvance(void);

void DISPTEXT_FinalizeLineTable(void)
{
    WORD idx;

    if (DISPTEXT_LineTableLockFlag != 0) {
        return;
    }

    idx = DISPTEXT_CurrentLineIndex;
    DISPTEXT_TargetLineIndex = idx;

    if (DISPTEXT_LineLengthTable[(UWORD)idx] != 0) {
        DISPTEXT_TargetLineIndex = (WORD)(idx + 1);
    }

    DISPTEXT_BuildLinePointerTable(1);
    DISPTEXT_CurrentLineIndex = 0;
}

LONG DISPTEXT_SetLayoutParams(LONG widthPx, LONG targetLines, LONG currentLine)
{
    DISPLIB_ResetTextBufferAndLineTables();

    if (widthPx >= 0 && widthPx <= 624) {
        DISPTEXT_LineWidthPx = widthPx;
    }

    if (targetLines > 0 && targetLines <= 20) {
        DISPTEXT_TargetLineIndex = (WORD)targetLines;
    }

    DISPLIB_CommitCurrentLinePenAndAdvance(currentLine);

    if (DISPTEXT_LineWidthPx != widthPx) {
        return 0;
    }

    if ((LONG)(UWORD)DISPTEXT_TargetLineIndex != targetLines) {
        return 0;
    }

    return 1;
}
