    XDEF    _P_TYPE_JMPTBL_STRING_FindSubstring


;------------------------------------------------------------------------------
; FUNC: _P_TYPE_JMPTBL_STRING_FindSubstring   (Routine at _P_TYPE_JMPTBL_STRING_FindSubstring)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   _STRING_FindSubstring
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_P_TYPE_JMPTBL_STRING_FindSubstring:
    JMP     _STRING_FindSubstring

;!======

    ; Alignment
    MOVEQ   #97,D0
