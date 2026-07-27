/* RESTORES: ED_DrawHelpPanels
 * MODULE:   modules/groups/a/l/ed3bb.s
 * STATUS:   behavioural
 *
 * Paints the editor's two help panels: a fixed pen-2 block for the upper panel
 * and a caller-coloured block below it, then leaves the RastPort in JAM1 with
 * pen 1 for whoever draws the text.
 *
 * 118 bytes in the original, 116 emitted, and the -2 is ONE constant. Everything
 * else in the function reproduces: all six library calls, the single GfxBase load
 * shared across them, the RastPort reloaded before each call, and the second
 * RectFill leaving D2 alone because 640 is still in it from the first.
 *
 * That makes this a clean probe for the constant rule, better than the one in
 * docs/compiler-version.md in one respect -- it is a whole function with a single
 * divergence, so a candidate compiler either matches it byte-for-byte or does not:
 *
 *     tools/cmatch.sh src/c/ed_draw_help_panels.c ED_DrawHelpPanels
 *
 * MATCH means the compiler has the original's constant behaviour. See also
 * src/c/ladfunc2_emit_escaped_char_to_scratch.c, which probes the two four-byte
 * short forms; this one probes the refusal to shift by more than one.
 *
 * SASC-MISMATCH: constant-materialisation
 *   ref:     243c00000280   MOVE.L #640,D2
 *   got:     7450 e78a      MOVEQ #80,D2 / LSL.L #3,D2
 *   summary: 640 = 80<<3. The original spends six bytes rather than shift by
 *            three; 6.51 generalises MOVEQ+shift to any power of two. This is the
 *            documented rule and 640 is already on its MOVE.L list -- what is new
 *            here is that it is the only thing separating this function from an
 *            exact restoration.
 *   scope:   program-wide. docs/compiler-version.md has the measured table.
 *   retest:  a compiler that emits MOVE.L for 640 makes this function exact.
 *
 * SASC-MISMATCH: a6-in-save-mask
 *   ref:     48e73100 ... 4cdf008c    D2-D3/D7
 *   got:     48e73102 ... 4cdf408c    D2-D3/D7/A6
 *   summary: The original treats A6 as scratch across library calls and does not
 *            preserve it; 6.51 adds it to the mask. Same four bytes either way, so
 *            no cost -- but it is a real convention difference and would show up
 *            as a diff in any OS-calling function, so it is recorded rather than
 *            passed over.
 */
#include <proto/graphics.h>

extern struct RastPort *Global_REF_RASTPORT_1;

void ED_DrawHelpPanels(long pen)
{
    SetAPen(Global_REF_RASTPORT_1, 2L);
    RectFill(Global_REF_RASTPORT_1, 40L, 68L, 640L, 297L);
    SetAPen(Global_REF_RASTPORT_1, pen);
    RectFill(Global_REF_RASTPORT_1, 40L, 298L, 640L, 429L);
    SetDrMd(Global_REF_RASTPORT_1, 0L);
    SetAPen(Global_REF_RASTPORT_1, 1L);
}
