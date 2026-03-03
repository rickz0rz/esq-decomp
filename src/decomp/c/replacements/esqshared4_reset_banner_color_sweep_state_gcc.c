#include "esq_types.h"

extern u8 ESQ_CopperBannerTailListA;
extern u8 ESQ_CopperBannerTailListB;
extern u16 CONFIG_BannerCopperHeadByte;
extern u16 ESQPARS2_BannerTailBiasValue;
extern u16 ESQPARS2_BannerColorStepCounter;
extern u16 ESQPARS2_BannerSweepEntryGuardCounter;

void ESQSHARED4_ResetBannerColorToStart(void) __attribute__((noinline));
void ESQSHARED4_ResetBannerColorSweepState(void) __attribute__((noinline, used));

void ESQSHARED4_ResetBannerColorSweepState(void)
{
    u16 value;

    ESQ_CopperBannerTailListA = 0xF6;
    ESQ_CopperBannerTailListB = 0xF6;

    value = 0xF5;
    value = (u16)(value + CONFIG_BannerCopperHeadByte);
    value = (u16)(value - 0x80);
    ESQPARS2_BannerTailBiasValue = value;

    ESQPARS2_BannerColorStepCounter = 0x62;
    ESQPARS2_BannerSweepEntryGuardCounter = 1;
    ESQSHARED4_ResetBannerColorToStart();
}
