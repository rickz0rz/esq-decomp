    XDEF    _P_TYPE_PromoteSecondaryList

;------------------------------------------------------------------------------
; FUNC: _P_TYPE_PromoteSecondaryList   (Replace primary list with secondary list)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7
; CALLS:
;   _P_TYPE_FreeEntry
; READS:
;   _P_TYPE_PrimaryGroupListPtr, _P_TYPE_SecondaryGroupListPtr
; WRITES:
;   _P_TYPE_PrimaryGroupListPtr, _P_TYPE_SecondaryGroupListPtr
; DESC:
;   Frees the current primary list, then promotes secondary list into primary.
; NOTES:
;   Secondary pointer is cleared after promotion.
;------------------------------------------------------------------------------
_P_TYPE_PromoteSecondaryList:
    MOVE.L  _P_TYPE_PrimaryGroupListPtr,-(A7)
    BSR.W   _P_TYPE_FreeEntry

    ADDQ.W  #4,A7
    MOVE.L  _P_TYPE_SecondaryGroupListPtr,_P_TYPE_PrimaryGroupListPtr
    CLR.L   _P_TYPE_SecondaryGroupListPtr
    RTS

;!======
