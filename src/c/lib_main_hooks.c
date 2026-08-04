/* RESTORES: ESQ_MainEntryNoOpHook, ESQ_MainExitNoOpHook
 * MODULE:   modules/submodules/unknown2b.s   (2 of its 9 labels)
 * STATUS:   behavioural
 *
 * SAS/C's two startup hooks. Both are a bare RTS in the original, and both are
 * reached through the `_main` jump table, so the symbols must exist even though
 * neither does anything.
 *
 * THEY ARE CALLED WITH ARGUMENTS ALREADY ON THE STACK, AND THAT IS FINE. The
 * caller in `modules/groups/_main/a/a.s` pushes the saved Workbench message and
 * the command buffer BEFORE the entry hook, and leaves them there for
 * `ESQ_ParseCommandLineAndRun` to read:
 *
 *     MOVE.L  A0,-(A7)                        ; saved WBStartup message
 *     PEA     Global_WBStartupCmdBuffer(A4)   ; command buffer
 *     ...
 *     JSR     GROUP_MAIN_A_JMPTBL_ESQ_MainEntryNoOpHook(PC)
 *     JSR     GROUP_MAIN_A_JMPTBL_ESQ_ParseCommandLineAndRun(PC)
 *
 * A `void` hook simply ignores the block, exactly as the original's RTS does.
 * The two calls are NOT a two-argument function split in half.
 *
 * NOT LINKED YET. `unknown2b.s` holds nine labels and a C file replaces a whole
 * module, so these wait on the SAS/C stdio routines beside them. They are
 * written now because `jmptbl_to_c.py` reads the signatures from here.
 */

void ESQ_MainEntryNoOpHook(void)
{
}

void ESQ_MainExitNoOpHook(void)
{
}
