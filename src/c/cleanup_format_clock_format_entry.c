/* RESTORES: CLEANUP_FormatClockFormatEntry
 * MODULE:   modules/groups/a/c/cleanup2_p1_2.s
 * STATUS:   behavioural
 *
 * Copies the clock-format string for a slot and, when the current variant has
 * a minute remainder, rewrites the two minute digits in place.
 *
 * The slot wrap is a SUBTRACT LOOP, not a modulo: MOVEQ #48 / CMP.L / BLE /
 * SUB.L / BRA back. It also runs while the slot is strictly GREATER than 48, so
 * a slot of exactly 48 is left alone.
 *
 * The minute value is MATH_DivS32's REMAINDER (D1 is moved to D6, not D0), so
 * it is CLOCK_FormatVariantCode % 30. Taking the quotient here would produce a
 * clock that reads 0 or 1 minutes past every slot.
 *
 * The digit arithmetic reads the EXISTING tens digit out of the copied string,
 * folds it back in, and writes both digits again:
 *
 *   mins += (out[3] - '0') * 10
 *   out[3] = mins / 10 + '0'      (the quotient)
 *   out[4] = mins % 10 + '0'      (the remainder of the SAME divide)
 *
 * The original issues MATH_DivS32 twice with the same operands and takes D0
 * from the first and D1 from the second, which is the register-argument helper
 * giving both halves. In C that is one `/` and one `%`; SAS/C emits two calls
 * to its own helper, which is the documented cost of the class.
 *
 * The literal 48 is '0' and is written as the character.
 *
 * The string copy is MOVE.B (A1)+,(A2)+ / BNE -- what strcpy inlines to.
 *
 * THE FORMAT TABLE IS REACHED THROUGH TWO DEREFERENCES, and the first version
 * of this file used one. The symbol is a single DC.L in src/data/esq.s that
 * HOLDS the table base, so `char *X[]` made the symbol itself the table. Slot 0
 * then copied from the table base, whose first byte is the high byte of a
 * pointer, so every label came out EMPTY and Text() drew nothing. The result
 * was a grid banner with its bevels, separators and running clock intact and
 * all three time-slot labels missing.
 *
 * NO BYTE CHECK COULD SEE IT. The emitted size is 124 either way, DATA=FAR
 * turns the access into an absolute long carrying a relocation, and cdiff.sh
 * masks relocated fields by definition. The soak passed, menusweep passed on
 * all six items, and framecolor called every bin overlapping -- the yellow bin
 * ran at half the reference median but still overlapped, because both dip to
 * zero between screens. A user watching the program found it.
 *
 * tools/data_shape_audit.py now compares every C extern against the addressing
 * mode the original uses at that symbol, and build-split.sh runs it on any C
 * build. It reports this file when the declaration is reverted.
 *
 * 120 ref vs 124 got. The slot wrap loop is VERBATIM (7030 be80 6f04 9e80 60f6),
 * and so are the MOVEQ #30 divisor, the remainder move to D6, the ASL.L #2
 * table index, the inline strcpy (244b 14d9 66fc), the TST.L / BLE guard, the
 * EXT.W / EXT.L digit widening, the MOVEQ #48 subtract and both digit stores.
 *
 * SASC-MISMATCH: mul32-helper-vs-inline
 *   ref:     720a 4eba5910          MOVEQ #10,D1 / JSR MATH_Mulu32(PC)  (6)
 *   got:     2400 e582 d480 d482    MOVE.L D0,D2 / ASL.L #2,D2 / ADD.L D0,D2 /
 *                                   ADD.L D2,D2                        (8)
 *   summary: the * 10 goes to the multiply helper in the original and is
 *            strength-reduced inline by 6.51 -- 10 = (4 + 1) * 2. Same product,
 *            2 bytes more, and the other 2 are object alignment padding.
 *   scope:   program-wide. docs/compiler-version.md, "Arithmetic: three more
 *            classes".
 *   retest:  a compiler that emits a helper call for a 32-bit constant multiply.
 *
 * SASC-MISMATCH: register-argument-helper-vs-operator
 *   ref:     4eba58b8 then 4eba58a8   two MATH_DivS32 calls, D0 from the first
 *                                     and D1 from the second
 *   got:     61000000 x2              two calls to SAS/C 6.51 own helper
 *   summary: the original issues the SAME divide twice and takes the quotient
 *            from one and the remainder from the other, because the helper
 *            leaves both. In C that is one / and one %, and 6.51 emits two
 *            helper calls of its own -- the same instruction count, a different
 *            callee. The remainder cannot be reached through a C return value
 *            at all, which is why the operator form is the only correct one.
 *   scope:   program-wide. See tliba3_get_view_mode_height.c for the crash this
 *            class caused when it was written the other way.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>

extern unsigned char CLOCK_FormatVariantCode;

/* TWO dereferences, not one. The symbol is a single DC.L in src/data/esq.s
 * that HOLDS the table base, so the original reads the pointer, indexes it,
 * and then reads the string:
 *
 *   MOVEA.L _Global_REF_STR_CLOCK_FORMAT,A0 / ADDA.L D0,A0 / MOVEA.L (A0),A1
 *
 * Declaring it `char *X[]` makes the symbol ITSELF the table and drops a level.
 * Slot 0 then copies from the table base, whose first byte is the high byte of
 * a pointer, so the label comes out EMPTY and every clock-format label stops
 * being drawn. DATA=FAR turns each access into an absolute long carrying a
 * relocation, and cdiff.sh masks relocated fields, so the byte comparison
 * cannot see this at all.
 */
extern char **Global_REF_STR_CLOCK_FORMAT;

void CLEANUP_FormatClockFormatEntry(long slot, char *out)
{
    long mins;

    while (slot > 48)
        slot -= 48;

    mins = (long)CLOCK_FormatVariantCode % 30;

    strcpy(out, Global_REF_STR_CLOCK_FORMAT[slot]);

    if (mins > 0) {
        mins += ((long)out[3] - '0') * 10;
        out[3] = (char)(mins / 10 + '0');
        out[4] = (char)(mins % 10 + '0');
    }
}
