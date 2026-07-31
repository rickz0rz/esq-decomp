/* RESTORES: NEWGRID_SetSelectionMarkers
 * MODULE:   modules/groups/b/a/newgrid1b_p1_2_p0.s
 * STATUS:   behavioural
 *
 * Writes four marker characters from two independent 3-way selectors. The
 * primary pair gets 0x80/0x81 or 0x82/0x83, the secondary pair 0x88/0x89 or
 * 0x8a/0x8b, and either pair is zeroed when its selector is 0 or anything
 * outside 1..2.
 *
 * Both dispatches are chained subtracts on LONGS (TST.L / BEQ, then SUBQ.L #1 /
 * BEQ twice), which is what `switch` gives here without SHORTINT -- the
 * selectors are already long parameters, so there is no width to correct.
 *
 * Case 0 and the default share one arm in the original: TST.L / BEQ and the
 * closing BRA both land on the same zeroing block, so they are written as a
 * single `default`.
 *
 * The zero arms write BOTH markers from ONE register (MOVEQ #0,D0 then two
 * MOVE.B), which is the chained-assignment idiom. The first marker is stored
 * first, so the C chain is written right-to-left against the store order.
 *
 * The last two markers are re-read from the stack at every use (206d0018 /
 * 206d001c appear three times each) rather than held in address registers --
 * six pointers is more than the allocator has, and the original spills the same
 * two.
 *
 * This is a `no-calls` function, so nothing structural caps it at behavioural.
 *
 * 140 ref vs 120 got. Both chained-subtract dispatches are VERBATIM
 * (2007 4a80 671e 5380 6706 5380 670c 6014 and the same for the second), and so
 * are all eight marker constants.
 *
 * SASC-MISMATCH: link-frame-vs-none
 *   ref:     4e550000 ... 4e5d     LINK.W A5,#0 / UNLK
 *   got:     (nothing)
 *   summary: a ZERO-sized frame, opened only because the original addresses its
 *            six parameters through A5. 6.51 reads them at A7 offsets. 6 of the
 *            20 bytes.
 *   scope:   program-wide, and one of the clearest sightings of the reserved-A5
 *            property. docs/compiler-version.md, "The A3/A5 divergence has a
 *            single root cause: A5 is a reserved frame pointer".
 *   retest:  a compiler that reserves A5; the same doc gives the probe.
 *
 * SASC-MISMATCH: pointer-reloaded-per-store
 *   ref:     206d0018 10bc0088 206d001c 10bc0089   (three times each)
 *   got:     14bc0088 206f002c 10bc0089            two kept in registers
 *   summary: the original reloads BOTH trailing marker pointers from the frame
 *            before every store -- six reloads in the second dispatch. 6.51
 *            keeps one of the two in an address register and reloads only the
 *            other. The saved reloads are the remaining 14 bytes.
 *   tried:   nothing from the source side. Which parameters get registers is
 *            the allocator, and the original has one fewer to give because A5
 *            is its frame pointer -- the same root cause as the item above.
 *   scope:   program-wide.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
void NEWGRID_SetSelectionMarkers(long primary, long secondary,
                                 char *p1, char *p2, char *s1, char *s2)
{
    switch (primary) {
    case 1:
        *p1 = (char)0x80;
        *p2 = (char)0x81;
        break;
    case 2:
        *p1 = (char)0x82;
        *p2 = (char)0x83;
        break;
    default:
        *p2 = *p1 = 0;
        break;
    }

    switch (secondary) {
    case 1:
        *s1 = (char)0x88;
        *s2 = (char)0x89;
        break;
    case 2:
        *s1 = (char)0x8a;
        *s2 = (char)0x8b;
        break;
    default:
        *s2 = *s1 = 0;
        break;
    }
}
