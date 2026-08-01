    XDEF    _ESQSHARED4_BlitBannerRowsForActiveField
    XDEF    _ESQSHARED4_CopyBannerRowsWithByteOffset
    XDEF    _ESQSHARED4_CopyInterleavedRowWordsFromOffset
    XDEF    _ESQSHARED4_LoadCopperColorWordsFromNibbleTable


;------------------------------------------------------------------------------
; FUNC: _ESQSHARED4_CopyInterleavedRowWordsFromOffset   (Routine at _ESQSHARED4_CopyInterleavedRowWordsFromOffset)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A1/A2/A7/D0
; CALLS:
;   (none)
; READS:
;   _ESQSHARED4_InterleaveCopyBaseOffset, _ESQSHARED4_InterleaveCopyTailOffsetCurrent
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_ESQSHARED4_CopyInterleavedRowWordsFromOffset:
    MOVEM.L D0/A0-A2,-(A7)
    MOVEA.L A0,A1
    ADDA.L  _ESQSHARED4_InterleaveCopyBaseOffset,A1
    MOVEA.L A1,A2
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    ADDA.L  #$20,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    ADDA.L  #$20,A1
    MOVEA.L A0,A2
    ADDA.L  _ESQSHARED4_InterleaveCopyTailOffsetCurrent,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    MOVEM.L (A7)+,D0/A0-A2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _ESQSHARED4_CopyBannerRowsWithByteOffset   (Routine at _ESQSHARED4_CopyBannerRowsWithByteOffset)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A1/A2/A7/D0/D1
; CALLS:
;   (none)
; READS:
;   _ESQPARS2_BannerCopySourceOffset, _ESQPARS2_BannerCopyTailOffset, _ESQSHARED_BlitAddressOffset, _GCOMMAND_BannerRowByteOffsetCurrent, b0
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_ESQSHARED4_CopyBannerRowsWithByteOffset:
    MOVEM.L D0-D1/A0-A2,-(A7)
    MOVE.L  _ESQPARS2_BannerCopySourceOffset,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L A1,A2
    ADDA.L  #$b0,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  _ESQSHARED_BlitAddressOffset,A1
    ADDA.L  _ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  _ESQSHARED_BlitAddressOffset,A1
    ADDA.L  _ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  _ESQSHARED_BlitAddressOffset,A1
    ADDA.L  _ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  _ESQSHARED_BlitAddressOffset,A1
    ADDA.L  _ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  _ESQSHARED_BlitAddressOffset,A1
    ADDA.L  _ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  _ESQSHARED_BlitAddressOffset,A1
    ADDA.L  _ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  _ESQSHARED_BlitAddressOffset,A1
    ADDA.L  _ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  _ESQSHARED_BlitAddressOffset,A1
    ADDA.L  _ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  _ESQSHARED_BlitAddressOffset,A1
    ADDA.L  _ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  _ESQSHARED_BlitAddressOffset,A1
    ADDA.L  _ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  _ESQSHARED_BlitAddressOffset,A1
    ADDA.L  _ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  _ESQSHARED_BlitAddressOffset,A1
    ADDA.L  _ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  _ESQSHARED_BlitAddressOffset,A1
    ADDA.L  _ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  _ESQSHARED_BlitAddressOffset,A1
    ADDA.L  _ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  _ESQSHARED_BlitAddressOffset,A1
    ADDA.L  _ESQSHARED_BlitAddressOffset,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    ADDA.L  _ESQSHARED_BlitAddressOffset,A1
    MOVE.L  _GCOMMAND_BannerRowByteOffsetCurrent,D1
    ADD.L   _ESQPARS2_BannerCopyTailOffset,D1
    MOVEA.L A0,A2
    ADDA.L  D1,A2
    MOVE.W  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVE.L  (A2)+,(A1)+
    MOVEM.L (A7)+,D0-D1/A0-A2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _ESQSHARED4_BlitBannerRowsForActiveField   (Routine at _ESQSHARED4_BlitBannerRowsForActiveField)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0/D1
; CALLS:
;   _ESQSHARED4_CopyInterleavedRowWordsFromOffset, _ESQSHARED4_CopyBannerRowsWithByteOffset
; READS:
;   _ESQ_CopperListBannerA, _ESQ_CopperListBannerB, _ESQPARS2_BannerRowCopySpanBytes, _ESQPARS2_BannerRowCopyStrideBytes, _ESQPARS2_ActiveCopperListSelectFlag, _ESQSHARED_BannerRowScratchRasterBase0, _ESQSHARED_BannerRowScratchRasterBase1, _ESQSHARED_BannerRowScratchRasterBase2
; WRITES:
;   _ESQPARS2_BannerCopySourceOffset, _ESQPARS2_BannerCopyTailOffset
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_ESQSHARED4_BlitBannerRowsForActiveField:
    MOVEM.L D0/A0-A1,-(A7)
    MOVE.L  _ESQPARS2_BannerRowCopySpanBytes,D1
    MOVE.L  _ESQPARS2_BannerRowCopyStrideBytes,D0
    TST.L   _ESQPARS2_ActiveCopperListSelectFlag
    BNE.S   .lab_0C9F

    ADDI.L  #$58,D0
    LEA     _ESQ_CopperListBannerA,A0
    BRA.S   .lab_0CA0

.lab_0C9F:
    LEA     _ESQ_CopperListBannerB,A0

.lab_0CA0:
    MOVE.L  D0,_ESQPARS2_BannerCopyTailOffset
    ADD.L   D0,D1
    MOVE.L  D1,_ESQPARS2_BannerCopySourceOffset
    JSR     _ESQSHARED4_CopyInterleavedRowWordsFromOffset(PC)

    LEA     _ESQSHARED_BannerRowScratchRasterBase0,A1
    MOVEA.L (A1),A0
    JSR     _ESQSHARED4_CopyBannerRowsWithByteOffset(PC)

    LEA     _ESQSHARED_BannerRowScratchRasterBase1,A1
    MOVEA.L (A1),A0
    JSR     _ESQSHARED4_CopyBannerRowsWithByteOffset(PC)

    LEA     _ESQSHARED_BannerRowScratchRasterBase2,A1
    MOVEA.L (A1),A0
    JSR     _ESQSHARED4_CopyBannerRowsWithByteOffset(PC)

    MOVEM.L (A7)+,D0/A0-A1
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _ESQSHARED4_LoadCopperColorWordsFromNibbleTable   (Routine at _ESQSHARED4_LoadCopperColorWordsFromNibbleTable)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A4/D3/D4
; CALLS:
;   _ESQSHARED4_DecodeRgbNibbleTriplet
; READS:
;   _ESQ_BannerColorSweepProgramA, _ESQ_BannerColorSweepProgramA_AnchorColorWord, _ESQ_BannerColorSweepProgramA_TailColorWord, _ESQ_BannerColorSweepProgramB, _ESQ_BannerColorSweepProgramB_AnchorColorWord, _ESQ_BannerColorSweepProgramB_TailColorWord, lab_0CA2, lab_0CA3, lab_0CA4, lab_0CA5
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_ESQSHARED4_LoadCopperColorWordsFromNibbleTable:
    MOVEQ   #7,D4

.lab_0CA2:
    BSR.S   _ESQSHARED4_DecodeRgbNibbleTriplet

    CMPI.W  #4,D3
    BEQ.W   .lab_0CA3

    CMPI.W  #$1c,D3
    BEQ.W   .lab_0CA4

    MOVE.W  D0,0(A2,D3.W)
    MOVE.W  D0,0(A3,D3.W)
    BRA.W   .lab_0CA5

.lab_0CA3:
    LEA     _ESQ_BannerColorSweepProgramA,A4
    MOVE.W  D0,(A4)
    LEA     _ESQ_BannerColorSweepProgramB,A4
    MOVE.W  D0,(A4)
    LEA     _ESQ_BannerColorSweepProgramA_AnchorColorWord,A4
    MOVE.W  D0,(A4)
    LEA     _ESQ_BannerColorSweepProgramB_AnchorColorWord,A4
    MOVE.W  D0,(A4)
    BRA.W   .lab_0CA5

.lab_0CA4:
    LEA     _ESQ_BannerColorSweepProgramA_TailColorWord,A4
    MOVE.W  D0,(A4)
    LEA     _ESQ_BannerColorSweepProgramB_TailColorWord,A4
    MOVE.W  D0,(A4)

.lab_0CA5:
    ADDQ.W  #4,D3
    DBF     D4,.lab_0CA2
    RTS

;!======