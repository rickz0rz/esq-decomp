    XDEF    _TLIBA1_ParseStyleCodeChar


;------------------------------------------------------------------------------
; FUNC: _TLIBA1_ParseStyleCodeChar   (Parse style char '1'..'7' or 'X')
; ARGS:
;   stack +8: styleChar (u8)
; RET:
;   D0: -1 for 'X', 1..7 for '1'..'7', else 0
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Converts single-character style tokens into compact numeric style IDs.
; NOTES:
;   Input is case-sensitive for 'X'.
;------------------------------------------------------------------------------
_TLIBA1_ParseStyleCodeChar:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7
    MOVEQ   #88,D0
    CMP.B   D0,D7
    BNE.S   .if_ne_176D

    MOVEQ   #-1,D7
    BRA.S   .return_1770

.if_ne_176D:
    MOVEQ   #49,D0
    CMP.B   D0,D7
    BCS.S   .if_cs_176E

    MOVEQ   #55,D0
    CMP.B   D0,D7
    BLS.S   .if_ls_176F

.if_cs_176E:
    MOVEQ   #0,D7
    BRA.S   .return_1770

.if_ls_176F:
    SUBI.B  #$30,D7

.return_1770:
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS

;!======