/* RESTORES: TLIBA1_DrawInlineStyledText
 * MODULE:   modules/groups/b/a/tliba1_p1.s
 * STATUS:   behavioural
 *
 * Draws a line of text containing INLINE STYLE ESCAPES, rewriting the caller's
 * string in place as it goes. There are three completely separate paths and
 * they are chosen by which escape character the text contains.
 *
 * IT MODIFIES THE CALLER'S STRING. Every path except the last one edits the
 * text: escapes are rewritten to a two-byte 0x13/0x14 bracket and the rest of
 * the line is shifted down over them. A caller that needs the original text
 * must copy it first.
 *
 * PATH 1 -- the aligned-inset gate. If the gate flag is set AND the text has
 * both a 19 and a 20, the nibbles come from the CLEANUP globals rather than
 * from the text, and the gate is CLEARED on the way out. It is a one-shot: the
 * next call takes another path.
 *
 * PATH 2 -- character 30 escapes, processed in a loop until none remain. Each
 * escape is a run of bytes above 0x20 following the 30. Two style codes are
 * parsed from the two bytes after the marker, and the run is either converted
 * to a bracket or DELETED outright.
 *
 * THE VALIDITY TEST ACCEPTS 255 OR 1..7 FOR EACH NIBBLE, and rejects everything
 * else including ZERO -- the low bound is `BCS` against 1 on an unsigned byte,
 * so 0 fails. 255 is the "unset" marker and is explicitly allowed. A run whose
 * codes fail, or whose fourth byte is not above 0x20, is spliced out of the
 * string entirely rather than rendered.
 *
 * THE WIDTH BOOKKEEPING IS THE POINT OF PATH 2. Every escape run contributes
 * its full width to one total and its VISIBLE width to another; the difference,
 * halved, shifts the drawing origin. That is what keeps styled text centred
 * against unstyled text of the same nominal length. A high nibble other than
 * 255 adds a further 8 pixels, which is the inset the bracket renders.
 *
 * THE SPLICE IS THREE MOVES, NOT ONE. The marker becomes 0x13, the two style
 * bytes are shifted out by moving the rest of the run down two, a 0x14 is
 * written two before the run end, and the tail of the string is moved to close
 * the gap. Doing it in one move loses the bracket.
 *
 * PATH 3 -- a character 23 escape, handled once rather than in a loop, with the
 * nibbles extracted by two separate helper calls instead of the style parser.
 * The bounds check here writes 255 for a bad HIGH nibble and MINUS ONE for a
 * bad low one. Both reach the draw call as an unsigned byte, so both arrive as
 * 255 -- but they are different constants in the original and are kept
 * different here.
 *
 * PATH 4 -- no escape at all, so the plain text drawer is called and nothing is
 * modified.
 *
 * MEM_Move TAKES (source, destination, count), same as in
 * ladfunc_repack_entry_text_and_attr_buffers.c: the original pushes the
 * moved-from pointer last.
 *
 * BOTH ORIGIN SHIFTS ROUND TOWARD ZERO on a negative value -- the
 * `TST.L / BPL / ADDQ.L #1 / ASR.L #1` sequence -- which `d / 2` on a signed
 * long reproduces. The path-2 difference genuinely can be negative when the
 * inset width exceeds the run width.
 *
 * 768 ref vs 780 got, 26 differing regions. The gate test with both character
 * searches, all four escape searches, the run scan with its unsigned 0x20
 * bound, both style-parser calls, the two-part validity test including its
 * rejection of zero, all four MEM_Move splices with their distinct counts, both
 * TextLength measurements in the loop, the 8-pixel inset addition, both
 * round-toward-zero halvings, both nibble extractions with their differing
 * failure constants, the in-place compression loop and all four terminal draw
 * calls match in kind and size.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ffe8 ... 2b40ffee   LINK.W A5,#-24 / MOVE.L D0,-18(A5)
 *   got:     both width accumulators kept in registers
 *   summary: the frame class. The original spills both accumulators and the
 *            segment length across the TextLength calls; 6.51 keeps two of
 *            them live and reloads at the call boundaries. Net 12 bytes over.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>
#include "esq-graphics.h"

extern char *STR_FindCharPtr(char *s, long ch);
extern void  MEM_Move(char *src, char *dst, long n);
extern unsigned char TLIBA1_ParseStyleCodeChar(long ch);
extern long  TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble(long b);
extern long  TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble(long b);
extern void  TLIBA1_DrawTextWithInsetSegments(struct RastPort *rp, long x,
                                              long y, long low, long high,
                                              char *text);
extern void  UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(struct RastPort *rp,
                                                          long x, long y,
                                                          char *text);

extern char CLOCK_AlignedInsetRenderGateFlag;
extern unsigned char CLEANUP_AlignedInsetNibblePrimary;
extern unsigned char CLEANUP_AlignedInsetNibbleSecondary;

void TLIBA1_DrawInlineStyledText(struct RastPort *rp, long x, long y,
                                 char *text)
{
    char *seg;
    char *cur;
    char *p;
    unsigned char styleA;
    long  styleB;
    long  totalWidth;
    long  insetWidth;
    long  segLen;
    long  d;

    insetWidth = totalWidth = 0;

    if (CLOCK_AlignedInsetRenderGateFlag != 0
        && STR_FindCharPtr(text, 19L) != 0
        && STR_FindCharPtr(text, 20L) != 0) {

        TLIBA1_DrawTextWithInsetSegments(
            rp, x, y, (long)CLEANUP_AlignedInsetNibbleSecondary,
            (long)CLEANUP_AlignedInsetNibblePrimary, text);

        CLOCK_AlignedInsetRenderGateFlag = 0;
        return;
    }

    seg = STR_FindCharPtr(text, 30L);

    if (seg != 0) {

        do {
            segLen = 1;
            cur    = seg + 1;

            while ((unsigned char)*cur > 0x20) {
                cur++;
                segLen++;
            }

            totalWidth += TextLength(rp, seg, segLen);

            if (segLen > 2) {
                styleA = TLIBA1_ParseStyleCodeChar((long)(unsigned char)seg[1]);
                styleB = (long)TLIBA1_ParseStyleCodeChar(
                             (long)(unsigned char)seg[2]);
            } else {
                styleB = 0;
                styleA = 0;
            }

            if ((styleA == 255
                 || ((unsigned char)styleA >= 1 && (unsigned char)styleA <= 7))
                && ((unsigned char)styleB == 255
                    || ((unsigned char)styleB >= 1
                        && (unsigned char)styleB <= 7))
                && (unsigned char)seg[3] > 0x20) {

                seg[0] = 0x13;

                MEM_Move(seg + 3, seg + 1, segLen - 3);

                p     = seg + segLen;
                p[-2] = 0x14;
                p--;

                MEM_Move(cur, p, strlen(cur) + 1);

                insetWidth += TextLength(rp, seg + 1, segLen - 3);

                if (styleA != 255)
                    insetWidth += 8;

            } else {
                MEM_Move(cur, seg, strlen(cur) + 1);
            }

            seg = STR_FindCharPtr(text, 30L);

        } while (seg != 0);

        d = totalWidth - insetWidth;
        d = d / 2;
        x += d;

        TLIBA1_DrawTextWithInsetSegments(rp, x, y, (long)(unsigned char)styleB,
                                         (long)styleA, text);
        return;
    }

    seg = STR_FindCharPtr(text, 23L);

    if (seg == 0) {
        UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(rp, x, y, text);
        return;
    }

    *seg++ = 0x13;

    d = TextLength(rp, seg, 1L);
    d = d / 2;
    x += d;

    styleA = (unsigned char)TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble(
                 (long)(unsigned char)*seg);
    if (styleA < 1 || styleA > 7)
        styleA = 0xff;

    styleB = TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble(
                 (long)(unsigned char)*seg);
    if ((unsigned char)styleB < 1 || (unsigned char)styleB > 7)
        styleB = -1;

    while ((unsigned char)seg[1] > 32) {
        seg[0] = seg[1];
        seg++;
    }

    *seg = 0x14;

    TLIBA1_DrawTextWithInsetSegments(rp, x, y, (long)(unsigned char)styleB,
                                     (long)styleA, text);
}
