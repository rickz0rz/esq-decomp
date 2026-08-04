/* RESTORES: _ESQDISP_DrawStatusBanner
 * MODULE:   modules/groups/a/n/esqdispb_p0_p1_p0_esqdisp_drawstatusbanner_impl_esqdisp_drawstatusbanner_impl.s
 * STATUS:   behavioural
 *
 * THIS IS AN ALIAS, NOT A SECOND FUNCTION. The module carries two labels on
 * ONE address, separated only by a comment block:
 *
 *     _ESQDISP_DrawStatusBanner:
 *     _ESQDISP_DrawStatusBanner_Impl:
 *         (the banner renderer)
 *
 * The original spends no bytes on the alias. This file forwards to the
 * definition of record in `esqdisp_draw_status_banner_impl.c`.
 *
 * The alias is LIVE and it blocks a whole jump table.
 * `_GROUP_AC_JMPTBL_ESQDISP_DrawStatusBanner` in `modules/groups/a/c/xjump.s`
 * jumps to it, and that table cannot be converted until this symbol exists
 * in C.
 *
 * THE PARAMETER IS `short`, and this matters. The definition takes
 * `short highlight`. Several unrelated files declare the extern as
 * `(long which)`, which is harmless for them because the caller pushes a
 * 4-byte slot either way -- but this forwarder must match the DEFINITION, or
 * the value it passes on is read from the wrong half of the slot.
 *
 * SASC-MISMATCH: alias-costs-a-forwarder
 *   ref:     (nothing -- a second label on the same address)
 *   got:     a forwarding function: one argument re-pushed, BSR.W, RTS
 *   summary: two names for one entry point.
 *   tried:   nothing in C reaches it. SAS/C 6.51 has no alias pragma.
 *   scope:   five modules in the program carry an alias pair.
 *   retest:  a toolchain with an alias directive.
 */
extern void ESQDISP_DrawStatusBanner_Impl(short highlight);

void ESQDISP_DrawStatusBanner(short highlight)
{
    ESQDISP_DrawStatusBanner_Impl(highlight);
}
