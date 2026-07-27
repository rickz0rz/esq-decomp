    XDEF    COI_FormatEntryDisplayText
    XDEF    COI_GetAnimFieldPointerByMode
    XDEF    COI_RenderClockFormatEntryVariant
    XDEF    COI_SelectAnimFieldPointer
    XDEF    COI_FormatEntryDisplayText_Return
    XDEF    COI_GetAnimFieldPointerByMode_Return


;------------------------------------------------------------------------------
; FUNC: COI_SelectAnimFieldPointer   (Select animation field pointer by key/mode)
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
COI_SelectAnimFieldPointer:
;------------------------------------------------------------------------------
; FUNC: COI_GetAnimFieldPointerByMode   (Routine at COI_GetAnimFieldPointerByMode)
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
COI_GetAnimFieldPointerByMode:
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

;------------------------------------------------------------------------------
; FUNC: COI_RenderClockFormatEntryVariant   (Render clock-format entry variant)
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
COI_RenderClockFormatEntryVariant:
;------------------------------------------------------------------------------
; FUNC: COI_FormatEntryDisplayText   (Routine at COI_FormatEntryDisplayText)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
;   stack +20: arg_5 (via 24(A5))
;   stack +24: arg_6 (via 28(A5))
;   stack +28: arg_7 (via 32(A5))
;   stack +32: arg_8 (via 36(A5))
;   stack +40: arg_9 (via 44(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A3/A5/A7/D0/D1/D2/D5/D6/D7
; CALLS:
;   CLEANUP_TestEntryFlagYAndBit1, CLEANUP_UpdateEntryFlagBytes, _GROUP_AE_JMPTBL_WDISP_SPrintf, _GROUP_AI_JMPTBL_STRING_AppendAtNull, COI_GetAnimFieldPointerByMode, COI_TestEntryWithinTimeWindow
; READS:
;   COI_FormatEntryDisplayText_Return, COI_FMT_WRAP_CHAR_STRING_CHAR, COI_STR_SINGLE_SPACE, _CONFIG_TimeWindowMinutes, _GCOMMAND_PpvSelectionWindowMinutes, _GCOMMAND_PpvSelectionToleranceMinutes
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
COI_FormatEntryDisplayText:
    LINK.W  A5,#-44
    MOVEM.L D2/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7
    MOVE.L  24(A5),D6
    MOVEQ   #-1,D0
    CMP.L   D0,D6
    BNE.S   .lab_0359

    MOVE.L  _GCOMMAND_PpvSelectionWindowMinutes,D1
    BRA.S   .lab_035A

.lab_0359:
    MOVE.L  #1440,D1

.lab_035A:
    MOVE.L  D1,-28(A5)
    CMP.L   D0,D6
    BNE.S   .lab_035B

    MOVE.L  _GCOMMAND_PpvSelectionToleranceMinutes,D0
    BRA.S   .lab_035C

.lab_035B:
    MOVE.L  _CONFIG_TimeWindowMinutes,D0

.lab_035C:
    MOVE.L  D7,D2
    EXT.L   D2
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-32(A5)
    BSR.W   COI_TestEntryWithinTimeWindow

    LEA     20(A7),A7
    TST.L   D0
    BEQ.W   COI_FormatEntryDisplayText_Return

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   COI_GetAnimFieldPointerByMode

    LEA     12(A7),A7
    MOVE.L  D0,-20(A5)
    MOVEQ   #-1,D0
    CMP.L   D0,D6
    BNE.S   .lab_035D

    SUBA.L  A0,A0
    MOVE.L  A0,-16(A5)
    MOVE.L  A0,-12(A5)
    MOVE.L  A0,-8(A5)
    MOVEQ   #3,D6
    BRA.S   .lab_035E

.lab_035D:
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     3.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   COI_GetAnimFieldPointerByMode

    MOVE.L  D0,-16(A5)
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     4.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   COI_GetAnimFieldPointerByMode

    MOVE.L  D0,-12(A5)
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   COI_GetAnimFieldPointerByMode

    LEA     36(A7),A7
    MOVE.L  D0,-8(A5)

.lab_035E:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   CLEANUP_TestEntryFlagYAndBit1

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .lab_035F

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     6.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   COI_GetAnimFieldPointerByMode

    PEA     20.W
    MOVE.L  D0,-(A7)
    PEA     19.W
    PEA     COI_FMT_WRAP_CHAR_STRING_CHAR
    PEA     -44(A5)
    MOVE.L  D0,-36(A5)
    JSR     _GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     -44(A5),A0
    MOVE.L  A0,-4(A5)
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  A3,-(A7)
    BSR.W   CLEANUP_UpdateEntryFlagBytes

    LEA     36(A7),A7
    BRA.S   .lab_0360

.lab_035F:
    CLR.L   -4(A5)

.lab_0360:
    MOVEQ   #0,D5

.lab_0361:
    MOVEQ   #5,D0
    CMP.L   D0,D5
    BGE.S   COI_FormatEntryDisplayText_Return

    MOVE.L  D5,D0
    ASL.L   #2,D0
    TST.L   -20(A5,D0.L)
    BEQ.S   .lab_0362

    MOVEA.L -20(A5,D0.L),A0
    TST.B   (A0)
    BEQ.S   .lab_0362

    PEA     COI_STR_SINGLE_SPACE
    MOVE.L  20(A5),-(A7)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    MOVE.L  D5,D0
    ASL.L   #2,D0
    MOVE.L  -20(A5,D0.L),(A7)
    MOVE.L  20(A5),-(A7)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     12(A7),A7

.lab_0362:
    ADDQ.L  #1,D5
    BRA.S   .lab_0361

;------------------------------------------------------------------------------
; FUNC: COI_FormatEntryDisplayText_Return   (Routine at COI_FormatEntryDisplayText_Return)
; ARGS:
;   stack +16: arg_1 (via 20(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D2
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
COI_FormatEntryDisplayText_Return:
    MOVE.L  20(A5),D0
    MOVEM.L (A7)+,D2/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======