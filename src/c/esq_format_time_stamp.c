/* RESTORES: ESQ_FormatTimeStamp
 * MODULE:   modules/groups/_main/a/esq.s
 * STATUS:   behavioural
 *
 * 142 bytes in the original, 212 emitted -- a 50% overshoot, and the worst ratio
 * of any restoration in this directory. The cause is a codegen idiom SAS/C
 * simply does not produce.
 *
 * SASC-MISMATCH: no-predecrement-store
 *   ref:     113c004d                  MOVE.B #'M',-(A0)          4 bytes
 *   got:     538a 14bc004d             SUBQ.L #1,A2 / MOVE.B #'M',(A2)   6 bytes
 *   summary: The original fills its output buffer BACKWARDS using predecrement
 *            addressing, which is the natural encoding for `*--p = c`. SAS/C
 *            never emits `-(An)` for a store: it decrements the pointer with a
 *            separate SUBQ and then stores through plain indirect. Two extra
 *            bytes per write, and this function performs eleven of them.
 *   tried:   `*--p = c`, `*(--p) = c`, pre-decrementing on a separate line, and
 *            a register-qualified pointer. All produce the SUBQ form.
 *   scope:   MEASURED, not estimated: exactly ONE function in the whole program
 *            uses this idiom three or more times -- this one. tools/coverage.py
 *            now screens for it and finds nothing else. So it is genuinely
 *            unreachable from C, but it is NOT a broad blocker the way A5-frame
 *            (304 functions) or cross-unit-call are, and an earlier commit
 *            message overstated it by listing it alongside them.
 *   retest:  a compiler that emits -(An) for a predecrement store closes ~22 of
 *            the 70 bytes here immediately.
 *
 * Given the density of that idiom plus the DIVS/SWAP pairs -- one divide yielding
 * both digits, where SAS/C issues two -- this function may well be hand-written
 * assembly rather than compiled C. Compare the note in AGENTS.md about
 * src/modules/submodules being library code: a restoration that overshoots by
 * half with no structural disagreement is a signal the original was not C.
 *
 * The reconstruction IS semantically faithful and is kept for that reason: the
 * backwards fill of "HH:MM:SS AM", the leading space when the hour has no tens
 * digit, and the sign test on the PM flag all reproduce. But it should not be
 * promoted, and the byte gap should not be chased.
 */
struct ClockRec {
    short pad0, pad1, pad2, pad3;   /* 0,2,4,6 */
    short hour;                     /* 8  */
    short minute;                   /* 10 */
    short second;                   /* 12 */
    short pad7, pad8;               /* 14,16 */
    short pmFlag;                   /* 18 */
};

void ESQ_FormatTimeStamp(char *buf, struct ClockRec *c)
{
    register char *p;
    register short v;

    p = buf + 11;
    *p = 0;
    *--p = 'M';

    if (c->pmFlag < 0)
        *--p = 'P';
    else
        *--p = 'A';

    *--p = ' ';

    v = c->second;
    *--p = v % 10 + '0';
    *--p = v / 10 + '0';
    *--p = ':';

    v = c->minute;
    *--p = v % 10 + '0';
    *--p = v / 10 + '0';
    *--p = ':';

    v = c->hour;
    *--p = v % 10 + '0';
    v = v / 10;
    if (v == 0)
        *--p = ' ';
    else
        *--p = v + '0';
}
