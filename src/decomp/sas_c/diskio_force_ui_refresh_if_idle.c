typedef signed short WORD;

extern WORD Global_UIBusyFlag;
extern WORD ESQPARS2_ReadModeFlags;
extern WORD Global_RefreshTickCounter;

extern void GROUP_AG_JMPTBL_TEXTDISP_ResetSelectionAndRefresh(void);

void DISKIO_ForceUiRefreshIfIdle(void)
{
    if (Global_UIBusyFlag != 0) {
        return;
    }

    ESQPARS2_ReadModeFlags = 0x100;
    Global_RefreshTickCounter = -1;
    GROUP_AG_JMPTBL_TEXTDISP_ResetSelectionAndRefresh();
}
