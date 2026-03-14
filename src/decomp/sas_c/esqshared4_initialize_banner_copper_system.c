#include <exec/types.h>
extern UWORD ESQPARS2_BannerSweepBaseColor;
extern UWORD ESQPARS2_BannerSweepOffsetColor;
extern UWORD ESQPARS2_ReadModeFlags;
extern UWORD ESQPARS2_StateIndex;
extern UWORD ESQPARS2_HighlightTickCountdown;
extern UWORD ESQPARS2_CopperProgramPendingFlag;

extern UWORD CONFIG_BannerCopperHeadByte;
extern UBYTE ESQ_CopperListBannerA;
extern UBYTE ESQ_CopperListBannerB;

extern volatile UBYTE CIAB_PRA;

void ESQSHARED4_SnapshotDisplayBufferBases(void);
void ESQSHARED4_ResetBannerColorSweepState(void);
void ESQSHARED4_SetupBannerPlanePointerWords(void);

void ESQSHARED4_InitializeBannerCopperSystem(void)
{
    const UWORD BANNER_BASE_COLOR = 0x62;
    const UWORD BANNER_OFFSET_DELTA = 2;
    const UWORD READMODE_BANNER_INIT = 5;
    const UWORD STATE_INDEX_INIT = 2;
    const UWORD HIGHLIGHT_TICK_INIT = 10;
    const UBYTE CIAB_PRA_SET_BIT7 = 0x80;
    const UBYTE CIAB_PRA_SET_BIT6 = 0x40;
    const UWORD FLAG_PENDING = 1;
    UWORD d0;
    UBYTE d1;

    d0 = BANNER_BASE_COLOR;
    ESQPARS2_BannerSweepBaseColor = d0;
    d0 = (UWORD)(d0 - BANNER_OFFSET_DELTA);
    ESQPARS2_BannerSweepOffsetColor = d0;
    ESQPARS2_ReadModeFlags = READMODE_BANNER_INIT;
    ESQPARS2_StateIndex = STATE_INDEX_INIT;
    ESQPARS2_HighlightTickCountdown = HIGHLIGHT_TICK_INIT;

    ESQSHARED4_SnapshotDisplayBufferBases();
    ESQSHARED4_ResetBannerColorSweepState();
    ESQSHARED4_SetupBannerPlanePointerWords();

    d1 = CIAB_PRA;
    d1 = (UBYTE)(d1 | CIAB_PRA_SET_BIT7);
    CIAB_PRA = d1;
    d1 = CIAB_PRA;
    d1 = (UBYTE)(d1 | CIAB_PRA_SET_BIT6);
    CIAB_PRA = d1;

    d0 = CONFIG_BannerCopperHeadByte;
    ESQ_CopperListBannerA = (UBYTE)d0;
    ESQ_CopperListBannerB = (UBYTE)d0;
    ESQPARS2_CopperProgramPendingFlag = FLAG_PENDING;
}
