#include <exec/types.h>
extern LONG AbsExecBase;
extern LONG Global_REF_GRAPHICS_LIBRARY;
extern LONG WDISP_DisplayContextBase;
extern LONG ESQIFF_GAdsBrushListHead;
extern LONG ESQIFF_LogoBrushListHead;
extern LONG ESQIFF_GAdsBrushListCount;
extern LONG ESQIFF_LogoBrushListCount;
extern WORD TEXTDISP_PrimaryGroupEntryCount;
extern WORD ESQIFF_ExternalAssetStateTable;
extern WORD ESQIFF_ExternalAssetPathCommaFlag;
extern WORD TEXTDISP_DeferredActionCountdown;
extern WORD TEXTDISP_CurrentMatchIndex;
extern WORD WDISP_AccumulatorCaptureActive;

extern void ESQIFF_RunCopperDropTransition(void);
extern void ESQIFF_RunCopperRiseTransition(void);
extern void ESQIFF_RestoreBasePaletteTriples(void);
extern void ESQ_SetCopperEffect_OffDisableHighlight(void);
extern void TEXTDISP_SetRastForMode(LONG mode);
extern LONG TLIBA3_BuildDisplayContextForViewMode(LONG viewMode, LONG a, LONG b);
extern void _LVOSetRast(void *gfxBase, char *rastPort, LONG pen);
extern void ESQDISP_ProcessGridMessagesIfIdle(void);
extern void ESQ_NoOp(void);
extern void SCRIPT_AssertCtrlLineIfEnabled(void);
extern void ESQIFF_ShowExternalAssetWithCopperFx(WORD refreshMode);
extern void _LVOSetDrMd(void *gfxBase, char *rastPort, LONG mode);
extern void ESQIFF_SetApenToBrightestPaletteIndex(void);
extern void TEXTDISP_DrawChannelBanner(LONG mode, LONG refresh);
extern void _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOForbid(void *execBase);
extern void *BRUSH_PopBrushHead(void *head);
extern void _LVOPermit(void *execBase);
extern void ESQIFF_ServiceExternalAssetSourceState(WORD mode);

void ESQIFF_PlayNextExternalAssetFrame(WORD refreshMode)
{
    LONG brushHead;
    WORD savedAccumulatorFlag;
    char *rastPort;

    ESQIFF_RunCopperDropTransition();

    if (refreshMode != 0) {
        if (ESQIFF_GAdsBrushListHead == 0) {
            ESQIFF_RestoreBasePaletteTriples();
            ESQ_SetCopperEffect_OffDisableHighlight();
            TEXTDISP_SetRastForMode(2);
            goto run_rise_transition_and_service_source;
        }
    } else if (ESQIFF_LogoBrushListHead == 0) {
        ESQIFF_RestoreBasePaletteTriples();
        ESQ_SetCopperEffect_OffDisableHighlight();
        TEXTDISP_SetRastForMode(2);
        goto run_rise_transition_and_service_source;
    }

    if (TEXTDISP_PrimaryGroupEntryCount < ESQIFF_ExternalAssetStateTable &&
        refreshMode == 0 &&
        ESQIFF_ExternalAssetPathCommaFlag == 0) {
        ESQIFF_RestoreBasePaletteTriples();
        ESQ_SetCopperEffect_OffDisableHighlight();
        TEXTDISP_SetRastForMode(2);
        goto run_rise_transition_and_service_source;
    }

    ESQ_SetCopperEffect_OffDisableHighlight();

    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(4, 0, 1);
    rastPort = (char *)(WDISP_DisplayContextBase - 458);
    _LVOSetRast((void *)Global_REF_GRAPHICS_LIBRARY, rastPort, 2);

    ESQDISP_ProcessGridMessagesIfIdle();

    if (refreshMode != 0) {
        brushHead = ESQIFF_GAdsBrushListHead;
    } else {
        brushHead = ESQIFF_LogoBrushListHead;
    }

    ESQ_NoOp();

    if (refreshMode == 1 &&
        (TEXTDISP_DeferredActionCountdown == 2 ||
         TEXTDISP_DeferredActionCountdown == 3)) {
        SCRIPT_AssertCtrlLineIfEnabled();
    }

    ESQIFF_ShowExternalAssetWithCopperFx(refreshMode);

    if (refreshMode == 0 && ESQIFF_ExternalAssetPathCommaFlag == 0) {
        rastPort = (char *)(WDISP_DisplayContextBase - 458);
        _LVOSetDrMd((void *)Global_REF_GRAPHICS_LIBRARY, rastPort, 0);
        ESQIFF_SetApenToBrightestPaletteIndex();

        TEXTDISP_CurrentMatchIndex = ESQIFF_ExternalAssetStateTable;
        TEXTDISP_DrawChannelBanner(1, 2);

        rastPort = (char *)(WDISP_DisplayContextBase - 458);
        _LVOSetDrMd((void *)Global_REF_GRAPHICS_LIBRARY, rastPort, 1);
    }

    rastPort = (char *)(WDISP_DisplayContextBase - 458);
    _LVOSetAPen((void *)Global_REF_GRAPHICS_LIBRARY, rastPort, 1);

    _LVOForbid((void *)AbsExecBase);

    if (refreshMode != 0) {
        ESQIFF_GAdsBrushListCount--;
        ESQIFF_GAdsBrushListHead = (LONG)BRUSH_PopBrushHead((void *)ESQIFF_GAdsBrushListHead);
    } else {
        ESQIFF_LogoBrushListCount--;
        ESQIFF_LogoBrushListHead = (LONG)BRUSH_PopBrushHead((void *)ESQIFF_LogoBrushListHead);
    }

    _LVOPermit((void *)AbsExecBase);

run_rise_transition_and_service_source:
    savedAccumulatorFlag = WDISP_AccumulatorCaptureActive;
    WDISP_AccumulatorCaptureActive = 0;
    ESQIFF_RunCopperRiseTransition();
    WDISP_AccumulatorCaptureActive = savedAccumulatorFlag;

    ESQIFF_ServiceExternalAssetSourceState(refreshMode);
}
