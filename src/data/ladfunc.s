; ========== LADFUNC.c ==========

Global_STR_LADFUNC_C_1:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_2:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_3:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_4:
    NStr    "LADFUNC.c"
LADFUNC_TAG_RS_ResetTriggerSet:
    NStr    "RS"
LADFUNC_TAG_RS_ParseAllowedSet:
    NStr    "RS"
Global_STR_LADFUNC_C_5:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_6:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_7:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_8:
    NStr    "LADFUNC.c"
LADFUNC_FMT_AttrEscapePrefixCharHex:
    NStr    "%c%02X"
LADFUNC_TextAdLineBreakBuffer:
    DS.W    1
Global_STR_LADFUNC_C_9:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_10:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_11:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_12:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_13:
    NStr    "LADFUNC.c"
Global_STR_SINGLE_SPACE_1:
    NStr    " "
Global_STR_LADFUNC_C_14:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_15:
    NStr    "LADFUNC.c"
Global_STR_SINGLE_SPACE_2:
    NStr    " "
Global_STR_LADFUNC_C_16:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_17:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_18:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_19:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_20:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_21:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_22:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_23:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_24:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_25:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_26:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_27:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_28:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_29:
    NStr    "LADFUNC.c"
Global_STR_LADFUNC_C_30:
    NStr    "LADFUNC.c"
LADFUNC_STR_QuoteAndNewline:
    NStr2   """",TextLineFeed
LADFUNC_STR_Quote:
    NStr    """"
LADFUNC_FMT_ControlCharCaretEscape:
    NStr    "^%lc"
LADFUNC_FMT_ReplacementQuoteChar:
    NStr    "%lc"
LADFUNC_FMT_ReplacementCommaChar:
    NStr    "%lc"
LADFUNC_FMT_HexEscapeByte:
    NStr    "$%02lx"
LADFUNC_FMT_LiteralChar:
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
LOCAVAIL_FilterWindowHalfSpan:
    DC.W    $ffff
