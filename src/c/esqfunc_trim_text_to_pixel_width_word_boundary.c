/* RESTORES: _ESQFUNC_TrimTextToPixelWidthWordBoundary
 * MODULE:   modules/groups/a/n/esqfunc_p5.s
 * STATUS:   behavioural
 *
 * Shortens `text` until it fits in `maxPixels`, cutting at a WORD BOUNDARY
 * rather than mid-word. It returns the character count that fits, and does not
 * modify the string -- the caller draws that many characters.
 *
 * IT MEASURES, THEN CUTS, THEN MEASURES AGAIN. One backward scan is not enough,
 * because dropping one word can still leave the line too wide, so the whole
 * thing is a loop around TextLength.
 *
 * EACH CUT IS TWO SCANS, AND THEY ARE NOT THE SAME SCAN. The first walks back to
 * the next separator -- class bit 3 in WDISP_CharClassTable -- and the second
 * walks back OVER any run of separators it landed on. Without the second the
 * count would keep trailing spaces, and the next TextLength would measure them.
 *
 * THE TABLE INDEX IS A SIGNED CHAR. `MOVE.B / EXT.W / EXT.L` sign-extends, so a
 * character at or above 128 indexes BEFORE the table. That is what the original
 * does and the C reproduces it with a signed index rather than quietly widening
 * to unsigned, which would read a different byte and classify high characters
 * the other way.
 *
 * SASC-MISMATCH: cross-unit-call-encoding
 *   scope:   program-wide under SAS/C 6.51. See AGENTS.md.
 */
#include "esq-graphics.h"

extern unsigned char WDISP_CharClassTable[];

long ESQFUNC_TrimTextToPixelWidthWordBoundary(struct RastPort *rp,
                                              long maxPixels, char *text)
{
    long n = strlen(text);

    for (;;) {
        if (n <= 0)
            return n;
        if ((long)TextLength(rp, text, n) <= maxPixels)
            return n;

        /* back to the next separator... */
        do {
            n--;
        } while (n > 0 && !(WDISP_CharClassTable[text[n - 1]] & 8));

        /* ...then back over the run of them. */
        while (n > 0 && (WDISP_CharClassTable[text[n - 1]] & 8))
            n--;
    }
}
