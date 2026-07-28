/* RESTORES: _DATETIME_NormalizeStructToSeconds
 * MODULE:   modules/groups/a/j/disptext2_p0_datetime_normalizestructtoseconds.s
 * STATUS:   behavioural
 *
 * The inverse of datetime_seconds_to_struct.c: tidy up a partly-filled date/time
 * struct and return the seconds since the 1970 epoch, or -1 if the result is not
 * positive or the year is out of range.
 *
 * A two-digit year is accepted: anything below 1900 gets 1900 added first, so 95
 * becomes 1995. Only then is the range checked, and it is 1970..2038 -- the upper
 * bound is where a signed 32-bit seconds count runs out.
 *
 * Carries are propagated by ordinary divide-and-remainder up the chain, seconds
 * into minutes into hours, and then hours into BOTH day and day-of-year before
 * the hour itself is reduced. Both fields getting the same increment is
 * deliberate, not a duplicate.
 *
 * The leap correction counts leap years since 1968 -- the last leap year before
 * the epoch, hence 1968 and not 1970 -- and then subtracts one if the current year
 * is itself a leap year, because its own 29 February has not happened yet at the
 * point the day count is formed.
 *
 * 416 bytes against 388. THE DIVMOD IDIOM MATCHES EXACTLY: the original does the
 * carry propagation with the 68000's own 16-bit divide and a SWAP to recover the
 * remainder, and writing `dt->second / 60` and `dt->second % 60` on short fields
 * reproduces it -- 7 DIVS and 3 SWAP in both streams, verified by counting the
 * opcodes rather than by reading the byte total.
 *
 * NO SHORTINT, deliberately, and it costs 4 bytes (412 with, 416 without). Both
 * settings give the same 7 DIVS / 3 SWAP, so the option buys no fidelity on the
 * part that matters -- and it would NARROW the wider arithmetic: the original
 * computes (year - 1970) * 365 through the 32-bit Mulu32 helper, whereas with
 * 16-bit ints that multiply happens in a word. It stays in range for 1970..2038
 * so nothing observable changes, but matching the original's width is worth the
 * four bytes. Same reasoning as cleanup_draw_inset_rect_frame.c, where the
 * smaller number was also the wrong one.
 *
 * SASC-MISMATCH: multiply-strength-reduction
 *   summary: most of the +28. The original farms out both large constant
 *            multiplies -- (year-1970)*365 and (totalDays-1)*86400 -- to
 *            MATH_Mulu32, while SAS/C expands them inline. Same class as
 *            datetime_seconds_to_struct.c's blocks * 1461 and
 *            tliba3_init_runtime_entry.c's idx * 154.
 *   tried:   nothing source-side; a constant multiply is the compiler's choice.
 *   scope:   every constant multiply the original hands to a helper.
 *   retest:  a compiler that calls a helper for a constant multiply.
 */

struct EsqDateTime {
    short dayOfWeek;   /* +0  */
    short month;       /* +2  */
    short day;         /* +4  */
    short year;        /* +6  */
    short hour;        /* +8  */
    short minute;      /* +10 */
    short second;      /* +12 */
    short pad14;       /* +14 */
    short dayOfYear;   /* +16 */
    short pad18;       /* +18 */
    short isLeap;      /* +20 */
};

extern void DATETIME_AdjustMonthIndex(struct EsqDateTime *dt);
extern long DATETIME_IsLeapYear(long year);
extern void DATETIME_NormalizeMonthRange(struct EsqDateTime *dt);

long DATETIME_NormalizeStructToSeconds(struct EsqDateTime *dt)
{
    long daysInYear, leapDays, totalDays, secs;

    if (dt->year < 1900)
        dt->year += 1900;
    if (dt->year < 1970 || dt->year > 2038)
        return -1;

    DATETIME_AdjustMonthIndex(dt);

    dt->minute += dt->second / 60;
    dt->second  = dt->second % 60;
    dt->hour   += dt->minute / 60;
    dt->minute  = dt->minute % 60;

    dt->day       += dt->hour / 24;
    dt->dayOfYear += dt->hour / 24;
    dt->hour       = dt->hour % 24;

    daysInYear = DATETIME_IsLeapYear(dt->year) ? 366 : 365;
    while (dt->dayOfYear > daysInYear) {
        dt->dayOfYear -= daysInYear;
        dt->year++;
        daysInYear = DATETIME_IsLeapYear(dt->year) ? 366 : 365;
    }

    leapDays = (dt->year - 1968) / 4;
    if (DATETIME_IsLeapYear(dt->year))
        leapDays--;

    totalDays = (dt->year - 1970) * 365;
    totalDays += leapDays;
    totalDays += dt->dayOfYear;

    secs  = (totalDays - 1) * 86400L;
    secs += (long)dt->hour * 3600;
    secs += (long)dt->minute * 60;
    secs += dt->second;

    DATETIME_NormalizeMonthRange(dt);

    if (secs <= 0)
        return -1;
    return secs;
}
