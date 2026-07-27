    XDEF    _ESQSHARED_InitEntryDefaults


;------------------------------------------------------------------------------
; FUNC: _ESQSHARED_InitEntryDefaults   (Initialize new entry default header fields)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A7/D0
; CALLS:
;   (none)
; READS:
;   _ESQPARS_DefaultEntryCodeString
; WRITES:
;   (none observed)
; DESC:
;   Seeds default entry header bytes: status at +40, flags at +41/+42, two-byte
;   code string at +43..+44, and default word value 3 at +46.
; NOTES:
;   Uses _ESQPARS_DefaultEntryCodeString as the default code-string source.
;------------------------------------------------------------------------------
_ESQSHARED_InitEntryDefaults:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.B  #$2,40(A3)
    MOVEQ   #-1,D0
    MOVE.B  D0,41(A3)
    MOVE.B  D0,42(A3)
    LEA     43(A3),A0
    LEA     _ESQPARS_DefaultEntryCodeString,A1

.lab_0C1D:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .lab_0C1D

    MOVE.W  #3,46(A3)
    MOVEA.L (A7)+,A3
    RTS

;!======