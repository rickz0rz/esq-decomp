/* RESTORES: TEXTDISP_GetGroupEntryCount
 * MODULE:   modules/groups/b/a/textdisp.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: branch-shape
 *   ref:     48e703002e2f000c2007538067065380670a60103c39000087bc600a3c39000087b860027c0020064cdf00c04e75
 *   got:     48e703002e2f000c2007538067065380670c60143c390000000048c6600c3c390000000048c660027c0020064cdf00c04e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short TEXTDISP_PrimaryGroupEntryCount;
extern short TEXTDISP_SecondaryGroupEntryCount;
long TEXTDISP_GetGroupEntryCount(long which)
{
    long n;

    switch (which) {
    case 1:  n = TEXTDISP_PrimaryGroupEntryCount;   break;
    case 2:  n = TEXTDISP_SecondaryGroupEntryCount; break;
    default: n = 0;                                 break;
    }
    return n;
}
