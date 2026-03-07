typedef signed long LONG;
typedef signed short WORD;

extern void *Global_REF_RASTPORT_1;
extern LONG Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;

extern void *ED_AdRecordPtrTable[];
extern LONG ED_AdActiveFlag;
extern LONG ED_ViewportOffset;
extern LONG ED_AdDisplayResetFlag;
extern LONG ED_AdDisplayStateLatchBlockB;
extern LONG ED_ActiveIndicatorCachedState;
extern LONG ED_AdDisplayStateLatchA;

extern const char Global_STR_AD_NUMBER_FORMATTED[];

extern LONG GROUP_AM_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, ...);
extern LONG DISPLIB_DisplayTextAtPosition(void *rastPort, LONG y, LONG x, const char *text);
extern void ED_UpdateActiveInactiveIndicator(void);

void ED_UpdateAdNumberDisplay(void)
{
    char adLabel[40];
    LONG adIndex;
    WORD activeWord;

    GROUP_AM_JMPTBL_WDISP_SPrintf(adLabel, Global_STR_AD_NUMBER_FORMATTED, Global_REF_LONG_CURRENT_EDITING_AD_NUMBER);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 180, 40, adLabel);

    ED_AdActiveFlag = 0;

    adIndex = Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;
    activeWord = *(WORD *)ED_AdRecordPtrTable[adIndex];
    if (activeWord > 0) {
        ED_AdActiveFlag = 1;
    }

    ED_AdDisplayResetFlag = 1;
    ED_ViewportOffset = 0;
    ED_AdDisplayStateLatchBlockB = -1;
    ED_ActiveIndicatorCachedState = -1;
    ED_AdDisplayStateLatchA = -1;

    ED_UpdateActiveInactiveIndicator();
}
