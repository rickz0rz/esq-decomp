    XDEF    _ED_IncrementAdNumber

;------------------------------------------------------------------------------
; FUNC: _ED_IncrementAdNumber   (Increment current ad numberuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0
; CALLS:
;   _ED_ApplyActiveFlagToAdData, _ED_UpdateAdNumberDisplay
; READS:
;   _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER, _ED_MaxAdNumber
; WRITES:
;   _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
; DESC:
;   Increments the current ad number if within bounds and refreshes display.
; NOTES:
;   Calls _ED_ApplyActiveFlagToAdData before increment to commit current state.
;------------------------------------------------------------------------------
_ED_IncrementAdNumber:
    MOVE.L  _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    CMP.L   _ED_MaxAdNumber,D0
    BGE.S   .return

    BSR.W   _ED_ApplyActiveFlagToAdData

    ADDQ.L  #1,_Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BSR.W   _ED_UpdateAdNumberDisplay

.return:
    RTS

;!======
