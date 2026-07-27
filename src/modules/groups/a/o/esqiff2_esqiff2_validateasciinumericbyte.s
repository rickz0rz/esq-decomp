    XDEF    _ESQIFF2_ValidateAsciiNumericByte


;------------------------------------------------------------------------------
; FUNC: _ESQIFF2_ValidateAsciiNumericByte   (Validate byte is ASCII '1'..'0' range used by parser)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Returns input byte when it lies in accepted ASCII range, otherwise leaves D0 as 1.
; NOTES:
;   Preserves D7 across call.
;------------------------------------------------------------------------------
_ESQIFF2_ValidateAsciiNumericByte:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7

    MOVEQ   #1,D0
    CMP.B   D0,D7
    BLT.S   .return

    MOVEQ   #48,D1
    CMP.B   D1,D7
    BGT.S   .return

    MOVE.L  D7,D0

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======