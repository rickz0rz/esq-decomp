    XDEF    _Global_STR_PARSEINI_C_1
    XDEF    _PARSEINI_DelimSpaceTab_Section2
    XDEF    _PARSEINI_DelimSpaceTab_Section4_5
    XDEF    _PARSEINI_DelimSpaceTab_Section6
    XDEF    _PARSEINI_DelimSpaceTab_Section7
    XDEF    _PARSEINI_DelimSpaceTab_Section8
    XDEF    _Global_STR_PARSEINI_C_2
    XDEF    _PARSEINI_CurrentRangeTableIndex
    XDEF    _PARSEINI_DelimSpaceTab_RangeKey
    XDEF    _PARSEINI_DelimSpaceSemicolonTab_RangeValue
    XDEF    _PARSEINI_TAG_TABLE
    XDEF    _PARSEINI_TAG_DONE
    XDEF    _PARSEINI_TAG_COLOR
    XDEF    _PARSEINI_CurrentWeatherBlockTempPtr
    XDEF    _PARSEINI_TAG_FILENAME_WeatherBlock
    XDEF    _PARSEINI_STR_LOADCOLOR
    XDEF    _PARSEINI_TAG_ALL
    XDEF    _PARSEINI_TAG_NONE
    XDEF    _PARSEINI_TAG_TEXT
    XDEF    _PARSEINI_TAG_XPOS
    XDEF    _PARSEINI_TAG_TYPE
    XDEF    _PARSEINI_TAG_DITHER
    XDEF    _PARSEINI_TAG_YPOS
    XDEF    _PARSEINI_TAG_XSOURCE
    XDEF    _PARSEINI_TAG_YSOURCE
    XDEF    _PARSEINI_TAG_SIZEX
    XDEF    _PARSEINI_TAG_SIZEY
    XDEF    _PARSEINI_TAG_SOURCE
    XDEF    _PARSEINI_TAG_PPV
    XDEF    _Global_STR_PARSEINI_C_3
    XDEF    _PARSEINI_STR_HORIZONTAL
    XDEF    _PARSEINI_TAG_RIGHT
    XDEF    _PARSEINI_TAG_CENTER_HorizontalAlign
    XDEF    _PARSEINI_TAG_VERTICAL
    XDEF    _PARSEINI_TAG_BOTTOM
    XDEF    _PARSEINI_TAG_CENTER_VerticalAlign
    XDEF    _PARSEINI_TAG_ID
    XDEF    _PARSEINI_TAG_FILENAME_WeatherString
    XDEF    _PARSEINI_TAG_WEATHER
    XDEF    _PARSEINI_STR_WEATHERCURRENT
    XDEF    _PARSEINI_STR_WEATHERFORECAST
    XDEF    _PARSEINI_STR_BOTTOMLINETAG
    XDEF    _Global_STR_COLOR_PERCENT_D
    XDEF    _Global_STR_PERCENT_S_2
    XDEF    _Global_STR_DF0_GRADIENT_INI_3
    XDEF    _Global_STR_DF0_BANNER_INI_2
    XDEF    _Global_STR_DF0_BANNER_INI_3
    XDEF    _Global_STR_DF0_DEFAULT_INI_2
    XDEF    _Global_STR_DF0_SOURCECFG_INI_1
    XDEF    _Global_STR_LIST_RAM_LOGODIR_TXT_DH2_LOGOS_NOHEAD_QUICK
    XDEF    _PARSEINI_PATH_DF0_COLON_LOGO_DOT_LST
    XDEF    _PARSEINI_STR_RB_LogoListPrimary
    XDEF    _PARSEINI_PATH_RAM_COLON_LOGODIR_DOT_TXT
    XDEF    _PARSEINI_STR_RB_LogoListSecondary
    XDEF    _Global_STR_PARSEINI_C_4
    XDEF    _Global_STR_PARSEINI_C_5
    XDEF    _Global_STR_DELETE_NIL_DH2_LOGOS
    XDEF    _Global_STR_PARSEINI_C_6
    XDEF    _Global_STR_PARSEINI_C_7
    XDEF    _PARSEINI_FallbackClockDataRecord
    XDEF    _Global_STR_DF0_ERR_LOG
    XDEF    _PARSEINI_ClockSecondsSnapshot
    XDEF    _PARSEINI_ClockChangeSampleCounter
    XDEF    _PARSEINI_ClockChangeActiveFlag
    XDEF    _PARSEINI_CtrlHClockSnapshot
    XDEF    _PARSEINI_CtrlHChangeGateCounter
    XDEF    _PARSEINI_CtrlHChangePendingFlag
; ========== PARSEINI.c ==========

_Global_STR_PARSEINI_C_1:
    NStr    "PARSEINI.c"
_PARSEINI_DelimSpaceTab_Section2:
    NStr2   " ",9
_PARSEINI_DelimSpaceTab_Section4_5:
    NStr2   " ",9
_PARSEINI_DelimSpaceTab_Section6:
    NStr2   " ",9
_PARSEINI_DelimSpaceTab_Section7:
    NStr2   " ",9
_PARSEINI_DelimSpaceTab_Section8:
    NStr2   " ",9
_Global_STR_PARSEINI_C_2:
    NStr    "PARSEINI.c"
;------------------------------------------------------------------------------
; SYM: _PARSEINI_CurrentRangeTableIndex   (current TABLE/COLOR range index)
; TYPE: s32
; PURPOSE: Holds the active TABLE/COLOR index while parsing range assignment lines.
; USED BY: _PARSEINI_ParseRangeKeyValue, _PARSEINI_ProcessWeatherBlocks
; NOTES: Sentinel is -1 when no valid index is active.
;------------------------------------------------------------------------------
_PARSEINI_CurrentRangeTableIndex:
    DC.L    $ffffffff
_PARSEINI_DelimSpaceTab_RangeKey:
    NStr2   " ",9
_PARSEINI_DelimSpaceSemicolonTab_RangeValue:
    NStr2   " ;",9
_PARSEINI_TAG_TABLE:
    NStr    "TABLE"
_PARSEINI_TAG_DONE:
    NStr    "DONE"
_PARSEINI_TAG_COLOR:
    NStr    "COLOR"
_PARSEINI_CurrentWeatherBlockTempPtr:
    DS.L    1
_PARSEINI_TAG_FILENAME_WeatherBlock:
    NStr    "FILENAME"
_PARSEINI_STR_LOADCOLOR:
    NStr    "LOADCOLOR"
_PARSEINI_TAG_ALL:
    NStr    "ALL"
_PARSEINI_TAG_NONE:
    NStr    "NONE"
_PARSEINI_TAG_TEXT:
    NStr    "TEXT"
_PARSEINI_TAG_XPOS:
    NStr    "XPOS"
_PARSEINI_TAG_TYPE:
    NStr    "TYPE"
_PARSEINI_TAG_DITHER:
    NStr    "DITHER"
_PARSEINI_TAG_YPOS:
    NStr    "YPOS"
_PARSEINI_TAG_XSOURCE:
    NStr    "XSOURCE"
_PARSEINI_TAG_YSOURCE:
    NStr    "YSOURCE"
_PARSEINI_TAG_SIZEX:
    NStr    "SIZEX"
_PARSEINI_TAG_SIZEY:
    NStr    "SIZEY"
_PARSEINI_TAG_SOURCE:
    NStr    "SOURCE"
_PARSEINI_TAG_PPV:
    NStr    "PPV"
_Global_STR_PARSEINI_C_3:
    NStr    "PARSEINI.c"
_PARSEINI_STR_HORIZONTAL:
    NStr    "HORIZONTAL"
_PARSEINI_TAG_RIGHT:
    NStr    "RIGHT"
_PARSEINI_TAG_CENTER_HorizontalAlign:
    NStr    "CENTER"
_PARSEINI_TAG_VERTICAL:
    NStr    "VERTICAL"
_PARSEINI_TAG_BOTTOM:
    NStr    "BOTTOM"
_PARSEINI_TAG_CENTER_VerticalAlign:
    NStr    "CENTER"
_PARSEINI_TAG_ID:
    NStr    "ID"
_PARSEINI_TAG_FILENAME_WeatherString:
    NStr    "FILENAME"
_PARSEINI_TAG_WEATHER:
    NStr    "WEATHER"
_PARSEINI_STR_WEATHERCURRENT:
    NStr    "WeatherCurrent"
_PARSEINI_STR_WEATHERFORECAST:
    NStr    "WeatherForecast"
_PARSEINI_STR_BOTTOMLINETAG:
    NStr    "BottomLineTag"
_Global_STR_COLOR_PERCENT_D:
    NStr    "COLOR%d"
_Global_STR_PERCENT_S_2:
    NStr    "%s"
_Global_STR_DF0_GRADIENT_INI_3:
    NStr    "df0:Gradient.ini"
_Global_STR_DF0_BANNER_INI_2:
    NStr    "df0:banner.ini"
_Global_STR_DF0_BANNER_INI_3:
    NStr    "df0:banner.ini"
_Global_STR_DF0_DEFAULT_INI_2:
    NStr    "df0:default.ini"
_Global_STR_DF0_SOURCECFG_INI_1:
    NStr    "df0:SourceCfg.ini"
_Global_STR_LIST_RAM_LOGODIR_TXT_DH2_LOGOS_NOHEAD_QUICK:
    NStr    "list >RAM:logodir.txt DH2:LOGOS nohead quick"
_PARSEINI_PATH_DF0_COLON_LOGO_DOT_LST:
    NStr    "df0:logo.lst"
_PARSEINI_STR_RB_LogoListPrimary:
    NStr    "rb"
_PARSEINI_PATH_RAM_COLON_LOGODIR_DOT_TXT:
    NStr    "RAM:logodir.txt"
_PARSEINI_STR_RB_LogoListSecondary:
    NStr    "rb"
_Global_STR_PARSEINI_C_4:
    NStr    "PARSEINI.c"
_Global_STR_PARSEINI_C_5:
    NStr    "PARSEINI.c"
_Global_STR_DELETE_NIL_DH2_LOGOS:
    NStr    "DELETE > NIL: DH2:LOGOS/"
_Global_STR_PARSEINI_C_6:
    NStr    "PARSEINI.c"
_Global_STR_PARSEINI_C_7:
    NStr    "PARSEINI.c"
_PARSEINI_FallbackClockDataRecord:
    DC.L    262144,1986     ; 182 days (262144 / 60 / 24) into 1986?
    DC.L    0,0,0,0,0
_Global_STR_DF0_ERR_LOG:
    NStr    "df0:err.log"
_PARSEINI_ClockSecondsSnapshot:
    DC.W    0
_PARSEINI_ClockChangeSampleCounter:
    DC.W    0
_PARSEINI_ClockChangeActiveFlag:
    DC.W    0
_PARSEINI_CtrlHClockSnapshot:
    DC.W    0
_PARSEINI_CtrlHChangeGateCounter:
    DC.W    0
_PARSEINI_CtrlHChangePendingFlag:
    DC.W    0
