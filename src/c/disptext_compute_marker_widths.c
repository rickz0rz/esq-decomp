/* RESTORES: DISPTEXT_ComputeMarkerWidths
 * MODULE:   modules/groups/a/i/disptext_p2.s
 * STATUS:   behavioural
 *
 * Asks the grid for four selection-marker characters, measures TWO of them,
 * and stores the combined pixel width.
 *
 * Only the first and third markers are measured. The original writes four
 * one-byte locals at -1, -2, -3 and -4 and then reads only -1(A5) and -3(A5),
 * so two of the four are collected and discarded. They are still passed,
 * because the marker call writes through all four pointers.
 *
 * Each measurement is guarded: a zero byte contributes 0 rather than being
 * measured, so an absent marker costs nothing.
 *
 * Each TextLength is given a length of 1 and the ADDRESS of the local, which is
 * why the locals are chars rather than a string.
 *
 * The volatile graphics header is right here: the marker call is ESQ assembly
 * and does not preserve A6, and the original duly reloads the base before each
 * of the two TextLength calls rather than caching it across them.
 *
 * 126 ref vs 128 got. All four PEA local addresses, both argument pushes, the
 * LEA 24(A7),A7 cleanup, both TST.B guards, both MOVEQ #1 lengths, both
 * TextLength calls with their base reloads and the final ADD.L / store all
 * match exactly -- including the fact that the original reloads the graphics
 * base before EACH TextLength, which is what the volatile header gives.
 *
 * SASC-MISMATCH: byte-result-widened
 *   ref:     600270002a00        BRA / MOVEQ #0,D0 / MOVE.L D0,D5
 *   got:     3a0048c560027a00    MOVE.W D0,D5 / EXT.L D5 / BRA / MOVEQ #0,D5
 *   summary: 6.51 narrows the TextLength result to a word and sign-extends it
 *            back, where the original keeps the full long. Same value for any
 *            real text width, 2 bytes more at each of the two sites, and the
 *            other 2 come back from the frame class -- 6.51 uses SUBQ.W #4,A7
 *            against the original LINK.W A5,#-12.
 *   tried:   nothing from the source side; the widths are already plain longs.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include "esq-graphics.h"

extern void GROUP_AI_JMPTBL_NEWGRID_SetSelectionMarkers(long a, long b,
                                                        char *m1, char *m2,
                                                        char *m3, char *m4);
extern long DISPTEXT_ControlMarkerWidthPx;

void DISPTEXT_ComputeMarkerWidths(struct RastPort *rp, long a, long b)
{
    char m1, m2, m3, m4;
    long w1, w3;

    GROUP_AI_JMPTBL_NEWGRID_SetSelectionMarkers(a, b, &m1, &m2, &m3, &m4);

    if (m1)
        w1 = TextLength(rp, &m1, 1L);
    else
        w1 = 0;

    if (m3)
        w3 = TextLength(rp, &m3, 1L);
    else
        w3 = 0;

    DISPTEXT_ControlMarkerWidthPx = w1 + w3;
}
