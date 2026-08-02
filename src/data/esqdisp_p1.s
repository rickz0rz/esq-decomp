    XDEF    _ESQDISP_SecondaryPropagationDoneFlag
;------------------------------------------------------------------------------
; SYM: _ESQDISP_SecondaryPropagationDoneFlag   (secondary propagation done gate)
; TYPE: u16 flag
; PURPOSE: Prevents duplicate secondary metadata propagation within a slot window.
; USED BY: _ESQDISP_DrawStatusBanner_Impl
; NOTES: Cleared at window start and set after propagation routine runs.
;------------------------------------------------------------------------------
_ESQDISP_SecondaryPropagationDoneFlag:
    DC.W    $0001

; ---- joined from data/esqfunc.s by tools/data_merge.py ----
    XDEF    _Global_STR_ESQFUNC_C_1
; ========== ESQFUNC.c ==========

_Global_STR_ESQFUNC_C_1:
    NStr    "ESQFUNC.c"