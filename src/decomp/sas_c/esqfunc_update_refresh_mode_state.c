typedef signed long LONG;
typedef signed short WORD;

extern WORD ESQFUNC_WeatherSliceWidthInitGate;
extern LONG NEWGRID_MessagePumpSuspendFlag;
extern LONG NEWGRID_RefreshStateFlag;
extern WORD ESQPARS2_BannerRowWidthBytes;
extern WORD ESQPARS2_BannerCopyBlockSpanBytes;
extern LONG NEWGRID_ModeSelectorState;
extern LONG NEWGRID_LastRefreshRequest;

extern void ESQSHARED4_ComputeBannerRowBlitGeometry(void);

void ESQFUNC_UpdateRefreshModeState(LONG request)
{
    ESQFUNC_WeatherSliceWidthInitGate = 1;

    if (NEWGRID_MessagePumpSuspendFlag != 0) {
        NEWGRID_RefreshStateFlag = 0;
        NEWGRID_MessagePumpSuspendFlag = 0;
        ESQPARS2_BannerRowWidthBytes = 0x90;
        ESQPARS2_BannerCopyBlockSpanBytes = 0x230;
        ESQSHARED4_ComputeBannerRowBlitGeometry();
    }

    if (request == 0) {
        NEWGRID_ModeSelectorState = 0;
    } else {
        NEWGRID_ModeSelectorState = 2;
        if (NEWGRID_LastRefreshRequest == 0) {
            NEWGRID_RefreshStateFlag = 0;
        }
    }

    NEWGRID_LastRefreshRequest = request;
}
