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
; NOTES: First bytes encode month lengths; later longs appear to be cumulative offsets.
;------------------------------------------------------------------------------
DATETIME_MONTH_LENGTH_AND_DAY_OFFSET_TABLES:
    DC.L    $1f1c1f1e,$1f1e1f1f,$1e1f1e1f
    DS.L    1
    DC.L    $0000001f,$0000003b,$0000005a,$00000078
    DC.L    $00000097,$000000b5,$000000d4,$000000f3
    DC.L    $00000111,$00000130,$0000014e
