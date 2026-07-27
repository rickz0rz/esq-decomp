    XDEF    _ESQSHARED4_ComputeBannerRowBlitGeometry


;------------------------------------------------------------------------------
; FUNC: _ESQSHARED4_ComputeBannerRowBlitGeometry   (Routine at _ESQSHARED4_ComputeBannerRowBlitGeometry)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   (none)
; READS:
;   _ESQPARS2_BannerRowCount, _ESQPARS2_BannerRowWidthBytes, _ESQPARS2_BannerCopyBlockSpanBytes
; WRITES:
;   _ESQPARS2_BannerRowCopyWordCount, _ESQPARS2_BannerRowCopySpanBytes, _ESQPARS2_BannerRowCopyStrideBytes, _ESQSHARED_BlitAddressOffset, _ESQPARS2_BannerCopyBlockWordLimit
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_ESQSHARED4_ComputeBannerRowBlitGeometry:
    MOVE.L  _ESQPARS2_BannerRowCount,D0
    MULU    #$58,D0
    MOVE.L  D0,_ESQPARS2_BannerRowCopySpanBytes
    CLR.L   D0
    MOVE.W  _ESQPARS2_BannerRowWidthBytes,D0
    LSR.W   #3,D0
    MOVE.L  D0,_ESQPARS2_BannerRowCopyStrideBytes
    ADDI.L  #$58,D0
    MOVE.L  D0,_ESQSHARED_BlitAddressOffset
    MOVE.W  _ESQPARS2_BannerCopyBlockSpanBytes,D0
    LSR.W   #5,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,_ESQPARS2_BannerRowCopyWordCount
    MOVE.W  #$22,D0
    LSR.W   #1,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,_ESQPARS2_BannerCopyBlockWordLimit
    RTS

;!======