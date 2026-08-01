    XDEF    _TEXTDISP_TrimTextToPixelWidth


;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_TrimTextToPixelWidth   (Trim text to pixel width)
; ARGS:
;   stack +8: textPtr (A3)
;   stack +12: maxWidth (long)
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _LVOTextLength
; READS:
;   _WDISP_DisplayContextBase
; DESC:
;   Trims text to fit maxWidth, skipping control bytes 0x18/0x19.
; NOTES:
;   Uses the rastport stored in _WDISP_DisplayContextBase for font metrics.
;------------------------------------------------------------------------------
_TEXTDISP_TrimTextToPixelWidth:
    LINK.W  A5,#-28
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVEQ   #25,D4
    MOVEA.L A3,A0
    CLR.L   -8(A5)
    MOVEQ   #0,D6
    MOVEA.L _WDISP_DisplayContextBase,A1
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A1
    MOVEA.L A0,A2

.measure_text_len:
    TST.B   (A2)+
    BNE.S   .measure_text_len

    SUBQ.L  #1,A2
    SUBA.L  A0,A2
    MOVE.L  A0,-4(A5)
    MOVE.L  A2,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5

.trim_loop:
    CMP.L   D7,D5
    BLE.W   .return

    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.W   .return

    MOVE.B  (A0),D0
    MOVEQ   #24,D1
    CMP.B   D1,D0
    BEQ.S   .handle_control_prefix

    MOVEQ   #25,D1
    CMP.B   D1,D0
    BNE.S   .measure_char

.handle_control_prefix:
    MOVE.L  D0,D4
    ADDQ.L  #1,-4(A5)
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L -4(A5),A1

.measure_after_control:
    TST.B   (A1)+
    BNE.S   .measure_after_control

    SUBQ.L  #1,A1
    SUBA.L  -4(A5),A1
    MOVE.L  A1,28(A7)
    MOVEA.L A0,A1
    MOVEA.L -4(A5),A0
    MOVE.L  28(A7),D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5
    MOVEQ   #0,D6
    CLR.L   -8(A5)
    BRA.S   .trim_loop

.measure_char:
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEA.L -4(A5),A0
    MOVEQ   #1,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    ADD.L   D0,D6
    CMP.L   D7,D6
    BLE.S   .track_last_space

    TST.L   -8(A5)
    BEQ.S   .return

    MOVEA.L -8(A5),A0
    MOVE.B  D4,(A0)
    LEA     1(A0),A1
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A1,A2

.measure_after_insert:
    TST.B   (A2)+
    BNE.S   .measure_after_insert

    SUBQ.L  #1,A2
    SUBA.L  A1,A2
    MOVE.L  A1,-4(A5)
    MOVEA.L A0,A1
    MOVE.L  A2,D0
    MOVEA.L -4(A5),A0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5
    MOVEQ   #0,D6
    CLR.L   -8(A5)
    BRA.W   .trim_loop

.track_last_space:
    MOVEQ   #32,D0
    MOVEA.L -4(A5),A0
    CMP.B   (A0),D0
    BNE.S   .advance_char

    MOVE.L  A0,-8(A5)

.advance_char:
    ADDQ.L  #1,-4(A5)
    BRA.W   .trim_loop

.return:
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS
