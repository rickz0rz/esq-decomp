#include <exec/types.h>
enum {
    DISPTEXT_LINE_TABLE_COUNT = 21,
    DISPTEXT_DEFAULT_PEN = 1,
    DISPTEXT_VALUE_CLEAR = 0
};

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

    DISPTEXT_TargetLineIndex = DISPTEXT_VALUE_CLEAR;
    DISPTEXT_CurrentLineIndex = DISPTEXT_VALUE_CLEAR;
    DISPTEXT_LineWidthPx = DISPTEXT_VALUE_CLEAR;
    DISPTEXT_ControlMarkerWidthPx = DISPTEXT_VALUE_CLEAR;
    DISPTEXT_LineTableLockFlag = DISPTEXT_VALUE_CLEAR;
    DISPTEXT_ControlMarkersEnabledFlag = DISPTEXT_VALUE_CLEAR;

    for (i = 0; i < DISPTEXT_LINE_TABLE_COUNT; ++i) {
        DISPTEXT_LinePtrTable[i] = 0;
        DISPTEXT_LineLengthTable[i] = DISPTEXT_VALUE_CLEAR;
        DISPTEXT_LinePenTable[i] = DISPTEXT_DEFAULT_PEN;
    }
}
