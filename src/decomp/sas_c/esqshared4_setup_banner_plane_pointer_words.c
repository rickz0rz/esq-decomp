typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned long ULONG;

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
void ESQSHARED4_SetBannerColorBaseAndLimit(UWORD value);

static void split_ptr(UBYTE *p, UWORD *lo, UWORD *hi)
{
    ULONG v = (ULONG)p;
    *lo = (UWORD)v;
    *hi = (UWORD)(v >> 16);
}

void ESQSHARED4_SetupBannerPlanePointerWords(void)
{
    UBYTE *base;
    UBYTE *p;
    UWORD color;

    base = ESQSHARED_BannerRowScratchRasterBase0;
    p = base + 2992;
    split_ptr(p, &ESQ_BannerPlane0SnapshotScratchPtrLoWord, &ESQ_BannerPlane0SnapshotScratchPtrHiWord);
    p = base + 3080;
    split_ptr(p, &ESQ_BannerPlane0ScratchPtrAlt_LoWord, &ESQ_BannerPlane0ScratchPtrAlt_HiWord);
    p = base + (ULONG)GCOMMAND_BannerRowByteOffsetResetValueDefault;
    ESQPARS2_BannerSnapshotPlane0DstPtr = p;
    ESQPARS2_BannerRowOffsetResetPtrPlane0 = p;
    split_ptr(p, &ESQ_BannerSnapshotPlane0DstPtrLoWord, &ESQ_BannerSnapshotPlane0DstPtrHiWord);
    split_ptr(p, &ESQ_BannerPlane0DstPtrReset_LoWord, &ESQ_BannerPlane0DstPtrReset_HiWord);
    p = base + 6072;
    split_ptr(p, &ESQ_BannerSweepSrcPlane0Ptr_LoWord, &ESQ_BannerSweepSrcPlane0Ptr_HiWord);
    split_ptr(p, &ESQ_BannerSweepSrcPlane0PtrReset_LoWord, &ESQ_BannerSweepSrcPlane0PtrReset_HiWord);

    base = ESQSHARED_BannerRowScratchRasterBase1;
    p = base + 2992;
    split_ptr(p, &ESQ_BannerPlane1SnapshotScratchPtrLoWord, &ESQ_BannerPlane1SnapshotScratchPtrHiWord);
    p = base + 3080;
    split_ptr(p, &ESQ_BannerPlane1ScratchPtrAlt_LoWord, &ESQ_BannerPlane1ScratchPtrAlt_HiWord);
    p = base + (ULONG)GCOMMAND_BannerRowByteOffsetResetValueDefault;
    ESQPARS2_BannerSnapshotPlane1DstPtr = p;
    ESQPARS2_BannerRowOffsetResetPtrPlane1 = p;
    split_ptr(p, &ESQ_BannerSnapshotPlane1DstPtrLoWord, &ESQ_BannerSnapshotPlane1DstPtrHiWord);
    split_ptr(p, &ESQ_BannerPlane1DstPtrReset_LoWord, &ESQ_BannerPlane1DstPtrReset_HiWord);
    p = base + 6072;
    split_ptr(p, &ESQ_BannerSweepSrcPlane1Ptr_LoWord, &ESQ_BannerSweepSrcPlane1Ptr_HiWord);
    split_ptr(p, &ESQ_BannerSweepSrcPlane1PtrReset_LoWord, &ESQ_BannerSweepSrcPlane1PtrReset_HiWord);

    base = ESQSHARED_BannerRowScratchRasterBase2;
    p = base + 2992;
    split_ptr(p, &ESQ_BannerPlane2SnapshotScratchPtrLoWord, &ESQ_BannerPlane2SnapshotScratchPtrHiWord);
    p = base + 3080;
    split_ptr(p, &ESQ_BannerPlane2ScratchPtrAlt_LoWord, &ESQ_BannerPlane2ScratchPtrAlt_HiWord);
    p = base + (ULONG)GCOMMAND_BannerRowByteOffsetResetValueDefault;
    ESQPARS2_BannerSnapshotPlane2DstPtr = p;
    ESQPARS2_BannerRowOffsetResetPtrPlane2Table = p;
    split_ptr(p, &ESQ_BannerSnapshotPlane2DstPtrLoWord, &ESQ_BannerSnapshotPlane2DstPtrHiWord);
    split_ptr(p, &ESQ_BannerPlane2DstPtrReset_LoWord, &ESQ_BannerPlane2DstPtrReset_HiWord);
    p = base + 6072;
    split_ptr(p, &ESQ_BannerSweepSrcPlane2Ptr_LoWord, &ESQ_BannerSweepSrcPlane2Ptr_HiWord);
    split_ptr(p, &ESQ_BannerSweepSrcPlane2PtrReset_LoWord, &ESQ_BannerSweepSrcPlane2PtrReset_HiWord);

    color = ESQPARS2_BannerColorThreshold;
    ESQSHARED4_SetBannerColorBaseAndLimit(color);
}
