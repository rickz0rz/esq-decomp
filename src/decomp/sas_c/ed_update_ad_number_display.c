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
    const LONG LABEL_Y = 180;
    const LONG LABEL_X = 40;
    const LONG FLAG_FALSE = 0;
    const LONG FLAG_TRUE = 1;
    const LONG LATCH_RESET = -1;
    char adLabel[40];
    LONG adIndex;
    WORD activeWord;

    GROUP_AM_JMPTBL_WDISP_SPrintf(adLabel, Global_STR_AD_NUMBER_FORMATTED, Global_REF_LONG_CURRENT_EDITING_AD_NUMBER);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, LABEL_Y, LABEL_X, adLabel);

    ED_AdActiveFlag = FLAG_FALSE;

    adIndex = Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;
    activeWord = *(WORD *)ED_AdRecordPtrTable[adIndex];
    if (activeWord > 0) {
        ED_AdActiveFlag = FLAG_TRUE;
    }

    ED_AdDisplayResetFlag = FLAG_TRUE;
    ED_ViewportOffset = FLAG_FALSE;
    ED_AdDisplayStateLatchBlockB = LATCH_RESET;
    ED_ActiveIndicatorCachedState = LATCH_RESET;
    ED_AdDisplayStateLatchA = LATCH_RESET;

    ED_UpdateActiveInactiveIndicator();
}
