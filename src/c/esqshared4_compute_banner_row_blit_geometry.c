/* RESTORES: ESQSHARED4_ComputeBannerRowBlitGeometry
 * MODULE:   modules/groups/a/q/esqshared4.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: global-store-order
 *   ref:     203900005f1ac0fc005823c000005f027000303900005f1ee64823c000005f0606800000005823c000005f12303900005f20ea48534033c000005f00303c0022e248534033c000005f224e75
 *   got:     48e703002039000000002200e5819280e5819280e78123c10000000030390000000072003200e6812e0123c70000000020077258d08123c000000000303900000000ea483c00534633c60000000033fc0010000000004cdf00c04e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern long  ESQPARS2_BannerRowCount, ESQPARS2_BannerRowCopySpanBytes;
extern short ESQPARS2_BannerRowWidthBytes;
extern long  ESQPARS2_BannerRowCopyStrideBytes, ESQSHARED_BlitAddressOffset;
extern short ESQPARS2_BannerCopyBlockSpanBytes, ESQPARS2_BannerRowCopyWordCount;
extern short ESQPARS2_BannerCopyBlockWordLimit;

void ESQSHARED4_ComputeBannerRowBlitGeometry(void)
{
    long  span;
    short words;

    ESQPARS2_BannerRowCopySpanBytes = ESQPARS2_BannerRowCount * 0x58;
    span = (unsigned short)ESQPARS2_BannerRowWidthBytes >> 3;
    ESQPARS2_BannerRowCopyStrideBytes = span;
    ESQSHARED_BlitAddressOffset = span + 0x58;
    words = ((unsigned short)ESQPARS2_BannerCopyBlockSpanBytes >> 5) - 1;
    ESQPARS2_BannerRowCopyWordCount = words;
    ESQPARS2_BannerCopyBlockWordLimit = (0x22 >> 1) - 1;
}
