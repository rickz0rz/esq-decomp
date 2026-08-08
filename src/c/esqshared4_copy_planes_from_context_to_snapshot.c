/* RESTORES: ESQSHARED4_CopyPlanesFromContextToSnapshot
 * MODULE:   modules/groups/a/q/esqshared4.s
 * STATUS:   behavioural
 *
 * KNOWN DEFECT, STILL LINKED: IT STOPS THE GRAPHIC ADS DRAWING (2026-08-08).
 *   Bisected against
 *   the shipped binary: press `g` on a guide showing listings and the control
 *   raises a full-screen ad every time (black share 0.31-0.47), while a build
 *   with this restoration linked never does (0.64-0.65, the same as a frame
 *   with no ad). Adding this one row to an otherwise-passing manifest flips it.
 *   The "LINKABLE SINCE 2026-08-01" note below is therefore WRONG, and the
 *   "DO NOT LINK" further down was right -- but it was written as prose, which
 *   no tool reads, so the generator linked the file anyway. That is the third
 *   time this project has lost to a prose-only marker.
 *   NOT DIAGNOSED. The original takes its argument in A1 and this takes it on
 *   the stack; caller and callee are both C now, so the convention agrees, and
 *   the body matches the reference instruction for instruction. Something else
 *   is wrong. Its destination table is one of the eight documented split-pointer
 *   adjacencies, which is the first place to look.
 *
 *   IT IS LINKED ANYWAY, DELIBERATELY, because every alternative is worse and
 *   each was measured. Holding this file out alone leaves its C caller passing
 *   on the stack while the assembly callee reads A1, and the LISTINGS then
 *   store nothing -- two runs, reproducible. Holding out the caller as well,
 *   so the pair is assembly and the convention agrees, still leaves the ads
 *   broken. Only this configuration writes a curday.dat byte-identical to the
 *   assembly control. Listings are the program's purpose, so they win until
 *   someone diagnoses the ad path.
 *
 *   No `DO-NOT-LINK:` marker, therefore: the marker would exclude it and break
 *   the listings. The defect is recorded here instead.
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
