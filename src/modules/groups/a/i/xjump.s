    XDEF    _GROUP_AI_JMPTBL_FORMAT_FormatToBuffer2
    XDEF    GROUP_AI_JMPTBL_NEWGRID_SetSelectionMarkers
    XDEF    _GROUP_AI_JMPTBL_STRING_AppendAtNull
    XDEF    GROUP_AI_JMPTBL_TLIBA1_DrawTextWithInsetSegments
    XDEF    GROUP_AI_JMPTBL_STR_CopyUntilAnyDelimN
    XDEF    _GROUP_AI_JMPTBL_STR_FindCharPtr
    XDEF    GROUP_AI_JMPTBL_STR_SkipClass3Chars

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
;   _NEWGRID_SetSelectionMarkers
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to _NEWGRID_SetSelectionMarkers.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AI_JMPTBL_NEWGRID_SetSelectionMarkers:
    JMP     _NEWGRID_SetSelectionMarkers

;------------------------------------------------------------------------------
; FUNC: _GROUP_AI_JMPTBL_STR_FindCharPtr   (JumpStub_STR_FindCharPtr)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _STR_FindCharPtr
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to _STR_FindCharPtr.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AI_JMPTBL_STR_FindCharPtr:
    JMP     _STR_FindCharPtr

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
; FUNC: _GROUP_AI_JMPTBL_FORMAT_FormatToBuffer2   (JumpStub_FORMAT_FormatToBuffer2)
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
_GROUP_AI_JMPTBL_FORMAT_FormatToBuffer2:
    JMP     FORMAT_FormatToBuffer2

;------------------------------------------------------------------------------
; FUNC: GROUP_AI_JMPTBL_STR_SkipClass3Chars   (JumpStub_STR_SkipClass3Chars)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _STR_SkipClass3Chars
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to _STR_SkipClass3Chars.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AI_JMPTBL_STR_SkipClass3Chars:
    JMP     _STR_SkipClass3Chars

;------------------------------------------------------------------------------
; FUNC: _GROUP_AI_JMPTBL_STRING_AppendAtNull   (JumpStub_STRING_AppendAtNull)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _STRING_AppendAtNull
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to _STRING_AppendAtNull.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AI_JMPTBL_STRING_AppendAtNull:
    JMP     _STRING_AppendAtNull

;------------------------------------------------------------------------------
; FUNC: GROUP_AI_JMPTBL_STR_CopyUntilAnyDelimN   (JumpStub_STR_CopyUntilAnyDelimN)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   STR_CopyUntilAnyDelimN
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to STR_CopyUntilAnyDelimN.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AI_JMPTBL_STR_CopyUntilAnyDelimN:
    JMP     STR_CopyUntilAnyDelimN

    ; Alignment?
    MOVEQ   #97,D0
