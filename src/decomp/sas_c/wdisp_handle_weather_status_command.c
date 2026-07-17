#include <exec/types.h>
#include "wdisp_accumulator_rows.h"

extern void *WDISP_DisplayContextBase;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_HANDLE_PREVUEC_FONT;

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
extern void ESQ_SetCopperEffect_OnEnableHighlight(void);
extern void ESQIFF_RestoreBasePaletteTriples(void);
extern void ESQIFF_RunCopperDropTransition(void);
extern void ESQIFF_RunCopperRiseTransition(void);
extern void WDISP_DrawWeatherStatusOverlay(char *rastPort, LONG x, LONG y);
extern void WDISP_DrawWeatherStatusSummary(char *rastPort, LONG x, LONG y);
extern void TEXTDISP_ResetSelectionAndRefresh(void);

extern void _LVOSetDrMd(void *base, char *rastPort, LONG mode);
extern void _LVOSetAPen(void *base, char *rastPort, LONG pen);
extern void _LVOSetFont(void *base, char *rastPort, void *font);

typedef struct WDISP_DisplayContext {
    UBYTE pad0[2];
    UWORD left;
    UWORD width;
    UBYTE rastPortTail[1];
} WDISP_DisplayContext;

void WDISP_HandleWeatherStatusCommand(LONG command)
{
    WDISP_DisplayContext *context;
    char *localRastPort;
    LONG width;
    LONG left;
    WORD capture3;

    if (command != 48 && command != 51) {
        TEXTDISP_ResetSelectionAndRefresh();
        return;
    }

    TLIBA3_ClearViewModeRastPort(4, 0);
    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(4, 0, 4);
    ESQ_SetCopperEffect_OnEnableHighlight();

    context = (WDISP_DisplayContext *)WDISP_DisplayContextBase;
    localRastPort = (char *)&context->left;
    width = (LONG)context->width;
    left = (LONG)context->left;

    ESQIFF_RestoreBasePaletteTriples();
    ESQIFF_RunCopperDropTransition();

    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(3, 0, 0);

    (void)Global_REF_GRAPHICS_LIBRARY;
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, localRastPort, 0);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, localRastPort, 1);
    _LVOSetFont(Global_REF_GRAPHICS_LIBRARY, localRastPort, Global_HANDLE_PREVUEC_FONT);

    if (command == 48) {
        WDISP_DrawWeatherStatusOverlay(localRastPort, left, width);
    } else if (command == 51) {
        WDISP_DrawWeatherStatusSummary(localRastPort, left, width);
    }

    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(4, 0, 4);

    if (WDISP_AccumulatorRowTable[0].copperIndexStart < 32 &&
        WDISP_AccumulatorRowTable[0].copperIndexEnd < 32 &&
        WDISP_AccumulatorRowTable[0].value < 0x4000) {
        ACCUMULATOR_Row0_CaptureValue = WDISP_AccumulatorRowTable[0].value;
    } else {
        ACCUMULATOR_Row0_CaptureValue = 0;
    }

    if (WDISP_AccumulatorRowTable[1].copperIndexStart < 32 &&
        WDISP_AccumulatorRowTable[1].copperIndexEnd < 32 &&
        WDISP_AccumulatorRowTable[1].value < 0x4000) {
        ACCUMULATOR_Row1_CaptureValue = WDISP_AccumulatorRowTable[1].value;
    } else {
        ACCUMULATOR_Row1_CaptureValue = 0;
    }

    if (WDISP_AccumulatorRowTable[2].copperIndexStart < 32 &&
        WDISP_AccumulatorRowTable[2].copperIndexEnd < 32 &&
        WDISP_AccumulatorRowTable[2].value < 0x4000) {
        ACCUMULATOR_Row2_CaptureValue = WDISP_AccumulatorRowTable[2].value;
    } else {
        ACCUMULATOR_Row2_CaptureValue = 0;
    }

    if (WDISP_AccumulatorRowTable[3].copperIndexStart < 32 &&
        WDISP_AccumulatorRowTable[3].copperIndexEnd < 32 &&
        WDISP_AccumulatorRowTable[3].value < 0x4000) {
        capture3 = WDISP_AccumulatorRowTable[3].value;
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

    ESQIFF_RunCopperRiseTransition();
}
