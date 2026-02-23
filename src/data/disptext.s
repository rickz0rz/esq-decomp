; ========== DISPTEXT.c ==========

Global_STR_DISPTEXT_C_1:
    NStr    "DISPTEXT.c"
;------------------------------------------------------------------------------
; SYM: DISPTEXT_STR_SINGLE_SPACE_MEASURE   (single-space literal)
; TYPE: cstring
; PURPOSE: Width measurement and separator helpers in line-layout routines.
; USED BY: DISPTEXT_BuildLineWithWidth
; NOTES: Multiple aliases preserve original callsite intent while sharing value.
;------------------------------------------------------------------------------
DISPTEXT_STR_SINGLE_SPACE_MEASURE:
    NStr    " "
DISPTEXT_STR_SINGLE_SPACE_APPEND:
    NStr    " "
DISPTEXT_STR_SINGLE_SPACE_DELIM:
    NStr    " "
; One-shot init guard for buffer allocation path.
DISPTEXT_InitBuffersPending:
    DC.L    1
Global_STR_DISPTEXT_C_2:
    NStr    "DISPTEXT.c"
Global_STR_DISPTEXT_C_3:
    NStr    "DISPTEXT.c"
Global_STR_DISPTEXT_C_4:
    NStr    "DISPTEXT.c"
Global_STR_DISPTEXT_C_5:
    NStr    "DISPTEXT.c"
DISPTEXT_STR_SINGLE_SPACE_PREFIX_1:
    NStr    " "
DISPTEXT_STR_SINGLE_SPACE_PREFIX_2:
    NStr    " "
DISPTEXT_STR_SINGLE_SPACE_COPY_PREFIX:
    NStr    " "
;------------------------------------------------------------------------------
; SYM: DATETIME_MONTH_LENGTH_AND_DAY_OFFSET_TABLES   (month tables)
; TYPE: byte/long lookup tables
; PURPOSE: Month-length sequence and cumulative day offsets used by datetime conversion.
; USED BY: DATETIME_SecondsToStruct
; NOTES: First bytes encode month lengths; later longs appear to be cumulative
;        offsets from the beginning of the year for each month in days.
;------------------------------------------------------------------------------
DATETIME_MONTH_LENGTH_AND_DAY_OFFSET_TABLES:
    DC.B    31,28,31,30,31,30,31,31,30,31,30,31
    DC.L    0,31,59,90,120,151,181,212,243,273,304,334
