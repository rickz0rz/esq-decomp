#include "esq_types.h"

/*
 * Target 626 GCC trial function.
 * Format disk diagnostics message from soft-error count or usage percent.
 */
extern u8 COMMON_QueryDiskSoftErrorCountScratch[];
extern u8 COMMON_QueryDiskUsagePercentScratch[];
extern u8 DISKIO_ErrorMessageScratch[];
extern u8 Global_STR_DISK_ERRORS_FORMATTED[];
extern u8 Global_STR_DISK_IS_FULL_FORMATTED[];

s32 DISKIO_QueryVolumeSoftErrorCount(void *scratch) __attribute__((noinline));
s32 DISKIO_QueryDiskUsagePercentAndSetBufferSize(void *scratch) __attribute__((noinline));
void GROUP_AE_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, ...) __attribute__((noinline));

void ESQ_FormatDiskErrorMessage(void) __attribute__((noinline, used));

void ESQ_FormatDiskErrorMessage(void)
{
    s32 soft_errors = DISKIO_QueryVolumeSoftErrorCount(COMMON_QueryDiskSoftErrorCountScratch);

    if (soft_errors > 0) {
        GROUP_AE_JMPTBL_WDISP_SPrintf(
            (char *)DISKIO_ErrorMessageScratch,
            (const char *)Global_STR_DISK_ERRORS_FORMATTED,
            soft_errors
        );
    } else {
        s32 pct = DISKIO_QueryDiskUsagePercentAndSetBufferSize(COMMON_QueryDiskUsagePercentScratch);
        GROUP_AE_JMPTBL_WDISP_SPrintf(
            (char *)DISKIO_ErrorMessageScratch,
            (const char *)Global_STR_DISK_IS_FULL_FORMATTED,
            pct
        );
    }
}
