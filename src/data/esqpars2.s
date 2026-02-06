; ========== ESQPARS2.c ==========

GLOB_ESQPARS2_C_1:
    NStr    "ESQPARS2.c"
GLOB_ESQPARS2_C_2:
    NStr    "ESQPARS2.c"
GLOB_ESQPARS2_C_3:
    NStr    "ESQPARS2.c"
GLOB_ESQPARS2_C_4:
    NStr    "ESQPARS2.c"
GLOB_STR_CLOSED_CAPTIONED:
    NStr    "(CC)"
GLOB_STR_IN_STEREO:
    NStr    "In Stereo"

GLOB_STR_RATING_R:
    NStr    "(R)"
GLOB_STR_RATING_ADULT:
    NStr    "(Adult)"
GLOB_STR_RATING_PG:
    NStr    "(PG)"
GLOB_STR_RATING_NR:
    NStr    "(NR)"
GLOB_STR_RATING_PG_13:
    NStr    "(PG-13)"
GLOB_STR_RATING_G:
    NStr    "(G)"
GLOB_STR_RATING_NC_17:
    NStr    "(NC-17)"

GLOB_TBL_MOVIE_RATINGS:
    DC.L    GLOB_STR_RATING_R
    DC.L    GLOB_STR_RATING_ADULT
    DC.L    GLOB_STR_RATING_PG
    DC.L    GLOB_STR_RATING_NR
    DC.L    GLOB_STR_RATING_PG_13
    DC.L    GLOB_STR_RATING_G
    DC.L    GLOB_STR_RATING_NC_17

; Perhaps a table of the character codes that map
; to the ratings in the font?
DATA_ESQPARS2_CONST_BYTE_1F1E:
    DC.B    $84
    DC.B    $86
    DC.B    $85
    DC.B    $8C
    DC.B    $87
    DC.B    $8D
    DC.B    $8F
    DC.B    0       ; Table terminator

GLOB_STR_TV_Y:
    NStr    "(TV-Y)"
GLOB_STR_TV_Y7:
    NStr    "(TV-Y7)"
GLOB_STR_TV_PG:
    NStr    "(TV-PG)"
GLOB_STR_TV_G:
    NStr    "(TV-G)"
GLOB_STR_TV_M:
    NStr    "(TV-M)"
GLOB_STR_TV_MA:
    NStr    "(TV-MA)"
GLOB_STR_TV_14:
    NStr    "(TV-14)"

GLOB_TBL_TV_PROGRAM_RATINGS:
    DC.L    GLOB_STR_TV_Y
    DC.L    GLOB_STR_TV_Y7
    DC.L    GLOB_STR_TV_PG
    DC.L    GLOB_STR_TV_G
    DC.L    GLOB_STR_TV_M
    DC.L    GLOB_STR_TV_MA
    DC.L    GLOB_STR_TV_14

; Perhaps a table of the character codes that map
; to the ratings in the font?
DATA_ESQPARS2_CONST_BYTE_1F27:
    DC.B    $90
    DC.B    $93
    DC.B    $9b
    DC.B    $99
    DC.B    $A3
    DC.B    $A3
    DC.B    $9A
    DC.B    0       ; Table terminator

GLOB_STR_ESQPARS2_C_1:
    NStr    "ESQPARS2.c"
DATA_ESQPARS2_FMT_PCT_D_1F29:
    NStr    "%d "
DATA_ESQPARS2_FMT_PCT_D_1F2A:
    NStr    "(%d "
DATA_ESQPARS2_FMT_PCT_D_1F2B:
    NStr    "(%d "
DATA_ESQPARS2_STR_VALUE_1F2C:
    NStr    ")"
GLOB_STR_ESQPARS2_C_2:
    NStr    "ESQPARS2.c"
    DS.W    1
GLOB_LONG_PATCH_VERSION_NUMBER:
    DC.L    $00000004 ; Patch version number
DATA_ESQPARS2_BSS_WORD_1F2F:
    DS.W    1
DATA_ESQPARS2_BSS_WORD_1F30:
    DS.W    1
DATA_ESQPARS2_BSS_WORD_1F31:
    DS.W    1
DATA_ESQPARS2_BSS_WORD_1F32:
    DS.W    1
DATA_ESQPARS2_BSS_WORD_1F33:
    DS.W    1
DATA_ESQPARS2_BSS_WORD_1F34:
    DS.W    1
DATA_ESQPARS2_BSS_LONG_1F35:
    DS.L    1
DATA_ESQPARS2_BSS_LONG_1F36:
    DS.L    1
DATA_ESQPARS2_BSS_LONG_1F37:
    DS.L    1
DATA_ESQPARS2_BSS_LONG_1F38:
    DS.L    1
DATA_ESQPARS2_BSS_LONG_1F39:
    DS.L    1
DATA_ESQPARS2_BSS_LONG_1F3A:
    DS.L    9
DATA_ESQPARS2_BSS_WORD_1F3B:
    DS.W    1
DATA_ESQPARS2_BSS_WORD_1F3C:
    DS.W    1
DATA_ESQPARS2_BSS_WORD_1F3D:
    DS.W    1
DATA_ESQPARS2_BSS_LONG_1F3E:
    DS.L    1
DATA_ESQPARS2_BSS_WORD_1F3F:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQPARS2_StateIndex   (ESQPARS2 runtime state index)
; TYPE: u16
; PURPOSE: Holds a small parser/UI state index used by ESQPARS2-linked flows.
; USED BY: ESQIFF2_*, ED2_*, ESQSHARED4_*
; NOTES: Typical values are low integers (for example 2, 4).
;------------------------------------------------------------------------------
ESQPARS2_StateIndex:
    DS.W    1
DATA_ESQPARS2_BSS_WORD_1F41:
    DS.W    1
DATA_ESQPARS2_BSS_WORD_1F42:
    DS.W    1
DATA_ESQPARS2_BSS_WORD_1F43:
    DS.W    1
DATA_ESQPARS2_BSS_WORD_1F44:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQPARS2_ReadModeFlags   (input/read mode flags)
; TYPE: u16
; PURPOSE: Global mode word controlling stream/buffer handling behavior.
; USED BY: DISKIO_*, APP_*, ESQFUNC_*, NEWGRID_*, SCRIPT3_*
; NOTES: Observed values include 0, 5, $0100, $0101, $0102, $0200.
;------------------------------------------------------------------------------
ESQPARS2_ReadModeFlags:
    DS.W    1
DATA_ESQPARS2_BSS_LONG_1F46:
    DS.L    1
DATA_ESQPARS2_BSS_WORD_1F47:
    DS.W    1
DATA_ESQPARS2_BSS_LONG_1F48:
    DS.L    25
DATA_ESQPARS2_BSS_LONG_1F49:
    DS.L    1
DATA_ESQPARS2_BSS_WORD_1F4A:
    DS.W    1
DATA_ESQPARS2_BSS_WORD_1F4B:
    DS.W    1
DATA_ESQPARS2_BSS_LONG_1F4C:
    DS.L    1
DATA_ESQPARS2_BSS_LONG_1F4D:
    DS.L    1
DATA_ESQPARS2_BSS_LONG_1F4E:
    DS.L    1
DATA_ESQPARS2_BSS_LONG_1F4F:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ESQSHARED_BlitAddressOffset   (shared blit address offset)
; TYPE: s32
; PURPOSE: Offset added to paired source/destination pointers before blits/copies.
; USED BY: ESQSHARED4_* drawing/compositing paths
; NOTES: Applied symmetrically to A1/A2 style pointer pairs.
;------------------------------------------------------------------------------
ESQSHARED_BlitAddressOffset:
    DS.L    1
DATA_ESQPARS2_BSS_LONG_1F51:
    DS.L    1
DATA_ESQPARS2_CONST_LONG_1F52:
    DC.L    $00000022
DATA_ESQPARS2_CONST_WORD_1F53:
    DC.W    $0100
DATA_ESQPARS2_CONST_WORD_1F54:
    DC.W    $00c0
DATA_ESQPARS2_CONST_WORD_1F55:
    DC.W    $0010
DATA_ESQPARS2_CONST_LONG_1F56:
    DC.L    $00110000
    DS.L    1
DATA_ESQPARS2_BSS_LONG_1F57:
    DS.L    1
DATA_ESQPARS2_FMT_PCT_02LD_COLON_PCT_02LD_COLON_PCT_02_1F58:
    NStr    "%02ld:%02ld:%02ld %2.2s"
DATA_ESQPARS2_TAG_PM_1F59:
    NStr    "PM"
DATA_ESQPARS2_TAG_AM_1F5A:
    NStr    "AM"
DATA_ESQPARS2_CONST_WORD_1F5B:
    DC.W    $0900
DATA_ESQPARS2_CONST_LONG_1F5C:
    DC.L    $0d0a0000
