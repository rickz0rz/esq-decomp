/* RESTORES: ESQSHARED4_LoadDefaultPaletteToCopper_NoOp
 * MODULE:   modules/groups/a/q/esqshared4.s
 * STATUS:   exact
 *
 * SASC-MISMATCH: dead-code-after-rts
 *   ref:     4e7548e7f8f845f900002dda47f90000419a363c000043f9000028fc4ebaff6a4cdf1f1f4e75
 *   got:     4e75
 *   summary: The entry point is a bare RTS followed by unreachable dead code. Documented so the label is accounted for; it must stay in assembly.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
/* The entry point is a bare RTS; the body after it is unreachable dead code
 * left in the image, and it takes its arguments in registers besides. */
void ESQSHARED4_LoadDefaultPaletteToCopper_NoOp(void)
{
}
