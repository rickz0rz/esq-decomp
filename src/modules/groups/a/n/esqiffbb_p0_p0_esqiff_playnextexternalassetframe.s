    XDEF    _ESQIFF_PlayNextExternalAssetFrame
    XDEF    ESQIFF_PlayNextExternalAssetFrame_Return


;------------------------------------------------------------------------------
; FUNC: _ESQIFF_PlayNextExternalAssetFrame   (Render and retire next external asset frame)
; ARGS:
;   stack +6: arg_1 (via 10(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D6/D7
; CALLS:
;   _ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode, _ESQIFF_JMPTBL_BRUSH_PopBrushHead, _ESQIFF_JMPTBL_ESQ_NoOp, _ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode, _ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled, _ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner, _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight, _ESQDISP_ProcessGridMessagesIfIdle, _ESQIFF_RestoreBasePaletteTriples, _ESQIFF_RunCopperRiseTransition, _ESQIFF_RunCopperDropTransition, _ESQIFF_SetApenToBrightestPaletteIndex, _ESQIFF_ShowExternalAssetWithCopperFx, _ESQIFF_ServiceExternalAssetSourceState, _LVOForbid, _LVOPermit, _LVOSetAPen, _LVOSetDrMd, _LVOSetRast
; READS:
;   AbsExecBase, Global_REF_GRAPHICS_LIBRARY, _Global_REF_RASTPORT_2, _TEXTDISP_DeferredActionCountdown, _ESQIFF_GAdsBrushListHead, _ESQIFF_LogoBrushListHead, _WDISP_DisplayContextBase, _TEXTDISP_PrimaryGroupEntryCount, _WDISP_AccumulatorCaptureActive, _ESQIFF_ExternalAssetStateTable, _ESQIFF_ExternalAssetPathCommaFlag
; WRITES:
;   _ESQIFF_GAdsBrushListCount, _ESQIFF_LogoBrushListCount, _ESQIFF_GAdsBrushListHead, _ESQIFF_LogoBrushListHead, _WDISP_DisplayContextBase, _WDISP_AccumulatorCaptureActive, _TEXTDISP_CurrentMatchIndex
; DESC:
;   Chooses source brush head, renders one frame with copper/display setup, pops the
;   consumed brush node from the active list, then services source-state queueing.
; NOTES:
;   Mode 0 path may redraw channel banner using stored match index snapshot.
;------------------------------------------------------------------------------
_ESQIFF_PlayNextExternalAssetFrame:
    LINK.W  A5,#-8
    MOVEM.L D6-D7,-(A7)
    MOVE.W  10(A5),D7
    BSR.W   _ESQIFF_RunCopperDropTransition

    TST.W   D7
    BEQ.S   .check_logo_head_fallback

    TST.L   _ESQIFF_GAdsBrushListHead
    BNE.S   .validate_asset_list_and_match_index

.check_logo_head_fallback:
    TST.W   D7
    BNE.W   .fallback_restore_base_palette

    TST.L   _ESQIFF_LogoBrushListHead
    BEQ.W   .fallback_restore_base_palette

.validate_asset_list_and_match_index:
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.W  _ESQIFF_ExternalAssetStateTable,D1
    CMP.W   D1,D0
    BCC.S   .prepare_display_context_for_asset_blit

    TST.W   D7
    BNE.S   .prepare_display_context_for_asset_blit

    TST.W   _ESQIFF_ExternalAssetPathCommaFlag
    BNE.S   .prepare_display_context_for_asset_blit

    BSR.W   _ESQIFF_RestoreBasePaletteTriples

    JSR     _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    PEA     2.W
    JSR     _ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(PC)

    ADDQ.W  #4,A7
    BRA.W   .run_rise_transition_and_service_source

.prepare_display_context_for_asset_blit:
    JSR     _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    PEA     1.W
    CLR.L   -(A7)
    PEA     4.W
    JSR     _ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    MOVE.L  D0,_WDISP_DisplayContextBase
    MOVEA.L D0,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    JSR     _ESQDISP_ProcessGridMessagesIfIdle(PC)

    LEA     12(A7),A7
    TST.W   D7
    BEQ.S   .select_logo_head_for_blit

    MOVEA.L _ESQIFF_GAdsBrushListHead,A0
    BRA.S   .run_asset_frame_side_effects

.select_logo_head_for_blit:
    MOVEA.L _ESQIFF_LogoBrushListHead,A0

.run_asset_frame_side_effects:
    MOVE.L  A0,-6(A5)
    JSR     _ESQIFF_JMPTBL_ESQ_NoOp(PC)

    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   .render_selected_asset_frame

    MOVE.W  _TEXTDISP_DeferredActionCountdown,D0
    SUBQ.W  #2,D0
    BEQ.S   .assert_ctrl_line_for_deferred_tick

    MOVE.W  _TEXTDISP_DeferredActionCountdown,D0
    SUBQ.W  #3,D0
    BNE.S   .render_selected_asset_frame

.assert_ctrl_line_for_deferred_tick:
    JSR     _ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled(PC)

.render_selected_asset_frame:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   _ESQIFF_ShowExternalAssetWithCopperFx

    ADDQ.W  #4,A7
    TST.W   D7
    BNE.S   .pop_rendered_asset_head

    TST.W   _ESQIFF_ExternalAssetPathCommaFlag
    BNE.S   .pop_rendered_asset_head

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    BSR.W   _ESQIFF_SetApenToBrightestPaletteIndex

    MOVE.W  _ESQIFF_ExternalAssetStateTable,_TEXTDISP_CurrentMatchIndex
    PEA     2.W
    PEA     1.W
    JSR     _ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner(PC)

    ADDQ.W  #8,A7
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

.pop_rendered_asset_head:
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    TST.W   D7
    BEQ.S   .pop_logo_brush_head

    SUBQ.L  #1,_ESQIFF_GAdsBrushListCount
    MOVE.L  _ESQIFF_GAdsBrushListHead,-(A7)
    JSR     _ESQIFF_JMPTBL_BRUSH_PopBrushHead(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,_ESQIFF_GAdsBrushListHead
    BRA.S   .permit_after_pop

.pop_logo_brush_head:
    SUBQ.L  #1,_ESQIFF_LogoBrushListCount
    MOVE.L  _ESQIFF_LogoBrushListHead,-(A7)
    JSR     _ESQIFF_JMPTBL_BRUSH_PopBrushHead(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,_ESQIFF_LogoBrushListHead

.permit_after_pop:
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPermit(A6)

    BRA.S   .run_rise_transition_and_service_source

.fallback_restore_base_palette:
    BSR.W   _ESQIFF_RestoreBasePaletteTriples

    JSR     _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    PEA     2.W
    JSR     _ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(PC)

    ADDQ.W  #4,A7

.run_rise_transition_and_service_source:
    MOVE.W  _WDISP_AccumulatorCaptureActive,D6
    CLR.W   _WDISP_AccumulatorCaptureActive
    BSR.W   _ESQIFF_RunCopperRiseTransition

    MOVE.W  D6,_WDISP_AccumulatorCaptureActive
    TST.W   D7
    BEQ.S   .service_source_mode_zero

    PEA     1.W
    BSR.W   _ESQIFF_ServiceExternalAssetSourceState

    ADDQ.W  #4,A7
    BRA.S   ESQIFF_PlayNextExternalAssetFrame_Return

.service_source_mode_zero:
    CLR.L   -(A7)
    BSR.W   _ESQIFF_ServiceExternalAssetSourceState

    ADDQ.W  #4,A7

;------------------------------------------------------------------------------
; FUNC: ESQIFF_PlayNextExternalAssetFrame_Return   (Return tail for external asset frame player)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D6
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Restores saved registers/frame and returns from frame-player helper.
; NOTES:
;   Shared return for both render and fallback/no-asset paths.
;------------------------------------------------------------------------------
ESQIFF_PlayNextExternalAssetFrame_Return:
    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS

;!======