/* RESTORES: GCOMMAND_DisableHighlight
 * MODULE:   modules/groups/a/u/gcommand3.s
 * STATUS:   exact
 *
 * SASC-MISMATCH: external-call-width
 *   ref:     42790000b2cc6100ff0e4e7548e70330266f0014246f00182f0b4879000068bc4eba36b04879000068c24eba36a64fef000c7e007010be806c5a2007d0803232080048c12f012f074879000068ce4eba36824fef000c7c002007d0803232080048c1bc816c2a2007ef80204ad1c02006d080d1c07000302800202f002f064879000068de4eba364c4fef000c528660c8528760a04879000068ec4eba3636584f4cdf0cc04e75
 *   got:     427900000000610000004e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short GCOMMAND_HighlightFlag;
extern void  GCOMMAND_ApplyHighlightFlag(void);
void GCOMMAND_DisableHighlight(void)
{
    GCOMMAND_HighlightFlag = 0;
    GCOMMAND_ApplyHighlightFlag();
}
