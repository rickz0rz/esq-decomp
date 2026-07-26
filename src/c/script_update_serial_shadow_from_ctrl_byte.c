/* RESTORES: SCRIPT_UpdateSerialShadowFromCtrlByte
 * MODULE:   modules/groups/b/a/script2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: byte-width-arithmetic
 *   ref:     2f071e2f000b7000100733c00000bf0602070003700030390000bf04727ed281c0818e007000100733c00000bf04720032002f0161000100584f2e1f4e75
 *   got:     48e703001e2f000f7000100733c0000000002c07020600037000303900000000727ed281c0818c007000100633c000000000720032002f0161000000584f4cdf00c04e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short SCRIPT_SerialInputLatch;
extern unsigned short SCRIPT_SerialShadowWord;
extern void SCRIPT_WriteCtrlShadowToSerdat(unsigned short v);
void SCRIPT_UpdateSerialShadowFromCtrlByte(unsigned char b)
{
    unsigned char v;

    SCRIPT_SerialInputLatch = (unsigned short)b;
    v = b & 3;
    v |= (unsigned char)(SCRIPT_SerialShadowWord & 252);
    SCRIPT_SerialShadowWord = (unsigned short)v;
    SCRIPT_WriteCtrlShadowToSerdat(SCRIPT_SerialShadowWord);
}
