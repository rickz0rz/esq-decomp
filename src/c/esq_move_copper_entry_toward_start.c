/* RESTORES: ESQ_MoveCopperEntryTowardStart
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 * LINKABLE SINCE 2026-08-04. THE OLD DO-NOT-LINK WAS SIMPLY WRONG. It said the
 *   function "takes its arguments in REGISTERS", and it does not: the first
 *   two instructions are `MOVE.L 4(A7),D1` and `MOVE.L 8(A7),D0`, which is an
 *   ordinary stack frame read. The note was copied across the whole copper
 *   family from the routines that really do read registers, and it kept an
 *   ordinary C function out of every manifest for no reason.
 *
 * THE ARGUMENTS WERE ALSO THE WRONG WAY ROUND, and being unlinked is why
 *   nothing caught it. The original loads the LIMIT from 4(A7) into D1 and the
 *   WALKER from 8(A7) into D2, so the entry that moves is the SECOND argument
 *   and it moves down to the first. The previous body used the first argument
 *   as the walker, which reverses the routine. Its sibling
 *   esq_move_copper_entry_toward_end.c has the opposite assignment in the
 *   original -- walker in D1, limit in D2 -- and was already correct, which is
 *   how the disagreement showed up.
 *
 *   Every caller passes (start, end): esqiff_service_pending_copper_palette_-
 *   moves.c four times, and ed2_handle_menu_actions.c as (0, 31) on the
 *   TowardEnd side. So TowardStart moves the entry at `end` down to `start`
 *   and TowardEnd moves the entry at `start` up to `end`, which is the
 *   symmetry the pair of names claims.
 *
 * SASC-MISMATCH: scratch-register-allocation
 *   ref:     222f0004202f000848e7380024000242001f0241001fe549e54a43f900002d2a41f90000414a0641000006420000383c001c3602594330312000b4416b00001a33b130002000b8426b00000831b1300020005942594360e233801000b8426b00000a67000006318010004cdf001c4e75   (150)
 *   summary: the original keeps both list bases in address registers across
 *            the whole routine and indexes them with `0(An,Dn.W)`. SAS/C
 *            recomputes an effective address per access, and it materialises
 *            each `<< 2` with a shift into a fresh register rather than
 *            folding it. The loop structure, the two comparisons per iteration
 *            and the guarded secondary write are the same.
 *   tried:   indexing a `short *` at `off >> 1` rather than casting a `char *`
 *            makes SAS/C emit the divide-by-two as a real ASR at every site.
 *            Holding the two bases in locals is what gets closest.
 *   scope:   program-wide; this is the ordinary DATA=FAR addressing cost.
 *   retest:  a compiler that pins the bases in address registers for the
 *            function's lifetime lands much closer.
 */
extern short ESQ_CopperStatusDigitsA[], ESQ_CopperStatusDigitsB[];

/* The entry at `end` moves down to `start`; everything between shifts up one
 * slot. The secondary list only mirrors slots below 0x1c. */
void ESQ_MoveCopperEntryTowardStart(long start, long end)
{
    char *a = (char *)ESQ_CopperStatusDigitsA;
    char *b = (char *)ESQ_CopperStatusDigitsB;
    short lim = (short)((start & 0x1f) << 2);
    short src = (short)((end & 0x1f) << 2);
    short prv = src - 4;
    short top = 0x1c;
    short held = *(short *)(a + src);

    while (src >= lim) {
        *(short *)(a + src) = *(short *)(a + prv);
        if (top >= src)
            *(short *)(b + src) = *(short *)(a + prv);
        src -= 4;
        prv -= 4;
    }
    *(short *)(a + lim) = held;
    if (top > src)
        *(short *)(b + lim) = held;
}
