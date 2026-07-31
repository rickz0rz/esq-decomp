/* RESTORES: TLIBA3_SetFontForAllViewModes
 * MODULE:   modules/groups/b/a/tliba3_p5_p0.s
 * STATUS:   behavioural
 *
 * Sets one TextFont on the RastPort of each of the first nine view-mode
 * runtime entries. The entry stride is 154 bytes and the RastPort sits at
 * offset 10, which is the same layout tliba3_clear_view_mode_rast_port.c and
 * tliba3_get_view_mode_height.c model.
 *
 * The loop bound is nine, not ten: the original loads MOVEQ #9 and leaves on
 * BGE, so entry 9 is not touched.
 *
 * 60 ref vs 68 got, and the whole 8 bytes are one known class.
 *
 * SASC-MISMATCH: mul32-helper-vs-inline
 *   ref:     724dd2814eba2790        MOVEQ #77,D1 / ADD.L D1,D1 / JSR _MATH_Mulu32(PC)
 *   got:     e5809087e58090872200e7819280d281
 *                                    ASL.L #2,D0 / SUB.L D7,D0 / ASL.L #2,D0 /
 *                                    SUB.L D7,D0 / MOVE.L D0,D1 / ASL.L #3,D1 /
 *                                    SUB.L D0,D1 / ADD.L D1,D1
 *   summary: for the index multiply i * 154 the original materialises 154 as
 *            MOVEQ #77 + ADD.L (the 2n rule) and CALLS its 32-bit multiply
 *            helper. SAS/C 6.51 strength-reduces the same multiply inline into
 *            shifts and subtracts -- 154 = 2 * 7 * 11, and the chain computes
 *            3i, 11i, 88i, 77i, 154i -- and calls nothing. Both compute
 *            i * 154. Inline is 16 bytes against 8, which is the whole delta.
 *   tried:   nothing from the source side. The multiply is by a compile-time
 *            constant, so any spelling of the index gives the compiler the
 *            same constant to reduce.
 *   scope:   already recorded in docs/compiler-version.md, "Arithmetic: three
 *            more classes" (32-bit multiply: original calls the helper, 6.51
 *            inlines) and "Constant materialisation", where 154 = 77x2 is one
 *            of the measured sightings of the 2n rule. This file is another
 *            sighting of both, not a new class. Siblings
 *            tliba3_clear_view_mode_rast_port.c and
 *            tliba3_get_view_mode_height.c share the stride of 154.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include "esq-graphics.h"

extern char TLIBA3_VmArrayRuntimeTable[];

void TLIBA3_SetFontForAllViewModes(struct TextFont *font)
{
    long i;

    for (i = 0; i < 9; i++)
        SetFont((struct RastPort *)(TLIBA3_VmArrayRuntimeTable + i * 154 + 10),
                font);
}
