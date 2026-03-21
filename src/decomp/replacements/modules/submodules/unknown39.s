;------------------------------------------------------------------------------
; DECOMP TARGETS unknown39 graphics blit helper module boundary
; SOURCE: modules/submodules/unknown39.s
; PURPOSE:
;   Object-level hybrid replacement for UNKNOWN39 now that the restored SAS/C
;   lane covers GRAPHICS_BltBitMapRastPort. This replacement now carries the
;   module body directly instead of delegating back to the canonical asm
;   include.
;------------------------------------------------------------------------------

    XDEF    GRAPHICS_BltBitMapRastPort

;------------------------------------------------------------------------------
; FUNC: GRAPHICS_BltBitMapRastPort   (Wrapper around Graphics.library blit)
; ARGS:
;   stack +28: A0 = source BitMap
;   stack +32: D0 = src X
;   stack +36: D1 = src Y
;   stack +40: A1 = destination RastPort
;   stack +44: D2 = dst X
;   stack +48: D3 = dst Y
;   stack +52: D4 = width
;   stack +56: D5 = height
;   stack +60: D6 = minterm
;   stack +64: D7 = mask
; RET:
;   D0: library call result/status
; CLOBBERS:
;   D0-D6/A0-A1/A6
; CALLS:
;   _LVOBltBitMapRastPort
; READS:
;   Global_GraphicsLibraryBase_A4
; DESC:
;   Loads Graphics.library base from A4 globals and forwards the full blit
;   argument pack to BltBitMapRastPort.
;------------------------------------------------------------------------------
GRAPHICS_BltBitMapRastPort:
    MOVEM.L D2-D6/A6,-(A7)

    MOVEA.L Global_GraphicsLibraryBase_A4(A4),A6
    MOVEA.L 28(A7),A0
    MOVEM.L 32(A7),D0-D1
    MOVEA.L 40(A7),A1
    MOVEM.L 44(A7),D2-D6
    JSR     _LVOBltBitMapRastPort(A6)

    MOVEM.L (A7)+,D2-D6/A6
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    MOVEQ   #97,D0
