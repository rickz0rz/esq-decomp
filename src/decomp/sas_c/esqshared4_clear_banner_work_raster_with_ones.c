#include <exec/types.h>
extern ULONG *WDISP_BannerWorkRasterPtr;

void ESQSHARED4_ClearBannerWorkRasterWithOnes(void)
{
    ULONG *p;
    UWORD i;

    p = WDISP_BannerWorkRasterPtr;
    for (i = 0; i <= 0x149; i++) {
        *p++ = 0xFFFFFFFFUL;
    }
}
