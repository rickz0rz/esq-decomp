; ========== COI.c ==========

Global_STR_COI_C_3:
    NStr    "COI.c"
Global_STR_COI_C_4:
    NStr    "COI.c"
Global_STR_DF0_OI_PERCENT_2_LX_DAT_1:
    NStr    "df0:OI_%02lx.dat"
;------------------------------------------------------------------------------
; SYM: COI_FMT_LONG_DEC_A   (decimal formatting strings)
; TYPE: cstring
; PURPOSE: Format strings and separators used while parsing/building COI fields.
; USED BY: COI parsing/serialization helpers
; NOTES: Multiple aliases point to similar formats with context-specific usage.
;------------------------------------------------------------------------------
COI_FMT_LONG_DEC_A:
    NStr    "%ld"
COI_FMT_DEC_A:
    NStr    "%d"
COI_STR_COLON_A:
    NStr    ":"
COI_FMT_LONG_DEC_B:
    NStr    "%ld"
COI_FMT_LONG_DEC_C:
    NStr    "%ld"
COI_FMT_LONG_DEC_PAD2:
    NStr    "%02ld"
COI_STR_COLON_B:
    NStr    ":"
COI_FMT_DEC_B:
    NStr    "%d"
Global_STR_COI_C_5:
    NStr    "COI.c"
Global_STR_DF0_OI_PERCENT_2_LX_DAT_2:
    NStr    "df0:OI_%02lx.dat"
Global_STR_COI_C_6:
    NStr    "COI.c"
COI_STR_LINEFEED_CR_1:
    NStr2   TextLineFeed,TextCarriageReturn
COI_STR_LINEFEED_CR_2:
    NStr2   TextLineFeed,TextCarriageReturn
COI_STR_DEFAULT_TOKEN_TEMPLATE_A:
    NStr    "NNNNNNXX00"
Global_STR_PERCENT_S_1:
    NStr    "%s"
Global_STR_COI_C_1:
    NStr    "COI.c"
Global_STR_COI_C_2:
    NStr    "COI.c"
COI_STR_DEFAULT_TOKEN_TEMPLATE_B:
    NStr    "NNNNNNXX00"
COI_FMT_WRAP_CHAR_STRING_CHAR:
    NStr    "%c%s%c"
COI_STR_SINGLE_SPACE:
    NStr    " "
COI_FMT_WIDE_STR_WITH_TRAILING_SPACE:
    NStr    "%ls "
    DS.W    1
;------------------------------------------------------------------------------
; SYM: CTASKS_IffTaskDoneFlag/CTASKS_IffTaskState   (IFF task completion + state)
; TYPE: u16/u16
; PURPOSE: Coordinates IFF loader task lifecycle and target-state selection.
; USED BY: CTASKS_*, ESQIFF_*, ESQFUNC_*, PARSEINI_*, GCOMMAND_SaveBrushResult
; NOTES: Observed states include 0 (idle), 4/5/6 (active target classes), 11 (special case).
;------------------------------------------------------------------------------
CTASKS_IffTaskDoneFlag:
    DC.W    $0001
CTASKS_IffTaskState:
    DC.W    $0004
DATA_COI_BSS_WORD_1B85:
    DS.W    1
