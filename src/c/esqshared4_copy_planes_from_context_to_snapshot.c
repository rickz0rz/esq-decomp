/* RESTORES: ESQSHARED4_CopyPlanesFromContextToSnapshot
 * MODULE:   modules/groups/a/q/esqshared4.s
 * STATUS:   behavioural
 *
 * NO KNOWN DEFECT HERE. This file was accused of stopping the graphic ads on
 * 2026-08-08 and the accusation is RETRACTED: the bisect that produced it used
 * a broken oracle. The probe scored a frame as "ad present" when its black
 * share fell below 0.55, and two other things do that -- the Workbench CLI
 * screen after ESQ exits, and an ordinary guide frame with the TV Guide logo
 * showing. So every PASS in that bisect was one of those, not an ad, and the
 * attribution means nothing.
 *
 * THE AD DEFECT ITSELF IS REAL and is not attributed to any file yet. Pressing
 * `g` on a guide showing listings raises a full-screen ad on the shipped binary
 * every time and never on the maximum-C build; both were confirmed BY LOOKING
 * AT THE FRAMES, which is the only check that held up.
 *
 * A USABLE ORACLE MUST IDENTIFY THE AD, not merely a bright screen. Match the
 * ad's own colours against a control frame, or require guide furniture to be
 * present as well, and validate it against three cases before trusting it: an
 * ad frame, a plain guide frame, and a dead machine.
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
