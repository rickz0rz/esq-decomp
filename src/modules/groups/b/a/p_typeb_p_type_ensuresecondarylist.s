    XDEF    _P_TYPE_EnsureSecondaryList


;------------------------------------------------------------------------------
; FUNC: _P_TYPE_EnsureSecondaryList   (Clone primary list into secondary list if missing)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A7
; CALLS:
;   _P_TYPE_CloneEntry
; READS:
;   _TEXTDISP_SecondaryGroupCode, _P_TYPE_PrimaryGroupListPtr, _P_TYPE_SecondaryGroupListPtr
; WRITES:
;   _P_TYPE_SecondaryGroupListPtr
; DESC:
;   If primary list exists and secondary list is null, clones primary into
;   secondary and updates the cloned type byte to SecondaryGroupCode.
; NOTES:
;   No-op when primary is null or secondary already exists.
;------------------------------------------------------------------------------
_P_TYPE_EnsureSecondaryList:
    TST.L   _P_TYPE_PrimaryGroupListPtr
    BEQ.S   .return_136B

    TST.L   _P_TYPE_SecondaryGroupListPtr
    BNE.S   .return_136B

    MOVE.L  _P_TYPE_PrimaryGroupListPtr,-(A7)
    MOVE.L  _P_TYPE_SecondaryGroupListPtr,-(A7)
    BSR.S   _P_TYPE_CloneEntry

    ADDQ.W  #8,A7
    MOVE.L  D0,_P_TYPE_SecondaryGroupListPtr
    MOVEA.L D0,A0
    MOVE.B  _TEXTDISP_SecondaryGroupCode,(A0)

.return_136B:
    RTS

;!======