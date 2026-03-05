typedef unsigned char UBYTE;
typedef unsigned short UWORD;

extern void DISKIO2_WriteCurDayDataFile(void);
extern void DISKIO2_WriteNxtDayDataFile(void);
extern void DISKIO2_WriteOinfoDataFile(void);
extern void COI_WriteOiDataFile(long diskId);

extern void DISKIO2_LoadCurDayDataFile(void);
extern void DISKIO2_LoadNxtDayDataFile(void);
extern void DISKIO2_LoadOinfoDataFile(void);
extern void GROUP_AH_JMPTBL_NEWGRID_RebuildIndexCache(void);

volatile UWORD DISKIO2_FlushDataFilesGuardFlag;
volatile UWORD TEXTDISP_PrimaryGroupEntryCount;
volatile UBYTE CTASKS_PrimaryOiWritePendingFlag;
volatile UBYTE CTASKS_PendingPrimaryOiDiskId;
volatile UBYTE CTASKS_SecondaryOiWritePendingFlag;
volatile UBYTE CTASKS_PendingSecondaryOiDiskId;

void DISKIO2_FlushDataFilesIfNeeded(void)
{
    if (DISKIO2_FlushDataFilesGuardFlag != 0) {
        return;
    }

    DISKIO2_FlushDataFilesGuardFlag = 1;
    if (TEXTDISP_PrimaryGroupEntryCount < 0xc9U) {
        DISKIO2_WriteCurDayDataFile();
        DISKIO2_WriteNxtDayDataFile();
        DISKIO2_WriteOinfoDataFile();

        if (CTASKS_PrimaryOiWritePendingFlag != 0) {
            COI_WriteOiDataFile((long)CTASKS_PendingPrimaryOiDiskId);
        }
        if (CTASKS_SecondaryOiWritePendingFlag != 0) {
            COI_WriteOiDataFile((long)CTASKS_PendingSecondaryOiDiskId);
        }
    }
    DISKIO2_FlushDataFilesGuardFlag = 0;
}

void DISKIO2_ReloadDataFilesAndRebuildIndex(void)
{
    DISKIO2_LoadCurDayDataFile();
    DISKIO2_LoadNxtDayDataFile();
    DISKIO2_LoadOinfoDataFile();
    GROUP_AH_JMPTBL_NEWGRID_RebuildIndexCache();
}
