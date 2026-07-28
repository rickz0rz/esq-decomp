    XDEF    _SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte


;------------------------------------------------------------------------------
; FUNC: _SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte   (Routine at _SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _SCRIPT2_JMPTBL_ESQ_CaptureCtrlBit4StreamBufferByte
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte:
    JSR     _SCRIPT2_JMPTBL_ESQ_CaptureCtrlBit4StreamBufferByte(PC)

    RTS

;!======