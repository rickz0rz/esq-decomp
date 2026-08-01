    XDEF    _Global_STR_SCRIPT_C_1
    XDEF    _Global_STR_SCRIPT_C_2
    XDEF    _SCRIPT_SerialReadModeOverflowCount
    XDEF    _SCRIPT_CtrlLineAssertedFlag
    XDEF    _Global_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE
    XDEF    _SCRIPT_PtrNoForecastWeatherData
    XDEF    _SCRIPT_PtrWeatherDataAvailabilityDisclaimer
    XDEF    _Global_JMPTBL_MONTHS
    XDEF    _Global_JMPTBL_SHORT_MONTHS
    XDEF    _Global_JMPTBL_DAYS_OF_WEEK
    XDEF    _Global_JMPTBL_SHORT_DAYS_OF_WEEK
    XDEF    _SCRIPT_StrChannelLabel_TuesdaysFridays
    XDEF    _Global_STR_ALIGNED_NOW_SHOWING
    XDEF    _Global_STR_ALIGNED_NEXT_SHOWING
    XDEF    _Global_STR_ALIGNED_TODAY_AT
    XDEF    _Global_STR_ALIGNED_TOMORROW_AT
    XDEF    _Global_STR_SHOWTIMES_AND_SINGLE_SPACE
    XDEF    _Global_STR_SHOWING_AT_AND_SINGLE_SPACE
    XDEF    _SCRIPT_StrHoursPluralSuffix
    XDEF    _SCRIPT_StrHourSingularSuffix
    XDEF    _SCRIPT_StrMinutesSuffix
    XDEF    _Global_STR_ALIGNED_TONIGHT_AT
    XDEF    _Global_STR_ALIGNED_ON
    XDEF    _Global_STR_ALIGNED_CHANNEL_1
    XDEF    _SCRIPT_PtrSportsOnPrefix
    XDEF    _SCRIPT_PtrMovieSummaryForPrefix
    XDEF    _SCRIPT_PtrSummaryOfPrefix
    XDEF    _SCRIPT_PtrChannelSuffix
    XDEF    _SCRIPT_PtrNoDataPlaceholder
    XDEF    _Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION
    XDEF    _SCRIPT_PtrOffAirPlaceholder
    XDEF    _Global_STR_GRID_DATE_FORMAT_STRING
    XDEF    _Global_STR_WEATHER_UPDATE_FOR
    XDEF    _SCRIPT_CtrlHandshakeStage
    XDEF    _SCRIPT_CtrlHandshakeRetryCount
    XDEF    _SCRIPT_RuntimeModeDispatchLatch
    XDEF    _SCRIPT_CtrlCmdDeferCounter
    XDEF    _SCRIPT_PlaybackFallbackCounter
    XDEF    _SCRIPT_Type20SubtypeCache
    XDEF    _SCRIPT_PendingBannerTargetChar
    XDEF    _SCRIPT_PendingBannerSpeedMs
    XDEF    _SCRIPT_BannerTransitionStepBudget
    XDEF    _SCRIPT_BannerTransitionActive
    XDEF    _SCRIPT_ReadModeActiveLatch
    XDEF    _BRUSH_ScriptPrimarySelection
    XDEF    _BRUSH_ScriptSecondarySelection
    XDEF    _SCRIPT_RuntimeModeDeferredFlag
    XDEF    _SCRIPT_PendingWeatherCommandChar
    XDEF    _SCRIPT_PendingTextdispCmdChar
    XDEF    _SCRIPT_PendingTextdispCmdArg
    XDEF    _SCRIPT_CommandTextPtr
    XDEF    _SCRIPT_BannerTransitionStepCursor
    XDEF    _SCRIPT_StatusMaskRefreshPending
    XDEF    _SCRIPT_BrushTag_Default00_Primary
    XDEF    _SCRIPT_BrushTag_Default00_Secondary
    XDEF    _SCRIPT_BrushTag_Clear11_Primary
    XDEF    _SCRIPT_BrushTag_Clear11_Secondary
    XDEF    _SCRIPT_Tag_YL
    XDEF    _TEXTDISP_SourceConfigFlagMask
    XDEF    _TEXTDISP_PtrPrevueSportsTag
    XDEF    _SCRIPT_AlignedPrefixEmptyA
    XDEF    _SCRIPT_AlignedPrefixEmptyB
    XDEF    _SCRIPT_SpacerTripleA
    XDEF    _SCRIPT_AlignedChannelAbbrevPrefix
    XDEF    _SCRIPT_SpacerTripleB
    XDEF    _SCRIPT_AlignedCharFormat
    XDEF    _SCRIPT_AlignedPrefixEmptyC
    XDEF    _SCRIPT_AlignedPrefixEmptyD
    XDEF    _SCRIPT_SpacerTripleC
    XDEF    _SCRIPT_AlignedPrefixEmptyE
    XDEF    _SCRIPT_AlignedPrefixEmptyF
    XDEF    _SCRIPT_AlignedStringFormat
    XDEF    _SCRIPT_StrAtSeparator
    XDEF    _SCRIPT_StrVsDotSeparator
    XDEF    _SCRIPT_StrVsSeparator
    XDEF    _SCRIPT_AlignedPrefixEmptyG
    XDEF    _Global_STR_ALIGNED_CHANNEL_2
    XDEF    _TEXTDISP_FilterModeId
    XDEF    _SCRIPT_FilterTag_PPV
    XDEF    _SCRIPT_FilterTag_SBE
    XDEF    _SCRIPT_FilterTag_SPORTS
    XDEF    _TEXTDISP_LastDispatchMatchIndex
; ========== SCRIPT.c ==========

_Global_STR_SCRIPT_C_1:
    NStr    "SCRIPT.c"
_Global_STR_SCRIPT_C_2:
    NStr    "SCRIPT.c"
;------------------------------------------------------------------------------
; SYM: _SCRIPT_SerialReadModeOverflowCount   (serial read-mode overflow counter)
; TYPE: u32
; PURPOSE: Counts serial read-mode overflow/threshold events seen by APP interrupt path.
; USED BY: _ESQ_HandleSerialRbfInterrupt
; NOTES: Incremented when ESQPARS2 read-mode flags hit overflow handling branch.
;------------------------------------------------------------------------------
_SCRIPT_SerialReadModeOverflowCount:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _SCRIPT_CtrlLineAssertedFlag   (CTRL-line asserted mirror)
; TYPE: u16 (stored in s32 slot)
; PURPOSE: Mirrors asserted/deasserted CTRL-line state for serial control helpers.
; USED BY: _SCRIPT_AssertCtrlLine*, _SCRIPT_DeassertCtrlLine*, _SCRIPT_ClearCtrlLineIfEnabled
; NOTES: Written as 0/1 while _SCRIPT_SerialShadowWord is updated and sent to SERDAT.
;------------------------------------------------------------------------------
_SCRIPT_CtrlLineAssertedFlag:
    DS.L    1
_Global_STR_NO_CURRENT_WEATHER_DATA_AVIALABLE:
    NStr    "No Current Weather Data Available"
_Global_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE:
    DC.L    _Global_STR_NO_CURRENT_WEATHER_DATA_AVIALABLE
_SCRIPT_StrNoForecastWeatherData:
    NStr    "No Forecast Weather Data Available"
_SCRIPT_PtrNoForecastWeatherData:
    DC.L    _SCRIPT_StrNoForecastWeatherData
_SCRIPT_StrWeatherDataAvailabilityDisclaimer:
    NStr    "May not be available in all areas."
_SCRIPT_PtrWeatherDataAvailabilityDisclaimer:
    DC.L    _SCRIPT_StrWeatherDataAvailabilityDisclaimer
_SCRIPT_StrContinued:
    NStr    "Continued"
_SCRIPT_PtrContinued:
    DC.L    _SCRIPT_StrContinued

_Global_STR_JANUARY:
    NStr    "January"
_Global_STR_FEBRUARY:
    NStr    "February"
_Global_STR_MARCH:
    NStr    "March"
_Global_STR_APRIL:
    NStr    "April"
_Global_STR_MAY:
    NStr    "May"
_Global_STR_JUNE:
    NStr    "June"
_Global_STR_JULY:
    NStr    "July"
_Global_STR_AUGUST:
    NStr    "August"
_Global_STR_SEPTEMBER:
    NStr    "September"
_Global_STR_OCTOBER:
    NStr    "October"
_Global_STR_NOVEMBER:
    NStr    "November"
_Global_STR_DECEMBER:
    NStr    "December"

_Global_JMPTBL_MONTHS:
    DC.L    _Global_STR_JANUARY
    DC.L    _Global_STR_FEBRUARY
    DC.L    _Global_STR_MARCH
    DC.L    _Global_STR_APRIL
    DC.L    _Global_STR_MAY
    DC.L    _Global_STR_JUNE
    DC.L    _Global_STR_JULY
    DC.L    _Global_STR_AUGUST
    DC.L    _Global_STR_SEPTEMBER
    DC.L    _Global_STR_OCTOBER
    DC.L    _Global_STR_NOVEMBER
    DC.L    _Global_STR_DECEMBER

_SCRIPT_StrMonthShort_Jan:
    NStr    "Jan "
_SCRIPT_StrMonthShort_Feb:
    NStr    "Feb "
_SCRIPT_StrMonthShort_Mar:
    NStr    "Mar "
_SCRIPT_StrMonthShort_Apr:
    NStr    "Apr "
_SCRIPT_StrMonthShort_May:
    NStr    "May "
_SCRIPT_StrMonthShort_Jun:
    NStr    "Jun "
_SCRIPT_StrMonthShort_Jul:
    NStr    "Jul "
_SCRIPT_StrMonthShort_Aug:
    NStr    "Aug "
_SCRIPT_StrMonthShort_Sep:
    NStr    "Sep "
_SCRIPT_StrMonthShort_Oct:
    NStr    "Oct "
_SCRIPT_StrMonthShort_Nov:
    NStr    "Nov "
_SCRIPT_StrMonthShort_Dec:
    NStr    "Dec "

_Global_JMPTBL_SHORT_MONTHS:
    DC.L    _SCRIPT_StrMonthShort_Jan
    DC.L    _SCRIPT_StrMonthShort_Feb
    DC.L    _SCRIPT_StrMonthShort_Mar
    DC.L    _SCRIPT_StrMonthShort_Apr
    DC.L    _SCRIPT_StrMonthShort_May
    DC.L    _SCRIPT_StrMonthShort_Jun
    DC.L    _SCRIPT_StrMonthShort_Jul
    DC.L    _SCRIPT_StrMonthShort_Aug
    DC.L    _SCRIPT_StrMonthShort_Sep
    DC.L    _SCRIPT_StrMonthShort_Oct
    DC.L    _SCRIPT_StrMonthShort_Nov
    DC.L    _SCRIPT_StrMonthShort_Dec

_Global_STR_SUNDAY_1:
    NStr    "Sunday"
_Global_STR_MONDAY_1:
    NStr    "Monday"
_Global_STR_TUESDAY_1:
    NStr    "Tuesday"
_Global_STR_WEDNESDAY_1:
    NStr    "Wednesday"
_Global_STR_THURSDAY_1:
    NStr    "Thursday"
_Global_STR_FRIDAY_1:
    NStr    "Friday"
_Global_STR_SATURDAY_1:
    NStr    "Saturday"

_Global_JMPTBL_DAYS_OF_WEEK:
    DC.L    _Global_STR_SUNDAY_1
    DC.L    _Global_STR_MONDAY_1
    DC.L    _Global_STR_TUESDAY_1
    DC.L    _Global_STR_WEDNESDAY_1
    DC.L    _Global_STR_THURSDAY_1
    DC.L    _Global_STR_FRIDAY_1
    DC.L    _Global_STR_SATURDAY_1

_SCRIPT_StrDayShort_Sun:
    NStr    "Sun "
_SCRIPT_StrDayShort_Mon:
    NStr    "Mon "
_SCRIPT_StrDayShort_Tue:
    NStr    "Tue "
_SCRIPT_StrDayShort_Wed:
    NStr    "Wed "
_SCRIPT_StrDayShort_Thu:
    NStr    "Thu "
_SCRIPT_StrDayShort_Fri:
    NStr    "Fri "
_SCRIPT_StrDayShort_Sat:
    NStr    "Sat "
_Global_JMPTBL_SHORT_DAYS_OF_WEEK:
    DC.L    _SCRIPT_StrDayShort_Sun
    DC.L    _SCRIPT_StrDayShort_Mon
    DC.L    _SCRIPT_StrDayShort_Tue
    DC.L    _SCRIPT_StrDayShort_Wed
    DC.L    _SCRIPT_StrDayShort_Thu
    DC.L    _SCRIPT_StrDayShort_Fri
    DC.L    _SCRIPT_StrDayShort_Sat
_SCRIPT_StrChannelLabel_Monday:
    NStr    "Monday"
_SCRIPT_StrChannelLabel_Tuesday:
    NStr    "Tuesday"
_SCRIPT_StrChannelLabel_Wednesday:
    NStr    "Wednesday"
_SCRIPT_StrChannelLabel_Thursday:
    NStr    "Thursday"
_SCRIPT_StrChannelLabel_Friday:
    NStr    "Friday"
_SCRIPT_StrChannelLabel_Saturday:
    NStr    "Saturday"
_SCRIPT_StrChannelLabel_Sunday:
    NStr    "Sunday"
_SCRIPT_StrChannelLabel_Weekdays:
    NStr    "Weekdays"
_SCRIPT_StrChannelLabel_Weeknights:
    NStr    "Weeknights"
_SCRIPT_StrChannelLabel_ComingSoon:
    NStr    "Coming Soon"
_SCRIPT_StrChannelLabel_ThisMonth:
    NStr    "This Month"
_SCRIPT_StrChannelLabel_NextMonth:
    NStr    "Next Month"
_SCRIPT_StrChannelLabel_ThisFall:
    NStr    "This Fall"
_SCRIPT_StrChannelLabel_ThisSummer:
    NStr    "This Summer"
;------------------------------------------------------------------------------
; SYM: _SCRIPT_StrChannelLabel_TuesdaysFridays   (legacy channel-label index anchor)
; TYPE: cstring
; PURPOSE: Historical anchor used by `index * 4` address math in legacy callsites.
; USED BY: CLEANUP3/Textdisp channel-label lookups.
; NOTES: Anchor label only; pointer-table base is _SCRIPT_ChannelLabelPtrTable.
;------------------------------------------------------------------------------
_SCRIPT_StrChannelLabel_TuesdaysFridays:
    NStr    "Tuesdays & Fridays"
_SCRIPT_StrChannelLabel_MondaysSaturdays:
    NStr    "Mondays & Saturdays"
_SCRIPT_StrChannelLabel_Weekends:
    NStr    "Weekends"
_SCRIPT_StrChannelLabel_EveryNight:
    NStr    "Every Night"
_SCRIPT_StrChannelLabel_EveryDay:
    NStr    "Every Day"
;------------------------------------------------------------------------------
; SYM: _SCRIPT_ChannelLabelEmptySlot0/_SCRIPT_ChannelLabelEmptySlot1/_SCRIPT_ChannelLabelEmptySlot2/_SCRIPT_ChannelLabelEmptySlot3   (channel label empty-string slots)
; TYPE: char[2] x4
; PURPOSE: Zero-initialized placeholders referenced by _SCRIPT_ChannelLabelPtrTable.
; USED BY: Legacy channel-label pointer lookups in TEXTDISP/CLEANUP3 flows.
; NOTES:
;   These currently act as empty-string targets (byte0 = NUL).
;   No direct symbol-based writers are identified yet; preserve contiguous layout.
;------------------------------------------------------------------------------
_SCRIPT_ChannelLabelEmptySlot0:
_SCRIPT_ChannelLabelEmptySlot0_BackingWord:
    DS.W    1
_SCRIPT_ChannelLabelEmptySlot1:
_SCRIPT_ChannelLabelEmptySlot1_BackingWord:
    DS.W    1
_SCRIPT_ChannelLabelEmptySlot2:
_SCRIPT_ChannelLabelEmptySlot2_BackingWord:
    DS.W    1
_SCRIPT_ChannelLabelEmptySlot3:
_SCRIPT_ChannelLabelEmptySlot3_BackingWord:
    DS.W    1
_SCRIPT_StrChannelLabel_MondaysThruSaturdays:
    NStr    "Mondays thru Saturdays"
_SCRIPT_StrChannelLabel_MondaysThruThursdays:
    NStr    "Mondays thru Thursdays"
_SCRIPT_StrChannelLabel_WeekdayMornings:
    NStr    "Weekday Mornings"
_SCRIPT_StrChannelLabel_WeekdayAfternoons:
    NStr    "Weekday Afternoons"
_SCRIPT_StrChannelLabel_TuesdaysThursdays:
    NStr    "Tuesdays & Thursdays"
_SCRIPT_StrChannelLabel_ThisWeek:
    NStr    "This Week"
;------------------------------------------------------------------------------
; SYM: _SCRIPT_ChannelLabelPtrTable   (channel label pointer table)
; TYPE: array<u32 ptr>
; PURPOSE: Maps channel/group selector values to label strings for append paths.
; USED BY: CLEANUP3/Textdisp routines that index from _SCRIPT_StrChannelLabel_TuesdaysFridays.
; NOTES:
;   Legacy callsites index relative to _SCRIPT_StrChannelLabel_TuesdaysFridays.
;   Entries 19..22 intentionally point at zeroed empty-slot placeholders.
;------------------------------------------------------------------------------
_SCRIPT_ChannelLabelPtrTable:
    DC.L    _SCRIPT_StrChannelLabel_Monday
    DC.L    _SCRIPT_StrChannelLabel_Tuesday
    DC.L    _SCRIPT_StrChannelLabel_Wednesday
    DC.L    _SCRIPT_StrChannelLabel_Thursday
    DC.L    _SCRIPT_StrChannelLabel_Friday
    DC.L    _SCRIPT_StrChannelLabel_Saturday
    DC.L    _SCRIPT_StrChannelLabel_Sunday
    DC.L    _SCRIPT_StrChannelLabel_Weekdays
    DC.L    _SCRIPT_StrChannelLabel_Weeknights
    DC.L    _SCRIPT_StrChannelLabel_ComingSoon
    DC.L    _SCRIPT_StrChannelLabel_ThisMonth
    DC.L    _SCRIPT_StrChannelLabel_NextMonth
    DC.L    _SCRIPT_StrChannelLabel_ThisFall
    DC.L    _SCRIPT_StrChannelLabel_ThisSummer
    DC.L    _SCRIPT_StrChannelLabel_TuesdaysFridays
    DC.L    _SCRIPT_StrChannelLabel_MondaysSaturdays
    DC.L    _SCRIPT_StrChannelLabel_Weekends
    DC.L    _SCRIPT_StrChannelLabel_EveryNight
    DC.L    _SCRIPT_StrChannelLabel_EveryDay
    DC.L    _SCRIPT_ChannelLabelEmptySlot0
    DC.L    _SCRIPT_ChannelLabelEmptySlot1
    DC.L    _SCRIPT_ChannelLabelEmptySlot2
    DC.L    _SCRIPT_ChannelLabelEmptySlot3
    DC.L    _SCRIPT_StrChannelLabel_MondaysThruSaturdays
    DC.L    _SCRIPT_StrChannelLabel_MondaysThruThursdays
    DC.L    _SCRIPT_StrChannelLabel_WeekdayMornings
    DC.L    _SCRIPT_StrChannelLabel_WeekdayAfternoons
    DC.L    _SCRIPT_StrChannelLabel_TuesdaysThursdays
    DC.L    _SCRIPT_StrChannelLabel_ThisWeek

; Another struct?
_Global_STR_ALIGNED_NOW_SHOWING:
    DC.B    TextAlignCenter,"Now showing",0
_Global_STR_ALIGNED_NEXT_SHOWING:
    DC.B    TextAlignCenter,"Next showing ",0
_Global_STR_ALIGNED_TODAY_AT:
    DC.B    TextAlignCenter,"Today at ",0
_Global_STR_ALIGNED_TOMORROW_AT:
    DC.B    TextAlignCenter,"Tomorrow at ",0
_Global_STR_SHOWTIMES_AND_SINGLE_SPACE:
    NStr    "Showtimes "
_Global_STR_SHOWING_AT_AND_SINGLE_SPACE:
    NStr    "Showing at "
_SCRIPT_StrHoursPluralSuffix:
    DC.B    "hrs ",0
_SCRIPT_StrHourSingularSuffix:
    DC.B    "hr ",0
_SCRIPT_StrMinutesSuffix:
    DC.B    "min)",0
_Global_STR_ALIGNED_TONIGHT_AT:
    DC.B    TextAlignCenter,"Tonight at ",0
_Global_STR_ALIGNED_ON:
    DC.B    TextAlignCenter,"on",0
_Global_STR_ALIGNED_CHANNEL_1:
    NStr2   TextAlignCenter,"Channel "
_SCRIPT_StrSportsOnPrefix:
    NStr    "Sports on "
_SCRIPT_PtrSportsOnPrefix:
    DC.L    _SCRIPT_StrSportsOnPrefix
_SCRIPT_StrMovieSummaryForPrefix:
    NStr    "Movie Summary for "
_SCRIPT_PtrMovieSummaryForPrefix:
    DC.L    _SCRIPT_StrMovieSummaryForPrefix
_SCRIPT_StrSummaryOfPrefix:
    NStr    "Summary of "
_SCRIPT_PtrSummaryOfPrefix:
    DC.L    _SCRIPT_StrSummaryOfPrefix
_SCRIPT_StrChannelSuffix:
    NStr    " channel "
_SCRIPT_PtrChannelSuffix:
    DC.L    _SCRIPT_StrChannelSuffix
_SCRIPT_StrNoDataPlaceholder:
    NStr    "No Data."
_SCRIPT_PtrNoDataPlaceholder:
    DC.L    _SCRIPT_StrNoDataPlaceholder
_Global_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION:
    NStr    "Please Stand By for your Local Listings.  ER007"
_Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION:
    DC.L    _Global_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION
_Global_STR_OFF_AIR_1:
    NStr    "Off Air."
_SCRIPT_PtrOffAirPlaceholder:
    DC.L    _Global_STR_OFF_AIR_1
_Global_STR_GRID_DATE_FORMAT_STRING:
    NStr    "%s %s %ld %04ld"
_Global_STR_WEATHER_UPDATE_FOR:
    NStr    "Weather Update for "
;------------------------------------------------------------------------------
; SYM: _SCRIPT_CtrlHandshakeStage/_SCRIPT_CtrlHandshakeRetryCount/_SCRIPT_RuntimeModeDispatchLatch/_SCRIPT_CtrlCmdDeferCounter/_SCRIPT_PlaybackFallbackCounter/_SCRIPT_Type20SubtypeCache   (script ctrl/runtime state cluster)
; TYPE: u16/u16/u16/u16/u16/u16
; PURPOSE: Tracks CTRL handshake/retry/dispatch state and cached subtype in runtime command processing.
; USED BY: _SCRIPT_UpdateCtrlStateMachine, _SCRIPT_HandleBrushCommand, _SCRIPT_ProcessCtrlContextPlaybackTick, _ESQFUNC_DrawDiagnosticsScreen
; NOTES:
;   `_SCRIPT_Type20SubtypeCache` semantics are still partially inferred from P_TYPE type-20 helper flows.
;------------------------------------------------------------------------------
_SCRIPT_CtrlHandshakeStage:
    DS.W    1
_SCRIPT_CtrlHandshakeRetryCount:
    DS.W    1
_SCRIPT_RuntimeModeDispatchLatch:
    DS.W    1
_SCRIPT_CtrlCmdDeferCounter:
    DS.W    1
_SCRIPT_PlaybackFallbackCounter:
    DS.W    1
_SCRIPT_Type20SubtypeCache:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _SCRIPT_PendingBannerTargetChar/_SCRIPT_BannerTransitionActive   (banner transition control)
; TYPE: s16/u16
; PURPOSE: Stores a deferred banner-char target and whether a transition is currently active.
; USED BY: _SCRIPT_BeginBannerCharTransition, _SCRIPT_UpdateBannerCharTransition, _SCRIPT_ApplyPendingBannerTarget
; NOTES: `_SCRIPT_PendingBannerTargetChar` uses sentinels (-2 = one-shot staged value, -1 = none pending).
;------------------------------------------------------------------------------
_SCRIPT_PendingBannerTargetChar:
    DC.W    $ffff
_SCRIPT_PendingBannerSpeedMs:
    DS.W    1
_SCRIPT_BannerTransitionStepBudget:
    DS.W    1
_SCRIPT_BannerTransitionActive:
    DS.W    1
_SCRIPT_ReadModeActiveLatch:
    DS.W    1
; Brush pointers exposed to scripting (primary/secondary selections).
_BRUSH_ScriptPrimarySelection:
    DS.L    1
_BRUSH_ScriptSecondarySelection:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _SCRIPT_RuntimeModeDeferredFlag/_SCRIPT_PendingWeatherCommandChar/_SCRIPT_PendingTextdispCmdChar/_SCRIPT_PendingTextdispCmdArg   (deferred command payload cluster)
; TYPE: u32/u8/u8/u16
; PURPOSE: Holds deferred runtime-mode and pending command bytes consumed by weather/TEXTDISP dispatch paths.
; USED BY: _SCRIPT_HandleBrushCommand, _SCRIPT_ProcessCtrlContextPlaybackTick, _SCRIPT_LoadCtrlContextSnapshot, _SCRIPT_SaveCtrlContextSnapshot, _ESQIFF2_ApplyIncomingStatusPacket
; NOTES: Command chars/arg are serialized into CTRL context at offsets +437..+439.
;------------------------------------------------------------------------------
_SCRIPT_RuntimeModeDeferredFlag:
    DS.L    1
_SCRIPT_PendingWeatherCommandChar:
    DC.B    "x"
_SCRIPT_PendingTextdispCmdChar:
    DS.B    1
_SCRIPT_PendingTextdispCmdArg:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _SCRIPT_CommandTextPtr   (owned script command text pointer)
; TYPE: pointer
; PURPOSE: Stores heap-owned text payload used by TEXTDISP command dispatch (`cmd 'C'` path).
; USED BY: _SCRIPT_HandleBrushCommand, _SCRIPT_LoadCtrlContextSnapshot, _SCRIPT_SaveCtrlContextSnapshot, _TEXTDISP_HandleScriptCommand
; NOTES: Updated through _ESQPARS_ReplaceOwnedString; source commonly comes from
;   _SCRIPT_CTRL_CMD_BUFFER tail (`LEA 3(A2),A0`) after parser NUL-termination.
;------------------------------------------------------------------------------
_SCRIPT_CommandTextPtr:
    DS.L    1
_SCRIPT_BannerTransitionStepCursor:
    DS.W    1
_SCRIPT_StatusMaskRefreshPending:
    DS.W    1
_SCRIPT_BrushTag_Default00_Primary:
    NStr    "00"
_SCRIPT_BrushTag_Default00_Secondary:
    NStr    "00"
_SCRIPT_BrushTag_Clear11_Primary:
    NStr    "11"
_SCRIPT_BrushTag_Clear11_Secondary:
    NStr    "11"
_SCRIPT_Tag_YL:
    NStr    "yl"
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _TEXTDISP_SourceConfigFlagMask   (source-config aggregate flag mask)
; TYPE: u16
; PURPOSE: Accumulates SourceCfg feature flags while loading/applying source config entries.
; USED BY: _TEXTDISP_LoadSourceConfig, _TEXTDISP_ClearSourceConfig, _TEXTDISP_ApplySourceConfigToEntry, _TEXTDISP_AddSourceConfigEntry
; NOTES: Updated by OR-ing per-entry flags.
;------------------------------------------------------------------------------
_TEXTDISP_SourceConfigFlagMask:
    DS.W    1
_Global_STR_PREVUESPORTS:
    NStr    "PrevueSports"
_TEXTDISP_PtrPrevueSportsTag:
    DC.L    _Global_STR_PREVUESPORTS
_SCRIPT_AlignedPrefixEmptyA:
    NStr    TextAlignCenter
_SCRIPT_AlignedPrefixEmptyB:
    NStr    TextAlignCenter
_SCRIPT_SpacerTripleA:
    NStr    "   "
_SCRIPT_AlignedChannelAbbrevPrefix:
    NStr2   TextAlignCenter,"Ch. "
_SCRIPT_SpacerTripleB:
    NStr    "   "
_SCRIPT_AlignedCharFormat:
    NStr2   TextAlignCenter,"%c"
_SCRIPT_AlignedPrefixEmptyC:
    NStr    TextAlignCenter
_SCRIPT_AlignedPrefixEmptyD:
    NStr    TextAlignCenter
_SCRIPT_SpacerTripleC:
    NStr    "   "
_SCRIPT_AlignedPrefixEmptyE:
    NStr    TextAlignCenter
_SCRIPT_AlignedPrefixEmptyF:
    NStr    TextAlignCenter
_SCRIPT_AlignedStringFormat:
    NStr2   TextAlignCenter,"%s"
_SCRIPT_StrAtSeparator:
    NStr    " at "
_SCRIPT_StrVsDotSeparator:
    NStr    " vs. "
_SCRIPT_StrVsSeparator:
    NStr    " vs "
_SCRIPT_AlignedPrefixEmptyG:
    NStr    TextAlignCenter
_Global_STR_ALIGNED_CHANNEL_2:
    NStr2   TextAlignCenter,"Channel "
;------------------------------------------------------------------------------
; SYM: _TEXTDISP_FilterModeId   (text-display filter mode id)
; TYPE: u8 (stored in word slot)
; PURPOSE: Active mode selector for TEXTDISP filter/search passes.
; USED BY: _TEXTDISP_FilterAndSelectEntry
; NOTES: Observed values cycle through 1..3.
;------------------------------------------------------------------------------
_TEXTDISP_FilterModeId:
    DC.W    $0300
_SCRIPT_FilterTag_PPV:
    NStr    "PPV"
_SCRIPT_FilterTag_SBE:
    NStr    "SBE"
_SCRIPT_FilterTag_SPORTS:
    NStr    "SPORTS"
;------------------------------------------------------------------------------
; SYM: _TEXTDISP_LastDispatchMatchIndex/_TEXTDISP_LastDispatchGroupId/_TEXTDISP_CommandBufferPtr/_TEXTDISP_CommandPrefixFormat   (textdisp dispatch scratch cluster)
; TYPE: s16/u8/pointer/cstring
; PURPOSE: Stores last dispatch selection/group and temporary command-buffer state for TEXTDISP command handling.
; USED BY: _TEXTDISP_HandleScriptCommand
; NOTES: Command prefix format currently emits `xx%s` into local scratch before lookup/dispatch.
;------------------------------------------------------------------------------
_TEXTDISP_LastDispatchMatchIndex:
    DC.W    $ffff