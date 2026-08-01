    XDEF    _ESQSHARED4_BindAndClearBannerWorkRaster


;------------------------------------------------------------------------------
; FUNC: _ESQSHARED4_BindAndClearBannerWorkRaster   (Routine at _ESQSHARED4_BindAndClearBannerWorkRaster)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0
; CALLS:
;   _ESQSHARED4_ClearBannerWorkRasterWithOnes
; READS:
;   _WDISP_BannerWorkRasterPtr
; WRITES:
;   _ESQ_BannerWorkRasterPtrA_HiWord, _ESQ_BannerWorkRasterPtrA_LoWord, _ESQ_BannerWorkRasterPtrMirrorA_HiWord, _ESQ_BannerWorkRasterPtrMirrorA_LoWord, _ESQ_BannerWorkRasterPtrTailA_HiWord, _ESQ_CopperBannerRasterPointerListA, _ESQ_BannerWorkRasterPtrB_HiWord, _ESQ_BannerWorkRasterPtrB_LoWord, _ESQ_BannerWorkRasterPtrMirrorB_HiWord, _ESQ_BannerWorkRasterPtrMirrorB_LoWord, _ESQ_BannerWorkRasterPtrTailB_HiWord, _ESQ_CopperBannerRasterPointerListB
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_ESQSHARED4_BindAndClearBannerWorkRaster:
    MOVEM.L D0/A0-A1,-(A7)

    LEA     _WDISP_BannerWorkRasterPtr,A0
    MOVEA.L (A0),A1
    LEA (A1),A1
    MOVE.L  A1,D0
    MOVE.W  D0,_ESQ_BannerWorkRasterPtrA_LoWord
    MOVE.W  D0,_ESQ_BannerWorkRasterPtrMirrorA_LoWord
    MOVE.W  D0,_ESQ_CopperBannerRasterPointerListA
    MOVE.W  D0,_ESQ_BannerWorkRasterPtrB_LoWord
    MOVE.W  D0,_ESQ_BannerWorkRasterPtrMirrorB_LoWord
    MOVE.W  D0,_ESQ_CopperBannerRasterPointerListB
    SWAP    D0
    MOVE.W  D0,_ESQ_BannerWorkRasterPtrA_HiWord
    MOVE.W  D0,_ESQ_BannerWorkRasterPtrMirrorA_HiWord
    MOVE.W  D0,_ESQ_BannerWorkRasterPtrTailA_HiWord
    MOVE.W  D0,_ESQ_BannerWorkRasterPtrB_HiWord
    MOVE.W  D0,_ESQ_BannerWorkRasterPtrMirrorB_HiWord
    MOVE.W  D0,_ESQ_BannerWorkRasterPtrTailB_HiWord
    BSR.S   _ESQSHARED4_ClearBannerWorkRasterWithOnes

    MOVEM.L (A7)+,D0/A0-A1
    RTS

;!======