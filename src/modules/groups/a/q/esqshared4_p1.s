    XDEF    _ESQSHARED4_InitializeBannerCopperSystem
    XDEF    ESQSHARED4_SetupBannerPlanePointerWords


;------------------------------------------------------------------------------
; FUNC: _ESQSHARED4_InitializeBannerCopperSystem   (InitializeBannerCopperSystem)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A1/A7/D0/D1
; CALLS:
;   _ESQSHARED4_ResetBannerColorSweepState, ESQSHARED4_SetupBannerPlanePointerWords, _ESQSHARED4_SnapshotDisplayBufferBases
; READS:
;   CIAB_PRA, _CONFIG_BannerCopperHeadByte
; WRITES:
;   _ESQ_CopperListBannerA, _ESQ_CopperListBannerB, ESQPARS2_CopperProgramPendingFlag, ESQPARS2_HighlightTickCountdown, _ESQPARS2_StateIndex, ESQPARS2_BannerSweepBaseColor, ESQPARS2_BannerSweepOffsetColor, _ESQPARS2_ReadModeFlags
; DESC:
;   Initializes banner copper-state globals, snapshots display buffer bases,
;   seeds banner plane pointer words, and enables CIAB PRA control bits.
; NOTES:
;   Sets baseline read/state flags used by subsequent banner color/plane updates.
;------------------------------------------------------------------------------
_ESQSHARED4_InitializeBannerCopperSystem:
    MOVEM.L D0-D1/A0-A4,-(A7)
    MOVE.W  #$62,D0
    MOVE.W  D0,ESQPARS2_BannerSweepBaseColor
    SUBQ.W  #2,D0
    MOVE.W  D0,ESQPARS2_BannerSweepOffsetColor
    MOVE.W  #5,_ESQPARS2_ReadModeFlags
    MOVE.W  #2,_ESQPARS2_StateIndex
    MOVE.W  #10,ESQPARS2_HighlightTickCountdown
    BSR.W   _ESQSHARED4_SnapshotDisplayBufferBases

    JSR     _ESQSHARED4_ResetBannerColorSweepState(PC)

    BSR.S   ESQSHARED4_SetupBannerPlanePointerWords

    MOVEA.L #CIAB_PRA,A1
    MOVE.B  (A1),D1
    BSET    #7,D1
    MOVE.B  D1,(A1)
    MOVEA.L #CIAB_PRA,A1
    MOVE.B  (A1),D1
    BSET    #6,D1
    MOVE.B  D1,(A1)
    MOVE.W  _CONFIG_BannerCopperHeadByte,D0
    MOVE.B  D0,_ESQ_CopperListBannerA
    MOVE.B  D0,_ESQ_CopperListBannerB
    MOVE.W  #1,ESQPARS2_CopperProgramPendingFlag
    MOVEM.L (A7)+,D0-D1/A0-A4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_SetupBannerPlanePointerWords   (Routine at ESQSHARED4_SetupBannerPlanePointerWords)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A1/A2/A3/A4/A7/D0/D2
; CALLS:
;   _ESQSHARED4_SetBannerColorBaseAndLimit
; READS:
;   _ESQPARS2_BannerSnapshotPlane0DstPtr, ESQPARS2_BannerRowOffsetResetPtrPlane0, ESQPARS2_BannerColorThreshold, _ESQPARS2_BannerColorBaseValue, _ESQSHARED_BannerRowScratchRasterBase0, _ESQSHARED_BannerRowScratchRasterBase1, _ESQSHARED_BannerRowScratchRasterBase2
; WRITES:
;   _ESQ_BannerPlane0SnapshotScratchPtrHiWord, _ESQ_BannerPlane0SnapshotScratchPtrLoWord, _ESQ_BannerPlane1SnapshotScratchPtrHiWord, _ESQ_BannerPlane1SnapshotScratchPtrLoWord, _ESQ_BannerPlane2SnapshotScratchPtrHiWord, _ESQ_BannerPlane2SnapshotScratchPtrLoWord, _ESQ_BannerSnapshotPlane0DstPtrHiWord, _ESQ_BannerSnapshotPlane0DstPtrLoWord, _ESQ_BannerSnapshotPlane1DstPtrHiWord, _ESQ_BannerSnapshotPlane1DstPtrLoWord, _ESQ_BannerSnapshotPlane2DstPtrHiWord, _ESQ_BannerSnapshotPlane2DstPtrLoWord, _ESQ_BannerPlane0DstPtrReset_HiWord, _ESQ_BannerPlane0DstPtrReset_LoWord, _ESQ_BannerPlane1DstPtrReset_HiWord, _ESQ_BannerPlane1DstPtrReset_LoWord, _ESQ_BannerPlane2DstPtrReset_HiWord, _ESQ_BannerPlane2DstPtrReset_LoWord, _ESQ_BannerPlane0ScratchPtrAlt_HiWord, _ESQ_BannerPlane0ScratchPtrAlt_LoWord, _ESQ_BannerPlane1ScratchPtrAlt_HiWord, _ESQ_BannerPlane1ScratchPtrAlt_LoWord, _ESQ_BannerPlane2ScratchPtrAlt_HiWord, _ESQ_BannerPlane2ScratchPtrAlt_LoWord, _ESQ_BannerSweepSrcPlane0Ptr_HiWord, _ESQ_BannerSweepSrcPlane0Ptr_LoWord, _ESQ_BannerSweepSrcPlane1Ptr_HiWord, _ESQ_BannerSweepSrcPlane1Ptr_LoWord, _ESQ_BannerSweepSrcPlane2Ptr_HiWord, _ESQ_BannerSweepSrcPlane2Ptr_LoWord, _ESQ_BannerSweepSrcPlane0PtrReset_HiWord, _ESQ_BannerSweepSrcPlane0PtrReset_LoWord, _ESQ_BannerSweepSrcPlane1PtrReset_HiWord, _ESQ_BannerSweepSrcPlane1PtrReset_LoWord, _ESQ_BannerSweepSrcPlane2PtrReset_HiWord, _ESQ_BannerSweepSrcPlane2PtrReset_LoWord, ESQPARS2_BannerRowOffsetResetPtrPlane1, ESQPARS2_BannerRowOffsetResetPtrPlane2Table
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_SetupBannerPlanePointerWords:
    MOVEM.L D0-D1/A0-A4,-(A7)
    LEA     _ESQPARS2_BannerSnapshotPlane0DstPtr,A1
    LEA     _ESQSHARED_BannerRowScratchRasterBase0,A3
    MOVEA.L (A3),A2
    LEA     2992(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,_ESQ_BannerPlane0SnapshotScratchPtrLoWord
    SWAP    D0
    MOVE.W  D0,_ESQ_BannerPlane0SnapshotScratchPtrHiWord
    MOVEA.L (A3),A2
    LEA     3080(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,_ESQ_BannerPlane0ScratchPtrAlt_LoWord
    SWAP    D0
    MOVE.W  D0,_ESQ_BannerPlane0ScratchPtrAlt_HiWord
    LEA     ESQPARS2_BannerRowOffsetResetPtrPlane0,A4
    LEA     _ESQPARS2_BannerSnapshotPlane0DstPtr,A1
    MOVEA.L (A3),A2
    LEA     GCOMMAND_BannerRowByteOffsetResetValueDefault(A2),A2
    MOVE.L  A2,(A1)+
    MOVE.L  A2,(A4)+
    MOVE.L  A2,D0
    MOVE.W  D0,_ESQ_BannerSnapshotPlane0DstPtrLoWord
    MOVE.W  D0,_ESQ_BannerPlane0DstPtrReset_LoWord
    SWAP    D0
    MOVE.W  D0,_ESQ_BannerSnapshotPlane0DstPtrHiWord
    MOVE.W  D0,_ESQ_BannerPlane0DstPtrReset_HiWord
    MOVEA.L (A3),A2
    LEA     6072(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,_ESQ_BannerSweepSrcPlane0Ptr_LoWord
    MOVE.W  D0,_ESQ_BannerSweepSrcPlane0PtrReset_LoWord
    SWAP    D0
    MOVE.W  D0,_ESQ_BannerSweepSrcPlane0Ptr_HiWord
    MOVE.W  D0,_ESQ_BannerSweepSrcPlane0PtrReset_HiWord
    LEA     _ESQSHARED_BannerRowScratchRasterBase1,A3
    MOVEA.L (A3),A2
    LEA     2992(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,_ESQ_BannerPlane1SnapshotScratchPtrLoWord
    SWAP    D0
    MOVE.W  D0,_ESQ_BannerPlane1SnapshotScratchPtrHiWord
    MOVEA.L (A3),A2
    LEA     3080(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,_ESQ_BannerPlane1ScratchPtrAlt_LoWord
    SWAP    D0
    MOVE.W  D0,_ESQ_BannerPlane1ScratchPtrAlt_HiWord
    MOVEA.L (A3),A2
    LEA     GCOMMAND_BannerRowByteOffsetResetValueDefault(A2),A2
    MOVE.L  A2,(A1)+
    MOVE.L  A2,ESQPARS2_BannerRowOffsetResetPtrPlane1
    MOVE.L  A2,D0
    MOVE.W  D0,_ESQ_BannerSnapshotPlane1DstPtrLoWord
    MOVE.W  D0,_ESQ_BannerPlane1DstPtrReset_LoWord
    SWAP    D0
    MOVE.W  D0,_ESQ_BannerSnapshotPlane1DstPtrHiWord
    MOVE.W  D0,_ESQ_BannerPlane1DstPtrReset_HiWord
    MOVEA.L (A3),A2
    LEA     6072(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,_ESQ_BannerSweepSrcPlane1Ptr_LoWord
    MOVE.W  D0,_ESQ_BannerSweepSrcPlane1PtrReset_LoWord
    SWAP    D0
    MOVE.W  D0,_ESQ_BannerSweepSrcPlane1Ptr_HiWord
    MOVE.W  D0,_ESQ_BannerSweepSrcPlane1PtrReset_HiWord
    LEA     _ESQSHARED_BannerRowScratchRasterBase2,A3
    MOVEA.L (A3),A2
    LEA     2992(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,_ESQ_BannerPlane2SnapshotScratchPtrLoWord
    SWAP    D0
    MOVE.W  D0,_ESQ_BannerPlane2SnapshotScratchPtrHiWord
    MOVEA.L (A3),A2
    LEA     3080(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,_ESQ_BannerPlane2ScratchPtrAlt_LoWord
    SWAP    D0
    MOVE.W  D0,_ESQ_BannerPlane2ScratchPtrAlt_HiWord
    MOVEA.L (A3),A2
    LEA     GCOMMAND_BannerRowByteOffsetResetValueDefault(A2),A2
    MOVE.L  A2,(A1)
    MOVE.L  A2,ESQPARS2_BannerRowOffsetResetPtrPlane2Table
    MOVE.L  A2,D0
    MOVE.W  D0,_ESQ_BannerSnapshotPlane2DstPtrLoWord
    MOVE.W  D0,_ESQ_BannerPlane2DstPtrReset_LoWord
    SWAP    D0
    MOVE.W  D0,_ESQ_BannerSnapshotPlane2DstPtrHiWord
    MOVE.W  D0,_ESQ_BannerPlane2DstPtrReset_HiWord
    MOVEA.L (A3),A2
    LEA     6072(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,_ESQ_BannerSweepSrcPlane2Ptr_LoWord
    MOVE.W  D0,_ESQ_BannerSweepSrcPlane2PtrReset_LoWord
    SWAP    D0
    MOVE.W  D0,_ESQ_BannerSweepSrcPlane2Ptr_HiWord
    MOVE.W  D0,_ESQ_BannerSweepSrcPlane2PtrReset_HiWord
    MOVE.W  ESQPARS2_BannerColorThreshold,D0
    BSR.W   _ESQSHARED4_SetBannerColorBaseAndLimit

    MOVEM.L (A7)+,D0-D1/A0-A4
    RTS

;!======

    MOVEM.L D2-D7/A2-A6,-(A7)
    MOVEQ   #0,D0
    MOVE.W  _ESQPARS2_BannerColorBaseValue,D0
    BSR.W   _ESQSHARED4_SetBannerColorBaseAndLimit

    MOVEM.L (A7)+,D2-D7/A2-A6
    RTS

;!======