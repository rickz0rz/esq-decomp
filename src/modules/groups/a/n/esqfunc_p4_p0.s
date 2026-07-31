    XDEF    _ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner
    XDEF    _ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts
    XDEF    _ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths
    XDEF    _ESQFUNC_JMPTBL_ESQ_ClampBannerCharRange
    XDEF    _ESQFUNC_JMPTBL_ESQ_GetHalfHourSlotIndex
    XDEF    _ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt
    XDEF    _ESQFUNC_JMPTBL_ESQ_PollCtrlInput
    XDEF    _ESQFUNC_JMPTBL_ESQ_TickGlobalCounters
    XDEF    _ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit
    XDEF    _ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState
    XDEF    _ESQFUNC_JMPTBL_LOCAVAIL_RebuildFilterStateFromCurrentGroup
    XDEF    _ESQFUNC_JMPTBL_LOCAVAIL_SyncSecondaryFilterForCurrentGroup
    XDEF    _ESQFUNC_JMPTBL_PARSEINI_ComputeHTCMaxValues
    XDEF    _ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange
    XDEF    _ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData
    XDEF    _ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax
    XDEF    _ESQFUNC_JMPTBL_P_TYPE_EnsureSecondaryList
    XDEF    _ESQFUNC_JMPTBL_P_TYPE_PromoteSecondaryList
    XDEF    _ESQFUNC_JMPTBL_SCRIPT_GetCtrlLineFlag
    XDEF    _ESQFUNC_JMPTBL_SCRIPT_HandleSerialCtrlCmd
    XDEF    _ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit3Flag
    XDEF    _ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask
    XDEF    _ESQFUNC_JMPTBL_STRING_CopyPadNul
    XDEF    _ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh
    XDEF    _ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode
    XDEF    _ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState
    XDEF    _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines



;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _TEXTDISP_SetRastForMode
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode:
    JMP     _TEXTDISP_SetRastForMode

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_P_TYPE_PromoteSecondaryList   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _P_TYPE_PromoteSecondaryList
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_P_TYPE_PromoteSecondaryList:
    JMP     _P_TYPE_PromoteSecondaryList

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DISKIO_ProbeDrivesAndAssignPaths
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths:
    JMP     _DISKIO_ProbeDrivesAndAssignPaths

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _PARSEINI_UpdateCtrlHDeltaMax
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax:
    JMP     _PARSEINI_UpdateCtrlHDeltaMax

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_ESQ_ClampBannerCharRange   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQ_ClampBannerCharRange
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_ESQ_ClampBannerCharRange:
    JMP     _ESQ_ClampBannerCharRange

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit3Flag   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _SCRIPT_ReadHandshakeBit3Flag
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit3Flag:
    JMP     _SCRIPT_ReadHandshakeBit3Flag

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _TLIBA3_DrawCenteredWrappedTextLines
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines:
    JMP     _TLIBA3_DrawCenteredWrappedTextLines

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_SCRIPT_GetCtrlLineFlag   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _SCRIPT_GetCtrlLineFlag
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_SCRIPT_GetCtrlLineFlag:
    JMP     _SCRIPT_GetCtrlLineFlag

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_LOCAVAIL_SyncSecondaryFilterForCurrentGroup   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _LOCAVAIL_SyncSecondaryFilterForCurrentGroup
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_LOCAVAIL_SyncSecondaryFilterForCurrentGroup:
    JMP     _LOCAVAIL_SyncSecondaryFilterForCurrentGroup

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _TEXTDISP_ResetSelectionAndRefresh
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh:
    JMP     _TEXTDISP_ResetSelectionAndRefresh

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _PARSEINI_MonitorClockChange
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange:
    JMP     _PARSEINI_MonitorClockChange

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _LADFUNC_ParseHexDigit
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit:
    JMP     _LADFUNC_ParseHexDigit

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _CLEANUP_ProcessAlerts
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts:
    ; Update on-screen alerts and pending timers (cleanup module owns the UI state).
    JMP     _CLEANUP_ProcessAlerts

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_ESQ_GetHalfHourSlotIndex   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQ_GetHalfHourSlotIndex
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_ESQ_GetHalfHourSlotIndex:
    JMP     _ESQ_GetHalfHourSlotIndex

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _CLEANUP_DrawClockBanner
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner:
    JMP     _CLEANUP_DrawClockBanner

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_PARSEINI_ComputeHTCMaxValues   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _PARSEINI_ComputeHTCMaxValues
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_PARSEINI_ComputeHTCMaxValues:
    JMP     _PARSEINI_ComputeHTCMaxValues

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _LADFUNC_UpdateHighlightState
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState:
    JMP     _LADFUNC_UpdateHighlightState

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_P_TYPE_EnsureSecondaryList   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _P_TYPE_EnsureSecondaryList
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_P_TYPE_EnsureSecondaryList:
    JMP     _P_TYPE_EnsureSecondaryList

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _SCRIPT_ReadHandshakeBit5Mask
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask:
    JMP     _SCRIPT_ReadHandshakeBit5Mask

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _PARSEINI_NormalizeClockData
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData:
    JMP     _PARSEINI_NormalizeClockData

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_ESQ_TickGlobalCounters   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQ_TickGlobalCounters
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_ESQ_TickGlobalCounters:
    JMP     _ESQ_TickGlobalCounters

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_SCRIPT_HandleSerialCtrlCmd   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _SCRIPT_HandleSerialCtrlCmd
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_SCRIPT_HandleSerialCtrlCmd:
    JMP     _SCRIPT_HandleSerialCtrlCmd

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQ_HandleSerialRbfInterrupt
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt:
    JMP     _ESQ_HandleSerialRbfInterrupt

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _TEXTDISP_TickDisplayState
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState:
    JMP     _TEXTDISP_TickDisplayState

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_ESQ_PollCtrlInput   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQ_PollCtrlInput
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_ESQ_PollCtrlInput:
    JMP     _ESQ_PollCtrlInput

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_LOCAVAIL_RebuildFilterStateFromCurrentGroup   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _LOCAVAIL_RebuildFilterStateFromCurrentGroup
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_LOCAVAIL_RebuildFilterStateFromCurrentGroup:
    JMP     _LOCAVAIL_RebuildFilterStateFromCurrentGroup

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_STRING_CopyPadNul   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   _STRING_CopyPadNul
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_STRING_CopyPadNul:
    JMP     _STRING_CopyPadNul

;!======

    MOVEQ   #97,D0

;!======