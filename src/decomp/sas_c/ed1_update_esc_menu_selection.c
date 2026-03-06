typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern LONG ED_StateRingIndex;
extern UBYTE ED_StateRingTable[];
extern UBYTE ED_LastKeyCode;
extern WORD ED_DiagnosticsScreenActive;

extern void ED_DrawESCMenuBottomHelp(void);

void ED1_UpdateEscMenuSelection(void)
{
    UBYTE value = ED_StateRingTable[(ED_StateRingIndex << 2) + ED_StateRingIndex];

    ED_LastKeyCode = value;
    if (((WORD)value - (WORD)0x31) != 0) {
        ED_DrawESCMenuBottomHelp();
        ED_DiagnosticsScreenActive = 0;
    }
}
