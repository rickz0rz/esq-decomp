    XDEF    GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold
    XDEF    GROUP_AS_JMPTBL_STR_FindCharPtr

;------------------------------------------------------------------------------
; FUNC: GROUP_AS_JMPTBL_STR_FindCharPtr   (JumpStub_STR_FindCharPtr)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   STR_FindCharPtr
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to STR_FindCharPtr.
;------------------------------------------------------------------------------
GROUP_AS_JMPTBL_STR_FindCharPtr:
    JMP     STR_FindCharPtr

;------------------------------------------------------------------------------
; FUNC: GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold   (JumpStub_ESQ_FindSubstringCaseFold)
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
GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold:
    JMP     ESQ_FindSubstringCaseFold
