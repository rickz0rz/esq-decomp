/* RESTORES: ESQ_SetCopperEffect_Custom
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-argument-convention
 *   ref:     227c00bfd000121108c1000608c100071281103c003f1239000000f661684e75
 *   got:     610000004e75
 *   summary: The original takes its arguments in REGISTERS rather than on the stack, so it is callable only from assembly. Documented, not linkable.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short ESQPARS2_BannerColorStepCounter;
extern void  ESQ_SetCopperEffectParams(void);
/* Register-argument function: the two effect bytes arrive in D0/D1. */
void ESQ_SetCopperEffect_Custom(void)
{
    ESQ_SetCopperEffectParams();
}
