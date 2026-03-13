typedef signed long LONG;
typedef signed short WORD;

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
extern void GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(void);
extern void ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(LONG mode);
extern void *ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(LONG viewMode, LONG a, LONG b);
extern void _LVOSetRast(void *gfxBase, char *rastPort, LONG pen);
extern void ESQDISP_ProcessGridMessagesIfIdle(void);
extern void ESQIFF_JMPTBL_ESQ_NoOp(void);
extern void ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled(void);
extern void ESQIFF_ShowExternalAssetWithCopperFx(WORD refreshMode);
extern void _LVOSetDrMd(void *gfxBase, char *rastPort, LONG mode);
extern void ESQIFF_SetApenToBrightestPaletteIndex(void);
extern void ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner(LONG mode, LONG refresh);
extern void _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOForbid(void *execBase);
extern LONG ESQIFF_JMPTBL_BRUSH_PopBrushHead(LONG head);
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
            GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight();
            ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(2);
            goto run_rise_transition_and_service_source;
        }
    } else if (ESQIFF_LogoBrushListHead == 0) {
        ESQIFF_RestoreBasePaletteTriples();
        GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight();
        ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(2);
        goto run_rise_transition_and_service_source;
    }

    if (TEXTDISP_PrimaryGroupEntryCount < ESQIFF_ExternalAssetStateTable &&
        refreshMode == 0 &&
        ESQIFF_ExternalAssetPathCommaFlag == 0) {
        ESQIFF_RestoreBasePaletteTriples();
        GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight();
        ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(2);
        goto run_rise_transition_and_service_source;
    }

    GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight();

    WDISP_DisplayContextBase = (LONG)ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(4, 0, 1);
    rastPort = (char *)(WDISP_DisplayContextBase - 458);
    _LVOSetRast((void *)Global_REF_GRAPHICS_LIBRARY, rastPort, 2);

    ESQDISP_ProcessGridMessagesIfIdle();

    if (refreshMode != 0) {
        brushHead = ESQIFF_GAdsBrushListHead;
    } else {
        brushHead = ESQIFF_LogoBrushListHead;
    }

    ESQIFF_JMPTBL_ESQ_NoOp();

    if (refreshMode == 1 &&
        (TEXTDISP_DeferredActionCountdown == 2 ||
         TEXTDISP_DeferredActionCountdown == 3)) {
        ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled();
    }

    ESQIFF_ShowExternalAssetWithCopperFx(refreshMode);

    if (refreshMode == 0 && ESQIFF_ExternalAssetPathCommaFlag == 0) {
        rastPort = (char *)(WDISP_DisplayContextBase - 458);
        _LVOSetDrMd((void *)Global_REF_GRAPHICS_LIBRARY, rastPort, 0);
        ESQIFF_SetApenToBrightestPaletteIndex();

        TEXTDISP_CurrentMatchIndex = ESQIFF_ExternalAssetStateTable;
        ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner(1, 2);

        rastPort = (char *)(WDISP_DisplayContextBase - 458);
        _LVOSetDrMd((void *)Global_REF_GRAPHICS_LIBRARY, rastPort, 1);
    }

    rastPort = (char *)(WDISP_DisplayContextBase - 458);
    _LVOSetAPen((void *)Global_REF_GRAPHICS_LIBRARY, rastPort, 1);

    _LVOForbid((void *)AbsExecBase);

    if (refreshMode != 0) {
        ESQIFF_GAdsBrushListCount--;
        ESQIFF_GAdsBrushListHead = ESQIFF_JMPTBL_BRUSH_PopBrushHead(ESQIFF_GAdsBrushListHead);
    } else {
        ESQIFF_LogoBrushListCount--;
        ESQIFF_LogoBrushListHead = ESQIFF_JMPTBL_BRUSH_PopBrushHead(ESQIFF_LogoBrushListHead);
    }

    _LVOPermit((void *)AbsExecBase);

run_rise_transition_and_service_source:
    savedAccumulatorFlag = WDISP_AccumulatorCaptureActive;
    WDISP_AccumulatorCaptureActive = 0;
    ESQIFF_RunCopperRiseTransition();
    WDISP_AccumulatorCaptureActive = savedAccumulatorFlag;

    ESQIFF_ServiceExternalAssetSourceState(refreshMode);
}
