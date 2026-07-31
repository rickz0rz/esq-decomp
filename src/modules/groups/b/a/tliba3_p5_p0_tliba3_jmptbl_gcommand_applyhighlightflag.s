    XDEF    _TLIBA3_JMPTBL_GCOMMAND_ApplyHighlightFlag


;------------------------------------------------------------------------------
; FUNC: _TLIBA3_JMPTBL_GCOMMAND_ApplyHighlightFlag   (_TLIBA3_JMPTBL_GCOMMAND_ApplyHighlightFlag)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   _GCOMMAND_ApplyHighlightFlag
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_TLIBA3_JMPTBL_GCOMMAND_ApplyHighlightFlag:
    JMP     _GCOMMAND_ApplyHighlightFlag

;!======