    XDEF    _WDISP_UpdateSelectionPreviewPanel


;------------------------------------------------------------------------------
; FUNC: _WDISP_UpdateSelectionPreviewPanel   (UpdateSelectionPreviewPanel)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2
; CALLS:
;   _WDISP_JMPTBL_BRUSH_FreeBrushList, _WDISP_JMPTBL_ESQIFF_QueueIffBrushLoad, _WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice, _WDISP_JMPTBL_GCOMMAND_ExpandPresetBlock, _WDISP_JMPTBL_NEWGRID_ResetRowTable, _LVOSetRast
; READS:
;   Global_REF_GRAPHICS_LIBRARY, _Global_REF_RASTPORT_1, _WDISP_WeatherStatusBrushListHead, _P_TYPE_WeatherBrushRefreshPendingFlag, _TLIBA1_PreviewSlotRefreshState, _TLIBA1_PreviewSlotRenderResult, _WDISP_WeatherStatusCountdown, _WDISP_WeatherStatusDigitChar, _WDISP_WeatherCycleOffsetCount
; WRITES:
;   _TLIBA1_PreviewSlotRefreshState, _TLIBA1_PreviewSlotRenderResult
; DESC:
;   Updates/refreshes the selection preview panel brush resources and row table,
;   then returns boolean success as 0/-1 in D0.
; NOTES:
;   Uses SNE/NEG/EXT booleanization pattern on _TLIBA1_PreviewSlotRenderResult.
;------------------------------------------------------------------------------
_WDISP_UpdateSelectionPreviewPanel:
    LINK.W  A5,#-4
    MOVEM.L D2/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2

    MOVEQ   #8,D0
    CMP.L   _TLIBA1_PreviewSlotRefreshState,D0
    BNE.S   .preview_refresh_panel

    MOVEQ   #0,D0
    MOVE.L  D0,_TLIBA1_PreviewSlotRefreshState
    MOVE.L  D0,_TLIBA1_PreviewSlotRenderResult
    BRA.W   .preview_return_boolean

.preview_refresh_panel:
    LEA     60(A2),A0
    MOVEA.L A0,A1
    MOVEQ   #7,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-4(A5)
    MOVE.L  4(A3),4(A0)
    TST.L   _TLIBA1_PreviewSlotRefreshState
    BNE.S   .preview_refresh_existing_slot

    MOVE.L  _WDISP_WeatherStatusBrushListHead,-(A7)
    MOVE.L  A2,-(A7)
    JSR     _WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice(PC)

    ADDQ.W  #8,A7
    EXT.L   D0
    MOVE.L  D0,_TLIBA1_PreviewSlotRenderResult
    TST.L   D0
    BEQ.S   .preview_after_initial_render

    MOVEQ   #7,D0
    MOVE.L  D0,_TLIBA1_PreviewSlotRefreshState

.preview_after_initial_render:
    TST.L   _WDISP_WeatherStatusBrushListHead
    BEQ.S   .preview_after_render_paths

    MOVEA.L _WDISP_WeatherStatusBrushListHead,A0
    ADDA.W  #$e8,A0
    MOVE.L  A0,-(A7)
    JSR     _WDISP_JMPTBL_GCOMMAND_ExpandPresetBlock(PC)

    MOVE.L  A2,(A7)
    JSR     _WDISP_JMPTBL_NEWGRID_ResetRowTable(PC)

    ADDQ.W  #4,A7
    BRA.S   .preview_after_render_paths

.preview_refresh_existing_slot:
    MOVEQ   #7,D0
    CMP.L   _TLIBA1_PreviewSlotRefreshState,D0
    BNE.S   .preview_after_render_paths

    MOVE.L  _WDISP_WeatherStatusBrushListHead,-(A7)
    MOVE.L  A2,-(A7)
    JSR     _WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice(PC)

    ADDQ.W  #8,A7
    EXT.L   D0
    MOVE.L  D0,_TLIBA1_PreviewSlotRenderResult
    MOVEQ   #-1,D1
    MOVE.L  D1,32(A2)

.preview_after_render_paths:
    TST.L   _TLIBA1_PreviewSlotRenderResult
    BNE.S   .preview_restore_rastport_bitmap

    CLR.L   -(A7)
    PEA     _WDISP_WeatherStatusBrushListHead
    JSR     _WDISP_JMPTBL_BRUSH_FreeBrushList(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    TST.L   D0
    BEQ.S   .preview_mark_reload_pending

    MOVE.W  _WDISP_WeatherStatusDigitChar,D1
    MOVEQ   #48,D2
    CMP.W   D2,D1
    BEQ.S   .preview_mark_reload_pending

    MOVE.B  _WDISP_WeatherStatusCountdown,D1
    TST.B   D1
    BEQ.S   .preview_mark_reload_pending

    MOVE.W  _WDISP_WeatherCycleOffsetCount,D1
    MOVEQ   #1,D2
    CMP.W   D2,D1
    BGT.S   .preview_mark_reload_pending

    TST.L   _P_TYPE_WeatherBrushRefreshPendingFlag
    BNE.S   .preview_mark_reload_pending

    PEA     2.W
    JSR     _WDISP_JMPTBL_ESQIFF_QueueIffBrushLoad(PC)

    ADDQ.W  #4,A7

.preview_mark_reload_pending:
    MOVEQ   #8,D0
    MOVE.L  D0,_TLIBA1_PreviewSlotRefreshState
    MOVEQ   #-1,D0
    MOVE.L  D0,_TLIBA1_PreviewSlotRenderResult

.preview_restore_rastport_bitmap:
    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)

.preview_return_boolean:
    TST.L   _TLIBA1_PreviewSlotRenderResult
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0

    MOVEM.L (A7)+,D2/A2-A3
    UNLK    A5
    RTS

;!======