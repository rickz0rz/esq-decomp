typedef signed long LONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern void *WDISP_DisplayContextBase;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_HANDLE_PREVUEC_FONT;

extern UBYTE WDISP_AccumulatorRow0_CopperIndexStart;
extern UBYTE WDISP_AccumulatorRow0_CopperIndexEnd;
extern WORD WDISP_AccumulatorRow0_Value;
extern UBYTE WDISP_AccumulatorRow1_CopperIndexStart;
extern UBYTE WDISP_AccumulatorRow1_CopperIndexEnd;
extern WORD WDISP_AccumulatorRow1_Value;
extern UBYTE WDISP_AccumulatorRow2_CopperIndexStart;
extern UBYTE WDISP_AccumulatorRow2_CopperIndexEnd;
extern WORD WDISP_AccumulatorRow2_Value;
extern UBYTE WDISP_AccumulatorRow3_CopperIndexStart;
extern UBYTE WDISP_AccumulatorRow3_CopperIndexEnd;
extern WORD WDISP_AccumulatorRow3_Value;

extern WORD ACCUMULATOR_Row0_CaptureValue;
extern WORD ACCUMULATOR_Row1_CaptureValue;
extern WORD ACCUMULATOR_Row2_CaptureValue;
extern WORD ACCUMULATOR_Row3_CaptureValue;
extern WORD WDISP_AccumulatorCaptureActive;
extern WORD ACCUMULATOR_Row0_Sum;
extern WORD ACCUMULATOR_Row0_SaturateFlag;
extern WORD ACCUMULATOR_Row1_Sum;
extern WORD ACCUMULATOR_Row1_SaturateFlag;
extern WORD ACCUMULATOR_Row2_Sum;
extern WORD ACCUMULATOR_Row2_SaturateFlag;
extern WORD ACCUMULATOR_Row3_Sum;
extern WORD ACCUMULATOR_Row3_SaturateFlag;

extern void TLIBA3_ClearViewModeRastPort(LONG mode, LONG clearPen);
extern void *TLIBA3_BuildDisplayContextForViewMode(LONG mode, LONG a, LONG b);
extern void WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(void);
extern void WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples(void);
extern void WDISP_JMPTBL_ESQIFF_RunCopperDropTransition(void);
extern void TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition(void);
extern void WDISP_DrawWeatherStatusOverlay(void *rastPort, LONG x, LONG y);
extern void WDISP_DrawWeatherStatusSummary(void *rastPort, LONG x, LONG y);
extern void TEXTDISP_ResetSelectionAndRefresh(void);

extern LONG _LVOSetDrMd(void *rastPort, LONG mode);
extern LONG _LVOSetAPen(void *rastPort, LONG pen);
extern LONG _LVOSetFont(void *rastPort, void *font);

void WDISP_HandleWeatherStatusCommand(LONG command)
{
    void *localRastPort;
    LONG width;
    LONG left;
    WORD capture3;

    if (command != 48 && command != 51) {
        TEXTDISP_ResetSelectionAndRefresh();
        return;
    }

    TLIBA3_ClearViewModeRastPort(4, 0);
    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(4, 0, 4);
    WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight();

    localRastPort = (UBYTE *)WDISP_DisplayContextBase + 2;
    width = (LONG)(UWORD)(*(UWORD *)((UBYTE *)WDISP_DisplayContextBase + 4));
    left = (LONG)(UWORD)(*(UWORD *)((UBYTE *)WDISP_DisplayContextBase + 2));

    WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples();
    WDISP_JMPTBL_ESQIFF_RunCopperDropTransition();

    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(3, 0, 0);

    (void)Global_REF_GRAPHICS_LIBRARY;
    _LVOSetDrMd(localRastPort, 0);
    _LVOSetAPen(localRastPort, 1);
    _LVOSetFont(localRastPort, Global_HANDLE_PREVUEC_FONT);

    if (command == 48) {
        WDISP_DrawWeatherStatusOverlay(localRastPort, left, width);
    } else if (command == 51) {
        WDISP_DrawWeatherStatusSummary(localRastPort, left, width);
    }

    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(4, 0, 4);

    if (WDISP_AccumulatorRow0_CopperIndexStart < 32 &&
        WDISP_AccumulatorRow0_CopperIndexEnd < 32 &&
        WDISP_AccumulatorRow0_Value < 0x4000) {
        ACCUMULATOR_Row0_CaptureValue = WDISP_AccumulatorRow0_Value;
    } else {
        ACCUMULATOR_Row0_CaptureValue = 0;
    }

    if (WDISP_AccumulatorRow1_CopperIndexStart < 32 &&
        WDISP_AccumulatorRow1_CopperIndexEnd < 32 &&
        WDISP_AccumulatorRow1_Value < 0x4000) {
        ACCUMULATOR_Row1_CaptureValue = WDISP_AccumulatorRow1_Value;
    } else {
        ACCUMULATOR_Row1_CaptureValue = 0;
    }

    if (WDISP_AccumulatorRow2_CopperIndexStart < 32 &&
        WDISP_AccumulatorRow2_CopperIndexEnd < 32 &&
        WDISP_AccumulatorRow2_Value < 0x4000) {
        ACCUMULATOR_Row2_CaptureValue = WDISP_AccumulatorRow2_Value;
    } else {
        ACCUMULATOR_Row2_CaptureValue = 0;
    }

    if (WDISP_AccumulatorRow3_CopperIndexStart < 32 &&
        WDISP_AccumulatorRow3_CopperIndexEnd < 32 &&
        WDISP_AccumulatorRow3_Value < 0x4000) {
        capture3 = WDISP_AccumulatorRow3_Value;
        ACCUMULATOR_Row3_CaptureValue = capture3;
    } else {
        capture3 = 0;
        ACCUMULATOR_Row3_CaptureValue = 0;
    }

    if (ACCUMULATOR_Row0_CaptureValue != 0 ||
        ACCUMULATOR_Row1_CaptureValue != 0 ||
        ACCUMULATOR_Row2_CaptureValue != 0 ||
        capture3 != 0) {
        WDISP_AccumulatorCaptureActive = 1;
    } else {
        WDISP_AccumulatorCaptureActive = 0;
    }

    ACCUMULATOR_Row0_Sum = 0;
    ACCUMULATOR_Row0_SaturateFlag = 0;
    ACCUMULATOR_Row1_Sum = 0;
    ACCUMULATOR_Row1_SaturateFlag = 0;
    ACCUMULATOR_Row2_Sum = 0;
    ACCUMULATOR_Row2_SaturateFlag = 0;
    ACCUMULATOR_Row3_Sum = 0;
    ACCUMULATOR_Row3_SaturateFlag = 0;

    TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition();
}
