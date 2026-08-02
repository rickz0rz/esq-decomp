    XDEF    _NEWGRID_GridResourcesInitializedFlag
;------------------------------------------------------------------------------
; SYM: _NEWGRID_GridResourcesInitializedFlag   (grid resource init guard)
; TYPE: u16
; PURPOSE: Guards NEWGRID resource allocation so init runs once per active session.
; USED BY: _NEWGRID_InitGridResources, _NEWGRID_ShutdownGridResources
; NOTES: Set to 1 after successful init path, cleared during grid shutdown.
;------------------------------------------------------------------------------
_NEWGRID_GridResourcesInitializedFlag:
    DS.W    1

; ---- joined from data/newgrid.s by tools/data_merge.py ----
    XDEF    _Global_STR_NEWGRID_C_1
; ========== NEWGRID.c ==========

_Global_STR_NEWGRID_C_1:
    NStr    "NEWGRID.c"