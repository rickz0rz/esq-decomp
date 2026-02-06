; ========== DST.c ==========
DATA_DST_PATH_DF0_COLON_DST_DOT_DAT_1CF6:
    NStr    "df0:dst.dat"
DATA_DST_CONST_LONG_1CF7:
    DC.L    DATA_DST_PATH_DF0_COLON_DST_DOT_DAT_1CF6
DATA_DST_FMT_PCT_C_1CF8:
    NStr    "%c"
DATA_DST_FMT_PCT_04D_PCT_03D_1CF9:
    NStr    "%04d%03d"
DATA_DST_FMT_PCT_02D_COLON_PCT_02D_1CFA:
    NStr    "%02d:%02d"
DATA_DST_STR_NO_IN_TIME_1CFB:
    NStr    " NO IN TIME "
DATA_DST_FMT_PCT_C_1CFC:
    NStr    "%c"
DATA_DST_FMT_PCT_04D_PCT_03D_1CFD:
    NStr    "%04d%03d"
DATA_DST_FMT_PCT_02D_COLON_PCT_02D_1CFE:
    NStr    "%02d:%02d"
DATA_DST_STR_NO_OUT_TIME_1CFF:
    NStr    " NO OUT TIME "
DATA_DST_STR_NO_DST_DATA_1D00:
    NStr    " NO DST DATA "
DATA_DST_STR_G2_COLON_1D01:
    NStr    " g2:"
DATA_DST_STR_G3_COLON_1D02:
    NStr    " g3:"
GLOB_STR_DST_C_1:
    NStr    "DST.c"
GLOB_STR_DST_C_2:
    NStr    "DST.c"
GLOB_STR_DST_C_3:
    NStr    "DST.c"
GLOB_STR_DST_C_4:
    NStr    "DST.c"
GLOB_STR_DST_C_5:
    NStr    "DST.c"
GLOB_STR_DST_C_6:
    NStr    "DST.c"
GLOB_STR_G2:
    NStr    "g2"
GLOB_STR_G3:
    NStr    "g3"
GLOB_STR_DST_C_7:
    NStr    "DST.c"
DATA_DST_FMT_PCT_S_COLON_PCT_S_PCT_S_PCT_02D_PCT__1D0C:
    NStr2   "%s:  %s%s%02d, '%d (%03d) %2d:%02d:%02d %s %s %s",TextLineFeed
DATA_DST_TAG_PM_1D0D:
    NStr    "PM"
DATA_DST_TAG_AM_1D0E:
    NStr    "AM"
DATA_DST_TAG_DST_1D0F:
    NStr    "DST"
DATA_DST_TAG_STD_1D10:
    NStr    "STD"
DATA_DST_STR_LEAP_YEAR_1D11:
    NStr    "Leap Year"
DATA_DST_STR_NORM_YEAR_1D12:
    NStr    "Norm Year"
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ED_MenuStateId   (editor menu state id)
; TYPE: u16
; PURPOSE: Tracks active editor/menu substate for ED/ED1/ED2/ED3 dispatch.
; USED BY: ED_*, ED1_*, ED2_*, ED3_*, CLEANUP2_*, ESQFUNC_*
; NOTES: Used as a jump-dispatch selector in ED handlers.
;------------------------------------------------------------------------------
ED_MenuStateId:
    DS.W    1
DATA_DST_CONST_LONG_1D14:
    DC.L    1
DATA_DST_CONST_LONG_1D15:
    DC.L    1
