    XDEF    _Global_STR_ESQIFF_C_1
    XDEF    _ESQIFF_BannerBrushResourceCursor
    XDEF    _ESQIFF_STR_WEATHER
    XDEF    _Global_STR_ESQIFF_C_2
    XDEF    _ESQIFF_WeatherSliceRemainingWidth
    XDEF    _ESQIFF_WeatherSliceSourceOffset
    XDEF    _ESQIFF_WeatherSliceValidateGateFlag
    XDEF    _Global_STR_ESQIFF_C_3
    XDEF    _Global_STR_ESQIFF_C_4
    XDEF    _Global_STR_ESQIFF_C_5
    XDEF    _Global_STR_ESQIFF_C_6
    XDEF    _ESQIFF_PATH_DF0_COLON
    XDEF    _ESQIFF_PATH_RAM_COLON_LOGOS_SLASH
    XDEF    _Global_STR_ESQIFF_C_7
    XDEF    _Global_STR_ESQIFF_C_8
    XDEF    _Global_STR_DF0_BRUSH_INI_2
    XDEF    _ESQIFF_TAG_DT
    XDEF    _ESQIFF_TAG_DITHER
    XDEF    _ESQIFF_FMT_PCT_S_DOT_PCT_LD
    XDEF    _Global_STR_MAJOR_MINOR_VERSION_1
    XDEF    _ESQIFF_STR_INCORRECT_VERSION_PLEASE_CORRECT_ASA
    XDEF    _ESQIFF_FMT_YOUR_VERSION_IS_PCT_S_DOT_PCT_LD
    XDEF    _Global_STR_MAJOR_MINOR_VERSION_2
    XDEF    _ESQIFF_STR_CORRECT_VERSION_IS
    XDEF    _Global_STR_APOSTROPHE
    XDEF    _Global_STR_PLEASE_STANDBY_2
    XDEF    _Global_STR_ATTENTION_SYSTEM_ENGINEER_2
    XDEF    _Global_STR_REPORT_ERROR_CODE_FORMATTED
    XDEF    _Global_STR_FILE_WIDTH_COLORS_FORMATTED
    XDEF    _Global_STR_FILE_PERCENT_S
    XDEF    _Global_STR_PRESS_ESC_TWICE_TO_RESUME_SCROLL
; ========== ESQIFF.c ==========

_Global_STR_ESQIFF_C_1:
    NStr    "ESQIFF.c"
;------------------------------------------------------------------------------
; SYM: _ESQIFF_BannerBrushResourceCursor   (banner brush resource cursor)
; TYPE: pointer (brush resource node)
; PURPOSE: Tracks current node while queuing/weather-rendering banner brush work.
; USED BY: _ESQIFF_QueueIffBrushLoad
; NOTES:
;   Seeded from _PARSEINI_BannerBrushResourceHead and advanced via node +234
;   next-link field when mode does not request cursor hold.
;------------------------------------------------------------------------------
_ESQIFF_BannerBrushResourceCursor:
    DS.L    1
_ESQIFF_STR_WEATHER:
    NStr    "weather"
_Global_STR_ESQIFF_C_2:
    NStr    "ESQIFF.c"
;------------------------------------------------------------------------------
; SYM: _ESQIFF_WeatherSliceRemainingWidth   (weather slice remaining width)
; TYPE: u16
; PURPOSE: Remaining pixel width left to blit for current weather brush slice.
; USED BY: _ESQIFF_RenderWeatherStatusBrushSlice
; NOTES:
;   Initialized from brush width (A2+178), decremented by per-tick slice width.
;------------------------------------------------------------------------------
_ESQIFF_WeatherSliceRemainingWidth:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _ESQIFF_WeatherSliceSourceOffset   (weather slice source offset)
; TYPE: u16
; PURPOSE: Running source-X offset into the weather brush for incremental blits.
; USED BY: _ESQIFF_RenderWeatherStatusBrushSlice
; NOTES:
;   Reset to 0 on slice init; increased by emitted slice width each update.
;------------------------------------------------------------------------------
_ESQIFF_WeatherSliceSourceOffset:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _ESQIFF_WeatherSliceValidateGateFlag   (weather-slice one-shot validation gate)
; TYPE: u8 flag in word storage
; PURPOSE: One-shot guard for _NEWGRID_ValidateSelectionCode trigger in mode 11.
; USED BY: _ESQIFF_RenderWeatherStatusBrushSlice
; NOTES:
;   Accessed with byte operations (set to 1, tested, then cleared once fired).
;------------------------------------------------------------------------------
_ESQIFF_WeatherSliceValidateGateFlag:
    DC.W    $0100
_Global_STR_ESQIFF_C_3:
    NStr    "ESQIFF.c"
_Global_STR_ESQIFF_C_4:
    NStr    "ESQIFF.c"
_Global_STR_ESQIFF_C_5:
    NStr    "ESQIFF.c"
_Global_STR_ESQIFF_C_6:
    NStr    "ESQIFF.c"
_ESQIFF_PATH_DF0_COLON:
    NStr    "df0:"
    NStr    "df0:"
_ESQIFF_PATH_RAM_COLON_LOGOS_SLASH:
    NStr    "ram:logos/ "
    NStr    "ram:logos/ "
_Global_STR_ESQIFF_C_7:
    NStr    "ESQIFF.c"
_Global_STR_ESQIFF_C_8:
    NStr    "ESQIFF.c"
_Global_STR_DF0_BRUSH_INI_2:
    NStr    "df0:brush.ini"
_ESQIFF_TAG_DT:
    NStr    "DT"
_ESQIFF_TAG_DITHER:
    NStr    "DITHER"
_ESQIFF_FMT_PCT_S_DOT_PCT_LD:
    NStr    "%s.%ld"
_Global_STR_MAJOR_MINOR_VERSION_1:
    NStr    "9.0"   ; major/minor version
_ESQIFF_STR_INCORRECT_VERSION_PLEASE_CORRECT_ASA:
    NStr    "Incorrect Version! Please correct ASAP!"
_ESQIFF_FMT_YOUR_VERSION_IS_PCT_S_DOT_PCT_LD:
    NStr    "Your version is    '%s.%ld'"
_Global_STR_MAJOR_MINOR_VERSION_2:
    NStr    "9.0"   ; major/minor version
_ESQIFF_STR_CORRECT_VERSION_IS:
    NStr    "Correct version is '"
_Global_STR_APOSTROPHE:
    NStr    "'"
_Global_STR_PLEASE_STANDBY_2:
    NStr    "Please Standby..."
_Global_STR_ATTENTION_SYSTEM_ENGINEER_2:
    NStr    "ATTENTION SYSTEM ENGINEER!"
_Global_STR_REPORT_ERROR_CODE_FORMATTED:
    NStr    "Report Error Code ER%03d to TV Guide Technical Services."
_Global_STR_FILE_WIDTH_COLORS_FORMATTED:
    NStr    "File='%s'  Width=%d  Colors=%d"
_Global_STR_FILE_PERCENT_S:
    NStr    "File '%s'"
_Global_STR_PRESS_ESC_TWICE_TO_RESUME_SCROLL:
    NStr    "Press ESC key twice to resume scroll"
