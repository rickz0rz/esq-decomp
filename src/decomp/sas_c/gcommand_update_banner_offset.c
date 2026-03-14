#include <exec/types.h>
extern LONG GCOMMAND_BannerRowIndexCurrent;
extern LONG GCOMMAND_BannerRowIndexPrevious;
extern unsigned char ESQ_CopperListBannerA[];
extern unsigned char ESQ_CopperListBannerB[];

extern void GCOMMAND_UpdateBannerRowPointers(void *tablePtr);

void GCOMMAND_UpdateBannerOffset(BYTE delta)
{
    if (delta == 0) {
        return;
    }

    GCOMMAND_BannerRowIndexPrevious = GCOMMAND_BannerRowIndexCurrent;
    GCOMMAND_BannerRowIndexCurrent -= (LONG)delta;

    while (GCOMMAND_BannerRowIndexCurrent >= 98) {
        GCOMMAND_BannerRowIndexCurrent -= 98;
    }

    while (GCOMMAND_BannerRowIndexCurrent < 0) {
        GCOMMAND_BannerRowIndexCurrent += 98;
    }

    GCOMMAND_UpdateBannerRowPointers(ESQ_CopperListBannerA);
    GCOMMAND_UpdateBannerRowPointers(ESQ_CopperListBannerB);
}
