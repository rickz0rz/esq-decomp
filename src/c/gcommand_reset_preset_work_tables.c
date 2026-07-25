/* RESTORES: GCOMMAND_ResetPresetWorkTables
 * MODULE:   modules/groups/a/u/gcommand3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: stack-local-pointer
 *   ref:     4e55fff82f077e002b7c0000b26cfff87004be806c2620075880206dfff82080700021400004214000082140000c2140001052877018d1adfff860d44279000068a82e1f4e5d4e75
 *   got:     48e701044bf9000000007e007004be806c1e200758802a8042ad000442ad000842ad000c42ad0010dafc0018528760dc4279000000004cdf20804e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct PresetWorkEntry { long id; long a; long b; long c; long d; long e; };
extern struct PresetWorkEntry GCOMMAND_PresetWorkEntryTable[];
extern short GCOMMAND_PresetWorkResetPendingFlag;
void GCOMMAND_ResetPresetWorkTables(void)
{
    struct PresetWorkEntry *p = GCOMMAND_PresetWorkEntryTable;
    long i;

    for (i = 0; i < 4; i++) {
        p->id = i + 4;
        p->a = 0;
        p->b = 0;
        p->c = 0;
        p->d = 0;
        p = (struct PresetWorkEntry *)((char *)p + 24);
    }
    GCOMMAND_PresetWorkResetPendingFlag = 0;
}
