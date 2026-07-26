/* RESTORES: GCOMMAND_InitPresetDefaults
 * MODULE:   modules/groups/a/u/gcommand3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: external-call-width
 *   ref:     48790000aa4c618e584f4e75
 *   got:     48790000000061000000584f4e75
 *   summary: SAS/C 6.51 emits JSR (xxx).L (6 bytes) for a call to an external function where the original uses BSR.W (4 bytes), because with separate compilation the callee is not in the same section. That accounts for +2 bytes per call site. See docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern char GCOMMAND_DefaultPresetTable[];
extern void GCOMMAND_InitPresetTableFromPalette(char *table);
void GCOMMAND_InitPresetDefaults(void)
{
    GCOMMAND_InitPresetTableFromPalette(GCOMMAND_DefaultPresetTable);
}
