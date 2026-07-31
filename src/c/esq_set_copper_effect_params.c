/* RESTORES: ESQ_SetCopperEffectParams
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 * DO-NOT-LINK: takes its arguments in REGISTERS, so the compiled C reads the
 *   stack and gets garbage. Proven: esq_dec_color_step.c linked alone over a
 *   clean 356-entry build paints a green panel over the grid area, and
 *   ESQ_SetCopperEffect_Custom compiles to 610000004e75 -- a call and a
 *   return, doing none of the work. Kept for the analysis, never linked.
 *
 * SASC-MISMATCH: register-argument-convention
 *   ref:     13c0000000ea13c1000000eb33fc0005000000e861024e75
 *   got:     48e703001c2f00131e2f000f13c70000000013c60000000033fc000500000000610000004cdf00c04e75
 *   summary: The original takes its arguments in REGISTERS rather than on the stack, so it is callable only from assembly. Documented, not linkable.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
/* Register-argument function: the two effect bytes arrive in D0 and D1. */
extern unsigned char HIGHLIGHT_CopperEffectParamA, HIGHLIGHT_CopperEffectParamB;
extern short HIGHLIGHT_CopperEffectSeed;
extern void  ESQ_UpdateCopperListsFromParams(void);
void ESQ_SetCopperEffectParams(unsigned char a, unsigned char b)
{
    HIGHLIGHT_CopperEffectParamA = a;
    HIGHLIGHT_CopperEffectParamB = b;
    HIGHLIGHT_CopperEffectSeed = 5;
    ESQ_UpdateCopperListsFromParams();
}
