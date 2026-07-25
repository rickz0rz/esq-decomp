/* RESTORES: TEXTDISP_SkipControlCodes
 * MODULE:   modules/groups/b/a/textdisp.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-order
 *   ref:     2f0b266f0008200b671e7028b0136602508b7000101341f900007c11d1c0081000036704528b60ea200b265f4e75
 *   got:     2f0d2a6f0008200d67207028b0156602508d10157200120041f900000000d0c1081000036704528d60e8200d2a5f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md for the known divergence classes.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern unsigned char WDISP_CharClassTable[];
char *TEXTDISP_SkipControlCodes(char *p)
{
    if (p != 0) {
        if (*p == 40)
            p += 8;
        while (WDISP_CharClassTable[(unsigned char)*p] & 8)
            p++;
    }
    return p;
}
