/* RESTORES: ESQ_AdjustBracketedHourInString
 * MODULE:   modules/groups/a/a/app2_p7.s  (with ESQ_AdvanceBannerCharIndex)
 * STATUS:   behavioural
 *
 * Rewrites every `[hh...]` group in a string in place: the square brackets
 * become round ones, and the two-character hour just inside the opening bracket
 * is shifted by `delta` and re-emitted in 12-hour form. It edits the caller's
 * buffer and returns nothing.
 *
 * IT REWRITES THE BRACKETS EVEN WHEN delta IS ZERO. The zero test happens AFTER
 * `[` has already been replaced by `(`, and it skips only the hour arithmetic,
 * so a zero delta is still a bracket-style conversion pass.
 *
 * THE HOUR IS TWO CHARACTERS AND THE TENS MAY BE A SPACE. A leading space means
 * the hour is 1..9; anything else means the tens digit is 1 and ten is added.
 * The tens character is never parsed as a digit -- the original only tests it
 * against ' ' -- so `[27]` reads as 17, not 27.
 *
 * THE WRAP IS ASYMMETRIC, AND THIS IS NOT A TRANSCRIPTION SLIP. Going high the
 * original LOOPS (`CMP.B / BLE / SUB.B #12 / BRA`), so any hour above 12 comes
 * back into range. Going low it adds 12 exactly ONCE and falls straight to the
 * emit, so a delta below -11 leaves a zero or negative hour and prints a
 * non-digit. Both behaviours are reproduced.
 *
 * ALL THE HOUR ARITHMETIC IS SIGNED BYTE arithmetic -- `ADD.B`, `SUBI.B`,
 * `CMPI.B #1` with `BGE`. `signed char` is what makes the negative branch above
 * reachable at all; on `int` the `< 1` test would behave the same but the
 * overflow at 127 would not.
 *
 * THE TWO HOUR CHARACTERS ARE WRITTEN BACKWARDS from a cursor that starts just
 * past them, so the units digit is stored first. See the mismatch below.
 *
 * SASC-MISMATCH: predecrement-store
 *   ref:     1300  1302              MOVE.B D0,-(A1) / MOVE.B D2,-(A1)
 *   got:     SUBQ.L #1,A1 / MOVE.B D0,(A1)   twice
 *   summary: SAS/C NEVER emits `-(An)` as a store destination, so each of the
 *            two writes costs 2 extra bytes. AGENTS.md screens this shape as
 *            `predecrement-store` and records that it finds exactly ONE function
 *            program-wide with it. This is that function. It is unreachable from
 *            C rather than merely encoded differently, which is why the file is
 *            behavioural and cannot become exact under any option set.
 *   tried:   `*--p = c`, `p--; *p = c`, and a pointer decremented in a separate
 *            statement all emit the same SUBQ-then-store pair.
 *   scope:   two sites, both in this function, 4 bytes.
 *   retest:  a compiler that selects the predecrement addressing mode for a
 *            store. Neither 6.51 nor 6.00 does.
 *
 * SASC-MISMATCH: constant-hoisting
 *   ref:     the scan character, 10, 12 and 32 are held in D3/D1/D2 across the
 *            loop and reloaded only when they change
 *   got:     6.51 re-materialises each constant at its use
 *   summary: same values, same order of tests.
 *   scope:   program-wide.
 *   retest:  re-run tools/mismatches.py --recheck against another SAS/C.
 */

void ESQ_AdjustBracketedHourInString(char *s, long delta)
{
    register char *p = s;
    char *q;
    signed char hour;
    char tens;
    char c;

    for (;;) {
        /* Find the opening bracket. */
        for (;;) {
            c = *p++;
            if (c == 0)
                return;
            if (c == '[')
                break;
        }
        p--;
        *p++ = '(';

        /* A zero delta still converts the brackets, and only that. */
        if ((signed char)delta != 0) {
            hour = 0;
            if (*p++ != ' ')
                hour = 10;              /* the tens char is tested, not parsed */

            hour = (signed char)(hour + (*p++ - '0'));
            hour = (signed char)(hour + (signed char)delta);

            if (hour < 1) {
                hour = (signed char)(hour + 12);   /* once only -- see above */
            } else {
                while (hour > 12)
                    hour = (signed char)(hour - 12);
            }

            tens = ' ';
            if (hour >= 10) {
                hour = (signed char)(hour - 10);
                tens = '1';
            }
            hour = (signed char)(hour + '0');

            /* Written backwards from just past the two hour characters. */
            q = p;
            *--q = (char)hour;
            *--q = tens;
        }

        /* Find the closing bracket and convert it, then look for the next group. */
        for (;;) {
            c = *p++;
            if (c == 0)
                return;
            if (c == ']')
                break;
        }
        p--;
        *p++ = ')';
    }
}
