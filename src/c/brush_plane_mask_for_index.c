/* RESTORES: BRUSH_PlaneMaskForIndex
 * MODULE:   (not extracted -- still inside modules/groups/a/a/brush.s)
 * STATUS:   behavioural
 *
 * Returns the bitplane mask for a 1-based plane index, or 0 when the index is
 * out of range. Not wired into src/c/replacements.txt: the function has not
 * been split out of brush.s, and there is no reason to ship a non-exact
 * replacement for it. Kept here because it is the cleanest known example of the
 * shift-idiom divergence, and so the retest tooling covers it.
 *
 * 24 of 28 bytes match, including the D7 save, the parameter at 8(A7), the
 * explicit TST.L, the MOVEQ #9 / CMP.L bound check, the BRA.S to a shared exit
 * and the epilogue. Only the shift differs.
 *
 * SASC-MISMATCH: shift-of-one-via-bset
 *   ref:     7001 efa0                    MOVEQ #1,D0 ; ASL.L D7,D0   (4 bytes)
 *   got:     2007 7200 01c1 2001          MOVE.L D7,D0 ; MOVEQ #0,D1 ;
 *                                         BSET D0,D1 ; MOVE.L D1,D0   (8 bytes)
 *   summary: SAS/C 6.51 always materialises a literal 1<<n by zeroing a
 *            register and using BSET. The original uses MOVEQ #1 plus ASL.L.
 *            BSET is fixed-cost where ASL.L is 8+2n cycles, so 6.51 is choosing
 *            speed -- but the original's compiler chose contextually, not
 *            always: the program contains 3 register-to-register BSETs (all
 *            genuine `x |= 1<<n`, which 6.51 also produces) alongside 4
 *            MOVEQ #1 + ASL.L. So this is a code-generator difference, not a
 *            source-form difference.
 *   tried:   options - default, OPTIMIZE, NOOPTPEEP, OPTIMIZE NOOPTPEEP,
 *            OPTIMIZE OPTSIZE, OPTIMIZE OPTTIME, NOOPTGLO;
 *            sources - literal `1L << index`, shift of a local pre-set to 1
 *            (yields ASL.L and both branch displacements correct, but costs an
 *            extra register), shift of a static, `register` parameter.
 *   scope:   4 sites program-wide. Find them with:
 *              grep -rA1 -E '^\s+MOVEQ\s+#1,D[0-7]\s*$' src/modules \
 *                | grep -E '^\s+ASL\.L\s+D[0-7],D[0-7]'
 *   retest:  a compiler that emits MOVEQ #1 + ASL.L for a literal 1<<n should
 *            match this source exactly.
 */
long BRUSH_PlaneMaskForIndex(long index)
{
    if (index > 0 && index < 9)
        return 1L << index;
    return 0;
}
