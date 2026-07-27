    XDEF    _ED_PrevAdNumber


; Decrement the current ad number being edited
;------------------------------------------------------------------------------
; FUNC: _ED_PrevAdNumber   (Go to previous ad numberuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   (none)
; CALLS:
;   _ED_CommitCurrentAdEdits, _ED_LoadCurrentAdIntoBuffers
; READS:
;   _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
; WRITES:
;   _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
; DESC:
;   Commits current edits then moves to the previous ad.
; NOTES:
;   No-op when current ad number is 1.
;------------------------------------------------------------------------------
_ED_PrevAdNumber:
    CMPI.L  #$1,_Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BLE.S   .return

    BSR.S   _ED_CommitCurrentAdEdits

    SUBQ.L  #1,_Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BSR.W   _ED_LoadCurrentAdIntoBuffers

.return:
    RTS

;!======