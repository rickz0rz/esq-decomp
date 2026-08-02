    XDEF    _DOS_SystemTagList


;------------------------------------------------------------------------------
; FUNC: _DOS_SystemTagList   (Call DOS SystemTagList.)
; ARGS:
;   (none observed)
; RET:
;   D0: status
; CLOBBERS:
;   D0-D2/A6
; CALLS:
;   _LVOSystemTagList
;------------------------------------------------------------------------------
_DOS_SystemTagList:
    MOVEM.L D2/A6,-(A7)

    MOVEA.L _Global_REF_DOS_LIBRARY_2,A6
    MOVEM.L 12(A7),D1-D2
    JSR     _LVOSystemTagList(A6)

    MOVEM.L (A7)+,D2/A6
    RTS

;!======