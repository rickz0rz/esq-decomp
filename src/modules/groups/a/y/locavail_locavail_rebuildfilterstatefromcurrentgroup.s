    XDEF    _LOCAVAIL_RebuildFilterStateFromCurrentGroup


;------------------------------------------------------------------------------
; FUNC: _LOCAVAIL_RebuildFilterStateFromCurrentGroup   (Routine at _LOCAVAIL_RebuildFilterStateFromCurrentGroup)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0
; CALLS:
;   _LOCAVAIL_CopyFilterStateStructRetainRefs, _LOCAVAIL_ResetFilterCursorState, _LOCAVAIL_FreeResourceChain
; READS:
;   _TEXTDISP_PrimaryGroupCode, _LOCAVAIL_PrimaryFilterState, LOCAVAIL_SecondaryFilterState
; WRITES:
;   LOCAVAIL_SecondaryFilterState
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_LOCAVAIL_RebuildFilterStateFromCurrentGroup:
    PEA     _LOCAVAIL_PrimaryFilterState
    BSR.W   _LOCAVAIL_FreeResourceChain

    PEA     LOCAVAIL_SecondaryFilterState
    PEA     _LOCAVAIL_PrimaryFilterState
    BSR.W   _LOCAVAIL_CopyFilterStateStructRetainRefs

    PEA     LOCAVAIL_SecondaryFilterState
    BSR.W   _LOCAVAIL_FreeResourceChain

    LEA     16(A7),A7
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    SUBQ.B  #1,D0
    MOVE.B  D0,LOCAVAIL_SecondaryFilterState
    PEA     _LOCAVAIL_PrimaryFilterState
    BSR.W   _LOCAVAIL_ResetFilterCursorState

    ADDQ.W  #4,A7
    RTS
