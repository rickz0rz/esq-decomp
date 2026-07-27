    XDEF    _ESQDISP_AllocateHighlightBitmaps
    XDEF    ESQDISP_AllocateHighlightBitmaps_Return




;------------------------------------------------------------------------------
; FUNC: _ESQDISP_AllocateHighlightBitmaps   (Initialize 3-plane bitmap and allocate plane rasters)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A6/A7/D0/D1/D2/D7
; CALLS:
;   _ESQDISP_JMPTBL_GRAPHICS_AllocRaster, _LVOBltClear, _LVOInitBitMap
; READS:
;   Global_REF_GRAPHICS_LIBRARY, _Global_STR_ESQDISP_C, _WDISP_HighlightRasterHeightPx
; WRITES:
;   A3+8/A3+12/A3+16 raster plane pointers
; DESC:
;   Initializes a 696-wide, 3-plane highlight bitmap descriptor and allocates one
;   raster per plane using configured highlight height.
; NOTES:
;   Clears each allocated plane with BltClear before returning.
;------------------------------------------------------------------------------
_ESQDISP_AllocateHighlightBitmaps:
    LINK.W  A5,#-4
    MOVEM.L D2/D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVEQ   #0,D0
    MOVE.W  _WDISP_HighlightRasterHeightPx,D0
    MOVEA.L A3,A0
    MOVE.L  D0,D2
    MOVEQ   #3,D0
    MOVE.L  #696,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    MOVEQ   #0,D7

.alloc_plane_loop:
    MOVEQ   #3,D0
    CMP.L   D0,D7
    BGE.S   ESQDISP_AllocateHighlightBitmaps_Return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEQ   #0,D1

    MOVE.W  _WDISP_HighlightRasterHeightPx,D1
    MOVE.L  D1,-(A7)                    ; Height
    PEA     696.W                       ; Width
    PEA     79.W                        ; Line Number
    PEA     _Global_STR_ESQDISP_C          ; Calling File
    MOVE.L  D0,28(A7)
    JSR     _ESQDISP_JMPTBL_GRAPHICS_AllocRaster(PC)

    LEA     16(A7),A7
    MOVE.L  12(A7),D1
    MOVE.L  D0,8(A3,D1.L)
    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVE.W  _WDISP_HighlightRasterHeightPx,D1
    MULU    #$58,D1
    MOVE.L  D0,12(A7)
    MOVE.L  D1,D0
    MOVE.L  12(A7),D2
    MOVEA.L 8(A3,D2.L),A1
    MOVEQ   #0,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOBltClear(A6)

    ADDQ.L  #1,D7
    BRA.S   .alloc_plane_loop

;------------------------------------------------------------------------------
; FUNC: ESQDISP_AllocateHighlightBitmaps_Return   (Return tail for highlight bitmap allocator)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Restores saved registers/frame state and returns to caller.
; NOTES:
;   Shared exit for allocation loop bound check.
;------------------------------------------------------------------------------
ESQDISP_AllocateHighlightBitmaps_Return:
    MOVEM.L (A7)+,D2/D7/A3
    UNLK    A5
    RTS

;!======