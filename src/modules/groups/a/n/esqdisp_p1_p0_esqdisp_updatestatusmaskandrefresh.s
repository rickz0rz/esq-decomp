    XDEF    _ESQDISP_UpdateStatusMaskAndRefresh
    XDEF    ESQDISP_UpdateStatusMaskAndRefresh_Return


;------------------------------------------------------------------------------
; FUNC: _ESQDISP_UpdateStatusMaskAndRefresh   (UpdateStatusMaskAndRefresh)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D5/D6/D7
; CALLS:
;   _ESQDISP_ApplyStatusMaskToIndicators
; READS:
;   _ESQDISP_StatusIndicatorMask, fff
; WRITES:
;   _ESQDISP_StatusIndicatorMask
; DESC:
;   Sets or clears bits in the global status mask, clamps to 12 bits, and only
;   refreshes status indicators when the effective mask changed.
; NOTES:
;   D6 controls operation mode: non-zero = OR-in mask, zero = clear mask bits.
;------------------------------------------------------------------------------
_ESQDISP_UpdateStatusMaskAndRefresh:
    MOVEM.L D5-D7,-(A7)
    MOVE.L  16(A7),D7
    MOVE.L  20(A7),D6
    MOVEQ   #-1,D5
    MOVE.L  _ESQDISP_StatusIndicatorMask,D5
    TST.L   D6
    BEQ.S   .lab_08DB

    OR.L    D7,_ESQDISP_StatusIndicatorMask
    BRA.S   .lab_08DC

.lab_08DB:
    MOVE.L  D7,D0
    NOT.L   D0
    AND.L   D0,_ESQDISP_StatusIndicatorMask

.lab_08DC:
    ANDI.L  #$fff,_ESQDISP_StatusIndicatorMask
    MOVE.L  _ESQDISP_StatusIndicatorMask,D0
    CMP.L   D0,D5
    BEQ.S   ESQDISP_UpdateStatusMaskAndRefresh_Return

    MOVE.L  D0,-(A7)
    BSR.W   _ESQDISP_ApplyStatusMaskToIndicators

    ADDQ.W  #4,A7

;------------------------------------------------------------------------------
; FUNC: ESQDISP_UpdateStatusMaskAndRefresh_Return   (UpdateStatusMaskAndRefresh_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D5
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Shared return tail for _ESQDISP_UpdateStatusMaskAndRefresh.
; NOTES:
;   Restores D5-D7 and returns.
;------------------------------------------------------------------------------
ESQDISP_UpdateStatusMaskAndRefresh_Return:
    MOVEM.L (A7)+,D5-D7
    RTS

;!======