/* RESTORES: _ESQ_MainExitNoOpHook
 * MODULE:   modules/submodules/unknown2b_esq_mainexitnoophook.s
 * STATUS:   exact
 *
 * A bare RTS in the original, reached through the `_main` jump table, so the
 * symbol must exist even though it does nothing.
 *
 * IT IS CALLED WITH ARGUMENTS ALREADY ON THE STACK, AND THAT IS FINE. The
 * caller in `modules/groups/_main/a/a.s` pushes the saved Workbench message and
 * the command buffer BEFORE the entry hook and leaves them there for
 * `ESQ_ParseCommandLineAndRun` to read. A `void` hook ignores the block exactly
 * as the original's RTS does. The two hook calls are NOT one function split in
 * half.
 */

void ESQ_MainExitNoOpHook(void)
{
}
