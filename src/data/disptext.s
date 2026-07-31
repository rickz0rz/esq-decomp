    XDEF    _Global_STR_DISPTEXT_C_1
    XDEF    _DISPTEXT_STR_SINGLE_SPACE_MEASURE
    XDEF    _DISPTEXT_STR_SINGLE_SPACE_APPEND
    XDEF    _DISPTEXT_STR_SINGLE_SPACE_DELIM
    XDEF    _DISPTEXT_InitBuffersPending
    XDEF    _Global_STR_DISPTEXT_C_2
    XDEF    _Global_STR_DISPTEXT_C_3
    XDEF    _Global_STR_DISPTEXT_C_4
    XDEF    _Global_STR_DISPTEXT_C_5
    XDEF    _DISPTEXT_STR_SINGLE_SPACE_PREFIX_1
    XDEF    _DISPTEXT_STR_SINGLE_SPACE_PREFIX_2
    XDEF    _DISPTEXT_STR_SINGLE_SPACE_COPY_PREFIX
    XDEF    _DATETIME_MONTH_LENGTH_AND_DAY_OFFSET_TABLES
; ========== DISPTEXT.c ==========

_Global_STR_DISPTEXT_C_1:
    NStr    "DISPTEXT.c"
;------------------------------------------------------------------------------
; SYM: _DISPTEXT_STR_SINGLE_SPACE_MEASURE   (single-space literal)
; TYPE: cstring
; PURPOSE: Width measurement and separator helpers in line-layout routines.
; USED BY: _DISPTEXT_BuildLineWithWidth
; NOTES: Multiple aliases preserve original callsite intent while sharing value.
;------------------------------------------------------------------------------
_DISPTEXT_STR_SINGLE_SPACE_MEASURE:
    NStr    " "
_DISPTEXT_STR_SINGLE_SPACE_APPEND:
    NStr    " "
_DISPTEXT_STR_SINGLE_SPACE_DELIM:
    NStr    " "
; One-shot init guard for buffer allocation path.
_DISPTEXT_InitBuffersPending:
    DC.L    1
_Global_STR_DISPTEXT_C_2:
    NStr    "DISPTEXT.c"
_Global_STR_DISPTEXT_C_3:
    NStr    "DISPTEXT.c"
_Global_STR_DISPTEXT_C_4:
    NStr    "DISPTEXT.c"
_Global_STR_DISPTEXT_C_5:
    NStr    "DISPTEXT.c"
_DISPTEXT_STR_SINGLE_SPACE_PREFIX_1:
    NStr    " "
_DISPTEXT_STR_SINGLE_SPACE_PREFIX_2:
    NStr    " "
_DISPTEXT_STR_SINGLE_SPACE_COPY_PREFIX:
    NStr    " "
;------------------------------------------------------------------------------
; SYM: _DATETIME_MONTH_LENGTH_AND_DAY_OFFSET_TABLES   (month tables)
; TYPE: byte/long lookup tables
; PURPOSE: Month-length sequence and cumulative day offsets used by datetime conversion.
; USED BY: _DATETIME_SecondsToStruct
; NOTES: First bytes encode month lengths; later longs appear to be cumulative
;        offsets from the beginning of the year for each month in days.
;------------------------------------------------------------------------------
_DATETIME_MONTH_LENGTH_AND_DAY_OFFSET_TABLES:
    DC.B    31,28,31,30,31,30,31,31,30,31,30,31
    DC.L    0,31,59,90,120,151,181,212,243,273,304,334
