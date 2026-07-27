    XDEF    _NEWGRID_DrawTopBorderLine


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_DrawTopBorderLine   (Draw filled rect 0,0..695,1)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A6
; CALLS:
;   _LVOSetAPen, _LVORectFill
; READS:
;   _NEWGRID_HeaderRastPortPtr
; WRITES:
;   none
; DESC:
;   Draws a 1-pixel-tall horizontal bar at the top of the grid area.
; NOTES:
;   Uses pen 7 on the secondary grid rastport.
;------------------------------------------------------------------------------
_NEWGRID_DrawTopBorderLine:
    MOVEM.L D2-D3,-(A7)

    MOVEA.L _NEWGRID_HeaderRastPortPtr,A1
    MOVEQ   #7,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    ; Draw a filled rect from 0,0 to 695,1
    MOVEA.L _NEWGRID_HeaderRastPortPtr,A1
    MOVEQ   #0,D0               ; x.min = 0
    MOVE.L  D0,D1               ; y.min = 0
    MOVE.L  #695,D2             ; x.max = 695
    MOVEQ   #1,D3               ; y.max = 1
    JSR     _LVORectFill(A6)

    MOVEM.L (A7)+,D2-D3
    RTS

;!======