#include <exec/types.h>
extern UBYTE ESQ_STR_6;
extern WORD WDISP_BannerCharPhaseShift;
extern WORD DST_PrimaryCountdown;
extern WORD DST_SecondaryCountdown;

void DST_TickBannerCounters(void)
{
    WORD phase = (WORD)((UBYTE)ESQ_STR_6 - 0x36);
    WDISP_BannerCharPhaseShift = phase;

    if ((WORD)(DST_PrimaryCountdown - 1) == 0) {
        WDISP_BannerCharPhaseShift = (WORD)(phase - 1);
    }

    if ((WORD)(DST_SecondaryCountdown - 1) == 0) {
        WDISP_BannerCharPhaseShift = (WORD)(WDISP_BannerCharPhaseShift + 1);
    }
}
