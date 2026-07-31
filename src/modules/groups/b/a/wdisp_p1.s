    XDEF    WDISP_UpdateSelectionPreviewPanel
    XDEF    _WDISP_JMPTBL_BRUSH_FindBrushByPredicate
    XDEF    WDISP_JMPTBL_BRUSH_FreeBrushList
    XDEF    _WDISP_JMPTBL_BRUSH_PlaneMaskForIndex
    XDEF    _WDISP_JMPTBL_BRUSH_SelectBrushSlot
    XDEF    _WDISP_JMPTBL_ESQFUNC_TrimTextToPixelWidthWordBoundary
    XDEF    WDISP_JMPTBL_ESQIFF_QueueIffBrushLoad
    XDEF    WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice
    XDEF    _WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples
    XDEF    _WDISP_JMPTBL_ESQIFF_RunCopperDropTransition
    XDEF    _WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight
    XDEF    WDISP_JMPTBL_GCOMMAND_ExpandPresetBlock
    XDEF    _WDISP_JMPTBL_NEWGRID_DrawWrappedText
    XDEF    WDISP_JMPTBL_NEWGRID_ResetRowTable


    ; Dead code.
    MOVEM.L D2-D3,-(A7)

    MOVE.W  _WDISP_WeatherStatusDigitChar,D0
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BEQ.S   .return

    MOVE.B  _WDISP_WeatherStatusCountdown,D2
    TST.B   D2
    BEQ.S   .return

    MOVE.W  _WDISP_WeatherCycleOffsetCount,D2
    MOVE.L  D2,D3
    SUBQ.W  #1,D3
    MOVE.W  D3,_WDISP_WeatherCycleOffsetCount
    BGT.S   .return

    SUBI.W  #$30,D0
    MOVE.W  D0,_WDISP_WeatherCycleOffsetCount

.return:
    MOVEM.L (A7)+,D2-D3
    RTS

;!======

    ; Dead code.
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.B  _WDISP_WeatherStatusBrushIndex,D0
    SUBQ.B  #1,D0
    BEQ.S   .dead_slice_no_valid_brush

    MOVE.B  _WDISP_WeatherStatusBrushIndex,D0
    MOVEQ   #6,D1
    CMP.B   D1,D0
    BLS.S   .dead_slice_lookup_and_render

.dead_slice_no_valid_brush:
    MOVEQ   #0,D0
    BRA.S   .dead_slice_return

.dead_slice_lookup_and_render:
    MOVEQ   #0,D0
    MOVE.B  _WDISP_WeatherStatusBrushIndex,D0
    ASL.L   #2,D0
    ; Layout-coupled table anchor (_ESQFUNC_STR_I5 -> ptr table).
    LEA     _ESQFUNC_STR_I5,A0
    ADDA.L  D0,A0
    PEA     _ESQFUNC_PwBrushListHead
    MOVE.L  (A0),-(A7)
    JSR     _WDISP_JMPTBL_BRUSH_FindBrushByPredicate(PC)

    MOVE.L  D0,(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-6(A5)
    JSR     WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,D0

.dead_slice_return:
    MOVEM.L -16(A5),D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: WDISP_UpdateSelectionPreviewPanel   (UpdateSelectionPreviewPanel)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2
; CALLS:
;   WDISP_JMPTBL_BRUSH_FreeBrushList, WDISP_JMPTBL_ESQIFF_QueueIffBrushLoad, WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice, WDISP_JMPTBL_GCOMMAND_ExpandPresetBlock, WDISP_JMPTBL_NEWGRID_ResetRowTable, _LVOSetRast
; READS:
;   Global_REF_GRAPHICS_LIBRARY, _Global_REF_RASTPORT_1, _WDISP_WeatherStatusBrushListHead, _P_TYPE_WeatherBrushRefreshPendingFlag, TLIBA1_PreviewSlotRefreshState, TLIBA1_PreviewSlotRenderResult, _WDISP_WeatherStatusCountdown, _WDISP_WeatherStatusDigitChar, _WDISP_WeatherCycleOffsetCount
; WRITES:
;   TLIBA1_PreviewSlotRefreshState, TLIBA1_PreviewSlotRenderResult
; DESC:
;   Updates/refreshes the selection preview panel brush resources and row table,
;   then returns boolean success as 0/-1 in D0.
; NOTES:
;   Uses SNE/NEG/EXT booleanization pattern on TLIBA1_PreviewSlotRenderResult.
;------------------------------------------------------------------------------
WDISP_UpdateSelectionPreviewPanel:
    LINK.W  A5,#-4
    MOVEM.L D2/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2

    MOVEQ   #8,D0
    CMP.L   TLIBA1_PreviewSlotRefreshState,D0
    BNE.S   .preview_refresh_panel

    MOVEQ   #0,D0
    MOVE.L  D0,TLIBA1_PreviewSlotRefreshState
    MOVE.L  D0,TLIBA1_PreviewSlotRenderResult
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
    TST.L   TLIBA1_PreviewSlotRefreshState
    BNE.S   .preview_refresh_existing_slot

    MOVE.L  _WDISP_WeatherStatusBrushListHead,-(A7)
    MOVE.L  A2,-(A7)
    JSR     WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice(PC)

    ADDQ.W  #8,A7
    EXT.L   D0
    MOVE.L  D0,TLIBA1_PreviewSlotRenderResult
    TST.L   D0
    BEQ.S   .preview_after_initial_render

    MOVEQ   #7,D0
    MOVE.L  D0,TLIBA1_PreviewSlotRefreshState

.preview_after_initial_render:
    TST.L   _WDISP_WeatherStatusBrushListHead
    BEQ.S   .preview_after_render_paths

    MOVEA.L _WDISP_WeatherStatusBrushListHead,A0
    ADDA.W  #$e8,A0
    MOVE.L  A0,-(A7)
    JSR     WDISP_JMPTBL_GCOMMAND_ExpandPresetBlock(PC)

    MOVE.L  A2,(A7)
    JSR     WDISP_JMPTBL_NEWGRID_ResetRowTable(PC)

    ADDQ.W  #4,A7
    BRA.S   .preview_after_render_paths

.preview_refresh_existing_slot:
    MOVEQ   #7,D0
    CMP.L   TLIBA1_PreviewSlotRefreshState,D0
    BNE.S   .preview_after_render_paths

    MOVE.L  _WDISP_WeatherStatusBrushListHead,-(A7)
    MOVE.L  A2,-(A7)
    JSR     WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice(PC)

    ADDQ.W  #8,A7
    EXT.L   D0
    MOVE.L  D0,TLIBA1_PreviewSlotRenderResult
    MOVEQ   #-1,D1
    MOVE.L  D1,32(A2)

.preview_after_render_paths:
    TST.L   TLIBA1_PreviewSlotRenderResult
    BNE.S   .preview_restore_rastport_bitmap

    CLR.L   -(A7)
    PEA     _WDISP_WeatherStatusBrushListHead
    JSR     WDISP_JMPTBL_BRUSH_FreeBrushList(PC)

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
    JSR     WDISP_JMPTBL_ESQIFF_QueueIffBrushLoad(PC)

    ADDQ.W  #4,A7

.preview_mark_reload_pending:
    MOVEQ   #8,D0
    MOVE.L  D0,TLIBA1_PreviewSlotRefreshState
    MOVEQ   #-1,D0
    MOVE.L  D0,TLIBA1_PreviewSlotRenderResult

.preview_restore_rastport_bitmap:
    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)

.preview_return_boolean:
    TST.L   TLIBA1_PreviewSlotRenderResult
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0

    MOVEM.L (A7)+,D2/A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

;------------------------------------------------------------------------------
; FUNC: _WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples   (Routine at _WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQIFF_RestoreBasePaletteTriples
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples:
    JMP     _ESQIFF_RestoreBasePaletteTriples

;------------------------------------------------------------------------------
; FUNC: _WDISP_JMPTBL_ESQFUNC_TrimTextToPixelWidthWordBoundary   (Routine at _WDISP_JMPTBL_ESQFUNC_TrimTextToPixelWidthWordBoundary)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQFUNC_TrimTextToPixelWidthWordBoundary
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_WDISP_JMPTBL_ESQFUNC_TrimTextToPixelWidthWordBoundary:
    JMP     _ESQFUNC_TrimTextToPixelWidthWordBoundary

;------------------------------------------------------------------------------
; FUNC: WDISP_JMPTBL_GCOMMAND_ExpandPresetBlock   (Routine at WDISP_JMPTBL_GCOMMAND_ExpandPresetBlock)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   GCOMMAND_ExpandPresetBlock
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
WDISP_JMPTBL_GCOMMAND_ExpandPresetBlock:
    JMP     GCOMMAND_ExpandPresetBlock

;------------------------------------------------------------------------------
; FUNC: WDISP_JMPTBL_ESQIFF_QueueIffBrushLoad   (Routine at WDISP_JMPTBL_ESQIFF_QueueIffBrushLoad)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQIFF_QueueIffBrushLoad
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
WDISP_JMPTBL_ESQIFF_QueueIffBrushLoad:
    JMP     ESQIFF_QueueIffBrushLoad

;------------------------------------------------------------------------------
; FUNC: _WDISP_JMPTBL_ESQIFF_RunCopperDropTransition   (Routine at _WDISP_JMPTBL_ESQIFF_RunCopperDropTransition)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQIFF_RunCopperDropTransition
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_WDISP_JMPTBL_ESQIFF_RunCopperDropTransition:
    JMP     _ESQIFF_RunCopperDropTransition

;------------------------------------------------------------------------------
; FUNC: _WDISP_JMPTBL_BRUSH_FindBrushByPredicate   (Routine at _WDISP_JMPTBL_BRUSH_FindBrushByPredicate)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _BRUSH_FindBrushByPredicate
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_WDISP_JMPTBL_BRUSH_FindBrushByPredicate:
    JMP     _BRUSH_FindBrushByPredicate

;------------------------------------------------------------------------------
; FUNC: WDISP_JMPTBL_BRUSH_FreeBrushList   (Routine at WDISP_JMPTBL_BRUSH_FreeBrushList)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _BRUSH_FreeBrushList
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
WDISP_JMPTBL_BRUSH_FreeBrushList:
    JMP     _BRUSH_FreeBrushList

;------------------------------------------------------------------------------
; FUNC: _WDISP_JMPTBL_BRUSH_PlaneMaskForIndex   (Routine at _WDISP_JMPTBL_BRUSH_PlaneMaskForIndex)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _BRUSH_PlaneMaskForIndex
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_WDISP_JMPTBL_BRUSH_PlaneMaskForIndex:
    JMP     _BRUSH_PlaneMaskForIndex

;------------------------------------------------------------------------------
; FUNC: _WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight   (Routine at _WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQ_SetCopperEffect_OnEnableHighlight
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight:
    JMP     _ESQ_SetCopperEffect_OnEnableHighlight

;------------------------------------------------------------------------------
; FUNC: WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice   (Routine at WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQIFF_RenderWeatherStatusBrushSlice
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice:
    JMP     ESQIFF_RenderWeatherStatusBrushSlice

;------------------------------------------------------------------------------
; FUNC: _WDISP_JMPTBL_BRUSH_SelectBrushSlot   (Routine at _WDISP_JMPTBL_BRUSH_SelectBrushSlot)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_SelectBrushSlot
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_WDISP_JMPTBL_BRUSH_SelectBrushSlot:
    JMP     BRUSH_SelectBrushSlot

;------------------------------------------------------------------------------
; FUNC: _WDISP_JMPTBL_NEWGRID_DrawWrappedText   (Routine at _WDISP_JMPTBL_NEWGRID_DrawWrappedText)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _NEWGRID_DrawWrappedText
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_WDISP_JMPTBL_NEWGRID_DrawWrappedText:
    JMP     _NEWGRID_DrawWrappedText

;------------------------------------------------------------------------------
; FUNC: WDISP_JMPTBL_NEWGRID_ResetRowTable   (Routine at WDISP_JMPTBL_NEWGRID_ResetRowTable)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   _NEWGRID_ResetRowTable
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
WDISP_JMPTBL_NEWGRID_ResetRowTable:
    JMP     _NEWGRID_ResetRowTable

;!======

    ; Alignment
    MOVEQ   #97,D0
