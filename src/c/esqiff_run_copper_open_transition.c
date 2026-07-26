/* RESTORES: ESQIFF_RunCopperOpenTransition
 * MODULE:   unknown
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: external-call-width
 *   got:     33fc000f00000000610000004e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short COPPER_AnimationLane0_Countdown;
extern void  ESQIFF_RunPendingCopperAnimations(void);
void ESQIFF_RunCopperOpenTransition(void)
{
    COPPER_AnimationLane0_Countdown = 15;
    ESQIFF_RunPendingCopperAnimations();
}
