#include <exec/types.h>
extern UWORD ESQPARS2_BannerColorStepCounter;

void ESQSHARED4_SetBannerCopperColorAndThreshold(UWORD value);
void ESQSHARED4_BindAndClearBannerWorkRaster(UWORD span);

void ESQSHARED4_ResetBannerColorToStart(void)
{
    UWORD d0;

    ESQPARS2_BannerColorStepCounter = 0x62;
    d0 = 0x19;

    ESQSHARED4_SetBannerCopperColorAndThreshold(d0);
    ESQSHARED4_BindAndClearBannerWorkRaster(0x58);
}
