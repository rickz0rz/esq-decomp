typedef unsigned char UBYTE;
typedef unsigned short UWORD;

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
    UWORD d0;
    UBYTE d1;

    d0 = 0x62;
    ESQPARS2_BannerSweepBaseColor = d0;
    d0 = (UWORD)(d0 - 2);
    ESQPARS2_BannerSweepOffsetColor = d0;
    ESQPARS2_ReadModeFlags = 5;
    ESQPARS2_StateIndex = 2;
    ESQPARS2_HighlightTickCountdown = 10;

    ESQSHARED4_SnapshotDisplayBufferBases();
    ESQSHARED4_ResetBannerColorSweepState();
    ESQSHARED4_SetupBannerPlanePointerWords();

    d1 = CIAB_PRA;
    d1 = (UBYTE)(d1 | 0x80);
    CIAB_PRA = d1;
    d1 = CIAB_PRA;
    d1 = (UBYTE)(d1 | 0x40);
    CIAB_PRA = d1;

    d0 = CONFIG_BannerCopperHeadByte;
    ESQ_CopperListBannerA = (UBYTE)d0;
    ESQ_CopperListBannerB = (UBYTE)d0;
    ESQPARS2_CopperProgramPendingFlag = 1;
}
