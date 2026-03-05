typedef unsigned short UWORD;
typedef signed short WORD;
typedef signed long LONG;

extern LONG DISPTEXT_LineTableLockFlag;
extern LONG DISPTEXT_TextBufferPtr;
extern LONG DISPTEXT_LinePtrTable[];
extern LONG DISPTEXT_TextBufferPtrTable[];
extern WORD DISPTEXT_CurrentLineIndex;
extern WORD DISPTEXT_LineLengthTable[];

void DISPTEXT_BuildLinePointerTable(LONG lockValue)
{
    LONG headerAdjust;
    LONG totalLines;
    LONG i;
    LONG *linePtr;
    LONG *textPtr;
    WORD *offsetTable;

    if (DISPTEXT_LineTableLockFlag != 0) {
        return;
    }

    DISPTEXT_LinePtrTable[0] = DISPTEXT_TextBufferPtr;

    if (DISPTEXT_LineLengthTable[(UWORD)DISPTEXT_CurrentLineIndex] != 0) {
        headerAdjust = 1;
    } else {
        headerAdjust = 0;
    }

    totalLines = (LONG)(UWORD)DISPTEXT_CurrentLineIndex + headerAdjust;

    for (i = 1; i < totalLines; ++i) {
        linePtr = &DISPTEXT_LinePtrTable[i];
        textPtr = &DISPTEXT_TextBufferPtrTable[i];
        offsetTable = (WORD *)&DISPTEXT_CurrentLineIndex;
        *linePtr = *textPtr + (LONG)(UWORD)offsetTable[i];
    }

    DISPTEXT_LineTableLockFlag = lockValue;
}
