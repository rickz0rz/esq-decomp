/* RESTORES: NEWGRID_DrawEntryRowOrPlaceholder
 * MODULE:   modules/groups/b/a/newgrid1b_p1_2_p0_p0.s
 * STATUS:   behavioural
 *
 * Draws a grid row, or one of two placeholder strings when there is nothing to
 * draw.
 *
 * The kind selector is a chained subtract: 0 gives the off-air placeholder, 1
 * gives the no-data placeholder, 2 draws a row, and ANYTHING ELSE also gives
 * no-data -- the third test is a BNE to the same target, so the default and
 * case 1 share an arm.
 *
 * Within case 2 the placeholder-mode flag picks between two DIFFERENT argument
 * sets for the same drawing routine, and they are not variations of one call:
 * the flag-set path passes the two real coordinates plus a bevel boolean, while
 * the flag-clear path passes literal 3 and 1 in place of the second coordinate
 * and the boolean.
 *
 * The bevel boolean is a booleanize of the config byte against 'Y' (89):
 * CMP.B / SEQ / NEG.B / EXT.W / EXT.L gives 1 for 'Y' and 0 otherwise.
 *
 * 178 ref vs 168 got. The chained-subtract kind dispatch, the
 * CMP.B / SEQ / NEG.B / EXT.W / EXT.L booleanize against 89, both seven-argument
 * pushes with their PEA 2 / PEA 1 / PEA 3 literals, both LEA 28(A7),A7 cleanups
 * and both placeholder calls match in kind and size.
 *
 * SASC-MISMATCH: booleanize-shape
 *   ref:     7859 b404 57c3 4403 4883 48c3
 *            MOVEQ #89,D4 / CMP.B D4,D2 / SEQ D3 / NEG.B / EXT.W / EXT.L
 *   got:     7659 b403 57c2 7600 9602
 *            MOVEQ #89,D3 / CMP.B D3,D2 / SEQ D2 / MOVEQ #0,D3 / SUB.B D2,D3
 *   summary: both give 1 for a match and 0 otherwise. The original negates and
 *            widens; 6.51 subtracts the 0xFF from a zeroed register, which
 *            leaves the value already widened. Same class as
 *            parseini_monitor_clock_change.c.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: link-frame-vs-none
 *   ref:     4e550000 ... 4e5d      LINK.W A5,#0 / UNLK
 *   got:     (nothing)
 *   summary: a ZERO-sized frame, opened only to address the six parameters
 *            through A5. 6 of the 10 bytes.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  a compiler that reserves A5; the same doc gives the probe.
 */
extern void NEWGRID_DrawGridEntry(void *rp, void *entry, void *ctx, long x,
                                  long y, long bevel, long mode);
extern void DISPTEXT_LayoutAndAppendToBuffer(void *dst,
                                                             char *src);

extern short NEWGRID_EntryPlaceholderModeFlag;
extern char  CONFIG_NewgridPlaceholderBevelFlag;
extern char *SCRIPT_PtrOffAirPlaceholder;
extern char *SCRIPT_PtrNoDataPlaceholder;

void NEWGRID_DrawEntryRowOrPlaceholder(void *rp, void *entry, void *ctx,
                                       short x, short y, long kind)
{
    switch (kind) {
    case 0:
        DISPTEXT_LayoutAndAppendToBuffer(
            rp, SCRIPT_PtrOffAirPlaceholder);
        break;

    case 2:
        if (NEWGRID_EntryPlaceholderModeFlag != 0)
            NEWGRID_DrawGridEntry(rp, entry, ctx, (long)x, (long)y,
                                  (CONFIG_NewgridPlaceholderBevelFlag == 'Y')
                                      ? 1L : 0L,
                                  2L);
        else
            NEWGRID_DrawGridEntry(rp, entry, ctx, (long)x, 3L, 1L, 2L);
        break;

    default:
        DISPTEXT_LayoutAndAppendToBuffer(
            rp, SCRIPT_PtrNoDataPlaceholder);
        break;
    }
}
