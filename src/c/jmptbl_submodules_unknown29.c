/* RESTORES: UNKNOWN29_JMPTBL_ESQ_MainInitAndRun
 * MODULE:   modules/submodules/unknown29.s   (1 of its 2 labels)
 * STATUS:   behavioural
 *
 * The single jump-table thunk that shares a module with SAS/C's `_main`. It is
 * the reason lib_parse_command_line_and_run.c could not be linked on its own: a
 * C file replaces a WHOLE module, and this label had no restoration.
 *
 * The signature is copied from ESQ_MainInitAndRun's own restoration
 * (esq_main_init_and_run.c), not from the thunk, which says nothing about its
 * arguments. A thunk written `void f(void)` compiles, links, and silently
 * passes no arguments -- a whole bug class in this project's history.
 *
 * SASC-MISMATCH: tail-jump
 *   ref:     JMP _ESQ_MainInitAndRun
 *   got:     a call and a return, +2 bytes and one extra frame for the
 *            duration of the call
 *   summary: the same divergence every converted jump table carries.
 *   scope:   all converted tables.
 *   retest:  needs a compiler that can emit a tail jump; SAS/C 6.51 cannot.
 */
extern void ESQ_MainInitAndRun(long argc, char **argv);

void UNKNOWN29_JMPTBL_ESQ_MainInitAndRun(long argc, char **argv)
{
    ESQ_MainInitAndRun(argc, argv);
}
