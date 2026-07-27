    XDEF    ESQSHARED4_BindAndClearBannerWorkRaster


;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_BindAndClearBannerWorkRaster   (Routine at ESQSHARED4_BindAndClearBannerWorkRaster)
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
;   ESQ_BannerWorkRasterPtrA_HiWord, ESQ_BannerWorkRasterPtrA_LoWord, ESQ_BannerWorkRasterPtrMirrorA_HiWord, ESQ_BannerWorkRasterPtrMirrorA_LoWord, ESQ_BannerWorkRasterPtrTailA_HiWord, ESQ_CopperBannerRasterPointerListA, ESQ_BannerWorkRasterPtrB_HiWord, ESQ_BannerWorkRasterPtrB_LoWord, ESQ_BannerWorkRasterPtrMirrorB_HiWord, ESQ_BannerWorkRasterPtrMirrorB_LoWord, ESQ_BannerWorkRasterPtrTailB_HiWord, ESQ_CopperBannerRasterPointerListB
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_BindAndClearBannerWorkRaster:
    MOVEM.L D0/A0-A1,-(A7)

    LEA     _WDISP_BannerWorkRasterPtr,A0
    MOVEA.L (A0),A1
    LEA (A1),A1
    MOVE.L  A1,D0
    MOVE.W  D0,ESQ_BannerWorkRasterPtrA_LoWord
    MOVE.W  D0,ESQ_BannerWorkRasterPtrMirrorA_LoWord
    MOVE.W  D0,ESQ_CopperBannerRasterPointerListA
    MOVE.W  D0,ESQ_BannerWorkRasterPtrB_LoWord
    MOVE.W  D0,ESQ_BannerWorkRasterPtrMirrorB_LoWord
    MOVE.W  D0,ESQ_CopperBannerRasterPointerListB
    SWAP    D0
    MOVE.W  D0,ESQ_BannerWorkRasterPtrA_HiWord
    MOVE.W  D0,ESQ_BannerWorkRasterPtrMirrorA_HiWord
    MOVE.W  D0,ESQ_BannerWorkRasterPtrTailA_HiWord
    MOVE.W  D0,ESQ_BannerWorkRasterPtrB_HiWord
    MOVE.W  D0,ESQ_BannerWorkRasterPtrMirrorB_HiWord
    MOVE.W  D0,ESQ_BannerWorkRasterPtrTailB_HiWord
    BSR.S   _ESQSHARED4_ClearBannerWorkRasterWithOnes

    MOVEM.L (A7)+,D0/A0-A1
    RTS

;!======