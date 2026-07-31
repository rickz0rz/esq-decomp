    XDEF    _ESQ_SetCopperEffect_AllOn


;------------------------------------------------------------------------------
; FUNC: _ESQ_SetCopperEffect_AllOn   (SetCopperEffectAllOn)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A1
; CALLS:
;   _ESQ_SetCopperEffectParams
; READS:
;   CIAB_PRA
; WRITES:
;   CIAB_PRA, _HIGHLIGHT_CopperEffectSeed, _HIGHLIGHT_CopperEffectParamA, _HIGHLIGHT_CopperEffectParamB, ESQ_CopperEffectListA, ESQ_CopperEffectListB
; DESC:
;   Clears CIAB_PRA bits 6/7, sets both parameters to $3F, and updates the
;   copper tables.
; NOTES:
;   Exact meaning of the parameters is unknown.
;------------------------------------------------------------------------------
_ESQ_SetCopperEffect_AllOn:
    MOVEA.L #CIAB_PRA,A1
    MOVE.B  (A1),D1
    BCLR    #6,D1
    BCLR    #7,D1
    MOVE.B  D1,(A1)
    MOVE.B  #$3f,D0
    MOVE.B  #$3f,D1
    BSR.S   _ESQ_SetCopperEffectParams

    RTS

;!======