/* RESTORES: GCOMMAND_UpdateBannerOffset
 * MODULE:   modules/groups/a/u/gcommand3b_p4_p0.s
 * STATUS:   behavioural
 *
 * Moves the banner row index by a signed byte delta, normalizes it into
 * [0, 98), and repoints both copper lists.
 *
 * The normalization is TWO SEPARATE LOOPS, not a modulo. The original branches
 * back to each loop head (BRA -0x16 and BRA -0x14), so a large positive value
 * is brought down 98 at a time and a negative one is brought up 98 at a time.
 * Writing it as `% 98` would emit a helper call and would also give the wrong
 * sign for negatives.
 *
 * The delta is a CHAR -- a byte at 11(A7) widened with the EXT.W / EXT.L pair.
 * A zero delta returns before touching anything, including the previous-index
 * store.
 *
 * All three globals are read and written in place; the original re-reads
 * BannerRowIndexCurrent at the top of each loop rather than holding it.
 *
 * 102 ref vs 102 got, and the structure backs it. BOTH normalization loops are
 * VERBATIM -- 7262 b081 6d0a 7262 93b9.... 60ea for the down-loop and
 * 4a80 6a0a 7262 d3b9.... 60ec for the up-loop, including the branch
 * displacements. So are the previous-index store, both PEA list addresses and
 * the ADDQ.W #8,A7. One item differs and it costs nothing.
 *
 * SASC-MISMATCH: delta-widened-from-register-vs-memory
 *   ref:     2207 4881 48c1     MOVE.L D7,D1 / EXT.W D1 / EXT.L D1
 *   got:     1007 4880 48c0     MOVE.B D7,D0 / EXT.W D0 / EXT.L D0
 *   summary: the original copies the whole longword out of the parameter
 *            register before narrowing it with the EXT pair; 6.51 copies the
 *            byte. Both end with the same sign-extended long, same three
 *            instructions, same six bytes, one register apart.
 *   scope:   the A3/A5-family allocation difference. docs/compiler-version.md,
 *            "A third divergence: register allocation order".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern void GCOMMAND_UpdateBannerRowPointers(unsigned char *list);

extern long GCOMMAND_BannerRowIndexCurrent;
extern long GCOMMAND_BannerRowIndexPrevious;
extern unsigned char ESQ_CopperListBannerA[];
extern unsigned char ESQ_CopperListBannerB[];

void GCOMMAND_UpdateBannerOffset(char delta)
{
    if (delta == 0)
        return;

    GCOMMAND_BannerRowIndexPrevious = GCOMMAND_BannerRowIndexCurrent;
    GCOMMAND_BannerRowIndexCurrent -= (long)delta;

    while (GCOMMAND_BannerRowIndexCurrent >= 98)
        GCOMMAND_BannerRowIndexCurrent -= 98;

    while (GCOMMAND_BannerRowIndexCurrent < 0)
        GCOMMAND_BannerRowIndexCurrent += 98;

    GCOMMAND_UpdateBannerRowPointers(ESQ_CopperListBannerA);
    GCOMMAND_UpdateBannerRowPointers(ESQ_CopperListBannerB);
}
