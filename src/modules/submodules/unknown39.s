;------------------------------------------------------------------------------
; FUNC: GRAPHICS_BltBitMapRastPort   (Wrapper around Graphics.library blit??)
; ARGS:
;   stack +4:  A0 = source BitMap??
;   stack +8:  D0-D1 = src x/y??
;   stack +16: A1 = destination RastPort??
;   stack +20: D2-D6 = blit params (dst x/y, size, minterm, mask??)
; RET:
;   D0: status (per Graphics.library) ??
; CLOBBERS:
;   D0-D6/A0-A1/A6
; DESC:
;   Loads Graphics.library base and dispatches to LVO -606.
; NOTES:
;   LVO -606 is likely BltBitMapRastPort; verify with call sites.
;------------------------------------------------------------------------------
GRAPHICS_BltBitMapRastPort:
    MOVEM.L D2-D6/A6,-(A7)

    MOVEA.L Global_GraphicsLibraryBase_A4(A4),A6
    MOVEA.L 28(A7),A0
    MOVEM.L 32(A7),D0-D1
    MOVEA.L 40(A7),A1
    MOVEM.L 44(A7),D2-D6
    JSR     -606(A6)            ; I think this may be BltBitMapRastPort in Graphics.library

    MOVEM.L (A7)+,D2-D6/A6
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    MOVEQ   #97,D0
