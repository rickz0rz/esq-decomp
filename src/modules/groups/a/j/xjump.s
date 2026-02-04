;------------------------------------------------------------------------------
; FUNC: DST_JMPTBL_OpenFileMaybe   (Jump stub)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   STRING_FindSubstring
; DESC:
;   Jump stub to STRING_FindSubstring.
;------------------------------------------------------------------------------
DST_JMPTBL_OpenFileMaybe:
LAB_066C:
    JMP     STRING_FindSubstring

;------------------------------------------------------------------------------
; FUNC: DST_JMPTBL_FormatToBuffer   (Jump stub)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   FORMAT_RawDoFmtWithScratchBuffer
; DESC:
;   Jump stub to FORMAT_RawDoFmtWithScratchBuffer.
;------------------------------------------------------------------------------
DST_JMPTBL_FormatToBuffer:
LAB_066D:
    JMP     FORMAT_RawDoFmtWithScratchBuffer

;------------------------------------------------------------------------------
; FUNC: DST_JMPTBL_DivMod7   (Jump stub)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   MATH_DivU32
; DESC:
;   Jump stub to MATH_DivU32.
;------------------------------------------------------------------------------
DST_JMPTBL_DivMod7:
LAB_066E:
    JMP     MATH_DivU32

;------------------------------------------------------------------------------
; FUNC: DST_JMPTBL_Call_146E   (Jump stub)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   LAB_146E
; DESC:
;   Jump stub to LAB_146E.
;------------------------------------------------------------------------------
DST_JMPTBL_Call_146E:
LAB_066F:
    JMP     LAB_146E

;------------------------------------------------------------------------------
; FUNC: GROUP_AJ_JMPTBL_MATH_Mulu32   (Jump stub)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   MATH_Mulu32
; DESC:
;   Jump stub to MATH_Mulu32.
;------------------------------------------------------------------------------
GROUP_AJ_JMPTBL_MATH_Mulu32:
    JMP     MATH_Mulu32

;!======

    ; Alignment
    MOVEQ   #97,D0