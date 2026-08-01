    XDEF    _COI_ProcessEntrySelectionState
    XDEF    _COI_TestEntryWithinTimeWindow
    XDEF    COI_TestEntryWithinTimeWindow_Return




;------------------------------------------------------------------------------
; FUNC: _COI_ProcessEntrySelectionState   (Process entry-selection state)
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
_COI_ProcessEntrySelectionState:
;------------------------------------------------------------------------------
; FUNC: _COI_TestEntryWithinTimeWindow   (Routine at _COI_TestEntryWithinTimeWindow)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +14: arg_4 (via 18(A5))
;   stack +16: arg_5 (via 20(A5))
;   stack +20: arg_6 (via 24(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D5/D6/D7
; CALLS:
;   _GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset, _GROUP_AG_JMPTBL_MATH_Mulu32, _COI_ComputeEntryTimeDeltaMinutes
; READS:
;   _CLOCK_HalfHourSlotIndex, lab_0378
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_COI_TestEntryWithinTimeWindow:
    LINK.W  A5,#-24
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  18(A5),D7
    MOVE.L  20(A5),D6
    MOVE.L  24(A5),D5
    MOVEQ   #1,D0
    MOVE.L  D0,-4(A5)
    MOVEQ   #0,D0
    SUBA.L  A0,A0
    MOVE.L  D0,-12(A5)
    MOVE.L  D0,-8(A5)
    MOVE.L  A0,-20(A5)
    MOVE.L  A0,-16(A5)
    MOVE.L  A3,D0
    BEQ.W   .lab_0378

    MOVE.L  A2,D0
    BEQ.W   .lab_0378

    TST.W   D7
    BLE.W   .lab_0378

    TST.W   D7
    BLE.S   .lab_036D

    MOVEQ   #49,D0
    CMP.W   D0,D7
    BGE.S   .lab_036D

    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    EXT.L   D0
    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset(PC)

    LEA     12(A7),A7
    MOVE.L  D0,-8(A5)
    BRA.S   .lab_036E

.lab_036D:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.W  _CLOCK_HalfHourSlotIndex,D1
    SUB.L   D1,D0
    MOVEQ   #30,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,-8(A5)

.lab_036E:
    BTST    #4,27(A3)
    BEQ.S   .lab_0375

    MOVEA.L 48(A3),A0
    MOVE.L  A0,-16(A5)
    BEQ.S   .lab_0374

    CLR.L   -24(A5)

.lab_036F:
    MOVEA.L -16(A5),A0
    MOVE.W  36(A0),D0
    EXT.L   D0
    MOVE.L  -24(A5),D1
    CMP.L   D0,D1
    BGE.S   .lab_0371

    ASL.L   #2,D1
    MOVEA.L -16(A5),A1
    MOVEA.L 38(A1),A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-20(A5)
    MOVEA.L -20(A5),A0
    MOVE.W  (A0),D0
    CMP.W   D7,D0
    BNE.S   .lab_0370

    BRA.S   .lab_0371

.lab_0370:
    CLR.L   -20(A5)
    ADDQ.L  #1,-24(A5)
    BRA.S   .lab_036F

.lab_0371:
    TST.L   -20(A5)
    BEQ.S   .lab_0372

    MOVEA.L -20(A5),A0
    MOVE.L  26(A0),-12(A5)
    BRA.S   .lab_0373

.lab_0372:
    MOVEA.L -16(A5),A0
    MOVE.L  32(A0),D0
    MOVE.L  D0,-12(A5)

.lab_0373:
    MOVEQ   #-1,D0
    CMP.L   -12(A5),D0
    BNE.S   .lab_0376

    MOVE.L  D5,-12(A5)
    BRA.S   .lab_0376

.lab_0374:
    MOVE.L  D5,-12(A5)
    BRA.S   .lab_0376

.lab_0375:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    BSR.W   _COI_ComputeEntryTimeDeltaMinutes

    ADDQ.W  #8,A7
    MOVE.L  -8(A5),D1
    SUB.L   D1,D0
    MOVE.L  D0,-12(A5)

.lab_0376:
    MOVE.L  -12(A5),D0
    TST.L   D0
    BMI.S   .lab_0377

    MOVE.L  -8(A5),D1
    CMP.L   D6,D1
    BGT.S   .lab_0377

    NEG.L   D0
    CMP.L   D0,D1
    BGE.S   COI_TestEntryWithinTimeWindow_Return

.lab_0377:
    MOVEQ   #0,D0
    MOVE.L  D0,-4(A5)
    BRA.S   COI_TestEntryWithinTimeWindow_Return

.lab_0378:
    MOVEQ   #0,D0
    MOVE.L  D0,-4(A5)

;------------------------------------------------------------------------------
; FUNC: COI_TestEntryWithinTimeWindow_Return   (Routine at COI_TestEntryWithinTimeWindow_Return)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D5/D7
; CALLS:
;   _GROUP_AE_JMPTBL_WDISP_SPrintf, _COI_GetAnimFieldPointerByMode
; READS:
;   _COI_FMT_WIDE_STR_WITH_TRAILING_SPACE
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
COI_TestEntryWithinTimeWindow_Return:
    MOVE.L  -4(A5),D0
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======