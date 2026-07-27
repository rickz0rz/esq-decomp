    XDEF    _ESQ_SetCopperEffect_OffDisableHighlight


;------------------------------------------------------------------------------
; FUNC: _ESQ_SetCopperEffect_OffDisableHighlight   (SetCopperEffectOffDisableHighlight)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A1
; CALLS:
;   _ESQ_SetCopperEffectParams, _GCOMMAND_DisableHighlight
; READS:
;   CIAB_PRA
; WRITES:
;   CIAB_PRA, _HIGHLIGHT_CopperEffectSeed, _HIGHLIGHT_CopperEffectParamA, _HIGHLIGHT_CopperEffectParamB, ESQ_CopperEffectListA, ESQ_CopperEffectListB
; DESC:
;   Sets CIAB_PRA bits to 01, clears both parameters, updates copper tables,
;   and disables UI highlight.
; NOTES:
;   Exact meaning of the parameters is unknown.
;------------------------------------------------------------------------------
_ESQ_SetCopperEffect_OffDisableHighlight:
    MOVEA.L #CIAB_PRA,A1
    MOVE.B  (A1),D1
    BCLR    #6,D1
    BSET    #7,D1
    MOVE.B  D1,(A1)
    MOVE.B  #0,D0
    MOVE.B  #0,D1
    BSR.S   _ESQ_SetCopperEffectParams

    JSR     _GCOMMAND_DisableHighlight

    RTS

;!======