/* RESTORES: GCOMMAND_UpdateBannerRowPointers
 * MODULE:   modules/groups/a/u/gcommand3b_p2_p1.s
 * STATUS:   behavioural
 *
 * Repoints two copper MOVE instructions when the banner row index changes: the
 * NEW row is pointed at the shared tail, and the OLD row is pointed either back
 * at its own data or, when it was the last row, at the wrap tail.
 *
 * A copper pointer is TWO SEPARATE WORDS, and they are not adjacent: the high
 * half goes to +0x2fa of the row and the low half to +0x2fe. Both are extracted
 * from the address the same way the original does -- CLR.W then SWAP for the
 * high half, AND with 0xffff for the low.
 *
 * The row stride is 32 (ASL.L #5), and the three data offsets are 772 for a
 * row's own data, 3916 for the shared tail and 3876 for the wrap tail.
 *
 * The early exit is on the two indices being EQUAL, so a tick that did not move
 * the row does nothing.
 *
 * The original recomputes every address rather than holding it -- the +772
 * address is built TWICE (once for each half) and so is the +3916 one. The C
 * below recomputes for the same reason; hoisting would collapse them.
 *
 * This is a `no-calls` function, so nothing structural caps it at behavioural.
 *
 * 202 ref vs 180 got. Both word-extraction idioms are present in both
 * (CLR.W / SWAP for the high half, an AND with 0xffff for the low), all three
 * data offsets (772, 3916, 3876) and both copper word offsets (0x2fa, 0x2fe)
 * match, as does the ASL.L #5 row stride at every site.
 *
 * SASC-MISMATCH: address-recomputation
 *   ref:     204b d1c0 43e80304 (twice) / 41eb0f4c (twice) / 41eb0f24 (twice)
 *            every address rebuilt from A3 for each half
 *   got:     43ed0f4c / 43ea02fa / 47ea02fe ...
 *            6.51 folds the constant offsets into the addressing modes and
 *            reuses one base per pair
 *   summary: the original recomputes each address separately for the high and
 *            the low word; 6.51 computes it once and reaches both words with
 *            two displacements off the same register. Same six stores to the
 *            same six addresses, 22 bytes fewer.
 *   tried:   writing each half through its own freshly-built expression, which
 *            is what the C already does -- the source recomputes and 6.51
 *            commons it up anyway. This is common-subexpression elimination,
 *            not a spelling choice.
 *   scope:   any function that builds several addresses off one base.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern long GCOMMAND_BannerRowIndexPrevious;
extern long GCOMMAND_BannerRowIndexCurrent;

void GCOMMAND_UpdateBannerRowPointers(char *list)
{
    unsigned long  addr;
    unsigned short prevHi;
    unsigned short prevLo;
    long prev;
    long cur;

    prev = GCOMMAND_BannerRowIndexPrevious;
    cur  = GCOMMAND_BannerRowIndexCurrent;

    if (cur == prev)
        return;

    addr   = (unsigned long)(list + (prev << 5) + 772);
    prevHi = (unsigned short)(addr >> 16);

    addr   = (unsigned long)(list + (prev << 5) + 772);
    prevLo = (unsigned short)(addr & 0xffffL);

    addr = (unsigned long)(list + 3916);
    *(unsigned short *)(list + (cur << 5) + 0x2fa) = (unsigned short)(addr >> 16);

    addr = (unsigned long)(list + 3916);
    *(unsigned short *)(list + (cur << 5) + 0x2fe) =
        (unsigned short)(addr & 0xffffL);

    if (GCOMMAND_BannerRowIndexPrevious == 97) {

        addr = (unsigned long)(list + 3876);
        *(unsigned short *)(list + (prev << 5) + 0x2fa) =
            (unsigned short)(addr >> 16);

        addr = (unsigned long)(list + 3876);
        *(unsigned short *)(list + (prev << 5) + 0x2fe) =
            (unsigned short)(addr & 0xffffL);

    } else {
        *(unsigned short *)(list + (prev << 5) + 0x2fa) = prevHi;
        *(unsigned short *)(list + (prev << 5) + 0x2fe) = prevLo;
    }
}
