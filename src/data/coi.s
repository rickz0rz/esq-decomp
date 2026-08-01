    XDEF    _Global_STR_COI_C_3
    XDEF    _Global_STR_COI_C_4
    XDEF    _Global_STR_DF0_OI_PERCENT_2_LX_DAT_1
    XDEF    _COI_FMT_LONG_DEC_A
    XDEF    _COI_FMT_DEC_A
    XDEF    _COI_STR_COLON_A
    XDEF    _COI_FMT_LONG_DEC_B
    XDEF    _COI_FMT_LONG_DEC_C
    XDEF    _COI_FMT_LONG_DEC_PAD2
    XDEF    _COI_STR_COLON_B
    XDEF    _COI_FMT_DEC_B
    XDEF    _Global_STR_COI_C_5
    XDEF    _Global_STR_DF0_OI_PERCENT_2_LX_DAT_2
    XDEF    _Global_STR_COI_C_6
    XDEF    _COI_STR_LINEFEED_CR_1
    XDEF    _COI_STR_LINEFEED_CR_2
    XDEF    _COI_STR_DEFAULT_TOKEN_TEMPLATE_A
    XDEF    _Global_STR_PERCENT_S_1
    XDEF    _Global_STR_COI_C_1
    XDEF    _Global_STR_COI_C_2
    XDEF    _COI_STR_DEFAULT_TOKEN_TEMPLATE_B
    XDEF    _COI_FMT_WRAP_CHAR_STRING_CHAR
    XDEF    _COI_STR_SINGLE_SPACE
    XDEF    _COI_FMT_WIDE_STR_WITH_TRAILING_SPACE
    XDEF    _CTASKS_IffTaskDoneFlag
    XDEF    _CTASKS_IffTaskState
; ========== COI.c ==========

_Global_STR_COI_C_3:
    NStr    "COI.c"
_Global_STR_COI_C_4:
    NStr    "COI.c"
_Global_STR_DF0_OI_PERCENT_2_LX_DAT_1:
    NStr    "df0:OI_%02lx.dat"
;------------------------------------------------------------------------------
; SYM: _COI_FMT_LONG_DEC_A   (decimal formatting strings)
; TYPE: cstring
; PURPOSE: Format strings and separators used while parsing/building COI fields.
; USED BY: COI parsing/serialization helpers
; NOTES: Multiple aliases point to similar formats with context-specific usage.
;------------------------------------------------------------------------------
_COI_FMT_LONG_DEC_A:
    NStr    "%ld"
_COI_FMT_DEC_A:
    NStr    "%d"
_COI_STR_COLON_A:
    NStr    ":"
_COI_FMT_LONG_DEC_B:
    NStr    "%ld"
_COI_FMT_LONG_DEC_C:
    NStr    "%ld"
_COI_FMT_LONG_DEC_PAD2:
    NStr    "%02ld"
_COI_STR_COLON_B:
    NStr    ":"
_COI_FMT_DEC_B:
    NStr    "%d"
_Global_STR_COI_C_5:
    NStr    "COI.c"
_Global_STR_DF0_OI_PERCENT_2_LX_DAT_2:
    NStr    "df0:OI_%02lx.dat"
_Global_STR_COI_C_6:
    NStr    "COI.c"
_COI_STR_LINEFEED_CR_1:
    NStr2   TextLineFeed,TextCarriageReturn
_COI_STR_LINEFEED_CR_2:
    NStr2   TextLineFeed,TextCarriageReturn
_COI_STR_DEFAULT_TOKEN_TEMPLATE_A:
    NStr    "NNNNNNXX00"
_Global_STR_PERCENT_S_1:
    NStr    "%s"
_Global_STR_COI_C_1:
    NStr    "COI.c"
_Global_STR_COI_C_2:
    NStr    "COI.c"
_COI_STR_DEFAULT_TOKEN_TEMPLATE_B:
    NStr    "NNNNNNXX00"
_COI_FMT_WRAP_CHAR_STRING_CHAR:
    NStr    "%c%s%c"
_COI_STR_SINGLE_SPACE:
    NStr    " "
_COI_FMT_WIDE_STR_WITH_TRAILING_SPACE:
    NStr    "%ls "
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _CTASKS_IffTaskDoneFlag/_CTASKS_IffTaskState   (IFF task completion + state)
; TYPE: u16/u16
; PURPOSE: Coordinates IFF loader task lifecycle and target-state selection.
; USED BY: CTASKS_*, ESQIFF_*, ESQFUNC_*, PARSEINI_*, _GCOMMAND_SaveBrushResult
; NOTES: Observed states include 0 (idle), 4/5/6 (active target classes), 11 (special case).
;------------------------------------------------------------------------------
_CTASKS_IffTaskDoneFlag:
    DC.W    $0001
_CTASKS_IffTaskState:
    DC.W    $0004