typedef signed long LONG;
typedef signed short WORD;

typedef unsigned char UBYTE;

typedef struct ESQFUNC_RastPortHolder {
    UBYTE pad0[2];
    UBYTE rastPort[1];
} ESQFUNC_RastPortHolder;

extern LONG DISKIO_Drive0WriteProtectedCode;
extern LONG DISKIO_DriveMediaStatusCodeTable;
extern WORD Global_RefreshTickCounter;
extern ESQFUNC_RastPortHolder Global_REF_RASTPORT_2;
extern const char Global_STR_DISK_0_IS_WRITE_PROTECTED[];
extern const char Global_STR_YOU_MUST_REINSERT_SYSTEM_DISK_INTO_DRIVE_0[];

extern void DISKIO_ProbeDrivesAndAssignPaths(void);
extern void TLIBA3_DrawCenteredWrappedTextLines(char *rastPort, const char *text, LONG y);

void ESQFUNC_UpdateDiskWarningAndRefreshTick(void)
{
    DISKIO_ProbeDrivesAndAssignPaths();

    if (DISKIO_Drive0WriteProtectedCode != 0) {
        Global_RefreshTickCounter = -1;
        TLIBA3_DrawCenteredWrappedTextLines(
            (char *)Global_REF_RASTPORT_2.rastPort,
            Global_STR_YOU_MUST_REINSERT_SYSTEM_DISK_INTO_DRIVE_0,
            90);
        return;
    }

    if (DISKIO_DriveMediaStatusCodeTable != 0) {
        Global_RefreshTickCounter = -1;
        TLIBA3_DrawCenteredWrappedTextLines(
            (char *)Global_REF_RASTPORT_2.rastPort,
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
