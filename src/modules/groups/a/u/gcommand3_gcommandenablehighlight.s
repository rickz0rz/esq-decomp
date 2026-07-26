    XDEF    _GCOMMAND_EnableHighlight

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_EnableHighlight   (Routine at _GCOMMAND_EnableHighlight)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _GCOMMAND_ApplyHighlightFlag
; READS:
;   (none observed)
; WRITES:
;   _GCOMMAND_HighlightFlag
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_GCOMMAND_EnableHighlight:
    MOVE.W  #1,_GCOMMAND_HighlightFlag
    BSR.W   _GCOMMAND_ApplyHighlightFlag

    RTS

;!======
