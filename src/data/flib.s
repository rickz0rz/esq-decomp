    XDEF    _Global_STR_FLIB_C_1
    XDEF    _Global_STR_FLIB_C_2
    XDEF    _FLIB_EmptyLogReplacementString
    XDEF    _FLIB_FMT_PCT_02LD_COLON_PCT_02LD_COLON_PCT_02
    XDEF    _FLIB_STR_DIGITAL_NICHE_LISTINGS
    XDEF    _FLIB_STR_DIGITAL_MULTIPLEX_LISTINGS
    XDEF    _FLIB_FMT_DIGITAL_MULTIPLEX_AT_PCT_S
    XDEF    _FLIB_STR_DIGITAL_PPV_LISTINGS
    XDEF    _Global_STR_DIGITAL_PPV_PERIOD
; ========== FLIB.c ==========

_Global_STR_FLIB_C_1:
    NStr    "FLIB.c"
_Global_STR_FLIB_C_2:
    NStr    "FLIB.c"
;------------------------------------------------------------------------------
; SYM: _FLIB_EmptyLogReplacementString   (FLIB empty-log replacement string)
; TYPE: u16 (zero-initialized NUL string storage)
; PURPOSE: Static empty-string source used when resetting/replacing log text.
; USED BY: FLIB log rollover/reset path via _ESQPARS_ReplaceOwnedString
; NOTES:
;   Passed by address as source text; DC.B yields two zero bytes so this
;   behaves as a stable "" string of two NULs without separate NStr storage.
;------------------------------------------------------------------------------
_FLIB_EmptyLogReplacementString:
    DC.B    0,0
_FLIB_FMT_PCT_02LD_COLON_PCT_02LD_COLON_PCT_02:
    NStr    "%02ld:%02ld:%02ld:%02ld"
_FLIB_STR_DIGITAL_NICHE_LISTINGS:
    NStr    "Digital Niche Listings"
_FLIB_STR_DIGITAL_MULTIPLEX_LISTINGS:
    NStr    "Digital Multiplex Listings"
_FLIB_FMT_DIGITAL_MULTIPLEX_AT_PCT_S:
    NStr    "Digital Multiplex at %s"
_FLIB_STR_DIGITAL_PPV_LISTINGS:
    NStr    "Digital PPV Listings"
_Global_STR_DIGITAL_PPV_PERIOD:
    NStr    "Digital PPV."
