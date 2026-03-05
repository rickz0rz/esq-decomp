typedef unsigned short UWORD;
typedef unsigned long ULONG;

extern ULONG *WDISP_BannerWorkRasterPtr;

extern UWORD ESQ_BannerWorkRasterPtrA_LoWord;
extern UWORD ESQ_BannerWorkRasterPtrMirrorA_LoWord;
extern UWORD ESQ_CopperBannerRasterPointerListA;
extern UWORD ESQ_BannerWorkRasterPtrB_LoWord;
extern UWORD ESQ_BannerWorkRasterPtrMirrorB_LoWord;
extern UWORD ESQ_CopperBannerRasterPointerListB;

extern UWORD ESQ_BannerWorkRasterPtrA_HiWord;
extern UWORD ESQ_BannerWorkRasterPtrMirrorA_HiWord;
extern UWORD ESQ_BannerWorkRasterPtrTailA_HiWord;
extern UWORD ESQ_BannerWorkRasterPtrB_HiWord;
extern UWORD ESQ_BannerWorkRasterPtrMirrorB_HiWord;
extern UWORD ESQ_BannerWorkRasterPtrTailB_HiWord;

void ESQSHARED4_ClearBannerWorkRasterWithOnes(void);

void ESQSHARED4_BindAndClearBannerWorkRaster(void)
{
    ULONG value;
    UWORD lo;
    UWORD hi;

    value = (ULONG)WDISP_BannerWorkRasterPtr;
    lo = (UWORD)value;

    ESQ_BannerWorkRasterPtrA_LoWord = lo;
    ESQ_BannerWorkRasterPtrMirrorA_LoWord = lo;
    ESQ_CopperBannerRasterPointerListA = lo;
    ESQ_BannerWorkRasterPtrB_LoWord = lo;
    ESQ_BannerWorkRasterPtrMirrorB_LoWord = lo;
    ESQ_CopperBannerRasterPointerListB = lo;

    hi = (UWORD)(value >> 16);
    ESQ_BannerWorkRasterPtrA_HiWord = hi;
    ESQ_BannerWorkRasterPtrMirrorA_HiWord = hi;
    ESQ_BannerWorkRasterPtrTailA_HiWord = hi;
    ESQ_BannerWorkRasterPtrB_HiWord = hi;
    ESQ_BannerWorkRasterPtrMirrorB_HiWord = hi;
    ESQ_BannerWorkRasterPtrTailB_HiWord = hi;

    ESQSHARED4_ClearBannerWorkRasterWithOnes();
}
