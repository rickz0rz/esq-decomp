/* RESTORES: NEWGRID_SetRowColor
 * MODULE:   modules/groups/b/a/newgrid1_p0.s
 * STATUS:   behavioural
 *
 * Maps a row selector to a pen, stores a colour byte in the row's pen array at
 * the slot that pen owns, and returns the pen.
 *
 * The selector dispatch is a CHAINED SUBTRACT, not a compare chain:
 *
 *   MOVE.L D7,D0 / ADDQ.W #1,D0 / BEQ    -> case -1
 *   SUBQ.W #1,D0 / BEQ                   -> case  0
 *   SUBQ.W #1,D0 / BEQ                   -> case  1
 *   SUBQ.W #1,D0 / BEQ                   -> case  2
 *   BRA                                  -> default
 *
 * Each test consumes the running difference. AGENTS.md records that an
 * if/else chain gives independent compares and only `switch` gives this shape,
 * and that the selector must be a short for the arithmetic to stay at word
 * width -- which is why the parameter is read as MOVE.W 26(A7),D7.
 *
 * The default and case 0 both produce pen 4 and are kept as separate arms,
 * because the original emits two separate MOVEQ #4 (7a04 at 0x2145c and again
 * at 0x21468). Merging them would drop one.
 *
 * The pen array is indexed by `pen - 4`, so pens 4..7 map to slots 0..3 at
 * offset 55.
 *
 * The colour guard is a signed range test on a long (TST.L / BMI, then
 * CMP.L #16 / BGT), so out-of-range means below zero or above 16, and both
 * store the literal 7.
 *
 * OPTIONS: SHORTINT (per-file, and load-bearing -- see below).
 *
 * 92 ref vs 92 got, and this one is worth reading rather than trusting the
 * equal size, because equal size is not evidence (AGENTS.md rule 1). The
 * dispatch chain itself is now VERBATIM:
 *
 *     ref  5240 670e 5340 670e 5340 670e 5340 670e 6010
 *     got  5240 670e 5340 670e 5340 670e 5340 670e 6010
 *
 * and so are all five MOVEQ arms with their branches
 * (7a07 600e 7a04 600a 7a05 6006 7a06 6002 7a04).
 *
 * SHORTINT is what buys that. Without it the chain widens to long --
 * MOVE.W D7,D0 / EXT.L D0 / ADDQ.L #1,D0 / SUBQ.L #1,D0 x3 -- which is 2 bytes
 * more and, more to the point, the wrong idiom. This is the third sighting of
 * the pairing AGENTS.md records: a chained-subtract dispatch wants `switch`
 * and `SHORTINT` together, and neither alone reproduces it.
 *
 * Three items remain, and they cancel to zero, which is exactly why the equal
 * size proves nothing on its own.
 *
 * SASC-MISMATCH: a3-vs-a5-register-allocation
 *   ref:     48e70710 266f0014 3e2f001a 2c2f001c   D5-D7/A3, ptr then word then long
 *   got:     48e70f04 2c2f001e 3e2f001c 2a6f0018   D4-D7/A5, long then word then ptr
 *   summary: different address register and the documented descending-versus-
 *            ascending parameter load order. Same three loads, same widths,
 *            same total size.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause" and "Parameter and case layout".
 *   retest:  a compiler that reserves A5; the same doc gives the probe.
 *
 * SASC-MISMATCH: redundant-result-copy
 *   ref:     2005 5980 2e00     MOVE.L D5,D0 / SUBQ.L #4,D0 / MOVE.L D0,D7
 *   got:     2805 5984          MOVE.L D5,D4 / SUBQ.L #4,D4
 *   summary: the original computes the slot index into D0 and then copies it to
 *            D7; 6.51 computes it straight into the register it will index
 *            with. The extra copy is 2 bytes the original spends and we do not.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: case-body-layout
 *   ref:     6e08 2006 17807037 6006 17bc00077037   BGT / in-range store / BRA / default store
 *   got:     6f08 1bbc00074837 6006 2006 1b804837   BLE / default store / BRA / in-range store
 *   summary: 6.51 inverts the range test and emits the two stores in the
 *            opposite order. Same two stores, same operands, same sizes; only
 *            which one falls through. This is the documented case-body-layout
 *            class, and it is the reason the region count here is misleading.
 *   tried:   writing the guard the other way round (testing the in-range case
 *            first) does not move it; the ordering is chosen after the source
 *            form.
 *   scope:   program-wide. docs/compiler-version.md, "Parameter and case
 *            layout".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * So this is a `no-calls` function with NO call-encoding blocker at all, and it
 * still does not reach exact -- the remaining three classes are all register
 * allocation and block placement, none of which the source can reach.
 */
struct NewGridColorRow {
    char pad0[55];
    char pens[4];               /* +55 */
};

long NEWGRID_SetRowColor(struct NewGridColorRow *row, short which, long value)
{
    long pen;
    long idx;

    switch (which) {
    case -1: pen = 7; break;
    case  0: pen = 4; break;
    case  1: pen = 5; break;
    case  2: pen = 6; break;
    default: pen = 4; break;
    }

    idx = pen - 4;
    if (value < 0 || value > 16)
        row->pens[idx] = 7;
    else
        row->pens[idx] = (char)value;

    return pen;
}
