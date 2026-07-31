    XDEF    _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop
    XDEF    _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight
    XDEF    _NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame
    XDEF    _NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel
    XDEF    _NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel
    XDEF    _NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair
    XDEF    _NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry
    XDEF    _NEWGRID2_JMPTBL_CLEANUP_TestEntryFlagYAndBit1
    XDEF    _NEWGRID2_JMPTBL_CLEANUP_UpdateEntryFlagBytes
    XDEF    _NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState
    XDEF    _NEWGRID2_JMPTBL_COI_RenderClockFormatEntryVariant
    XDEF    _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer
    XDEF    _NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex
    XDEF    _NEWGRID2_JMPTBL_DISPTEXT_BuildLayoutForSource
    XDEF    _NEWGRID2_JMPTBL_DISPTEXT_ComputeMarkerWidths
    XDEF    _NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount
    XDEF    _NEWGRID2_JMPTBL_DISPTEXT_GetTotalLineCount
    XDEF    _NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines
    XDEF    _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast
    XDEF    _NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected
    XDEF    _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer
    XDEF    _NEWGRID2_JMPTBL_DISPTEXT_LayoutSourceToLines
    XDEF    _NEWGRID2_JMPTBL_DISPTEXT_MeasureCurrentLineLength
    XDEF    _NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine
    XDEF    _NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex
    XDEF    _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams
    XDEF    _NEWGRID2_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow
    XDEF    _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode
    XDEF    _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode
    XDEF    _NEWGRID2_JMPTBL_ESQDISP_TestEntryBits0And2
    XDEF    _NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex
    XDEF    _NEWGRID2_JMPTBL_ESQ_TestBit1Based
    XDEF    _NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt
    XDEF    _NEWGRID2_JMPTBL_STRING_AppendN
    XDEF    _NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex
    XDEF    _NEWGRID2_JMPTBL_STR_SkipClass3Chars


; Jump-stub block:
; These entries preserve legacy call-table layout and tail-call target helpers.
; Arguments/return values pass through unchanged unless noted in each header.

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   COI_SelectAnimFieldPointer
; DESC:
;   Jump table entry that forwards to COI_SelectAnimFieldPointer.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer:
    JMP     COI_SelectAnimFieldPointer

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _DISPTEXT_SetCurrentLineIndex
; DESC:
;   Jump table entry that forwards to _DISPTEXT_SetCurrentLineIndex.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex:
    JMP     _DISPTEXT_SetCurrentLineIndex

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _DISPTEXT_LayoutAndAppendToBuffer
; DESC:
;   Jump table entry that forwards to _DISPTEXT_LayoutAndAppendToBuffer.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer:
    JMP     _DISPTEXT_LayoutAndAppendToBuffer

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_DISPTEXT_GetTotalLineCount   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   _DISPTEXT_GetTotalLineCount
; DESC:
;   Jump table entry that forwards to _DISPTEXT_GetTotalLineCount.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_DISPTEXT_GetTotalLineCount:
    JMP     _DISPTEXT_GetTotalLineCount

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _TLIBA_FindFirstWildcardMatchIndex
; DESC:
;   Jump table entry that forwards to _TLIBA_FindFirstWildcardMatchIndex.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex:
    BRA.W   _TLIBA_FindFirstWildcardMatchIndex

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_DISPTEXT_BuildLayoutForSource   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   _DISPTEXT_BuildLayoutForSource
; DESC:
;   Jump table entry that forwards to _DISPTEXT_BuildLayoutForSource.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_DISPTEXT_BuildLayoutForSource:
    JMP     _DISPTEXT_BuildLayoutForSource

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _BEVEL_DrawBevelFrameWithTopRight
; DESC:
;   Jump table entry that forwards to _BEVEL_DrawBevelFrameWithTopRight.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight:
    JMP     _BEVEL_DrawBevelFrameWithTopRight

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _ESQDISP_GetEntryAuxPointerByMode
; DESC:
;   Jump table entry that forwards to _ESQDISP_GetEntryAuxPointerByMode.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode:
    JMP     _ESQDISP_GetEntryAuxPointerByMode

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _BEVEL_DrawVerticalBevel
; DESC:
;   Jump table entry that forwards to _BEVEL_DrawVerticalBevel.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel:
    JMP     _BEVEL_DrawVerticalBevel

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_DISPTEXT_LayoutSourceToLines   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _DISPTEXT_LayoutSourceToLines
; DESC:
;   Jump table entry that forwards to _DISPTEXT_LayoutSourceToLines.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_DISPTEXT_LayoutSourceToLines:
    JMP     _DISPTEXT_LayoutSourceToLines

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_CLEANUP_UpdateEntryFlagBytes   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _CLEANUP_UpdateEntryFlagBytes
; DESC:
;   Jump table entry that forwards to _CLEANUP_UpdateEntryFlagBytes.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_CLEANUP_UpdateEntryFlagBytes:
    JMP     _CLEANUP_UpdateEntryFlagBytes

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_COI_RenderClockFormatEntryVariant   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _COI_RenderClockFormatEntryVariant
; DESC:
;   Jump table entry that forwards to _COI_RenderClockFormatEntryVariant.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_COI_RenderClockFormatEntryVariant:
    JMP     _COI_RenderClockFormatEntryVariant

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_ESQDISP_TestEntryBits0And2   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _ESQDISP_TestEntryBits0And2
; DESC:
;   Jump table entry that forwards to _ESQDISP_TestEntryBits0And2.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_ESQDISP_TestEntryBits0And2:
    JMP     _ESQDISP_TestEntryBits0And2

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _DISPTEXT_ComputeVisibleLineCount
; DESC:
;   Jump table entry that forwards to _DISPTEXT_ComputeVisibleLineCount.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount:
    JMP     _DISPTEXT_ComputeVisibleLineCount

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _ESQDISP_GetEntryPointerByMode
; DESC:
;   Jump table entry that forwards to _ESQDISP_GetEntryPointerByMode.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode:
    JMP     _ESQDISP_GetEntryPointerByMode

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _DISPTEXT_RenderCurrentLine
; DESC:
;   Jump table entry that forwards to _DISPTEXT_RenderCurrentLine.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine:
    JMP     _DISPTEXT_RenderCurrentLine

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _COI_ProcessEntrySelectionState
; DESC:
;   Jump table entry that forwards to _COI_ProcessEntrySelectionState.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState:
    JMP     _COI_ProcessEntrySelectionState

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _CLEANUP_FormatClockFormatEntry
; DESC:
;   Jump table entry that forwards to _CLEANUP_FormatClockFormatEntry.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry:
    JMP     _CLEANUP_FormatClockFormatEntry

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _BEVEL_DrawBevelFrameWithTop
; DESC:
;   Jump table entry that forwards to _BEVEL_DrawBevelFrameWithTop.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop:
    JMP     _BEVEL_DrawBevelFrameWithTop

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _ESQ_GetHalfHourSlotIndex
; DESC:
;   Jump table entry that forwards to _ESQ_GetHalfHourSlotIndex.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex:
    JMP     _ESQ_GetHalfHourSlotIndex

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_STR_SkipClass3Chars   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _STR_SkipClass3Chars
; DESC:
;   Jump table entry that forwards to _STR_SkipClass3Chars.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_STR_SkipClass3Chars:
    JMP     _STR_SkipClass3Chars

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_STRING_AppendN   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   STRING_AppendN
; DESC:
;   Jump table entry that forwards to STRING_AppendN.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_STRING_AppendN:
    JMP     STRING_AppendN

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _ESQDISP_ComputeScheduleOffsetForRow
; DESC:
;   Jump table entry that forwards to _ESQDISP_ComputeScheduleOffsetForRow.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow:
    JMP     _ESQDISP_ComputeScheduleOffsetForRow

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _PARSE_ReadSignedLongSkipClass3_Alt
; DESC:
;   Jump table entry that forwards to _PARSE_ReadSignedLongSkipClass3_Alt.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt:
    JMP     _PARSE_ReadSignedLongSkipClass3_Alt

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_CLEANUP_TestEntryFlagYAndBit1   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _CLEANUP_TestEntryFlagYAndBit1
; DESC:
;   Jump table entry that forwards to _CLEANUP_TestEntryFlagYAndBit1.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_CLEANUP_TestEntryFlagYAndBit1:
    JMP     _CLEANUP_TestEntryFlagYAndBit1

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _DISPTEXT_IsCurrentLineLast
; DESC:
;   Jump table entry that forwards to _DISPTEXT_IsCurrentLineLast.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast:
    JMP     _DISPTEXT_IsCurrentLineLast

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _DISPTEXT_IsLastLineSelected
; DESC:
;   Jump table entry that forwards to _DISPTEXT_IsLastLineSelected.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected:
    JMP     _DISPTEXT_IsLastLineSelected

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _BEVEL_DrawBeveledFrame
; DESC:
;   Jump table entry that forwards to _BEVEL_DrawBeveledFrame.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame:
    JMP     _BEVEL_DrawBeveledFrame

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   DISPLIB_FindPreviousValidEntryIndex
; DESC:
;   Jump table entry that forwards to DISPLIB_FindPreviousValidEntryIndex.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex:
    JMP     DISPLIB_FindPreviousValidEntryIndex

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_DISPTEXT_ComputeMarkerWidths   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _DISPTEXT_ComputeMarkerWidths
; DESC:
;   Jump table entry that forwards to _DISPTEXT_ComputeMarkerWidths.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_DISPTEXT_ComputeMarkerWidths:
    JMP     _DISPTEXT_ComputeMarkerWidths

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_ESQ_TestBit1Based   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _ESQ_TestBit1Based
; DESC:
;   Jump table entry that forwards to _ESQ_TestBit1Based.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_ESQ_TestBit1Based:
    JMP     _ESQ_TestBit1Based

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _BEVEL_DrawVerticalBevelPair
; DESC:
;   Jump table entry that forwards to _BEVEL_DrawVerticalBevelPair.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair:
    JMP     _BEVEL_DrawVerticalBevelPair

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_DISPTEXT_MeasureCurrentLineLength   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _DISPTEXT_MeasureCurrentLineLength
; DESC:
;   Jump table entry that forwards to _DISPTEXT_MeasureCurrentLineLength.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_DISPTEXT_MeasureCurrentLineLength:
    JMP     _DISPTEXT_MeasureCurrentLineLength

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _DISPTEXT_SetLayoutParams
; DESC:
;   Jump table entry that forwards to _DISPTEXT_SetLayoutParams.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams:
    JMP     _DISPTEXT_SetLayoutParams

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _DISPTEXT_HasMultipleLines
; DESC:
;   Jump table entry that forwards to _DISPTEXT_HasMultipleLines.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines:
    JMP     _DISPTEXT_HasMultipleLines

;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel   (Jump stub)
; ARGS:
;   Forwarded unchanged to target routine.
; RET:
;   D0: passthrough from target routine
; CLOBBERS:
;   As per target routine
; CALLS:
;   _BEVEL_DrawHorizontalBevel
; DESC:
;   Jump table entry that forwards to _BEVEL_DrawHorizontalBevel.
;------------------------------------------------------------------------------
_NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel:
    JMP     _BEVEL_DrawHorizontalBevel

;!======

    RTS

;!======

    ; Alignment
    ALIGN_WORD
