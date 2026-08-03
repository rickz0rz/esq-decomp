    XDEF    _TLIBA1_JMPTBL_CLEANUP_FormatClockFormatEntry
    XDEF    _TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode
    XDEF    _TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow
    XDEF    _TLIBA1_JMPTBL_DISPLIB_FindPreviousValidEntryIndex
    XDEF    _TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow
    XDEF    _TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode
    XDEF    _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode
    XDEF    _TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold
    XDEF    _TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble
    XDEF    _TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble


    ; Alignment
    ALIGN_WORD

;!======

;------------------------------------------------------------------------------
; FUNC: _TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   _COI_GetAnimFieldPointerByMode
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _COI_GetAnimFieldPointerByMode.
;------------------------------------------------------------------------------
_TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode:
    JMP     _COI_GetAnimFieldPointerByMode

;------------------------------------------------------------------------------
; FUNC: _TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   _ESQDISP_GetEntryAuxPointerByMode
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _ESQDISP_GetEntryAuxPointerByMode.
;------------------------------------------------------------------------------
_TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode:
    JMP     _ESQDISP_GetEntryAuxPointerByMode

;------------------------------------------------------------------------------
; FUNC: _TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   _LADFUNC_GetPackedPenLowNibble
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _LADFUNC_GetPackedPenLowNibble.
;------------------------------------------------------------------------------
_TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble:
    JMP     _LADFUNC_GetPackedPenLowNibble

;------------------------------------------------------------------------------
; FUNC: _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   _ESQDISP_GetEntryPointerByMode
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _ESQDISP_GetEntryPointerByMode.
;------------------------------------------------------------------------------
_TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode:
    JMP     _ESQDISP_GetEntryPointerByMode

;------------------------------------------------------------------------------
; FUNC: _TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   _COI_TestEntryWithinTimeWindow
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _COI_TestEntryWithinTimeWindow.
;------------------------------------------------------------------------------
_TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow:
    JMP     _COI_TestEntryWithinTimeWindow

;------------------------------------------------------------------------------
; FUNC: _TLIBA1_JMPTBL_CLEANUP_FormatClockFormatEntry   (JumpStub_CLEANUP_FormatClockFormatEntry)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   _CLEANUP_FormatClockFormatEntry
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _CLEANUP_FormatClockFormatEntry.
;------------------------------------------------------------------------------
_TLIBA1_JMPTBL_CLEANUP_FormatClockFormatEntry:
    JMP     _CLEANUP_FormatClockFormatEntry

;------------------------------------------------------------------------------
; FUNC: _TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   _ESQDISP_ComputeScheduleOffsetForRow
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _ESQDISP_ComputeScheduleOffsetForRow.
;------------------------------------------------------------------------------
_TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow:
    JMP     _ESQDISP_ComputeScheduleOffsetForRow

;------------------------------------------------------------------------------
; FUNC: _TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold   (JumpStub_ESQ_FindSubstringCaseFold)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   _ESQ_FindSubstringCaseFold
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _ESQ_FindSubstringCaseFold.
;------------------------------------------------------------------------------
_TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold:
    JMP     _ESQ_FindSubstringCaseFold

;------------------------------------------------------------------------------
; FUNC: _TLIBA1_JMPTBL_DISPLIB_FindPreviousValidEntryIndex   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   _DISPLIB_FindPreviousValidEntryIndex
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _DISPLIB_FindPreviousValidEntryIndex.
;------------------------------------------------------------------------------
_TLIBA1_JMPTBL_DISPLIB_FindPreviousValidEntryIndex:
    JMP     _DISPLIB_FindPreviousValidEntryIndex

;------------------------------------------------------------------------------
; FUNC: _TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   _LADFUNC_GetPackedPenHighNibble
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _LADFUNC_GetPackedPenHighNibble.
;------------------------------------------------------------------------------
_TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble:
    JMP     _LADFUNC_GetPackedPenHighNibble

;!======

    ; Alignment
    RTS
    DC.W    $0000
