    XDEF    _DST_DefaultDatPathPtr
    XDEF    _DST_FMT_PCT_C_InTimePrefixChar
    XDEF    _DST_FMT_PCT_04D_PCT_03D_InTimeDateCode
    XDEF    _DST_FMT_PCT_02D_COLON_PCT_02D_InTimeClock
    XDEF    _DST_STR_NO_IN_TIME
    XDEF    _DST_FMT_PCT_C_OutTimePrefixChar
    XDEF    _DST_FMT_PCT_04D_PCT_03D_OutTimeDateCode
    XDEF    _DST_FMT_PCT_02D_COLON_PCT_02D_OutTimeClock
    XDEF    _DST_STR_NO_OUT_TIME
    XDEF    _DST_STR_NO_DST_DATA
    XDEF    _DST_STR_G2_COLON
    XDEF    _DST_STR_G3_COLON
    XDEF    _Global_STR_DST_C_1
    XDEF    _Global_STR_DST_C_2
    XDEF    _Global_STR_DST_C_3
    XDEF    _Global_STR_DST_C_4
    XDEF    _Global_STR_DST_C_5
    XDEF    _Global_STR_DST_C_6
    XDEF    _Global_STR_G2
    XDEF    _Global_STR_G3
    XDEF    _Global_STR_DST_C_7
    XDEF    _DST_FMT_PCT_S_COLON_PCT_S_PCT_S_PCT_02D_PCT_
    XDEF    _DST_TAG_PM
    XDEF    _DST_TAG_AM
    XDEF    _DST_TAG_DST
    XDEF    _DST_TAG_STD
    XDEF    _DST_STR_LEAP_YEAR
    XDEF    _DST_STR_NORM_YEAR
; ========== DST.c ==========
_DST_PATH_DF0_COLON_DST_DOT_DAT:
    NStr    "df0:dst.dat"
_DST_DefaultDatPathPtr:
    DC.L    _DST_PATH_DF0_COLON_DST_DOT_DAT
_DST_FMT_PCT_C_InTimePrefixChar:
    NStr    "%c"
_DST_FMT_PCT_04D_PCT_03D_InTimeDateCode:
    NStr    "%04d%03d"
_DST_FMT_PCT_02D_COLON_PCT_02D_InTimeClock:
    NStr    "%02d:%02d"
_DST_STR_NO_IN_TIME:
    NStr    " NO IN TIME "
_DST_FMT_PCT_C_OutTimePrefixChar:
    NStr    "%c"
_DST_FMT_PCT_04D_PCT_03D_OutTimeDateCode:
    NStr    "%04d%03d"
_DST_FMT_PCT_02D_COLON_PCT_02D_OutTimeClock:
    NStr    "%02d:%02d"
_DST_STR_NO_OUT_TIME:
    NStr    " NO OUT TIME "
_DST_STR_NO_DST_DATA:
    NStr    " NO DST DATA "
_DST_STR_G2_COLON:
    NStr    " g2:"
_DST_STR_G3_COLON:
    NStr    " g3:"
_Global_STR_DST_C_1:
    NStr    "DST.c"
_Global_STR_DST_C_2:
    NStr    "DST.c"
_Global_STR_DST_C_3:
    NStr    "DST.c"
_Global_STR_DST_C_4:
    NStr    "DST.c"
_Global_STR_DST_C_5:
    NStr    "DST.c"
_Global_STR_DST_C_6:
    NStr    "DST.c"
_Global_STR_G2:
    NStr    "g2"
_Global_STR_G3:
    NStr    "g3"
_Global_STR_DST_C_7:
    NStr    "DST.c"
_DST_FMT_PCT_S_COLON_PCT_S_PCT_S_PCT_02D_PCT_:
    NStr2   "%s:  %s%s%02d, '%d (%03d) %2d:%02d:%02d %s %s %s",TextLineFeed
_DST_TAG_PM:
    NStr    "PM"
_DST_TAG_AM:
    NStr    "AM"
_DST_TAG_DST:
    NStr    "DST"
_DST_TAG_STD:
    NStr    "STD"
_DST_STR_LEAP_YEAR:
    NStr    "Leap Year"
_DST_STR_NORM_YEAR:
    NStr    "Norm Year"
    DS.W    1