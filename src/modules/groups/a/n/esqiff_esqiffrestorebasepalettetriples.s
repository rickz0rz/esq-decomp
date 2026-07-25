    XDEF    _ESQIFF_RestoreBasePaletteTriples

;------------------------------------------------------------------------------
; FUNC: _ESQIFF_RestoreBasePaletteTriples   (RestoreBasePaletteTriples)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0/D7
; CALLS:
;   (none)
; READS:
;   _ESQFUNC_BasePaletteRgbTriples, _WDISP_PaletteTriplesRBase
; WRITES:
;   (none observed)
; DESC:
;   Restores 24 palette bytes from _ESQFUNC_BasePaletteRgbTriples into
;   _WDISP_PaletteTriplesRBase.
; NOTES:
;   Fixed-length byte copy loop; used before startup/status render transitions.
;------------------------------------------------------------------------------
_ESQIFF_RestoreBasePaletteTriples:
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

.lab_0A46:
    MOVEQ   #24,D0
    CMP.W   D0,D7
    BGE.S   .return

    LEA     _WDISP_PaletteTriplesRBase,A0
    ADDA.W  D7,A0
    LEA     _ESQFUNC_BasePaletteRgbTriples,A1
    ADDA.W  D7,A1
    MOVE.B  (A1),(A0)
    ADDQ.W  #1,D7
    BRA.S   .lab_0A46

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======
