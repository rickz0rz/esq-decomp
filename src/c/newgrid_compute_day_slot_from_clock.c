/* RESTORES: NEWGRID_ComputeDaySlotFromClock
 * MODULE:   modules/groups/b/a/newgrid_p2.s
 * STATUS:   behavioural
 *
 * Takes a copy of the caller's clock record, asks for its half-hour slot index,
 * and bumps the slot by one when the minutes field falls in a late part of the
 * hour, wrapping 49 back to 1.
 *
 * The local copy is a STRUCT ASSIGNMENT, not a memcpy. The original emits
 * MOVEQ #4 / MOVE.L (A0)+,(A1)+ / DBF followed by one MOVE.W (A0),(A1) -- five
 * longs and a word, 22 bytes. AGENTS.md records that struct assignment gives
 * exactly that long-copy shape where memcpy of the same bytes gives a MOVE.B
 * loop, so the copy is written as `tmp = *src;`.
 *
 * The record is therefore 22 bytes with the minutes field at offset 10, which
 * is where the original reads it (-16(A5) against a copy based at -26(A5)).
 *
 * The predicate is three signed word compares, and reading them off the branch
 * targets rather than the order they are written matters:
 *
 *   minutes >= 50            -> bump
 *   minutes <  20            -> leave alone
 *   minutes > 29             -> leave alone
 *   otherwise (20..29)       -> bump
 *
 * so the condition is `minutes >= 50 || (minutes >= 20 && minutes <= 29)`.
 *
 * The slot index is widened with MOVEQ #0,D7 / MOVE.W D0,D7, so the helper
 * returns an unsigned short.
 *
 * 84 ref vs 88 got. The struct copy reproduces the original EXACTLY
 * (7004 22d8 51c8fffc, MOVEQ #4 / MOVE.L (A0)+,(A1)+ / DBF), which is the
 * evidence that `tmp = *src;` is the right form. So does the whole predicate
 * chain and the wrap. Three items differ.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ffe4 ... 4e5d       LINK.W A5,#-28 / UNLK
 *   got:     9efc0018 ... defc0018   SUBA.W #24,A7 / ADDA.W #24,A7
 *   summary: the frame class. 6.51 also allocates 24 bytes where the original
 *            takes 28, because it needs no slot for the spill the original
 *            makes.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: struct-copy-tail-postincrement
 *   ref:     3290                    MOVE.W (A0),(A1)
 *   got:     32d8                    MOVE.W (A0)+,(A1)+
 *   summary: the trailing word of the 22-byte copy. The original stops
 *            incrementing because nothing reads the pointers afterwards; 6.51
 *            keeps the post-increment form. Same size, same effect.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: compare-register-order
 *   ref:     7232 b041               MOVEQ #50,D1 / CMP.W D1,D0   (x3)
 *   got:     7032 bc40               MOVEQ #50,D0 / CMP.W D0,D6   (x3)
 *   summary: the three bound compares use the opposite register pairing. Same
 *            constants (50, 20, 29), same branch conditions, same sizes.
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

long NEWGRID_ComputeDaySlotFromClock(struct NewGridClockData *src)
{
    struct NewGridClockData tmp;
    long  slot;
    short m;

    tmp  = *src;
    slot = (long)NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(&tmp);

    m = tmp.minutes;
    if (m >= 50 || (m >= 20 && m <= 29)) {
        slot++;
        if (slot > 48)
            slot = 1;
    }
    return slot;
}
