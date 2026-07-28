/* RESTORES: _TEXTDISP_TrimTextToPixelWidth
 * MODULE:   modules/groups/b/a/textdisp3_p1_p5_textdisp_trimtexttopixelwidth.s
 * STATUS:   behavioural
 *
 * Break a string so it fits maxWidth pixels: walk it accumulating per-character
 * widths, and when the accumulator passes the limit, overwrite the LAST SPACE
 * seen with the current fill byte and restart measuring from just after it. A
 * control byte of 24 or 25 in the text sets the fill byte and also restarts the
 * measurement. Bails out if there is no space to break at, which is why a single
 * over-long word is left over-long.
 *
 * The fill byte starts at 25, so text with no control prefix breaks with 25.
 *
 * Three separate inlined strlen scan loops (TST.B (An)+ / BNE, then SUBQ #1 and
 * SUBA of the start) -- one per restart point. Written as strlen() calls, which
 * inline to exactly that; see AGENTS.md.
 *
 * LIBRARY BASE: esq-graphics-leaf.h, the NON-volatile base -- every call is a
 * library call (four TextLength sites). See esq-graphics-leaf.h; a6_audit
 * enforces it. Note the original reloads the base before each TextLength anyway,
 * because each is preceded by stores through the text pointer -- the same
 * store-may-alias-the-base behaviour documented in
 * bevel_draw_vertical_bevel_pair.c, and the leaf header reproduces it.
 *
 * 280 bytes against 292. SHORTINT was tried and is WRONG here (284, further from
 * the reference in structure) -- unlike its sibling
 * esqiff_set_apen_to_brightest_palette_index.c. The option really is per-file.
 *
 * SASC-MISMATCH: a5-frame-pointer
 *   summary: -12. The original carries three values in frame slots -4/-8(A5) plus
 *            a spill at 28(A7) and reloads them around each call; 6.51 keeps them
 *            in registers and builds no frame. Every access to those slots is 4
 *            bytes in the reference against 2 here, which is where the twelve go.
 *            The scan loops, the 24/25 dispatch, the space tracking and all four
 *            TextLength calls reproduce.
 *   tried:   SHORTINT (284, worse). Nothing source-side forces the frame.
 *   scope:   whole-program.
 *   retest:  a compiler that reserves A5 as the frame pointer.
 */

#include "esq-graphics-leaf.h"
#include <string.h>

extern unsigned char *WDISP_DisplayContextBase;

#define Offset_RastPort2_FromDisplayContextBase 8
#define RP2 ((struct RastPort *)(WDISP_DisplayContextBase \
             + Offset_RastPort2_FromDisplayContextBase + 2))

void TEXTDISP_TrimTextToPixelWidth(unsigned char *text, long maxWidth)
{
    unsigned char *p;
    unsigned char *lastSpace;
    unsigned char *rest;
    long fill = 25;
    long acc;
    long width;
    long c;

    p = text;
    lastSpace = 0;
    acc = 0;

    width = TextLength(RP2, text, strlen(text));

    while (width > maxWidth) {
        if (!*p)
            return;

        c = *p;
        if (c == 24 || c == 25) {
            fill = c;
            p++;
            width = TextLength(RP2, p, strlen(p));
            acc = 0;
            lastSpace = 0;
            continue;
        }

        acc += TextLength(RP2, p, 1L);

        if (acc > maxWidth) {
            if (!lastSpace)
                return;

            *lastSpace = fill;
            rest = lastSpace + 1;
            p = rest;
            width = TextLength(RP2, rest, strlen(rest));
            acc = 0;
            lastSpace = 0;
            continue;
        }

        if (*p == 32)
            lastSpace = p;
        p++;
    }
}
