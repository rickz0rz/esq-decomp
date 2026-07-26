/* RESTORES: DATETIME_BuildFromGlobals
 * MODULE:   modules/groups/a/j/disptext2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-push-order
 *   ref:     48e70110266f000c303900009ab048c02f00487800362f0b487900009aa26100ff764fef00102e0020074cdf08804e75
 *   got:     48e701042a6f000c30390000000048c02f00487800362f0d487900000000610000002e004fef001020074cdf20804e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short DST_PrimaryCountdown;
extern char  CLOCK_DaySlotIndex[];
extern long  DATETIME_BuildFromBaseDay(char *base, void *out, long span, long days);
long DATETIME_BuildFromGlobals(void *out)
{
    long r = DATETIME_BuildFromBaseDay(CLOCK_DaySlotIndex, out, 54,
                                       (long)DST_PrimaryCountdown);
    return r;
}
