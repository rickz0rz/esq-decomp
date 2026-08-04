/* RESTORES: COI_SelectAnimFieldPointer
 * MODULE:   modules/groups/a/e/coi_p3_coi_getanimfieldpointerbymode_coi_getanimfieldpointerbymode.s
 * STATUS:   behavioural
 *
 * THIS IS AN ALIAS, NOT A SECOND FUNCTION. The module carries two labels on
 * ONE address:
 *
 *     COI_SelectAnimFieldPointer:
 *     _COI_GetAnimFieldPointerByMode:
 *         LINK.W  A5,#-20
 *
 * So the original spends no bytes on the alias at all. C has no way to give one
 * function two external names, so this file forwards. That costs a call, a
 * return and one stack frame for the duration of the call.
 *
 * The alias is LIVE. `_NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer` in
 * `modules/groups/b/a/newgrid2_p2.s` jumps to it, and
 * `NEWGRID_BuildShowtimesText` calls that thunk twice. Dropping the symbol
 * breaks the link, and defining it as an empty stub would silently return
 * garbage.
 *
 * The signature must stay identical to the target's. `coi_get_anim_field_
 * pointer_by_mode.c` is the definition of record for it.
 *
 * SASC-MISMATCH: alias-costs-a-forwarder
 *   ref:     (nothing -- a second label on the same address)
 *   got:     a forwarding function: arguments re-pushed, BSR.W, RTS
 *   summary: two names for one entry point. The original gets this free from
 *            the assembler. Every caller reaches the same code either way.
 *   tried:   nothing in C reaches it. A macro cannot create an EXTERNAL symbol,
 *            and SAS/C 6.51 has no alias pragma.
 *   scope:   two modules in the program carry an alias pair. The other is
 *            `_ESQDISP_TestEntryBits0And2`.
 *   retest:  a toolchain with an alias directive, or an assembly stub that is
 *            allowed to remain.
 */
#ifndef ANIMENTRY_DEFINED
struct AnimEntry;
#endif

extern char *COI_GetAnimFieldPointerByMode(struct AnimEntry *entry, short key,
                                           short mode);

char *COI_SelectAnimFieldPointer(struct AnimEntry *entry, short key, short mode)
{
    return COI_GetAnimFieldPointerByMode(entry, key, mode);
}
