
Global_STR_PLEASE_STANDBY_1:
    NStr    "Please Standby..."
Global_STR_PLEASE_STANDBY_1_Length = Global_STR_ATTENTION_SYSTEM_ENGINEER_1-Global_STR_PLEASE_STANDBY_1
Global_STR_ATTENTION_SYSTEM_ENGINEER_1:
    NStr    "ATTENTION! SYSTEM ENGINEER"
Global_STR_REPORT_CODE_ER003:
    NStr    "Report Code ER003 to TV Guide Technical Services."
Global_STR_YOU_CANNOT_RE_RUN_THE_SOFTWARE:
    NStr2   "YOU CANNOT RE-RUN THE SOFTWARE IN THIS MANNER.  PLEASE RE-BOOT!!",TextLineFeed
COMMON_QueryDiskSoftErrorCountScratch:
    DS.W    1
Global_STR_DISK_ERRORS_FORMATTED:
    NStr2   "Disk Errors: %ld",TextLineFeed
COMMON_QueryDiskUsagePercentScratch:
    DS.W    1
Global_STR_DISK_IS_FULL_FORMATTED:
    NStr    "Disk is %ld%% full"
CTRL_Bit4CaptureDelayCounter:
    DS.W    1
CTRL_Bit3CaptureDelayCounter:
    DS.W    1
CTRL_Bit4CapturePhase:
    DS.W    1
CTRL_Bit4SampleSlotIndex:
    DS.W    1
CTRL_Bit3CapturePhase:
    DS.W    1
CTRL_Bit3SampleSlotIndex:
    DS.W    1
CTRL_Bit4SampleScratch:
    DS.L    2
CTRL_Bit3SampleScratch:
    DS.L    2
HIGHLIGHT_CopperEffectSeed:
    DS.W    1
HIGHLIGHT_CopperEffectParamA:
    DS.B    1
HIGHLIGHT_CopperEffectParamB:
    DS.B    1
    DS.W    1
CTRL_SampleEntryCount:
    DS.W    1
CTRL_SampleEntryScratch:
    DS.L    1
    DS.W    1
HIGHLIGHT_CustomValue:
    NStr    "?"
CLOCK_DaySlotIndexPtr:
    DS.L    1
CLOCK_CurrentDayOfWeekIndexPtr:
    DS.L    1
BANNER_ResetPendingFlag:
    DS.L    1
CLOCK_MinuteTrigger30MinusBase:
    DS.W    1
CLOCK_MinuteTrigger60MinusBase:
    DS.W    1
CLOCK_MinuteTriggerBaseOffsetPlus30:
    DS.W    1
CLOCK_MinuteTriggerBaseOffset:
    DS.W    1
ACCUMULATOR_Row0_CaptureValue:
    DS.W    1
ACCUMULATOR_Row1_CaptureValue:
    DS.W    1
ACCUMULATOR_Row2_CaptureValue:
    DS.W    1
ACCUMULATOR_Row3_CaptureValue:
    DS.W    1
ACCUMULATOR_Row0_Sum:
    DS.W    1
ACCUMULATOR_Row1_Sum:
    DS.W    1
ACCUMULATOR_Row2_Sum:
    DS.W    1
ACCUMULATOR_Row3_Sum:
    DS.W    1
ACCUMULATOR_Row0_SaturateFlag:
    DS.W    1
ACCUMULATOR_Row1_SaturateFlag:
    DS.W    1
ACCUMULATOR_Row2_SaturateFlag:
    DS.W    1
ACCUMULATOR_Row3_SaturateFlag:
    DS.L    2
    DS.W    1
COPPER_AnimationLane0_Countdown:
    DS.W    1
COPPER_AnimationLane1_Countdown:
    DS.W    1
COPPER_AnimationLane2_Countdown:
    DS.W    1
COPPER_AnimationLane3_Countdown:
    DS.W    1
CLOCK_MonthLengths:
    DC.L    $001f001c,$001f001e,$001f001e,$001f001f
    DC.L    $001e001f,$001e001f,$001f001d,$001f001e
    DC.L    $001f001e,$001f001f,$001e001f,$001e001f
CLOCK_HalfHourSlotLookup:
    DC.L    $2728292a,$2b2c2d2e,$2f300102,$03040506
    DC.L    $0708090a,$0b0c0d0e,$0f101112,$13141516
    DC.L    $1718191a,$1b1c1d1e,$1f202122,$23242526
;------------------------------------------------------------------------------
; SYM: PARSEINI_ParsedDescriptorListHead ... WDISP_WeatherStatusBrushListHead   (brush descriptor/list head pointers)
; TYPE: pointer fields
; PURPOSE: Shared heads used for parsed brush descriptor chains, pending CTASKS handoff nodes, and weather-status brush lists.
; USED BY: PARSEINI_*, ESQIFF_*, ESQFUNC_*, CTASKS_IFFTaskCleanup, WDISP_*
; NOTES: Most entries are transient handoff pointers consumed by BRUSH_PopulateBrushList or task cleanup.
;------------------------------------------------------------------------------
PARSEINI_ParsedDescriptorListHead:
    DS.L    1
CTASKS_PendingLogoBrushDescriptor:
    DS.L    1
CTASKS_PendingGAdsBrushDescriptor:
    DS.L    1
ESQFUNC_PwBrushDescriptorHead:
    DS.L    1
PARSEINI_BannerBrushResourceHead:
    DS.L    1
CTASKS_PendingIffBrushDescriptor:
    DS.L    1
WDISP_WeatherStatusBrushListHead:
    DS.L    1
; Points to the most recently loaded brush node (shared across modules).
BRUSH_SelectedNode:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ESQIFF_GAdsBrushListCount/ESQIFF_LogoBrushListCount   (brush list node counts)
; TYPE: u32/u32
; PURPOSE: Track active node counts in the G-Ads and Logo brush lists.
; USED BY: ESQIFF_*, ESQFUNC_*, GCOMMAND_SaveBrushResult
; NOTES: Counters are incremented on append and decremented on pop; selection paths gate on thresholds (G-Ads >=2, Logo >=1).
;------------------------------------------------------------------------------
ESQIFF_GAdsBrushListCount:
    DS.L    1
ESQIFF_LogoBrushListCount:
    DS.L    1
; Non-zero while BRUSH_PopulateBrushList is mutating the brush list.
BRUSH_LoadInProgressFlag:
    DS.L    1
; Tracks which cleanup alert message (if any) should be shown after brush loads.
BRUSH_PendingAlertCode:
    DS.L    1
