/* RESTORES: SCRIPT_AssertCtrlLine
 * MODULE:   modules/groups/b/a/script2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-push-order
 *   ref:     33fc0001000070bc30390000bf0422000041002033c10000bf04700030012f00610000d6584f4e75
 *   got:     2f0733fc0001000000003039000000003e000047002033c700000000700030072f0061000000584f2e1f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short SCRIPT_CtrlLineAssertedFlag;
extern unsigned short SCRIPT_SerialShadowWord;
extern void SCRIPT_WriteCtrlShadowToSerdat(unsigned short v);
void SCRIPT_AssertCtrlLine(void)
{
    unsigned short w;

    SCRIPT_CtrlLineAssertedFlag = 1;
    w = SCRIPT_SerialShadowWord | 32;
    SCRIPT_SerialShadowWord = w;
    SCRIPT_WriteCtrlShadowToSerdat(w);
}
