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
 */
extern volatile unsigned char CIAB_PRA;
long GET_BIT_4_OF_CIAB_PRA_INTO_D1(void)
{
    long v = CIAB_PRA;
    return (v & 16) ? 0 : -1;
}
