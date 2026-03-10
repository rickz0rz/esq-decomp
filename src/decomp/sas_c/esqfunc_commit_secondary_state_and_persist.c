typedef signed short WORD;
typedef signed long LONG;

typedef unsigned char UBYTE;

extern WORD ESQPARS2_ReadModeFlags;
extern WORD ESQDISP_PendingGridReinitFlag;
extern UBYTE LOCAVAIL_PrimaryFilterState;
extern UBYTE LOCAVAIL_SecondaryFilterState;
extern UBYTE DST_BannerWindowPrimary;

extern void ESQDISP_PropagatePrimaryTitleMetadataToSecondary(void);
extern void ESQFUNC_JMPTBL_LOCAVAIL_RebuildFilterStateFromCurrentGroup(void);
extern void ESQDISP_PromoteSecondaryGroupToPrimary(void);
extern void ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty(void);
extern void ESQDISP_PromoteSecondaryLineHeadTailIfMarked(void);
extern void ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded(void);
extern LONG ESQPARS_JMPTBL_LADFUNC_SaveTextAdsToFile(void);
extern void ESQPARS_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile(void *primary, void *secondary);
extern void DATETIME_SavePairToFile(void *pair);
extern void ESQFUNC_JMPTBL_P_TYPE_PromoteSecondaryList(void);
extern void ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile(void);
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
    ESQFUNC_JMPTBL_LOCAVAIL_RebuildFilterStateFromCurrentGroup();
    ESQDISP_PromoteSecondaryGroupToPrimary();
    ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty();
    ESQDISP_PromoteSecondaryLineHeadTailIfMarked();

    ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded();
    ESQPARS_JMPTBL_LADFUNC_SaveTextAdsToFile();

    ESQPARS_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile(
        &LOCAVAIL_PrimaryFilterState,
        &LOCAVAIL_SecondaryFilterState);

    DATETIME_SavePairToFile(&DST_BannerWindowPrimary);
    ESQFUNC_JMPTBL_P_TYPE_PromoteSecondaryList();
    ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile();
    ESQFUNC_UpdateDiskWarningAndRefreshTick();

    ESQPARS2_ReadModeFlags = savedFlags;
}
