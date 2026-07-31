/* RESTORES: DATETIME_BuildFromBaseDay
 * MODULE:   modules/groups/a/j/disptext2_p0_p0.s
 * STATUS:   behavioural
 *
 * Converts a base date record to seconds, shifts it by a whole number of
 * hours, writes the result back out as a record, and returns the shifted
 * second count.
 *
 * The hour offset is (day - 0x36) minus one when the flag equals 1, and the
 * multiply is by 3600 -- MOVE.L #$e10,D1 followed by the 32-bit multiply
 * helper, so it is seconds per hour rather than any smaller unit.
 *
 * Both scalar parameters are words at slot+2 (3e2d0012, 3c2d0016), so they are
 * shorts, and both intermediate values are widened with EXT.L before the
 * subtraction, so the arithmetic happens in long.
 *
 * The flag test is `== 1` exactly (MOVEQ #1 / CMP.W / BNE), not merely
 * non-zero, and both arms materialise their own MOVEQ.
 *
 * The trailing CLR.W 14(A2) zeroes a word field of the OUTPUT record, after
 * the conversion has filled it. It is written through a struct so the offset
 * folds into the displacement.
 *
 * 106 ref vs 100 got. The SUBI.W #$36, the MOVEQ #1 / CMP.W flag test with its
 * two separate MOVEQ arms, both EXT.L widenings, the SUB.L, the two argument
 * pushes and the CLR.W 14(A2) all match in kind and size.
 *
 * SASC-MISMATCH: mul32-helper-vs-inline
 *   ref:     223c00000e10 4ebad1fc      MOVE.L #$e10,D1 / JSR MATH_Mulu32(PC)
 *   got:     2200 e981 9280 2401 e982 9481 e982 da82
 *                                       an ASL/SUB/ADD chain
 *   summary: the * 3600 goes to the 32-bit multiply helper in the original and
 *            is strength-reduced inline by 6.51. Same product. Recorded
 *            program-wide in docs/compiler-version.md, "Arithmetic: three more
 *            classes" -- the original calls out for a 32-bit multiply where
 *            6.51 inlines. Note the original ALSO spends 6 bytes materialising
 *            3600 with MOVE.L, because 3600 is neither 2n nor ~n for any n in
 *            MOVEQ range, which is the constant rule in the same document.
 *   retest:  a compiler that emits a helper call for a 32-bit constant multiply.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55fff4 ... 4ced0cf0ffdc 4e5d    LINK.W A5,#-12 / MOVEM / UNLK
 *   got:     594f ... 4cdf28f4 584f            SUBQ.W #4,A7 / MOVEM / ADDQ.W
 *   summary: the frame class. The original also stores two intermediates into
 *            frame slots (48ad0001fff6 and 3b41fff4) that nothing reads back.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct DateTimeRec {
    char  pad0[14];
    short field14;              /* +14 */
};

extern long DATETIME_NormalizeStructToSeconds(char *rec);
extern void DATETIME_SecondsToStruct(long secs, struct DateTimeRec *out);

long DATETIME_BuildFromBaseDay(char *base, struct DateTimeRec *out, short day,
                               short flag)
{
    long  secs;
    short offset;
    short adjust;

    secs   = DATETIME_NormalizeStructToSeconds(base);
    offset = day - 0x36;
    adjust = (flag == 1) ? 1 : 0;

    secs += ((long)offset - (long)adjust) * 3600;

    DATETIME_SecondsToStruct(secs, out);
    out->field14 = 0;

    return secs;
}
