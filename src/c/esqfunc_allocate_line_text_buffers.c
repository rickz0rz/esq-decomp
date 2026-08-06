/* RESTORES: ESQFUNC_AllocateLineTextBuffers
 * MODULE:   modules/groups/a/n/esqfunc.s
 * STATUS:   behavioural
 *
 * Allocates the twenty 60-byte line-text buffers. Nothing checks the results;
 * a failed allocation leaves a null in the table for a later reader to trip over.
 * That is the original's behaviour.
 *
 * The two slot indices are reset from the same register the function returns in,
 * which is why they are written as a chain and the return is a plain 0.
 *
 * 90 bytes in the original, 90 emitted. Itemises to zero: -2 frame, +2/-2 for the
 * sign-extend, +2/-2 for where the returned zero is materialised.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fffc ... 4e5d   LINK.W A5,#-4 / UNLK A5
 *   got:     594f ... 584f       SUBQ.W #4,A7 / ADDQ.W #4,A7
 *   summary: -2, and note the stack slot is still needed in both: the loop spills
 *            the table address across the allocator call either way.
 *
 * SASC-MISMATCH: sign-extend-in-place
 *   ref:     2007 48c0   MOVE.L D7,D0 / EXT.L D0
 *   got:     48c7        EXT.L D7
 *   summary: Same class as esqfunc_free_extra_title_text_pointers.c. +2/-2.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the one cross-unit call.
 */

extern void *MEMORY_AllocateMemory(char *who, long line, long size,
                                                 long flags);

extern char *LADFUNC_LineTextBufferPtrs[];
extern short LADFUNC_LineSlotWriteIndex;
extern short LADFUNC_LineSlotSecondaryIndex;

long ESQFUNC_AllocateLineTextBuffers(void)
{
    short i;

    for (i = 0; i < 20; i++)
        LADFUNC_LineTextBufferPtrs[i] =
            (char *)MEMORY_AllocateMemory("ESQFUNC.c",
                                                        1222L, 60L, 0x00010001L);
    LADFUNC_LineSlotSecondaryIndex = LADFUNC_LineSlotWriteIndex = 0;
    return 0;
}
