/* RESTORES: NEWGRID_InitSelectionWindow
 * MODULE:   modules/groups/b/a/newgrid2.s
 * STATUS:   behavioural
 *
 * 256 bytes in the original, 252 emitted.
 *
 * Reproduces: the null guard, the forward scan that walks until it finds the
 * first entry with bit 4 of byte 47 set -- writing that index into the loop's own
 * bound so the loop self-terminates -- the mirrored reverse scan, the slot
 * assignment with its two-way +48 adjustment (taken either when mode is 1 or when
 * the half-hour slot index comes back as 1), and the final window-end computation
 * (29 + minutes) / 30 with its clamp to 96 followed by an unconditional
 * increment.
 *
 * The chained-assignment rule applies to POINTERS as well as scalars, which is
 * worth recording separately from esqdisp_promote_secondary_group_to_primary.c.
 * Written as two statements SAS/C emits CLR.L twice; written as
 *
 *     w->tail = w->head = 0;
 *
 * it emits SUBA.L A0,A0 followed by two stores, exactly as the original does.
 * Note the original then uses a SEPARATE zero (MOVEQ #0,D0) for the adjacent long
 * field, so the chain must stop at the two pointers -- extending it to three
 * fields would be wrong.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff8 48e70310         LINK.W A5,#-8 / MOVEM
 *   got:     48e72314                  MOVEM only, no frame
 *   summary: The A5-frame class; the single spilled entry pointer stays in a
 *            register for SAS/C.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the three cross-unit calls.
 */
struct SelWin {
    void *head;      /*  0 */
    void *tail;      /*  4 */
    long  flags;     /*  8 */
    long  first;     /* 12 */
    long  last;      /* 16 */
    short slot;      /* 20 */
    short slotCopy;  /* 22 */
    short slotEnd;   /* 24 */
};

extern unsigned char *ESQDISP_GetEntryPointerByMode(long i, long mode);
extern long ESQ_GetHalfHourSlotIndex(void *p);
extern short TEXTDISP_PrimaryGroupEntryCount;
extern long  GCOMMAND_PpvSelectionWindowMinutes;
extern short CLOCK_DaySlotIndex;

void NEWGRID_InitSelectionWindow(struct SelWin *w, short mode)
{
    unsigned char *entry;
    register long i;

    if (w == 0)
        return;

    w->tail = w->head = 0;
    w->flags = 0;

    if (mode) {
        w->first = TEXTDISP_PrimaryGroupEntryCount;
        for (i = 0; i < w->first; i++) {
            entry = ESQDISP_GetEntryPointerByMode(i, 1);
            if (entry[47] & 0x10)
                w->first = i;
        }
        w->last = w->first;
        for (i = TEXTDISP_PrimaryGroupEntryCount; i > w->last; i--) {
            entry = ESQDISP_GetEntryPointerByMode(i - 1, 1);
            if (entry[47] & 0x10)
                w->last = i;
        }
    } else {
        w->last = w->first = 0;
    }

    w->slot = mode;
    if (mode < 48) {
        if (mode == 1)
            w->slot += 48;
        else if (ESQ_GetHalfHourSlotIndex(&CLOCK_DaySlotIndex) == 1)
            w->slot += 48;
    }

    w->slotCopy = w->slot;
    w->slotEnd = w->slot + (29 + GCOMMAND_PpvSelectionWindowMinutes) / 30;
    if (w->slotEnd > 96)
        w->slotEnd = 96;
    w->slotEnd++;
}
