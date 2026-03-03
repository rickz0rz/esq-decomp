#include "esq_types.h"

extern u8 *WDISP_BannerWorkRasterPtr;

extern u16 ESQ_BannerWorkRasterPtrA_LoWord;
extern u16 ESQ_BannerWorkRasterPtrMirrorA_LoWord;
extern u16 ESQ_CopperBannerRasterPointerListA;
extern u16 ESQ_BannerWorkRasterPtrB_LoWord;
extern u16 ESQ_BannerWorkRasterPtrMirrorB_LoWord;
extern u16 ESQ_CopperBannerRasterPointerListB;

extern u16 ESQ_BannerWorkRasterPtrA_HiWord;
extern u16 ESQ_BannerWorkRasterPtrMirrorA_HiWord;
extern u16 ESQ_BannerWorkRasterPtrTailA_HiWord;
extern u16 ESQ_BannerWorkRasterPtrB_HiWord;
extern u16 ESQ_BannerWorkRasterPtrMirrorB_HiWord;
extern u16 ESQ_BannerWorkRasterPtrTailB_HiWord;

void ESQSHARED4_ClearBannerWorkRasterWithOnes(void) __attribute__((noinline));
void ESQSHARED4_BindAndClearBannerWorkRaster(void) __attribute__((noinline, used));

void ESQSHARED4_BindAndClearBannerWorkRaster(void)
{
    u32 addr = (u32)WDISP_BannerWorkRasterPtr;
    u16 lo = (u16)addr;
    u16 hi = (u16)(addr >> 16);

    ESQ_BannerWorkRasterPtrA_LoWord = lo;
    ESQ_BannerWorkRasterPtrMirrorA_LoWord = lo;
    ESQ_CopperBannerRasterPointerListA = lo;
    ESQ_BannerWorkRasterPtrB_LoWord = lo;
    ESQ_BannerWorkRasterPtrMirrorB_LoWord = lo;
    ESQ_CopperBannerRasterPointerListB = lo;

    ESQ_BannerWorkRasterPtrA_HiWord = hi;
    ESQ_BannerWorkRasterPtrMirrorA_HiWord = hi;
    ESQ_BannerWorkRasterPtrTailA_HiWord = hi;
    ESQ_BannerWorkRasterPtrB_HiWord = hi;
    ESQ_BannerWorkRasterPtrMirrorB_HiWord = hi;
    ESQ_BannerWorkRasterPtrTailB_HiWord = hi;

    ESQSHARED4_ClearBannerWorkRasterWithOnes();
}
