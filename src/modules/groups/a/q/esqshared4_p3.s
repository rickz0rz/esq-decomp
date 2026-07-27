    XDEF    ESQSHARED4_ProgramDisplayWindowAndCopper
    XDEF    ESQSHARED4_TickCopperAndBannerTransitions


;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_ProgramDisplayWindowAndCopper   (Routine at ESQSHARED4_ProgramDisplayWindowAndCopper)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/D0
; CALLS:
;   _ESQSHARED4_LoadDefaultPaletteToCopper_NoOp
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
    BSR.W   _ESQSHARED4_LoadDefaultPaletteToCopper_NoOp

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
;   BLTDDAT, LAB_0C85, LAB_0C86, LAB_0C87, LAB_0C89, LAB_0C8A, LAB_0C8B, ED2_HighlightTickEnabledFlag, ESQ_CopperEffectListA, ESQ_BannerSnapshotPlane0DstPtrHiWord, ESQ_BannerSnapshotPlane0DstPtrLoWord, ESQ_BannerSnapshotPlane1DstPtrHiWord, ESQ_BannerSnapshotPlane1DstPtrLoWord, ESQ_BannerSnapshotPlane2DstPtrHiWord, ESQ_BannerSnapshotPlane2DstPtrLoWord, ESQ_CopperEffectListB, ESQPARS2_CopperProgramPendingFlag, _ESQPARS2_StateIndex, _ESQPARS2_ReadModeFlags, _GCOMMAND_HighlightHoldoffTickCount, _SCRIPT_BannerTransitionActive, VPOSR, b0
; WRITES:
;   BLTDDAT, COP1LCH, ESQ_BannerSnapshotPlane0DstPtrHiWord, ESQ_BannerSnapshotPlane0DstPtrLoWord, ESQ_BannerSnapshotPlane1DstPtrHiWord, ESQ_BannerSnapshotPlane1DstPtrLoWord, ESQ_BannerSnapshotPlane2DstPtrHiWord, ESQ_BannerSnapshotPlane2DstPtrLoWord, ESQ_BannerSweepSrcPlane0Ptr_HiWord, ESQ_BannerSweepSrcPlane0Ptr_LoWord, ESQ_BannerSweepSrcPlane1Ptr_HiWord, ESQ_BannerSweepSrcPlane1Ptr_LoWord, ESQ_BannerSweepSrcPlane2Ptr_HiWord, ESQ_BannerSweepSrcPlane2Ptr_LoWord, _ESQPARS2_BannerSnapshotPlane0DstPtr, ESQPARS2_BannerSnapshotPlane0DstPtrLo, ESQPARS2_BannerSnapshotPlane1DstPtr, ESQPARS2_BannerSnapshotPlane1DstPtrLo, ESQPARS2_BannerSnapshotPlane2DstPtr, ESQPARS2_BannerSnapshotPlane2DstPtrLo, ESQPARS2_CopperProgramPendingFlag, ESQPARS2_HighlightTickCountdown, _ESQPARS2_ReadModeFlags, ESQPARS2_ActiveCopperListSelectFlag, _GCOMMAND_HighlightHoldoffTickCount
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

    TST.W   _SCRIPT_BannerTransitionActive
    BNE.W   .lab_0C8B

    TST.B   _GCOMMAND_HighlightHoldoffTickCount
    BNE.W   .lab_0C8A

    CMPI.W  #$200,_ESQPARS2_ReadModeFlags
    BNE.W   .lab_0C85

    MOVE.W  #$100,_ESQPARS2_ReadModeFlags
    BRA.W   .lab_0C89

.lab_0C85:
    CMPI.W  #$102,_ESQPARS2_ReadModeFlags
    BNE.W   .lab_0C86

    BRA.W   .lab_0C8B

.lab_0C86:
    CMPI.W  #$101,_ESQPARS2_ReadModeFlags
    BNE.W   .lab_0C87

    BRA.W   .lab_0C8B

.lab_0C87:
    CMPI.W  #$100,_ESQPARS2_ReadModeFlags
    BEQ.W   .lab_0C8B

    TST.W   _ESQPARS2_ReadModeFlags
    BMI.S   .lab_0C88

    MOVEQ   #1,D0
    SUB.W   D0,_ESQPARS2_ReadModeFlags
    BRA.W   .lab_0C8B

.lab_0C88:
    SUBQ.W  #1,ESQPARS2_HighlightTickCountdown
    BPL.S   .lab_0C8B

.lab_0C89:
    MOVE.W  _ESQPARS2_StateIndex,ESQPARS2_HighlightTickCountdown
    TST.W   ED2_HighlightTickEnabledFlag
    BEQ.S   .lab_0C8B

    BSR.W   GCOMMAND_TickHighlightState

    BRA.S   .lab_0C8B

.lab_0C8A:
    SUBQ.B  #1,_GCOMMAND_HighlightHoldoffTickCount
    SUBQ.W  #1,ESQPARS2_HighlightTickCountdown
    BSR.W   ESQSHARED4_BlitBannerRowsForActiveField

.lab_0C8B:
    MOVEM.L (A7)+,D0-D3/A0-A6
    RTS

;!======

    MOVE.W  ESQ_BannerSnapshotPlane0DstPtrLoWord,ESQPARS2_BannerSnapshotPlane0DstPtrLo
    MOVE.W  ESQ_BannerSnapshotPlane0DstPtrHiWord,_ESQPARS2_BannerSnapshotPlane0DstPtr
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