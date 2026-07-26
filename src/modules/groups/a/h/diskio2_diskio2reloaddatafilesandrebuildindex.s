    XDEF    _DISKIO2_ReloadDataFilesAndRebuildIndex

;------------------------------------------------------------------------------
; FUNC: _DISKIO2_ReloadDataFilesAndRebuildIndex   (Load disk data files and refresh state.)
; ARGS:
;   (none observed)
; RET:
;   D0: none
; CLOBBERS:
;   none observed
; CALLS:
;   _DISKIO2_LoadCurDayDataFile, _DISKIO2_LoadNxtDayDataFile, _DISKIO2_LoadOinfoDataFile, _GROUP_AH_JMPTBL_NEWGRID_RebuildIndexCache
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Wrapper that reloads multiple disk data files and applies updates.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISKIO2_ReloadDataFilesAndRebuildIndex:
    BSR.W   _DISKIO2_LoadCurDayDataFile

    BSR.W   _DISKIO2_LoadNxtDayDataFile

    BSR.W   _DISKIO2_LoadOinfoDataFile

    JSR     _GROUP_AH_JMPTBL_NEWGRID_RebuildIndexCache(PC)

    RTS
