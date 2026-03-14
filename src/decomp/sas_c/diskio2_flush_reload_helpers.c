#include <exec/types.h>
extern void DISKIO2_WriteCurDayDataFile(void);
extern void DISKIO2_WriteNxtDayDataFile(void);
extern void DISKIO2_WriteOinfoDataFile(void);
extern long COI_WriteOiDataFile(long diskId);

extern void DISKIO2_LoadCurDayDataFile(void);
extern void DISKIO2_LoadNxtDayDataFile(void);
extern void DISKIO2_LoadOinfoDataFile(void);
extern void NEWGRID_RebuildIndexCache(void);

volatile UWORD DISKIO2_FlushDataFilesGuardFlag;
volatile UWORD TEXTDISP_PrimaryGroupEntryCount;
volatile UBYTE CTASKS_PrimaryOiWritePendingFlag;
volatile UBYTE CTASKS_PendingPrimaryOiDiskId;
volatile UBYTE CTASKS_SecondaryOiWritePendingFlag;
volatile UBYTE CTASKS_PendingSecondaryOiDiskId;

#define DISKIO2_FLAG_CLEAR 0
#define DISKIO2_FLAG_SET 1
#define DISKIO2_MAX_PRIMARY_ENTRY_COUNT_PLUS_ONE 0xC9U

void DISKIO2_FlushDataFilesIfNeeded(void)
{
    if (DISKIO2_FlushDataFilesGuardFlag != DISKIO2_FLAG_CLEAR) {
        return;
    }

    DISKIO2_FlushDataFilesGuardFlag = DISKIO2_FLAG_SET;
    if (TEXTDISP_PrimaryGroupEntryCount < DISKIO2_MAX_PRIMARY_ENTRY_COUNT_PLUS_ONE) {
        DISKIO2_WriteCurDayDataFile();
        DISKIO2_WriteNxtDayDataFile();
        DISKIO2_WriteOinfoDataFile();

        if (CTASKS_PrimaryOiWritePendingFlag != DISKIO2_FLAG_CLEAR) {
            COI_WriteOiDataFile((long)CTASKS_PendingPrimaryOiDiskId);
        }
        if (CTASKS_SecondaryOiWritePendingFlag != DISKIO2_FLAG_CLEAR) {
            COI_WriteOiDataFile((long)CTASKS_PendingSecondaryOiDiskId);
        }
    }
    DISKIO2_FlushDataFilesGuardFlag = DISKIO2_FLAG_CLEAR;
}

void DISKIO2_ReloadDataFilesAndRebuildIndex(void)
{
    DISKIO2_LoadCurDayDataFile();
    DISKIO2_LoadNxtDayDataFile();
    DISKIO2_LoadOinfoDataFile();
    NEWGRID_RebuildIndexCache();
}
