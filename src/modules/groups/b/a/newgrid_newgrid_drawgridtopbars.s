    XDEF    _NEWGRID_DrawGridTopBars


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_DrawGridTopBars   (Draw top header bars)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A3
; CALLS:
;   _NEWGRID_FillGridRects (_NEWGRID_FillGridRects)
; READS:
;   _NEWGRID_HeaderRastPortPtr
; WRITES:
;   none
; DESC:
;   Draws the top bar rectangles using fixed parameters.
; NOTES:
;   Wrapper around _NEWGRID_FillGridRects.
;------------------------------------------------------------------------------
_NEWGRID_DrawGridTopBars:
    PEA     1.W
    MOVEQ   #6,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  _NEWGRID_HeaderRastPortPtr,-(A7)
    BSR.S   _NEWGRID_FillGridRects

    LEA     16(A7),A7
    RTS

;!======