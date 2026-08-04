/* RESTORES: ED_DrawCurrentColorIndicator
 * MODULE:   modules/groups/a/l/ed3bb.s
 * STATUS:   behavioural
 *
 * 202 bytes in the original, 200 emitted, 15 differing regions.
 *
 * Reproduces: the high nibble extracted once and reused as both the fill pen and
 * the later background pen, the swatch RectFill, the low nibble taken as the
 * foreground pen for the label, the formatted label drawn over the swatch, and
 * the pen restoration to 1/2 at the end.
 *
 * The two rectangle bounds that fit the original's short constant forms use
 * them -- 204 as 102x2 and 250 as 125x2 -- while 474 and 275 fall back to MOVE.L.
 * Consistent with the rule in docs/compiler-version.md, and a reminder that the
 * original applies it per-operand rather than per-instruction: the same RectFill
 * call carries two doubled constants and two immediates.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ffd4                   LINK.W A5,#-44
 *   got:     9efc002c                   SUBA.W #44,A7
 *   summary: The A5-frame class; the 41-byte label buffer moves to A7-relative.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the four cross-unit calls.
 */
#include "esq-graphics.h"

extern char LADFUNC_GetPackedPenHighNibble(long v);
extern char LADFUNC_GetPackedPenLowNibble(long v);
extern void WDISP_SPrintf(char *buf, char *fmt, long v);
extern void DISPLIB_DisplayTextAtPosition(void *rp, long x, long y, char *s);
extern struct RastPort *Global_REF_RASTPORT_1;
extern char Global_STR_CURRENT_COLOR_FORMATTED[];

void ED_DrawCurrentColorIndicator(char packed)
{
    char colorLabel[41];
    register unsigned char hi;

    hi = LADFUNC_GetPackedPenHighNibble((long)(unsigned char)packed);

    SetAPen(Global_REF_RASTPORT_1, (long)hi);
    RectFill(Global_REF_RASTPORT_1, 204L, 250L, 474L, 275L);

    SetAPen(Global_REF_RASTPORT_1,
            (long)(unsigned char)LADFUNC_GetPackedPenLowNibble(
                (long)(unsigned char)packed));
    SetBPen(Global_REF_RASTPORT_1, (long)hi);

    WDISP_SPrintf(colorLabel, Global_STR_CURRENT_COLOR_FORMATTED,
                                  (long)(unsigned char)packed);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 205, 272, colorLabel);

    SetAPen(Global_REF_RASTPORT_1, 1L);
    SetBPen(Global_REF_RASTPORT_1, 2L);
}
