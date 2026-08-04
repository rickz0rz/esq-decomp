/* RESTORES: _ESQIFF2_ClearPrimaryEntryFlags34To39
 * MODULE:   modules/groups/a/o/esqiff2_p4.s
 * STATUS:   behavioural
 *
 * Walks the primary entry pointer table and clears six contiguous flag bytes,
 * offsets 34 through 39, in every entry.
 *
 * Both counters are `short`. The original compares with CMP.W and indexes the
 * inner store with a word index (34(A0,D6.W)).
 *
 * SIZE: the reference reads 62 bytes because the epilogue carries its own
 * `_Return` label. Add the 6-byte `MOVEM.L (A7)+,D6-D7` / `UNLK A5` / `RTS`
 * for a true reference of 68, against 62 emitted. The whole 6-byte deficit is
 * the frame the original builds and 6.51 does not -- see below.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff8 ... 2b50fffc ... 206dfffc    LINK.W A5,#-8 /
 *                                                 MOVE.L (A0),-4(A5) /
 *                                                 MOVEA.L -4(A5),A0
 *   got:     (no LINK) ... 2a50 ... (no reload)    the pointer lives in A5
 *   summary: the original SPILLS the entry pointer to a frame slot and reloads
 *            it on every inner iteration. 6.51 has no frame to spill into, so
 *            it keeps the pointer in an address register and the reloads
 *            disappear. This is the reserved-A5 property seen from the
 *            local-variable side, and it makes the emitted code 6 bytes
 *            SHORTER rather than longer.
 *   tried:   nothing source-level reaches it. A pointer local is already what
 *            the original compiled from -- the difference is where the
 *            allocator puts it.
 *   scope:   program-wide. See docs/compiler-version.md, "The same property,
 *            seen from the local-variable side".
 *   retest:  a compiler that emits 2f0b on the acceptance test.
 */
extern short TEXTDISP_PrimaryGroupEntryCount;
extern char *TEXTDISP_PrimaryEntryPtrTable[];

void ESQIFF2_ClearPrimaryEntryFlags34To39(void)
{
    short entry;
    short slot;
    char *rec;

    for (entry = 0; entry < TEXTDISP_PrimaryGroupEntryCount; entry++) {
        rec = TEXTDISP_PrimaryEntryPtrTable[entry];

        for (slot = 0; slot < 6; slot++)
            rec[34 + slot] = 0;
    }
}
