#include <exec/types.h>
extern char COMMON_QueryDiskSoftErrorCountScratch[];
extern char COMMON_QueryDiskUsagePercentScratch[];
extern char DISKIO_ErrorMessageScratch[];
extern const char Global_STR_DISK_ERRORS_FORMATTED[];
extern const char Global_STR_DISK_IS_FULL_FORMATTED[];

extern LONG DISKIO_QueryVolumeSoftErrorCount(void *scratch);
extern LONG DISKIO_QueryDiskUsagePercentAndSetBufferSize(void *scratch);
extern LONG WDISP_SPrintf(char *dst, const char *fmt, LONG a);

LONG ESQ_FormatDiskErrorMessage(void)
{
    LONG softErrors;

    softErrors = DISKIO_QueryVolumeSoftErrorCount(COMMON_QueryDiskSoftErrorCountScratch);

    if (softErrors > 0) {
        WDISP_SPrintf(
            DISKIO_ErrorMessageScratch,
            Global_STR_DISK_ERRORS_FORMATTED,
            softErrors
        );
    } else {
        LONG pct;

        pct = DISKIO_QueryDiskUsagePercentAndSetBufferSize(COMMON_QueryDiskUsagePercentScratch);
        WDISP_SPrintf(
            DISKIO_ErrorMessageScratch,
            Global_STR_DISK_IS_FULL_FORMATTED,
            pct
        );
    }

    return 0;
}
