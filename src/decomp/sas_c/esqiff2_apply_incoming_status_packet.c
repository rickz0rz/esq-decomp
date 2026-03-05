typedef unsigned char UBYTE;
typedef signed char BYTE;
typedef unsigned short UWORD;
typedef signed short WORD;
typedef unsigned long ULONG;
typedef signed long LONG;

extern UBYTE ED_DiagVinModeChar;
extern UBYTE ESQ_STR_B[];
extern LONG LOCAVAIL_FilterModeFlag;
extern WORD SCRIPT_RuntimeMode;
extern LONG SCRIPT_RuntimeModeDeferredFlag;
extern UBYTE ESQ_STR_6;
extern void *DST_BannerWindowPrimary;
extern UBYTE CLOCK_MinuteEventBaseMinute;
extern UBYTE CLOCK_MinuteEventBaseOffset;
extern WORD ED_DiagnosticsScreenActive;
extern LONG ED_SavedScrollSpeedIndex;
extern UBYTE ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED;
extern WORD ESQPARS2_StateIndex;

extern LONG ESQPARS_JMPTBL_DST_UpdateBannerQueue(void *window);
extern void ESQPARS_JMPTBL_DST_RefreshBannerBuffer(void);
extern void ESQDISP_DrawStatusBanner(UWORD mode);
extern void ESQPARS_JMPTBL_ESQ_SeedMinuteEventThresholds(ULONG minute, ULONG offset);
extern void ED_DrawDiagnosticModeText(void);

void ESQIFF2_ApplyIncomingStatusPacket(UBYTE *src)
{
    UBYTE prev_diag = ED_DiagVinModeChar;
    UWORD i;

    for (i = 0; i < 20; ++i) {
        ESQ_STR_B[i] = src[i];
    }

    if (LOCAVAIL_FilterModeFlag == 0) {
        if (ED_DiagVinModeChar != prev_diag && SCRIPT_RuntimeMode != 0) {
            SCRIPT_RuntimeModeDeferredFlag = 1;
        }
    }

    if (ESQ_STR_6 < 49 || ESQ_STR_6 > 72) {
        ESQ_STR_6 = 0x36;
    }

    if (ESQPARS_JMPTBL_DST_UpdateBannerQueue(DST_BannerWindowPrimary) == 0) {
        ESQPARS_JMPTBL_DST_RefreshBannerBuffer();
    }

    ESQDISP_DrawStatusBanner(1);

    if (CLOCK_MinuteEventBaseMinute > 9 || CLOCK_MinuteEventBaseMinute <= 0) {
        CLOCK_MinuteEventBaseMinute = 1;
    }
    if (CLOCK_MinuteEventBaseOffset > 9 || CLOCK_MinuteEventBaseOffset <= 0) {
        CLOCK_MinuteEventBaseOffset = 1;
    }

    ESQPARS_JMPTBL_ESQ_SeedMinuteEventThresholds((ULONG)CLOCK_MinuteEventBaseMinute, (ULONG)CLOCK_MinuteEventBaseOffset);

    if (ED_DiagnosticsScreenActive != 0) {
        ED_DrawDiagnosticModeText();
    }

    if (ED_SavedScrollSpeedIndex != 0) {
        return;
    }

    {
        LONG v = (LONG)((UBYTE)ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED) - 48;
        if (v >= 1 && v <= 8) {
            ESQPARS2_StateIndex = (WORD)v;
        } else {
            ESQPARS2_StateIndex = 4;
        }
    }
}
