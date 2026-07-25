/* RESTORES: NEWGRID_TestModeFlagActive
 * MODULE:   modules/groups/b/a/newgrid1b.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: branch-shape
 *   ref:     2f072e2f00084a87660c1039000005fc7259b00167167001be80660c1039000005ff7259b00167047000600270012e1f4e75
 *   got:     48e703002e2f000c4a8766101039000000007259b00166047c0160182007538066101039000000007259b00166047c0160027c0020064cdf00c04e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md for the known divergence classes.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern unsigned char CONFIG_NewgridSelectionCode34PrimaryEnabledFlag;
extern unsigned char CONFIG_NewgridSelectionCode34AltEnabledFlag;
long NEWGRID_TestModeFlagActive(long mode)
{
    long r;
    if (mode == 0 && CONFIG_NewgridSelectionCode34PrimaryEnabledFlag == 89)
        r = 1;
    else if (mode == 1 && CONFIG_NewgridSelectionCode34AltEnabledFlag == 89)
        r = 1;
    else
        r = 0;
    return r;
}
