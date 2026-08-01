    XDEF    _Global_STR_WDISP_C
    XDEF    _WDISP_STR_UNKNOWN_NUM_WITH_SLASH
; ========== WDISP.c ==========
; weather display?

_Global_STR_WDISP_C:
    NStr    "WDISP.c"
;------------------------------------------------------------------------------
; SYM: _WDISP_STR_UNKNOWN_NUM_WITH_SLASH   (unknown numeric placeholder with slash)
; TYPE: cstring
; PURPOSE: Display fallback when sentinel value indicates missing first numeric field.
; USED BY: LAB_188C
; NOTES: Rendered instead of formatted "%d/" text.
;------------------------------------------------------------------------------
_WDISP_STR_UNKNOWN_NUM_WITH_SLASH:
    NStr3   '?','?','?/'