    XDEF    GROUP_AI_JMPTBL_FORMAT_FormatToBuffer2
    XDEF    GROUP_AI_JMPTBL_NEWGRID_SetSelectionMarkers
    XDEF    GROUP_AI_JMPTBL_STRING_AppendAtNull
    XDEF    GROUP_AI_JMPTBL_TLIBA1_DrawTextWithInsetSegments
    XDEF    GROUP_AI_JMPTBL_UNKNOWN7_CopyUntilDelimiter
    XDEF    GROUP_AI_JMPTBL_STR_FindCharPtr
    XDEF    GROUP_AI_JMPTBL_UNKNOWN7_SkipCharClass3

;!======
;------------------------------------------------------------------------------
; FUNC: GROUP_AI_JMPTBL_NEWGRID_SetSelectionMarkers   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   NEWGRID_SetSelectionMarkers
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to NEWGRID_SetSelectionMarkers.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AI_JMPTBL_NEWGRID_SetSelectionMarkers:
    JMP     NEWGRID_SetSelectionMarkers

;------------------------------------------------------------------------------
; FUNC: GROUP_AI_JMPTBL_STR_FindCharPtr   (JumpStub_STR_FindCharPtr)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STR_FindCharPtr
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to STR_FindCharPtr.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AI_JMPTBL_STR_FindCharPtr:
    JMP     STR_FindCharPtr

;------------------------------------------------------------------------------
; FUNC: GROUP_AI_JMPTBL_TLIBA1_DrawTextWithInsetSegments   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   TLIBA1_DrawTextWithInsetSegments
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to TLIBA1_DrawTextWithInsetSegments.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AI_JMPTBL_TLIBA1_DrawTextWithInsetSegments:
    JMP     TLIBA1_DrawTextWithInsetSegments

;------------------------------------------------------------------------------
; FUNC: GROUP_AI_JMPTBL_FORMAT_FormatToBuffer2   (JumpStub_FORMAT_FormatToBuffer2)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   FORMAT_FormatToBuffer2
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to FORMAT_FormatToBuffer2.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AI_JMPTBL_FORMAT_FormatToBuffer2:
    JMP     FORMAT_FormatToBuffer2

;------------------------------------------------------------------------------
; FUNC: GROUP_AI_JMPTBL_UNKNOWN7_SkipCharClass3   (JumpStub_UNKNOWN7_SkipCharClass3)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   UNKNOWN7_SkipCharClass3
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to UNKNOWN7_SkipCharClass3.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AI_JMPTBL_UNKNOWN7_SkipCharClass3:
    JMP     UNKNOWN7_SkipCharClass3

;------------------------------------------------------------------------------
; FUNC: GROUP_AI_JMPTBL_STRING_AppendAtNull   (JumpStub_STRING_AppendAtNull)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STRING_AppendAtNull
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to STRING_AppendAtNull.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AI_JMPTBL_STRING_AppendAtNull:
    JMP     STRING_AppendAtNull

;------------------------------------------------------------------------------
; FUNC: GROUP_AI_JMPTBL_UNKNOWN7_CopyUntilDelimiter   (JumpStub_UNKNOWN7_CopyUntilDelimiter)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   UNKNOWN7_CopyUntilDelimiter
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to UNKNOWN7_CopyUntilDelimiter.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AI_JMPTBL_UNKNOWN7_CopyUntilDelimiter:
    JMP     UNKNOWN7_CopyUntilDelimiter

    ; Alignment?
    MOVEQ   #97,D0
