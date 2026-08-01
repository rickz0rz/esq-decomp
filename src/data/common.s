    XDEF    _Global_STR_PLEASE_STANDBY_1
    XDEF    _Global_STR_ATTENTION_SYSTEM_ENGINEER_1
    XDEF    _Global_STR_REPORT_CODE_ER003
    XDEF    _Global_STR_YOU_CANNOT_RE_RUN_THE_SOFTWARE
    XDEF    _COMMON_QueryDiskSoftErrorCountScratch
    XDEF    _Global_STR_DISK_ERRORS_FORMATTED
    XDEF    _COMMON_QueryDiskUsagePercentScratch
    XDEF    _Global_STR_DISK_IS_FULL_FORMATTED
    XDEF    _CTRL_Bit4CaptureDelayCounter
    XDEF    _CTRL_Bit3CaptureDelayCounter
    XDEF    _CTRL_Bit4CapturePhase
    XDEF    CTRL_Bit4SampleSlotIndex
    XDEF    _CTRL_Bit3CapturePhase
    XDEF    _CTRL_Bit3SampleSlotIndex
    XDEF    CTRL_Bit4SampleScratch
    XDEF    _CTRL_Bit3SampleScratch
    XDEF    _HIGHLIGHT_CopperEffectSeed
    XDEF    _HIGHLIGHT_CopperEffectParamA
    XDEF    _HIGHLIGHT_CopperEffectParamB
    XDEF    _CTRL_SampleEntryCount
    XDEF    _CTRL_SampleEntryScratch
    XDEF    _HIGHLIGHT_CustomValue
    XDEF    _CLOCK_DaySlotIndexPtr
    XDEF    _CLOCK_CurrentDayOfWeekIndexPtr
    XDEF    _BANNER_ResetPendingFlag
    XDEF    _CLOCK_MinuteTrigger30MinusBase
    XDEF    _CLOCK_MinuteTrigger60MinusBase
    XDEF    _CLOCK_MinuteTriggerBaseOffsetPlus30
    XDEF    _CLOCK_MinuteTriggerBaseOffset
    XDEF    _ACCUMULATOR_Row0_CaptureValue
    XDEF    _ACCUMULATOR_Row1_CaptureValue
    XDEF    _ACCUMULATOR_Row2_CaptureValue
    XDEF    _ACCUMULATOR_Row3_CaptureValue
    XDEF    _ACCUMULATOR_Row0_Sum
    XDEF    _ACCUMULATOR_Row1_Sum
    XDEF    _ACCUMULATOR_Row2_Sum
    XDEF    _ACCUMULATOR_Row3_Sum
    XDEF    _ACCUMULATOR_Row0_SaturateFlag
    XDEF    _ACCUMULATOR_Row1_SaturateFlag
    XDEF    _ACCUMULATOR_Row2_SaturateFlag
    XDEF    _ACCUMULATOR_Row3_SaturateFlag
    XDEF    _COPPER_AnimationLane0_Countdown
    XDEF    _COPPER_AnimationLane1_Countdown
    XDEF    _COPPER_AnimationLane2_Countdown
    XDEF    _COPPER_AnimationLane3_Countdown
    XDEF    _CLOCK_MonthLengths
    XDEF    _CLOCK_HalfHourSlotLookup
    XDEF    _PARSEINI_ParsedDescriptorListHead
    XDEF    _CTASKS_PendingLogoBrushDescriptor
    XDEF    _CTASKS_PendingGAdsBrushDescriptor
    XDEF    _ESQFUNC_PwBrushDescriptorHead
    XDEF    _PARSEINI_BannerBrushResourceHead
    XDEF    _CTASKS_PendingIffBrushDescriptor
    XDEF    _WDISP_WeatherStatusBrushListHead
    XDEF    _BRUSH_SelectedNode
    XDEF    _ESQIFF_GAdsBrushListCount
    XDEF    _ESQIFF_LogoBrushListCount
    XDEF    _BRUSH_LoadInProgressFlag
    XDEF    _BRUSH_PendingAlertCode

_Global_STR_PLEASE_STANDBY_1:
    NStr    "Please Standby..."
    assert Global_STR_PLEASE_STANDBY_1_Length==_Global_STR_ATTENTION_SYSTEM_ENGINEER_1-_Global_STR_PLEASE_STANDBY_1,"Global_STR_PLEASE_STANDBY_1_Length in data-lengths.s is out of sync with the data layout"
_Global_STR_ATTENTION_SYSTEM_ENGINEER_1:
    NStr    "ATTENTION! SYSTEM ENGINEER"
_Global_STR_REPORT_CODE_ER003:
    NStr    "Report Code ER003 to TV Guide Technical Services."
_Global_STR_YOU_CANNOT_RE_RUN_THE_SOFTWARE:
    NStr2   "YOU CANNOT RE-RUN THE SOFTWARE IN THIS MANNER.  PLEASE RE-BOOT!!",TextLineFeed
_COMMON_QueryDiskSoftErrorCountScratch:
    DC.W    0
_Global_STR_DISK_ERRORS_FORMATTED:
    NStr2   "Disk Errors: %ld",TextLineFeed
_COMMON_QueryDiskUsagePercentScratch:
    DC.W    0
_Global_STR_DISK_IS_FULL_FORMATTED:
    NStr    "Disk is %ld%% full"
_CTRL_Bit4CaptureDelayCounter:
    DC.W    0
_CTRL_Bit3CaptureDelayCounter:
    DC.W    0
_CTRL_Bit4CapturePhase:
    DC.W    0
CTRL_Bit4SampleSlotIndex:
    DC.W    0
_CTRL_Bit3CapturePhase:
    DC.W    0
_CTRL_Bit3SampleSlotIndex:
    DC.W    0
CTRL_Bit4SampleScratch:
    DC.L    0,0
_CTRL_Bit3SampleScratch:
    DC.L    0,0
_HIGHLIGHT_CopperEffectSeed:
    DC.W    0
_HIGHLIGHT_CopperEffectParamA:
    DC.B    0
_HIGHLIGHT_CopperEffectParamB:
    DC.B    0
    DC.W    0
_CTRL_SampleEntryCount:
    DC.W    0
_CTRL_SampleEntryScratch:
    DC.L    0
    DC.W    0
_HIGHLIGHT_CustomValue:
    NStr    "?"
_CLOCK_DaySlotIndexPtr:
    DC.L    0
_CLOCK_CurrentDayOfWeekIndexPtr:
    DC.L    0
_BANNER_ResetPendingFlag:
    DC.L    0
_CLOCK_MinuteTrigger30MinusBase:
    DC.W    0
_CLOCK_MinuteTrigger60MinusBase:
    DC.W    0
_CLOCK_MinuteTriggerBaseOffsetPlus30:
    DC.W    0
_CLOCK_MinuteTriggerBaseOffset:
    DC.W    0
_ACCUMULATOR_Row0_CaptureValue:
    DC.W    0
_ACCUMULATOR_Row1_CaptureValue:
    DC.W    0
_ACCUMULATOR_Row2_CaptureValue:
    DC.W    0
_ACCUMULATOR_Row3_CaptureValue:
    DC.W    0
_ACCUMULATOR_Row0_Sum:
    DC.W    0
_ACCUMULATOR_Row1_Sum:
    DC.W    0
_ACCUMULATOR_Row2_Sum:
    DC.W    0
_ACCUMULATOR_Row3_Sum:
    DC.W    0
_ACCUMULATOR_Row0_SaturateFlag:
    DC.W    0
_ACCUMULATOR_Row1_SaturateFlag:
    DC.W    0
_ACCUMULATOR_Row2_SaturateFlag:
    DC.W    0
_ACCUMULATOR_Row3_SaturateFlag:
    DC.L    0,0
    DC.W    0
_COPPER_AnimationLane0_Countdown:
    DC.W    0
_COPPER_AnimationLane1_Countdown:
    DC.W    0
_COPPER_AnimationLane2_Countdown:
    DC.W    0
_COPPER_AnimationLane3_Countdown:
    DC.W    0
_CLOCK_MonthLengths:
    DC.L    $001f001c,$001f001e,$001f001e,$001f001f
    DC.L    $001e001f,$001e001f,$001f001d,$001f001e
    DC.L    $001f001e,$001f001f,$001e001f,$001e001f
_CLOCK_HalfHourSlotLookup:
    DC.L    $2728292a,$2b2c2d2e,$2f300102,$03040506
    DC.L    $0708090a,$0b0c0d0e,$0f101112,$13141516
    DC.L    $1718191a,$1b1c1d1e,$1f202122,$23242526
;------------------------------------------------------------------------------
; SYM: _PARSEINI_ParsedDescriptorListHead ... _WDISP_WeatherStatusBrushListHead   (brush descriptor/list head pointers)
; TYPE: pointer fields
; PURPOSE: Shared heads used for parsed brush descriptor chains, pending CTASKS handoff nodes, and weather-status brush lists.
; USED BY: PARSEINI_*, ESQIFF_*, ESQFUNC_*, _CTASKS_IFFTaskCleanup, WDISP_*
; NOTES: Most entries are transient handoff pointers consumed by _BRUSH_PopulateBrushList or task cleanup.
;------------------------------------------------------------------------------
_PARSEINI_ParsedDescriptorListHead:
    DC.L    0
_CTASKS_PendingLogoBrushDescriptor:
    DC.L    0
_CTASKS_PendingGAdsBrushDescriptor:
    DC.L    0
_ESQFUNC_PwBrushDescriptorHead:
    DC.L    0
_PARSEINI_BannerBrushResourceHead:
    DC.L    0
_CTASKS_PendingIffBrushDescriptor:
    DC.L    0
_WDISP_WeatherStatusBrushListHead:
    DC.L    0
; Points to the most recently loaded brush node (shared across modules).
_BRUSH_SelectedNode:
    DC.L    0
;------------------------------------------------------------------------------
; SYM: _ESQIFF_GAdsBrushListCount/_ESQIFF_LogoBrushListCount   (brush list node counts)
; TYPE: u32/u32
; PURPOSE: Track active node counts in the G-Ads and Logo brush lists.
; USED BY: ESQIFF_*, ESQFUNC_*, _GCOMMAND_SaveBrushResult
; NOTES: Counters are incremented on append and decremented on pop; selection paths gate on thresholds (G-Ads >=2, Logo >=1).
;------------------------------------------------------------------------------
_ESQIFF_GAdsBrushListCount:
    DC.L    0
_ESQIFF_LogoBrushListCount:
    DC.L    0
; Non-zero while _BRUSH_PopulateBrushList is mutating the brush list.
_BRUSH_LoadInProgressFlag:
    DC.L    0
; Tracks which cleanup alert message (if any) should be shown after brush loads.
_BRUSH_PendingAlertCode:
    DC.L    0
