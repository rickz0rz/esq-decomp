/* RESTORES: DISPTEXT_MeasureCurrentLineLength
 * MODULE:   modules/groups/a/i/disptextb_p1.s
 * STATUS:   behavioural
 *
 * Flushes the pending line table, then measures the current line with the
 * graphics library. Both table lookups re-read DISPTEXT_CurrentLineIndex from
 * memory rather than holding it in a register, which is what the source form
 * below produces: the index is read twice because the call to
 * DISPTEXT_FinalizeLineTable can change it.
 *
 * The index is widened with MOVEQ #0 / MOVE.W, so it is unsigned. So is the
 * length: MOVEQ #0,D0 / MOVE.W (A1),D0.
 *
 * A leaf header is NOT used here. DISPTEXT_FinalizeLineTable is ESQ assembly,
 * so the graphics base must reload after it -- exactly the case
 * tools/a6_audit.py checks for.
 *
 * 68 ref vs 80 got. Two items, and they add up to the 12 bytes.
 *
 * SASC-MISMATCH: word-widening-idiom
 *   ref:     7000 3039xxxxxxxx        MOVEQ #0,D0 / MOVE.W index,D0      (8 bytes, twice)
 *   got:     3039xxxxxxxx 484042404840
 *                                     MOVE.W index,D0 / SWAP / CLR.W / SWAP (12 bytes, twice)
 *   summary: to widen an unsigned short to long the original clears the
 *            register first and moves the word into it; 6.51 loads the word and
 *            then clears the high half with SWAP/CLR.W/SWAP. Same value, 4 more
 *            bytes each time, and the index is widened twice, so 8 of the 12.
 *   tried:   an explicit (long) cast on each subscript -- no change, still 80
 *            bytes with the same SWAP/CLR.W/SWAP pairs. Declaring the index
 *            `short` instead of `unsigned short` DOES shrink it to 72, because
 *            EXT.L (48c0) is 2 bytes where the widening pair is 6. It is
 *            REJECTED: the original widens with MOVEQ #0 / MOVE.W, which is
 *            unsigned, and EXT.L is a sign extension. Taking those 8 bytes
 *            would mean picking the type for its width rather than its meaning,
 *            and it still would not match the original's idiom -- only trade
 *            one wrong one for a shorter wrong one.
 *   scope:   every unsigned-short global widened to long. Already noted in
 *            AGENTS.md under the (x << 3) vs (x * 8) row.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: a3-vs-a5-register-allocation
 *   ref:     2f0b 266f0008           MOVE.L A3,-(A7) / MOVEA.L 8(A7),A3
 *   got:     48e70006 2a6f000c       MOVEM.L A5/A6,-(A7) / MOVEA.L 12(A7),A5
 *   summary: the RastPort parameter lives in A3 in the original and A5 in 6.51,
 *            and 6.51 also adds A6 to the save mask where the original treats
 *            the library base as scratch. Both are settled classes.
 *   scope:   program-wide; docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause" and "OS library calls: one divergence left".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include "esq-graphics.h"

extern void            DISPTEXT_FinalizeLineTable(void);
extern unsigned short  DISPTEXT_CurrentLineIndex;
extern char           *DISPTEXT_LinePtrTable[];
extern unsigned short  DISPTEXT_LineLengthTable[];

long DISPTEXT_MeasureCurrentLineLength(struct RastPort *rp)
{
    DISPTEXT_FinalizeLineTable();
    return TextLength(rp,
                      DISPTEXT_LinePtrTable[DISPTEXT_CurrentLineIndex],
                      (long)DISPTEXT_LineLengthTable[DISPTEXT_CurrentLineIndex]);
}
