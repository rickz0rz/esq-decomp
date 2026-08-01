    XDEF    ESQSHARED4_ApplyBannerColorStep
    XDEF    _ESQSHARED4_ResetBannerColorToStart
    XDEF    ESQSHARED4_SetBannerCopperColorAndThreshold
    XDEF    ESQSHARED4_ApplyBannerColorStep_Return


    MOVEM.L D0-D4/A0-A4,-(A7)
    LEA     _ESQ_BannerPaletteWordsA,A2
    LEA     _ESQ_BannerPaletteWordsB,A3
    MOVE.W  #0,D3
    LEA     _GCOMMAND_PresetFallbackValue0,A1
    JSR     _ESQSHARED4_LoadCopperColorWordsFromNibbleTable(PC)

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
;   _ESQ_NoOp
; READS:
;   ESQSHARED4_ApplyBannerColorStep, _ESQ_CopperListBannerA, _ESQ_BannerSweepWaitRowA, _ESQ_BannerSweepWaitStartProgramA, _ESQ_BannerSweepWaitEndProgramA, _ESQ_CopperListBannerB, _ESQ_BannerSweepWaitRowB, _ESQ_BannerSweepWaitStartProgramB, _ESQ_BannerSweepWaitEndProgramB, ESQPARS2_BannerColorThreshold, _ESQPARS2_BannerColorBaseValue, f6, ff, lab_0CA9, lab_0CAA, lab_0CAB
; WRITES:
;   _ESQPARS2_BannerSweepEntryGuardCounter, _ESQPARS2_BannerColorStepCounter, ESQPARS2_BannerColorThreshold
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_SetBannerCopperColorAndThreshold:
    MOVE.B  D0,(A4)
    LEA     _ESQ_CopperListBannerB,A4
    MOVE.B  D0,(A4)
    LEA     _ESQ_BannerSweepWaitRowA,A4
    ADDI.B  #$1,D0
    MOVE.B  D0,(A4)
    LEA     _ESQ_BannerSweepWaitRowB,A4
    MOVE.B  D0,(A4)
    ADDI.B  #$11,D0
    LEA     _ESQ_BannerSweepWaitStartProgramA,A4
    MOVE.B  D0,(A4)
    LEA     _ESQ_BannerSweepWaitStartProgramB,A4
    MOVE.B  D0,(A4)
    ADDQ.W  #1,D0
    LEA     _ESQ_BannerSweepWaitEndProgramA,A4
    MOVE.B  D0,(A4)
    LEA     _ESQ_BannerSweepWaitEndProgramB,A4
    MOVE.B  D0,(A4)
    ANDI.W  #$ff,D0
    MOVE.W  D0,ESQPARS2_BannerColorThreshold
    RTS

;!======

    LEA     _ESQPARS2_BannerColorBaseValue,A4
    MOVEQ   #0,D0
    MOVE.W  (A4),D0
    SUBQ.W  #2,D0
    CMP.W   ESQPARS2_BannerColorThreshold,D0
    BPL.W   .lab_0CA9

    RTS

;!======

.lab_0CA9:
    SUBI.W  #1,_ESQPARS2_BannerSweepEntryGuardCounter
    BNE.W   .lab_0CAA

    BRA.W   .lab_0CAB

.lab_0CAA:
    BPL.W   .lab_0CAB

    MOVE.W  #0,_ESQPARS2_BannerSweepEntryGuardCounter
    JSR     _ESQ_NoOp

.lab_0CAB:
    SUBI.W  #1,_ESQPARS2_BannerColorStepCounter
    LEA     _ESQ_CopperListBannerA,A4
    MOVEQ   #0,D0
    MOVE.B  (A4),D0
    ADDQ.W  #1,D0
    CMPI.B  #$f6,D0
    BNE.W   ESQSHARED4_ApplyBannerColorStep

;------------------------------------------------------------------------------
; FUNC: _ESQSHARED4_ResetBannerColorToStart   (Routine at _ESQSHARED4_ResetBannerColorToStart)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A4/D0
; CALLS:
;   (none)
; READS:
;   _ESQ_CopperListBannerA
; WRITES:
;   _ESQPARS2_BannerColorStepCounter
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_ESQSHARED4_ResetBannerColorToStart:
    LEA     _ESQ_CopperListBannerA,A4
    MOVE.W  #$62,_ESQPARS2_BannerColorStepCounter
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
;   _ESQ_NoOp, _ESQSHARED4_BindAndClearBannerWorkRaster, ESQSHARED4_SetBannerCopperColorAndThreshold
; READS:
;   _ESQ_CopperListBannerA, _ESQ_BannerSnapshotPlane0DstPtrLoWord, _ESQ_BannerPlane0DstPtrReset_LoWord, _ESQ_BannerSweepSrcPlane0Ptr_LoWord, _ESQ_BannerSweepSrcPlane0PtrReset_LoWord, ESQPARS2_BannerColorThreshold, _ESQPARS2_BannerColorBaseValue, f6, lab_0CAE, lab_0CAF, lab_0CB0
; WRITES:
;   _ESQ_BannerColorClampValueA, _ESQ_BannerColorClampValueB, ESQPARS2_BannerSweepDelayCounter, _ESQPARS2_BannerColorStepCounter, ESQPARS2_BannerColorClampThreshold
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_ApplyBannerColorStep:
    BSR.W   ESQSHARED4_SetBannerCopperColorAndThreshold

    MOVE.W  #$58,D1
    JSR     _ESQSHARED4_BindAndClearBannerWorkRaster(PC)

    RTS

;!======

    MOVEM.L D2-D7/A2-A6,-(A7)
    LEA     _ESQ_CopperListBannerA,A4
    MOVEQ   #0,D0
    MOVE.B  (A4),D0
    BSR.W   ESQSHARED4_SetBannerCopperColorAndThreshold

    MOVEM.L (A7)+,D2-D7/A2-A6
    RTS

;!======

    LEA     _ESQPARS2_BannerColorBaseValue,A4
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
    JSR     _ESQ_NoOp

.lab_0CB0:
    ADDI.W  #1,_ESQPARS2_BannerColorStepCounter
    LEA     _ESQ_CopperListBannerA,A4
    MOVEQ   #0,D0
    MOVE.B  (A4),D0
    SUBQ.W  #1,D0
    BRA.S   ESQSHARED4_ApplyBannerColorStep

    LEA     _ESQ_CopperListBannerA,A4
    MOVE.W  #$62,_ESQPARS2_BannerColorStepCounter
    MOVE.W  #$19,D0
    BRA.W   ESQSHARED4_ApplyBannerColorStep

    RTS

;!======

    MOVEM.L D0-D1/A2,-(A7)
    MOVE.W  _ESQ_BannerPlane0DstPtrReset_LoWord,D0
    MOVE.W  _ESQ_BannerSnapshotPlane0DstPtrLoWord,D1
    CMP.W   D0,D1
    BEQ.S   .lab_0CB1

    MOVE.W  _ESQPARS2_BannerColorBaseValue,D0
    CMPI.W  #$f6,D0
    BLT.S   .lab_0CB2

.lab_0CB1:
    MOVE.W  #$8a,_ESQ_BannerColorClampValueA
    MOVE.W  #$8a,ESQPARS2_BannerColorClampThreshold

.lab_0CB2:
    MOVE.W  _ESQ_BannerSweepSrcPlane0PtrReset_LoWord,D0
    MOVE.W  _ESQ_BannerSweepSrcPlane0Ptr_LoWord,D1
    CMP.W   D0,D1
    BEQ.S   .lab_0CB3

    MOVE.W  _ESQPARS2_BannerColorBaseValue,D0
    CMPI.W  #$f6,D0
    BLT.S   ESQSHARED4_ApplyBannerColorStep_Return

.lab_0CB3:
    MOVE.W  #$8a,_ESQ_BannerColorClampValueB
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
