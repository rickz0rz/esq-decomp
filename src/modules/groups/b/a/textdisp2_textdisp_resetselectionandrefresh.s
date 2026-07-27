    XDEF    _TEXTDISP_ResetSelectionAndRefresh


;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_ResetSelectionAndRefresh   (Reset selection + refresh)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0/D1
; CALLS:
;   _SCRIPT_UpdateSerialShadowFromCtrlByte, _TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame
; READS:
;   (none)
; WRITES:
;   _TEXTDISP_CurrentMatchIndex
; DESC:
;   Resets selection state and triggers a refresh helper.
; NOTES:
;   Uses helper _SCRIPT_UpdateSerialShadowFromCtrlByte with constant 3 and clears
;   _TEXTDISP_CurrentMatchIndex.
;------------------------------------------------------------------------------
_TEXTDISP_ResetSelectionAndRefresh:
    PEA     3.W
    JSR     _SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    MOVE.W  #(-1),_TEXTDISP_CurrentMatchIndex
    CLR.L   (A7)
    JSR     _TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame(PC)

    ADDQ.W  #4,A7
    RTS

;!======