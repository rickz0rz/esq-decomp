/* RESTORES: ESQ_FormatDiskErrorMessage
 * MODULE:   modules/groups/_main/b/bb.s
 * STATUS:   behavioural
 *
 * Builds the disk status line into DISKIO_ErrorMessageScratch: a soft-error count
 * if the volume reported any, otherwise a percent-full figure. The two branches
 * query different things, so the "disk is full" figure is only computed when
 * there were no errors to report.
 *
 * MEASUREMENT NOTE: the reference extract is 92 bytes but the function ends at 88
 * -- the last four are `4a00 0000` sitting past the RTS, which is inter-function
 * padding, not code. So this is 88 against 88 with the two divergences below
 * cancelling. The same family of trap as the `_Return` label in
 * esqdisp_allocate_highlight_bitmaps.c: label-to-label extraction does not know
 * where the function actually stops.
 *
 * SASC-MISMATCH: alloc-result-store-order
 *   ref:     JSR / ADDQ.W #4,A7 / MOVE.L D0,D6
 *   got:     BSR / MOVE.L D0,D7 / ADDQ.W #4,A7
 *   summary: +2 / -2, no net cost. Seventh sighting of this ordering habit.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the four cross-unit calls.
 */

extern long DISKIO_QueryVolumeSoftErrorCount(char *scratch);
extern long DISKIO_QueryDiskUsagePercentAndSetBufferSize(char *scratch);
extern void GROUP_AE_JMPTBL_WDISP_SPrintf(char *buf, char *fmt, long v);

extern char COMMON_QueryDiskSoftErrorCountScratch[];
extern char COMMON_QueryDiskUsagePercentScratch[];
extern char DISKIO_ErrorMessageScratch[];
extern char Global_STR_DISK_ERRORS_FORMATTED[];
extern char Global_STR_DISK_IS_FULL_FORMATTED[];

long ESQ_FormatDiskErrorMessage(void)
{
    long errors;
    long percent;

    errors = DISKIO_QueryVolumeSoftErrorCount(COMMON_QueryDiskSoftErrorCountScratch);
    if (errors > 0) {
        GROUP_AE_JMPTBL_WDISP_SPrintf(DISKIO_ErrorMessageScratch,
                                      Global_STR_DISK_ERRORS_FORMATTED, errors);
    } else {
        percent = DISKIO_QueryDiskUsagePercentAndSetBufferSize(
                      COMMON_QueryDiskUsagePercentScratch);
        GROUP_AE_JMPTBL_WDISP_SPrintf(DISKIO_ErrorMessageScratch,
                                      Global_STR_DISK_IS_FULL_FORMATTED, percent);
    }
    return 0;
}
