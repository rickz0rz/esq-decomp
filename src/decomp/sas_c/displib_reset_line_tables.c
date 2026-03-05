typedef unsigned short UWORD;
typedef unsigned long ULONG;

extern volatile UWORD DISPTEXT_TargetLineIndex;
extern volatile UWORD DISPTEXT_CurrentLineIndex;
extern volatile ULONG DISPTEXT_LineWidthPx;
extern volatile ULONG DISPTEXT_ControlMarkerWidthPx;
extern volatile ULONG DISPTEXT_LineTableLockFlag;
extern volatile UWORD DISPTEXT_ControlMarkersEnabledFlag;
extern volatile char *DISPTEXT_LinePtrTable[21];
extern volatile UWORD DISPTEXT_LineLengthTable[21];
extern volatile ULONG DISPTEXT_LinePenTable[21];

void DISPLIB_ResetLineTables(void)
{
    long i;

    DISPTEXT_TargetLineIndex = 0;
    DISPTEXT_CurrentLineIndex = 0;
    DISPTEXT_LineWidthPx = 0;
    DISPTEXT_ControlMarkerWidthPx = 0;
    DISPTEXT_LineTableLockFlag = 0;
    DISPTEXT_ControlMarkersEnabledFlag = 0;

    for (i = 0; i < 21; i++) {
        DISPTEXT_LinePtrTable[i] = 0;
        DISPTEXT_LineLengthTable[i] = 0;
        DISPTEXT_LinePenTable[i] = 1;
    }
}
