    XDEF    _ESQ_PollCtrlInput


;------------------------------------------------------------------------------
; FUNC: _ESQ_PollCtrlInput   (PollCtrlInput)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A0-A1, A4-A5
; CALLS:
;   _ESQ_CaptureCtrlBit4Stream, _ESQ_CaptureCtrlBit3Stream
; READS:
;   _ESQ_STR_B
; WRITES:
;   INTREQ
; DESC:
;   Updates CTRL sampling state and acknowledges the audio channel 1 interrupt.
; NOTES:
;   Only captures the bit-3 stream when _ESQ_STR_B+ESQ_StatusPacket__Bit3CaptureGateChar holds 'N'.
;------------------------------------------------------------------------------
_ESQ_PollCtrlInput:
    MOVE.L  A5,-(A7)
    MOVE.L  A4,-(A7)

    BSR.S   _ESQ_CaptureCtrlBit4Stream

    LEA     _ESQ_STR_B,A4
    MOVE.B  ESQ_StatusPacket__Bit3CaptureGateChar(A4),D1 ; A4+18 = status byte gate for CTRL bit-3 capture
    CMPI.B  #"N",D1
    BNE.S   .lab_0040

    JSR     _ESQ_CaptureCtrlBit3Stream(PC)

.lab_0040:
    MOVEA.L #BLTDDAT,A0
    MOVE.W  #$100,(INTREQ-BLTDDAT)(A0)
    ; Looking at that, 0100 means bit 8 starting from the right as 0 is set
    ; so we're setting "Audio channel 1 block finished"

    MOVEA.L (A7)+,A4
    MOVEA.L (A7)+,A5
    RTS

;!======