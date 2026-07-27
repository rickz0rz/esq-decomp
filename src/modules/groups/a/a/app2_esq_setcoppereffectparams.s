    XDEF    _ESQ_SetCopperEffectParams


;------------------------------------------------------------------------------
; FUNC: _ESQ_SetCopperEffectParams   (SetCopperEffectParams)
; ARGS:
;   (none observed)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1
; CALLS:
;   _ESQ_UpdateCopperListsFromParams
; READS:
;   (none)
; WRITES:
;   _HIGHLIGHT_CopperEffectSeed, HIGHLIGHT_CopperEffectParamA, _HIGHLIGHT_CopperEffectParamB, ESQ_CopperEffectListA, ESQ_CopperEffectListB
; DESC:
;   Stores the effect parameters and regenerates the copper tables.
; NOTES:
;   Parameters are packed into _HIGHLIGHT_CopperEffectSeed.._HIGHLIGHT_CopperEffectParamB for _ESQ_UpdateCopperListsFromParams.
;------------------------------------------------------------------------------
_ESQ_SetCopperEffectParams:
    MOVE.B  D0,HIGHLIGHT_CopperEffectParamA
    MOVE.B  D1,_HIGHLIGHT_CopperEffectParamB
    MOVE.W  #5,_HIGHLIGHT_CopperEffectSeed
    BSR.S   _ESQ_UpdateCopperListsFromParams

    RTS

;!======