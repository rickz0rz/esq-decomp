#include "esq_types.h"

/*
 * Target 136 GCC trial function.
 * Jump-table stub forwarding to TEXTDISP_DrawChannelBanner.
 */
void TEXTDISP_DrawChannelBanner(s32 mode, s32 draw_mode) __attribute__((noinline));

void ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner(s32 mode, s32 draw_mode) __attribute__((noinline, used));

void ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner(s32 mode, s32 draw_mode)
{
    TEXTDISP_DrawChannelBanner(mode, draw_mode);
}
