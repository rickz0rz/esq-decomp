/* RESTORES: LADFUNC_GetPackedPenLowNibble
 * MODULE:   modules/groups/a/w/ladfuncb.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: trailing-dead-bytes
 *   ref:     2f071e2f000b20070200000f2e1f4e754a000000
 *   got:     2f071e2f000b70001007720fc0812e1f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
long LADFUNC_GetPackedPenLowNibble(unsigned char packed)
{
    return (long)packed & 15;
}
