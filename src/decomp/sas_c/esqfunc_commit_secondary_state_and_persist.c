#include <exec/types.h>
#include <exec/types.h>
extern WORD ESQPARS2_ReadModeFlags;
extern WORD ESQDISP_PendingGridReinitFlag;
extern UBYTE LOCAVAIL_PrimaryFilterState;
extern UBYTE LOCAVAIL_SecondaryFilterState;
extern void *DST_BannerWindowPrimary;

extern void ESQDISP_PropagatePrimaryTitleMetadataToSecondary(void);
extern void LOCAVAIL_RebuildFilterStateFromCurrentGroup(void);
extern void ESQDISP_PromoteSecondaryGroupToPrimary(void);
extern void ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty(void);
extern void ESQDISP_PromoteSecondaryLineHeadTailIfMarked(void);
extern void DISKIO2_FlushDataFilesIfNeeded(void);
extern LONG LADFUNC_SaveTextAdsToFile(void);
extern LONG LOCAVAIL_SaveAvailabilityDataFile(void *primary, void *secondary);
extern LONG DATETIME_SavePairToFile(void *pair);
extern void P_TYPE_PromoteSecondaryList(void);
extern void P_TYPE_WritePromoIdDataFile(void);
extern void ESQFUNC_UpdateDiskWarningAndRefreshTick(void);

void ESQFUNC_CommitSecondaryStateAndPersist(void)
{
    const WORD READMODE_PROMOTE_PASS = 0x100;
    const WORD FLAG_PENDING = 1;
    WORD savedFlags;

    savedFlags = ESQPARS2_ReadModeFlags;
    ESQPARS2_ReadModeFlags = READMODE_PROMOTE_PASS;
    ESQDISP_PendingGridReinitFlag = FLAG_PENDING;

    ESQDISP_PropagatePrimaryTitleMetadataToSecondary();
    LOCAVAIL_RebuildFilterStateFromCurrentGroup();
    ESQDISP_PromoteSecondaryGroupToPrimary();
    ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty();
    ESQDISP_PromoteSecondaryLineHeadTailIfMarked();

    DISKIO2_FlushDataFilesIfNeeded();
    LADFUNC_SaveTextAdsToFile();

    LOCAVAIL_SaveAvailabilityDataFile(
        &LOCAVAIL_PrimaryFilterState,
        &LOCAVAIL_SecondaryFilterState);

    DATETIME_SavePairToFile(DST_BannerWindowPrimary);
    P_TYPE_PromoteSecondaryList();
    P_TYPE_WritePromoIdDataFile();
    ESQFUNC_UpdateDiskWarningAndRefreshTick();

    ESQPARS2_ReadModeFlags = savedFlags;
}
