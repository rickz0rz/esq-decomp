/* RESTORES: NEWGRID_InitSelectionWindowAlt
 * MODULE:   modules/groups/b/a/newgrid1bb_p1.s
 * STATUS:   behavioural
 *
 * Initialises a selection window: clears the three head fields, sets the start
 * slot, wraps it into the next day when appropriate, and computes the end from
 * a configured span.
 *
 * The two head pointers are zeroed from ONE cleared address register
 * (SUBA.L A0,A0 then two stores), which AGENTS.md records as the chained
 * assignment idiom working for pointers too. The third field uses a fresh
 * CLR.L, so the chain stops after two -- matching the grouping, not just the
 * idiom.
 *
 * The day wrap fires when the slot is below 48 AND either it is exactly 1 or
 * the current half-hour slot is 1. Reading that as a single condition would
 * miss that the helper is only called when the slot is not 1.
 *
 * The span byte is SIGNED (EXT.W then EXT.L), and which of the two config
 * bytes is used depends on the mode being non-zero.
 *
 * The end is clamped to 96 and THEN incremented, so the stored maximum is 97.
 * The increment is outside the clamp -- the BLE at 0x25F5E lands on the ADDQ.W,
 * not past it.
 *
 * 138 ref vs 144 got. The SUBA.L A0,A0 pointer zero, the MOVEQ #48 bound, the
 * half-hour call, the SUBQ.W #1 test, the ADD.W #48 wrap, both config-byte
 * loads with their EXT.W / EXT.L sign extension, the MOVEQ #96 clamp and the
 * closing ADDQ.W #1 all match in kind and size.
 *
 * SASC-MISMATCH: chained-store-not-taken
 *   ref:     2688 27480004 42ab0008
 *            MOVE.L A0,(A3) / MOVE.L A0,4(A3) / CLR.L 8(A3)
 *   got:     2a88 2b480004 2b480008
 *            the SAME register stored to all THREE fields
 *   summary: the original stops the chain after two fields and reaches for a
 *            fresh CLR.L on the third; 6.51 carries the zeroed register into
 *            the third store as well. AGENTS.md records this hazard -- "the
 *            chain must stop where the original does" -- and here the source
 *            DOES stop it (w->tail = w->head = 0; then w->f8 = 0;) and 6.51
 *            merges them anyway. The grouping is not always reachable from the
 *            source.
 *   tried:   writing all three as separate statements, measured at 140 bytes
 *            against the chained form's 144 and the original's 138. It is
 *            SMALLER and it is REJECTED, which is the interesting part. The
 *            separated form emits 4295 / 42ad0004 / 42ad0008 -- three CLR.L --
 *            and so matches only the LAST of the original's four instructions.
 *            The chained form emits 91c8 / 2a88 / 2b480004 / 2b480008 and
 *            matches the first THREE (the SUBA.L A0,A0 zero and both MOVE.L
 *            stores from it), missing only the closing CLR.L. Three of four
 *            beats one of four; AGENTS.md rule 1 says prefer the structure over
 *            the byte count, and this is a clean case of the two disagreeing.
 *   scope:   any run of adjacent zero stores.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct NewGridSelWindow {
    void *head;                 /* +0  */
    void *tail;                 /* +4  */
    long  f8;                   /* +8  */
    char  pad12[8];
    short start;                /* +20 */
    short row;                  /* +22 */
    short end;                  /* +24 */
};

extern short NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(long *clock);

extern long CLOCK_DaySlotIndex[];
extern char CONFIG_NewgridWindowSpanHalfHoursPrimary;
extern char CONFIG_NewgridWindowSpanHalfHoursAlt;

void NEWGRID_InitSelectionWindowAlt(struct NewGridSelWindow *w, short slot,
                                    long mode)
{
    long span;
    long end;

    if (w == 0)
        return;

    w->tail = w->head = 0;
    w->f8 = 0;

    w->start = slot;

    if (slot < 48) {
        if (slot == 1
            || NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(CLOCK_DaySlotIndex) == 1)
            w->start += 48;
    }

    w->row = w->start;

    if (mode)
        span = (long)CONFIG_NewgridWindowSpanHalfHoursAlt;
    else
        span = (long)CONFIG_NewgridWindowSpanHalfHoursPrimary;

    end = (long)w->start + span;
    w->end = (short)end;

    if (end > 96)
        w->end = 96;

    w->end++;
}
