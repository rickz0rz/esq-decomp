/* RESTORES: _DATETIME_ParseString
 * MODULE:   modules/groups/a/j/disptext2_p2_datetime_parsestring.s
 * STATUS:   behavioural
 *
 * Parse a fixed-layout date/time out of a string, starting at the first
 * occurrence of a caller-supplied delimiter, and fill the date/time struct.
 * Returns 1 on success and 0 on any failure, and ON FAILURE CLEARS THE STRUCT --
 * which is why the 22-byte clear appears twice, once on entry and once on the
 * failure path.
 *
 * The layout is positional, counted from the delimiter: +1 gives seven digits of
 * packed year-and-day-of-year, +8 the hour, +11 the minute. The packed field is
 * split by 1000, so 1995123 means day 123 of 1995.
 *
 * Validation is strict and every check rejects outright:
 *   - the year must be within 1 of CLOCK_CacheYear, in either direction
 *   - day-of-year must be greater than 1, so 0 and 1 are both refused
 *   - day-of-year must be below 366, or 367 in a leap year
 *   - hour 0..23, minute 0..59
 *
 * That day-of-year bound is one higher than a calendar year actually has. It is
 * reproduced as written rather than corrected -- the product here is evidence
 * about the original, not a tidier program.
 *
 * The year difference is recomputed in FULL in each branch rather than held in a
 * temporary: the original loads the field, sign-extends, loads CLOCK_CacheYear,
 * sign-extends and subtracts three separate times. Hoisting it into a variable
 * collapses those into one and loses the match.
 *
 * Seconds and the following word are zeroed from a single register, so they are
 * written as one chained assignment.
 *
 * The tail runs all three of NormalizeMonthRange, NormalizeStructToSeconds and
 * SecondsToStruct in sequence -- normalising the struct, converting it to a
 * seconds count, and converting that straight back. The round trip is how the
 * day-of-year is turned into a month and day.
 *
 * A NULL STRUCT POINTER IS DEREFERENCED, and that is the original's behaviour, not
 * a transcription slip. The entry test `MOVE.L A3,D0 / BEQ .parse_fail` branches
 * to the failure tail on a null pointer -- and the failure tail clears 22 bytes
 * through that same null pointer. So the original writes to address 0. The C
 * reproduces it, because the project's product is evidence about the original
 * rather than a corrected program; a caller passing NULL was already broken.
 *
 * 372 bytes against 362, and NO SHORTINT even though SHORTINT is smaller (344,
 * i.e. -18 against +10). The size-independent check settles it: the original
 * sign-extends nine times, and this build emits exactly 9 EXT.L against SHORTINT's
 * 4. The original genuinely does its comparisons long-wide after widening the
 * short fields, and 16-bit ints throw half of that away. Third file where the
 * smaller byte delta was the wrong answer -- see cleanup_draw_inset_rect_frame.c
 * and datetime_normalize_struct_to_seconds.c.
 *
 * SASC-MISMATCH: divide-helper-and-frame
 *   summary: +10. The two divisions by 1000 are 4EBA calls to MATH_DivS32 in the
 *            original and 6100 calls to SAS/C's helper here -- same size, no cost.
 *            The residual is the A5 frame class plus one fewer CMP.L (2 against
 *            the reference's 3), the third comparison being folded into a
 *            different form.
 *   tried:   SHORTINT (344, rejected on the EXT.L evidence above).
 *   scope:   whole-program frame and call-encoding classes.
 *   retest:  a compiler that reserves A5 and emits JSR (d16,PC) for externs.
 */

#include <string.h>

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

extern short CLOCK_CacheYear;

extern char *GROUP_AI_JMPTBL_STR_FindCharPtr(char *s, long ch);
extern void  GROUP_AG_JMPTBL_STRING_CopyPadNul(char *dst, char *src, long n);
extern long  GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(char *s);
extern long  DATETIME_IsLeapYear(long year);
extern void  DATETIME_NormalizeMonthRange(struct EsqDateTime *dt);
extern long  DATETIME_NormalizeStructToSeconds(struct EsqDateTime *dt);
extern struct EsqDateTime *DATETIME_SecondsToStruct(long secs, struct EsqDateTime *dt);

long DATETIME_ParseString(struct EsqDateTime *dt, char *text, char delim)
{
    char digits[8];
    char *at;
    long ok = 0;
    long packed, diff, limit, v;

    at = GROUP_AI_JMPTBL_STR_FindCharPtr(text, (long)delim);
    if (at && dt) {
        memset(dt, 0, 22);

        GROUP_AG_JMPTBL_STRING_CopyPadNul(digits, at + 1, 7L);
        digits[7] = 0;
        packed = GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(digits);

        dt->year      = packed / 1000;
        dt->dayOfYear = packed % 1000;

        if (dt->year - CLOCK_CacheYear >= 0)
            diff = dt->year - CLOCK_CacheYear;
        else
            diff = -(dt->year - CLOCK_CacheYear);

        if (diff <= 1 && dt->dayOfYear > 1) {
            limit = DATETIME_IsLeapYear(dt->year) ? 1 : 0;
            limit += 366;
            if (dt->dayOfYear < limit) {
                v = GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(at + 8);
                dt->hour = v;
                if (dt->hour >= 0 && dt->hour < 24) {
                    v = GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(at + 11);
                    dt->minute = v;
                    if (dt->minute >= 0 && dt->minute < 60) {
                        dt->second = dt->pad14 = 0;
                        DATETIME_NormalizeMonthRange(dt);
                        DATETIME_SecondsToStruct(
                            DATETIME_NormalizeStructToSeconds(dt), dt);
                        ok = 1;
                    }
                }
            }
        }
    }

    if (!ok)
        memset(dt, 0, 22);
    return ok;
}
