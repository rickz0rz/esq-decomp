#include <exec/types.h>

extern UBYTE *ESQSHARED_BannerRowScratchRasterBase0;
extern UBYTE *ESQSHARED_BannerRowScratchRasterBase1;
extern UBYTE *ESQSHARED_BannerRowScratchRasterBase2;

extern UBYTE *ESQPARS2_BannerSnapshotPlane0DstPtr;
extern UBYTE *ESQPARS2_BannerSnapshotPlane1DstPtr;
extern UBYTE *ESQPARS2_BannerSnapshotPlane2DstPtr;

extern UBYTE *ESQPARS2_BannerRowOffsetResetPtrPlane0;
extern UBYTE *ESQPARS2_BannerRowOffsetResetPtrPlane1;
extern UBYTE *ESQPARS2_BannerRowOffsetResetPtrPlane2Table;

extern ULONG GCOMMAND_BannerRowByteOffsetResetValueDefault;

extern UWORD ESQ_BannerPlane0SnapshotScratchPtrLoWord;
extern UWORD ESQ_BannerPlane0SnapshotScratchPtrHiWord;
extern UWORD ESQ_BannerPlane0ScratchPtrAlt_LoWord;
extern UWORD ESQ_BannerPlane0ScratchPtrAlt_HiWord;
extern UWORD ESQ_BannerSnapshotPlane0DstPtrLoWord;
extern UWORD ESQ_BannerSnapshotPlane0DstPtrHiWord;
extern UWORD ESQ_BannerPlane0DstPtrReset_LoWord;
extern UWORD ESQ_BannerPlane0DstPtrReset_HiWord;
extern UWORD ESQ_BannerSweepSrcPlane0Ptr_LoWord;
extern UWORD ESQ_BannerSweepSrcPlane0Ptr_HiWord;
extern UWORD ESQ_BannerSweepSrcPlane0PtrReset_LoWord;
extern UWORD ESQ_BannerSweepSrcPlane0PtrReset_HiWord;

extern UWORD ESQ_BannerPlane1SnapshotScratchPtrLoWord;
extern UWORD ESQ_BannerPlane1SnapshotScratchPtrHiWord;
extern UWORD ESQ_BannerPlane1ScratchPtrAlt_LoWord;
extern UWORD ESQ_BannerPlane1ScratchPtrAlt_HiWord;
extern UWORD ESQ_BannerSnapshotPlane1DstPtrLoWord;
extern UWORD ESQ_BannerSnapshotPlane1DstPtrHiWord;
extern UWORD ESQ_BannerPlane1DstPtrReset_LoWord;
extern UWORD ESQ_BannerPlane1DstPtrReset_HiWord;
extern UWORD ESQ_BannerSweepSrcPlane1Ptr_LoWord;
extern UWORD ESQ_BannerSweepSrcPlane1Ptr_HiWord;
extern UWORD ESQ_BannerSweepSrcPlane1PtrReset_LoWord;
extern UWORD ESQ_BannerSweepSrcPlane1PtrReset_HiWord;

extern UWORD ESQ_BannerPlane2SnapshotScratchPtrLoWord;
extern UWORD ESQ_BannerPlane2SnapshotScratchPtrHiWord;
extern UWORD ESQ_BannerPlane2ScratchPtrAlt_LoWord;
extern UWORD ESQ_BannerPlane2ScratchPtrAlt_HiWord;
extern UWORD ESQ_BannerSnapshotPlane2DstPtrLoWord;
extern UWORD ESQ_BannerSnapshotPlane2DstPtrHiWord;
extern UWORD ESQ_BannerPlane2DstPtrReset_LoWord;
extern UWORD ESQ_BannerPlane2DstPtrReset_HiWord;
extern UWORD ESQ_BannerSweepSrcPlane2Ptr_LoWord;
extern UWORD ESQ_BannerSweepSrcPlane2Ptr_HiWord;
extern UWORD ESQ_BannerSweepSrcPlane2PtrReset_LoWord;
extern UWORD ESQ_BannerSweepSrcPlane2PtrReset_HiWord;

extern UWORD ESQPARS2_BannerColorThreshold;
extern void ESQSHARED4_SetBannerColorBaseAndLimit(UWORD value);

void ESQSHARED4_SetupBannerPlanePointerWords(void)
{
    UBYTE *base;
    UBYTE *p;
    ULONG ptrValue;

    base = ESQSHARED_BannerRowScratchRasterBase0;
    p = base + 2992;
    ptrValue = (ULONG)p;
    ESQ_BannerPlane0SnapshotScratchPtrLoWord = (UWORD)ptrValue;
    ptrValue >>= 16;
    ESQ_BannerPlane0SnapshotScratchPtrHiWord = (UWORD)ptrValue;
    p = base + 3080;
    ptrValue = (ULONG)p;
    ESQ_BannerPlane0ScratchPtrAlt_LoWord = (UWORD)ptrValue;
    ptrValue >>= 16;
    ESQ_BannerPlane0ScratchPtrAlt_HiWord = (UWORD)ptrValue;
    p = base + (ULONG)GCOMMAND_BannerRowByteOffsetResetValueDefault;
    ESQPARS2_BannerSnapshotPlane0DstPtr = p;
    ESQPARS2_BannerRowOffsetResetPtrPlane0 = p;
    ptrValue = (ULONG)p;
    ESQ_BannerSnapshotPlane0DstPtrLoWord = (UWORD)ptrValue;
    ESQ_BannerPlane0DstPtrReset_LoWord = (UWORD)ptrValue;
    ptrValue >>= 16;
    ESQ_BannerSnapshotPlane0DstPtrHiWord = (UWORD)ptrValue;
    ESQ_BannerPlane0DstPtrReset_HiWord = (UWORD)ptrValue;
    p = base + 6072;
    ptrValue = (ULONG)p;
    ESQ_BannerSweepSrcPlane0Ptr_LoWord = (UWORD)ptrValue;
    ESQ_BannerSweepSrcPlane0PtrReset_LoWord = (UWORD)ptrValue;
    ptrValue >>= 16;
    ESQ_BannerSweepSrcPlane0Ptr_HiWord = (UWORD)ptrValue;
    ESQ_BannerSweepSrcPlane0PtrReset_HiWord = (UWORD)ptrValue;

    base = ESQSHARED_BannerRowScratchRasterBase1;
    p = base + 2992;
    ptrValue = (ULONG)p;
    ESQ_BannerPlane1SnapshotScratchPtrLoWord = (UWORD)ptrValue;
    ptrValue >>= 16;
    ESQ_BannerPlane1SnapshotScratchPtrHiWord = (UWORD)ptrValue;
    p = base + 3080;
    ptrValue = (ULONG)p;
    ESQ_BannerPlane1ScratchPtrAlt_LoWord = (UWORD)ptrValue;
    ptrValue >>= 16;
    ESQ_BannerPlane1ScratchPtrAlt_HiWord = (UWORD)ptrValue;
    p = base + (ULONG)GCOMMAND_BannerRowByteOffsetResetValueDefault;
    ESQPARS2_BannerSnapshotPlane1DstPtr = p;
    ESQPARS2_BannerRowOffsetResetPtrPlane1 = p;
    ptrValue = (ULONG)p;
    ESQ_BannerSnapshotPlane1DstPtrLoWord = (UWORD)ptrValue;
    ESQ_BannerPlane1DstPtrReset_LoWord = (UWORD)ptrValue;
    ptrValue >>= 16;
    ESQ_BannerSnapshotPlane1DstPtrHiWord = (UWORD)ptrValue;
    ESQ_BannerPlane1DstPtrReset_HiWord = (UWORD)ptrValue;
    p = base + 6072;
    ptrValue = (ULONG)p;
    ESQ_BannerSweepSrcPlane1Ptr_LoWord = (UWORD)ptrValue;
    ESQ_BannerSweepSrcPlane1PtrReset_LoWord = (UWORD)ptrValue;
    ptrValue >>= 16;
    ESQ_BannerSweepSrcPlane1Ptr_HiWord = (UWORD)ptrValue;
    ESQ_BannerSweepSrcPlane1PtrReset_HiWord = (UWORD)ptrValue;

    base = ESQSHARED_BannerRowScratchRasterBase2;
    p = base + 2992;
    ptrValue = (ULONG)p;
    ESQ_BannerPlane2SnapshotScratchPtrLoWord = (UWORD)ptrValue;
    ptrValue >>= 16;
    ESQ_BannerPlane2SnapshotScratchPtrHiWord = (UWORD)ptrValue;
    p = base + 3080;
    ptrValue = (ULONG)p;
    ESQ_BannerPlane2ScratchPtrAlt_LoWord = (UWORD)ptrValue;
    ptrValue >>= 16;
    ESQ_BannerPlane2ScratchPtrAlt_HiWord = (UWORD)ptrValue;
    p = base + (ULONG)GCOMMAND_BannerRowByteOffsetResetValueDefault;
    ESQPARS2_BannerSnapshotPlane2DstPtr = p;
    ESQPARS2_BannerRowOffsetResetPtrPlane2Table = p;
    ptrValue = (ULONG)p;
    ESQ_BannerSnapshotPlane2DstPtrLoWord = (UWORD)ptrValue;
    ESQ_BannerPlane2DstPtrReset_LoWord = (UWORD)ptrValue;
    ptrValue >>= 16;
    ESQ_BannerSnapshotPlane2DstPtrHiWord = (UWORD)ptrValue;
    ESQ_BannerPlane2DstPtrReset_HiWord = (UWORD)ptrValue;
    p = base + 6072;
    ptrValue = (ULONG)p;
    ESQ_BannerSweepSrcPlane2Ptr_LoWord = (UWORD)ptrValue;
    ESQ_BannerSweepSrcPlane2PtrReset_LoWord = (UWORD)ptrValue;
    ptrValue >>= 16;
    ESQ_BannerSweepSrcPlane2Ptr_HiWord = (UWORD)ptrValue;
    ESQ_BannerSweepSrcPlane2PtrReset_HiWord = (UWORD)ptrValue;

    ESQSHARED4_SetBannerColorBaseAndLimit(ESQPARS2_BannerColorThreshold);
}
