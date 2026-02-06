; ========== LADFUNC.c ==========

GLOB_STR_LADFUNC_C_1:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_2:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_3:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_4:
    NStr    "LADFUNC.c"
DATA_LADFUNC_TAG_RS_1FBF:
    NStr    "RS"
DATA_LADFUNC_TAG_RS_1FC0:
    NStr    "RS"
GLOB_STR_LADFUNC_C_5:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_6:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_7:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_8:
    NStr    "LADFUNC.c"
DATA_LADFUNC_FMT_PCT_C_PCT_02X_1FC5:
    NStr    "%c%02X"
DATA_LADFUNC_BSS_WORD_1FC6:
    DS.W    1
GLOB_STR_LADFUNC_C_9:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_10:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_11:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_12:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_13:
    NStr    "LADFUNC.c"
GLOB_STR_SINGLE_SPACE_1:
    NStr    " "
GLOB_STR_LADFUNC_C_14:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_15:
    NStr    "LADFUNC.c"
GLOB_STR_SINGLE_SPACE_2:
    NStr    " "
GLOB_STR_LADFUNC_C_16:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_17:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_18:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_19:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_20:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_21:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_22:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_23:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_24:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_25:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_26:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_27:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_28:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_29:
    NStr    "LADFUNC.c"
GLOB_STR_LADFUNC_C_30:
    NStr    "LADFUNC.c"
DATA_LADFUNC_STR_VALUE_1FDF:
    NStr2   """",TextLineFeed
DATA_LADFUNC_STR_VALUE_1FE0:
    NStr    """"
DATA_LADFUNC_FMT_PCT_LC_1FE1:
    NStr    "^%lc"
DATA_LADFUNC_FMT_PCT_LC_1FE2:
    NStr    "%lc"
DATA_LADFUNC_FMT_PCT_LC_1FE3:
    NStr    "%lc"
DATA_LADFUNC_FMT_PCT_02LX_1FE4:
    NStr    "$%02lx"
DATA_LADFUNC_FMT_PCT_LC_1FE5:
    NStr    "%lc"
;------------------------------------------------------------------------------
; SYM: LOCAVAIL_FilterModeFlag/LOCAVAIL_FilterStep/LOCAVAIL_FilterClassId/LOCAVAIL_FilterPrevClassId   (locavail filter state)
; TYPE: s32/s32/s32/s32
; PURPOSE: Stores mode and step state for locavail-style filter/selection transitions.
; USED BY: LOCAVAIL_*, SCRIPT3_*, TEXTDISP2_*, ED1_*, ED2_*
; NOTES: `-1` is a sentinel for "no class selected/previous class cleared".
;------------------------------------------------------------------------------
LOCAVAIL_FilterModeFlag:
    DS.L    1
LOCAVAIL_FilterStep:
    DS.L    1
LOCAVAIL_FilterClassId:
    DC.L    $ffffffff
LOCAVAIL_FilterPrevClassId:
    DC.L    $ffffffff
DATA_LADFUNC_CONST_WORD_1FEA:
    DC.W    $ffff
