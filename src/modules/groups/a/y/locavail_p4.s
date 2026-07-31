    XDEF    LOCAVAIL_UpdateFilterStateMachine
    XDEF    LOCAVAIL_UpdateFilterStateMachine_Return


;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_UpdateFilterStateMachine   (Routine at LOCAVAIL_UpdateFilterStateMachine)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D2/D3/D4/D5
; CALLS:
;   _GROUP_AS_JMPTBL_STR_FindCharPtr, GROUP_AY_JMPTBL_SCRIPT_ReadCiaBBit5Mask, _LOCAVAIL_ResetFilterCursorState, _NEWGRID_JMPTBL_MATH_Mulu32
; READS:
;   LOCAVAIL_UpdateFilterStateMachine_Return, _ESQIFF_GAdsBrushListCount, _ED_DiagGraphModeChar, _ED_DiagVinModeChar, _LOCAVAIL_FilterModeFlag, _LOCAVAIL_FilterStep, _LOCAVAIL_FilterClassId, LOCAVAIL_STR_YYLLZ_FilterStateUpdate, _WDISP_HighlightActive, lab_0F7F, lab_0F7F_0008, lab_0F7F_0040, lab_0F7F_0062, lab_0F83, lab_0F84, lab_0F86, lab_0F86_001E, lab_0F86_0066, lab_0F89, lab_0F8C, lab_0F8C_001E, lab_0F8C_0046
; WRITES:
;   _LOCAVAIL_FilterStep, _LOCAVAIL_FilterClassId, _LOCAVAIL_FilterPrevClassId, _LOCAVAIL_FilterWindowHalfSpan, _LOCAVAIL_FilterCooldownTicks
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
LOCAVAIL_UpdateFilterStateMachine:
    LINK.W  A5,#-4
    MOVEM.L D2-D5/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    SUBA.L  A0,A0
    MOVE.L  A0,-4(A5)
    MOVEQ   #1,D0
    CMP.L   _LOCAVAIL_FilterModeFlag,D0
    BNE.W   LOCAVAIL_UpdateFilterStateMachine_Return

    TST.L   _LOCAVAIL_FilterStep
    BNE.W   .lab_0F84

    MOVEQ   #-1,D1
    CMP.L   _LOCAVAIL_FilterClassId,D1
    BNE.W   .lab_0F84

    MOVE.L  8(A2),D2
    CMP.L   D1,D2
    BEQ.W   LOCAVAIL_UpdateFilterStateMachine_Return

    MOVE.L  12(A2),D3
    CMP.L   D1,D3
    BEQ.W   LOCAVAIL_UpdateFilterStateMachine_Return

    TST.L   D2
    BMI.S   .lab_0F7E

    CMP.L   2(A2),D2
    BGE.S   .lab_0F7E

    MOVE.L  D2,D0
    MOVEQ   #10,D1
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEA.L 20(A2),A1
    ADDA.L  D0,A1
    MOVE.L  A1,-4(A5)

.lab_0F7E:
    TST.L   -4(A5)
    BEQ.W   LOCAVAIL_UpdateFilterStateMachine_Return

    TST.L   D3
    BMI.W   LOCAVAIL_UpdateFilterStateMachine_Return

    MOVEA.L -4(A5),A0
    MOVE.W  4(A0),D0
    EXT.L   D0
    CMP.L   D0,D3
    BGE.W   LOCAVAIL_UpdateFilterStateMachine_Return

    MOVEA.L -4(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D3,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,_LOCAVAIL_FilterClassId
    MOVEQ   #1,D1
    MOVE.L  D1,_LOCAVAIL_FilterStep
    MOVEQ   #-1,D1
    MOVE.L  D1,_LOCAVAIL_FilterPrevClassId
    CMPI.L  #$5,D0
    BCC.W   .lab_0F83

    ADD.W   D0,D0
    MOVE.W  .lab_0F7F(PC,D0.W),D0
    JMP     .lab_0F7F+2(PC,D0.W)

; switch/jumptable
.lab_0F7F:
	DC.W    .lab_0F83-.lab_0F7F-2
    DC.W    .lab_0F7F_0008-.lab_0F7F-2
    DC.W    .lab_0F7F_0040-.lab_0F7F-2
	DC.W    .lab_0F7F_0062-.lab_0F7F-2
    DC.W    .lab_0F83-.lab_0F7F-2

.lab_0F7F_0008:
    MOVEQ   #0,D0
    MOVE.B  _ED_DiagVinModeChar,D0
    MOVE.L  D0,-(A7)
    PEA     LOCAVAIL_STR_YYLLZ_FilterStateUpdate
    JSR     _GROUP_AS_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .lab_0F81

    JSR     GROUP_AY_JMPTBL_SCRIPT_ReadCiaBBit5Mask(PC)

    TST.B   D0
    BEQ.S   .lab_0F81

    MOVEQ   #10,D0
    MOVE.L  D0,20(A3)
    BRA.W   LOCAVAIL_UpdateFilterStateMachine_Return

.lab_0F81:
    MOVE.L  A2,-(A7)
    BSR.W   _LOCAVAIL_ResetFilterCursorState

    ADDQ.W  #4,A7
    BRA.W   LOCAVAIL_UpdateFilterStateMachine_Return

.lab_0F7F_0040:
    MOVE.B  _ED_DiagGraphModeChar,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BEQ.S   .lab_0F82

    TST.L   _ESQIFF_GAdsBrushListCount
    BNE.W   LOCAVAIL_UpdateFilterStateMachine_Return

.lab_0F82:
    MOVE.L  A2,-(A7)
    BSR.W   _LOCAVAIL_ResetFilterCursorState

    ADDQ.W  #4,A7
    BRA.W   LOCAVAIL_UpdateFilterStateMachine_Return

.lab_0F7F_0062:
    TST.W   _WDISP_HighlightActive
    BNE.W   LOCAVAIL_UpdateFilterStateMachine_Return

    MOVE.L  A2,-(A7)
    BSR.W   _LOCAVAIL_ResetFilterCursorState

    ADDQ.W  #4,A7
    BRA.W   LOCAVAIL_UpdateFilterStateMachine_Return

.lab_0F83:
    MOVE.L  A2,-(A7)
    BSR.W   _LOCAVAIL_ResetFilterCursorState

    ADDQ.W  #4,A7
    BRA.W   LOCAVAIL_UpdateFilterStateMachine_Return

.lab_0F84:
    MOVEQ   #1,D0
    CMP.L   _LOCAVAIL_FilterStep,D0
    BNE.W   .lab_0F89

    MOVEQ   #-1,D0
    CMP.L   _LOCAVAIL_FilterClassId,D0
    BEQ.W   .lab_0F89

    MOVE.L  8(A2),D1
    CMP.L   D0,D1
    BEQ.W   .lab_0F89

    MOVE.L  12(A2),D0
    MOVEQ   #-1,D2
    CMP.L   D2,D0
    BEQ.W   .lab_0F89

    TST.L   D1
    BMI.S   .lab_0F85

    CMP.L   2(A2),D1
    BGE.S   .lab_0F85

    MOVEQ   #10,D0
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEA.L 20(A2),A0
    ADDA.L  D0,A0
    MOVE.L  A0,-4(A5)

.lab_0F85:
    TST.L   -4(A5)
    BEQ.W   LOCAVAIL_UpdateFilterStateMachine_Return

    MOVE.L  12(A2),D0
    TST.L   D0
    BMI.W   LOCAVAIL_UpdateFilterStateMachine_Return

    MOVEA.L -4(A5),A0
    MOVE.W  4(A0),D1
    EXT.L   D1
    CMP.L   D1,D0
    BGE.W   LOCAVAIL_UpdateFilterStateMachine_Return

    MOVE.L  20(A3),D0
    CMPI.L  #$10,D0
    BCC.W   LOCAVAIL_UpdateFilterStateMachine_Return

    ADD.W   D0,D0
    MOVE.W  .lab_0F86(PC,D0.W),D0
    JMP     .lab_0F86+2(PC,D0.W)

; switch/jumptable
.lab_0F86:
	DC.W    LOCAVAIL_UpdateFilterStateMachine_Return-.lab_0F86-2
    DC.W    .lab_0F86_001E-.lab_0F86-2
	DC.W    .lab_0F86_001E-.lab_0F86-2
    DC.W    .lab_0F86_001E-.lab_0F86-2
	DC.W    .lab_0F86_0066-.lab_0F86-2
    DC.W    .lab_0F86_001E-.lab_0F86-2
	DC.W    .lab_0F86_001E-.lab_0F86-2
    DC.W    .lab_0F86_001E-.lab_0F86-2
    DC.W    .lab_0F86_001E-.lab_0F86-2
	DC.W    LOCAVAIL_UpdateFilterStateMachine_Return-.lab_0F86-2
    DC.W    LOCAVAIL_UpdateFilterStateMachine_Return-.lab_0F86-2
	DC.W    LOCAVAIL_UpdateFilterStateMachine_Return-.lab_0F86-2
    DC.W    LOCAVAIL_UpdateFilterStateMachine_Return-.lab_0F86-2
	DC.W    LOCAVAIL_UpdateFilterStateMachine_Return-.lab_0F86-2
    DC.W    LOCAVAIL_UpdateFilterStateMachine_Return-.lab_0F86-2
	DC.W    LOCAVAIL_UpdateFilterStateMachine_Return-.lab_0F86-2

.lab_0F86_001E:
    MOVEA.L -4(A5),A0
    MOVE.W  2(A0),D0
    MOVE.L  D0,D1
    SUBQ.W  #5,D1
    MOVE.W  D1,_LOCAVAIL_FilterCooldownTicks
    MOVE.W  2(A0),_LOCAVAIL_FilterWindowHalfSpan
    MOVEQ   #-1,D0
    MOVE.L  D0,8(A2)
    MOVE.L  D0,12(A2)
    MOVEQ   #2,D0
    MOVE.L  D0,_LOCAVAIL_FilterStep
    MOVE.L  _LOCAVAIL_FilterClassId,D0
    MOVEQ   #2,D1
    CMP.L   D1,D0
    BEQ.S   .lab_0F88

    SUBQ.L  #3,D0
    BNE.W   LOCAVAIL_UpdateFilterStateMachine_Return

.lab_0F88:
    MOVEQ   #4,D0
    MOVE.L  D0,20(A3)
    BRA.W   LOCAVAIL_UpdateFilterStateMachine_Return

.lab_0F86_0066:
    CLR.L   20(A3)
    BRA.W   LOCAVAIL_UpdateFilterStateMachine_Return

.lab_0F89:
    MOVE.L  _LOCAVAIL_FilterStep,D0
    MOVEQ   #2,D1
    CMP.L   D1,D0
    BNE.S   .lab_0F8A

    MOVE.L  _LOCAVAIL_FilterClassId,D1
    MOVEQ   #-1,D2
    CMP.L   D2,D1
    BEQ.S   .lab_0F8A

    MOVE.L  8(A2),D3
    CMP.L   D2,D3
    BNE.S   .lab_0F8A

    MOVE.L  12(A2),D4
    CMP.L   D2,D4
    BNE.S   .lab_0F8A

    MOVEQ   #0,D5
    MOVE.L  D5,20(A3)
    BRA.W   LOCAVAIL_UpdateFilterStateMachine_Return

.lab_0F8A:
    MOVEQ   #3,D1
    CMP.L   D1,D0
    BEQ.S   .lab_0F8B

    SUBQ.L  #4,D0
    BNE.S   .lab_0F8F

.lab_0F8B:
    MOVEQ   #-1,D0
    CMP.L   _LOCAVAIL_FilterClassId,D0
    BEQ.S   .lab_0F8F

    CMP.L   8(A2),D0
    BNE.S   .lab_0F8F

    CMP.L   12(A2),D0
    BNE.S   .lab_0F8F

    MOVE.L  20(A3),D0
    CMPI.L  #$10,D0
    BCC.S   LOCAVAIL_UpdateFilterStateMachine_Return

    ADD.W   D0,D0
    MOVE.W  .lab_0F8C(PC,D0.W),D0
    JMP     .lab_0F8C+2(PC,D0.W)

; switch/jumptable
.lab_0F8C:
	DC.W    LOCAVAIL_UpdateFilterStateMachine_Return-.lab_0F8C-2
    DC.W    .lab_0F8C_001E-.lab_0F8C-2
	DC.W    .lab_0F8C_001E-.lab_0F8C-2
    DC.W    .lab_0F8C_001E-.lab_0F8C-2
	DC.W    .lab_0F8C_0046-.lab_0F8C-2
    DC.W    .lab_0F8C_001E-.lab_0F8C-2
	DC.W    .lab_0F8C_001E-.lab_0F8C-2
    DC.W    .lab_0F8C_001E-.lab_0F8C-2
	DC.W    .lab_0F8C_001E-.lab_0F8C-2
    DC.W    LOCAVAIL_UpdateFilterStateMachine_Return-.lab_0F8C-2
	DC.W    LOCAVAIL_UpdateFilterStateMachine_Return-.lab_0F8C-2
    DC.W    LOCAVAIL_UpdateFilterStateMachine_Return-.lab_0F8C-2
	DC.W    LOCAVAIL_UpdateFilterStateMachine_Return-.lab_0F8C-2
    DC.W    LOCAVAIL_UpdateFilterStateMachine_Return-.lab_0F8C-2
	DC.W    LOCAVAIL_UpdateFilterStateMachine_Return-.lab_0F8C-2
    DC.W    LOCAVAIL_UpdateFilterStateMachine_Return-.lab_0F8C-2

.lab_0F8C_001E:
    MOVEQ   #1,D0
    CMP.L   _LOCAVAIL_FilterClassId,D0
    BNE.S   .lab_0F8E

    MOVE.W  #3,24(A3)

.lab_0F8E:
    MOVEQ   #-1,D0
    MOVE.L  D0,_LOCAVAIL_FilterClassId
    CLR.L   _LOCAVAIL_FilterStep
    MOVE.W  #(-1),_LOCAVAIL_FilterWindowHalfSpan
    BRA.S   LOCAVAIL_UpdateFilterStateMachine_Return

.lab_0F8C_0046:
    CLR.L   20(A3)
    BRA.S   LOCAVAIL_UpdateFilterStateMachine_Return

.lab_0F8F:
    MOVE.L  A2,-(A7)
    BSR.W   _LOCAVAIL_ResetFilterCursorState

    ADDQ.W  #4,A7

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_UpdateFilterStateMachine_Return   (Routine at LOCAVAIL_UpdateFilterStateMachine_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D2
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
LOCAVAIL_UpdateFilterStateMachine_Return:
    MOVEM.L (A7)+,D2-D5/A2-A3
    UNLK    A5
    RTS

;!======