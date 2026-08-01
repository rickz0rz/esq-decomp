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
