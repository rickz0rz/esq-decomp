    XDEF    _COI_GetAnimFieldPointerByMode
    XDEF    _COI_SelectAnimFieldPointer
    XDEF    COI_GetAnimFieldPointerByMode_Return




;------------------------------------------------------------------------------
; FUNC: _COI_SelectAnimFieldPointer   (Select animation field pointer by key/mode)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;------------------------------------------------------------------------------
_COI_SelectAnimFieldPointer:
;------------------------------------------------------------------------------
; FUNC: _COI_GetAnimFieldPointerByMode   (Routine at _COI_GetAnimFieldPointerByMode)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +10: arg_3 (via 14(A5))
;   stack +12: arg_4 (via 16(A5))
;   stack +14: arg_5 (via 18(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A7/D0/D4/D5/D6/D7
; CALLS:
;   (none)
; READS:
;   COI_GetAnimFieldPointerByMode_Return, lab_034D, lab_034D_000E, lab_034D_0018, lab_034D_0026, lab_034D_0046, lab_034D_0064, lab_034D_0080, lab_034D_009C, lab_034D_00B8, lab_0355, lab_0356
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_COI_GetAnimFieldPointerByMode:
    LINK.W  A5,#-20
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.W  18(A5),D6
    SUBA.L  A0,A0
    MOVEQ   #0,D4
    MOVE.L  A0,-12(A5)
    MOVE.L  A3,D0
    BEQ.S   .lab_0348

    TST.L   48(A3)
    BNE.S   .lab_0349

.lab_0348:
    MOVE.L  A0,D0
    BRA.W   COI_GetAnimFieldPointerByMode_Return

.lab_0349:
    MOVE.L  48(A3),-4(A5)
    MOVEQ   #0,D5

.lab_034A:
    MOVEA.L -4(A5),A0
    CMP.W   36(A0),D5
    BGE.S   .lab_034C

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -4(A5),A1
    MOVEA.L 38(A1),A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-8(A5)
    MOVE.W  (A1),D0
    CMP.W   D7,D0
    BNE.S   .lab_034B

    MOVEQ   #1,D4
    MOVE.L  A1,-12(A5)
    BRA.S   .lab_034C

.lab_034B:
    ADDQ.W  #1,D5
    BRA.S   .lab_034A

.lab_034C:
    MOVE.L  D6,D0
    CMPI.W  #8,D0
    BCC.W   .lab_0355

    ADD.W   D0,D0
    MOVE.W  .lab_034D(PC,D0.W),D0
    JMP     .lab_034D+2(PC,D0.W)

; switch/jumptable
.lab_034D:
	DC.W    .lab_034D_0018-.lab_034D-2
    DC.W    .lab_034D_0026-.lab_034D-2
	DC.W    .lab_034D_0046-.lab_034D-2
    DC.W    .lab_034D_0064-.lab_034D-2
	DC.W    .lab_034D_0080-.lab_034D-2
    DC.W    .lab_034D_000E-.lab_034D-2
    DC.W    .lab_034D_009C-.lab_034D-2
	DC.W    .lab_034D_00B8-.lab_034D-2

.lab_034D_000E:
    MOVE.L  -4(A5),-16(A5)
    BRA.W   .lab_0356

.lab_034D_0018:
    MOVEA.L -4(A5),A0
    MOVE.L  4(A0),-16(A5)
    BRA.W   .lab_0356

.lab_034D_0026:
    TST.W   D4
    BEQ.S   .lab_034F

    MOVEA.L -12(A5),A0
    MOVE.L  2(A0),-16(A5)
    BRA.W   .lab_0356

.lab_034F:
    MOVEA.L -4(A5),A0
    MOVE.L  8(A0),-16(A5)
    BRA.W   .lab_0356

.lab_034D_0046:
    TST.W   D4
    BEQ.S   .lab_0350

    MOVEA.L -12(A5),A0
    MOVE.L  6(A0),-16(A5)
    BRA.W   .lab_0356

.lab_0350:
    MOVEA.L -4(A5),A0
    MOVE.L  12(A0),-16(A5)
    BRA.S   .lab_0356

.lab_034D_0064:
    TST.W   D4
    BEQ.S   .lab_0351

    MOVEA.L -12(A5),A0
    MOVE.L  10(A0),-16(A5)
    BRA.S   .lab_0356

.lab_0351:
    MOVEA.L -4(A5),A0
    MOVE.L  16(A0),-16(A5)
    BRA.S   .lab_0356

.lab_034D_0080:
    TST.W   D4
    BEQ.S   .lab_0352

    MOVEA.L -12(A5),A0
    MOVE.L  14(A0),-16(A5)
    BRA.S   .lab_0356

.lab_0352:
    MOVEA.L -4(A5),A0
    MOVE.L  20(A0),-16(A5)
    BRA.S   .lab_0356

.lab_034D_009C:
    TST.W   D4
    BEQ.S   .lab_0353

    MOVEA.L -12(A5),A0
    MOVE.L  18(A0),-16(A5)
    BRA.S   .lab_0356

.lab_0353:
    MOVEA.L -4(A5),A0
    MOVE.L  24(A0),-16(A5)
    BRA.S   .lab_0356

.lab_034D_00B8:
    TST.W   D4
    BEQ.S   .lab_0354

    MOVEA.L -12(A5),A0
    MOVE.L  22(A0),-16(A5)
    BRA.S   .lab_0356

.lab_0354:
    MOVEA.L -4(A5),A0
    MOVE.L  28(A0),-16(A5)
    BRA.S   .lab_0356

.lab_0355:
    CLR.L   -16(A5)

.lab_0356:
    MOVE.L  -16(A5),D0

;------------------------------------------------------------------------------
; FUNC: COI_GetAnimFieldPointerByMode_Return   (Routine at COI_GetAnimFieldPointerByMode_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D4
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
COI_GetAnimFieldPointerByMode_Return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======