    XDEF    _P_TYPE_ResetListsAndLoadPromoIds

;------------------------------------------------------------------------------
; FUNC: _P_TYPE_ResetListsAndLoadPromoIds   (Clear list pointers and reload PROMOID.DAT)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0
; CALLS:
;   _P_TYPE_LoadPromoIdDataFile
; READS:
;   (none observed)
; WRITES:
;   _P_TYPE_PrimaryGroupListPtr, _P_TYPE_SecondaryGroupListPtr
; DESC:
;   Clears primary/secondary list pointers and repopulates them from disk.
; NOTES:
;   Load is best-effort; return value is ignored.
;------------------------------------------------------------------------------
_P_TYPE_ResetListsAndLoadPromoIds:
    SUBA.L  A0,A0
    MOVE.L  A0,_P_TYPE_SecondaryGroupListPtr
    MOVE.L  A0,_P_TYPE_PrimaryGroupListPtr
    BSR.W   _P_TYPE_LoadPromoIdDataFile

    RTS

;!======
