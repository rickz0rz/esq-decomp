/* RESTORES: PARSEINI_WriteRtcFromGlobals
 * MODULE:   modules/groups/b/a/parseini2.s
 * STATUS:   behavioural
 *
 * Builds a clock record from the cached clock globals and writes it to the
 * battery-backed clock, provided both utility.library and the battclock
 * resource are open.
 *
 * The record is seven words and the field order is read off the STORE OFFSETS,
 * not the store sequence -- the original fills them out of order (-6 first,
 * then -10, -12, -8, -14, -16, -18). Laid out by address the record is
 * [f0, minute, hour, day, month, year, slot] from -18(A5) upward, and that is
 * the base passed to both clock helpers.
 *
 * The month is stored PLUS ONE, so the cached global is a 0-based month index
 * and the record wants 1-based.
 *
 * The hour goes through the 12-to-24-hour conversion with the AM/PM flag, and
 * both inputs are EXT.L-widened, so both cached globals are signed shorts.
 *
 * The write only happens if the epoch check returns non-zero; the seconds are
 * then computed from the SAME record and passed on.
 *
 * 154 ref vs 144 got. Both library guards, all seven field stores at their
 * offsets, the ADDQ.W #1 on the month, the two EXT.L widenings into the hour
 * conversion, the LEA 12(A7),A7 cleanup and both epoch calls match in kind and
 * size -- which is the confirmation that the record layout derived from the
 * store OFFSETS above is right.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ffec ... 3b40fffa ... 4e5d
 *            LINK.W A5,#-20 / stores at A5 offsets / UNLK
 *   got:     9efc0010 ... 3f400012 ... defc0010
 *            SUBA.W #16,A7 / stores at A7 offsets / ADDA.W
 *   summary: the frame class. 6.51 takes 16 bytes for the 14-byte record where
 *            the original reserves 20, which is the same over-allocation seen
 *            in esqpars_apply_rtc_bytes_and_persist.c -- the two functions
 *            build the same kind of record.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct ParseIniRtcRecord {
    short f0;                   /* +0  */
    short minute;               /* +2  */
    short hour;                 /* +4  */
    short day;                  /* +6  */
    short month;                /* +8  */
    short year;                 /* +10 */
    short slot;                 /* +12 */
};

extern short PARSEINI_AdjustHoursTo24HrFormat(long hour, long ampm);
extern long  CLOCK_CheckDateOrSecondsFromEpoch(
    struct ParseIniRtcRecord *r);
extern long  CLOCK_SecondsFromEpoch(
    struct ParseIniRtcRecord *r);
extern void  BATTCLOCK_WriteSecondsToBatteryBackedClock(
    long seconds);

extern long  Global_REF_UTILITY_LIBRARY;
extern long  Global_REF_BATTCLOCK_RESOURCE;
extern short Global_REF_CLOCKDATA_STRUCT;
extern short CLOCK_DaySlotIndex;
extern short CLOCK_CacheMonthIndex0;
extern short CLOCK_CacheDayIndex0;
extern short CLOCK_CacheYear;
extern short CLOCK_CacheHour;
extern short CLOCK_CacheAmPmFlag;
extern short CLOCK_CacheMinuteOrSecond;

void PARSEINI_WriteRtcFromGlobals(void)
{
    struct ParseIniRtcRecord rec;
    long seconds;

    if (Global_REF_UTILITY_LIBRARY == 0)
        return;
    if (Global_REF_BATTCLOCK_RESOURCE == 0)
        return;

    rec.slot   = CLOCK_DaySlotIndex;
    rec.month  = CLOCK_CacheMonthIndex0 + 1;
    rec.day    = CLOCK_CacheDayIndex0;
    rec.year   = CLOCK_CacheYear;
    rec.hour   = PARSEINI_AdjustHoursTo24HrFormat((long)CLOCK_CacheHour,
                                                  (long)CLOCK_CacheAmPmFlag);
    rec.minute = CLOCK_CacheMinuteOrSecond;
    rec.f0     = Global_REF_CLOCKDATA_STRUCT;

    if (CLOCK_CheckDateOrSecondsFromEpoch(&rec)) {
        seconds = CLOCK_SecondsFromEpoch(&rec);
        BATTCLOCK_WriteSecondsToBatteryBackedClock(seconds);
    }
}
