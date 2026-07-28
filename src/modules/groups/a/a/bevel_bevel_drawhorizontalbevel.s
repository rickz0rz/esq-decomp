    XDEF    _BEVEL_DrawHorizontalBevel


;------------------------------------------------------------------------------
; FUNC: _BEVEL_DrawHorizontalBevel   (DrawHorizontalBeveluncertain)
; ARGS:
;   stack +4: rastPort
;   stack +8: leftX
;   stack +12: rightX
;   stack +16: y
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
;   Draws a multi-line horizontal beveled edge at y with pen 2.
; NOTES:
;   Repeats offset strokes to create a thicker edge.
;------------------------------------------------------------------------------
_BEVEL_DrawHorizontalBevel:
    LINK.W  A5,#-4
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  20(A5),D6
    MOVE.L  24(A5),D5

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L A3,A1
    MOVEQ   #2,D0
    JSR     _LVOSetAPen(A6)

    MOVE.W  #(-1),34(A3)
    BSET    #0,33(A3)
    MOVE.B  #$f,30(A3)
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  D5,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D5,D1
    JSR     _LVODraw(A6)

    MOVE.L  D5,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,16(A7)
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  16(A7),D1
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVE.L  D5,D1
    SUBQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.L  D5,D0
    SUBQ.L  #2,D0
    MOVE.L  D0,16(A7)
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  16(A7),D1
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    ADDQ.L  #2,D0
    MOVE.L  D5,D1
    SUBQ.L  #2,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.L  D5,D0
    SUBQ.L  #3,D0
    MOVE.L  D0,16(A7)
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  16(A7),D1
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    ADDQ.L  #3,D0
    MOVE.L  D5,D1
    SUBQ.L  #3,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVEA.L A3,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  D5,D1
    JSR     _LVOMove(A6)

    MOVE.L  D6,D0
    SUBQ.L  #3,D0
    MOVE.L  D5,D1
    SUBQ.L  #3,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======