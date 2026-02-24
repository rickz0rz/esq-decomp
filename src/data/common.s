
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
    DC.W    0
Global_STR_DISK_ERRORS_FORMATTED:
    NStr2   "Disk Errors: %ld",TextLineFeed
COMMON_QueryDiskUsagePercentScratch:
    DC.W    0
Global_STR_DISK_IS_FULL_FORMATTED:
    NStr    "Disk is %ld%% full"
CTRL_Bit4CaptureDelayCounter:
    DC.W    0
CTRL_Bit3CaptureDelayCounter:
    DC.W    0
CTRL_Bit4CapturePhase:
    DC.W    0
CTRL_Bit4SampleSlotIndex:
    DC.W    0
CTRL_Bit3CapturePhase:
    DC.W    0
CTRL_Bit3SampleSlotIndex:
    DC.W    0
CTRL_Bit4SampleScratch:
    DC.L    0,0
CTRL_Bit3SampleScratch:
    DC.L    0,0
HIGHLIGHT_CopperEffectSeed:
    DC.W    0
HIGHLIGHT_CopperEffectParamA:
    DC.B    0
HIGHLIGHT_CopperEffectParamB:
    DC.B    0
    DC.W    0
CTRL_SampleEntryCount:
    DC.W    0
CTRL_SampleEntryScratch:
    DC.L    0
    DC.W    0
HIGHLIGHT_CustomValue:
    NStr    "?"
CLOCK_DaySlotIndexPtr:
    DC.L    0
CLOCK_CurrentDayOfWeekIndexPtr:
    DC.L    0
BANNER_ResetPendingFlag:
    DC.L    0
CLOCK_MinuteTrigger30MinusBase:
    DC.W    0
CLOCK_MinuteTrigger60MinusBase:
    DC.W    0
CLOCK_MinuteTriggerBaseOffsetPlus30:
    DC.W    0
CLOCK_MinuteTriggerBaseOffset:
    DC.W    0
ACCUMULATOR_Row0_CaptureValue:
    DC.W    0
ACCUMULATOR_Row1_CaptureValue:
    DC.W    0
ACCUMULATOR_Row2_CaptureValue:
    DC.W    0
ACCUMULATOR_Row3_CaptureValue:
    DC.W    0
ACCUMULATOR_Row0_Sum:
    DC.W    0
ACCUMULATOR_Row1_Sum:
    DC.W    0
ACCUMULATOR_Row2_Sum:
    DC.W    0
ACCUMULATOR_Row3_Sum:
    DC.W    0
ACCUMULATOR_Row0_SaturateFlag:
    DC.W    0
ACCUMULATOR_Row1_SaturateFlag:
    DC.W    0
ACCUMULATOR_Row2_SaturateFlag:
    DC.W    0
ACCUMULATOR_Row3_SaturateFlag:
    DC.L    0,0
    DC.W    0
COPPER_AnimationLane0_Countdown:
    DC.W    0
COPPER_AnimationLane1_Countdown:
    DC.W    0
COPPER_AnimationLane2_Countdown:
    DC.W    0
COPPER_AnimationLane3_Countdown:
    DC.W    0
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
    DC.L    0
CTASKS_PendingLogoBrushDescriptor:
    DC.L    0
CTASKS_PendingGAdsBrushDescriptor:
    DC.L    0
ESQFUNC_PwBrushDescriptorHead:
    DC.L    0
PARSEINI_BannerBrushResourceHead:
    DC.L    0
CTASKS_PendingIffBrushDescriptor:
    DC.L    0
WDISP_WeatherStatusBrushListHead:
    DC.L    0
; Points to the most recently loaded brush node (shared across modules).
BRUSH_SelectedNode:
    DC.L    0
;------------------------------------------------------------------------------
; SYM: ESQIFF_GAdsBrushListCount/ESQIFF_LogoBrushListCount   (brush list node counts)
; TYPE: u32/u32
; PURPOSE: Track active node counts in the G-Ads and Logo brush lists.
; USED BY: ESQIFF_*, ESQFUNC_*, GCOMMAND_SaveBrushResult
; NOTES: Counters are incremented on append and decremented on pop; selection paths gate on thresholds (G-Ads >=2, Logo >=1).
;------------------------------------------------------------------------------
ESQIFF_GAdsBrushListCount:
    DC.L    0
ESQIFF_LogoBrushListCount:
    DC.L    0
; Non-zero while BRUSH_PopulateBrushList is mutating the brush list.
BRUSH_LoadInProgressFlag:
    DC.L    0
; Tracks which cleanup alert message (if any) should be shown after brush loads.
BRUSH_PendingAlertCode:
    DC.L    0
