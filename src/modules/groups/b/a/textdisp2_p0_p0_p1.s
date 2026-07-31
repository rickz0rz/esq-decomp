    XDEF    TEXTDISP_TickDisplayState
    XDEF    _TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame
    XDEF    TEXTDISP2_JMPTBL_ESQIFF_RunPendingCopperAnimations
    XDEF    TEXTDISP2_JMPTBL_LADFUNC_DrawEntryPreview
    XDEF    TEXTDISP2_JMPTBL_LOCAVAIL_GetFilterWindowHalfSpan


;------------------------------------------------------------------------------
; FUNC: TEXTDISP_TickDisplayState   (Tick display/control state)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D2
; CALLS:
;   TEXTDISP2_JMPTBL_LOCAVAIL_GetFilterWindowHalfSpan, _SCRIPT_AssertCtrlLineIfEnabled, TEXTDISP_UpdateHighlightOrPreview,
;   _TEXTDISP_ResetSelectionAndRefresh, TEXTDISP2_JMPTBL_ESQIFF_RunPendingCopperAnimations
; READS:
;   TEXTDISP_TickSuspendFlag, _Global_UIBusyFlag, _SCRIPT_RuntimeMode, _TEXTDISP_DeferredActionCountdown, _TEXTDISP_DeferredActionArmed, _LOCAVAIL_FilterPrevClassId, _Global_RefreshTickCounter
; WRITES:
;   _ESQ_GlobalTickCounter, _TEXTDISP_DeferredActionDelayTicks, _TEXTDISP_DeferredActionArmed, _TEXTDISP_DeferredActionCountdown, _Global_RefreshTickCounter
; DESC:
;   Updates internal display/control counters and triggers refresh/preview steps.
; NOTES:
;   Uses _Global_RefreshTickCounter as a timer for periodic refresh.
;------------------------------------------------------------------------------
TEXTDISP_TickDisplayState:
    MOVE.L  D2,-(A7)
    MOVEQ   #0,D0
    MOVE.W  D0,_ESQ_GlobalTickCounter
    TST.W   TEXTDISP_TickSuspendFlag
    BNE.W   .return

    TST.W   _Global_UIBusyFlag
    BNE.W   .tick_refresh_timer

    MOVE.W  _SCRIPT_RuntimeMode,D1
    SUBQ.W  #2,D1
    BEQ.S   .tick_refresh_timer

    MOVE.W  _TEXTDISP_DeferredActionCountdown,D1
    BEQ.S   .handle_refresh_timer

    MOVE.W  _TEXTDISP_DeferredActionArmed,D2
    BEQ.S   .handle_refresh_timer

    MOVE.W  D0,_TEXTDISP_DeferredActionArmed
    MOVE.W  _TEXTDISP_DeferredActionCountdown,D0
    SUBQ.W  #3,D0
    BEQ.S   .assert_ctrl_and_refresh

    MOVE.W  _TEXTDISP_DeferredActionCountdown,D0
    SUBQ.W  #2,D0
    BNE.S   .clear_pending_mode

.assert_ctrl_and_refresh:
    JSR     TEXTDISP2_JMPTBL_LOCAVAIL_GetFilterWindowHalfSpan(PC)

    MOVE.W  D0,_TEXTDISP_DeferredActionDelayTicks
    JSR     _SCRIPT_AssertCtrlLineIfEnabled(PC)

    BSR.W   TEXTDISP_UpdateHighlightOrPreview

    BRA.S   .decrement_delay_counter

.clear_pending_mode:
    MOVEQ   #-1,D0
    CMP.L   _LOCAVAIL_FilterPrevClassId,D0
    BEQ.S   .decrement_delay_counter

    MOVE.L  D0,_LOCAVAIL_FilterPrevClassId

.decrement_delay_counter:
    MOVE.W  _TEXTDISP_DeferredActionCountdown,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .handle_refresh_timer

    SUBQ.W  #1,D0
    MOVE.W  D0,_TEXTDISP_DeferredActionCountdown

.handle_refresh_timer:
    MOVE.W  _Global_RefreshTickCounter,D0
    CMPI.W  #$b4,D0
    BLT.S   .dispatch_update

    CLR.W   _Global_RefreshTickCounter
    BSR.W   _TEXTDISP_ResetSelectionAndRefresh

    BRA.S   .dispatch_update

.tick_refresh_timer:
    MOVE.W  _Global_RefreshTickCounter,D0
    ADDQ.W  #1,D0
    BEQ.S   .dispatch_update

    CLR.W   _Global_RefreshTickCounter

.dispatch_update:
    JSR     TEXTDISP2_JMPTBL_ESQIFF_RunPendingCopperAnimations(PC)

.return:
    MOVE.L  (A7)+,D2
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP2_JMPTBL_LOCAVAIL_GetFilterWindowHalfSpan   (JumpStub)
; ARGS:
;   see _LOCAVAIL_GetFilterWindowHalfSpan)
; RET:
;   see _LOCAVAIL_GetFilterWindowHalfSpan)
; CLOBBERS:
;   see _LOCAVAIL_GetFilterWindowHalfSpan)
; CALLS:
;   _LOCAVAIL_GetFilterWindowHalfSpan
; DESC:
;   Jump stub to _LOCAVAIL_GetFilterWindowHalfSpan.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
TEXTDISP2_JMPTBL_LOCAVAIL_GetFilterWindowHalfSpan:
    JMP     _LOCAVAIL_GetFilterWindowHalfSpan

;------------------------------------------------------------------------------
; FUNC: TEXTDISP2_JMPTBL_LADFUNC_DrawEntryPreview   (JumpStub_LADFUNC_DrawEntryPreview)
; ARGS:
;   see LADFUNC_DrawEntryPreview)
; RET:
;   see LADFUNC_DrawEntryPreview)
; CLOBBERS:
;   see LADFUNC_DrawEntryPreview)
; CALLS:
;   LADFUNC_DrawEntryPreview
; DESC:
;   Jump stub to LADFUNC_DrawEntryPreview.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
TEXTDISP2_JMPTBL_LADFUNC_DrawEntryPreview:
    JMP     LADFUNC_DrawEntryPreview

;------------------------------------------------------------------------------
; FUNC: TEXTDISP2_JMPTBL_ESQIFF_RunPendingCopperAnimations   (JumpStub)
; ARGS:
;   see _ESQIFF_RunPendingCopperAnimations)
; RET:
;   see _ESQIFF_RunPendingCopperAnimations)
; CLOBBERS:
;   see _ESQIFF_RunPendingCopperAnimations)
; CALLS:
;   _ESQIFF_RunPendingCopperAnimations
; DESC:
;   Jump stub to _ESQIFF_RunPendingCopperAnimations.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
TEXTDISP2_JMPTBL_ESQIFF_RunPendingCopperAnimations:
    JMP     _ESQIFF_RunPendingCopperAnimations

;------------------------------------------------------------------------------
; FUNC: _TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame   (JumpStub)
; ARGS:
;   see _ESQIFF_PlayNextExternalAssetFrame)
; RET:
;   see _ESQIFF_PlayNextExternalAssetFrame)
; CLOBBERS:
;   see _ESQIFF_PlayNextExternalAssetFrame)
; CALLS:
;   _ESQIFF_PlayNextExternalAssetFrame
; DESC:
;   Jump stub to _ESQIFF_PlayNextExternalAssetFrame.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame:
    JMP     _ESQIFF_PlayNextExternalAssetFrame
