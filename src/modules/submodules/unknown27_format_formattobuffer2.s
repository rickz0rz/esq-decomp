    XDEF    _FORMAT_FormatToBuffer2


;------------------------------------------------------------------------------
; FUNC: _FORMAT_FormatToBuffer2   (Format string into buffer #2.)
; ARGS:
;   stack +16: A3 = output buffer
;   stack +20: A2 = format string
;   stack +24: varargs pointer
; RET:
;   D0: bytes written (excluding terminator)
; CLOBBERS:
;   D0/A0-A3
; CALLS:
;   _WDISP_FormatWithCallback, _FORMAT_Buffer2WriteChar
; WRITES:
;   Global_FormatBufferPtr2, Global_FormatByteCount2
;------------------------------------------------------------------------------
_FORMAT_FormatToBuffer2:
    LINK.W  A5,#0
    MOVEM.L A2-A3,-(A7)

    MOVEA.L 16(A7),A3
    MOVEA.L 20(A7),A2
    CLR.L   Global_FormatByteCount2(A4)
    MOVE.L  A3,Global_FormatBufferPtr2(A4)
    MOVE.L  16(A5),-(A7)
    MOVE.L  A2,-(A7)
    PEA     _FORMAT_Buffer2WriteChar(PC)
    JSR     _WDISP_FormatWithCallback(PC)

    MOVEA.L Global_FormatBufferPtr2(A4),A0
    CLR.B   (A0)
    MOVE.L  Global_FormatByteCount2(A4),D0

    MOVEM.L -8(A5),A2-A3
    UNLK    A5
    RTS

;!======