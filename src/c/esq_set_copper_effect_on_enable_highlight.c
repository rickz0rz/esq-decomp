/* RESTORES: ESQ_SetCopperEffect_OnEnableHighlight
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-argument-convention
 *   ref:     227c00bfd000121108c1000608c100071281103c003f123c000061084eb90001ba084e75
 *   got:     7000103900000000004000c013c00000000061000000610000004e75
 *   summary: Part of the original's behaviour lives in registers set by the caller or left for the callee (D0/D1), which C cannot express. Documented, not linkable.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
/* Register-argument tail: the effect bytes are set in D0/D1 before the call. */
extern volatile unsigned char CIAB_PRA;
extern void ESQ_SetCopperEffectParams(void);
extern void GCOMMAND_EnableHighlight(void);
void ESQ_SetCopperEffect_OnEnableHighlight(void)
{
    CIAB_PRA = CIAB_PRA | 0xc0;
    ESQ_SetCopperEffectParams();
    GCOMMAND_EnableHighlight();
}
