/* RESTORES: _ED1_ClearEscMenuMode
 * MODULE:   modules/groups/a/k/ed1_ed1clearescmenumode.s
 * STATUS:   exact
 *
 * Leaves the ESC menu by zeroing the editor's menu-state id. Eight bytes, one
 * store and a return.
 *
 * Data point for the zero-store-via-register class: the original emits CLR.B here,
 * so its compiler certainly HAS the CLR peephole.
 *
 * It is not yet known what selects it. An earlier version of this comment claimed
 * the original declines CLR only through a displacement; ctasks_close_task_teardown.c
 * disproves that -- there it emits MOVEQ #0 + MOVE.L D0 to a plain absolute where
 * CLR.L would have been two bytes shorter. The four sightings so far do not fall
 * into an obvious rule, so no rule is asserted:
 *
 *   CLR.B (abs).L      here
 *   CLR.B (A0)         textdisp_set_entry_text_fields.c, else branch
 *   MOVEQ+MOVE.B 9(A0) textdisp_set_entry_text_fields.c, if branch
 *   MOVEQ+MOVE.B (A0)  gcommand_consume_banner_queue_entry.c (zero reused later)
 *   MOVEQ+MOVE.L (abs) ctasks_close_task_teardown.c (zero NOT reused)
 */

extern char ED_MenuStateId;

void ED1_ClearEscMenuMode(void)
{
    ED_MenuStateId = 0;
}
