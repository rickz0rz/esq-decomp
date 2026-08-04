    XDEF    _GRAPHICS_FreeRaster

;------------------------------------------------------------------------------
; FUNC: _GRAPHICS_FreeRaster   (FreeRaster wrapper)
; ARGS:
;   stack +16: A3 = raster pointer
;   stack +20: D7 = width
;   stack +24: D6 = height
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A6/A7/D0/D1/D6/D7
; CALLS:
;   _LVOFreeRaster
; READS:
;   _Global_REF_GRAPHICS_LIBRARY
; WRITES:
;   (none observed)
; DESC:
;   Frees a raster via graphics.library.
; NOTES:
;   Thin wrapper paired with _GRAPHICS_AllocRaster.
;------------------------------------------------------------------------------
_GRAPHICS_FreeRaster:
    LINK.W  A5,#0
    MOVEM.L D6-D7/A3,-(A7)

    MOVEA.L 16(A5),A3
    MOVE.L  20(A5),D7
    MOVE.L  24(A5),D6

    MOVEA.L A3,A0
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOFreeRaster(A6)

    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======