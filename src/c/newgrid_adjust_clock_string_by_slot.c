/* RESTORES: NEWGRID_AdjustClockStringBySlot
 * MODULE:   modules/groups/b/a/newgrid_p2_p0.s
 * STATUS:   behavioural
 *
 * Takes a copy of a 22-byte clock record, winds it back to the start of its
 * half-hour slot, and returns the slot index for the adjusted time.
 *
 * The rewind amount is 60 * (CLOCK_FormatVariantCode % 30) seconds, and the
 * REMAINDER is the point. The original calls MATH_DivS32 with the variant code
 * in D0 and 30 in D1, which leaves the quotient in D0 and the remainder in D1;
 * it then OVERWRITES D0 with MOVEQ #60 and calls MATH_Mulu32, so the multiply
 * operands are 60 and the surviving D1. The quotient is discarded. Reading
 * this as a divide rather than a modulo gives silently wrong times -- the same
 * trap recorded in tliba3_get_view_mode_height.c.
 *
 * The copy here is BYTE-at-a-time (MOVEQ #21 / MOVE.B (A0)+,(A1)+ / DBF), so
 * the parameter is a char buffer and memcpy is the faithful form. Note this
 * differs from newgrid_compute_day_slot_from_clock.c, which copies the SAME 22
 * bytes with a MOVE.L loop because there the value has a struct type. The two
 * spellings are both correct for their own function; AGENTS.md records the
 * pairing in both directions.
 *
 * 86 ref vs 92 got. The copy loop matches the original exactly
 * (7015 / 12d8 / 51c8fffc), and so does the MOVEQ #30 divisor setup and the
 * SUB.L D0,D7.
 *
 * SASC-MISMATCH: mul32-helper-vs-inline
 *   ref:     703c 4eba08a4      MOVEQ #60,D0 / JSR _MATH_Mulu32(PC)      (6 bytes)
 *   got:     2001 e980 9081 e580
 *                               MOVE.L D1,D0 / ASL.L #4,D0 / SUB.L D1,D0 /
 *                               ASL.L #2,D0                              (8 bytes)
 *   summary: the * 60 goes to the 32-bit multiply helper in the original and is
 *            strength-reduced inline by 6.51 -- 60 = (16 - 1) * 4, which is
 *            what the emitted chain computes. Same product, 2 bytes more.
 *            Already recorded in docs/compiler-version.md, "Arithmetic: three
 *            more classes" (32-bit multiply: original calls, 6.51 inlines).
 *   retest:  a compiler that emits a helper call for a 32-bit constant
 *            multiply.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ffe4 ... 4ced0880ffdc 4e5d    LINK.W A5,#-28 / MOVEM / UNLK
 *   got:     9efc0018 ... 4fef0010 4cdf2080 defc0018
 *   summary: the frame class -- 6.51 keeps no frame pointer and pops its call
 *            arguments explicitly. The remaining 4 bytes.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>

extern long NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds(char *rec);
extern void NEWGRID_JMPTBL_DATETIME_SecondsToStruct(long secs, char *rec);
extern long NEWGRID_ComputeDaySlotFromClock(char *rec);
extern unsigned char CLOCK_FormatVariantCode;

long NEWGRID_AdjustClockStringBySlot(char *clock)
{
    char tmp[22];
    long secs;

    memcpy(tmp, clock, 22);
    secs = NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds(tmp);
    secs -= 60 * ((long)CLOCK_FormatVariantCode % 30);
    NEWGRID_JMPTBL_DATETIME_SecondsToStruct(secs, tmp);

    return NEWGRID_ComputeDaySlotFromClock(tmp);
}
