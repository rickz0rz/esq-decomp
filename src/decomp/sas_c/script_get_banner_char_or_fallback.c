#include <exec/types.h>
extern UBYTE TEXTDISP_BannerCharSelected;
extern UBYTE TEXTDISP_BannerCharFallback;

UBYTE SCRIPT_GetBannerCharOrFallback(void)
{
    if (TEXTDISP_BannerCharSelected == 100) {
        return TEXTDISP_BannerCharFallback;
    }
    return TEXTDISP_BannerCharSelected;
}
