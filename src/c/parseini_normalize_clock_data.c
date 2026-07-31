/* RESTORES: PARSEINI_NormalizeClockData
 * MODULE:   modules/groups/b/a/parseini2_p1.s
 * STATUS:   behavioural
 *
 * Copies a clock record and normalizes it: two-digit years become four-digit,
 * the month is folded into 1..12, the leap-year flag is set, and the day of
 * year is recomputed.
 *
 * The copy is a 22-byte STRUCT ASSIGNMENT (MOVEQ #4 / MOVE.L (A0)+,(A1)+ / DBF
 * plus a trailing MOVE.W), the same record layout
 * newgrid_compute_day_slot_from_clock.c uses.
 *
 * Argument order is destination FIRST, source second -- A3 comes from the lower
 * stack slot and is the copy's target. esqdisp_normalize_clock_and_redraw_banner.c
 * calls it that way round.
 *
 * Three details taken from the branches rather than assumed:
 *
 *  - THE FIELD AT +8 IS THE HOUR, NOT THE MONTH, and the block around it is a
 *    24-to-12-hour conversion. An earlier version of this file named it `month`
 *    on the strength of the constant 12 alone, which fits both readings. The
 *    layout is settled by parseini_update_clock_from_rtc.c, which BUILDS this
 *    record field by field from a ClockData: weekday at +0, month at +2, mday
 *    at +4, year at +6, hour at +8, minute at +10, second at +12. The +6 field
 *    taking +1900 confirms the year and pins the rest.
 *  - So the flag at +18 records that the hour was PM: it is -1 when the hour is
 *    12 or more, and BOTH arms continue into the fold.
 *  - An hour of 0 becomes 12, and only then is an hour greater than 12 reduced
 *    by 12. Doing those in the other order would turn 0 into 12 and leave it.
 *  - The MDAY at +4 is incremented UNCONDITIONALLY. The BLE at 0x28E52 skips
 *    only the SUB.W and lands on the ADDQ.W, so the increment is not part of
 *    the hour wrap -- it is the date rolling forward.
 *
 * The leap-year helper returns a word (TST.W D0), and the flag it sets at +20
 * is -1 or 0 rather than 1 or 0.
 *
 * 138 ref vs 136 got. The struct copy is VERBATIM (7004 22d8 51c8fffc), and so
 * are the CMPI.W #1900 test, the ADDI.W #1900, the MOVEQ #12 comparisons, the
 * zero-month fix, the SUB.W wrap, the unconditional ADDQ.W #1 on the day, the
 * EXT.L before the leap-year call and both -1 flag stores.
 *
 * SASC-MISMATCH: a3-vs-a5-register-allocation
 *   ref:     48e72030 266f0010 246f0014 302b0006 ...   A2/A3
 *   got:     48e70014 266f0010 2a6f000c 302d0006 ...   A3/A5
 *   summary: the destination record lands in A5 rather than A3. Same
 *            instructions, same sizes, one register apart throughout.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause".
 *   retest:  a compiler that reserves A5; the same doc gives the probe.
 *
 * SASC-MISMATCH: case-body-layout
 *   ref:     7400 37420012 6006 377cffff0012
 *            zero arm first, via a register, then the -1 arm
 *   got:     3b7cffff0012 6004 426d0012
 *            -1 arm first, then CLR.W for the zero arm
 *   summary: 6.51 emits the two arms of the month-range flag in the opposite
 *            order and uses CLR.W where the original stores a zeroed register.
 *            Same two values into the same field; 2 bytes cheaper.
 *   scope:   program-wide. docs/compiler-version.md, "Parameter and case
 *            layout".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct ParseIniClockData {
    short weekday;              /* +0  */
    short month;                /* +2  */
    short mday;                 /* +4  */
    short year;                 /* +6  */
    short hour;                 /* +8  */
    short minute;               /* +10 */
    short second;               /* +12 */
    short countdown;            /* +14 */
    short f16;
    short hourWasPm;            /* +18 */
    short leapYear;             /* +20 */
};

extern short PARSEINI2_JMPTBL_DATETIME_IsLeapYear(long year);
extern void  PARSEINI2_JMPTBL_ESQ_CalcDayOfYearFromMonthDay(
    struct ParseIniClockData *c);

void PARSEINI_NormalizeClockData(struct ParseIniClockData *dst,
                                 struct ParseIniClockData *src)
{
    *dst = *src;

    if (dst->year < 1900)
        dst->year += 1900;

    if (dst->hour >= 12)
        dst->hourWasPm = -1;
    else
        dst->hourWasPm = 0;

    if (dst->hour == 0)
        dst->hour = 12;

    if (dst->hour > 12)
        dst->hour -= 12;

    dst->mday++;

    if (PARSEINI2_JMPTBL_DATETIME_IsLeapYear((long)dst->year))
        dst->leapYear = -1;
    else
        dst->leapYear = 0;

    PARSEINI2_JMPTBL_ESQ_CalcDayOfYearFromMonthDay(dst);
}
