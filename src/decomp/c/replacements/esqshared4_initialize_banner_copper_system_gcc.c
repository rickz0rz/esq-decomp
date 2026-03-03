#include "esq_types.h"

extern u16 ESQPARS2_BannerSweepBaseColor;
extern u16 ESQPARS2_BannerSweepOffsetColor;
extern u16 ESQPARS2_ReadModeFlags;
extern u16 ESQPARS2_StateIndex;
extern u16 ESQPARS2_HighlightTickCountdown;
extern u16 ESQPARS2_CopperProgramPendingFlag;
extern u16 CONFIG_BannerCopperHeadByte;
extern u8 ESQ_CopperListBannerA;
extern u8 ESQ_CopperListBannerB;
extern volatile u8 CIAB_PRA;

void ESQSHARED4_SnapshotDisplayBufferBases(void) __attribute__((noinline));
void ESQSHARED4_ResetBannerColorSweepState(void) __attribute__((noinline));
void ESQSHARED4_SetupBannerPlanePointerWords(void) __attribute__((noinline));

void ESQSHARED4_InitializeBannerCopperSystem(void) __attribute__((noinline, used));

void ESQSHARED4_InitializeBannerCopperSystem(void)
{
    u16 d0;
    u8 d1;

    d0 = 0x62;
    ESQPARS2_BannerSweepBaseColor = d0;
    d0 = (u16)(d0 - 2);
    ESQPARS2_BannerSweepOffsetColor = d0;
    ESQPARS2_ReadModeFlags = 5;
    ESQPARS2_StateIndex = 2;
    ESQPARS2_HighlightTickCountdown = 10;

    ESQSHARED4_SnapshotDisplayBufferBases();
    ESQSHARED4_ResetBannerColorSweepState();
    ESQSHARED4_SetupBannerPlanePointerWords();

    d1 = CIAB_PRA;
    d1 = (u8)(d1 | 0x80);
    CIAB_PRA = d1;
    d1 = CIAB_PRA;
    d1 = (u8)(d1 | 0x40);
    CIAB_PRA = d1;

    d0 = CONFIG_BannerCopperHeadByte;
    ESQ_CopperListBannerA = (u8)d0;
    ESQ_CopperListBannerB = (u8)d0;
    ESQPARS2_CopperProgramPendingFlag = 1;
}
