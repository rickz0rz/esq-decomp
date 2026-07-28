    XDEF    _SCRIPT_ReadNextRbfByte




;------------------------------------------------------------------------------
; FUNC: _SCRIPT_ReadNextRbfByte   (ReadNextRbfByte)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   D0
; CALLS:
;   _SCRIPT2_JMPTBL_ESQ_ReadSerialRbfByte
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Thin wrapper around _ESQ_ReadSerialRbfByte.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_SCRIPT_ReadNextRbfByte:
    JSR     _SCRIPT2_JMPTBL_ESQ_ReadSerialRbfByte(PC)

    RTS

;!======