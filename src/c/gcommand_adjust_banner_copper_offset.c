/* RESTORES: GCOMMAND_AdjustBannerCopperOffset
 * MODULE:   modules/groups/a/u/gcommand3b_p4_p0.s
 * STATUS:   behavioural
 *
 * Shifts both banner copper lists by a signed byte delta, but only when the
 * shift would keep the head byte at or above 130.
 *
 * The delta is a CHAR: it is read as a byte at 11(A5) and widened with the
 * EXT.W / EXT.L pair, which is the char-to-long sign extension. Reading it as
 * a long or an unsigned char both give the wrong guard for a negative shift.
 *
 * The head byte itself is read with MOVEQ #0 / MOVE.B, so it is unsigned, and
 * the comparison happens in long.
 *
 * 130 is reached as MOVEQ #65 / ADD.L D1,D1 -- the 2n constant rule recorded in
 * docs/compiler-version.md. It is written as the literal 130 here; the
 * materialisation is the compiler's choice, not the source's.
 *
 * All three calls take the same widened delta, and the original recomputes the
 * sign extension before each one rather than holding it.
 *
 * 98 ref vs 92 got. The guard arithmetic is VERBATIM -- MOVEQ #0 / MOVE.B /
 * EXT.W / EXT.L / ADD.L / MOVEQ #65 / ADD.L D1,D1 / CMP.L / BLT -- and so are
 * all three call sites with their MOVE.L D0,(A7) argument reuse and the closing
 * LEA 12(A7),A7. Two items differ.
 *
 * SASC-MISMATCH: address-through-frame-vs-register
 *   ref:     41f900002da8 2b48fffc   LEA list,A0 / MOVE.L A0,-4(A5)
 *   got:     4bf900000000            LEA list,A5
 *   summary: the original computes the list address and then spills it to a
 *            frame slot it never reads back. 6.51 emits the LEA alone. 4 bytes
 *            of dead store plus the frame.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55fffc 2f07 ... 2e1f 4e5d    LINK / MOVE.L D7 / pop / UNLK
 *   got:     48e70104 ... 4cdf2080          MOVEM.L D7/A5 / MOVEM back
 *   summary: the frame class; the remaining 2 bytes.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern void GCOMMAND_AddBannerTableByteDelta(unsigned char *list, long delta);
extern void GCOMMAND_UpdateBannerOffset(long delta);

extern unsigned char ESQ_CopperListBannerA[];
extern unsigned char ESQ_CopperListBannerB[];

void GCOMMAND_AdjustBannerCopperOffset(char delta)
{
    unsigned char *list = ESQ_CopperListBannerA;

    if (delta != 0 && (long)*list + (long)delta >= 130) {
        GCOMMAND_AddBannerTableByteDelta(list, (long)delta);
        GCOMMAND_AddBannerTableByteDelta(ESQ_CopperListBannerB, (long)delta);
        GCOMMAND_UpdateBannerOffset((long)delta);
    }
}
