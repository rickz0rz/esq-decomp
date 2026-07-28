    XDEF    BEVEL_DrawBeveledFrame


;------------------------------------------------------------------------------
; FUNC: BEVEL_DrawBeveledFrame   (DrawBeveledFrameuncertain)
; ARGS:
;   stack +4: rastPort
;   stack +8: leftX
;   stack +12: topY
;   stack +16: rightX
;   stack +20: bottomY
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A3
; CALLS:
;   _BEVEL_DrawVerticalBevelPair, _BEVEL_DrawVerticalBevel
; READS:
;   (none)
; WRITES:
;   RastPort
; DESC:
;   Draws a beveled frame with left/right edges and a corner accent.
; NOTES:
;   Composes _BEVEL_DrawVerticalBevelPair + _BEVEL_DrawVerticalBevel helpers.
;------------------------------------------------------------------------------
BEVEL_DrawBeveledFrame:
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.L  28(A7),D7
    MOVE.L  32(A7),D6
    MOVE.L  36(A7),D5
    MOVE.L  40(A7),D4

    MOVE.L  D4,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _BEVEL_DrawVerticalBevelPair

    MOVE.L  D4,(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _BEVEL_DrawVerticalBevel

    LEA     36(A7),A7

    MOVEA.L A3,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    ADDQ.L  #3,D0
    MOVE.L  D6,D1
    ADDQ.L  #3,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======