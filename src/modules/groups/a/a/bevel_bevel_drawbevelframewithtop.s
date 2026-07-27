    XDEF    _BEVEL_DrawBevelFrameWithTop


;------------------------------------------------------------------------------
; FUNC: _BEVEL_DrawBevelFrameWithTop   (DrawBevelFrameWithTopuncertain)
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
;   _BEVEL_DrawVerticalBevelPair, _BEVEL_DrawHorizontalBevel
; READS:
;   (none)
; WRITES:
;   RastPort
; DESC:
;   Draws a beveled frame with a top horizontal edge.
; NOTES:
;   Composes _BEVEL_DrawVerticalBevelPair + _BEVEL_DrawHorizontalBevel helpers.
;------------------------------------------------------------------------------
_BEVEL_DrawBevelFrameWithTop:
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
    BSR.W   _BEVEL_DrawHorizontalBevel

    LEA     36(A7),A7

    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======