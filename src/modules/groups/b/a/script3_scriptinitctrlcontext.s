    XDEF    _SCRIPT_InitCtrlContext

;------------------------------------------------------------------------------
; FUNC: _SCRIPT_InitCtrlContext   (InitCtrlContext)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0/D7/A3
; CALLS:
;   _SCRIPT_SetCtrlContextMode
; READS:
;   _SCRIPT_CTRL_CONTEXT (control context base)
; WRITES:
;   _SCRIPT_CTRL_CONTEXT (initializes context)
; DESC:
;   Initializes the script CTRL/control context block with a mode flag of 1.
; NOTES:
;   Wrapper around _SCRIPT_SetCtrlContextMode which fully clears/initializes the context struct.
;------------------------------------------------------------------------------
_SCRIPT_InitCtrlContext:
    PEA     1.W
    PEA     _SCRIPT_CTRL_CONTEXT
    BSR.W   _SCRIPT_SetCtrlContextMode

    ADDQ.W  #8,A7
    RTS

;!======
