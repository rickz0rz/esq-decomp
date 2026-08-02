    XDEF    _CTASKS_STR_1
    XDEF    _CONFIG_RefreshIntervalSeconds
    XDEF    _DISKIO_OpenCount
_CTASKS_STR_1:
    NStr    "1"

;------------------------------------------------------------------------------
; SYM: _CONFIG_RefreshIntervalSeconds   (banner queue preset token ??)
; TYPE: s32
; PURPOSE: Shared preset value injected into banner queue mapping paths.
; USED BY: _GCOMMAND_MapKeycodeToPreset, DISKIO config parse/save, ED2 diagnostics
; NOTES: Default value is 120; exact user-facing meaning is still unresolved.
;------------------------------------------------------------------------------
_CONFIG_RefreshIntervalSeconds:
    DC.L    120
_DISKIO_OpenCount:
    DS.L    1

; ---- joined from data/diskio.s by tools/data_merge.py ----
    XDEF    _Global_STR_DISKIO_C_1
; ========== DISKIO.c ==========

_Global_STR_DISKIO_C_1:
    NStr    "DISKIO.c"