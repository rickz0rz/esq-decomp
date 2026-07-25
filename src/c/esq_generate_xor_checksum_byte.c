/* RESTORES: ESQ_GenerateXorChecksumByte
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: dbf-loop-and-early-return
 *   ref:     700010390000a07e4a39000086bc6626202f0004206f0008222f000c2f0224015342460072001218b30051cafffa0280000000ff241f4e75
 *   got:     48e70f042c2f00202e2f00182a6f001c7a001a39000000001039000000004a006704200560222a070a4500ff2006380053447000101db185200453444a4066f2200572004601c0814cdf20f04e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern unsigned char ESQIFF_RecordChecksumByte;
extern unsigned char ESQIFF_UseCachedChecksumFlag;
long ESQ_GenerateXorChecksumByte(long seed, unsigned char *data, long count)
{
    long sum;
    short n;

    sum = ESQIFF_RecordChecksumByte;
    if (ESQIFF_UseCachedChecksumFlag != 0)
        return sum;
    sum = seed ^ 0xFF;
    n = (short)count - 1;
    do {
        sum ^= *data++;
    } while (n--);
    return sum & 0xFF;
}
