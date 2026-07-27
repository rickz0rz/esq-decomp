    XDEF    _ESQ_SetCopperEffect_Default


;------------------------------------------------------------------------------
; FUNC: _ESQ_SetCopperEffect_Default   (SetCopperEffectDefault)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1
; CALLS:
;   _ESQ_SetCopperEffectParams
; READS:
;   (none)
; WRITES:
;   _HIGHLIGHT_CopperEffectSeed, HIGHLIGHT_CopperEffectParamA, _HIGHLIGHT_CopperEffectParamB, ESQ_CopperEffectListA, ESQ_CopperEffectListB
; DESC:
;   Loads a default effect parameter pair (0/$3F) and updates copper tables.
; NOTES:
;   Likely tied to a highlight/flash effect; exact purpose unknown.
;------------------------------------------------------------------------------
_ESQ_SetCopperEffect_Default:
    MOVE.B  #0,D0
    MOVE.B  #$3f,D1
    BSR.W   _ESQ_SetCopperEffectParams

    RTS

;!======