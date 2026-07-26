/* RESTORES: LADFUNC2_EmitEscapedStringToScratch
 * MODULE:   modules/groups/a/x/ladfunc2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-order
 *   ref:     2f0b266f0008200b67144a136710101b720012002f016100000a584f60ec265f4e75
 *   got:     2f0d2a6f0008200d67144a156710101d720012002f0161000000584f60ec2a5f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern void LADFUNC2_EmitEscapedCharToScratch(long c);
void LADFUNC2_EmitEscapedStringToScratch(char *s)
{
    if (s == 0)
        return;
    while (*s != 0)
        LADFUNC2_EmitEscapedCharToScratch((long)(unsigned char)*s++);
}
