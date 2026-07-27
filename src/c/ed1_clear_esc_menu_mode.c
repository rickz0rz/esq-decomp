/* RESTORES: _ED1_ClearEscMenuMode
 * MODULE:   modules/groups/a/k/ed1_ed1clearescmenumode.s
 * STATUS:   exact
 *
 * Leaves the ESC menu by zeroing the editor's menu-state id. Eight bytes, one
 * store and a return.
 *
 * Worth noting against the zero-store-via-register class recorded in
 * textdisp_set_entry_text_fields.c and gcommand_consume_banner_queue_entry.c: the
 * original emits CLR.B here, not MOVEQ #0 plus a store. So the original's compiler
 * does have the CLR peephole and applies it to a plain absolute operand -- what it
 * declines to do is apply it through a displacement or reuse. That narrows the
 * class from "the original avoids CLR" to something much more specific.
 */

extern char ED_MenuStateId;

void ED1_ClearEscMenuMode(void)
{
    ED_MenuStateId = 0;
}
