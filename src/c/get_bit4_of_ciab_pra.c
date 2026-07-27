/* RESTORES: GET_BIT_4_OF_CIAB_PRA_INTO_D1
 * MODULE:   modules/groups/a/a/app.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: result-returned-in-d1
 *   ref:     72002a7c00bfd00012150801000457c14e75
 *   got:     2f077e001e39000000000807000467047000600270ff2e1f4e75
 *   summary: The original returns its result in D1, not D0, so it is callable only from assembly. No C function can express that calling convention; this restoration documents the logic but cannot be linked in.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 *
 * DO NOT LINK. This restoration is valid as ANALYSIS and its byte comparison
 * stands, but it must never be substituted into a build: interior label reached by fall-through, and it returns its result in D1.
 * A C function with an ordinary prologue is not a different encoding of that,
 * it is wrong. tools/gen_all_manifest.py excludes it automatically; this note
 * is here so the reason survives if the tooling changes.
 *
 * This class is what hung the machine on the first whole-program C run.
 */
extern volatile unsigned char CIAB_PRA;
long GET_BIT_4_OF_CIAB_PRA_INTO_D1(void)
{
    long v = CIAB_PRA;
    return (v & 16) ? 0 : -1;
}
