#include <exec/types.h>
extern UBYTE ESQ_CopperBannerTailListA;
extern UBYTE ESQ_CopperBannerTailListB;
extern UWORD CONFIG_BannerCopperHeadByte;
extern UWORD ESQPARS2_BannerTailBiasValue;
extern UWORD ESQPARS2_BannerColorStepCounter;
extern UWORD ESQPARS2_BannerSweepEntryGuardCounter;

void ESQSHARED4_ResetBannerColorToStart(void);

void ESQSHARED4_ResetBannerColorSweepState(void)
{
    UWORD value;

    ESQ_CopperBannerTailListA = 0xF6;
    ESQ_CopperBannerTailListB = 0xF6;

    value = 0xF5;
    value = (UWORD)(value + CONFIG_BannerCopperHeadByte);
    value = (UWORD)(value - 0x80);
    ESQPARS2_BannerTailBiasValue = value;

    ESQPARS2_BannerColorStepCounter = 0x62;
    ESQPARS2_BannerSweepEntryGuardCounter = 1;
    ESQSHARED4_ResetBannerColorToStart();
}
