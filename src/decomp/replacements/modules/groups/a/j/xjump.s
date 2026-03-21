;------------------------------------------------------------------------------
; DECOMP TARGET direct hybrid replacement
; SOURCE: modules/groups/a/j/xjump.s
; PURPOSE:
;   Carry the Group AJ wrapper module body directly now that the maintained
;   SAS/C compare lanes for its five wrapper exports are green in this
;   checkout.
;------------------------------------------------------------------------------

    XDEF    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
    XDEF    GROUP_AJ_JMPTBL_MATH_DivU32
    XDEF    GROUP_AJ_JMPTBL_MATH_Mulu32
    XDEF    GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals
    XDEF    GROUP_AJ_JMPTBL_STRING_FindSubstring

;------------------------------------------------------------------------------
; FUNC: GROUP_AJ_JMPTBL_STRING_FindSubstring   (JumpStub_STRING_FindSubstring)
; ARGS:
;   (none observed)
; RET:
;   D0: result pointer
; CLOBBERS:
;   (none observed)
; CALLS:
;   STRING_FindSubstring
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to STRING_FindSubstring.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AJ_JMPTBL_STRING_FindSubstring:
    JMP     STRING_FindSubstring

;------------------------------------------------------------------------------
; FUNC: GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer   (JumpStub_FORMAT_RawDoFmtWithScratchBuffer)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status ??
; CLOBBERS:
;   D0 ??
; CALLS:
;   FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to FORMAT_RawDoFmtWithScratchBuffer.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer:
    JMP     FORMAT_RawDoFmtWithScratchBuffer

;------------------------------------------------------------------------------
; FUNC: GROUP_AJ_JMPTBL_MATH_DivU32   (JumpStub_MATH_DivU32)
; ARGS:
;   (none observed)
; RET:
;   D0: unsigned quotient
; CLOBBERS:
;   D0
; CALLS:
;   MATH_DivU32
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to MATH_DivU32.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AJ_JMPTBL_MATH_DivU32:
    JMP     MATH_DivU32

;------------------------------------------------------------------------------
; FUNC: GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals   (JumpStub_PARSEINI_WriteRtcFromGlobals)
; ARGS:
;   (none observed)
; RET:
;   (none)
; CLOBBERS:
;   (none observed)
; CALLS:
;   PARSEINI_WriteRtcFromGlobals
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to PARSEINI_WriteRtcFromGlobals.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals:
    JMP     PARSEINI_WriteRtcFromGlobals

;------------------------------------------------------------------------------
; FUNC: GROUP_AJ_JMPTBL_MATH_Mulu32   (JumpStub_MATH_Mulu32)
; ARGS:
;   (none observed)
; RET:
;   D0: product
; CLOBBERS:
;   D0
; CALLS:
;   MATH_Mulu32
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to MATH_Mulu32.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AJ_JMPTBL_MATH_Mulu32:
    JMP     MATH_Mulu32

;!======

    ; Alignment
    MOVEQ   #97,D0
    RTS
    ALIGN_WORD
