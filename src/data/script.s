; ========== SCRIPT.c ==========

Global_STR_SCRIPT_C_1:
    NStr    "SCRIPT.c"
Global_STR_SCRIPT_C_2:
    NStr    "SCRIPT.c"
;------------------------------------------------------------------------------
; SYM: SCRIPT_SerialReadModeOverflowCount   (serial read-mode overflow counter)
; TYPE: u32
; PURPOSE: Counts serial read-mode overflow/threshold events seen by APP interrupt path.
; USED BY: ESQ_HandleSerialRbfInterrupt
; NOTES: Incremented when ESQPARS2 read-mode flags hit overflow handling branch.
;------------------------------------------------------------------------------
SCRIPT_SerialReadModeOverflowCount:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: SCRIPT_CtrlLineAssertedFlag   (CTRL-line asserted mirror)
; TYPE: u16 (stored in s32 slot)
; PURPOSE: Mirrors asserted/deasserted CTRL-line state for serial control helpers.
; USED BY: SCRIPT_AssertCtrlLine*, SCRIPT_DeassertCtrlLine*, SCRIPT_ClearCtrlLineIfEnabled
; NOTES: Written as 0/1 while SCRIPT_SerialShadowWord is updated and sent to SERDAT.
;------------------------------------------------------------------------------
SCRIPT_CtrlLineAssertedFlag:
    DS.L    1
Global_STR_NO_CURRENT_WEATHER_DATA_AVIALABLE:
    NStr    "No Current Weather Data Available"
Global_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE:
    DC.L    Global_STR_NO_CURRENT_WEATHER_DATA_AVIALABLE
SCRIPT_StrNoForecastWeatherData:
    NStr    "No Forecast Weather Data Available"
SCRIPT_PtrNoForecastWeatherData:
    DC.L    SCRIPT_StrNoForecastWeatherData
SCRIPT_StrWeatherDataAvailabilityDisclaimer:
    NStr    "May not be available in all areas."
SCRIPT_PtrWeatherDataAvailabilityDisclaimer:
    DC.L    SCRIPT_StrWeatherDataAvailabilityDisclaimer
SCRIPT_StrContinued:
    NStr    "Continued"
SCRIPT_PtrContinued:
    DC.L    SCRIPT_StrContinued

Global_STR_JANUARY:
    NStr    "January"
Global_STR_FEBRUARY:
    NStr    "February"
Global_STR_MARCH:
    NStr    "March"
Global_STR_APRIL:
    NStr    "April"
Global_STR_MAY:
    NStr    "May"
Global_STR_JUNE:
    NStr    "June"
Global_STR_JULY:
    NStr    "July"
Global_STR_AUGUST:
    NStr    "August"
Global_STR_SEPTEMBER:
    NStr    "September"
Global_STR_OCTOBER:
    NStr    "October"
Global_STR_NOVEMBER:
    NStr    "November"
Global_STR_DECEMBER:
    NStr    "December"

Global_JMPTBL_MONTHS:
    DC.L    Global_STR_JANUARY
    DC.L    Global_STR_FEBRUARY
    DC.L    Global_STR_MARCH
    DC.L    Global_STR_APRIL
    DC.L    Global_STR_MAY
    DC.L    Global_STR_JUNE
    DC.L    Global_STR_JULY
    DC.L    Global_STR_AUGUST
    DC.L    Global_STR_SEPTEMBER
    DC.L    Global_STR_OCTOBER
    DC.L    Global_STR_NOVEMBER
    DC.L    Global_STR_DECEMBER

SCRIPT_StrMonthShort_Jan:
    NStr    "Jan "
SCRIPT_StrMonthShort_Feb:
    NStr    "Feb "
SCRIPT_StrMonthShort_Mar:
    NStr    "Mar "
SCRIPT_StrMonthShort_Apr:
    NStr    "Apr "
SCRIPT_StrMonthShort_May:
    NStr    "May "
SCRIPT_StrMonthShort_Jun:
    NStr    "Jun "
SCRIPT_StrMonthShort_Jul:
    NStr    "Jul "
SCRIPT_StrMonthShort_Aug:
    NStr    "Aug "
SCRIPT_StrMonthShort_Sep:
    NStr    "Sep "
SCRIPT_StrMonthShort_Oct:
    NStr    "Oct "
SCRIPT_StrMonthShort_Nov:
    NStr    "Nov "
SCRIPT_StrMonthShort_Dec:
    NStr    "Dec "

Global_JMPTBL_SHORT_MONTHS:
    DC.L    SCRIPT_StrMonthShort_Jan
    DC.L    SCRIPT_StrMonthShort_Feb
    DC.L    SCRIPT_StrMonthShort_Mar
    DC.L    SCRIPT_StrMonthShort_Apr
    DC.L    SCRIPT_StrMonthShort_May
    DC.L    SCRIPT_StrMonthShort_Jun
    DC.L    SCRIPT_StrMonthShort_Jul
    DC.L    SCRIPT_StrMonthShort_Aug
    DC.L    SCRIPT_StrMonthShort_Sep
    DC.L    SCRIPT_StrMonthShort_Oct
    DC.L    SCRIPT_StrMonthShort_Nov
    DC.L    SCRIPT_StrMonthShort_Dec

Global_STR_SUNDAY_1:
    NStr    "Sunday"
Global_STR_MONDAY_1:
    NStr    "Monday"
Global_STR_TUESDAY_1:
    NStr    "Tuesday"
Global_STR_WEDNESDAY_1:
    NStr    "Wednesday"
Global_STR_THURSDAY_1:
    NStr    "Thursday"
Global_STR_FRIDAY_1:
    NStr    "Friday"
Global_STR_SATURDAY_1:
    NStr    "Saturday"

Global_JMPTBL_DAYS_OF_WEEK:
    DC.L    Global_STR_SUNDAY_1
    DC.L    Global_STR_MONDAY_1
    DC.L    Global_STR_TUESDAY_1
    DC.L    Global_STR_WEDNESDAY_1
    DC.L    Global_STR_THURSDAY_1
    DC.L    Global_STR_FRIDAY_1
    DC.L    Global_STR_SATURDAY_1

SCRIPT_StrDayShort_Sun:
    NStr    "Sun "
SCRIPT_StrDayShort_Mon:
    NStr    "Mon "
SCRIPT_StrDayShort_Tue:
    NStr    "Tue "
SCRIPT_StrDayShort_Wed:
    NStr    "Wed "
SCRIPT_StrDayShort_Thu:
    NStr    "Thu "
SCRIPT_StrDayShort_Fri:
    NStr    "Fri "
SCRIPT_StrDayShort_Sat:
    NStr    "Sat "
Global_JMPTBL_SHORT_DAYS_OF_WEEK:
    DC.L    SCRIPT_StrDayShort_Sun
    DC.L    SCRIPT_StrDayShort_Mon
    DC.L    SCRIPT_StrDayShort_Tue
    DC.L    SCRIPT_StrDayShort_Wed
    DC.L    SCRIPT_StrDayShort_Thu
    DC.L    SCRIPT_StrDayShort_Fri
    DC.L    SCRIPT_StrDayShort_Sat
SCRIPT_StrChannelLabel_Monday:
    NStr    "Monday"
SCRIPT_StrChannelLabel_Tuesday:
    NStr    "Tuesday"
SCRIPT_StrChannelLabel_Wednesday:
    NStr    "Wednesday"
SCRIPT_StrChannelLabel_Thursday:
    NStr    "Thursday"
SCRIPT_StrChannelLabel_Friday:
    NStr    "Friday"
SCRIPT_StrChannelLabel_Saturday:
    NStr    "Saturday"
SCRIPT_StrChannelLabel_Sunday:
    NStr    "Sunday"
SCRIPT_StrChannelLabel_Weekdays:
    NStr    "Weekdays"
SCRIPT_StrChannelLabel_Weeknights:
    NStr    "Weeknights"
SCRIPT_StrChannelLabel_ComingSoon:
    NStr    "Coming Soon"
SCRIPT_StrChannelLabel_ThisMonth:
    NStr    "This Month"
SCRIPT_StrChannelLabel_NextMonth:
    NStr    "Next Month"
SCRIPT_StrChannelLabel_ThisFall:
    NStr    "This Fall"
SCRIPT_StrChannelLabel_ThisSummer:
    NStr    "This Summer"
;------------------------------------------------------------------------------
; SYM: SCRIPT_StrChannelLabel_TuesdaysFridays   (legacy channel-label index anchor)
; TYPE: cstring
; PURPOSE: Historical anchor used by `index * 4` address math in legacy callsites.
; USED BY: CLEANUP3/Textdisp channel-label lookups.
; NOTES: Anchor label only; pointer-table base is SCRIPT_ChannelLabelPtrTable.
;------------------------------------------------------------------------------
SCRIPT_StrChannelLabel_TuesdaysFridays:
    NStr    "Tuesdays & Fridays"
SCRIPT_StrChannelLabel_MondaysSaturdays:
    NStr    "Mondays & Saturdays"
SCRIPT_StrChannelLabel_Weekends:
    NStr    "Weekends"
SCRIPT_StrChannelLabel_EveryNight:
    NStr    "Every Night"
SCRIPT_StrChannelLabel_EveryDay:
    NStr    "Every Day"
;------------------------------------------------------------------------------
; SYM: SCRIPT_ChannelLabelEmptySlot0/SCRIPT_ChannelLabelEmptySlot1/SCRIPT_ChannelLabelEmptySlot2/SCRIPT_ChannelLabelEmptySlot3   (channel label empty-string slots)
; TYPE: char[2] x4
; PURPOSE: Zero-initialized placeholders referenced by SCRIPT_ChannelLabelPtrTable.
; USED BY: Legacy channel-label pointer lookups in TEXTDISP/CLEANUP3 flows.
; NOTES:
;   These currently act as empty-string targets (byte0 = NUL).
;   No direct symbol-based writers are identified yet; preserve contiguous layout.
;------------------------------------------------------------------------------
SCRIPT_ChannelLabelEmptySlot0:
SCRIPT_ChannelLabelEmptySlot0_BackingWord:
    DS.W    1
SCRIPT_ChannelLabelEmptySlot1:
SCRIPT_ChannelLabelEmptySlot1_BackingWord:
    DS.W    1
SCRIPT_ChannelLabelEmptySlot2:
SCRIPT_ChannelLabelEmptySlot2_BackingWord:
    DS.W    1
SCRIPT_ChannelLabelEmptySlot3:
SCRIPT_ChannelLabelEmptySlot3_BackingWord:
    DS.W    1
SCRIPT_StrChannelLabel_MondaysThruSaturdays:
    NStr    "Mondays thru Saturdays"
SCRIPT_StrChannelLabel_MondaysThruThursdays:
    NStr    "Mondays thru Thursdays"
SCRIPT_StrChannelLabel_WeekdayMornings:
    NStr    "Weekday Mornings"
SCRIPT_StrChannelLabel_WeekdayAfternoons:
    NStr    "Weekday Afternoons"
SCRIPT_StrChannelLabel_TuesdaysThursdays:
    NStr    "Tuesdays & Thursdays"
SCRIPT_StrChannelLabel_ThisWeek:
    NStr    "This Week"
;------------------------------------------------------------------------------
; SYM: SCRIPT_ChannelLabelPtrTable   (channel label pointer table)
; TYPE: array<u32 ptr>
; PURPOSE: Maps channel/group selector values to label strings for append paths.
; USED BY: CLEANUP3/Textdisp routines that index from SCRIPT_StrChannelLabel_TuesdaysFridays.
; NOTES:
;   Legacy callsites index relative to SCRIPT_StrChannelLabel_TuesdaysFridays.
;   Entries 19..22 intentionally point at zeroed empty-slot placeholders.
;------------------------------------------------------------------------------
SCRIPT_ChannelLabelPtrTable:
    DC.L    SCRIPT_StrChannelLabel_Monday
    DC.L    SCRIPT_StrChannelLabel_Tuesday
    DC.L    SCRIPT_StrChannelLabel_Wednesday
    DC.L    SCRIPT_StrChannelLabel_Thursday
    DC.L    SCRIPT_StrChannelLabel_Friday
    DC.L    SCRIPT_StrChannelLabel_Saturday
    DC.L    SCRIPT_StrChannelLabel_Sunday
    DC.L    SCRIPT_StrChannelLabel_Weekdays
    DC.L    SCRIPT_StrChannelLabel_Weeknights
    DC.L    SCRIPT_StrChannelLabel_ComingSoon
    DC.L    SCRIPT_StrChannelLabel_ThisMonth
    DC.L    SCRIPT_StrChannelLabel_NextMonth
    DC.L    SCRIPT_StrChannelLabel_ThisFall
    DC.L    SCRIPT_StrChannelLabel_ThisSummer
    DC.L    SCRIPT_StrChannelLabel_TuesdaysFridays
    DC.L    SCRIPT_StrChannelLabel_MondaysSaturdays
    DC.L    SCRIPT_StrChannelLabel_Weekends
    DC.L    SCRIPT_StrChannelLabel_EveryNight
    DC.L    SCRIPT_StrChannelLabel_EveryDay
    DC.L    SCRIPT_ChannelLabelEmptySlot0
    DC.L    SCRIPT_ChannelLabelEmptySlot1
    DC.L    SCRIPT_ChannelLabelEmptySlot2
    DC.L    SCRIPT_ChannelLabelEmptySlot3
    DC.L    SCRIPT_StrChannelLabel_MondaysThruSaturdays
    DC.L    SCRIPT_StrChannelLabel_MondaysThruThursdays
    DC.L    SCRIPT_StrChannelLabel_WeekdayMornings
    DC.L    SCRIPT_StrChannelLabel_WeekdayAfternoons
    DC.L    SCRIPT_StrChannelLabel_TuesdaysThursdays
    DC.L    SCRIPT_StrChannelLabel_ThisWeek

; Another struct?
Global_STR_ALIGNED_NOW_SHOWING:
    DC.B    TextAlignCenter,"Now showing",0
Global_STR_ALIGNED_NEXT_SHOWING:
    DC.B    TextAlignCenter,"Next showing ",0
Global_STR_ALIGNED_TODAY_AT:
    DC.B    TextAlignCenter,"Today at ",0
Global_STR_ALIGNED_TOMORROW_AT:
    DC.B    TextAlignCenter,"Tomorrow at ",0
Global_STR_SHOWTIMES_AND_SINGLE_SPACE:
    NStr    "Showtimes "
Global_STR_SHOWING_AT_AND_SINGLE_SPACE:
    NStr    "Showing at "
SCRIPT_StrHoursPluralSuffix:
    DC.B    "hrs ",0
SCRIPT_StrHourSingularSuffix:
    DC.B    "hr ",0
SCRIPT_StrMinutesSuffix:
    DC.B    "min)",0
Global_STR_ALIGNED_TONIGHT_AT:
    DC.B    TextAlignCenter,"Tonight at ",0
Global_STR_ALIGNED_ON:
    DC.B    TextAlignCenter,"on",0
Global_STR_ALIGNED_CHANNEL_1:
    NStr2   TextAlignCenter,"Channel "
SCRIPT_StrSportsOnPrefix:
    NStr    "Sports on "
SCRIPT_PtrSportsOnPrefix:
    DC.L    SCRIPT_StrSportsOnPrefix
SCRIPT_StrMovieSummaryForPrefix:
    NStr    "Movie Summary for "
SCRIPT_PtrMovieSummaryForPrefix:
    DC.L    SCRIPT_StrMovieSummaryForPrefix
SCRIPT_StrSummaryOfPrefix:
    NStr    "Summary of "
SCRIPT_PtrSummaryOfPrefix:
    DC.L    SCRIPT_StrSummaryOfPrefix
SCRIPT_StrChannelSuffix:
    NStr    " channel "
SCRIPT_PtrChannelSuffix:
    DC.L    SCRIPT_StrChannelSuffix
SCRIPT_StrNoDataPlaceholder:
    NStr    "No Data."
SCRIPT_PtrNoDataPlaceholder:
    DC.L    SCRIPT_StrNoDataPlaceholder
Global_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION:
    NStr    "Please Stand By for your Local Listings.  ER007"
Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION:
    DC.L    Global_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION
Global_STR_OFF_AIR_1:
    NStr    "Off Air."
SCRIPT_PtrOffAirPlaceholder:
    DC.L    Global_STR_OFF_AIR_1
Global_STR_GRID_DATE_FORMAT_STRING:
    NStr    "%s %s %ld %04ld"
Global_STR_WEATHER_UPDATE_FOR:
    NStr    "Weather Update for "
;------------------------------------------------------------------------------
; SYM: SCRIPT_CtrlHandshakeStage/SCRIPT_CtrlHandshakeRetryCount/SCRIPT_RuntimeModeDispatchLatch/SCRIPT_CtrlCmdDeferCounter/SCRIPT_PlaybackFallbackCounter/SCRIPT_Type20SubtypeCache   (script ctrl/runtime state cluster)
; TYPE: u16/u16/u16/u16/u16/u16
; PURPOSE: Tracks CTRL handshake/retry/dispatch state and cached subtype in runtime command processing.
; USED BY: SCRIPT_UpdateCtrlStateMachine, SCRIPT_HandleBrushCommand, SCRIPT_ProcessCtrlContextPlaybackTick, ESQFUNC_DrawDiagnosticsScreen
; NOTES:
;   `SCRIPT_Type20SubtypeCache` semantics are still partially inferred from P_TYPE type-20 helper flows.
;------------------------------------------------------------------------------
SCRIPT_CtrlHandshakeStage:
    DS.W    1
SCRIPT_CtrlHandshakeRetryCount:
    DS.W    1
SCRIPT_RuntimeModeDispatchLatch:
    DS.W    1
SCRIPT_CtrlCmdDeferCounter:
    DS.W    1
SCRIPT_PlaybackFallbackCounter:
    DS.W    1
SCRIPT_Type20SubtypeCache:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: SCRIPT_PendingBannerTargetChar/SCRIPT_BannerTransitionActive   (banner transition control)
; TYPE: s16/u16
; PURPOSE: Stores a deferred banner-char target and whether a transition is currently active.
; USED BY: SCRIPT_BeginBannerCharTransition, SCRIPT_UpdateBannerCharTransition, SCRIPT_ApplyPendingBannerTarget
; NOTES: `SCRIPT_PendingBannerTargetChar` uses sentinels (-2 = one-shot staged value, -1 = none pending).
;------------------------------------------------------------------------------
SCRIPT_PendingBannerTargetChar:
    DC.W    $ffff
SCRIPT_PendingBannerSpeedMs:
    DS.W    1
SCRIPT_BannerTransitionStepBudget:
    DS.W    1
SCRIPT_BannerTransitionActive:
    DS.W    1
SCRIPT_ReadModeActiveLatch:
    DS.W    1
; Brush pointers exposed to scripting (primary/secondary selections).
BRUSH_ScriptPrimarySelection:
    DS.L    1
BRUSH_ScriptSecondarySelection:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: SCRIPT_RuntimeModeDeferredFlag/SCRIPT_PendingWeatherCommandChar/SCRIPT_PendingTextdispCmdChar/SCRIPT_PendingTextdispCmdArg   (deferred command payload cluster)
; TYPE: u32/u8/u8/u16
; PURPOSE: Holds deferred runtime-mode and pending command bytes consumed by weather/TEXTDISP dispatch paths.
; USED BY: SCRIPT_HandleBrushCommand, SCRIPT_ProcessCtrlContextPlaybackTick, SCRIPT_LoadCtrlContextSnapshot, SCRIPT_SaveCtrlContextSnapshot, ESQIFF2_ApplyIncomingStatusPacket
; NOTES: Command chars/arg are serialized into CTRL context at offsets +437..+439.
;------------------------------------------------------------------------------
SCRIPT_RuntimeModeDeferredFlag:
    DS.L    1
SCRIPT_PendingWeatherCommandChar:
    DC.B    "x"
SCRIPT_PendingTextdispCmdChar:
    DS.B    1
SCRIPT_PendingTextdispCmdArg:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: SCRIPT_CommandTextPtr   (owned script command text pointer)
; TYPE: pointer
; PURPOSE: Stores heap-owned text payload used by TEXTDISP command dispatch (`cmd 'C'` path).
; USED BY: SCRIPT_HandleBrushCommand, SCRIPT_LoadCtrlContextSnapshot, SCRIPT_SaveCtrlContextSnapshot, TEXTDISP_HandleScriptCommand
; NOTES: Updated through ESQPARS_ReplaceOwnedString; source commonly comes from
;   SCRIPT_CTRL_CMD_BUFFER tail (`LEA 3(A2),A0`) after parser NUL-termination.
;------------------------------------------------------------------------------
SCRIPT_CommandTextPtr:
    DS.L    1
SCRIPT_BannerTransitionStepCursor:
    DS.W    1
SCRIPT_StatusMaskRefreshPending:
    DS.W    1
SCRIPT_BrushTag_Default00_Primary:
    NStr    "00"
SCRIPT_BrushTag_Default00_Secondary:
    NStr    "00"
SCRIPT_BrushTag_Clear11_Primary:
    NStr    "11"
SCRIPT_BrushTag_Clear11_Secondary:
    NStr    "11"
SCRIPT_Tag_YL:
    NStr    "yl"
    DS.W    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_SourceConfigFlagMask   (source-config aggregate flag mask)
; TYPE: u16
; PURPOSE: Accumulates SourceCfg feature flags while loading/applying source config entries.
; USED BY: TEXTDISP_LoadSourceConfig, TEXTDISP_ClearSourceConfig, TEXTDISP_ApplySourceConfigToEntry, TEXTDISP_AddSourceConfigEntry
; NOTES: Updated by OR-ing per-entry flags.
;------------------------------------------------------------------------------
TEXTDISP_SourceConfigFlagMask:
    DS.W    1
Global_STR_PREVUESPORTS:
    NStr    "PrevueSports"
TEXTDISP_PtrPrevueSportsTag:
    DC.L    Global_STR_PREVUESPORTS
SCRIPT_AlignedPrefixEmptyA:
    NStr    TextAlignCenter
SCRIPT_AlignedPrefixEmptyB:
    NStr    TextAlignCenter
SCRIPT_SpacerTripleA:
    NStr    "   "
SCRIPT_AlignedChannelAbbrevPrefix:
    NStr2   TextAlignCenter,"Ch. "
SCRIPT_SpacerTripleB:
    NStr    "   "
SCRIPT_AlignedCharFormat:
    NStr2   TextAlignCenter,"%c"
SCRIPT_AlignedPrefixEmptyC:
    NStr    TextAlignCenter
SCRIPT_AlignedPrefixEmptyD:
    NStr    TextAlignCenter
SCRIPT_SpacerTripleC:
    NStr    "   "
SCRIPT_AlignedPrefixEmptyE:
    NStr    TextAlignCenter
SCRIPT_AlignedPrefixEmptyF:
    NStr    TextAlignCenter
SCRIPT_AlignedStringFormat:
    NStr2   TextAlignCenter,"%s"
SCRIPT_StrAtSeparator:
    NStr    " at "
SCRIPT_StrVsDotSeparator:
    NStr    " vs. "
SCRIPT_StrVsSeparator:
    NStr    " vs "
SCRIPT_AlignedPrefixEmptyG:
    NStr    TextAlignCenter
Global_STR_ALIGNED_CHANNEL_2:
    NStr2   TextAlignCenter,"Channel "
;------------------------------------------------------------------------------
; SYM: TEXTDISP_FilterModeId   (text-display filter mode id)
; TYPE: u8 (stored in word slot)
; PURPOSE: Active mode selector for TEXTDISP filter/search passes.
; USED BY: TEXTDISP_FilterAndSelectEntry
; NOTES: Observed values cycle through 1..3.
;------------------------------------------------------------------------------
TEXTDISP_FilterModeId:
    DC.W    $0300
SCRIPT_FilterTag_PPV:
    NStr    "PPV"
SCRIPT_FilterTag_SBE:
    NStr    "SBE"
SCRIPT_FilterTag_SPORTS:
    NStr    "SPORTS"
;------------------------------------------------------------------------------
; SYM: TEXTDISP_LastDispatchMatchIndex/TEXTDISP_LastDispatchGroupId/TEXTDISP_CommandBufferPtr/TEXTDISP_CommandPrefixFormat   (textdisp dispatch scratch cluster)
; TYPE: s16/u8/pointer/cstring
; PURPOSE: Stores last dispatch selection/group and temporary command-buffer state for TEXTDISP command handling.
; USED BY: TEXTDISP_HandleScriptCommand
; NOTES: Command prefix format currently emits `xx%s` into local scratch before lookup/dispatch.
;------------------------------------------------------------------------------
TEXTDISP_LastDispatchMatchIndex:
    DC.W    $ffff
TEXTDISP_LastDispatchGroupId:
    DC.B    0,"1"
TEXTDISP_CommandBufferPtr:
    DS.L    1
TEXTDISP_CommandPrefixFormat:
    NStr3   "xx%s",18,"TEMPO"
