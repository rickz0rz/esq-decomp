/* RESTORES: _COI_RenderClockFormatEntryVariant
 * MODULE:   modules/groups/a/e/coi_p3_coi_formatentrydisplaytext_coi_renderclockformatentryvariant.s
 * STATUS:   behavioural
 *
 * THIS IS AN ALIAS, NOT A SECOND FUNCTION. The module carries two labels on
 * ONE address, separated only by a comment block:
 *
 *     _COI_RenderClockFormatEntryVariant:
 *     _COI_FormatEntryDisplayText:
 *         LINK.W  A5,#-...
 *
 * The original spends no bytes on the alias. This file forwards to the
 * definition of record in `coi_format_entry_display_text.c`.
 *
 * The alias is LIVE and it blocks a whole jump table.
 * `_NEWGRID2_JMPTBL_COI_RenderClockFormatEntryVariant` in
 * `modules/groups/b/a/newgrid2_p2.s` jumps to it.
 *
 * The `; FUNC:` comment under the alias label documents
 * `_COI_FormatEntryDisplayText`, not the alias, which is why the alias reads as
 * a 0-byte function to `refbytes.py`. That is the tell for this whole class.
 *
 * SASC-MISMATCH: alias-costs-a-forwarder
 *   ref:     (nothing -- a second label on the same address)
 *   got:     a forwarding function: five arguments re-pushed, BSR.W, RTS
 *   summary: two names for one entry point.
 *   tried:   nothing in C reaches it. SAS/C 6.51 has no alias pragma.
 *   scope:   five modules in the program carry an alias pair.
 *   retest:  a toolchain with an alias directive.
 */
extern void COI_FormatEntryDisplayText(char *entry, char *aux, long slot,
                                       char *out, long mode);

void COI_RenderClockFormatEntryVariant(char *entry, char *aux, long slot,
                                       char *out, long mode)
{
    COI_FormatEntryDisplayText(entry, aux, slot, out, mode);
}
