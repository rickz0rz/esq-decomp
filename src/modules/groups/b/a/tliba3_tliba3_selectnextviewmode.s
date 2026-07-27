    XDEF    _TLIBA3_SelectNextViewMode


;------------------------------------------------------------------------------
; FUNC: _TLIBA3_SelectNextViewMode   (_TLIBA3_SelectNextViewMode)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1
; CALLS:
;   _TLIBA3_DrawViewModeOverlay, _TLIBA3_BuildDisplayContextForViewMode, _MATH_DivS32
; READS:
;   _TLIBA1_CurrentViewModeIndex
; WRITES:
;   _TLIBA1_CurrentViewModeIndex, _WDISP_DisplayContextBase
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_TLIBA3_SelectNextViewMode:
    MOVE.L  _TLIBA1_CurrentViewModeIndex,D0
    ADDQ.L  #1,D0
    MOVEQ   #9,D1
    JSR     _MATH_DivS32(PC)

    MOVE.L  D1,_TLIBA1_CurrentViewModeIndex
    PEA     -1.W
    CLR.L   -(A7)
    MOVE.L  D1,-(A7)
    BSR.W   _TLIBA3_BuildDisplayContextForViewMode

    MOVE.L  D0,_WDISP_DisplayContextBase
    MOVE.L  _TLIBA1_CurrentViewModeIndex,(A7)
    BSR.W   _TLIBA3_DrawViewModeOverlay

    LEA     12(A7),A7
    RTS

;!======