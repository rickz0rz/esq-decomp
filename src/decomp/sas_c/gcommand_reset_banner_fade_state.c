typedef unsigned short UWORD;
typedef unsigned long ULONG;

extern UWORD GCOMMAND_BannerFadeResetPendingFlag;
extern ULONG ESQSHARED4_InterleaveCopyBaseOffset;
extern ULONG ESQSHARED4_InterleaveCopyTailOffsetReset;
extern void GCOMMAND_BuildBannerTables(void *a0, ULONG a1, ULONG a2);

void GCOMMAND_ResetBannerFadeState(void)
{
    if (GCOMMAND_BannerFadeResetPendingFlag == 0) {
        return;
    }

    GCOMMAND_BannerFadeResetPendingFlag = 0;
    GCOMMAND_BuildBannerTables((void *)128UL, 0x80FEUL, 0UL);
    ESQSHARED4_InterleaveCopyBaseOffset = 128UL;
    ESQSHARED4_InterleaveCopyTailOffsetReset = 128UL + 0x264UL;
}
