    XDEF    _ED_DecrementAdNumber

;------------------------------------------------------------------------------
; FUNC: _ED_DecrementAdNumber   (Decrement current ad numberuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   none observed
; CALLS:
;   _ED_ApplyActiveFlagToAdData, _ED_UpdateAdNumberDisplay
; READS:
;   _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
; WRITES:
;   _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
; DESC:
;   Decrements the current ad number if above 1 and refreshes display.
; NOTES:
;   Calls _ED_ApplyActiveFlagToAdData before decrement to commit current state.
;------------------------------------------------------------------------------
_ED_DecrementAdNumber:
    CMPI.L  #1,_Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BLE.S   .return

    BSR.W   _ED_ApplyActiveFlagToAdData

    SUBQ.L  #1,_Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BSR.W   _ED_UpdateAdNumberDisplay

.return:
    RTS

;!======
