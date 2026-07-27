    XDEF    _SCRIPT_ResetCtrlContextAndClearStatusLine


;------------------------------------------------------------------------------
; FUNC: _SCRIPT_ResetCtrlContextAndClearStatusLine   (ResetCtrlContextAndClearStatusLine)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   A7/D0
; CALLS:
;   _SCRIPT_ResetCtrlContext, _TEXTDISP_HandleScriptCommand
; READS:
;   _SCRIPT_CTRL_CONTEXT
; WRITES:
;   _SCRIPT_CTRL_CONTEXT (via _SCRIPT_ResetCtrlContext)
; DESC:
;   Clears the status line via _TEXTDISP_HandleScriptCommand and reinitializes
;   _SCRIPT_CTRL_CONTEXT.
;------------------------------------------------------------------------------
_SCRIPT_ResetCtrlContextAndClearStatusLine:
    CLR.L   -(A7)
    MOVEQ   #0,D0
    NOT.B   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _TEXTDISP_HandleScriptCommand(PC)

    PEA     _SCRIPT_CTRL_CONTEXT
    BSR.W   _SCRIPT_ResetCtrlContext

    LEA     16(A7),A7
    RTS

;!======