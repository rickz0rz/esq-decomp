    XDEF    ESQ_InvokeGcommandInit

;------------------------------------------------------------------------------
; FUNC: ESQ_InvokeGcommandInit   (InvokeGcommandInituncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0-A1
; CALLS:
;   GCOMMAND_ProcessCtrlCommand
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Simple wrapper around GCOMMAND_ProcessCtrlCommand with register preservation.
; NOTES:
;   Likely used as a callback.
;------------------------------------------------------------------------------
ESQ_InvokeGcommandInit:
    MOVEM.L A0-A1,-(A7)
    JSR     GCOMMAND_ProcessCtrlCommand

    ADDQ.L  #8,A7
    RTS

;!======

    ; Alignment
    ALIGN_WORD
