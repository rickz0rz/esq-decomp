    XDEF    _DISPLIB_ResetTextBufferAndLineTables


;------------------------------------------------------------------------------
; FUNC: _DISPLIB_ResetTextBufferAndLineTables   (Routine at _DISPLIB_ResetTextBufferAndLineTables)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7
; CALLS:
;   _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   _DISPTEXT_TextBufferPtr
; WRITES:
;   _DISPTEXT_TextBufferPtr
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_DISPLIB_ResetTextBufferAndLineTables:
    MOVE.L  _DISPTEXT_TextBufferPtr,-(A7)
    CLR.L   -(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,_DISPTEXT_TextBufferPtr
    BSR.S   _DISPLIB_ResetLineTables

    ADDQ.W  #8,A7
    RTS

;!======