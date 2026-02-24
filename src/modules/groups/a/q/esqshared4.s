    XDEF    ESQSHARED4_ApplyBannerColorStep
    XDEF    ESQSHARED4_BindAndClearBannerWorkRaster
    XDEF    ESQSHARED4_BlitBannerRowsForActiveField
    XDEF    ESQSHARED4_ClearBannerWorkRasterWithOnes
    XDEF    ESQSHARED4_ComputeBannerRowBlitGeometry
    XDEF    ESQSHARED4_CopyBannerRowsWithByteOffset
    XDEF    ESQSHARED4_CopyInterleavedRowWordsFromOffset
    XDEF    ESQSHARED4_CopyLivePlanesToSnapshot
    XDEF    ESQSHARED4_CopyLongwordBlockDbfLoop
    XDEF    ESQSHARED4_CopyPlanesFromContextToSnapshot
    XDEF    ESQSHARED4_DecodeRgbNibbleTriplet
    XDEF    ESQSHARED4_InitializeBannerCopperSystem
    XDEF    ESQSHARED4_LoadCopperColorWordsFromNibbleTable
    XDEF    ESQSHARED4_LoadDefaultPaletteToCopper_NoOp
    XDEF    ESQSHARED4_ProgramDisplayWindowAndCopper
    XDEF    ESQSHARED4_ResetBannerColorSweepState
    XDEF    ESQSHARED4_ResetBannerColorToStart
    XDEF    ESQSHARED4_SetBannerColorBaseAndLimit
    XDEF    ESQSHARED4_SetBannerCopperColorAndThreshold
    XDEF    ESQSHARED4_SetupBannerPlanePointerWords
    XDEF    ESQSHARED4_SnapshotDisplayBufferBases
    XDEF    ESQSHARED4_TickCopperAndBannerTransitions
    XDEF    ESQSHARED4_ApplyBannerColorStep_Return

    ; Dead code
    MOVEM.L D0-D1/A0-A4,-(A7)
    MOVE.W  ESQSHARED_BannerColorModeWord,D0
    JSR     ESQSHARED4_ResetBannerColorSweepState

    MOVE.W  #$62,ESQPARS2_BannerColorStepCounter
    MOVE.W  #0,ESQPARS2_BannerSweepEntryGuardCounter
    MOVE.W  #0,ESQPARS2_BannerSweepDelayCounter
    LEA     ESQ_CopperListBannerA,A4
    MOVE.W  CONFIG_BannerCopperHeadByte,D0
    JSR     ESQSHARED4_ApplyBannerColorStep

    MOVEM.L (A7)+,D0-D1/A0-A4
    RTS

;!======

    ; Dead code.
    MOVEM.L D0-D1/A0-A4,-(A7)
    MOVE.W  ESQSHARED_BannerColorModeWord,D0
    JSR     ESQSHARED4_ResetBannerColorSweepState

    MOVE.W  #$62,ESQPARS2_BannerColorStepCounter
    MOVE.W  #1,ESQPARS2_BannerSweepEntryGuardCounter
    JSR     ESQSHARED4_ResetBannerColorToStart

    MOVEM.L (A7)+,D0-D1/A0-A4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_ResetBannerColorSweepState   (Routine at ESQSHARED4_ResetBannerColorSweepState)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   ESQSHARED4_ResetBannerColorToStart
; READS:
;   CONFIG_BannerCopperHeadByte, f5, f6
; WRITES:
;   ESQ_CopperBannerTailListA, ESQ_CopperBannerTailListB, ESQPARS2_BannerSweepEntryGuardCounter, ESQPARS2_BannerTailBiasValue, ESQPARS2_BannerColorStepCounter
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_ResetBannerColorSweepState:
    MOVEQ   #0,D0
    MOVE.B  #$f6,ESQ_CopperBannerTailListA
    MOVE.B  #$f6,ESQ_CopperBannerTailListB
    MOVE.W  #$f5,D0
    ADD.W   CONFIG_BannerCopperHeadByte,D0
    SUBI.W  #$80,D0
    MOVE.W  D0,ESQPARS2_BannerTailBiasValue
    MOVE.W  #$62,ESQPARS2_BannerColorStepCounter
    MOVE.W  #1,ESQPARS2_BannerSweepEntryGuardCounter
    JSR     ESQSHARED4_ResetBannerColorToStart

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_InitializeBannerCopperSystem   (InitializeBannerCopperSystem)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A1/A7/D0/D1
; CALLS:
;   ESQSHARED4_ResetBannerColorSweepState, ESQSHARED4_SetupBannerPlanePointerWords, ESQSHARED4_SnapshotDisplayBufferBases
; READS:
;   CIAB_PRA, CONFIG_BannerCopperHeadByte
; WRITES:
;   ESQ_CopperListBannerA, ESQ_CopperListBannerB, ESQPARS2_CopperProgramPendingFlag, ESQPARS2_HighlightTickCountdown, ESQPARS2_StateIndex, ESQPARS2_BannerSweepBaseColor, ESQPARS2_BannerSweepOffsetColor, ESQPARS2_ReadModeFlags
; DESC:
;   Initializes banner copper-state globals, snapshots display buffer bases,
;   seeds banner plane pointer words, and enables CIAB PRA control bits.
; NOTES:
;   Sets baseline read/state flags used by subsequent banner color/plane updates.
;------------------------------------------------------------------------------
ESQSHARED4_InitializeBannerCopperSystem:
    MOVEM.L D0-D1/A0-A4,-(A7)
    MOVE.W  #$62,D0
    MOVE.W  D0,ESQPARS2_BannerSweepBaseColor
    SUBQ.W  #2,D0
    MOVE.W  D0,ESQPARS2_BannerSweepOffsetColor
    MOVE.W  #5,ESQPARS2_ReadModeFlags
    MOVE.W  #2,ESQPARS2_StateIndex
    MOVE.W  #10,ESQPARS2_HighlightTickCountdown
    JSR     ESQSHARED4_SnapshotDisplayBufferBases

    JSR     ESQSHARED4_ResetBannerColorSweepState(PC)

    JSR     ESQSHARED4_SetupBannerPlanePointerWords

    MOVEA.L #CIAB_PRA,A1
    MOVE.B  (A1),D1
    BSET    #7,D1
    MOVE.B  D1,(A1)
    MOVEA.L #CIAB_PRA,A1
    MOVE.B  (A1),D1
    BSET    #6,D1
    MOVE.B  D1,(A1)
    MOVE.W  CONFIG_BannerCopperHeadByte,D0
    MOVE.B  D0,ESQ_CopperListBannerA
    MOVE.B  D0,ESQ_CopperListBannerB
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
;   ESQSHARED4_SetBannerColorBaseAndLimit
; READS:
;   ESQPARS2_BannerSnapshotPlane0DstPtr, ESQPARS2_BannerRowOffsetResetPtrPlane0, ESQPARS2_BannerColorThreshold, ESQPARS2_BannerColorBaseValue, ESQSHARED_BannerRowScratchRasterBase0, ESQSHARED_BannerRowScratchRasterBase1, ESQSHARED_BannerRowScratchRasterBase2
; WRITES:
;   ESQ_BannerPlane0SnapshotScratchPtrHiWord, ESQ_BannerPlane0SnapshotScratchPtrLoWord, ESQ_BannerPlane1SnapshotScratchPtrHiWord, ESQ_BannerPlane1SnapshotScratchPtrLoWord, ESQ_BannerPlane2SnapshotScratchPtrHiWord, ESQ_BannerPlane2SnapshotScratchPtrLoWord, ESQ_BannerSnapshotPlane0DstPtrHiWord, ESQ_BannerSnapshotPlane0DstPtrLoWord, ESQ_BannerSnapshotPlane1DstPtrHiWord, ESQ_BannerSnapshotPlane1DstPtrLoWord, ESQ_BannerSnapshotPlane2DstPtrHiWord, ESQ_BannerSnapshotPlane2DstPtrLoWord, ESQ_BannerPlane0DstPtrReset_HiWord, ESQ_BannerPlane0DstPtrReset_LoWord, ESQ_BannerPlane1DstPtrReset_HiWord, ESQ_BannerPlane1DstPtrReset_LoWord, ESQ_BannerPlane2DstPtrReset_HiWord, ESQ_BannerPlane2DstPtrReset_LoWord, ESQ_BannerPlane0ScratchPtrAlt_HiWord, ESQ_BannerPlane0ScratchPtrAlt_LoWord, ESQ_BannerPlane1ScratchPtrAlt_HiWord, ESQ_BannerPlane1ScratchPtrAlt_LoWord, ESQ_BannerPlane2ScratchPtrAlt_HiWord, ESQ_BannerPlane2ScratchPtrAlt_LoWord, ESQ_BannerSweepSrcPlane0Ptr_HiWord, ESQ_BannerSweepSrcPlane0Ptr_LoWord, ESQ_BannerSweepSrcPlane1Ptr_HiWord, ESQ_BannerSweepSrcPlane1Ptr_LoWord, ESQ_BannerSweepSrcPlane2Ptr_HiWord, ESQ_BannerSweepSrcPlane2Ptr_LoWord, ESQ_BannerSweepSrcPlane0PtrReset_HiWord, ESQ_BannerSweepSrcPlane0PtrReset_LoWord, ESQ_BannerSweepSrcPlane1PtrReset_HiWord, ESQ_BannerSweepSrcPlane1PtrReset_LoWord, ESQ_BannerSweepSrcPlane2PtrReset_HiWord, ESQ_BannerSweepSrcPlane2PtrReset_LoWord, ESQPARS2_BannerRowOffsetResetPtrPlane1, ESQPARS2_BannerRowOffsetResetPtrPlane2Table
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_SetupBannerPlanePointerWords:
    MOVEM.L D0-D1/A0-A4,-(A7)
    LEA     ESQPARS2_BannerSnapshotPlane0DstPtr,A1
    LEA     ESQSHARED_BannerRowScratchRasterBase0,A3
    MOVEA.L (A3),A2
    LEA     2992(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,ESQ_BannerPlane0SnapshotScratchPtrLoWord
    SWAP    D0
    MOVE.W  D0,ESQ_BannerPlane0SnapshotScratchPtrHiWord
    MOVEA.L (A3),A2
    LEA     3080(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,ESQ_BannerPlane0ScratchPtrAlt_LoWord
    SWAP    D0
    MOVE.W  D0,ESQ_BannerPlane0ScratchPtrAlt_HiWord
    LEA     ESQPARS2_BannerRowOffsetResetPtrPlane0,A4
    LEA     ESQPARS2_BannerSnapshotPlane0DstPtr,A1
    MOVEA.L (A3),A2
    LEA     GCOMMAND_BannerRowByteOffsetResetValueDefault(A2),A2
    MOVE.L  A2,(A1)+
    MOVE.L  A2,(A4)+
    MOVE.L  A2,D0
    MOVE.W  D0,ESQ_BannerSnapshotPlane0DstPtrLoWord
    MOVE.W  D0,ESQ_BannerPlane0DstPtrReset_LoWord
    SWAP    D0
    MOVE.W  D0,ESQ_BannerSnapshotPlane0DstPtrHiWord
    MOVE.W  D0,ESQ_BannerPlane0DstPtrReset_HiWord
    MOVEA.L (A3),A2
    LEA     6072(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,ESQ_BannerSweepSrcPlane0Ptr_LoWord
    MOVE.W  D0,ESQ_BannerSweepSrcPlane0PtrReset_LoWord
    SWAP    D0
    MOVE.W  D0,ESQ_BannerSweepSrcPlane0Ptr_HiWord
    MOVE.W  D0,ESQ_BannerSweepSrcPlane0PtrReset_HiWord
    LEA     ESQSHARED_BannerRowScratchRasterBase1,A3
    MOVEA.L (A3),A2
    LEA     2992(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,ESQ_BannerPlane1SnapshotScratchPtrLoWord
    SWAP    D0
    MOVE.W  D0,ESQ_BannerPlane1SnapshotScratchPtrHiWord
    MOVEA.L (A3),A2
    LEA     3080(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,ESQ_BannerPlane1ScratchPtrAlt_LoWord
    SWAP    D0
    MOVE.W  D0,ESQ_BannerPlane1ScratchPtrAlt_HiWord
    MOVEA.L (A3),A2
    LEA     GCOMMAND_BannerRowByteOffsetResetValueDefault(A2),A2
    MOVE.L  A2,(A1)+
    MOVE.L  A2,ESQPARS2_BannerRowOffsetResetPtrPlane1
    MOVE.L  A2,D0
    MOVE.W  D0,ESQ_BannerSnapshotPlane1DstPtrLoWord
    MOVE.W  D0,ESQ_BannerPlane1DstPtrReset_LoWord
    SWAP    D0
    MOVE.W  D0,ESQ_BannerSnapshotPlane1DstPtrHiWord
    MOVE.W  D0,ESQ_BannerPlane1DstPtrReset_HiWord
    MOVEA.L (A3),A2
    LEA     6072(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,ESQ_BannerSweepSrcPlane1Ptr_LoWord
    MOVE.W  D0,ESQ_BannerSweepSrcPlane1PtrReset_LoWord
    SWAP    D0
    MOVE.W  D0,ESQ_BannerSweepSrcPlane1Ptr_HiWord
    MOVE.W  D0,ESQ_BannerSweepSrcPlane1PtrReset_HiWord
    LEA     ESQSHARED_BannerRowScratchRasterBase2,A3
    MOVEA.L (A3),A2
    LEA     2992(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,ESQ_BannerPlane2SnapshotScratchPtrLoWord
    SWAP    D0
    MOVE.W  D0,ESQ_BannerPlane2SnapshotScratchPtrHiWord
    MOVEA.L (A3),A2
    LEA     3080(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,ESQ_BannerPlane2ScratchPtrAlt_LoWord
    SWAP    D0
    MOVE.W  D0,ESQ_BannerPlane2ScratchPtrAlt_HiWord
    MOVEA.L (A3),A2
    LEA     GCOMMAND_BannerRowByteOffsetResetValueDefault(A2),A2
    MOVE.L  A2,(A1)
    MOVE.L  A2,ESQPARS2_BannerRowOffsetResetPtrPlane2Table
    MOVE.L  A2,D0
    MOVE.W  D0,ESQ_BannerSnapshotPlane2DstPtrLoWord
    MOVE.W  D0,ESQ_BannerPlane2DstPtrReset_LoWord
    SWAP    D0
    MOVE.W  D0,ESQ_BannerSnapshotPlane2DstPtrHiWord
    MOVE.W  D0,ESQ_BannerPlane2DstPtrReset_HiWord
    MOVEA.L (A3),A2
    LEA     6072(A2),A2
    MOVE.L  A2,D0
    MOVE.W  D0,ESQ_BannerSweepSrcPlane2Ptr_LoWord
    MOVE.W  D0,ESQ_BannerSweepSrcPlane2PtrReset_LoWord
    SWAP    D0
    MOVE.W  D0,ESQ_BannerSweepSrcPlane2Ptr_HiWord
    MOVE.W  D0,ESQ_BannerSweepSrcPlane2PtrReset_HiWord
    MOVE.W  ESQPARS2_BannerColorThreshold,D0
    BSR.W   ESQSHARED4_SetBannerColorBaseAndLimit

    MOVEM.L (A7)+,D0-D1/A0-A4
    RTS

;!======

    MOVEM.L D2-D7/A2-A6,-(A7)
    MOVEQ   #0,D0
    MOVE.W  ESQPARS2_BannerColorBaseValue,D0
    BSR.W   ESQSHARED4_SetBannerColorBaseAndLimit

    MOVEM.L (A7)+,D2-D7/A2-A6
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_SetBannerColorBaseAndLimit   (Routine at ESQSHARED4_SetBannerColorBaseAndLimit)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D1
; CALLS:
;   (none)
; READS:
;   d9
; WRITES:
;   ESQ_BannerColorClampValueA, ESQ_BannerColorClampWaitRowA, ESQ_BannerColorClampValueB, ESQ_BannerColorClampWaitRowB, ESQPARS2_BannerColorBaseValue
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_SetBannerColorBaseAndLimit:
    MOVE.W  D0,ESQPARS2_BannerColorBaseValue
    MOVE.W  #$d9,D1
    MOVE.B  D0,ESQ_BannerColorClampValueA
    MOVE.B  D0,ESQ_BannerColorClampValueB
    MOVE.B  D1,ESQ_BannerColorClampWaitRowA
    MOVE.B  D1,ESQ_BannerColorClampWaitRowB
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_BindAndClearBannerWorkRaster   (Routine at ESQSHARED4_BindAndClearBannerWorkRaster)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0
; CALLS:
;   ESQSHARED4_ClearBannerWorkRasterWithOnes
; READS:
;   WDISP_BannerWorkRasterPtr
; WRITES:
;   ESQ_BannerWorkRasterPtrA_HiWord, ESQ_BannerWorkRasterPtrA_LoWord, ESQ_BannerWorkRasterPtrMirrorA_HiWord, ESQ_BannerWorkRasterPtrMirrorA_LoWord, ESQ_BannerWorkRasterPtrTailA_HiWord, ESQ_CopperBannerRasterPointerListA, ESQ_BannerWorkRasterPtrB_HiWord, ESQ_BannerWorkRasterPtrB_LoWord, ESQ_BannerWorkRasterPtrMirrorB_HiWord, ESQ_BannerWorkRasterPtrMirrorB_LoWord, ESQ_BannerWorkRasterPtrTailB_HiWord, ESQ_CopperBannerRasterPointerListB
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_BindAndClearBannerWorkRaster:
    MOVEM.L D0/A0-A1,-(A7)

    LEA     WDISP_BannerWorkRasterPtr,A0
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
    JSR     ESQSHARED4_ClearBannerWorkRasterWithOnes

    MOVEM.L (A7)+,D0/A0-A1
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_ClearBannerWorkRasterWithOnes   (Routine at ESQSHARED4_ClearBannerWorkRasterWithOnes)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A1/D1
; CALLS:
;   (none)
; READS:
;   LAB_0C7F, WDISP_BannerWorkRasterPtr, ffffffff
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_ClearBannerWorkRasterWithOnes:
    LEA     WDISP_BannerWorkRasterPtr,A1
    MOVEA.L (A1),A0
    LEA (A0),A0
    MOVE.L  #$149,D1

.lab_0C7F:
    MOVE.L  #$ffffffff,(A0)+
    DBF     D1,.lab_0C7F
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_ProgramDisplayWindowAndCopper   (Routine at ESQSHARED4_ProgramDisplayWindowAndCopper)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/D0
; CALLS:
;   ESQSHARED4_LoadDefaultPaletteToCopper_NoOp
; READS:
;   BLTDDAT, COPJMP1, DDFSTOP_WIDE, DDFSTRT_WIDE, ESQ_CopperEffectListA, ESQ_CopperEffectSwitchWaitWordA, ESQ_CopperEffectListB, ESQ_CopperEffectSwitchWaitWordB, VPOSR, ffc5
; WRITES:
;   BLTDDAT, BPL1MOD, BPL2MOD, COP1LCH, DDFSTOP, DDFSTRT, DIWSTOP, DIWSTRT, DMACON, ESQ_CopperEffectListB_PtrHiWord, ESQ_CopperEffectListB_PtrLoWord, ESQ_CopperEffectJumpTargetA_HiWord, ESQ_CopperEffectJumpTargetA_LoWord, ESQ_CopperEffectListA_PtrHiWord, ESQ_CopperEffectListA_PtrLoWord, ESQ_CopperEffectJumpTargetB_HiWord, ESQ_CopperEffectJumpTargetB_LoWord
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_ProgramDisplayWindowAndCopper:
    LEA     BLTDDAT,A0
    MOVE.W  #$1761,(DIWSTRT-BLTDDAT)(A0)    ; $17, $61  -> 23, 97
    MOVE.W  #$ffc5,(DIWSTOP-BLTDDAT)(A0)    ; $ff, $c5  -> 255, 197
    MOVE.W  #DDFSTRT_WIDE,(DDFSTRT-BLTDDAT)(A0)
    MOVE.W  #DDFSTOP_WIDE,(DDFSTOP-BLTDDAT)(A0)
    ; $58 = 88
    ; 88 * 8 = 704
    ; SCREEN_WIDTH_BYTES	equ (320/8)
    ; SCREEN_BIT_DEPTH	equ 5
    ; BPL1MOD,SCREEN_WIDTH_BYTES*SCREEN_BIT_DEPTH-SCREEN_WIDTH_BYTES
    ; how is this calculated?
    MOVE.W  #$58,(BPL1MOD-BLTDDAT)(A0)
    MOVE.W  #$58,(BPL2MOD-BLTDDAT)(A0)
    JSR     ESQSHARED4_LoadDefaultPaletteToCopper_NoOp

    LEA     ESQ_CopperEffectListB,A2
    MOVE.L  A2,D0
    MOVE.W  D0,ESQ_CopperEffectListB_PtrLoWord
    SWAP    D0
    MOVE.W  D0,ESQ_CopperEffectListB_PtrHiWord
    LEA     ESQ_CopperEffectListA,A2
    MOVE.L  A2,D0
    MOVE.W  D0,ESQ_CopperEffectListA_PtrLoWord
    SWAP    D0
    MOVE.W  D0,ESQ_CopperEffectListA_PtrHiWord
    LEA     ESQ_CopperEffectSwitchWaitWordA,A2
    MOVE.L  A2,D0
    MOVE.W  D0,ESQ_CopperEffectJumpTargetA_LoWord
    SWAP    D0
    MOVE.W  D0,ESQ_CopperEffectJumpTargetA_HiWord
    LEA     ESQ_CopperEffectSwitchWaitWordB,A2
    MOVE.L  A2,D0
    MOVE.W  D0,ESQ_CopperEffectJumpTargetB_LoWord
    SWAP    D0
    MOVE.W  D0,ESQ_CopperEffectJumpTargetB_HiWord
    LEA     ESQ_CopperEffectListB,A2
    MOVE.W  (VPOSR-BLTDDAT)(A0),D0
    BPL.S   .lab_0C81

    LEA     ESQ_CopperEffectListA,A2

.lab_0C81:
    MOVE.L  A2,(COP1LCH-BLTDDAT)(A0)
    MOVE.W  (COPJMP1-BLTDDAT)(A0),D0
    MOVE.W  #$20,(DMACON-BLTDDAT)(A0)
    MOVE.W  #$8180,(DMACON-BLTDDAT)(A0)
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_TickCopperAndBannerTransitions   (Routine at ESQSHARED4_TickCopperAndBannerTransitions)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A7/D0/D1
; CALLS:
;   GCOMMAND_TickHighlightState, ESQSHARED4_ProgramDisplayWindowAndCopper, ESQSHARED4_BlitBannerRowsForActiveField, SCRIPT_UpdateBannerCharTransition
; READS:
;   BLTDDAT, LAB_0C85, LAB_0C86, LAB_0C87, LAB_0C89, LAB_0C8A, LAB_0C8B, ED2_HighlightTickEnabledFlag, ESQ_CopperEffectListA, ESQ_BannerSnapshotPlane0DstPtrHiWord, ESQ_BannerSnapshotPlane0DstPtrLoWord, ESQ_BannerSnapshotPlane1DstPtrHiWord, ESQ_BannerSnapshotPlane1DstPtrLoWord, ESQ_BannerSnapshotPlane2DstPtrHiWord, ESQ_BannerSnapshotPlane2DstPtrLoWord, ESQ_CopperEffectListB, ESQPARS2_CopperProgramPendingFlag, ESQPARS2_StateIndex, ESQPARS2_ReadModeFlags, GCOMMAND_HighlightHoldoffTickCount, SCRIPT_BannerTransitionActive, VPOSR, b0
; WRITES:
;   BLTDDAT, COP1LCH, ESQ_BannerSnapshotPlane0DstPtrHiWord, ESQ_BannerSnapshotPlane0DstPtrLoWord, ESQ_BannerSnapshotPlane1DstPtrHiWord, ESQ_BannerSnapshotPlane1DstPtrLoWord, ESQ_BannerSnapshotPlane2DstPtrHiWord, ESQ_BannerSnapshotPlane2DstPtrLoWord, ESQ_BannerSweepSrcPlane0Ptr_HiWord, ESQ_BannerSweepSrcPlane0Ptr_LoWord, ESQ_BannerSweepSrcPlane1Ptr_HiWord, ESQ_BannerSweepSrcPlane1Ptr_LoWord, ESQ_BannerSweepSrcPlane2Ptr_HiWord, ESQ_BannerSweepSrcPlane2Ptr_LoWord, ESQPARS2_BannerSnapshotPlane0DstPtr, ESQPARS2_BannerSnapshotPlane0DstPtrLo, ESQPARS2_BannerSnapshotPlane1DstPtr, ESQPARS2_BannerSnapshotPlane1DstPtrLo, ESQPARS2_BannerSnapshotPlane2DstPtr, ESQPARS2_BannerSnapshotPlane2DstPtrLo, ESQPARS2_CopperProgramPendingFlag, ESQPARS2_HighlightTickCountdown, ESQPARS2_ReadModeFlags, ESQPARS2_ActiveCopperListSelectFlag, GCOMMAND_HighlightHoldoffTickCount
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_TickCopperAndBannerTransitions:
    MOVEM.L D0-D3/A0-A6,-(A7)

    LEA     BLTDDAT,A0
    LEA     ESQ_CopperEffectListA,A2
    MOVEQ   #1,D1
    MOVE.W  (VPOSR-BLTDDAT)(A0),D0
    BPL.S   .lab_0C83            ; BPL = checks to see if bit 15 is set (LOF), if it is jump to LAB_0C83

    LEA     ESQ_CopperEffectListB,A2
    MOVEQ   #0,D1

.lab_0C83:
    MOVE.L  A2,(COP1LCH-BLTDDAT)(A0)
    MOVE.L  D1,ESQPARS2_ActiveCopperListSelectFlag
    TST.W   ESQPARS2_CopperProgramPendingFlag
    BEQ.S   .lab_0C84

    JSR     ESQSHARED4_ProgramDisplayWindowAndCopper(PC)

    MOVE.W  #0,ESQPARS2_CopperProgramPendingFlag
    BRA.W   .lab_0C8B

.lab_0C84:
    JSR     SCRIPT_UpdateBannerCharTransition

    TST.W   SCRIPT_BannerTransitionActive
    BNE.W   .lab_0C8B

    TST.B   GCOMMAND_HighlightHoldoffTickCount
    BNE.W   .lab_0C8A

    CMPI.W  #$200,ESQPARS2_ReadModeFlags
    BNE.W   .lab_0C85

    MOVE.W  #$100,ESQPARS2_ReadModeFlags
    BRA.W   .lab_0C89

.lab_0C85:
    CMPI.W  #$102,ESQPARS2_ReadModeFlags
    BNE.W   .lab_0C86

    BRA.W   .lab_0C8B

.lab_0C86:
    CMPI.W  #$101,ESQPARS2_ReadModeFlags
    BNE.W   .lab_0C87

    BRA.W   .lab_0C8B

.lab_0C87:
    CMPI.W  #$100,ESQPARS2_ReadModeFlags
    BEQ.W   .lab_0C8B

    TST.W   ESQPARS2_ReadModeFlags
    BMI.S   .lab_0C88

    MOVEQ   #1,D0
    SUB.W   D0,ESQPARS2_ReadModeFlags
    BRA.W   .lab_0C8B

.lab_0C88:
    SUBQ.W  #1,ESQPARS2_HighlightTickCountdown
    BPL.S   .lab_0C8B

.lab_0C89:
    MOVE.W  ESQPARS2_StateIndex,ESQPARS2_HighlightTickCountdown
    TST.W   ED2_HighlightTickEnabledFlag
    BEQ.S   .lab_0C8B

    JSR     GCOMMAND_TickHighlightState

    BRA.S   .lab_0C8B

.lab_0C8A:
    SUBQ.B  #1,GCOMMAND_HighlightHoldoffTickCount
    SUBQ.W  #1,ESQPARS2_HighlightTickCountdown
    JSR     ESQSHARED4_BlitBannerRowsForActiveField

.lab_0C8B:
    MOVEM.L (A7)+,D0-D3/A0-A6
    RTS

;!======

    MOVE.W  ESQ_BannerSnapshotPlane0DstPtrLoWord,ESQPARS2_BannerSnapshotPlane0DstPtrLo
    MOVE.W  ESQ_BannerSnapshotPlane0DstPtrHiWord,ESQPARS2_BannerSnapshotPlane0DstPtr
    MOVE.W  ESQ_BannerSnapshotPlane1DstPtrLoWord,ESQPARS2_BannerSnapshotPlane1DstPtrLo
    MOVE.W  ESQ_BannerSnapshotPlane1DstPtrHiWord,ESQPARS2_BannerSnapshotPlane1DstPtr
    MOVE.W  ESQ_BannerSnapshotPlane2DstPtrLoWord,ESQPARS2_BannerSnapshotPlane2DstPtrLo
    MOVE.W  ESQ_BannerSnapshotPlane2DstPtrHiWord,ESQPARS2_BannerSnapshotPlane2DstPtr
    RTS

;!======

    MOVE.L  #$b0,D1
    MOVEQ   #1,D0
    ADD.W   D1,ESQ_BannerSnapshotPlane0DstPtrLoWord
    BCC.S   .lab_0C8C

    ADD.W   D0,ESQ_BannerSnapshotPlane0DstPtrHiWord

.lab_0C8C:
    ADD.W   D1,ESQ_BannerSnapshotPlane1DstPtrLoWord
    BCC.S   .lab_0C8D

    ADD.W   D0,ESQ_BannerSnapshotPlane1DstPtrHiWord

.lab_0C8D:
    ADD.W   D1,ESQ_BannerSnapshotPlane2DstPtrLoWord
    BCC.S   .lab_0C8E

    ADD.W   D0,ESQ_BannerSnapshotPlane2DstPtrHiWord

.lab_0C8E:
    ADD.W   D1,ESQ_BannerSweepSrcPlane0Ptr_LoWord
    BCC.S   .lab_0C8F

    ADD.W   D0,ESQ_BannerSweepSrcPlane0Ptr_HiWord

.lab_0C8F:
    ADD.W   D1,ESQ_BannerSweepSrcPlane1Ptr_LoWord
    BCC.S   .lab_0C90

    ADD.W   D0,ESQ_BannerSweepSrcPlane1Ptr_HiWord

.lab_0C90:
    ADD.W   D1,ESQ_BannerSweepSrcPlane2Ptr_LoWord
    BCC.S   .lab_0C91

    ADD.W   D0,ESQ_BannerSweepSrcPlane2Ptr_HiWord

.lab_0C91:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_SnapshotDisplayBufferBases   (Routine at ESQSHARED4_SnapshotDisplayBufferBases)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A1/A7
; CALLS:
;   (none)
; READS:
;   ESQSHARED_LivePlaneBase0, ESQSHARED_LivePlaneBase1, ESQSHARED_LivePlaneBase2
; WRITES:
;   ESQPARS2_SnapshotLivePlane0Base, ESQPARS2_SnapshotLivePlane1Base, ESQPARS2_SnapshotLivePlane2Base
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_SnapshotDisplayBufferBases:
    MOVE.L  A1,-(A7)
    LEA     ESQSHARED_LivePlaneBase0,A1
    MOVE.L  (A1),ESQPARS2_SnapshotLivePlane0Base
    LEA     ESQSHARED_LivePlaneBase1,A1
    MOVE.L  (A1),ESQPARS2_SnapshotLivePlane1Base
    LEA     ESQSHARED_LivePlaneBase2,A1
    MOVE.L  (A1),ESQPARS2_SnapshotLivePlane2Base
    MOVEA.L (A7)+,A1
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_CopyPlanesFromContextToSnapshot   (Routine at ESQSHARED4_CopyPlanesFromContextToSnapshot)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A1/A2/A3/A4/A7/D1
; CALLS:
;   (none)
; READS:
;   ESQPARS2_BannerSnapshotPlane0DstPtr, lab_0C94, lab_0C95, lab_0C96
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_CopyPlanesFromContextToSnapshot:
    MOVEM.L D1/A1-A4,-(A7)
    LEA     20(A1),A1
    LEA     ESQPARS2_BannerSnapshotPlane0DstPtr,A2
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1

.lab_0C94:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,.lab_0C94
    MOVE.L  A3,(A1)+
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1

.lab_0C95:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,.lab_0C95
    MOVE.L  A3,(A1)+
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1

.lab_0C96:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,.lab_0C96
    MOVE.L  A3,(A1)+
    MOVEM.L (A7)+,D1/A1-A4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_CopyLivePlanesToSnapshot   (Routine at ESQSHARED4_CopyLivePlanesToSnapshot)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A1/A2/A3/A4/A7/D1
; CALLS:
;   (none)
; READS:
;   ESQPARS2_BannerSnapshotPlane0DstPtr, ESQSHARED_LivePlaneBase0, ESQSHARED_LivePlaneBase1, ESQSHARED_LivePlaneBase2, lab_0C98, lab_0C99
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_CopyLivePlanesToSnapshot:
    MOVEM.L D0-D1/A0-A4,-(A7)
    LEA     ESQSHARED_LivePlaneBase0,A1
    MOVEA.L (A1),A3
    LEA     ESQPARS2_BannerSnapshotPlane0DstPtr,A2
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1

.lab_0C98:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,.lab_0C98
    LEA     ESQSHARED_LivePlaneBase1,A1
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1

.lab_0C99:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,.lab_0C99
    LEA     ESQSHARED_LivePlaneBase2,A1
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_CopyLongwordBlockDbfLoop   (Routine at ESQSHARED4_CopyLongwordBlockDbfLoop)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A4/D0
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_CopyLongwordBlockDbfLoop:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,ESQSHARED4_CopyLongwordBlockDbfLoop
    MOVEM.L (A7)+,D0-D1/A0-A4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_ComputeBannerRowBlitGeometry   (Routine at ESQSHARED4_ComputeBannerRowBlitGeometry)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   (none)
; READS:
;   ESQPARS2_BannerRowCount, ESQPARS2_BannerRowWidthBytes, ESQPARS2_BannerCopyBlockSpanBytes
; WRITES:
;   ESQPARS2_BannerRowCopyWordCount, ESQPARS2_BannerRowCopySpanBytes, ESQPARS2_BannerRowCopyStrideBytes, ESQSHARED_BlitAddressOffset, ESQPARS2_BannerCopyBlockWordLimit
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_ComputeBannerRowBlitGeometry:
    MOVE.L  ESQPARS2_BannerRowCount,D0
    MULU    #$58,D0
    MOVE.L  D0,ESQPARS2_BannerRowCopySpanBytes
    CLR.L   D0
    MOVE.W  ESQPARS2_BannerRowWidthBytes,D0
    LSR.W   #3,D0
    MOVE.L  D0,ESQPARS2_BannerRowCopyStrideBytes
    ADDI.L  #$58,D0
    MOVE.L  D0,ESQSHARED_BlitAddressOffset
    MOVE.W  ESQPARS2_BannerCopyBlockSpanBytes,D0
    LSR.W   #5,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,ESQPARS2_BannerRowCopyWordCount
    MOVE.W  #$22,D0
    LSR.W   #1,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,ESQPARS2_BannerCopyBlockWordLimit
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_CopyInterleavedRowWordsFromOffset   (Routine at ESQSHARED4_CopyInterleavedRowWordsFromOffset)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A1/A2/A7/D0
; CALLS:
;   (none)
; READS:
;   ESQSHARED4_InterleaveCopyBaseOffset, ESQSHARED4_InterleaveCopyTailOffsetCurrent
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_CopyInterleavedRowWordsFromOffset:
    MOVEM.L D0/A0-A2,-(A7)
    MOVEA.L A0,A1
    ADDA.L  ESQSHARED4_InterleaveCopyBaseOffset,A1
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
    ADDA.L  ESQSHARED4_InterleaveCopyTailOffsetCurrent,A2
    MOVE.W  6(A2),6(A1)
    MOVE.W  10(A2),10(A1)
    MOVE.W  14(A2),14(A1)
    MOVEM.L (A7)+,D0/A0-A2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_CopyBannerRowsWithByteOffset   (Routine at ESQSHARED4_CopyBannerRowsWithByteOffset)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A1/A2/A7/D0/D1
; CALLS:
;   (none)
; READS:
;   ESQPARS2_BannerCopySourceOffset, ESQPARS2_BannerCopyTailOffset, ESQSHARED_BlitAddressOffset, GCOMMAND_BannerRowByteOffsetCurrent, b0
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_CopyBannerRowsWithByteOffset:
    MOVEM.L D0-D1/A0-A2,-(A7)
    MOVE.L  ESQPARS2_BannerCopySourceOffset,D0
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
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
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
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
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
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
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
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
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
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
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
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
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
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
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
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
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
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
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
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
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
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
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
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
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
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
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
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
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
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    ADDA.L  ESQSHARED_BlitAddressOffset,A2
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
    ADDA.L  ESQSHARED_BlitAddressOffset,A1
    MOVE.L  GCOMMAND_BannerRowByteOffsetCurrent,D1
    ADD.L   ESQPARS2_BannerCopyTailOffset,D1
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
; FUNC: ESQSHARED4_BlitBannerRowsForActiveField   (Routine at ESQSHARED4_BlitBannerRowsForActiveField)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0/D1
; CALLS:
;   ESQSHARED4_CopyInterleavedRowWordsFromOffset, ESQSHARED4_CopyBannerRowsWithByteOffset
; READS:
;   ESQ_CopperListBannerA, ESQ_CopperListBannerB, ESQPARS2_BannerRowCopySpanBytes, ESQPARS2_BannerRowCopyStrideBytes, ESQPARS2_ActiveCopperListSelectFlag, ESQSHARED_BannerRowScratchRasterBase0, ESQSHARED_BannerRowScratchRasterBase1, ESQSHARED_BannerRowScratchRasterBase2
; WRITES:
;   ESQPARS2_BannerCopySourceOffset, ESQPARS2_BannerCopyTailOffset
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_BlitBannerRowsForActiveField:
    MOVEM.L D0/A0-A1,-(A7)
    MOVE.L  ESQPARS2_BannerRowCopySpanBytes,D1
    MOVE.L  ESQPARS2_BannerRowCopyStrideBytes,D0
    TST.L   ESQPARS2_ActiveCopperListSelectFlag
    BNE.S   .lab_0C9F

    ADDI.L  #$58,D0
    LEA     ESQ_CopperListBannerA,A0
    BRA.S   .lab_0CA0

.lab_0C9F:
    LEA     ESQ_CopperListBannerB,A0

.lab_0CA0:
    MOVE.L  D0,ESQPARS2_BannerCopyTailOffset
    ADD.L   D0,D1
    MOVE.L  D1,ESQPARS2_BannerCopySourceOffset
    JSR     ESQSHARED4_CopyInterleavedRowWordsFromOffset(PC)

    LEA     ESQSHARED_BannerRowScratchRasterBase0,A1
    MOVEA.L (A1),A0
    JSR     ESQSHARED4_CopyBannerRowsWithByteOffset(PC)

    LEA     ESQSHARED_BannerRowScratchRasterBase1,A1
    MOVEA.L (A1),A0
    JSR     ESQSHARED4_CopyBannerRowsWithByteOffset(PC)

    LEA     ESQSHARED_BannerRowScratchRasterBase2,A1
    MOVEA.L (A1),A0
    JSR     ESQSHARED4_CopyBannerRowsWithByteOffset(PC)

    MOVEM.L (A7)+,D0/A0-A1
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_LoadCopperColorWordsFromNibbleTable   (Routine at ESQSHARED4_LoadCopperColorWordsFromNibbleTable)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A4/D3/D4
; CALLS:
;   ESQSHARED4_DecodeRgbNibbleTriplet
; READS:
;   ESQ_BannerColorSweepProgramA, ESQ_BannerColorSweepProgramA_AnchorColorWord, ESQ_BannerColorSweepProgramA_TailColorWord, ESQ_BannerColorSweepProgramB, ESQ_BannerColorSweepProgramB_AnchorColorWord, ESQ_BannerColorSweepProgramB_TailColorWord, lab_0CA2, lab_0CA3, lab_0CA4, lab_0CA5
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_LoadCopperColorWordsFromNibbleTable:
    MOVEQ   #7,D4

.lab_0CA2:
    JSR     ESQSHARED4_DecodeRgbNibbleTriplet

    CMPI.W  #4,D3
    BEQ.W   .lab_0CA3

    CMPI.W  #$1c,D3
    BEQ.W   .lab_0CA4

    MOVE.W  D0,0(A2,D3.W)
    MOVE.W  D0,0(A3,D3.W)
    BRA.W   .lab_0CA5

.lab_0CA3:
    LEA     ESQ_BannerColorSweepProgramA,A4
    MOVE.W  D0,(A4)
    LEA     ESQ_BannerColorSweepProgramB,A4
    MOVE.W  D0,(A4)
    LEA     ESQ_BannerColorSweepProgramA_AnchorColorWord,A4
    MOVE.W  D0,(A4)
    LEA     ESQ_BannerColorSweepProgramB_AnchorColorWord,A4
    MOVE.W  D0,(A4)
    BRA.W   .lab_0CA5

.lab_0CA4:
    LEA     ESQ_BannerColorSweepProgramA_TailColorWord,A4
    MOVE.W  D0,(A4)
    LEA     ESQ_BannerColorSweepProgramB_TailColorWord,A4
    MOVE.W  D0,(A4)

.lab_0CA5:
    ADDQ.W  #4,D3
    DBF     D4,.lab_0CA2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_DecodeRgbNibbleTriplet   (Routine at ESQSHARED4_DecodeRgbNibbleTriplet)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D1/D2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_DecodeRgbNibbleTriplet:
    MOVE.B  (A1)+,D2
    MOVE.B  (A1)+,D1
    MOVE.B  (A1)+,D0
    ANDI.W  #15,D2
    ANDI.W  #15,D1
    ANDI.W  #15,D0
    LSL.W   #8,D2
    LSL.W   #4,D1
    ADD.W   D1,D0
    ADD.W   D2,D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_LoadDefaultPaletteToCopper_NoOp   (Routine at ESQSHARED4_LoadDefaultPaletteToCopper_NoOp)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A1/A2/A3/A7/D0/D3
; CALLS:
;   ESQSHARED4_LoadCopperColorWordsFromNibbleTable
; READS:
;   GCOMMAND_PresetFallbackValue0, ESQ_BannerPaletteWordsA, ESQ_BannerPaletteWordsB
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_LoadDefaultPaletteToCopper_NoOp:
    RTS

;!======

    MOVEM.L D0-D4/A0-A4,-(A7)
    LEA     ESQ_BannerPaletteWordsA,A2
    LEA     ESQ_BannerPaletteWordsB,A3
    MOVE.W  #0,D3
    LEA     GCOMMAND_PresetFallbackValue0,A1
    JSR     ESQSHARED4_LoadCopperColorWordsFromNibbleTable(PC)

    MOVEM.L (A7)+,D0-D4/A0-A4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_SetBannerCopperColorAndThreshold   (Routine at ESQSHARED4_SetBannerCopperColorAndThreshold)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A4/D0
; CALLS:
;   ESQ_NoOp
; READS:
;   ESQSHARED4_ApplyBannerColorStep, ESQ_CopperListBannerA, ESQ_BannerSweepWaitRowA, ESQ_BannerSweepWaitStartProgramA, ESQ_BannerSweepWaitEndProgramA, ESQ_CopperListBannerB, ESQ_BannerSweepWaitRowB, ESQ_BannerSweepWaitStartProgramB, ESQ_BannerSweepWaitEndProgramB, ESQPARS2_BannerColorThreshold, ESQPARS2_BannerColorBaseValue, f6, ff, lab_0CA9, lab_0CAA, lab_0CAB
; WRITES:
;   ESQPARS2_BannerSweepEntryGuardCounter, ESQPARS2_BannerColorStepCounter, ESQPARS2_BannerColorThreshold
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_SetBannerCopperColorAndThreshold:
    MOVE.B  D0,(A4)
    LEA     ESQ_CopperListBannerB,A4
    MOVE.B  D0,(A4)
    LEA     ESQ_BannerSweepWaitRowA,A4
    ADDI.B  #$1,D0
    MOVE.B  D0,(A4)
    LEA     ESQ_BannerSweepWaitRowB,A4
    MOVE.B  D0,(A4)
    ADDI.B  #$11,D0
    LEA     ESQ_BannerSweepWaitStartProgramA,A4
    MOVE.B  D0,(A4)
    LEA     ESQ_BannerSweepWaitStartProgramB,A4
    MOVE.B  D0,(A4)
    ADDQ.W  #1,D0
    LEA     ESQ_BannerSweepWaitEndProgramA,A4
    MOVE.B  D0,(A4)
    LEA     ESQ_BannerSweepWaitEndProgramB,A4
    MOVE.B  D0,(A4)
    ANDI.W  #$ff,D0
    MOVE.W  D0,ESQPARS2_BannerColorThreshold
    RTS

;!======

    LEA     ESQPARS2_BannerColorBaseValue,A4
    MOVEQ   #0,D0
    MOVE.W  (A4),D0
    SUBQ.W  #2,D0
    CMP.W   ESQPARS2_BannerColorThreshold,D0
    BPL.W   .lab_0CA9

    RTS

;!======

.lab_0CA9:
    SUBI.W  #1,ESQPARS2_BannerSweepEntryGuardCounter
    BNE.W   .lab_0CAA

    BRA.W   .lab_0CAB

.lab_0CAA:
    BPL.W   .lab_0CAB

    MOVE.W  #0,ESQPARS2_BannerSweepEntryGuardCounter
    JSR     ESQ_NoOp

.lab_0CAB:
    SUBI.W  #1,ESQPARS2_BannerColorStepCounter
    LEA     ESQ_CopperListBannerA,A4
    MOVEQ   #0,D0
    MOVE.B  (A4),D0
    ADDQ.W  #1,D0
    CMPI.B  #$f6,D0
    BNE.W   ESQSHARED4_ApplyBannerColorStep

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_ResetBannerColorToStart   (Routine at ESQSHARED4_ResetBannerColorToStart)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A4/D0
; CALLS:
;   (none)
; READS:
;   ESQ_CopperListBannerA
; WRITES:
;   ESQPARS2_BannerColorStepCounter
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_ResetBannerColorToStart:
    LEA     ESQ_CopperListBannerA,A4
    MOVE.W  #$62,ESQPARS2_BannerColorStepCounter
    MOVE.W  #$19,D0

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_ApplyBannerColorStep   (Routine at ESQSHARED4_ApplyBannerColorStep)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A4/A7/D0/D1/D2
; CALLS:
;   ESQ_NoOp, ESQSHARED4_BindAndClearBannerWorkRaster, ESQSHARED4_SetBannerCopperColorAndThreshold
; READS:
;   ESQ_CopperListBannerA, ESQ_BannerSnapshotPlane0DstPtrLoWord, ESQ_BannerPlane0DstPtrReset_LoWord, ESQ_BannerSweepSrcPlane0Ptr_LoWord, ESQ_BannerSweepSrcPlane0PtrReset_LoWord, ESQPARS2_BannerColorThreshold, ESQPARS2_BannerColorBaseValue, f6, lab_0CAE, lab_0CAF, lab_0CB0
; WRITES:
;   ESQ_BannerColorClampValueA, ESQ_BannerColorClampValueB, ESQPARS2_BannerSweepDelayCounter, ESQPARS2_BannerColorStepCounter, ESQPARS2_BannerColorClampThreshold
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_ApplyBannerColorStep:
    BSR.W   ESQSHARED4_SetBannerCopperColorAndThreshold

    MOVE.W  #$58,D1
    JSR     ESQSHARED4_BindAndClearBannerWorkRaster(PC)

    RTS

;!======

    MOVEM.L D2-D7/A2-A6,-(A7)
    LEA     ESQ_CopperListBannerA,A4
    MOVEQ   #0,D0
    MOVE.B  (A4),D0
    BSR.W   ESQSHARED4_SetBannerCopperColorAndThreshold

    MOVEM.L (A7)+,D2-D7/A2-A6
    RTS

;!======

    LEA     ESQPARS2_BannerColorBaseValue,A4
    MOVEQ   #0,D0
    MOVE.W  (A4),D0
    SUBQ.W  #2,D0
    CMP.W   ESQPARS2_BannerColorThreshold,D0
    BPL.W   .lab_0CAE

    RTS

;!======

.lab_0CAE:
    SUBI.W  #1,ESQPARS2_BannerSweepDelayCounter
    BNE.W   .lab_0CAF

    BRA.W   .lab_0CB0

.lab_0CAF:
    BPL.W   .lab_0CB0

    MOVE.W  #0,ESQPARS2_BannerSweepDelayCounter
    JSR     ESQ_NoOp

.lab_0CB0:
    ADDI.W  #1,ESQPARS2_BannerColorStepCounter
    LEA     ESQ_CopperListBannerA,A4
    MOVEQ   #0,D0
    MOVE.B  (A4),D0
    SUBQ.W  #1,D0
    BRA.S   ESQSHARED4_ApplyBannerColorStep

    LEA     ESQ_CopperListBannerA,A4
    MOVE.W  #$62,ESQPARS2_BannerColorStepCounter
    MOVE.W  #$19,D0
    BRA.W   ESQSHARED4_ApplyBannerColorStep

    RTS

;!======

    MOVEM.L D0-D1/A2,-(A7)
    MOVE.W  ESQ_BannerPlane0DstPtrReset_LoWord,D0
    MOVE.W  ESQ_BannerSnapshotPlane0DstPtrLoWord,D1
    CMP.W   D0,D1
    BEQ.S   .lab_0CB1

    MOVE.W  ESQPARS2_BannerColorBaseValue,D0
    CMPI.W  #$f6,D0
    BLT.S   .lab_0CB2

.lab_0CB1:
    MOVE.W  #$8a,ESQ_BannerColorClampValueA
    MOVE.W  #$8a,ESQPARS2_BannerColorClampThreshold

.lab_0CB2:
    MOVE.W  ESQ_BannerSweepSrcPlane0PtrReset_LoWord,D0
    MOVE.W  ESQ_BannerSweepSrcPlane0Ptr_LoWord,D1
    CMP.W   D0,D1
    BEQ.S   .lab_0CB3

    MOVE.W  ESQPARS2_BannerColorBaseValue,D0
    CMPI.W  #$f6,D0
    BLT.S   ESQSHARED4_ApplyBannerColorStep_Return

.lab_0CB3:
    MOVE.W  #$8a,ESQ_BannerColorClampValueB
    MOVE.W  #$8a,ESQPARS2_BannerColorClampThreshold

;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_ApplyBannerColorStep_Return   (Routine at ESQSHARED4_ApplyBannerColorStep_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_ApplyBannerColorStep_Return:
    MOVEM.L (A7)+,D0-D1/A2
    RTS

;!======

    ; Alignment
    ALIGN_WORD
