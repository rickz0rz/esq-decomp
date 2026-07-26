/* RESTORES: SCRIPT_DeassertCtrlLine
 * MODULE:   modules/groups/b/a/script2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-push-order
 *   ref:     4279000070bc30390000bf0422000241ffdf33c10000bf04700030012f00610000a4584f4e75
 *   got:     2f07427900000000700030390000000002800000ffdf2e0033c700000000700030072f0061000000584f2e1f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short SCRIPT_CtrlLineAssertedFlag;
extern unsigned short SCRIPT_SerialShadowWord;
extern void SCRIPT_WriteCtrlShadowToSerdat(unsigned short v);
void SCRIPT_DeassertCtrlLine(void)
{
    unsigned short w;

    SCRIPT_CtrlLineAssertedFlag = 0;
    w = SCRIPT_SerialShadowWord & 0xffdf;
    SCRIPT_SerialShadowWord = w;
    SCRIPT_WriteCtrlShadowToSerdat(w);
}
