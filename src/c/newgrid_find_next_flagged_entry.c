/* RESTORES: NEWGRID_FindNextFlaggedEntry
 * MODULE:   modules/groups/b/a/newgrid1b_p2.s
 * STATUS:   behavioural
 *
 * Scans forward from an index for the next entry with bit 0 of +47 and bit 7 of
 * +40 both set, and answers its index or -1.
 *
 * The opcode dispatch is a chained subtract on a LONG (SUBQ.L #3 / BEQ /
 * SUBQ.L #1 / BEQ), so 3 restarts the scan from 0 and 4 continues from the next
 * index. Any other opcode sets the "done" flag immediately and the index comes
 * straight back unchanged -- it does NOT become -1, because the -1 is only
 * reached when the scan itself runs out.
 *
 * The group-present flag is tested ONCE, before the loop, and an absent group
 * also returns the index unchanged rather than -1. The sibling
 * newgrid_find_next_entry_with_flags.c tests the same flag INSIDE its loop and
 * therefore does return -1 in that case; the two are otherwise the same
 * routine, and this is the difference that matters.
 *
 * The entry-count bound is widened with MOVEQ #0 / MOVE.W, so it is an
 * unsigned short, and it is re-read every iteration.
 *
 * 130 ref vs 130 got. The opcode chain, both BTST operands, the PEA 1 / index
 * push, the ADDQ.W #8,A7 cleanup, the MOVEQ #-1 fallback and every branch
 * displacement in the scan loop match in kind and size.
 *
 * The opcode dispatch is written as a `switch`, and that is measured rather
 * than stylistic. An if/else chain gives independent compares
 * (7003 be80 6604 / 2007 5980 6604); the switch gives the original's CHAINED
 * SUBTRACT verbatim:
 *
 *     ref  2007 5780 6706 5380 6706
 *     got  2007 5780 6706 5380 6706
 *
 * Both forms come out at 130 bytes, so the byte count says nothing here and the
 * instruction sequence says everything -- which is AGENTS.md rule 1 in its
 * sharpest form. Note this works WITHOUT SHORTINT, unlike the key dispatchers:
 * the opcode is already a long, so there is no width to correct.
 */
struct NewGridScanEntry {
    char          pad0[40];
    unsigned char flags40;      /* +40 */
    char          pad41[6];
    unsigned char flags47;      /* +47 */
};

extern struct NewGridScanEntry *NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(
    long index, long mode);

extern unsigned char  TEXTDISP_PrimaryGroupPresentFlag;
extern unsigned short TEXTDISP_PrimaryGroupEntryCount;

long NEWGRID_FindNextFlaggedEntry(long op, long index)
{
    struct NewGridScanEntry *e;
    long found = 0;

    switch (op) {
    case 3:  index = 0;  break;
    case 4:  index++;    break;
    default: found = 1;  break;
    }

    if (found)
        return index;
    if (TEXTDISP_PrimaryGroupPresentFlag == 0)
        return index;

    while (!found && index < TEXTDISP_PrimaryGroupEntryCount) {
        e = NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(index, 1L);
        if (e != 0 && (e->flags47 & 1) && (e->flags40 & 0x80))
            found = 1;
        else
            index++;
    }

    if (!found)
        index = -1;
    return index;
}
