    XDEF    _ESQSHARED4_LoadDefaultPaletteToCopper_NoOp


;------------------------------------------------------------------------------
; FUNC: _ESQSHARED4_LoadDefaultPaletteToCopper_NoOp   (Routine at _ESQSHARED4_LoadDefaultPaletteToCopper_NoOp)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A1/A2/A3/A7/D0/D3
; CALLS:
;   ESQSHARED4_LoadCopperColorWordsFromNibbleTable
; READS:
;   _GCOMMAND_PresetFallbackValue0, ESQ_BannerPaletteWordsA, ESQ_BannerPaletteWordsB
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_ESQSHARED4_LoadDefaultPaletteToCopper_NoOp:
    RTS

;!======