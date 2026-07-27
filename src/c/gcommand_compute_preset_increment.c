/* RESTORES: GCOMMAND_ComputePresetIncrement
 * MODULE:   modules/groups/a/u/gcommand3b.s
 * STATUS:   behavioural
 *
 * Works out the per-step increment for a preset sweep: the preset's step count
 * scaled by 1000 and divided by the usable span. Returns 0 for an out-of-range
 * preset index, a span of 4 or less, or a usable span that works out to zero.
 *
 * The 1000 is fixed-point scaling -- the caller divides back down -- which is why
 * the result is computed as a long even though both inputs are small.
 *
 * 98 bytes in the original, 106 emitted plus one alignment NOP. The +8 is the
 * frame class (-6) against the inlined multiply (+10) and a branch shape (+4).
 *
 * The three range guards are ONE `||` expression, not three separate `if`s. Both
 * forms give the original's three branches to a shared target, but the separate
 * form makes 6.51 emit `CMPI.L #16,D7` (6 bytes) where the original has
 * `MOVEQ #16,D1` + `CMP.L D1,D7` (4). Written as a chain it emits the short form
 * at all three sites, which is +12 recovered. That is a new observation about the
 * constant rule: it applies to COMPARISON operands too, and whether 6.51 uses the
 * short form depends on the surrounding expression, not just the value.
 *
 * SASC-MISMATCH: multiply-strength-reduction
 *   ref:     223c000003e8 4eba5734   MOVE.L #1000,D1 / JSR MATH_Mulu32
 *   got:     ed81 9284 ...           inline shift/subtract chain
 *   summary: `* 1000`. The documented class -- the original calls the runtime
 *            helper (register arguments in D0/D1), 6.51 expands it inline. +10,
 *            the whole remaining cost.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff4 / 2b40fff4 / 4e5d
 *   got:     594f / the result kept in D0 / 584f
 *   summary: -6. The original stores the result local to -12(A5) at both exits
 *            even though the return value is already in D0.
 */

extern short GCOMMAND_DefaultPresetTable[];

long GCOMMAND_ComputePresetIncrement(long index, long span)
{
    long result;
    long steps;
    long usable;

    result = 0;
    if (index < 0 || index >= 16 || span <= 4)
        return result;

    steps = GCOMMAND_DefaultPresetTable[index] - 1;
    usable = span - 5;
    if (usable <= 0)
        result = 0;
    else
        result = steps * 1000 / usable;

    return result;
}
