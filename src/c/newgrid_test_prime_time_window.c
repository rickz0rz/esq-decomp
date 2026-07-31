/* RESTORES: NEWGRID_TestPrimeTimeWindow
 * MODULE:   modules/groups/b/a/newgrid1bb_p1.s
 * STATUS:   behavioural
 *
 * Classifies an entry by the second character of the string at +48 and, for
 * the 'P' case only, by whether the hour falls inside the prime-time window.
 *
 * The dispatch is a CHAINED SUBTRACT on a word, and the constants are the gaps
 * between the letters rather than the letters themselves:
 *
 *   SUBI.W #'N'          -> 'N'
 *   SUBQ.W #2            -> 'P'   ('P' - 'N' == 2)
 *   SUBI.W #30           -> 'n'   ('n' - 'P' == 30)
 *   SUBQ.W #2            -> 'p'   ('p' - 'n' == 2)
 *
 * That is the shape AGENTS.md says wants `switch` plus SHORTINT together, so
 * the four letters are written as ordinary case labels and the compiler is
 * left to find the chain.
 *
 * The three outcomes read off the branch targets:
 *   'N' or 'n'  -> 0
 *   'P' or 'p'  -> 1 only when 18 < hour < 22, else 0
 *   anything else -> 1
 *
 * The window test is strict on both ends: MOVEQ #18 / CMP.L / BLE leaves, and
 * MOVEQ #22 / CMP.L / BGE leaves, so 19, 20 and 21 pass.
 *
 * THE DOUBLED NULL TEST IS IN THE ORIGINAL. It loads 48(A3) once, stores it to
 * a frame local, and then tests the same register for zero TWICE in a row
 * (2008 6738 / 2008 6734) with nothing in between. Both branches go to the
 * same exit. It is written here as two statements so the shape is recorded,
 * and 6.51 DOES keep both -- the emitted code tests the pointer three times in
 * all, once for the entry and twice for the string.
 *
 * OPTIONS: SHORTINT (per-file, and load-bearing).
 *
 * 100 ref vs 100 got, and the equal size is backed by the structure rather
 * than standing on its own. The whole dispatch is VERBATIM:
 *
 *     ref  0440004e 6710 5540 6710 0440001e 6706 5540 6706 6014
 *     got  0440004e 6710 5540 6710 0440001e 6706 5540 6706 6014
 *
 * and so is the entire window test and result tail
 * (7012 be80 6f0c 7016 be80 6c06 ... 6002 ... 2006).
 *
 * SHORTINT is what buys the chain. Without it the four compares widen and the
 * function goes to 104 bytes with the letters materialised differently
 * (724e 9081 / 721e 9081 instead of the SUBI.W/SUBQ.W pairs). This is the
 * fourth sighting of the pairing AGENTS.md records: a chained-subtract
 * dispatch wants `switch` and `SHORTINT` together.
 *
 * SASC-MISMATCH: early-return-vs-common-exit
 *   ref:     200b 6744            MOVE.L A3,D0 / BEQ <common exit>
 *   got:     200d 6604 2006 604a  MOVE.L A5,D0 / BNE +4 / MOVE.L D6,D0 / BRA
 *   summary: the original branches straight to the shared epilogue from each
 *            guard; 6.51 inverts the test and jumps over a load-and-branch
 *            pair. Same three guards, same outcome, 4 bytes more each -- which
 *            is offset elsewhere by the register-allocation differences, so
 *            the totals agree by coincidence rather than by fidelity.
 *   tried:   writing the guards as one combined `if` instead of three early
 *            returns. That collapses the doubled null test, which is WORSE:
 *            the doubling is in the original and is the more informative
 *            property to keep.
 *   scope:   any function with several early returns.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: link-frame-vs-none
 *   ref:     4e55fff8 ... 4e5d    LINK.W A5,#-8 / UNLK
 *   got:     (nothing)
 *   summary: the original's frame exists only for the dead spill of the string
 *            pointer to -4(A5), which nothing reads back. The frame class.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct NewGridPrimeEntry {
    char  pad0[48];
    char *text;                 /* +48 */
};

long NEWGRID_TestPrimeTimeWindow(long hour, struct NewGridPrimeEntry *e)
{
    char *s;
    long  r = 0;

    if (e == 0)
        return r;

    s = e->text;
    if (s == 0)
        return r;
    if (s == 0)
        return r;

    switch (s[1]) {
    case 'N':
    case 'n':
        r = 0;
        break;
    case 'P':
    case 'p':
        if (hour > 18 && hour < 22)
            r = 1;
        break;
    default:
        r = 1;
        break;
    }
    return r;
}
