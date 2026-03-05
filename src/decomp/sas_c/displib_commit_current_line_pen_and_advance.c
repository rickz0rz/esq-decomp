typedef unsigned short UWORD;
typedef unsigned long ULONG;

extern volatile UWORD DISPTEXT_TargetLineIndex;
extern volatile UWORD DISPTEXT_CurrentLineIndex;
extern volatile UWORD DISPTEXT_LineLengthTable[21];
extern volatile ULONG DISPTEXT_LinePenTable[21];

void DISPLIB_CommitCurrentLinePenAndAdvance(ULONG pen)
{
    UWORD idx = DISPTEXT_CurrentLineIndex;

    if (DISPTEXT_LineLengthTable[idx] != 0) {
        DISPTEXT_CurrentLineIndex = (UWORD)(idx + 1U);
    }

    idx = DISPTEXT_CurrentLineIndex;
    if (idx < DISPTEXT_TargetLineIndex) {
        DISPTEXT_LinePenTable[idx] = pen;
    }
}
