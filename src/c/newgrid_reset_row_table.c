/* RESTORES: NEWGRID_ResetRowTable
 * MODULE:   modules/groups/b/a/newgrid1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-order
 *   ref:     48e70110266f000c7e007004be806c1422075881178178372207e58142b31824528760e64cdf08804e75
 *   got:     48e701042a6f000c7e007004be806c14220758811b8178372207e58142b51824528760e64cdf20804e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct NewgridRowTable {
    char pad[36];
    long slot[4];
    char pad2[3];
    char order[4];
};
void NEWGRID_ResetRowTable(struct NewgridRowTable *t)
{
    long i;

    for (i = 0; i < 4; i++) {
        t->order[i] = (char)(i + 4);
        t->slot[i] = 0;
    }
}
