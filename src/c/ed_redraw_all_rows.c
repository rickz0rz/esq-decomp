/* RESTORES: ED_RedrawAllRows
 * MODULE:   modules/groups/a/l/ed3bbbb_p1.s
 * STATUS:   behavioural
 *
 * Clears the whole editor area to the current background pen and redraws every
 * character, then puts the cursor offset back where it was.
 *
 * The fill rectangle is (40, 68) to (640, limit * 30 + 68), and the pen comes
 * from the HIGH NIBBLE of the live edit-buffer byte -- the original widens the
 * byte, calls the nibble extractor, and widens the byte result again before
 * passing it to SetAPen.
 *
 * The loop drives the SHARED cursor-offset global rather than a local, because
 * that is what the draw routine reads. It is saved on entry and restored on
 * exit, exactly as ed_redraw_row.c does for a single row.
 *
 * The bound is ED_BlockOffset, re-read every iteration.
 *
 * The volatile graphics header is required: ED_DrawCursorChar and the nibble
 * extractor are ESQ assembly and do not preserve A6. The original loads the
 * base once, before SetAPen, and keeps it across the RectFill -- both library
 * calls, and nothing between them.
 *
 * 128 ref vs 136 got. The nibble-extractor call, the SetAPen, the RectFill with
 * its MOVEQ #40 / MOVE.L #640 corners, the CLR.L of the cursor offset, the loop
 * bound against ED_BlockOffset, the ADDQ.L #1 and the restore all match in kind
 * and size.
 *
 * SASC-MISMATCH: mul32-helper-vs-inline
 *   ref:     721e 4eba5504 7244 d081     MOVEQ #30,D1 / JSR MATH_Mulu32(PC) /
 *                                        MOVEQ #68,D1 / ADD.L D1,D0
 *   got:     2200 e981 9280 d281 7044 d280
 *                                        an ASL/SUB/ADD chain, then the add
 *   summary: the limit * 30 goes to the multiply helper in the original and is
 *            strength-reduced inline by 6.51 -- 30 = (16 - 1) * 2. Same
 *            product. 6.51 also folds the RectFill corner differently
 *            (7244 7450 e78a against the original 7028 243c00000280), which is
 *            the same 640 reached as 80 << 3 rather than materialised.
 *   scope:   program-wide. docs/compiler-version.md, "Arithmetic: three more
 *            classes" and "Constant materialisation" -- the original never
 *            shifts by more than one, which is exactly what the 640 case shows.
 *   retest:  a compiler that emits a helper call for a 32-bit constant multiply
 *            and a six-byte MOVE.L for 640.
 *
 * SASC-MISMATCH: a6-preserved-across-libcall
 *   ref:     48e73100 ... 4cdf008c    A6 not saved
 *   got:     48e73102 ... 4cdf408c    A6 in the save mask
 *   summary: 6.51 treats A6 as callee-saved; the original treats it as scratch.
 *            4 bytes. Recorded program-wide in
 *            tliba3_clear_view_mode_rast_port.c.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include "esq-graphics.h"

extern unsigned char GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(long v);
extern void ED_DrawCursorChar(void);

extern long ED_EditCursorOffset;
extern long ED_BlockOffset;
extern long ED_TextLimit;
extern unsigned char ED_EditBufferLive;
extern struct RastPort *Global_REF_RASTPORT_1;

void ED_RedrawAllRows(void)
{
    long saved;

    saved = ED_EditCursorOffset;

    SetAPen(Global_REF_RASTPORT_1,
            (long)GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble((long)ED_EditBufferLive));

    RectFill(Global_REF_RASTPORT_1, 40L, 68L, 640L, ED_TextLimit * 30 + 68);

    ED_EditCursorOffset = 0;
    while (ED_EditCursorOffset < ED_BlockOffset) {
        ED_DrawCursorChar();
        ED_EditCursorOffset++;
    }

    ED_EditCursorOffset = saved;
}
