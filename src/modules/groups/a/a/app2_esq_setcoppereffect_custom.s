    XDEF    _ESQ_SetCopperEffect_Custom


;------------------------------------------------------------------------------
; FUNC: _ESQ_SetCopperEffect_Custom   (SetCopperEffectCustom)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A1
; CALLS:
;   _ESQ_SetCopperEffectParams
; READS:
;   _HIGHLIGHT_CustomValue, CIAB_PRA
; WRITES:
;   CIAB_PRA, _HIGHLIGHT_CopperEffectSeed, _HIGHLIGHT_CopperEffectParamA, _HIGHLIGHT_CopperEffectParamB, _ESQ_CopperEffectListA, _ESQ_CopperEffectListB
; DESC:
;   Forces CIAB_PRA bits 6/7 high, uses _HIGHLIGHT_CustomValue as a parameter, and updates
;   the copper tables.
; NOTES:
;   Exact meaning of the parameters is unknown.
;------------------------------------------------------------------------------
_ESQ_SetCopperEffect_Custom:
    MOVEA.L #CIAB_PRA,A1
    MOVE.B  (A1),D1
    BSET    #6,D1
    BSET    #7,D1
    MOVE.B  D1,(A1)
    MOVE.B  #$3f,D0
    MOVE.B  _HIGHLIGHT_CustomValue,D1
    BSR.S   _ESQ_SetCopperEffectParams

    RTS

;!======