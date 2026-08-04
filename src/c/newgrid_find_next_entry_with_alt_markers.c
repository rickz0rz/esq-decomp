/* RESTORES: NEWGRID_FindNextEntryWithAltMarkers
 * MODULE:   modules/groups/b/a/newgrid1b_p2_p1_2_p1.s
 * STATUS:   behavioural
 *
 * The most heavily guarded of the NEWGRID scan family: it advances to the next
 * entry that passes SIX tests, and answers its index or -1.
 *
 * The opcode chain is 0 to restart and 4 to continue, like
 * newgrid_find_next_entry_with_flags.c, but with a third arm -- SUBQ.L #2 after
 * the #4 -- so opcode 6 also falls into the scan. Anything else sets the found
 * flag and returns the index untouched.
 *
 * NEWGRID_UpdatePresetEntry is an OUT-PARAMETER call: it writes two pointers
 * through the two addresses it is given and RETURNS a slot index as a word.
 * All three are used, and both pointers are checked for null before either is
 * dereferenced.
 *
 * The six per-entry tests, in the order the original applies them:
 *   1. the entry pointer is non-null
 *   2. the aux pointer is non-null
 *   3. bit 3 of the state word at +46 is set
 *   4. bit 7 of the marker byte at +40 is set
 *   5. TestBit1Based over the bitset at +28 returns -1 for the slot
 *   6. bit 7 of the selector byte at aux + selector + 7 is CLEAR
 *   7. the pointer at aux + slot * 4 + 56 is non-null
 *
 * Test 5 is the ADDQ.L #1 / BNE idiom again: the helper answers -1 for "bit
 * clear", and the required answer here is -1, so the entry qualifies when the
 * bit is NOT set.
 *
 * Test 6 is inverted from the others -- BNE skips the entry -- so a set bit
 * BLOCKS the candidate.
 *
 * 230 ref vs 244 got, with the loop index and the found flag declared
 * `register`. The opcode chain, both null guards, the BTST #3 on the
 * state word, the BTST #7 on the marker byte, the LEA +28 bitset address, the
 * TestBit1Based call with its ADDQ.L #1 test, the BTST #7 selector block, the
 * ASL.L #2 slot scaling and the +56 pointer test all match in kind and size,
 * and every one of the six guards is applied in the original order.
 *
 * SASC-MISMATCH: out-parameters-forced-to-stack
 *   ref:     4aadfff6 / 4aadfff2 / 206dfff6 / 206dfff2
 *            the two out-pointers live in the A5 frame and are read from there
 *   got:     4aaf0018 / 4aaf0014 / 206f0018 / 206f0014
 *            the same, but addressed from A7
 *   summary: both compilers must spill these -- their ADDRESSES are passed to
 *            NEWGRID_UpdatePresetEntry, so neither can keep them in registers.
 *            This is the one shape where the reserved-A5 property costs
 *            NOTHING, because the original would have spilled anyway.
 *   tried:   without `register` on the loop index and the found flag, 6.51
 *            spills those too (42af0010 / 2f400010) where the original keeps
 *            them in D6 and D4, and the function is 252 bytes. Adding the
 *            keyword to both takes it to 244. Same lever as
 *            wdisp_draw_weather_status_summary.c, and it works here even though
 *            the out-parameter addresses already pin two frame slots -- so a
 *            crowded frame does not make the keyword useless.
 *   scope:   any function taking the address of a local.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct NewGridAltEntry {
    char          pad0[28];
    char          bitset[12];   /* +28 */
    unsigned char marker40;     /* +40 */
    char          pad41[5];
    short         state46;      /* +46 */
};

struct NewGridAltAux {
    char pad0[7];
    unsigned char selectorFlags[49];    /* +7, indexed by the selector */
    char pad56[0];
};

extern short NEWGRID_UpdatePresetEntry(struct NewGridAltEntry **entry,
                                       struct NewGridAltAux **aux,
                                       long selector, long index);
extern long  ESQ_TestBit1Based(char *bits, long slot);

extern unsigned short TEXTDISP_PrimaryGroupEntryCount;
extern unsigned char  TEXTDISP_PrimaryGroupPresentFlag;

long NEWGRID_FindNextEntryWithAltMarkers(long op, register long index,
                                        short selector)
{
    struct NewGridAltEntry *entry;
    struct NewGridAltAux   *aux;
    short slot;
    register long found = 0;

    switch (op) {
    case 0:  index = 0;  break;
    case 4:  index++;    break;
    case 6:              break;
    default: found = 1;  break;
    }

    if (found)
        return index;

    while (!found && index < TEXTDISP_PrimaryGroupEntryCount
           && TEXTDISP_PrimaryGroupPresentFlag != 0) {

        slot = NEWGRID_UpdatePresetEntry(&entry, &aux, (long)selector, index);

        if (entry != 0 && aux != 0
            && (entry->state46 & 8)
            && (entry->marker40 & 0x80)
            && ESQ_TestBit1Based(entry->bitset, (long)slot) == -1
            && !(aux->selectorFlags[selector] & 0x80)
            && *(long *)((char *)aux + slot * 4 + 56) != 0)
            found = 1;
        else
            index++;
    }

    if (!found)
        index = -1;
    return index;
}
