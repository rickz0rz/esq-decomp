    XDEF    _ESQSHARED4_TickCopperAndBannerTransitions


;------------------------------------------------------------------------------
; FUNC: _ESQSHARED4_TickCopperAndBannerTransitions   (Routine at _ESQSHARED4_TickCopperAndBannerTransitions)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A7/D0/D1
; CALLS:
;   _GCOMMAND_TickHighlightState, _ESQSHARED4_ProgramDisplayWindowAndCopper, _ESQSHARED4_BlitBannerRowsForActiveField, _SCRIPT_UpdateBannerCharTransition
; READS:
;   BLTDDAT, LAB_0C85, LAB_0C86, LAB_0C87, LAB_0C89, LAB_0C8A, LAB_0C8B, _ED2_HighlightTickEnabledFlag, _ESQ_CopperEffectListA, _ESQ_BannerSnapshotPlane0DstPtrHiWord, _ESQ_BannerSnapshotPlane0DstPtrLoWord, _ESQ_BannerSnapshotPlane1DstPtrHiWord, _ESQ_BannerSnapshotPlane1DstPtrLoWord, _ESQ_BannerSnapshotPlane2DstPtrHiWord, _ESQ_BannerSnapshotPlane2DstPtrLoWord, _ESQ_CopperEffectListB, _ESQPARS2_CopperProgramPendingFlag, _ESQPARS2_StateIndex, _ESQPARS2_ReadModeFlags, _GCOMMAND_HighlightHoldoffTickCount, _SCRIPT_BannerTransitionActive, VPOSR, b0
; WRITES:
;   BLTDDAT, COP1LCH, _ESQ_BannerSnapshotPlane0DstPtrHiWord, _ESQ_BannerSnapshotPlane0DstPtrLoWord, _ESQ_BannerSnapshotPlane1DstPtrHiWord, _ESQ_BannerSnapshotPlane1DstPtrLoWord, _ESQ_BannerSnapshotPlane2DstPtrHiWord, _ESQ_BannerSnapshotPlane2DstPtrLoWord, _ESQ_BannerSweepSrcPlane0Ptr_HiWord, _ESQ_BannerSweepSrcPlane0Ptr_LoWord, _ESQ_BannerSweepSrcPlane1Ptr_HiWord, _ESQ_BannerSweepSrcPlane1Ptr_LoWord, _ESQ_BannerSweepSrcPlane2Ptr_HiWord, _ESQ_BannerSweepSrcPlane2Ptr_LoWord, _ESQPARS2_BannerSnapshotPlane0DstPtr, _ESQPARS2_BannerSnapshotPlane0DstPtrLo, _ESQPARS2_BannerSnapshotPlane1DstPtr, _ESQPARS2_BannerSnapshotPlane1DstPtrLo, _ESQPARS2_BannerSnapshotPlane2DstPtr, _ESQPARS2_BannerSnapshotPlane2DstPtrLo, _ESQPARS2_CopperProgramPendingFlag, _ESQPARS2_HighlightTickCountdown, _ESQPARS2_ReadModeFlags, _ESQPARS2_ActiveCopperListSelectFlag, _GCOMMAND_HighlightHoldoffTickCount
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_ESQSHARED4_TickCopperAndBannerTransitions:
    MOVEM.L D0-D3/A0-A6,-(A7)

    LEA     BLTDDAT,A0
    LEA     _ESQ_CopperEffectListA,A2
    MOVEQ   #1,D1
    MOVE.W  (VPOSR-BLTDDAT)(A0),D0
    BPL.S   .lab_0C83            ; BPL = checks to see if bit 15 is set (LOF), if it is jump to LAB_0C83

    LEA     _ESQ_CopperEffectListB,A2
    MOVEQ   #0,D1

.lab_0C83:
    MOVE.L  A2,(COP1LCH-BLTDDAT)(A0)
    MOVE.L  D1,_ESQPARS2_ActiveCopperListSelectFlag
    TST.W   _ESQPARS2_CopperProgramPendingFlag
    BEQ.S   .lab_0C84

    JSR     _ESQSHARED4_ProgramDisplayWindowAndCopper(PC)

    MOVE.W  #0,_ESQPARS2_CopperProgramPendingFlag
    BRA.W   .lab_0C8B

.lab_0C84:
    JSR     _SCRIPT_UpdateBannerCharTransition

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
    SUBQ.W  #1,_ESQPARS2_HighlightTickCountdown
    BPL.S   .lab_0C8B

.lab_0C89:
    MOVE.W  _ESQPARS2_StateIndex,_ESQPARS2_HighlightTickCountdown
    TST.W   _ED2_HighlightTickEnabledFlag
    BEQ.S   .lab_0C8B

    BSR.W   _GCOMMAND_TickHighlightState

    BRA.S   .lab_0C8B

.lab_0C8A:
    SUBQ.B  #1,_GCOMMAND_HighlightHoldoffTickCount
    SUBQ.W  #1,_ESQPARS2_HighlightTickCountdown
    BSR.W   _ESQSHARED4_BlitBannerRowsForActiveField

.lab_0C8B:
    MOVEM.L (A7)+,D0-D3/A0-A6
    RTS

;!======

    MOVE.W  _ESQ_BannerSnapshotPlane0DstPtrLoWord,_ESQPARS2_BannerSnapshotPlane0DstPtrLo
    MOVE.W  _ESQ_BannerSnapshotPlane0DstPtrHiWord,_ESQPARS2_BannerSnapshotPlane0DstPtr
    MOVE.W  _ESQ_BannerSnapshotPlane1DstPtrLoWord,_ESQPARS2_BannerSnapshotPlane1DstPtrLo
    MOVE.W  _ESQ_BannerSnapshotPlane1DstPtrHiWord,_ESQPARS2_BannerSnapshotPlane1DstPtr
    MOVE.W  _ESQ_BannerSnapshotPlane2DstPtrLoWord,_ESQPARS2_BannerSnapshotPlane2DstPtrLo
    MOVE.W  _ESQ_BannerSnapshotPlane2DstPtrHiWord,_ESQPARS2_BannerSnapshotPlane2DstPtr
    RTS

;!======

    MOVE.L  #$b0,D1
    MOVEQ   #1,D0
    ADD.W   D1,_ESQ_BannerSnapshotPlane0DstPtrLoWord
    BCC.S   .lab_0C8C

    ADD.W   D0,_ESQ_BannerSnapshotPlane0DstPtrHiWord

.lab_0C8C:
    ADD.W   D1,_ESQ_BannerSnapshotPlane1DstPtrLoWord
    BCC.S   .lab_0C8D

    ADD.W   D0,_ESQ_BannerSnapshotPlane1DstPtrHiWord

.lab_0C8D:
    ADD.W   D1,_ESQ_BannerSnapshotPlane2DstPtrLoWord
    BCC.S   .lab_0C8E

    ADD.W   D0,_ESQ_BannerSnapshotPlane2DstPtrHiWord

.lab_0C8E:
    ADD.W   D1,_ESQ_BannerSweepSrcPlane0Ptr_LoWord
    BCC.S   .lab_0C8F

    ADD.W   D0,_ESQ_BannerSweepSrcPlane0Ptr_HiWord

.lab_0C8F:
    ADD.W   D1,_ESQ_BannerSweepSrcPlane1Ptr_LoWord
    BCC.S   .lab_0C90

    ADD.W   D0,_ESQ_BannerSweepSrcPlane1Ptr_HiWord

.lab_0C90:
    ADD.W   D1,_ESQ_BannerSweepSrcPlane2Ptr_LoWord
    BCC.S   .lab_0C91

    ADD.W   D0,_ESQ_BannerSweepSrcPlane2Ptr_HiWord

.lab_0C91:
    RTS

;!======