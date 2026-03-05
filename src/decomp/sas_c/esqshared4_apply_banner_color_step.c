typedef unsigned short UWORD;

void ESQSHARED4_SetBannerCopperColorAndThreshold(UWORD value);
void ESQSHARED4_BindAndClearBannerWorkRaster(UWORD span);

void ESQSHARED4_ApplyBannerColorStep(UWORD color)
{
    ESQSHARED4_SetBannerCopperColorAndThreshold(color);
    ESQSHARED4_BindAndClearBannerWorkRaster(0x58);
}
