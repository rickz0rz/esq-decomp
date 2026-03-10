typedef signed long LONG;

extern char *Global_REF_RASTPORT_1;
extern const char Global_STR_LOADING_TEXT_ADS_FROM_DH2[];

extern LONG ED_IsConfirmKey(void);
extern void DISPLIB_DisplayTextAtPosition(char *rastPort, LONG y, LONG x, const char *text);
extern LONG GROUP_AM_JMPTBL_LADFUNC_LoadTextAdsFromFile(void);
extern void ED_DrawESCMenuBottomHelp(void);

void ED_LoadTextAdsFromDh2(void)
{
    LONG keyState = ED_IsConfirmKey();

    if (((unsigned char)keyState) == 0) {
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 120, 40, Global_STR_LOADING_TEXT_ADS_FROM_DH2);
        GROUP_AM_JMPTBL_LADFUNC_LoadTextAdsFromFile();
    }

    ED_DrawESCMenuBottomHelp();
}
