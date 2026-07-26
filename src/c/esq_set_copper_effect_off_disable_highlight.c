/* RESTORES: ESQ_SetCopperEffect_OffDisableHighlight
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-argument-convention
 *   ref:     227c00bfd00012110881000608c100071281103c0000123c0000612c4eb90001ba164e75
 *   got:     700010390000000072404601c0810040008013c00000000061000000610000004e75
 *   summary: Part of the original's behaviour lives in registers set by the caller or left for the callee (D0/D1), which C cannot express. Documented, not linkable.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
/* Register-argument tail: the effect bytes are set in D0/D1 before the call. */
extern volatile unsigned char CIAB_PRA;
extern void ESQ_SetCopperEffectParams(void);
extern void GCOMMAND_DisableHighlight(void);
void ESQ_SetCopperEffect_OffDisableHighlight(void)
{
    CIAB_PRA = (CIAB_PRA & 0xbf) | 0x80;
    ESQ_SetCopperEffectParams();
    GCOMMAND_DisableHighlight();
}
