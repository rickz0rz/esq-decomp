/* RESTORES: NEWGRID_FindNextEntryWithFlags
 * MODULE:   modules/groups/b/a/newgrid1b_p2_p0.s
 * STATUS:   behavioural
 *
 * The near-twin of newgrid_find_next_flagged_entry.c. Same scan, same result
 * convention, three differences and all three are load-bearing:
 *
 *  - The restart opcode is 0, not 3. The original tests TST.L D0 / BEQ before
 *    the SUBQ.L #4, so the chain reads 0 then 4 rather than 3 then 4.
 *  - The required bit at +47 is bit 2, not bit 0.
 *  - The group-present flag is tested INSIDE the loop, after the count bound,
 *    so an absent group falls out through the scan and returns -1. The sibling
 *    tests it before the loop and returns the index unchanged instead.
 *
 * Everything else -- the found flag, the unsigned-short count, the bit 7 test
 * at +40, and the -1 only when the scan runs out -- is identical.
 *
 * 130 ref vs 124 got. The opcode chain, both BTST operands, the argument
 * pushes, the cleanup and the fallback all match in kind.
 *
 * SASC-MISMATCH: link-frame-and-dead-spill
 *   ref:     4e55fff8 ... 2b40fff8 ... 4e5d
 *            LINK.W A5,#-8 / MOVE.L D0,-8(A5) / UNLK
 *   got:     2a40                 MOVEA.L D0,A5
 *   summary: the original opens an 8-byte frame solely to store the entry
 *            pointer into it, and NOTHING EVER READS IT BACK -- the two BTSTs
 *            that follow go through the register. 6.51 has no frame and makes
 *            no dead store. The frame plus the store is the 6 bytes. The
 *            sibling newgrid_find_next_flagged_entry.c does exactly the same
 *            thing at -4(A5).
 *   tried:   nothing. Reproducing a dead store means writing a local that
 *            exists to be ignored, which is a wish rather than a source form.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * The opcode dispatch is a `switch` for the same measured reason as the
 * sibling: it reproduces the original chained subtract verbatim
 * (2007 4a80 6706 5980 6706, TST.L then SUBQ.L #4), where an if/else chain
 * emits independent compares. 130 ref vs 128 got after the change.
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

long NEWGRID_FindNextEntryWithFlags(long op, long index)
{
    struct NewGridScanEntry *e;
    long found = 0;

    switch (op) {
    case 0:  index = 0;  break;
    case 4:  index++;    break;
    default: found = 1;  break;
    }

    if (found)
        return index;

    while (!found && index < TEXTDISP_PrimaryGroupEntryCount
           && TEXTDISP_PrimaryGroupPresentFlag != 0) {
        e = NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(index, 1L);
        if (e != 0 && (e->flags47 & 4) && (e->flags40 & 0x80))
            found = 1;
        else
            index++;
    }

    if (!found)
        index = -1;
    return index;
}
