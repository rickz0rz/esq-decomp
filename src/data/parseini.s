; ========== PARSEINI.c ==========

Global_STR_PARSEINI_C_1:
    NStr    "PARSEINI.c"
PARSEINI_DelimSpaceTab_Section2:
    NStr2   " ",9
PARSEINI_DelimSpaceTab_Section4_5:
    NStr2   " ",9
PARSEINI_DelimSpaceTab_Section6:
    NStr2   " ",9
PARSEINI_DelimSpaceTab_Section7:
    NStr2   " ",9
PARSEINI_DelimSpaceTab_Section8:
    NStr2   " ",9
Global_STR_PARSEINI_C_2:
    NStr    "PARSEINI.c"
;------------------------------------------------------------------------------
; SYM: PARSEINI_CurrentRangeTableIndex   (current TABLE/COLOR range index)
; TYPE: s32
; PURPOSE: Holds the active TABLE/COLOR index while parsing range assignment lines.
; USED BY: PARSEINI_ParseRangeKeyValue, PARSEINI_ProcessWeatherBlocks
; NOTES: Sentinel is -1 when no valid index is active.
;------------------------------------------------------------------------------
PARSEINI_CurrentRangeTableIndex:
    DC.L    $ffffffff
PARSEINI_DelimSpaceTab_RangeKey:
    NStr2   " ",9
PARSEINI_DelimSpaceSemicolonTab_RangeValue:
    NStr2   " ;",9
PARSEINI_TAG_TABLE:
    NStr    "TABLE"
PARSEINI_TAG_DONE:
    NStr    "DONE"
PARSEINI_TAG_COLOR:
    NStr    "COLOR"
PARSEINI_CurrentWeatherBlockTempPtr:
    DS.L    1
PARSEINI_TAG_FILENAME_WeatherBlock:
    NStr    "FILENAME"
PARSEINI_STR_LOADCOLOR:
    NStr    "LOADCOLOR"
PARSEINI_TAG_ALL:
    NStr    "ALL"
PARSEINI_TAG_NONE:
    NStr    "NONE"
PARSEINI_TAG_TEXT:
    NStr    "TEXT"
PARSEINI_TAG_XPOS:
    NStr    "XPOS"
PARSEINI_TAG_TYPE:
    NStr    "TYPE"
PARSEINI_TAG_DITHER:
    NStr    "DITHER"
PARSEINI_TAG_YPOS:
    NStr    "YPOS"
PARSEINI_TAG_XSOURCE:
    NStr    "XSOURCE"
PARSEINI_TAG_YSOURCE:
    NStr    "YSOURCE"
PARSEINI_TAG_SIZEX:
    NStr    "SIZEX"
PARSEINI_TAG_SIZEY:
    NStr    "SIZEY"
PARSEINI_TAG_SOURCE:
    NStr    "SOURCE"
PARSEINI_TAG_PPV:
    NStr    "PPV"
Global_STR_PARSEINI_C_3:
    NStr    "PARSEINI.c"
PARSEINI_STR_HORIZONTAL:
    NStr    "HORIZONTAL"
PARSEINI_TAG_RIGHT:
    NStr    "RIGHT"
PARSEINI_TAG_CENTER_HorizontalAlign:
    NStr    "CENTER"
PARSEINI_TAG_VERTICAL:
    NStr    "VERTICAL"
PARSEINI_TAG_BOTTOM:
    NStr    "BOTTOM"
PARSEINI_TAG_CENTER_VerticalAlign:
    NStr    "CENTER"
PARSEINI_TAG_ID:
    NStr    "ID"
PARSEINI_TAG_FILENAME_WeatherString:
    NStr    "FILENAME"
PARSEINI_TAG_WEATHER:
    NStr    "WEATHER"
PARSEINI_STR_WEATHERCURRENT:
    NStr    "WeatherCurrent"
PARSEINI_STR_WEATHERFORECAST:
    NStr    "WeatherForecast"
PARSEINI_STR_BOTTOMLINETAG:
    NStr    "BottomLineTag"
Global_STR_COLOR_PERCENT_D:
    NStr    "COLOR%d"
Global_STR_PERCENT_S_2:
    NStr    "%s"
Global_STR_DF0_GRADIENT_INI_3:
    NStr    "df0:Gradient.ini"
Global_STR_DF0_BANNER_INI_2:
    NStr    "df0:banner.ini"
Global_STR_DF0_BANNER_INI_3:
    NStr    "df0:banner.ini"
Global_STR_DF0_DEFAULT_INI_2:
    NStr    "df0:default.ini"
Global_STR_DF0_SOURCECFG_INI_1:
    NStr    "df0:SourceCfg.ini"
Global_STR_LIST_RAM_LOGODIR_TXT_DH2_LOGOS_NOHEAD_QUICK:
    NStr    "list >RAM:logodir.txt DH2:LOGOS nohead quick"
PARSEINI_PATH_DF0_COLON_LOGO_DOT_LST:
    NStr    "df0:logo.lst"
PARSEINI_STR_RB_LogoListPrimary:
    NStr    "rb"
PARSEINI_PATH_RAM_COLON_LOGODIR_DOT_TXT:
    NStr    "RAM:logodir.txt"
PARSEINI_STR_RB_LogoListSecondary:
    NStr    "rb"
Global_STR_PARSEINI_C_4:
    NStr    "PARSEINI.c"
Global_STR_PARSEINI_C_5:
    NStr    "PARSEINI.c"
Global_STR_DELETE_NIL_DH2_LOGOS:
    NStr    "DELETE > NIL: DH2:LOGOS/"
Global_STR_PARSEINI_C_6:
    NStr    "PARSEINI.c"
Global_STR_PARSEINI_C_7:
    NStr    "PARSEINI.c"
PARSEINI_FallbackClockDataRecord:
    DC.L    262144,1986     ; 182 days (262144 / 60 / 24) into 1986?
    DC.L    0,0,0,0,0
Global_STR_DF0_ERR_LOG:
    NStr    "df0:err.log"
PARSEINI_ClockSecondsSnapshot:
    DC.W    0
PARSEINI_ClockChangeSampleCounter:
    DC.W    0
PARSEINI_ClockChangeActiveFlag:
    DC.W    0
PARSEINI_CtrlHClockSnapshot:
    DC.W    0
PARSEINI_CtrlHChangeGateCounter:
    DC.W    0
PARSEINI_CtrlHChangePendingFlag:
    DC.W    0
