;------------------------------------------------------------------------------
; FUNC: GROUP_AJ_JMPTBL_STRING_FindSubstring   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STRING_FindSubstring
; DESC:
;   Jump stub to STRING_FindSubstring.
;------------------------------------------------------------------------------
GROUP_AJ_JMPTBL_STRING_FindSubstring:
    JMP     STRING_FindSubstring

;------------------------------------------------------------------------------
; FUNC: GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   FORMAT_RawDoFmtWithScratchBuffer
; DESC:
;   Jump stub to FORMAT_RawDoFmtWithScratchBuffer.
;------------------------------------------------------------------------------
GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer:
    JMP     FORMAT_RawDoFmtWithScratchBuffer

;------------------------------------------------------------------------------
; FUNC: GROUP_AJ_JMPTBL_MATH_DivU32   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   MATH_DivU32
; DESC:
;   Jump stub to MATH_DivU32.
;------------------------------------------------------------------------------
GROUP_AJ_JMPTBL_MATH_DivU32:
    JMP     MATH_DivU32

;------------------------------------------------------------------------------
; FUNC: GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   PARSEINI_WriteRtcFromGlobals
; DESC:
;   Jump stub to PARSEINI_WriteRtcFromGlobals.
;------------------------------------------------------------------------------
GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals:
    JMP     PARSEINI_WriteRtcFromGlobals

;------------------------------------------------------------------------------
; FUNC: GROUP_AJ_JMPTBL_MATH_Mulu32   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
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
