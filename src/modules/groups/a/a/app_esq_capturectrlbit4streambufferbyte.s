    XDEF    _ESQ_CaptureCtrlBit4StreamBufferByte


;------------------------------------------------------------------------------
; FUNC: _ESQ_CaptureCtrlBit4StreamBufferByte   (_ESQ_CaptureCtrlBit4StreamBufferByte)
; ARGS:
;   (none)
; RET:
;   D0: next byte from _CTRL_BUFFER (low byte)
; CLOBBERS:
;   D0-D1, A0
; CALLS:
;   (none)
; READS:
;   _CTRL_HPreviousSample, _CTRL_BUFFER
; WRITES:
;   _CTRL_HPreviousSample
; DESC:
;   Reads one byte from _CTRL_BUFFER and advances the tail index.
; NOTES:
;   Buffer wraps at $01F4.
;------------------------------------------------------------------------------
_ESQ_CaptureCtrlBit4StreamBufferByte:
    MOVEQ   #0,D1
    MOVE.L  D1,D0
    MOVE.W  _CTRL_HPreviousSample,D1
    LEA     _CTRL_BUFFER,A0
    ADDA.L  D1,A0
    MOVE.B  (A0),D0
    ADDQ.W  #1,D1
    CMPI.W  #$1f4,D1
    BNE.S   .tail_update_done

    MOVEQ   #0,D1

.tail_update_done:
    MOVE.W  D1,_CTRL_HPreviousSample
    RTS

;!======