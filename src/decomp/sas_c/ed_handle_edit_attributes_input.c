typedef signed long LONG;
typedef unsigned char UBYTE;

extern UBYTE ED_LastKeyCode;
extern LONG ED_AdActiveFlag;
extern LONG ED_SaveTextAdsOnExitFlag;
extern LONG ED_AdDisplayResetFlag;
extern LONG ED_StateRingIndex;
extern UBYTE ED_StateRingTable[];

extern void ED_DrawESCMenuBottomHelp(void);
extern void ED_IncrementAdNumber(void);
extern void ED_DecrementAdNumber(void);
extern LONG ESQDISP_TestWordIsZeroBooleanize(LONG value);
extern void ED_ApplyActiveFlagToAdData(void);
extern void ED_UpdateActiveInactiveIndicator(void);

void ED_HandleEditAttributesInput(void)
{
    LONG ringOff;

    if (ED_LastKeyCode == 13 || ED_LastKeyCode == 27) {
        ED_DrawESCMenuBottomHelp();
        ED_SaveTextAdsOnExitFlag = 1;
        ED_ApplyActiveFlagToAdData();
        ED_UpdateActiveInactiveIndicator();
        return;
    }

    if (ED_LastKeyCode == 0x80) {
        ringOff = (ED_StateRingIndex << 2) + ED_StateRingIndex;
        if (ED_StateRingTable[ringOff + 1] == 32) {
            if (ED_StateRingTable[ringOff + 2] == 64) {
                ED_IncrementAdNumber();
            } else if (ED_StateRingTable[ringOff + 2] == 65) {
                ED_DecrementAdNumber();
            }
        }
    } else {
        ED_AdActiveFlag = ESQDISP_TestWordIsZeroBooleanize(ED_AdActiveFlag);
        ED_AdDisplayResetFlag = 1;
    }

    ED_UpdateActiveInactiveIndicator();
}
