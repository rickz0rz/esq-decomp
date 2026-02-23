; ========== FLIB.c ==========

Global_STR_FLIB_C_1:
    NStr    "FLIB.c"
Global_STR_FLIB_C_2:
    NStr    "FLIB.c"
;------------------------------------------------------------------------------
; SYM: FLIB_EmptyLogReplacementString   (FLIB empty-log replacement string)
; TYPE: u16 (zero-initialized NUL string storage)
; PURPOSE: Static empty-string source used when resetting/replacing log text.
; USED BY: FLIB log rollover/reset path via ESQPARS_ReplaceOwnedString
; NOTES:
;   Passed by address as source text; DC.B yields two zero bytes so this
;   behaves as a stable "" string of two NULs without separate NStr storage.
;------------------------------------------------------------------------------
FLIB_EmptyLogReplacementString:
    DC.B    0,0
FLIB_FMT_PCT_02LD_COLON_PCT_02LD_COLON_PCT_02:
    NStr    "%02ld:%02ld:%02ld:%02ld"
FLIB_STR_DIGITAL_NICHE_LISTINGS:
    NStr    "Digital Niche Listings"
FLIB_STR_DIGITAL_MULTIPLEX_LISTINGS:
    NStr    "Digital Multiplex Listings"
FLIB_FMT_DIGITAL_MULTIPLEX_AT_PCT_S:
    NStr    "Digital Multiplex at %s"
FLIB_STR_DIGITAL_PPV_LISTINGS:
    NStr    "Digital PPV Listings"
Global_STR_DIGITAL_PPV_PERIOD:
    NStr    "Digital PPV."
