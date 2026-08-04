/* RESTORES: ESQSHARED4_AdvancePlanePointersOneRow
 * MODULE:   modules/groups/a/q/esqshared4_p3_p0.s   (1 of its 3 blocks)
 * STATUS:   behavioural
 *
 * Advances all six banner plane pointers -- three snapshot destinations and
 * three sweep sources -- by 0xb0 bytes, which is one banner row.
 *
 * THE BLOCK CARRIED NO LABEL UNTIL 2026-08-04. See the note in
 * esqshared4_mirror_snapshot_plane_pointers.c: labelling the two unnamed blocks
 * in this module corrected their neighbour's reference from 388 bytes to 234,
 * and is byte-neutral. The name is OURS, chosen from what the block does.
 *
 * IT IS DEAD. Nothing reaches it, by name or by fall-through.
 *
 * EACH POINTER IS A 32-BIT VALUE SPLIT ACROSS TWO NON-ADJACENT COPPER WORDS,
 * so it cannot be incremented as a long. The original adds 0xb0 to the low word
 * and propagates the carry into the high word by hand:
 *
 *     ADD.W  D1,<lo>        ; D1 = 0xb0
 *     BCC.S  .next          ; no carry out of 16 bits -- skip
 *     ADD.W  D0,<hi>        ; D0 = 1
 *
 * `BCC` is the UNSIGNED carry, so the C test is `sum < old` on unsigned shorts.
 * Writing it as a signed overflow test, or letting the compiler widen the
 * addition to a long, would carry on the wrong condition.
 *
 * WRITTEN OUT SIX TIMES RATHER THAN THROUGH A HELPER, because the original is
 * straight-line. A static helper taking the two pointers reads better and emits
 * six calls the original does not have.
 *
 * SASC-MISMATCH: read-modify-write-on-memory
 *   ref:     ADD.W D1,abs -- the 68000 adds straight to memory, and the same
 *            constant stays in D1 across all six sites
 *   got:     a load, an add and a store per site, with the constant
 *            rematerialised
 *   summary: SAS/C 6.51 does not emit an add with a memory destination here.
 *            Six sites, each a few bytes wider. The carry propagation and the
 *            order of the six pointers are the same.
 *   tried:   holding 0xb0 in a local, which is what keeps the constant from
 *            being folded into each add separately; it helps and does not
 *            close the gap.
 *   scope:   program-wide.
 *   retest:  a compiler that emits ADD.W Dn,abs.
 */
extern unsigned short ESQ_BannerSnapshotPlane0DstPtrLoWord;
extern unsigned short ESQ_BannerSnapshotPlane0DstPtrHiWord;
extern unsigned short ESQ_BannerSnapshotPlane1DstPtrLoWord;
extern unsigned short ESQ_BannerSnapshotPlane1DstPtrHiWord;
extern unsigned short ESQ_BannerSnapshotPlane2DstPtrLoWord;
extern unsigned short ESQ_BannerSnapshotPlane2DstPtrHiWord;
extern unsigned short ESQ_BannerSweepSrcPlane0Ptr_LoWord;
extern unsigned short ESQ_BannerSweepSrcPlane0Ptr_HiWord;
extern unsigned short ESQ_BannerSweepSrcPlane1Ptr_LoWord;
extern unsigned short ESQ_BannerSweepSrcPlane1Ptr_HiWord;
extern unsigned short ESQ_BannerSweepSrcPlane2Ptr_LoWord;
extern unsigned short ESQ_BannerSweepSrcPlane2Ptr_HiWord;

void ESQSHARED4_AdvancePlanePointersOneRow(void)
{
    unsigned short step = 0xb0;
    unsigned short one  = 1;
    unsigned short old;

    old = ESQ_BannerSnapshotPlane0DstPtrLoWord;
    ESQ_BannerSnapshotPlane0DstPtrLoWord = (unsigned short)(old + step);
    if (ESQ_BannerSnapshotPlane0DstPtrLoWord < old)
        ESQ_BannerSnapshotPlane0DstPtrHiWord += one;

    old = ESQ_BannerSnapshotPlane1DstPtrLoWord;
    ESQ_BannerSnapshotPlane1DstPtrLoWord = (unsigned short)(old + step);
    if (ESQ_BannerSnapshotPlane1DstPtrLoWord < old)
        ESQ_BannerSnapshotPlane1DstPtrHiWord += one;

    old = ESQ_BannerSnapshotPlane2DstPtrLoWord;
    ESQ_BannerSnapshotPlane2DstPtrLoWord = (unsigned short)(old + step);
    if (ESQ_BannerSnapshotPlane2DstPtrLoWord < old)
        ESQ_BannerSnapshotPlane2DstPtrHiWord += one;

    old = ESQ_BannerSweepSrcPlane0Ptr_LoWord;
    ESQ_BannerSweepSrcPlane0Ptr_LoWord = (unsigned short)(old + step);
    if (ESQ_BannerSweepSrcPlane0Ptr_LoWord < old)
        ESQ_BannerSweepSrcPlane0Ptr_HiWord += one;

    old = ESQ_BannerSweepSrcPlane1Ptr_LoWord;
    ESQ_BannerSweepSrcPlane1Ptr_LoWord = (unsigned short)(old + step);
    if (ESQ_BannerSweepSrcPlane1Ptr_LoWord < old)
        ESQ_BannerSweepSrcPlane1Ptr_HiWord += one;

    old = ESQ_BannerSweepSrcPlane2Ptr_LoWord;
    ESQ_BannerSweepSrcPlane2Ptr_LoWord = (unsigned short)(old + step);
    if (ESQ_BannerSweepSrcPlane2Ptr_LoWord < old)
        ESQ_BannerSweepSrcPlane2Ptr_HiWord += one;
}
