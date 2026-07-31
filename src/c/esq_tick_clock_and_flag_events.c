/* RESTORES: _ESQ_TickClockAndFlagEvents
 * MODULE:   modules/groups/a/a/app2_p5.s
 * STATUS:   behavioural
 *
 * Advances the clock record by one second and answers an EVENT CODE naming the
 * largest boundary that was crossed. This is the function that drives ESQ's
 * timed display changes, so the codes are worth stating:
 *
 *   0  nothing -- the second did not reach 60
 *   1  a minute rolled over and hit none of the trigger values
 *   2  the half hour or the hour
 *   3  one of the two "30 minus base" / "60 minus base" triggers
 *   4  minute 20 or minute 50
 *   5  the configured base offset, or that offset plus 30
 *
 * The codes are NOT a priority order and the later ones do not override the
 * earlier: each arm returns as soon as it fires, so the ORDER of the tests is
 * the whole specification. Minute 30 is checked before the trigger values, so a
 * base offset configured to 30 reports 2 and never 5.
 *
 * The four trigger values are GLOBALS, not constants -- the operator configures
 * an offset and the program derives the other three from it. Only 20 and 50 are
 * literal.
 *
 * THE AM/PM FLAG IS A FULL-WORD TOGGLE, NOT A BIT. The original writes
 * `EORI.W #$ffff,18(A0)` and then branches on the SIGN of the result, so the
 * flag runs 0 and -1, and the day only advances on the -1 -> 0 edge. That is
 * once per 24 hours rather than once per 12. Writing the flag as a boolean and
 * testing it for truth advances the date at noon.
 *
 * The hour wraps 12 -> 1, not 12 -> 0: the equal case toggles the meridiem and
 * leaves the hour at 12, and only an hour ABOVE 12 is reset, to 1.
 *
 * The year length comes from the leap flag at +20 as 366 or 367, which is one
 * more than a reader expects in both cases, because the day of year is
 * ONE-BASED here -- the rollover sets it to 1, not 0.
 *
 * The new leap flag is `(year & 3) == 0`, the naive rule. The original has no
 * century correction, and adding one would be a fix rather than a restoration.
 *
 * ESQ_UpdateMonthDayFromDayOfYear TAKES ITS ARGUMENT IN A0. The original calls
 * it with `BSR.S` and no push at all, leaving the pointer live in the register
 * it was already using. The `MOVEA.L 4(A7),A0` that sits above that function's
 * label is marked "Unreachable Code?" in the disassembly and is not its
 * prologue. So the call needs an __asm register prototype, and its clobber list
 * checks out: it preserves D2 across its own body and touches only D0, D1 and
 * A1, all of which SAS/C already treats as scratch.
 *
 * A REGISTER-HELD CONSTANT IS SOMETIMES WORTH DECLARING AND SOMETIMES NOT, and
 * the two cases here point opposite ways. The original keeps four constants
 * live in registers across the whole body: 0 in D2, 1 in D1, 60 in D3 and later
 * 12 in D3. Writing them as ordinary literals gives 276 bytes. Declaring
 * `register short sixty = 60` and comparing against THAT gives 268, because the
 * three uses of 60 collapse from CMPI.W plus MOVEQ into one register compare
 * each. Declaring `register short one = 1` the same way gives 276 AGAIN -- 6.51
 * already emits ADDQ.W #1 for every increment, which is two bytes, and routing
 * those through a register costs more than it saves.
 *
 * So the rule is not "hold the original's constants in registers". It is: do
 * that only where the literal form emits an EXTRA instruction to materialise
 * the value. Measure both; the answer is not the same for two constants in one
 * function.
 *
 * The zero register is worth declaring for a different reason. It is size-
 * neutral at 268 either way, but with `zero = code = 0` and stores of `zero`,
 * 6.51 emits the original's shared-register stores and NO `CLR.W` at all; with
 * literals it emits two. AGENTS.md rule 1 -- prefer the candidate that contains
 * the original's instructions when the sizes tie -- picks the register form.
 *
 * 260 ref vs 268 got. The register constants, the SUB.W of 60 from the seconds
 * in place, all six trigger compares in the original order, the EORI.W #$ffff
 * meridiem toggle with its sign test, the weekday wrap at 7, the 366 year
 * length with its conditional increment, the ANDI.W #3 leap test with its
 * MOVEQ #0 / MOVE.W #$ffff pair and the register-argument BSR all match in kind
 * and size.
 *
 * SASC-MISMATCH: pointer-in-a5-vs-a0
 *   ref:     206f0004 ... 3028000c    the record pointer lives in A0
 *   got:     2a4d ... 302d000c        6.51 puts it in A5 and adds a MOVEA.L A5,A0
 *            before the register-argument call
 *   summary: the A5 class. 6.51 needs no frame here, so it uses A5 as an
 *            ordinary address register -- and then has to move the pointer into
 *            A0 for the one call that requires it there. The original was in A0
 *            all along. That MOVEA.L is 2 of the 8 bytes.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct EsqClock {
    short weekday;              /* +0  0..6, wraps at 7 */
    short month;                /* +2  written by UpdateMonthDayFromDayOfYear */
    short mday;                 /* +4  likewise */
    short year;                 /* +6  */
    short hour;                 /* +8  1..12 */
    short minute;               /* +10 */
    short second;               /* +12 */
    short pad14;
    short dayOfYear;            /* +16 one-based */
    short meridiem;             /* +18 0 or -1, toggled as a full word */
    short leapYear;             /* +20 0 or -1 */
};

extern void __asm ESQ_UpdateMonthDayFromDayOfYear(register __a0 struct EsqClock *t);

extern short CLOCK_MinuteTrigger30MinusBase;
extern short CLOCK_MinuteTrigger60MinusBase;
extern short CLOCK_MinuteTriggerBaseOffsetPlus30;
extern short CLOCK_MinuteTriggerBaseOffset;

short ESQ_TickClockAndFlagEvents(struct EsqClock *t)
{
    short code;
    short minute;
    short hour;
    register short limit;
    register short leap;
    register short sixty;
    register short zero;

    zero = code = 0;
    sixty = 60;

    if (t->second < sixty)
        return code;

    t->second -= sixty;
    code = 1;

    minute = t->minute + 1;
    t->minute = minute;

    if (minute == 30)
        return (short)2;

    if (minute < sixty) {
        if (minute == CLOCK_MinuteTriggerBaseOffset
            || minute == CLOCK_MinuteTriggerBaseOffsetPlus30)
            return (short)5;
        if (minute == 20 || minute == 50)
            return (short)4;
        if (minute == CLOCK_MinuteTrigger30MinusBase
            || minute == CLOCK_MinuteTrigger60MinusBase)
            return (short)3;
        return code;
    }

    t->minute = zero;
    code = 2;

    hour = t->hour + 1;
    t->hour = hour;

    if (hour < 12)
        return code;

    if (hour > 12) {
        t->hour = 1;
        return code;
    }

    t->meridiem ^= (short)0xffff;
    if (t->meridiem < 0)
        return code;

    t->weekday = t->weekday + 1;
    if (t->weekday == 7)
        t->weekday = zero;

    t->dayOfYear = t->dayOfYear + 1;

    limit = 366;
    if (t->leapYear != 0)
        limit++;

    if (t->dayOfYear >= limit) {
        t->year = t->year + 1;
        t->dayOfYear = 1;

        leap = 0;
        if ((t->year & 3) == 0)
            leap = -1;
        t->leapYear = leap;
    }

    ESQ_UpdateMonthDayFromDayOfYear(t);
    return code;
}
