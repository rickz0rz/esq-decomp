    XDEF    _ESQPARS2_LogFieldTab
    XDEF    _ESQPARS2_LogLineTerminator
_ESQPARS2_LogFieldTab:
    DC.W    $0900
_ESQPARS2_LogLineTerminator:
    DC.L    $0d0a0000

; ---- joined from data/flib.s by tools/data_merge.py ----
    XDEF    _Global_STR_FLIB_C_1
    XDEF    _Global_STR_FLIB_C_2
    XDEF    _FLIB_EmptyLogReplacementString
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