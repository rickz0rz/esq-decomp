#include <exec/types.h>
#define DISPTEXT_BUILD_LINE_PTRS_FLAG 1
#define DISPTEXT_MAX_LINE_WIDTH_PX 624
#define DISPTEXT_MAX_TARGET_LINES 20
#define DISPTEXT_RESULT_FALSE 0
#define DISPTEXT_RESULT_TRUE 1

extern LONG DISPTEXT_LineTableLockFlag;
extern WORD DISPTEXT_CurrentLineIndex;
extern WORD DISPTEXT_TargetLineIndex;
extern WORD DISPTEXT_LineLengthTable[];
extern LONG DISPTEXT_LineWidthPx;

extern void DISPTEXT_BuildLinePointerTable(LONG lockValue);
extern void DISPLIB_ResetTextBufferAndLineTables(void);
extern void DISPLIB_CommitCurrentLinePenAndAdvance(LONG pen);

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

    DISPTEXT_BuildLinePointerTable(DISPTEXT_BUILD_LINE_PTRS_FLAG);
    DISPTEXT_CurrentLineIndex = 0;
}

LONG DISPTEXT_SetLayoutParams(LONG widthPx, LONG targetLines, LONG currentLine)
{
    DISPLIB_ResetTextBufferAndLineTables();

    if (widthPx >= 0 && widthPx <= DISPTEXT_MAX_LINE_WIDTH_PX) {
        DISPTEXT_LineWidthPx = widthPx;
    }

    if (targetLines > 0 && targetLines <= DISPTEXT_MAX_TARGET_LINES) {
        DISPTEXT_TargetLineIndex = (WORD)targetLines;
    }

    DISPLIB_CommitCurrentLinePenAndAdvance(currentLine);

    if (DISPTEXT_LineWidthPx != widthPx) {
        return DISPTEXT_RESULT_FALSE;
    }

    if ((LONG)(UWORD)DISPTEXT_TargetLineIndex != targetLines) {
        return DISPTEXT_RESULT_FALSE;
    }

    return DISPTEXT_RESULT_TRUE;
}
