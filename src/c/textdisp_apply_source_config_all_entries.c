/* RESTORES: TEXTDISP_ApplySourceConfigAllEntries
 * MODULE:   modules/groups/b/a/textdisp_p2_p1.s
 * STATUS:   behavioural
 *
 * Applies the source configuration to every entry of both groups. The two
 * loops are identical except for the count they read and the mode they pass
 * (1 for the primary group, 2 for the secondary).
 *
 * Both counts are widened with MOVEQ #0 / MOVE.W, so they are unsigned shorts,
 * and both are re-read on every iteration -- the entry-config call can change
 * them.
 *
 * The original also stores the returned pointer into a frame local (-8(A5))
 * that nothing ever reads back. It is the reserved-A5 spill showing through,
 * not a second use of the value.
 *
 * 92 ref vs 80 got. Both loop bodies, both PEA mode constants, both
 * ADDQ.W #8,A7 cleanups and both MOVE.L D0,(A7) argument-slot reuses match
 * exactly. The 12 bytes are one class in two parts.
 *
 * SASC-MISMATCH: link-frame-and-dead-spill
 *   ref:     4e55fff8 ... 2b40fff8 (x2) ... 4e5d
 *            LINK.W A5,#-8 / MOVE.L D0,-8(A5) twice / UNLK
 *   got:     (no frame, no spill)
 *   summary: the original opens an 8-byte frame solely to store the returned
 *            entry pointer into it, once per loop, and NOTHING EVER READS IT
 *            BACK. 6.51 has no frame pointer, so it has nowhere to make the
 *            dead store and does not make it: 6 bytes of frame plus 4 bytes at
 *            each of the two stores. A C restoration cannot produce a dead
 *            store the source does not ask for, and asking for one would mean
 *            writing a variable that exists to be ignored.
 *   tried:   nothing. Reproducing this would require inventing an unused local
 *            and hoping the allocator spills it, which is not a source form so
 *            much as a wish.
 *   scope:   program-wide, and this is the clearest single sighting of the
 *            local-variable side of the reserved-A5 property -- the frame is
 *            written to and never read. docs/compiler-version.md, "The same
 *            property, seen from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern void *TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(long index, long mode);
extern void  TEXTDISP_ApplySourceConfigToEntry(void *entry);

extern unsigned short TEXTDISP_PrimaryGroupEntryCount;
extern unsigned short TEXTDISP_SecondaryGroupEntryCount;

void TEXTDISP_ApplySourceConfigAllEntries(void)
{
    long i;

    for (i = 0; i < TEXTDISP_PrimaryGroupEntryCount; i++)
        TEXTDISP_ApplySourceConfigToEntry(
            TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(i, 1L));

    for (i = 0; i < TEXTDISP_SecondaryGroupEntryCount; i++)
        TEXTDISP_ApplySourceConfigToEntry(
            TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(i, 2L));
}
