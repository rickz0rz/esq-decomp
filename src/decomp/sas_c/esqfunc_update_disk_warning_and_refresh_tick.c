#include <exec/types.h>

enum {
    ESQFUNC_DISPLAY_RASTPORT2_OFFSET = 10
};

extern LONG DISKIO_Drive0WriteProtectedCode;
extern LONG DISKIO_DriveMediaStatusCodeTable;
extern LONG WDISP_DisplayContextBase;
extern WORD Global_RefreshTickCounter;
extern const char Global_STR_DISK_0_IS_WRITE_PROTECTED[];
extern const char Global_STR_YOU_MUST_REINSERT_SYSTEM_DISK_INTO_DRIVE_0[];

extern void DISKIO_ProbeDrivesAndAssignPaths(void);
extern void TLIBA3_DrawCenteredWrappedTextLines(char *rastPort, const char *text, LONG y);

void ESQFUNC_UpdateDiskWarningAndRefreshTick(void)
{
    char *displayRastPort;

    DISKIO_ProbeDrivesAndAssignPaths();
    displayRastPort = (char *)(WDISP_DisplayContextBase + ESQFUNC_DISPLAY_RASTPORT2_OFFSET);

    if (DISKIO_Drive0WriteProtectedCode != 0) {
        Global_RefreshTickCounter = -1;
        TLIBA3_DrawCenteredWrappedTextLines(
            displayRastPort,
            Global_STR_YOU_MUST_REINSERT_SYSTEM_DISK_INTO_DRIVE_0,
            90);
        return;
    }

    if (DISKIO_DriveMediaStatusCodeTable != 0) {
        Global_RefreshTickCounter = -1;
        TLIBA3_DrawCenteredWrappedTextLines(
            displayRastPort,
            Global_STR_DISK_0_IS_WRITE_PROTECTED,
            90);
        return;
    }

    {
        WORD next = (WORD)(Global_RefreshTickCounter + 1);
        if (next == 0) {
            Global_RefreshTickCounter = 0;
        }
    }
}
