/* RESTORES: GET_BIT_3_OF_CIAB_PRA_INTO_D1
 * MODULE:   modules/groups/a/a/app_get_bit_3_of_ciab_pra_into_d1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: result-returned-in-d1
 *   ref:     72002a7c00bfd00012150801000357c14e75
 *   got:     2f077e001e39000000000807000367047000600270ff2e1f4e75
 *   summary: The original returns its result in D1, not D0, so it is callable only from assembly. No C function can express that calling convention; this restoration documents the logic but cannot be linked in.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 *
 * LINKABLE SINCE 2026-07-31, and the reason it was not is worth keeping.
 * It carried DO-NOT-LINK because the original returns in D1 and no C function
 * can, so an assembly caller would read D0 and get garbage. That is true and
 * still true. What changed is that this function has exactly ONE caller in the
 * whole program, ESQ_CaptureCtrlBit3Stream, and that caller is now C as well.
 * With both sides in C the convention is C's, D0, and there is no assembly left
 * to disappoint. The two modules are listed together in the manifest so they
 * cannot be split apart.
 *
 * The general rule this is an instance of: a register-convention blocker
 * describes the ORIGINAL's contract with ITS callers. It stops being a blocker
 * when every one of those callers becomes C in the same step. Check the caller
 * list before believing the marker.
 */
extern volatile unsigned char CIAB_PRA;
long GET_BIT_3_OF_CIAB_PRA_INTO_D1(void)
{
    long v = CIAB_PRA;
    return (v & 8) ? 0 : -1;
}
