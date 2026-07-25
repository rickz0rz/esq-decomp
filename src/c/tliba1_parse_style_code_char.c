/* RESTORES: TLIBA1_ParseStyleCodeChar
 * MODULE:   modules/groups/b/a/tliba1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: return-value-width
 *   ref:     2f071e2f000b7058be0066047eff60147031be0065067037be0063047e0060040407003020072e1f4e75
 *   got:     48e703001e2f000f7058be0066047cff601a7031be0065067037be0063047c00600a700010072c0072309c8120064cdf00c04e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md for the known divergence classes.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
long TLIBA1_ParseStyleCodeChar(unsigned char c)
{
    long r;
    if (c == 88)
        r = -1;
    else if (c < 49 || c > 55)
        r = 0;
    else
        r = c - 0x30;
    return r;
}
