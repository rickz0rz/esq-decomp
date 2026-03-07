typedef unsigned short UWORD;
typedef unsigned long ULONG;

extern volatile UWORD DISPTEXT_TargetLineIndex;
extern volatile UWORD DISPTEXT_CurrentLineIndex;
extern volatile UWORD DISPTEXT_LineLengthTable[21];
extern volatile ULONG DISPTEXT_LinePenTable[21];

void DISPLIB_CommitCurrentLinePenAndAdvance(ULONG pen)
{
    UWORD lineIndex = DISPTEXT_CurrentLineIndex;

    if (DISPTEXT_LineLengthTable[lineIndex] != 0) {
        DISPTEXT_CurrentLineIndex = (UWORD)(lineIndex + 1U);
    }

    lineIndex = DISPTEXT_CurrentLineIndex;
    if (lineIndex < DISPTEXT_TargetLineIndex) {
        DISPTEXT_LinePenTable[lineIndex] = pen;
    }
}
