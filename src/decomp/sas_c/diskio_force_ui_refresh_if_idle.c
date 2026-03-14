#include <exec/types.h>
enum {
    DISKIO_UIBUSY_IDLE = 0,
    DISKIO_READMODE_GUARD_FLAG = 0x100,
    DISKIO_REFRESH_FORCE_NOW = -1
};

extern WORD Global_UIBusyFlag;
extern WORD ESQPARS2_ReadModeFlags;
extern WORD Global_RefreshTickCounter;

extern void TEXTDISP_ResetSelectionAndRefresh(void);

void DISKIO_ForceUiRefreshIfIdle(void)
{
    if (Global_UIBusyFlag != DISKIO_UIBUSY_IDLE) {
        return;
    }

    ESQPARS2_ReadModeFlags = DISKIO_READMODE_GUARD_FLAG;
    Global_RefreshTickCounter = DISKIO_REFRESH_FORCE_NOW;
    TEXTDISP_ResetSelectionAndRefresh();
}
