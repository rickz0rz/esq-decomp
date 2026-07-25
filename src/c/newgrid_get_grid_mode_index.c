/* RESTORES: _NEWGRID_GetGridModeIndex
 * MODULE:   modules/groups/b/a/newgrid1_getgridmodeindex.s
 * STATUS:   behavioural
 *
 * Returns the grid layout mode index: 1 when the mode selector is in state 1,
 * otherwise 6. Called from 8 sites in the grid rendering path, so a wrong
 * answer changes how the channel grid is laid out -- visible immediately.
 *
 * SASC-MISMATCH: assignment-sunk-into-branches
 *   ref:     2f07 7001 b0b9<abs> 6702 7006 2e00 2007 2e1f 4e75      (22 bytes)
 *   got:     2f07 7001 b0b9<abs> 6604 2e00 6002 7e06 2007 2e1f 4e75 (24 bytes)
 *   summary: The original computes the value in D0 and stores it once to the
 *            D7-allocated local (MOVEQ #6,D0 / MOVE.L D0,D7), reusing the D0=1
 *            left over from the comparison as the result on the equal path.
 *            SAS/C 6.51 instead sinks the assignment into both branches
 *            (MOVE.L D0,D7 / BRA / MOVEQ #6,D7), costing 2 bytes.
 *   tried:   options - default, OPTIMIZE, OPTIMIZE OPTSIZE, OPTIMIZE OPTTIME;
 *            sources - ternary, ternary as initialiser, if/else, inverted
 *            condition with pre-init, `register long`, two separate returns.
 *            The two-return form under OPTIMIZE yields the original's exact
 *            core (7001 b0b9<abs> 6702 7006 4e75) but drops the D7 round-trip
 *            entirely, so it is a different function shape, not a match.
 *   retest:  a compiler that keeps the D7 round-trip while hoisting the store
 *            out of the branches should match this source unchanged.
 */
extern long NEWGRID_ModeSelectorState;

long NEWGRID_GetGridModeIndex(void)
{
    long mode = (NEWGRID_ModeSelectorState == 1) ? 1 : 6;

    return mode;
}
