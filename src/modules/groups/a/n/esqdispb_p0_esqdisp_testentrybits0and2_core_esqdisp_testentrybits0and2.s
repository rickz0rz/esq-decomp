    XDEF    _ESQDISP_TestEntryBits0And2
    XDEF    _ESQDISP_TestEntryBits0And2_Core



;------------------------------------------------------------------------------
; FUNC: _ESQDISP_TestEntryBits0And2   (Test entry flags bit0+bit2)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Alias entry that immediately falls through to `_Core` implementation below.
; NOTES:
;   Kept as exported compatibility label for existing callsites.
;------------------------------------------------------------------------------
_ESQDISP_TestEntryBits0And2:
;------------------------------------------------------------------------------
; FUNC: _ESQDISP_TestEntryBits0And2_Core   (Test entry flags bit0 and bit2)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Returns 1 only when both bit0 and bit2 are set in entry status byte +40.
; NOTES:
;   Returns 0 for NULL entry pointers.
;------------------------------------------------------------------------------
_ESQDISP_TestEntryBits0And2_Core:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3

    MOVEQ   #0,D7
    MOVE.L  A3,D0
    BEQ.S   .return

    BTST    #0,40(A3)
    BEQ.S   .bits_not_set

    BTST    #2,40(A3)
    BEQ.S   .bits_not_set

    MOVEQ   #1,D0
    BRA.S   .store_result

.bits_not_set:
    MOVEQ   #0,D0

.store_result:
    MOVE.L  D0,D7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======