    XDEF    _ED_IsConfirmKey

;------------------------------------------------------------------------------
; FUNC: _ED_IsConfirmKey   (Check for confirm keyuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   (none)
; READS:
;   _ED_LastKeyCode
; WRITES:
;   (none)
; DESC:
;   Returns a flag based on the current key code in _ED_LastKeyCode.
; NOTES:
;   Treats key codes $59 and $20 as confirm keys.
;------------------------------------------------------------------------------
_ED_IsConfirmKey:
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D0
    MOVE.B  _ED_LastKeyCode,D0
    SUBI.W  #$59,D0
    BEQ.S   .case_confirm

    SUBI.W  #$20,D0
    BNE.S   .case_other

.case_confirm:
    MOVEQ   #0,D7
    BRA.S   .return

.case_other:
    MOVEQ   #1,D7

.return:
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS

;!======
