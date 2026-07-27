    XDEF    _ED_EnterTextEditMode


;------------------------------------------------------------------------------
; FUNC: _ED_EnterTextEditMode   (Enter text edit modeuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0
; CALLS:
;   _ED_DrawAdEditingScreen, _ED_RedrawAllRows, _ED_RedrawCursorChar, _ED_DrawCurrentColorIndicator
; READS:
;   _ED_EditCursorOffset, _ED_EditBufferLive
; WRITES:
;   _ED_MenuStateId
; DESC:
;   Switches to mode 4 and refreshes the edit display for the current entry.
; NOTES:
;   Uses _ED_EditBufferLive + _ED_EditCursorOffset to fetch the current byte for display.
;------------------------------------------------------------------------------
_ED_EnterTextEditMode:
    MOVE.B  #$4,_ED_MenuStateId
    JSR     _ED_DrawAdEditingScreen(PC)

    JSR     _ED_RedrawAllRows(PC)

    JSR     _ED_RedrawCursorChar(PC)

    LEA     _ED_EditBufferLive,A0
    ADDA.L  _ED_EditCursorOffset,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    JSR     _ED_DrawCurrentColorIndicator(PC)

    ADDQ.W  #4,A7
    RTS

;!======