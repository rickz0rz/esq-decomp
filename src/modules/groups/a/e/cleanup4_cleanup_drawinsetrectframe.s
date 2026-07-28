    XDEF    _CLEANUP_DrawInsetRectFrame


;------------------------------------------------------------------------------
; FUNC: _CLEANUP_DrawInsetRectFrame   (DrawInsetRectFrameuncertain)
; ARGS:
;   stack +4: rastPort (struct RastPort*)
;   stack +8: pen (byte)
;   stack +12: width (word)
;   stack +16: height (word)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1/A3/A6
; CALLS:
;   _LVOSetAPen, _LVORectFill, _LVOMove, _LVODraw
; READS:
;   rastPort fields (25/36/38/62 offsets)
; WRITES:
;   rastPort drawing
; DESC:
;   Draws a filled rectangle and multiple inset outline strokes.
; NOTES:
;   - Uses pen 1 and 2 to draw the inset border layers.
;------------------------------------------------------------------------------
_CLEANUP_DrawInsetRectFrame:
    LINK.W  A5,#-24
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.B  15(A5),D7
    MOVE.W  18(A5),D6
    MOVE.W  22(A5),D5
    MOVE.B  25(A3),D4
    EXT.W   D4
    EXT.L   D4
    MOVE.W  36(A3),D0
    MOVE.W  38(A3),D1
    ADDQ.W  #2,D1
    MOVE.W  D0,-6(A5)
    SUBQ.W  #2,D0
    MOVE.W  D1,-8(A5)
    SUB.W   62(A3),D1
    SUBQ.W  #1,D1
    ADDQ.W  #2,D6
    MOVE.L  D7,D2
    EXT.W   D2
    EXT.L   D2
    MOVE.W  D0,-10(A5)
    MOVE.W  D1,-12(A5)

    MOVEA.L A3,A1
    MOVE.L  D2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    MOVE.W  -10(A5),D2
    EXT.L   D2
    MOVE.L  D6,D3
    EXT.L   D3
    ADD.L   D3,D2
    MOVE.W  -12(A5),D3
    EXT.L   D3
    MOVE.L  D2,36(A7)
    MOVE.L  D5,D2
    EXT.L   D2
    ADD.L   D2,D3
    MOVEA.L A3,A1
    MOVE.L  36(A7),D2
    JSR     _LVORectFill(A6)

    MOVEA.L A3,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    SUBQ.L  #2,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    ADD.L   D2,D1
    ADDQ.L  #2,D1
    MOVEA.L A3,A1
    JSR     _LVOMove(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    SUBQ.L  #2,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    SUBQ.L  #2,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D1,D0
    ADDQ.L  #2,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    SUBQ.L  #2,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    SUBQ.L  #1,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    ADD.L   D2,D1
    ADDQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVOMove(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    SUBQ.L  #1,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    SUBQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D1,D0
    ADDQ.L  #1,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    SUBQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVEA.L A3,A1
    MOVEQ   #2,D0
    JSR     _LVOSetAPen(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D1,D0
    ADDQ.L  #2,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    SUBQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVOMove(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D1,D0
    ADDQ.L  #2,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    ADD.L   D2,D1
    ADDQ.L  #2,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    SUBQ.L  #1,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    ADD.L   D2,D1
    ADDQ.L  #2,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D1,D0
    ADDQ.L  #1,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    MOVEA.L A3,A1
    JSR     _LVOMove(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D1,D0
    ADDQ.L  #1,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    ADD.L   D2,D1
    ADDQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    ADD.L   D2,D1
    ADDQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  -6(A5),D0
    EXT.L   D0
    MOVE.W  -8(A5),D1
    EXT.L   D1
    MOVEA.L A3,A1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVE.L  D4,D0
    JSR     _LVOSetAPen(A6)

    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======