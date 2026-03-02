#include "esq_types.h"

/*
 * Target 610 GCC trial function.
 * Tick banner phase counters based on primary/secondary countdowns.
 */
extern u8 ESQ_STR_6;
extern s16 WDISP_BannerCharPhaseShift;
extern s16 DST_PrimaryCountdown;
extern s16 DST_SecondaryCountdown;

void DST_TickBannerCounters(void) __attribute__((noinline, used));

void DST_TickBannerCounters(void)
{
    s16 phase = (s16)((u8)ESQ_STR_6 - 0x36);
    WDISP_BannerCharPhaseShift = phase;

    if ((s16)(DST_PrimaryCountdown - 1) == 0) {
        WDISP_BannerCharPhaseShift = (s16)(phase - 1);
    }

    if ((s16)(DST_SecondaryCountdown - 1) == 0) {
        WDISP_BannerCharPhaseShift = (s16)(WDISP_BannerCharPhaseShift + 1);
    }
}
