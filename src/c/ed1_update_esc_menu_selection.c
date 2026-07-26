/* RESTORES: ED1_UpdateEscMenuSelection
 * MODULE:   modules/groups/a/k/ed1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: branch-shape
 *   ref:     20390000b354e588d0b90000b35441f90000b358d1c0101013c0000081947200120004410031670a4eba1a9642790000a07c4e75
 *   got:     2f072039000000002200e581d28041f900000000d1c11e1013c7000000007000100704400031670a610000004279000000002e1f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern long ED_StateRingIndex;
extern char ED_StateRingTable[];
extern unsigned char ED_LastKeyCode;
extern short ED_DiagnosticsScreenActive;
extern void ED_DrawESCMenuBottomHelp(void);
void ED1_UpdateEscMenuSelection(void)
{
    unsigned char k = ED_StateRingTable[ED_StateRingIndex * 5];

    ED_LastKeyCode = k;
    if ((short)k - 0x31 == 0)
        return;
    ED_DrawESCMenuBottomHelp();
    ED_DiagnosticsScreenActive = 0;
}
