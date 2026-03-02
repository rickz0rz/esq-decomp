#include "esq_types.h"

extern u8 TEXTDISP_BannerCharSelected;
extern u8 TEXTDISP_BannerCharFallback;
extern s16 TEXTDISP_CurrentMatchIndex;

void SCRIPT_ResetBannerCharDefaults(void) __attribute__((noinline, used));

void SCRIPT_ResetBannerCharDefaults(void)
{
    TEXTDISP_BannerCharSelected = 0x64;
    TEXTDISP_BannerCharFallback = 0x31;
    TEXTDISP_CurrentMatchIndex = -1;
}
