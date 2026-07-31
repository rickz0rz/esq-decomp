/* RESTORES: ESQ_NoOp
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   exact
 *
 * SASC-MISMATCH: dead-code-after-rts
 *   ref:     4e75103c000013c000002da813c0000041684e75
 *   got:     4e75
 *   summary: Not expressible in C at all -- see the comment in the file. Documented so the label is accounted for; it must stay in assembly.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
/* The entry point is a bare RTS; the body after it is unreachable dead code
 * left in the image. Kept so the label is accounted for. */
extern unsigned char ESQ_CopperListBannerA, ESQ_CopperListBannerB;

void ESQ_NoOp(void)
{
}
