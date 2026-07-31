/* RESTORES: LADFUNC_DisplayTextPackedPens
 * MODULE:   modules/groups/a/w/ladfunc_p1.s
 * STATUS:   behavioural
 *
 * Unpacks a byte holding two pen numbers, sets them as the A and B pens, and
 * draws text.
 *
 * The LOW nibble is the A pen and the HIGH nibble is the B pen -- the original
 * calls GetPackedPenLowNibble before SetAPen and GetPackedPenHighNibble before
 * SetBPen, in that order. Swapping them draws the right characters in the wrong
 * colours, which no byte comparison would catch.
 *
 * The packed byte is widened before each call and the byte RESULT is widened
 * again before each pen call, so both helpers take and return unsigned bytes.
 *
 * The volatile graphics header is required: both nibble helpers are ESQ
 * assembly and do not preserve A6, which is exactly why the original reloads
 * the base before SetAPen AND again before SetBPen rather than caching it
 * across the pair. This is one of the cases where the volatile header
 * reproduces the original's reload pattern exactly rather than costing bytes.
 *
 * 102 ref vs 108 got. Both nibble calls, both byte widenings on the way in and
 * out, both pen calls with their base reloads, the argument-slot reuse and the
 * LEA 16(A7),A7 cleanup all match in kind and size -- including the two
 * graphics-base loads, which the volatile header gets exactly right here.
 *
 * SASC-MISMATCH: a3-vs-a5-register-allocation
 *   ref:     48e70730 266f0018 224b 2e8a 2f0b    A2/A3/D5-D7
 *   got:     48e70716 266f002c 224d 2e8b 2f0d    A3/A5 as well
 *   summary: 6.51 needs one more saved register than the original and loads the
 *            parameters in the opposite order. Same instructions otherwise; the
 *            extra MOVEM entry and the padding are the 6 bytes.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause" and "Parameter and case layout".
 *   retest:  a compiler that reserves A5; the same doc gives the probe.
 */
#include "esq-graphics.h"

extern unsigned char LADFUNC_GetPackedPenLowNibble(long packed);
extern unsigned char LADFUNC_GetPackedPenHighNibble(long packed);
extern void GROUP_AW_JMPTBL_DISPLIB_DisplayTextAtPosition(struct RastPort *rp,
                                                          long x, long y,
                                                          char *text);

void LADFUNC_DisplayTextPackedPens(struct RastPort *rp, long x, long y,
                                   char packed, char *text)
{
    SetAPen(rp, (long)LADFUNC_GetPackedPenLowNibble((long)(unsigned char)packed));
    SetBPen(rp, (long)LADFUNC_GetPackedPenHighNibble((long)(unsigned char)packed));

    GROUP_AW_JMPTBL_DISPLIB_DisplayTextAtPosition(rp, x, y, text);
}
