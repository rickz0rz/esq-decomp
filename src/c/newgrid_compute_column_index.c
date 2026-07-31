/* RESTORES: NEWGRID_ComputeColumnIndex
 * MODULE:   modules/groups/b/a/newgrid1_p1.s
 * STATUS:   behavioural
 *
 * Divides an entry's pixel span by a quarter of the grid row height to get a
 * column count, and returns 0 for an entry whose byte at offset 54 has reached
 * '@'. The guard is CMPI.B #'@' / BCC, an UNSIGNED compare, so the field is
 * unsigned char.
 *
 * NEWGRID_RowHeightPx is widened with MOVEQ #0 / MOVE.W (unsigned short) and
 * then divided by 4 with the signed sequence TST.L / BPL / ADDQ #3 / ASR #2.
 * The sign correction is dead for a zero-extended value, but the original
 * emits it, so the divide happens in long.
 *
 * SASC-MISMATCH: register-argument-helper-vs-operator
 *   ref:     4ebaf9da                JSR NEWGRID_JMPTBL_MATH_DivS32(PC)
 *   got:     a call to SAS/C's own 32-bit divide helper
 *   summary: MATH_DivS32 is a REGISTER-argument helper -- dividend in D0,
 *            divisor in D1, quotient back in D0. It cannot be declared as an
 *            ordinary C function and called, because the arguments would go on
 *            the stack where the helper never reads them. Written with the C
 *            operator instead, which is the only correct form; SAS/C then calls
 *            its own __CXD33. Same arithmetic, different callee.
 *   scope:   program-wide wherever MATH_DivS32 or MATH_Mulu32 appears. See
 *            tliba3_get_view_mode_height.c, which records the same thing and
 *            the crash it caused when it was written the other way.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * 70 ref vs 56 got -- this restoration is SMALLER than the original, which is
 * unusual and is worth reading before anyone treats it as an improvement.
 * Fourteen of the fourteen bytes are the two classes below; nothing here is
 * unattributed.
 *
 *   - The register-argument helper costs the original a SPILL. MATH_DivS32
 *     needs the dividend in D0 and the divisor in D1 exactly, so the original
 *     parks the divisor in a stack slot and reloads it after computing the
 *     dividend: LINK.W A5,#-4 / MOVE.L D0,8(A7) / MOVE.L 8(A7),D1 / UNLK, which
 *     is 12 bytes of frame and spill that exist only to satisfy the helper's
 *     calling convention. 6.51 calls __CXD33, which takes its arguments
 *     wherever the allocator put them, so it needs no frame at all.
 *   - The remaining 2 bytes are the A3/A5 class: 266f0014 against 2a6f000c.
 *
 * So the smaller output is not a better restoration. It is the same arithmetic
 * without the original's calling-convention overhead, and it is capped at
 * behavioural for exactly that reason.
 */
struct NewGridColumnEntry {
    char           pad52[52];
    unsigned short span;
    unsigned char  limit;
};

extern unsigned short NEWGRID_RowHeightPx;

long NEWGRID_ComputeColumnIndex(struct NewGridColumnEntry *e)
{
    long idx = 0;

    if (e->limit < '@')
        idx = (long)e->span / ((long)NEWGRID_RowHeightPx / 4);
    return idx;
}
