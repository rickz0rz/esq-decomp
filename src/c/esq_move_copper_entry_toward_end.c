/* RESTORES: ESQ_MoveCopperEntryTowardEnd
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 * LINKABLE SINCE 2026-08-04. THE OLD DO-NOT-LINK WAS SIMPLY WRONG. It said the
 *   function "takes its arguments in REGISTERS", and it does not: the first
 *   two instructions are `MOVE.L 4(A7),D1` and `MOVE.L 8(A7),D0`, which is an
 *   ordinary stack frame read. The note was copied across the whole copper
 *   family from the routines that really do read registers.
 *
 *   This half had its arguments the right way round already. Its sibling
 *   esq_move_copper_entry_toward_start.c did not, and comparing the two is how
 *   that was found -- see the note there. In this routine the WALKER is the
 *   first argument (D1) and the LIMIT is the second (D2), which is the mirror
 *   image of TowardStart.
 *
 * SASC-MISMATCH: scratch-register-allocation
 *   ref:     222f0004202f000848e7380024000242001f0241001fe549e54a43f900002d2a41f90000414a0641000006420000383c00207604d64130311000b2426a00001a33b130001000b2446a00000831b1300010005841584360e233801000b2446a000006318010004cdf001c4e75   (148)
 *   summary: the original keeps both list bases in address registers across
 *            the whole routine and indexes them with `0(An,Dn.W)`. SAS/C
 *            recomputes an effective address per access, and it materialises
 *            each `<< 2` with a shift into a fresh register rather than
 *            folding it. The loop structure, the two comparisons per iteration
 *            and the guarded secondary write are the same.
 *   tried:   indexing a `short *` at `off >> 1` rather than casting a `char *`
 *            makes SAS/C emit the divide-by-two as a real ASR at every site.
 *   scope:   program-wide; this is the ordinary DATA=FAR addressing cost.
 *   retest:  a compiler that pins the bases in address registers for the
 *            function's lifetime lands much closer.
 */
extern short ESQ_CopperStatusDigitsA[], ESQ_CopperStatusDigitsB[];

/* The entry at `start` moves up to `end`; everything between shifts down one
 * slot. The secondary list only mirrors slots below 0x20. */
void ESQ_MoveCopperEntryTowardEnd(long start, long end)
{
    char *a = (char *)ESQ_CopperStatusDigitsA;
    char *b = (char *)ESQ_CopperStatusDigitsB;
    short src = (short)((start & 0x1f) << 2);
    short lim = (short)((end & 0x1f) << 2);
    short nxt = src + 4;
    short top = 0x20;
    short held = *(short *)(a + src);

    while (src < lim) {
        *(short *)(a + src) = *(short *)(a + nxt);
        if (src < top)
            *(short *)(b + src) = *(short *)(a + nxt);
        src += 4;
        nxt += 4;
    }
    *(short *)(a + src) = held;
    if (src < top)
        *(short *)(b + src) = held;
}
