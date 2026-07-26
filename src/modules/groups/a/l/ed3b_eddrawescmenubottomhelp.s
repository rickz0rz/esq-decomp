    XDEF    _ED_DrawESCMenuBottomHelp

;------------------------------------------------------------------------------
; FUNC: _ED_DrawESCMenuBottomHelp
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0 uncertain
; CALLS:
;   _ED_DrawBottomHelpBarBackground, _ED_DrawESCMenuHelpText
; READS:
;   (none)
; WRITES:
;   _ED_MenuStateId
; DESC:
;   Draws the bottom help panel for the ESC menu.
; NOTES:
;   Sets _ED_MenuStateId to 1 before drawing.
;------------------------------------------------------------------------------
_ED_DrawESCMenuBottomHelp:
    MOVE.B  #$1,_ED_MenuStateId
    BSR.W   _ED_DrawBottomHelpBarBackground

    ; this might actually end up drawing all the text.
    BSR.W   _ED_DrawESCMenuHelpText

    RTS

;!======
