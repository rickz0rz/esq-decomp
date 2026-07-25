/* RESTORES: ESQ_SeedMinuteEventThresholds
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: scratch-register-locals
 *   ref:     202f0004222f0008743c944033c200000106741e944033c2000001047400d44133c20000010a741ed44133c2000001084e75
 *   got:     48e703003c2f00123e2f000e703c904733c000000000701e3200924733c10000000033c60000000030060640001e33c0000000004cdf00c04e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short CLOCK_MinuteTrigger60MinusBase;
extern short CLOCK_MinuteTrigger30MinusBase;
extern short CLOCK_MinuteTriggerBaseOffset;
extern short CLOCK_MinuteTriggerBaseOffsetPlus30;
void ESQ_SeedMinuteEventThresholds(short base, short offset)
{
    CLOCK_MinuteTrigger60MinusBase     = 60 - base;
    CLOCK_MinuteTrigger30MinusBase     = 30 - base;
    CLOCK_MinuteTriggerBaseOffset      = 0 + offset;
    CLOCK_MinuteTriggerBaseOffsetPlus30 = 30 + offset;
}
