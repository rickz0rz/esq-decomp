#include <exec/types.h>
extern void *DST_BannerWindowPrimary;
extern UBYTE LOCAVAIL_PrimaryFilterState[];
extern UBYTE LOCAVAIL_SecondaryFilterState[];

extern void ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded(void);
extern LONG LADFUNC_SaveTextAdsToFile(void);
extern LONG ESQPARS_JMPTBL_DATETIME_SavePairToFile(void *pair);
extern LONG LOCAVAIL_SaveAvailabilityDataFile(void *primary, void *secondary);
extern void ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile(void);

void ESQPARS_PersistStateDataAfterCommand(void)
{
    ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded();
    LADFUNC_SaveTextAdsToFile();
    ESQPARS_JMPTBL_DATETIME_SavePairToFile(DST_BannerWindowPrimary);
    LOCAVAIL_SaveAvailabilityDataFile(LOCAVAIL_PrimaryFilterState, LOCAVAIL_SecondaryFilterState);
    ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile();
}
