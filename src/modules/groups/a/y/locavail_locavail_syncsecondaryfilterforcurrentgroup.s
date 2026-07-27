    XDEF    _LOCAVAIL_SyncSecondaryFilterForCurrentGroup


;------------------------------------------------------------------------------
; FUNC: _LOCAVAIL_SyncSecondaryFilterForCurrentGroup   (Routine at _LOCAVAIL_SyncSecondaryFilterForCurrentGroup)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1
; CALLS:
;   _LOCAVAIL_CopyFilterStateStructRetainRefs, _LOCAVAIL_FreeResourceChain
; READS:
;   _TEXTDISP_SecondaryGroupCode, _TEXTDISP_PrimaryGroupCode, _LOCAVAIL_PrimaryFilterState, _LOCAVAIL_SecondaryFilterState
; WRITES:
;   _LOCAVAIL_SecondaryFilterState
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_LOCAVAIL_SyncSecondaryFilterForCurrentGroup:
    MOVE.B  _LOCAVAIL_SecondaryFilterState,D0
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D1
    CMP.B   D1,D0
    BEQ.S   .lab_0F92

    MOVE.B  _LOCAVAIL_PrimaryFilterState,D0
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D1
    CMP.B   D1,D0
    BNE.S   .lab_0F92

    PEA     _LOCAVAIL_SecondaryFilterState
    BSR.W   _LOCAVAIL_FreeResourceChain

    PEA     _LOCAVAIL_PrimaryFilterState
    PEA     _LOCAVAIL_SecondaryFilterState
    BSR.W   _LOCAVAIL_CopyFilterStateStructRetainRefs

    LEA     12(A7),A7
    MOVE.B  _TEXTDISP_SecondaryGroupCode,_LOCAVAIL_SecondaryFilterState

.lab_0F92:
    RTS

;!======