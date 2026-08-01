    XDEF    _BEVEL_DrawVerticalBevelPair


; The moves and draws seem like this is making some kind of
; outlined box... maybe with a shadow or bevel?
;------------------------------------------------------------------------------
; FUNC: _BEVEL_DrawVerticalBevelPair   (DrawVerticalBevelPairuncertain)
; ARGS:
;   stack +4: rastPort
;   stack +8: leftX
;   stack +12: topY
;   stack +16: rightX
;   stack +20: bottomY
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A3, A6
; CALLS:
;   graphics.library Move/Draw/SetDrMd/SetAPen
; READS:
;   (none)
; WRITES:
;   RastPort
; DESC:
;   Draws two vertical beveled edges using pen 1 and pen 2.
; NOTES:
;   Offsets by +/-1..3 to thicken edges.
;------------------------------------------------------------------------------
_BEVEL_DrawVerticalBevelPair:
    MOVEM.L D4-D7/A3,-(A7)

    MOVEA.L 24(A7),A3
    MOVE.L  28(A7),D7
    MOVE.L  32(A7),D6
    MOVE.L  36(A7),D5
    MOVE.L  40(A7),D4

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L A3,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVE.W  #(-1),34(A3)
    BSET    #0,33(A3)
    MOVE.B  #$f,30(A3)

    MOVEA.L A3,A1
    MOVE.L  D7,D0               ; x
    MOVE.L  D6,D1               ; y
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D4,D1               ; y
    JSR     _LVODraw(A6)

    MOVE.L  D7,D0

    ADDQ.L  #1,D0               ; x
    MOVEA.L A3,A1               ; rastport
    MOVE.L  D6,D1               ; y
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVEA.L A3,A1
    MOVE.L  D4,D1
    JSR     _LVODraw(A6)

    MOVE.L  D7,D0
    ADDQ.L  #2,D0               ; x
    MOVEA.L A3,A1               ; rastport
    MOVE.L  D6,D1               ; y
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    ADDQ.L  #2,D0
    MOVEA.L A3,A1
    MOVE.L  D4,D1
    JSR     _LVODraw(A6)

    MOVE.L  D7,D0               ; x = D7
    ADDQ.L  #3,D0               ; x = x + 3
    MOVEA.L A3,A1               ; rastport
    MOVE.L  D6,D1               ; y = D1
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    ADDQ.L  #3,D0
    MOVEA.L A3,A1
    MOVE.L  D4,D1
    JSR     _LVODraw(A6)

    MOVEA.L A3,A1               ; rastport
    MOVEQ   #2,D0               ; pen number
    JSR     _LVOSetAPen(A6)

    MOVE.W  #(-1),34(A3)
    BSET    #0,33(A3)
    MOVE.B  #$f,30(A3)

    MOVEA.L A3,A1               ; rastport
    MOVE.L  D5,D0               ; x
    MOVE.L  D4,D1               ; y
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVE.L  D5,D0
    MOVE.L  D6,D1
    JSR     _LVODraw(A6)

    MOVE.L  D5,D0
    SUBQ.L  #1,D0
    MOVEA.L A3,A1
    MOVE.L  D4,D1
    JSR     _LVOMove(A6)

    MOVE.L  D5,D0
    SUBQ.L  #1,D0
    MOVEA.L A3,A1
    MOVE.L  D6,D1
    JSR     _LVODraw(A6)

    MOVE.L  D5,D0
    SUBQ.L  #2,D0
    MOVEA.L A3,A1
    MOVE.L  D4,D1
    JSR     _LVOMove(A6)

    MOVE.L  D5,D0
    SUBQ.L  #2,D0
    MOVEA.L A3,A1
    MOVE.L  D6,D1
    JSR     _LVODraw(A6)

    MOVE.L  D5,D0               ; x = D5
    SUBQ.L  #3,D0               ; x = x - 3
    MOVEA.L A3,A1               ; rastport
    MOVE.L  D4,D1               ; y
    JSR     _LVOMove(A6)

    MOVE.L  D5,D0               ; x = D5
    SUBQ.L  #3,D0               ; x = x - 3
    MOVEA.L A3,A1               ; rastport
    MOVE.L  D6,D1               ; y = D6
    JSR     _LVODraw(A6)

    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======