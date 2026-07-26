/* RESTORES: BEVEL_DrawBevelFrameWithTop
 * MODULE:   modules/groups/a/a/bevel.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-slot-reuse
 *   ref:     48e70f10266f00182e2f001c2c2f00202a2f0024282f00282f042f052f062f072f0b6100fd6c2e842f052f062f072f0b6100fe824fef00244cdf08f04e75
 *   got:     48e70f04282f00282a2f00242c2f00202e2f001c2a6f00182f042f052f062f072f0d610000002e842f052f062f072f0d610000004fef00244cdf20f04e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern void BEVEL_DrawVerticalBevelPair(void *rp, long a, long b, long c, long d);
extern void BEVEL_DrawHorizontalBevel(void *rp, long a, long b, long c, long d);
void BEVEL_DrawBevelFrameWithTop(void *rp, long a, long b, long c, long d)
{
    BEVEL_DrawVerticalBevelPair(rp, a, b, c, d);
    BEVEL_DrawHorizontalBevel(rp, a, b, c, d);
}
