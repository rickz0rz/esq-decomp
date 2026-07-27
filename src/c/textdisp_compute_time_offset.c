/* RESTORES: TEXTDISP_ComputeTimeOffset
 * MODULE:   modules/groups/b/a/textdisp2.s
 * STATUS:   behavioural
 *
 * 228 bytes in the original and 228 emitted -- the FOURTH size coincidence of
 * the run, with 17 differing regions. Not a near-match; see
 * coi_free_sub_entry_table_entries.c for what a genuine size agreement looks
 * like (same byte count, seven regions).
 *
 * Reproduces: the schedule-offset lookup feeding the broadcast-window call, the
 * six-argument window call writing a date triple and an hour/minute pair into
 * two separate stack arrays, the nested date comparison that falls through year
 * to month to day and stops at the first non-zero difference, the conversion of
 * the window time to minutes, the current-time subtraction with its 12-hour
 * wrap and AM/PM bias, and the day difference scaled by 1440.
 *
 * The 1440 constant is loaded as MOVE.L #$5a0 -- neither 720x2 nor a complement,
 * so it falls outside both of the original's four-byte constant forms, exactly as
 * the rule in docs/compiler-version.md predicts.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ffdc                   LINK.W A5,#-36
 *   got:     9efc0018                   SUBA.W #24,A7
 *   summary: The A5-frame class. Both output arrays move to A7-relative, and
 *            since they are passed by address to the window call this touches
 *            every reference to them -- which is most of the 17 regions.
 *
 * SASC-MISMATCH: divide-helper-result-sharing
 *   summary: The 12-hour wrap takes the remainder from MATH_DivS32's D1 while
 *            discarding the quotient. Fourth sighting of this class.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the five cross-unit calls.
 */
extern short TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow(long mode, long code);
extern void  TLIBA2_ComputeBroadcastTimeWindow(long row, void *entry, long mode,
                                               long off, long *ymd, long *hm);
extern short CLOCK_CurrentYearValue;
extern short CLOCK_CurrentMonthIndex;
extern short CLOCK_CurrentDayOfMonth;
extern short CLOCK_CurrentAmPmFlag;
extern short Global_WORD_CURRENT_HOUR;
extern short Global_WORD_CURRENT_MINUTE;

long TEXTDISP_ComputeTimeOffset(short row, unsigned char *entry, short mode)
{
    long ymd[3];
    long hm[2];
    register long dayDelta;
    register long minutes;
    long off;

    off = TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow((long)mode,
                                                            (long)entry[498]);
    TLIBA2_ComputeBroadcastTimeWindow((long)row, entry, (long)mode, off, ymd, hm);

    dayDelta = ymd[0] - CLOCK_CurrentYearValue;
    if (dayDelta == 0) {
        dayDelta = ymd[1] - CLOCK_CurrentMonthIndex;
        if (dayDelta == 0)
            dayDelta = ymd[2] - CLOCK_CurrentDayOfMonth;
    }

    minutes = hm[0] * 60 + hm[1];
    minutes -= (Global_WORD_CURRENT_HOUR % 12
                + (CLOCK_CurrentAmPmFlag ? 12 : 0)) * 60
               + Global_WORD_CURRENT_MINUTE;
    minutes += dayDelta * 1440;

    return minutes;
}
