    XDEF    _ED_RedrawCursorChar


;------------------------------------------------------------------------------
; FUNC: _ED_RedrawCursorChar   (Redraw cursor characteruncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/D0
; CALLS:
;   _ED_DrawCursorChar, _LVOSetDrMd
; READS:
;   _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the current cursor character using a temporary draw mode.
; NOTES:
;   Sets draw mode to 5, draws, then restores draw mode to 1.
;------------------------------------------------------------------------------
_ED_RedrawCursorChar:
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #5,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    BSR.W   _ED_DrawCursorChar

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    RTS

;!======