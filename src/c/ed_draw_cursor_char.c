/* RESTORES: ED_DrawCursorChar
 * MODULE:   modules/groups/a/l/ed3bb_p3.s
 * STATUS:   behavioural
 *
 * Draws the character under the edit cursor with the pens packed into the live
 * buffer byte at the same offset.
 *
 * The buffer byte is FETCHED TWICE -- the original recomputes
 * ED_EditBufferLive + ED_EditCursorOffset and reloads the byte before the
 * second nibble call, rather than keeping it. That is not a spill; the
 * intervening SetAPen could in principle change the offset, and the C below
 * indexes twice for the same reason.
 *
 * The x coordinate is column * 15 + 40, and the original reaches the multiply
 * as LSL.L #4 minus the original value -- a LOGICAL shift, and written as a
 * shift here because AGENTS.md records that `* 15` would widen the whole
 * computation.
 *
 * The y coordinate is viewport * 30 + 90, and that multiply DOES go through the
 * 32-bit helper.
 *
 * The character drawn comes from a DIFFERENT buffer than the pens: pens from
 * ED_EditBufferLive, glyph from ED_EditBufferScratch, both at the same offset.
 *
 * The volatile graphics header is required -- both nibble helpers and the
 * cursor-position helper are ESQ assembly and none preserves A6. The original
 * reloads the base before SetAPen, before SetBPen and before Move, and keeps it
 * across Move to Text; that is exactly what the volatile header produces.
 *
 * 188 ref vs 196 got. Both buffer index computations, both nibble calls with
 * their byte widenings, both pen calls, the cursor-position call, the
 * LSL.L #4 / SUB.L column multiply, the MOVEQ #40 and MOVEQ #90 offsets and the
 * closing Move/Text pair all match in kind and size.
 *
 * SASC-MISMATCH: mul32-helper-vs-inline
 *   ref:     721e 4eba5892      MOVEQ #30,D1 / JSR MATH_Mulu32(PC)
 *   got:     2200 e981 9280 d281
 *                               ASL.L #4 / SUB.L / ADD.L chain
 *   summary: the viewport * 30 goes to the helper in the original and is
 *            strength-reduced inline by 6.51 -- 30 = (16 - 1) * 2. The COLUMN
 *            multiply is a shift in BOTH, because the original wrote it that
 *            way, which is why writing it as a shift here was necessary.
 *   scope:   program-wide. docs/compiler-version.md, "Arithmetic: three more
 *            classes".
 *   retest:  a compiler that emits a helper call for a 32-bit constant multiply.
 *
 * SASC-MISMATCH: link-frame-vs-register-save
 *   ref:     4e55fffc ... 4e5d    LINK.W A5,#-4 / UNLK
 *   got:     48e70102 ... 4cdf4080
 *   summary: the original opens a 4-byte frame for its one argument slot; 6.51
 *            saves two registers instead. Plus the A6-is-callee-saved class.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include "esq-graphics.h"

extern unsigned char GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble(long packed);
extern unsigned char GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(long packed);
extern void ED_UpdateCursorPosFromIndex(long index);

extern struct RastPort *Global_REF_RASTPORT_1;
extern unsigned char ED_EditBufferLive[];
extern unsigned char ED_EditBufferScratch[];
extern long ED_EditCursorOffset;
extern long ED_CursorColumnIndex;
extern long ED_ViewportOffset;

void ED_DrawCursorChar(void)
{
    long x;

    SetAPen(Global_REF_RASTPORT_1,
            (long)GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble(
                (long)ED_EditBufferLive[ED_EditCursorOffset]));

    SetBPen(Global_REF_RASTPORT_1,
            (long)GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(
                (long)ED_EditBufferLive[ED_EditCursorOffset]));

    ED_UpdateCursorPosFromIndex(ED_EditCursorOffset);

    x = (ED_CursorColumnIndex << 4) - ED_CursorColumnIndex + 40;

    Move(Global_REF_RASTPORT_1, x, ED_ViewportOffset * 30 + 90);
    Text(Global_REF_RASTPORT_1,
         (char *)&ED_EditBufferScratch[ED_EditCursorOffset], 1L);
}
