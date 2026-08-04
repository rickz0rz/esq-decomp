/* RESTORES: _COI_ProcessEntrySelectionState
 * MODULE:   modules/groups/a/e/coi_p4_coi_testentrywithintimewindow_coi_processentryselectionstate.s
 * STATUS:   behavioural
 *
 * THIS IS AN ALIAS, NOT A SECOND FUNCTION. The module carries two labels on
 * ONE address, separated only by a comment block:
 *
 *     _COI_ProcessEntrySelectionState:
 *     _COI_TestEntryWithinTimeWindow:
 *         LINK.W  A5,#-24
 *
 * The original spends no bytes on the alias. C cannot give one function two
 * external names, so this file forwards to the definition of record in
 * `coi_test_entry_within_time_window.c`.
 *
 * The alias is LIVE and it blocks a whole jump table.
 * `_NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState` in
 * `modules/groups/b/a/newgrid2_p2.s` jumps to it, and that table cannot be
 * converted to C until this symbol exists in C.
 *
 * SASC-MISMATCH: alias-costs-a-forwarder
 *   ref:     (nothing -- a second label on the same address)
 *   got:     a forwarding function: five arguments re-pushed, BSR.W, RTS
 *   summary: two names for one entry point. The original gets this free from
 *            the assembler.
 *   tried:   nothing in C reaches it. SAS/C 6.51 has no alias pragma.
 *   scope:   five modules in the program carry an alias pair.
 *   retest:  a toolchain with an alias directive.
 */
#ifndef COIENTRY_DEFINED
struct CoiEntry;
#endif

extern long COI_TestEntryWithinTimeWindow(struct CoiEntry *entry, void *aux,
                                          short slot, long window,
                                          long fallback);

long COI_ProcessEntrySelectionState(struct CoiEntry *entry, void *aux,
                                    short slot, long window, long fallback)
{
    return COI_TestEntryWithinTimeWindow(entry, aux, slot, window, fallback);
}
