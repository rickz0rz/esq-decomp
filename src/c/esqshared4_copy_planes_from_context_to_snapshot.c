/* RESTORES: ESQSHARED4_CopyPlanesFromContextToSnapshot
 * MODULE:   modules/groups/a/q/esqshared4.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-argument-convention
 *   ref:     48e7407843e9001445f900005e342651285a722b28db51c9fffc22cb2651285a722b28db51c9fffc22cb2651285a722b28db51c9fffc22cb4cdf1e024e75
 *   got:     514f48e703342a6f002047ed001445f9000000007e007003be406c2c2f5300182f5a00147c2b206f0018226f001422d82f4800182f490014200653464a4066e626ef0018524760ce4cdf2cc0504f4e75
 *   summary: The original takes its arguments in REGISTERS rather than on the stack, so it is callable only from assembly. No C function can express that convention; this restoration documents the logic but cannot be linked in.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
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
