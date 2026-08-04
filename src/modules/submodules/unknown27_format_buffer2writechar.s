    XDEF    _FORMAT_Buffer2WriteChar


;------------------------------------------------------------------------------
; FUNC: _FORMAT_Buffer2WriteChar   (Append a byte to format buffer #2.)
; ARGS:
;   stack +8: D7 = byte to append
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D7/A0
; READS:
;   Global_FormatBufferPtr2, Global_FormatByteCount2
; WRITES:
;   Global_FormatBufferPtr2, Global_FormatByteCount2
;------------------------------------------------------------------------------
_FORMAT_Buffer2WriteChar:
    MOVE.L  D7,-(A7)

    MOVE.L  8(A7),D7
    ADDQ.L  #1,Global_FormatByteCount2(A4)
    MOVE.L  D7,D0
    MOVEA.L Global_FormatBufferPtr2(A4),A0
    MOVE.B  D0,(A0)+
    MOVE.L  A0,Global_FormatBufferPtr2(A4)

    MOVE.L  (A7)+,D7
    RTS

;!======