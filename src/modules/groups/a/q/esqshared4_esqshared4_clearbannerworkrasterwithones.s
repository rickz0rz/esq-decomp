    XDEF    _ESQSHARED4_ClearBannerWorkRasterWithOnes


;------------------------------------------------------------------------------
; FUNC: _ESQSHARED4_ClearBannerWorkRasterWithOnes   (Routine at _ESQSHARED4_ClearBannerWorkRasterWithOnes)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A1/D1
; CALLS:
;   (none)
; READS:
;   LAB_0C7F, _WDISP_BannerWorkRasterPtr, ffffffff
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_ESQSHARED4_ClearBannerWorkRasterWithOnes:
    LEA     _WDISP_BannerWorkRasterPtr,A1
    MOVEA.L (A1),A0
    LEA (A0),A0
    MOVE.L  #$149,D1

.lab_0C7F:
    MOVE.L  #$ffffffff,(A0)+
    DBF     D1,.lab_0C7F
    RTS

;!======