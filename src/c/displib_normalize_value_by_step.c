/* RESTORES: DISPLIB_NormalizeValueByStep
 * MODULE:   modules/groups/a/i/displib.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: return-value-width
 *   ref:     48e707003e2f00123c2f00163a2f001abe466c04de4560f8be456f049e4560f820074cdf00e04e75
 *   got:     48e707003a2f001a3c2f00163e2f0012be466c04de4560f8be456f049e4560f8300748c04cdf00e04e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md for the known divergence classes.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
long DISPLIB_NormalizeValueByStep(short value, short low, short step)
{
    while (value < low)
        value += step;
    while (value > step)
        value -= step;
    return value;
}
