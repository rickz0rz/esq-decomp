/* RESTORES: GET_BIT_4_OF_CIAB_PRA_INTO_D1
 * MODULE:   modules/groups/a/a/app_get_bit_4_of_ciab_pra_into_d1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: result-returned-in-d1
 *   ref:     72002a7c00bfd00012150801000457c14e75
 *   got:     2f077e001e39000000000807000467047000600270ff2e1f4e75
 *   summary: The original returns its result in D1, not D0, so it is callable only from assembly. No C function can express that calling convention; this restoration documents the logic but cannot be linked in.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 *
 * LINKABLE SINCE 2026-08-01, for exactly the reason its bit-3 twin is, and the
 * header that used to sit here was wrong on both of its counts.
 *
 * It said "interior label reached by fall-through". It is not. Its module is
 * modules/groups/a/a/app_get_bit_4_of_ciab_pra_into_d1.s, whose predecessor in
 * src/Prevue.asm is the bit-3 helper, and that module ends in RTS. Nothing falls
 * into this one. The claim was boilerplate; the bit-3 twin carried the same
 * sentence and it was wrong there too.
 *
 * It also said the D1 return makes it unlinkable. That is true of an ASSEMBLY
 * caller and only of an assembly caller. This function has exactly ONE caller in
 * the whole program -- _ESQ_CaptureCtrlBit4Stream, which issues all four of the
 * JSRs to it -- and that caller is restored in the same tranche. With both sides
 * in C the convention is C's, D0. The two modules are listed together in
 * src/c/replacements-extra.txt so they cannot be split apart.
 *
 * The general rule: a register-convention blocker describes the ORIGINAL's
 * contract with ITS callers. It stops being a blocker when every one of those
 * callers becomes C in the same step. Check the caller list before believing the
 * marker.
 *
 * IT RETURNS -1, NOT 0xFF, AND THAT IS LOAD-BEARING. The original's `SEQ D1`
 * sets only the LOW BYTE, so D1 holds 0x000000FF and the assembly caller tests
 * it with `TST.B`. A C caller tests the whole long, so returning 0xFF would read
 * as POSITIVE and invert every decision in the sampler. -1 makes the long-width
 * test agree with the original's byte-width one.
 */
extern volatile unsigned char CIAB_PRA;
long GET_BIT_4_OF_CIAB_PRA_INTO_D1(void)
{
    long v = CIAB_PRA;
    return (v & 16) ? 0 : -1;
}
