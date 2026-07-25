/* RESTORES: ESQ_SetBit1Based
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: word-shift-index
 *   ref:     206f0004202f0008720053801200028100000007e64803f000004e75
 *   got:     48e73f042e2f00242a6f002053872a077007ca802007e6482c00700030062205740003c2760016350800280388821b8408004cdf20fc4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
void ESQ_SetBit1Based(unsigned char *base, long bit)
{
    unsigned short byteIndex;
    long bitIndex;

    bit--;
    bitIndex = bit & 7;
    byteIndex = (unsigned short)bit >> 3;
    base[byteIndex] |= 1 << bitIndex;
}
