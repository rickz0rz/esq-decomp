/* RESTORES: ESQ_SetCopperEffect_Default
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-argument-convention
 *   ref:     103c0000123c003f6100008a4e75
 *   got:     610000004e75
 *   summary: The original passes its arguments in REGISTERS (D0/D1) rather than on the stack, so it is callable only from assembly. Documented, not linkable.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
/* Register-argument function: the effect parameters arrive in D0/D1. */
extern void ESQ_SetCopperEffectParams(void);
void ESQ_SetCopperEffect_Default(void)
{
    ESQ_SetCopperEffectParams();
}
