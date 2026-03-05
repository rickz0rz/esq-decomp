typedef unsigned char UBYTE;
typedef unsigned short UWORD;

extern UBYTE ESQ_CopperListBannerA;
extern UBYTE ESQ_CopperListBannerB;
extern UBYTE ESQ_BannerSweepWaitRowA;
extern UBYTE ESQ_BannerSweepWaitRowB;
extern UBYTE ESQ_BannerSweepWaitStartProgramA;
extern UBYTE ESQ_BannerSweepWaitStartProgramB;
extern UBYTE ESQ_BannerSweepWaitEndProgramA;
extern UBYTE ESQ_BannerSweepWaitEndProgramB;
extern UWORD ESQPARS2_BannerColorThreshold;

void ESQSHARED4_SetBannerCopperColorAndThreshold(UBYTE value)
{
    UWORD d0;

    ESQ_CopperListBannerA = value;
    ESQ_CopperListBannerB = value;

    d0 = (UWORD)(UBYTE)(value + 1);
    ESQ_BannerSweepWaitRowA = (UBYTE)d0;
    ESQ_BannerSweepWaitRowB = (UBYTE)d0;

    d0 = (UWORD)(UBYTE)(d0 + 0x11);
    ESQ_BannerSweepWaitStartProgramA = (UBYTE)d0;
    ESQ_BannerSweepWaitStartProgramB = (UBYTE)d0;

    d0 = (UWORD)(UBYTE)(d0 + 1);
    ESQ_BannerSweepWaitEndProgramA = (UBYTE)d0;
    ESQ_BannerSweepWaitEndProgramB = (UBYTE)d0;

    ESQPARS2_BannerColorThreshold = (UWORD)(d0 & 0xFF);
}
