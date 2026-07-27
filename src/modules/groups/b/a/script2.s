    XDEF    SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte
    XDEF    SCRIPT_ReadNextRbfByte



;------------------------------------------------------------------------------
; FUNC: SCRIPT_ReadNextRbfByte   (ReadNextRbfByte)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   D0
; CALLS:
;   SCRIPT2_JMPTBL_ESQ_ReadSerialRbfByte
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Thin wrapper around _ESQ_ReadSerialRbfByte.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
SCRIPT_ReadNextRbfByte:
    JSR     SCRIPT2_JMPTBL_ESQ_ReadSerialRbfByte(PC)

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte   (Routine at SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   SCRIPT2_JMPTBL_ESQ_CaptureCtrlBit4StreamBufferByte
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte:
    JSR     SCRIPT2_JMPTBL_ESQ_CaptureCtrlBit4StreamBufferByte(PC)

    RTS

;!======