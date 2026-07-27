    XDEF    _ESQ_InvokeGcommandInit

;------------------------------------------------------------------------------
; FUNC: _ESQ_InvokeGcommandInit   (InvokeGcommandInituncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0-A1
; CALLS:
;   _GCOMMAND_ProcessCtrlCommand
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Simple wrapper around _GCOMMAND_ProcessCtrlCommand with register preservation.
; NOTES:
;   Likely used as a callback.
;------------------------------------------------------------------------------
_ESQ_InvokeGcommandInit:
    MOVEM.L A0-A1,-(A7)
    JSR     _GCOMMAND_ProcessCtrlCommand

    ADDQ.L  #8,A7
    RTS

;!======

    ; Alignment
    ALIGN_WORD
