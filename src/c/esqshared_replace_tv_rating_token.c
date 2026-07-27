/* RESTORES: ESQSHARED_ReplaceTvRatingToken
 * MODULE:   modules/groups/a/p/esqshared.s
 * STATUS:   behavioural
 *
 * Scans the string for each of the seven TV-rating words in turn, and on the
 * first hit collapses the word to the single glyph byte the display font uses for
 * it: the glyph overwrites the first character and the remainder of the string is
 * shifted down over the rest of the word. Only one substitution is made per call
 * -- the flag both records the hit and ends the loop.
 *
 * 148 bytes in the original, 132 emitted. Every byte of the -16 is itemised
 * below; there is no unattributed remainder. Region counts are not quoted because
 * the lengths differ, so everything after the first divergence is misaligned.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff0 48e70730 266d0008   LINK.W A5,#-16 / MOVEM.L D5-D7/A2-A3
 *                                         / MOVEA.L 8(A5),A3
 *   got:     48e70736 2a6f0020            MOVEM.L D5-D7/A2-A3/A5-A6 / MOVEA.L 32(A7),A5
 *   summary: The A5-frame class. -4 in the prologue and -2 in the epilogue (no
 *            UNLK). It also hands 6.51 two more register variables, which is what
 *            the next entry is about.
 *   scope:   program-wide; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: spilled-hit-pointer
 *   ref:     2b40fffc / 226dfffc / 2b49fffc / 226dfffc   the match pointer written
 *                                                        to and reloaded from -4(A5)
 *   got:     2640 / 16d0 / 244b / 224b                   the same value held in A3
 *   summary: A consequence of the frame class. With A5 free the match pointer is a
 *            register variable, so the glyph store becomes MOVE.B (A0),(A3)+ rather
 *            than a reload plus MOVE.B D0,(A1)+. Four sites: -2, -6, -2, -2 = -12.
 *   retest:  a compiler that reserves A5 has one fewer address register here and
 *            should spill the same pointer to the same slot.
 *
 * SASC-MISMATCH: reload-vs-cache
 *   ref:     2450 ... 95d0             MOVEA.L (A0),A2 / SUBA.L (A0),A2
 *   got:     2250 2009 ... 93c0        MOVEA.L (A0),A1 / MOVE.L A1,D0 / SUBA.L D0,A1
 *   summary: The inlined strlen of the table entry. The original re-reads the
 *            table slot through (A0) to recover the scan base; 6.51 copies it to
 *            D0 first. This is the one site where the class costs bytes in the
 *            other direction: +2, and it is why the total is -16 and not -18.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the one cross-unit call.
 */
#include <proto/exec.h>
#include <string.h>

extern char *GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(char *hay, char *needle);
extern char *Global_TBL_TV_PROGRAM_RATINGS[];
extern char ESQPARS2_TvRatingTokenGlyphMap[];

void ESQSHARED_ReplaceTvRatingToken(char *s)
{
    char *hit;
    char *rest;
    long tail;
    long i;
    short replaced;

    replaced = 0;
    for (i = 0; i < 7 && !replaced; i++) {
        hit = GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(s, Global_TBL_TV_PROGRAM_RATINGS[i]);
        if (hit) {
            *hit++ = ESQPARS2_TvRatingTokenGlyphMap[i];
            tail = (long)strlen(Global_TBL_TV_PROGRAM_RATINGS[i]) - 1;
            rest = hit + tail;
            CopyMem(rest, hit, (long)strlen(rest) + 1);
            replaced = 1;
        }
    }
}
