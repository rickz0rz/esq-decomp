    XDEF    _TLIBA1_DayEntryModeCounter
    XDEF    _WDISP_StatusDayEntry0
    XDEF    _WDISP_StatusDayEntry1
    XDEF    _WDISP_StatusDayEntry2
    XDEF    _WDISP_StatusDayEntry3
    XDEF    _TLIBA1_StatusBannerPropagateGuard
_TLIBA1_DayEntryModeCounter:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _WDISP_StatusDayEntry0.._WDISP_StatusDayEntry3   (status-day entry ring)
; TYPE: struct[4]
; PURPOSE: Four consecutive day-entry structs consumed by banner/status rendering and shifted each update tick.
; USED BY: _UNKNOWN_ParseListAndUpdateEntries, _ESQDISP_DrawStatusBanner, WDISP_DrawStatusBannerSlots
; NOTES: Per-entry layout is likely: +0 day code, +4/+8/+12 numeric fields, +16 active/pending flag.
;------------------------------------------------------------------------------
_WDISP_StatusDayEntry0:
    DC.L    0,1,0,0,1
_WDISP_StatusDayEntry1:
    DC.L    0,1,0,0,1
_WDISP_StatusDayEntry2:
    DC.L    0,1,0,0,1
_WDISP_StatusDayEntry3:
    DC.L    0,1,0,0
_TLIBA1_StatusBannerPropagateGuard:
    DC.L    1

; ---- joined from data/wdisp.s by tools/data_merge.py ----
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