;------------------------------------------------------------------------------
; FUNC: GRAPHICS_BltBitMapRastPort   (Wrapper around Graphics.library blituncertain)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D6/A0-A1/A6
; DESC:
;   Loads Graphics.library base and dispatches to _LVOBltBitMapRastPort.
; NOTES:
;   None
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
