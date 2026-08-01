    XDEF    _ED_DrawHelpPanels


;------------------------------------------------------------------------------
; FUNC: _ED_DrawHelpPanels
; ARGS:
;   stack +4: u16 penIndex uncertain
; RET:
;   (none)
; CLOBBERS:
;   D0-D3/D7/A1/A6 uncertain
; CALLS:
;   _LVOSetAPen, _LVORectFill, _LVOSetDrMd
; READS:
;   _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the rectangular panels behind help/menu text.
; NOTES:
;   Uses the stack argument to select the secondary pen.
;------------------------------------------------------------------------------
_ED_DrawHelpPanels:
    MOVEM.L D2-D3/D7,-(A7)
    MOVE.L  16(A7),D7

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVEQ   #68,D1
    MOVE.L  #640,D2
    MOVE.L  #297,D3
    JSR     _LVORectFill(A6)

    MOVE.L  D7,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #298,D1
    ; D2 is still 640
    MOVE.L  #429,D3
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEM.L (A7)+,D2-D3/D7
    RTS

;!======