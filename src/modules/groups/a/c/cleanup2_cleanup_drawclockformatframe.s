    XDEF    _CLEANUP_DrawClockFormatFrame


;------------------------------------------------------------------------------
; FUNC: _CLEANUP_DrawClockFormatFrame   (DrawClockFormatFrameuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0
; CALLS:
;   _GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort
; READS:
;   _NEWGRID_ColumnStartXPx, _NEWGRID_MainRastPortPtr
; WRITES:
;   (none)
; DESC:
;   Draws the frame/box for the clock format list area.
; NOTES:
;   - Uses _NEWGRID_ColumnStartXPx as a layout offset.
;------------------------------------------------------------------------------
_CLEANUP_DrawClockFormatFrame:
    MOVEM.L D2-D3,-(A7)
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVE.L  D0,D1
    MOVEQ   #36,D2
    ADD.L   D2,D1
    MOVEQ   #0,D3
    MOVE.W  D0,D3
    ADD.L   D2,D3
    MOVEQ   #0,D2
    MOVE.W  D0,D2
    MOVE.L  #660,D0
    SUB.L   D2,D0
    PEA     192.W
    MOVEQ   #34,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  _NEWGRID_MainRastPortPtr,-(A7)
    CLR.L   -(A7)
    MOVE.L  D1,-(A7)
    MOVEA.L _NEWGRID_MainRastPortPtr,A0
    MOVE.L  4(A0),-(A7)
    JSR     _GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(PC)

    LEA     36(A7),A7
    MOVEM.L (A7)+,D2-D3
    RTS

;!======