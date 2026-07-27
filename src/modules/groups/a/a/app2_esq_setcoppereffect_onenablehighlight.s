    XDEF    _ESQ_SetCopperEffect_OnEnableHighlight


;------------------------------------------------------------------------------
; FUNC: _ESQ_SetCopperEffect_OnEnableHighlight   (SetCopperEffectOnEnableHighlight)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A1
; CALLS:
;   _ESQ_SetCopperEffectParams, _GCOMMAND_EnableHighlight
; READS:
;   CIAB_PRA
; WRITES:
;   CIAB_PRA, _HIGHLIGHT_CopperEffectSeed, HIGHLIGHT_CopperEffectParamA, _HIGHLIGHT_CopperEffectParamB, ESQ_CopperEffectListA, ESQ_CopperEffectListB
; DESC:
;   Sets CIAB_PRA bits to 11, loads parameters ($3F/0), updates copper tables,
;   and enables UI highlight.
; NOTES:
;   Exact meaning of the parameters is unknown.
;------------------------------------------------------------------------------
_ESQ_SetCopperEffect_OnEnableHighlight:
    MOVEA.L #CIAB_PRA,A1
    MOVE.B  (A1),D1
    BSET    #6,D1
    BSET    #7,D1
    MOVE.B  D1,(A1)
    MOVE.B  #$3f,D0
    MOVE.B  #0,D1
    BSR.S   _ESQ_SetCopperEffectParams

    JSR     _GCOMMAND_EnableHighlight

    RTS

;!======