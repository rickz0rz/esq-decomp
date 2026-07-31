/* RESTORES: _BEVEL_DrawBevelFrameWithTopRight
 * MODULE:   modules/groups/a/a/bevel_p1.s
 * STATUS:   behavioural
 *
 * The same forwarder shape as bevel_draw_bevel_frame_with_top.c, with a
 * different first callee. 62 bytes against 62 -- the reference extract reads
 * 64 because two bytes of inter-function alignment padding follow the RTS.
 *
 * SASC-MISMATCH: parameter-load-order
 *   ref:     2e2f001c 2c2f0020 2a2f0024 282f0028 266f0018   loads a..d, then rp
 *   got:     282f0028 2a2f0024 2c2f0020 2e2f001c 2a6f0018   loads d..a, then rp
 *   summary: the same five loads from the same five stack slots, in the
 *            opposite order, at the same cost. SAS/C 6.51 emits its parameter
 *            loads in reverse declaration order. Nothing in the body reaches
 *            it: the loads happen in the prologue.
 *   scope:   every restoration with two or more register-cached parameters.
 *   retest:  a compiler that loads parameters in declaration order matches.
 *
 * SASC-MISMATCH: callee-saved-address-register
 *   ref:     266f0018 ... 2f0b ... 4cdf08f0     rp in A3
 *   got:     2a6f0018 ... 2f0d ... 4cdf20f0     rp in A5
 *   summary: same instructions, same sizes, different address register. No
 *            locals means no LINK, so A5 is free and SAS/C 6.51 takes it
 *            first. The original took A3.
 *   scope:   program-wide, every LINK-less function that caches a pointer.
 *   retest:  a compiler that allocates A3 before A5 matches.
 *
 * SASC-MISMATCH: external-call-width
 *   ref:     6100ff3a ... 6100fe44      BSR.W, twice, with real displacements
 *   got:     61000000 ... 61000000      BSR.W, twice, relocated
 *   summary: same opcode and same size. The displacement is a link-time
 *            field, so this region is not a divergence at all -- it is listed
 *            only because cdiff reports the unresolved bytes.
 */
extern void BEVEL_DrawBeveledFrame(void *rp, long a, long b, long c, long d);
extern void BEVEL_DrawHorizontalBevel(void *rp, long a, long b, long c, long d);

void BEVEL_DrawBevelFrameWithTopRight(void *rp, long a, long b, long c, long d)
{
    BEVEL_DrawBeveledFrame(rp, a, b, c, d);
    BEVEL_DrawHorizontalBevel(rp, a, b, c, d);
}
