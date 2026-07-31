/* RESTORES: DST_UpdateBannerQueue
 * MODULE:   modules/groups/a/j/dst2_p1_2.s
 * STATUS:   behavioural
 *
 * Ticks the two banner slots once and answers whether either of them changed.
 * The answer is the whole point: a nonzero result triggers the staging-buffer
 * rebuild at the end, and nothing else in the subsystem re-reads the slots.
 *
 * THE TWO SLOTS ARE NOT SYMMETRIC. Slot 0 always ticks. Slot 1 ticks in one of
 * two completely different ways depending on a MODE CHARACTER, not a flag:
 * ESQ_SecondarySlotModeFlagChar is compared against 89, which is 'Y'. On 'Y'
 * slot 1 behaves like slot 0; on anything else it ignores the entry entirely
 * and merely reallocates the banner struct when its timer expires.
 *
 * The countdown lives in TWO places at once and is copied back and forth: the
 * global holds it between ticks, field +16 of the entry holds it during the
 * tick. DATETIME_UpdateSelectionField is handed the entry with the global
 * already written into +16, and the value is read back out of +16 afterwards.
 * So the field is an IN-OUT parameter passed by struct, which is why the copies
 * look redundant and are not.
 *
 * THE EXPIRY TEST IS `== 1`, NOT `== 0`. The original writes
 * `MOVE.W count,D0 / SUBQ.W #1,D0 / BNE`, which tests the value MINUS ONE
 * against zero and does not store the result. So the branch fires on exactly 1
 * and the global is then set to 0 outright rather than decremented. A countdown
 * that somehow reached 0 without passing through 1 never expires.
 *
 * The time offset is +1 or -1 chosen by whether the entry's countdown reached
 * zero, and DST_AddTimeOffset takes (record, delta, 0) with the delta widened
 * to a long. On the empty-slot path the delta is the literal -1.
 *
 * DST_WriteRtcFromGlobals runs on the slot-0 entry path ONLY. Neither slot-1
 * path writes the clock, and neither does the slot-0 expiry path.
 *
 * 266 ref vs 264 got. The null guard on the pair, both +16 countdown copies,
 * the DATETIME_UpdateSelectionField calls with their word result tests, the
 * MOVEQ #89 mode compare, both DST_AddTimeOffset calls with their three
 * arguments, the DST_WriteRtcFromGlobals call, the DST_AllocateBannerStruct
 * reallocation and the final flag test all match in kind and size.
 *
 * SASC-MISMATCH: two-spellings-of-a-zero-store
 *   ref:     7000 33c0....   MOVEQ #0,D0 / MOVE.W D0,count   (the 'Y' path)
 *            4279....        CLR.W count                     (the other path)
 *   got:     4279.... at both sites
 *   summary: the ORIGINAL is the inconsistent one here. It zeroes the same
 *            global two different ways within one function, which is a hint the
 *            two arms came from differently-written source lines. 6.51 emits
 *            CLR.W for both, which is the shorter of the two, and that is where
 *            the function ends up 2 bytes UNDER the reference rather than over.
 *   tried:   a zero local, per AGENTS.md's chained-zero rule, to force the
 *            MOVEQ form on the 'Y' path. MEASURED, and it is a trap worth
 *            recording. It gives 266 bytes -- the reference size EXACTLY -- and
 *            converts BOTH sites to the register store, so it emits no CLR.W
 *            where the original emits one. And it is the WORSE candidate: 21
 *            differing regions against the plain form's 11, at 264 bytes. The
 *            size agreement is coincidence and the extra ten regions are real.
 *            This is AGENTS.md rule 1 in its sharpest form -- the size-exact
 *            candidate lost on every other measure, and taking the headline
 *            number would have shipped it. The two arms cannot be spelled
 *            differently from C in any case: 6.51 propagates the local to both.
 *   scope:   narrow. Two sites in this function.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct DstBannerEntry {
    char *first;                /* +0  */
    char *second;               /* +4  */
    long  firstSeconds;         /* +8  */
    long  secondSeconds;        /* +12 */
    short countdown;            /* +16 in-out for UpdateSelectionField */
};

struct DstBannerPair {
    struct DstBannerEntry *slot0;       /* +0 */
    struct DstBannerEntry *slot1;       /* +4 */
};

extern short DATETIME_UpdateSelectionField(struct DstBannerEntry *e);
extern void  DST_AddTimeOffset(void *record, long delta, long zero);
extern void *DST_AllocateBannerStruct(struct DstBannerEntry *old);
extern void  DST_RefreshBannerBuffer(void);
extern void  DST_WriteRtcFromGlobals(void);

extern short DST_PrimaryCountdown;
extern short DST_SecondaryCountdown;
extern char  ESQ_SecondarySlotModeFlagChar;
extern char  CLOCK_DaySlotIndex[];

long DST_UpdateBannerQueue(struct DstBannerPair *pair)
{
    struct DstBannerEntry *e;
    long changed = 0;
    long delta;

    if (pair == 0)
        return changed;

    if (pair->slot0 != 0) {

        pair->slot0->countdown = DST_PrimaryCountdown;

        if (DATETIME_UpdateSelectionField(pair->slot0) != 0) {

            e = pair->slot0;
            if (e->countdown == 0)
                delta = -1;
            else
                delta = 1;

            DST_AddTimeOffset(CLOCK_DaySlotIndex, delta, 0L);

            DST_PrimaryCountdown = pair->slot0->countdown;
            DST_WriteRtcFromGlobals();
            changed = 1;
        }

    } else if (DST_PrimaryCountdown == 1) {

        DST_AddTimeOffset(CLOCK_DaySlotIndex, -1L, 0L);
        DST_PrimaryCountdown = 0;
        changed = 1;
    }

    if (ESQ_SecondarySlotModeFlagChar == 89) {

        if (pair->slot1 != 0) {

            pair->slot1->countdown = DST_SecondaryCountdown;

            if (DATETIME_UpdateSelectionField(pair->slot1) != 0) {
                DST_SecondaryCountdown = pair->slot1->countdown;
                changed = 1;
            }

        } else if (DST_SecondaryCountdown == 1) {
            DST_SecondaryCountdown = 0;
            changed = 1;
        }

    } else if (DST_SecondaryCountdown == 1) {

        pair->slot1 = DST_AllocateBannerStruct(pair->slot1);
        DST_SecondaryCountdown = 0;
        changed = 1;
    }

    if (changed)
        DST_RefreshBannerBuffer();

    return changed;
}
