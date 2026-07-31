/* RESTORES: ESQ_UpdateMonthDayFromDayOfYear
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 * DO-NOT-LINK: takes its arguments in REGISTERS, so the compiled C reads the
 *   stack and gets garbage. Proven: esq_dec_color_step.c linked alone over a
 *   clean 356-entry build paints a green panel over the grid area, and
 *   ESQ_SetCopperEffect_Custom compiles to 610000004e75 -- a call and a
 *   return, doing none of the work. Kept for the analysis, never linked.
 *
 * SASC-MISMATCH: register-argument-convention
 *   ref:     2f0230280010740043f9000001344a680014670443e900183219b0416f069041524260f43142000231400004241f4e75
 *   got:     48e707142a6f00183e2d00107c0047f9000000004a6d00146704d6fc00183a1bbe456f069e45524660f43b4600023b4700044cdf28e04e75
 *   summary: The original takes its arguments in REGISTERS rather than on the stack, so it is callable only from assembly. No C function can express that convention; this restoration documents the logic but cannot be linked in.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
/* Register-argument function: the record pointer arrives in A0. */
extern short CLOCK_MonthLengths[];
struct ClockRec3 { char pad[2]; short month; short day; char pad2[10]; short dayOfYear; short pad3; short leap; };
void ESQ_UpdateMonthDayFromDayOfYear(struct ClockRec3 *c)
{
    short  remaining = c->dayOfYear;
    short  month = 0;
    short *tbl = CLOCK_MonthLengths;

    if (c->leap != 0)
        tbl += 12;
    for (;;) {
        short len = *tbl++;
        if (remaining <= len)
            break;
        remaining -= len;
        month++;
    }
    c->month = month;
    c->day = remaining;
}
