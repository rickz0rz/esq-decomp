/* RESTORES: ESQ_TestBit1Based
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: word-shift-index
 *   ref:     206f0004202f0008720053801200028100000007e6480330000056c0488048c04e75
 *   got:     48e737042e2f00202a6f001c53872a077007ca802007e6482c00700030062205740003c2760016350800c68256c04400488048c04cdf20ec4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
long ESQ_TestBit1Based(unsigned char *base, long bit)
{
    unsigned short byteIndex;
    long bitIndex;

    bit--;
    bitIndex = bit & 7;
    byteIndex = (unsigned short)bit >> 3;
    return (base[byteIndex] & (1 << bitIndex)) != 0;
}
