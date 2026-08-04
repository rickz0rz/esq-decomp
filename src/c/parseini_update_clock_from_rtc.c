/* RESTORES: PARSEINI_UpdateClockFromRtc
 * MODULE:   modules/groups/b/a/parseini2.s
 * STATUS:   behavioural
 *
 * Reads the battery-backed clock, sanity-checks every field, and normalizes the
 * result into the global clock -- falling back to a fixed record if anything is
 * out of range.
 *
 * THIS FUNCTION PINS THE CLOCK RECORD LAYOUT, which is why it is worth reading
 * before the rest of the parseini clock family. It builds the record field by
 * field out of a ClockData, so the destination offsets are unambiguous: weekday
 * at +0, month at +2, mday at +4, year at +6, hour at +8, minute at +10, second
 * at +12 and the DST countdown at +14. parseini_normalize_clock_data.c had two
 * of those named wrongly until this function settled them.
 *
 * The ClockData source has a DIFFERENT order -- second at +0, minute +2, hour
 * +4, mday +6, month +8, year +10, weekday +12 -- so the copy is a genuine
 * field-by-field reorder, not a block move.
 *
 * The month and mday are stored MINUS ONE, because the consumer indexes name
 * tables with them.
 *
 * All the range checks are UNSIGNED (BCS for the low end, BHI for the high),
 * and THE LOW-END ONES ARE DEAD: the original loads MOVEQ #0,D6 and then
 * compares each field against it with BCS, an unsigned "less than zero" that
 * can never be taken. Seven of them, and they are in the shipped binary.
 *
 * Reproducing them needs the zero-local trick AGENTS.md records: comparing
 * against a literal 0 lets SAS/C fold the test away, comparing against a local
 * holding 0 keeps it. Writing them as `>= zero` takes the function from 228
 * bytes to 254 against the original's 254 -- the whole 26-byte gap was those
 * seven dead compares and the MOVEQ that feeds them.
 *
 * AND ONE MORE DEAD COMPARE, of a different kind. The final seconds UPPER bound
 * at 0x28DA0 is `CMP.W D1,D0` with NO BRANCH AFTER IT -- the next instruction
 * is the PEA that sets up the success call. So the seconds are compared against
 * 59 and the answer is discarded: a seconds value above 59 is accepted. The C
 * below reproduces that by omitting the upper bound on seconds only. Writing
 * the symmetric check would reject inputs the shipped program accepts.
 *
 * The two together are worth stating plainly: of the sixteen comparisons this
 * function appears to make, EIGHT have no effect. Seven cannot fail and one is
 * not branched on.
 *
 * 254 ref vs 254 got, and the size agreement here is earned rather than
 * coincidental: it arrived only after the seven dead compares were restored,
 * and it went 228 -> 254 on that one change. Both PEA record addresses, the
 * MOVEQ bounds (6, 11, 31, 23, 59), the CMPI.W #9999 year bound, all seven
 * field copies with their two SUBQ.W adjustments, the countdown store and both
 * normalize calls match in kind and size.
 *
 * SASC-MISMATCH: frame-vs-stack-adjust
 *   ref:     4e55ffd8 ... 4e5d       LINK.W A5,#-40 / UNLK
 *   got:     9efc0024 ... defc0024   SUBA.W #36,A7 / ADDA.W #36,A7
 *   summary: the frame class. 6.51 takes 36 bytes where the original takes 40,
 *            because it needs no slot for the zero local -- it keeps that in a
 *            register, as the original does in D6.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
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
    short f16, f18, f20;
};

struct AmigaClockData {
    short second;               /* +0  */
    short minute;               /* +2  */
    short hour;                 /* +4  */
    short mday;                 /* +6  */
    short month;                /* +8  */
    short year;                 /* +10 */
    short weekday;              /* +12 */
};

extern long BATTCLOCK_GetSecondsFromBatteryBackedClock(void);
extern void CLOCK_ConvertAmigaSecondsToClockData(
    long seconds, struct AmigaClockData *out);
extern long CLOCK_CheckDateOrSecondsFromEpoch(
    struct AmigaClockData *c);
extern void PARSEINI_NormalizeClockData(struct ParseIniClockData *dst,
                                        struct ParseIniClockData *src);

extern long  Global_REF_UTILITY_LIBRARY;
extern long  Global_REF_BATTCLOCK_RESOURCE;
extern short DST_PrimaryCountdown;
extern struct ParseIniClockData CLOCK_DaySlotIndex;
extern struct ParseIniClockData PARSEINI_FallbackClockDataRecord;

void PARSEINI_UpdateClockFromRtc(void)
{
    struct AmigaClockData    cd;
    struct ParseIniClockData rec;
    long seconds;
    unsigned short zero;

    if (Global_REF_UTILITY_LIBRARY == 0)
        return;
    if (Global_REF_BATTCLOCK_RESOURCE == 0)
        return;

    seconds = BATTCLOCK_GetSecondsFromBatteryBackedClock();
    CLOCK_ConvertAmigaSecondsToClockData(seconds, &cd);

    if (CLOCK_CheckDateOrSecondsFromEpoch(&cd)) {

        rec.weekday   = cd.weekday;
        rec.month     = cd.month - 1;
        rec.mday      = cd.mday - 1;
        rec.year      = cd.year;
        rec.hour      = cd.hour;
        rec.minute    = cd.minute;
        rec.second    = cd.second;
        rec.countdown = DST_PrimaryCountdown;

        zero = 0;

        if ((unsigned short)cd.weekday >= zero
            && (unsigned short)cd.weekday <= 6
            && (unsigned short)cd.month >= zero
            && (unsigned short)cd.month <= 11
            && (unsigned short)cd.mday >= zero
            && (unsigned short)cd.mday <= 31
            && (unsigned short)cd.year >= zero
            && (unsigned short)cd.year <= 9999
            && (unsigned short)cd.hour >= zero
            && (unsigned short)cd.hour <= 23
            && (unsigned short)rec.minute >= zero
            && (unsigned short)rec.minute <= 59
            && (unsigned short)rec.second >= zero) {

            PARSEINI_NormalizeClockData(&CLOCK_DaySlotIndex, &rec);
            return;
        }
    }

    PARSEINI_NormalizeClockData(&CLOCK_DaySlotIndex,
                                &PARSEINI_FallbackClockDataRecord);
}
