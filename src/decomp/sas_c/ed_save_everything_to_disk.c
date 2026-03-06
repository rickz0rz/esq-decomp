typedef signed long LONG;

extern void *Global_REF_RASTPORT_1;
extern const char Global_STR_SAVING_EVERYTHING_TO_DISK[];

extern LONG ED_IsConfirmKey(void);
extern LONG DISPLIB_DisplayTextAtPosition(void *rastPort, LONG y, LONG x, const char *text);
extern void DISKIO2_RunDiskSyncWorkflow(LONG mode);
extern void ED_DrawESCMenuBottomHelp(void);

void ED_SaveEverythingToDisk(void)
{
    LONG keyState = ED_IsConfirmKey();

    if (((unsigned char)keyState) == 0) {
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 90, 40, Global_STR_SAVING_EVERYTHING_TO_DISK);
        DISKIO2_RunDiskSyncWorkflow(1);
    }

    ED_DrawESCMenuBottomHelp();
}
