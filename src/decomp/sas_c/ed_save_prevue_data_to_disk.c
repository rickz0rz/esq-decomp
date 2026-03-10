typedef signed long LONG;

extern char *Global_REF_RASTPORT_1;
extern const char Global_STR_SAVING_PREVUE_DATA_TO_DISK[];

extern LONG ED_IsConfirmKey(void);
extern void DISPLIB_DisplayTextAtPosition(char *rastPort, LONG y, LONG x, const char *text);
extern void DISKIO2_WriteCurDayDataFile(void);
extern void ED_DrawESCMenuBottomHelp(void);

void ED_SavePrevueDataToDisk(void)
{
    LONG keyState = ED_IsConfirmKey();

    if (((unsigned char)keyState) == 0) {
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 120, 40, Global_STR_SAVING_PREVUE_DATA_TO_DISK);
        DISKIO2_WriteCurDayDataFile();
    }

    ED_DrawESCMenuBottomHelp();
}
