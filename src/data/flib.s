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
DATA_FLIB_FMT_PCT_02LD_COLON_PCT_02LD_COLON_PCT_02_1F60:
    NStr    "%02ld:%02ld:%02ld:%02ld"
DATA_FLIB_STR_DIGITAL_NICHE_LISTINGS_1F61:
    NStr    "Digital Niche Listings"
DATA_FLIB_STR_DIGITAL_MULTIPLEX_LISTINGS_1F62:
    NStr    "Digital Multiplex Listings"
DATA_FLIB_FMT_DIGITAL_MULTIPLEX_AT_PCT_S_1F63:
    NStr    "Digital Multiplex at %s"
DATA_FLIB_STR_DIGITAL_PPV_LISTINGS_1F64:
    NStr    "Digital PPV Listings"
Global_STR_DIGITAL_PPV_PERIOD:
    NStr    "Digital PPV."
