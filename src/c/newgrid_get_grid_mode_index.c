/* NEWGRID_GetGridModeIndex -- replaces the function of the same name in
 * modules/groups/b/a/newgrid1.s (the module also contains other functions, so
 * the replacement is wired per-function via a trimmed assembly module).
 *
 * Returns the grid layout mode index: 1 when the mode selector is in state 1,
 * otherwise 6. Called from 8 sites in the grid rendering path, so a wrong
 * answer changes how the channel grid is laid out -- visible immediately.
 *
 * Byte-status: 24 bytes vs the original's 22. Same semantics and the same
 * addressing mode (absolute long, DATA=FAR), but SAS/C 6.51 sinks the
 * assignment into both branches, where the original computes the value in D0
 * and stores it to the D7-allocated local once. No source form or option
 * combination tried reproduces that. See docs/compiler-version.md.
 */
extern long NEWGRID_ModeSelectorState;

long NEWGRID_GetGridModeIndex(void)
{
    long mode = (NEWGRID_ModeSelectorState == 1) ? 1 : 6;

    return mode;
}
