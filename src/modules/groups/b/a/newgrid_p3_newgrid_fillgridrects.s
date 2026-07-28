    XDEF    _NEWGRID_FillGridRects



;------------------------------------------------------------------------------
; FUNC: _NEWGRID_FillGridRects   (Fill two grid rectangles)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: D7 = pen for first rect
;   stack +16: D6 = pen for second rect
;   stack +20: D5 = y2 for first rect
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _LVOSetAPen, _LVORectFill
; READS:
;   _NEWGRID_ColumnStartXPx
; WRITES:
;   none
; DESC:
;   Fills two horizontal rectangles in the grid header region with different pens.
; NOTES:
;   Uses SetOffsetForStack macro for parameters.
;------------------------------------------------------------------------------
_NEWGRID_FillGridRects:
    MOVEM.L D2-D3/D5-D7/A3,-(A7)

    SetOffsetForStack 6

    MOVEA.L .stackOffsetBytes+4(A7),A3
    MOVE.L  .stackOffsetBytes+8(A7),D7
    MOVE.L  .stackOffsetBytes+12(A7),D6
    MOVE.L  .stackOffsetBytes+16(A7),D5

    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVEA.L A3,A1
    MOVE.L  D0,D2
    MOVE.L  D5,D3
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    JSR     _LVORectFill(A6)

    MOVEA.L A3,A1
    MOVE.L  D6,D0
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVEA.L A3,A1
    MOVEQ   #0,D1
    MOVE.L  #695,D2
    JSR     _LVORectFill(A6)

    MOVEM.L (A7)+,D2-D3/D5-D7/A3
    RTS

;!======