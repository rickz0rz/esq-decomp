/* RESTORES: ESQSHARED4_CopyPlanesFromContextToSnapshot
 * MODULE:   modules/groups/a/q/esqshared4.s
 * STATUS:   behavioural
 * LINKABLE SINCE 2026-08-01. It took its argument in a REGISTER, which is
 *   true of the ORIGINAL and was the reason for the marker that used to sit
 *   here. Its only caller is GCOMMAND_ServiceHighlightMessages, which is C, and
 *   that caller declared it `__asm register` to match. Both sides move to C
 *   together, so the convention is C's and neither can disagree with the
 *   other. Check the caller list before believing a register-convention
 *   marker.

 *
 * SASC-MISMATCH: register-argument-convention
 *   ref:     48e7407843e9001445f900005e342651285a722b28db51c9fffc22cb2651285a722b28db51c9fffc22cb2651285a722b28db51c9fffc22cb4cdf1e024e75
 *   got:     514f48e703342a6f002047ed001445f9000000007e007003be406c2c2f5300182f5a00147c2b206f0018226f001422d82f4800182f490014200653464a4066e626ef0018524760ce4cdf2cc0504f4e75
 *   summary: The original takes its arguments in REGISTERS rather than on the stack, so it is callable only from assembly. No C function can express that convention; this restoration documents the logic but cannot be linked in.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 *
 * DO NOT LINK. This restoration is valid as ANALYSIS and its byte comparison
 * stands, but it must never be substituted into a build: takes its arguments in registers AND preserves them.
 * A C function with an ordinary prologue is not a different encoding of that,
 * it is wrong. tools/gen_all_manifest.py excludes it automatically; this note
 * is here so the reason survives if the tooling changes.
 *
 * This class is what hung the machine on the first whole-program C run.
 */
/* Register-argument function: the display-context pointer arrives in A1.
 * Copies three 0x2b-longword planes into the snapshot buffers, advancing the
 * source pointers in place. */
extern long *ESQPARS2_BannerSnapshotPlane0DstPtr[];

void ESQSHARED4_CopyPlanesFromContextToSnapshot(long **ctx)
{
    long **src = ctx + 5;          /* LEA 20(A1),A1 */
    long **dst = ESQPARS2_BannerSnapshotPlane0DstPtr;
    short plane;

    for (plane = 0; plane < 3; plane++) {
        long *s = *src;
        long *d = *dst++;
        short n = 0x2b;
        do {
            *d++ = *s++;
        } while (n--);
        *src++ = s;
    }
}
