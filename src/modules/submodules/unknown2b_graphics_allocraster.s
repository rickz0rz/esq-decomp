    XDEF    _GRAPHICS_AllocRaster

;------------------------------------------------------------------------------
; FUNC: _GRAPHICS_AllocRaster   (AllocRaster wrapper)
; ARGS:
;   stack +16: D7 = width
;   stack +20: D6 = height
; RET:
;   D0: raster pointer (or 0)
; CLOBBERS:
;   A6/A7/D0/D1/D6/D7
; CALLS:
;   _LVOAllocRaster
; READS:
;   _Global_REF_GRAPHICS_LIBRARY
; WRITES:
;   (none observed)
; DESC:
;   Allocates a raster via graphics.library.
; NOTES:
;   Thin wrapper used by brush/display setup code.
;------------------------------------------------------------------------------
_GRAPHICS_AllocRaster:
    LINK.W  A5,#-4
    MOVEM.L D6-D7,-(A7)
    MOVE.L  16(A5),D7   ; Width
    MOVE.L  20(A5),D6   ; Height

    MOVE.L  D7,D0       ; Width
    MOVE.L  D6,D1       ; Height
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOAllocRaster(A6)

    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS

;!======