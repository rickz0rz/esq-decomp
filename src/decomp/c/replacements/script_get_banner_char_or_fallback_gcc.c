#include "esq_types.h"

extern u8 TEXTDISP_BannerCharSelected;
extern u8 TEXTDISP_BannerCharFallback;

s32 SCRIPT_GetBannerCharOrFallback(void) __attribute__((noinline, used));

s32 SCRIPT_GetBannerCharOrFallback(void)
{
    u8 selected = TEXTDISP_BannerCharSelected;
    if (selected == 100) {
        return (s32)TEXTDISP_BannerCharFallback;
    }
    return (s32)selected;
}
