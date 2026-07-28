/* RESTORES: _DATETIME_SecondsToStruct
 * MODULE:   modules/groups/a/j/disptext2_datetime_secondstostruct.s
 * STATUS:   behavioural
 *
 * Convert a seconds count into ESQ's date/time struct, epoch 1 Jan 1970, and
 * return the struct pointer. Negative input is clamped to 0 rather than rejected.
 *
 * The year search is done in TWO STAGES, which is what the magic numbers are:
 *   35064 hours  (0x88f8) is exactly one four-year block, 1461 days
 *    1461 days   (0x5b5)  is that block's day count, used to seed the weekday
 *    8760 hours  (0x2238) is a common year, plus 24 when the year is a leap year
 * So it divides out whole four-year blocks first, then walks single years. The
 * weekday accumulator starts at that day total plus 4, which is the epoch's
 * weekday offset, and is reduced mod 7 with an UNSIGNED divide (the original
 * calls MATH_DivU32, not DivS32) -- hence `unsigned long`.
 *
 * LEAP DAY IS HANDLED BY SHIFTING THE DAY NUMBER, not by a second month table.
 * In a leap year, day-of-year 60 IS 29 February and is special-cased outright;
 * anything past 60 is decremented so the ordinary 28-day February table then
 * gives the right answer. That is why only one month-length table exists.
 *
 * `dt->year = q * 4;` and `dt->year += 1970;` are deliberately two statements --
 * the original stores the multiple and then adds the epoch in a separate
 * ADDI.W to the field, and folding them changes the emitted sequence.
 *
 * The month loop compares against the month LENGTH and subtracts the same byte,
 * reading `DATETIME_MONTH_LENGTH_AND_DAY_OFFSET_TABLES` twice at the same index.
 * The table's second half (twelve longs of cumulative day offsets) is not used
 * here at all.
 */

struct EsqDateTime {
    short dayOfWeek;   /* +0  */
    short month;       /* +2  0-based until NormalizeMonthRange runs */
    short day;         /* +4  */
    short year;        /* +6  */
    short hour;        /* +8  */
    short minute;      /* +10 */
    short second;      /* +12 */
    short pad14;       /* +14 */
    short dayOfYear;   /* +16 */
    short pad18;       /* +18 */
    short isLeap;      /* +20 -1 when leap, 0 otherwise */
};

extern unsigned char DATETIME_MONTH_LENGTH_AND_DAY_OFFSET_TABLES[];
extern long DATETIME_IsLeapYear(long year);
extern void DATETIME_NormalizeMonthRange(struct EsqDateTime *dt);

struct EsqDateTime *DATETIME_SecondsToStruct(long secs, struct EsqDateTime *dt)
{
    unsigned long days;
    long blocks, yearHours, doy;

    if (secs < 0)
        secs = 0;

    dt->second = secs % 60;
    secs /= 60;
    dt->minute = secs % 60;
    secs /= 60;                       /* secs is now whole HOURS */

    blocks = secs / 35064;            /* whole four-year blocks */
    dt->year = blocks * 4;
    dt->year += 1970;
    days = blocks * 1461;
    secs = secs % 35064;

    for (;;) {
        yearHours = 8760;
        if (DATETIME_IsLeapYear(dt->year))
            yearHours += 24;
        if (secs < yearHours)
            break;
        days += yearHours / 24;
        dt->year++;
        secs -= yearHours;
    }

    dt->hour = secs % 24;
    secs /= 24;                       /* day index within the year */

    days += secs + 4;                 /* +4 = the epoch's weekday offset */
    dt->dayOfWeek = days % 7;

    doy = secs + 1;
    dt->dayOfYear = doy;

    dt->isLeap = DATETIME_IsLeapYear(dt->year) ? -1 : 0;
    if (dt->isLeap == -1) {
        if (doy > 60) {
            doy--;
        } else if (doy == 60) {
            dt->month = 1;
            dt->day = 29;
            DATETIME_NormalizeMonthRange(dt);
            return dt;
        }
    }

    dt->month = 0;
    while (DATETIME_MONTH_LENGTH_AND_DAY_OFFSET_TABLES[dt->month] < doy) {
        doy -= DATETIME_MONTH_LENGTH_AND_DAY_OFFSET_TABLES[dt->month];
        dt->month++;
    }
    dt->day = doy;
    DATETIME_NormalizeMonthRange(dt);
    return dt;
}
