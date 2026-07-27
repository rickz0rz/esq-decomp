    XDEF    _GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold
    XDEF    _GROUP_AS_JMPTBL_STR_FindCharPtr

;------------------------------------------------------------------------------
; FUNC: _GROUP_AS_JMPTBL_STR_FindCharPtr   (JumpStub_STR_FindCharPtr)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   _STR_FindCharPtr
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _STR_FindCharPtr.
;------------------------------------------------------------------------------
_GROUP_AS_JMPTBL_STR_FindCharPtr:
    JMP     _STR_FindCharPtr

;------------------------------------------------------------------------------
; FUNC: _GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold   (JumpStub_ESQ_FindSubstringCaseFold)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   ESQ_FindSubstringCaseFold
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ESQ_FindSubstringCaseFold.
;------------------------------------------------------------------------------
_GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold:
    JMP     ESQ_FindSubstringCaseFold
