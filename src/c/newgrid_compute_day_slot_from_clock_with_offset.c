/* RESTORES: NEWGRID_ComputeDaySlotFromClockWithOffset
 * MODULE:   modules/groups/b/a/newgrid_p2_p0.s
 * STATUS:   behavioural
 *
 * The offset-aware twin of newgrid_compute_day_slot_from_clock.c. Same 22-byte
 * struct copy, same half-hour lookup, same wrap of 49 back to 1 -- but the two
 * window bounds are shifted by GCOMMAND_MplexClockOffsetMinutes instead of
 * being the fixed 50 and 20.
 *
 * The bounds are 60 - offset and 30 - offset. The offset is loaded ONCE into
 * D1 and reused for both, which is why the second bound is computed as
 * MOVEQ #30 / SUB.L D1 rather than reloading the global.
 *
 * The three compares are NOT all the same width, and this is read off the
 * instructions rather than assumed:
 *
 *   minutes >= 60 - offset     EXT.L then CMP.L    (long)
 *   minutes <  30 - offset     EXT.L then CMP.L    (long)
 *   minutes >  29              CMP.W               (word)
 *
 * The last one compares the raw word against MOVEQ #29 with no widening, so it
 * stays a short comparison.
 *
 * The struct copy is a MOVE.L loop plus a trailing MOVE.W -- struct assignment,
 * not memcpy. See the sibling file for why that distinction is load-bearing.
 *
 * 106 ref vs 108 got. The struct copy is VERBATIM (7004 22d8 51c8fffc), and so
 * are the MOVEQ #60 / MOVEQ #30 / MOVEQ #29 bounds, the SUB.L offset
 * subtractions, all three EXT.L widenings, the final CMP.W and the wrap.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ffe4 ... 4e5d       LINK.W A5,#-28 / UNLK
 *   got:     9efc0018 ... defc0018   SUBA.W #24,A7 / ADDA.W #24,A7
 *   summary: the frame class, and 6.51 takes 24 bytes where the original takes
 *            28 because it makes no spill.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: struct-copy-tail-postincrement
 *   ref:     3290                    MOVE.W (A0),(A1)
 *   got:     32d8                    MOVE.W (A0)+,(A1)+
 *   summary: the trailing word of the 22-byte copy. Same size, same effect;
 *            nothing reads the pointers afterwards. Same item as the sibling
 *            newgrid_compute_day_slot_from_clock.c.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct NewGridClockData {
    short f0, f2, f4, f6, f8;
    short minutes;              /* +10 */
    short f12, f14, f16, f18, f20;
};

extern unsigned short NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(
    struct NewGridClockData *c);
extern long GCOMMAND_MplexClockOffsetMinutes;

long NEWGRID_ComputeDaySlotFromClockWithOffset(struct NewGridClockData *src)
{
    struct NewGridClockData tmp;
    long slot;
    long offset;

    tmp    = *src;
    slot   = (long)NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(&tmp);
    offset = GCOMMAND_MplexClockOffsetMinutes;

    if ((long)tmp.minutes >= 60 - offset
        || ((long)tmp.minutes >= 30 - offset && tmp.minutes <= 29)) {
        slot++;
        if (slot > 48)
            slot = 1;
    }
    return slot;
}
