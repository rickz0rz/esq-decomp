; ========== SCRIPT.c ==========

Global_STR_SCRIPT_C_1:
    NStr    "SCRIPT.c"
Global_STR_SCRIPT_C_2:
    NStr    "SCRIPT.c"
DATA_SCRIPT_BSS_LONG_20AB:
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
DATA_SCRIPT_STR_NO_FORECAST_WEATHER_DATA_AVAILABLE_20AF:
    NStr    "No Forecast Weather Data Available"
DATA_SCRIPT_CONST_LONG_20B0:
    DC.L    DATA_SCRIPT_STR_NO_FORECAST_WEATHER_DATA_AVAILABLE_20AF
DATA_SCRIPT_STR_MAY_NOT_BE_AVAILABLE_IN_ALL_AREAS_DO_20B1:
    NStr    "May not be available in all areas."
DATA_SCRIPT_CONST_LONG_20B2:
    DC.L    DATA_SCRIPT_STR_MAY_NOT_BE_AVAILABLE_IN_ALL_AREAS_DO_20B1
DATA_SCRIPT_STR_CONTINUED_20B3:
    NStr    "Continued"
    DC.L    DATA_SCRIPT_STR_CONTINUED_20B3

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

DATA_SCRIPT_STR_JAN_20C1:
    NStr    "Jan "
DATA_SCRIPT_STR_FEB_20C2:
    NStr    "Feb "
DATA_SCRIPT_STR_MAR_20C3:
    NStr    "Mar "
DATA_SCRIPT_STR_APR_20C4:
    NStr    "Apr "
DATA_SCRIPT_STR_MAY_20C5:
    NStr    "May "
DATA_SCRIPT_STR_JUN_20C6:
    NStr    "Jun "
DATA_SCRIPT_STR_JUL_20C7:
    NStr    "Jul "
DATA_SCRIPT_STR_AUG_20C8:
    NStr    "Aug "
DATA_SCRIPT_STR_SEP_20C9:
    NStr    "Sep "
DATA_SCRIPT_STR_OCT_20CA:
    NStr    "Oct "
DATA_SCRIPT_STR_NOV_20CB:
    NStr    "Nov "
DATA_SCRIPT_STR_DEC_20CC:
    NStr    "Dec "

Global_JMPTBL_SHORT_MONTHS:
    DC.L    DATA_SCRIPT_STR_JAN_20C1
    DC.L    DATA_SCRIPT_STR_FEB_20C2
    DC.L    DATA_SCRIPT_STR_MAR_20C3
    DC.L    DATA_SCRIPT_STR_APR_20C4
    DC.L    DATA_SCRIPT_STR_MAY_20C5
    DC.L    DATA_SCRIPT_STR_JUN_20C6
    DC.L    DATA_SCRIPT_STR_JUL_20C7
    DC.L    DATA_SCRIPT_STR_AUG_20C8
    DC.L    DATA_SCRIPT_STR_SEP_20C9
    DC.L    DATA_SCRIPT_STR_OCT_20CA
    DC.L    DATA_SCRIPT_STR_NOV_20CB
    DC.L    DATA_SCRIPT_STR_DEC_20CC

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

DATA_SCRIPT_STR_SUN_20D6:
    NStr    "Sun "
DATA_SCRIPT_STR_MON_20D7:
    NStr    "Mon "
DATA_SCRIPT_STR_TUE_20D8:
    NStr    "Tue "
DATA_SCRIPT_STR_WED_20D9:
    NStr    "Wed "
DATA_SCRIPT_STR_THU_20DA:
    NStr    "Thu "
DATA_SCRIPT_STR_FRI_20DB:
    NStr    "Fri "
DATA_SCRIPT_STR_SAT_20DC:
    NStr    "Sat "
Global_JMPTBL_SHORT_DAYS_OF_WEEK:
    DC.L    DATA_SCRIPT_STR_SUN_20D6
    DC.L    DATA_SCRIPT_STR_MON_20D7
    DC.L    DATA_SCRIPT_STR_TUE_20D8
    DC.L    DATA_SCRIPT_STR_WED_20D9
    DC.L    DATA_SCRIPT_STR_THU_20DA
    DC.L    DATA_SCRIPT_STR_FRI_20DB
    DC.L    DATA_SCRIPT_STR_SAT_20DC
DATA_SCRIPT_STR_MONDAY_20DE:
    NStr    "Monday"
DATA_SCRIPT_STR_TUESDAY_20DF:
    NStr    "Tuesday"
DATA_SCRIPT_STR_WEDNESDAY_20E0:
    NStr    "Wednesday"
DATA_SCRIPT_STR_THURSDAY_20E1:
    NStr    "Thursday"
DATA_SCRIPT_STR_FRIDAY_20E2:
    NStr    "Friday"
DATA_SCRIPT_STR_SATURDAY_20E3:
    NStr    "Saturday"
DATA_SCRIPT_STR_SUNDAY_20E4:
    NStr    "Sunday"
DATA_SCRIPT_STR_WEEKDAYS_20E5:
    NStr    "Weekdays"
DATA_SCRIPT_STR_WEEKNIGHTS_20E6:
    NStr    "Weeknights"
DATA_SCRIPT_STR_COMING_SOON_20E7:
    NStr    "Coming Soon"
DATA_SCRIPT_STR_THIS_MONTH_20E8:
    NStr    "This Month"
DATA_SCRIPT_STR_NEXT_MONTH_20E9:
    NStr    "Next Month"
DATA_SCRIPT_STR_THIS_FALL_20EA:
    NStr    "This Fall"
DATA_SCRIPT_STR_THIS_SUMMER_20EB:
    NStr    "This Summer"
;------------------------------------------------------------------------------
; SYM: SCRIPT_ChannelLabelLegacyIndexAnchor   (legacy channel-label index anchor)
; TYPE: cstring
; PURPOSE: Historical anchor used by `index * 4` address math in legacy callsites.
; USED BY: CLEANUP3/Textdisp channel-label lookups.
; NOTES: Anchor label only; pointer-table base is SCRIPT_ChannelLabelPtrTable.
;------------------------------------------------------------------------------
SCRIPT_ChannelLabelLegacyIndexAnchor:
    NStr    "Tuesdays & Fridays"
DATA_SCRIPT_STR_MONDAYS_SATURDAYS_20EE:
    NStr    "Mondays & Saturdays"
DATA_SCRIPT_STR_WEEKENDS_20EF:
    NStr    "Weekends"
DATA_SCRIPT_STR_EVERY_NIGHT_20F0:
    NStr    "Every Night"
DATA_SCRIPT_STR_EVERY_DAY_20F1:
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
DATA_SCRIPT_BSS_WORD_20F2:
    DS.W    1
SCRIPT_ChannelLabelEmptySlot1:
DATA_SCRIPT_BSS_WORD_20F3:
    DS.W    1
SCRIPT_ChannelLabelEmptySlot2:
DATA_SCRIPT_BSS_WORD_20F4:
    DS.W    1
SCRIPT_ChannelLabelEmptySlot3:
DATA_SCRIPT_BSS_WORD_20F5:
    DS.W    1
DATA_SCRIPT_STR_MONDAYS_THRU_SATURDAYS_20F6:
    NStr    "Mondays thru Saturdays"
DATA_SCRIPT_STR_MONDAYS_THRU_THURSDAYS_20F7:
    NStr    "Mondays thru Thursdays"
DATA_SCRIPT_STR_WEEKDAY_MORNINGS_20F8:
    NStr    "Weekday Mornings"
DATA_SCRIPT_STR_WEEKDAY_AFTERNOONS_20F9:
    NStr    "Weekday Afternoons"
DATA_SCRIPT_STR_TUESDAYS_THURSDAYS_20FA:
    NStr    "Tuesdays & Thursdays"
DATA_SCRIPT_STR_THIS_WEEK_20FB:
    NStr    "This Week"
;------------------------------------------------------------------------------
; SYM: SCRIPT_ChannelLabelPtrTable   (channel label pointer table)
; TYPE: array<u32 ptr>
; PURPOSE: Maps channel/group selector values to label strings for append paths.
; USED BY: CLEANUP3/Textdisp routines that index from SCRIPT_ChannelLabelLegacyIndexAnchor.
; NOTES:
;   Legacy callsites index relative to SCRIPT_ChannelLabelLegacyIndexAnchor.
;   Entries 19..22 intentionally point at zeroed empty-slot placeholders.
;------------------------------------------------------------------------------
SCRIPT_ChannelLabelPtrTable:
    DC.L    DATA_SCRIPT_STR_MONDAY_20DE
    DC.L    DATA_SCRIPT_STR_TUESDAY_20DF
    DC.L    DATA_SCRIPT_STR_WEDNESDAY_20E0
    DC.L    DATA_SCRIPT_STR_THURSDAY_20E1
    DC.L    DATA_SCRIPT_STR_FRIDAY_20E2
    DC.L    DATA_SCRIPT_STR_SATURDAY_20E3
    DC.L    DATA_SCRIPT_STR_SUNDAY_20E4
    DC.L    DATA_SCRIPT_STR_WEEKDAYS_20E5
    DC.L    DATA_SCRIPT_STR_WEEKNIGHTS_20E6
    DC.L    DATA_SCRIPT_STR_COMING_SOON_20E7
    DC.L    DATA_SCRIPT_STR_THIS_MONTH_20E8
    DC.L    DATA_SCRIPT_STR_NEXT_MONTH_20E9
    DC.L    DATA_SCRIPT_STR_THIS_FALL_20EA
    DC.L    DATA_SCRIPT_STR_THIS_SUMMER_20EB
    DC.L    SCRIPT_ChannelLabelLegacyIndexAnchor
    DC.L    DATA_SCRIPT_STR_MONDAYS_SATURDAYS_20EE
    DC.L    DATA_SCRIPT_STR_WEEKENDS_20EF
    DC.L    DATA_SCRIPT_STR_EVERY_NIGHT_20F0
    DC.L    DATA_SCRIPT_STR_EVERY_DAY_20F1
    DC.L    DATA_SCRIPT_BSS_WORD_20F2
    DC.L    DATA_SCRIPT_BSS_WORD_20F3
    DC.L    DATA_SCRIPT_BSS_WORD_20F4
    DC.L    DATA_SCRIPT_BSS_WORD_20F5
    DC.L    DATA_SCRIPT_STR_MONDAYS_THRU_SATURDAYS_20F6
    DC.L    DATA_SCRIPT_STR_MONDAYS_THRU_THURSDAYS_20F7
    DC.L    DATA_SCRIPT_STR_WEEKDAY_MORNINGS_20F8
    DC.L    DATA_SCRIPT_STR_WEEKDAY_AFTERNOONS_20F9
    DC.L    DATA_SCRIPT_STR_TUESDAYS_THURSDAYS_20FA
    DC.L    DATA_SCRIPT_STR_THIS_WEEK_20FB

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
DATA_SCRIPT_STR_HRS_2102:
    DC.B    "hrs ",0
DATA_SCRIPT_STR_HR_2103:
    DC.B    "hr ",0
DATA_SCRIPT_STR_MIN_2104:
    DC.B    "min)",0
Global_STR_ALIGNED_TONIGHT_AT:
    DC.B    TextAlignCenter,"Tonight at ",0
Global_STR_ALIGNED_ON:
    DC.B    TextAlignCenter,"on",0
Global_STR_ALIGNED_CHANNEL_1:
    NStr2   TextAlignCenter,"Channel "
DATA_SCRIPT_STR_SPORTS_ON_2108:
    NStr    "Sports on "
DATA_SCRIPT_CONST_LONG_2109:
    DC.L    DATA_SCRIPT_STR_SPORTS_ON_2108
DATA_SCRIPT_STR_MOVIE_SUMMARY_FOR_210A:
    NStr    "Movie Summary for "
DATA_SCRIPT_CONST_LONG_210B:
    DC.L    DATA_SCRIPT_STR_MOVIE_SUMMARY_FOR_210A
DATA_SCRIPT_STR_SUMMARY_OF_210C:
    NStr    "Summary of "
DATA_SCRIPT_CONST_LONG_210D:
    DC.L    DATA_SCRIPT_STR_SUMMARY_OF_210C
DATA_SCRIPT_STR_CHANNEL_210E:
    NStr    " channel "
DATA_SCRIPT_CONST_LONG_210F:
    DC.L    DATA_SCRIPT_STR_CHANNEL_210E
DATA_SCRIPT_STR_NO_DATA_DOT_2110:
    NStr    "No Data."
DATA_SCRIPT_CONST_LONG_2111:
    DC.L    DATA_SCRIPT_STR_NO_DATA_DOT_2110
Global_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION:
    NStr    "Please Stand By for your Local Listings.  ER007"
Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION:
    DC.L    Global_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION
Global_STR_OFF_AIR_1:
    NStr    "Off Air."
DATA_SCRIPT_CONST_LONG_2115:
    DC.L    Global_STR_OFF_AIR_1
Global_STR_GRID_DATE_FORMAT_STRING:
    NStr    "%s %s %ld %04ld"
Global_STR_WEATHER_UPDATE_FOR:
    NStr    "Weather Update for "
DATA_SCRIPT_BSS_WORD_2118:
    DS.W    1
DATA_SCRIPT_BSS_WORD_2119:
    DS.W    1
DATA_SCRIPT_BSS_WORD_211A:
    DS.W    1
DATA_SCRIPT_BSS_WORD_211B:
    DS.W    1
DATA_SCRIPT_BSS_WORD_211C:
    DS.W    1
DATA_SCRIPT_BSS_WORD_211D:
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
DATA_SCRIPT_BSS_WORD_211F:
    DS.W    1
DATA_SCRIPT_BSS_WORD_2120:
    DS.W    1
SCRIPT_BannerTransitionActive:
    DS.W    1
DATA_SCRIPT_BSS_WORD_2122:
    DS.W    1
; Brush pointers exposed to scripting (primary/secondary selections).
BRUSH_ScriptPrimarySelection:
    DS.L    1
BRUSH_ScriptSecondarySelection:
    DS.L    1
DATA_SCRIPT_BSS_LONG_2125:
    DS.L    1
DATA_SCRIPT_STR_X_2126:
    DC.B    "x"
DATA_SCRIPT_BSS_BYTE_2127:
    DS.B    1
DATA_SCRIPT_BSS_WORD_2128:
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
DATA_SCRIPT_BSS_LONG_2129:
    DS.L    1
DATA_SCRIPT_BSS_WORD_212A:
    DS.W    1
DATA_SCRIPT_BSS_WORD_212B:
    DS.W    1
DATA_SCRIPT_TAG_00_212C:
    NStr    "00"
DATA_SCRIPT_TAG_00_212D:
    NStr    "00"
DATA_SCRIPT_TAG_11_212E:
    NStr    "11"
DATA_SCRIPT_TAG_11_212F:
    NStr    "11"
DATA_SCRIPT_STR_YL_2130:
    NStr    "yl"
    DS.W    1
DATA_SCRIPT_BSS_WORD_2131:
    DS.W    1
Global_STR_PREVUESPORTS:
    NStr    "PrevueSports"
DATA_SCRIPT_CONST_LONG_2133:
    DC.L    Global_STR_PREVUESPORTS
DATA_SCRIPT_STR_2134:
    NStr    TextAlignCenter
DATA_SCRIPT_STR_2135:
    NStr    TextAlignCenter
DATA_SCRIPT_SPACE_VALUE_2136:
    NStr    "   "
DATA_SCRIPT_STR_CH_DOT_2137:
    NStr2   TextAlignCenter,"Ch. "
DATA_SCRIPT_SPACE_VALUE_2138:
    NStr    "   "
DATA_SCRIPT_FMT_PCT_C_2139:
    NStr2   TextAlignCenter,"%c"
DATA_SCRIPT_STR_213A:
    NStr    TextAlignCenter
DATA_SCRIPT_STR_213B:
    NStr    TextAlignCenter
DATA_SCRIPT_SPACE_VALUE_213C:
    NStr    "   "
DATA_SCRIPT_STR_213D:
    NStr    TextAlignCenter
DATA_SCRIPT_STR_213E:
    NStr    TextAlignCenter
DATA_SCRIPT_FMT_PCT_S_213F:
    NStr2   TextAlignCenter,"%s"
DATA_SCRIPT_STR_AT_2140:
    NStr    " at "
DATA_SCRIPT_STR_VS_DOT_2141:
    NStr    " vs. "
DATA_SCRIPT_STR_VS_2142:
    NStr    " vs "
DATA_SCRIPT_STR_2143:
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
DATA_SCRIPT_TAG_PPV_2146:
    NStr    "PPV"
DATA_SCRIPT_TAG_SBE_2147:
    NStr    "SBE"
DATA_SCRIPT_TAG_SPORTS_2148:
    NStr    "SPORTS"
DATA_SCRIPT_CONST_WORD_2149:
    DC.W    $ffff
DATA_SCRIPT_CONST_BYTE_214A:
    DC.B    0,"1"
DATA_SCRIPT_BSS_LONG_214B:
    DS.L    1
DATA_SCRIPT_FMT_XX_PCT_S_214C:
    NStr3   "xx%s",18,"TEMPO"
