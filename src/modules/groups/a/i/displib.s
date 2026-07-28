    XDEF    DISPLIB_ApplyInlineAlignmentPadding
    XDEF    DISPLIB_FindPreviousValidEntryIndex
    XDEF    DISPLIB_ApplyInlineAlignmentPadding_Return
    XDEF    DISPLIB_FindPreviousValidEntryIndex_Return




;------------------------------------------------------------------------------
; FUNC: DISPLIB_FindPreviousValidEntryIndex   (Routine at DISPLIB_FindPreviousValidEntryIndex)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A2/A3/A7/D0/D5/D6/D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   DISPLIB_PreviousSearchWrappedFlag
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISPLIB_FindPreviousValidEntryIndex:
    MOVEM.L D5-D7/A2-A3,-(A7)

    MOVEA.L 24(A7),A3
    MOVEA.L 28(A7),A2
    MOVE.L  32(A7),D7

    BTST    #5,27(A3)
    BEQ.S   .lab_054D

    MOVEQ   #48,D5
    BRA.S   .lab_054E

.lab_054D:
    MOVEQ   #7,D5

.lab_054E:
    MOVE.L  D7,D6
    SUB.L   D5,D6
    MOVEQ   #1,D0
    CMP.L   D0,D6
    BGE.S   .branch

    MOVE.L  D0,D6

.branch:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    TST.L   56(A2,D0.L)
    BNE.S   DISPLIB_FindPreviousValidEntryIndex_Return

    SUBQ.L  #1,D7
    CMP.L   D6,D7
    BGE.S   .branch_1

    MOVEQ   #0,D7
    CLR.W   DISPLIB_PreviousSearchWrappedFlag
    BRA.S   DISPLIB_FindPreviousValidEntryIndex_Return

.branch_1:
    BTST    #5,27(A3)
    BNE.S   .branch

    MOVE.W  #1,DISPLIB_PreviousSearchWrappedFlag
    BRA.S   .branch

;------------------------------------------------------------------------------
; FUNC: DISPLIB_FindPreviousValidEntryIndex_Return   (Routine at DISPLIB_FindPreviousValidEntryIndex_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D5
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
DISPLIB_FindPreviousValidEntryIndex_Return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D5-D7/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISPLIB_ApplyInlineAlignmentPadding   (Routine at DISPLIB_ApplyInlineAlignmentPadding)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +11: arg_2 (via 15(A5))
;   stack +20: arg_3 (via 24(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A6/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   _GROUP_AG_JMPTBL_MATH_DivS32, _GROUP_AG_JMPTBL_MEMORY_AllocateMemory, _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, _GROUP_AI_JMPTBL_STRING_AppendAtNull, _LVOTextLength
; READS:
;   Global_REF_GRAPHICS_LIBRARY, _Global_REF_RASTPORT_1, Global_STR_DISPLIB_C_1, Global_STR_DISPLIB_C_2, DISPLIB_ApplyInlineAlignmentPadding_Return, DISPLIB_STR_InlineAlignPadCharCenter, DISPLIB_STR_InlineAlignPadCharRight, MEMF_PUBLIC
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISPLIB_ApplyInlineAlignmentPadding:
    LINK.W  A5,#-28
    MOVEM.L D4-D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.B  15(A5),D7
    MOVEA.L A3,A0

.lab_0553:
    TST.B   (A0)+
    BNE.S   .lab_0553

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D5
    MOVEA.L A3,A0
    MOVE.L  D5,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  #624,D1
    SUB.L   D0,D1
    MOVE.L  D1,D6
    TST.L   D6
    BLE.W   DISPLIB_ApplyInlineAlignmentPadding_Return

    MOVEQ   #24,D0
    CMP.B   D0,D7
    BNE.S   .lab_0555

    MOVEA.L _Global_REF_RASTPORT_1,A1
    LEA     DISPLIB_STR_InlineAlignPadCharCenter,A0
    MOVEQ   #1,D0
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,20(A7)
    MOVE.L  D6,D0
    MOVE.L  20(A7),D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    TST.L   D0
    BPL.S   .lab_0554

    ADDQ.L  #1,D0

.lab_0554:
    ASR.L   #1,D0
    MOVE.L  D0,D4
    BRA.S   .lab_0557

.lab_0555:
    MOVEQ   #26,D0
    CMP.B   D0,D7
    BNE.S   .branch

    MOVEA.L _Global_REF_RASTPORT_1,A1
    LEA     DISPLIB_STR_InlineAlignPadCharRight,A0
    MOVEQ   #1,D0
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,20(A7)
    MOVE.L  D6,D0
    MOVE.L  20(A7),D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D0,D4
    BRA.S   .lab_0557

.branch:
    MOVEQ   #0,D4

.lab_0557:
    TST.L   D4
    BEQ.S   DISPLIB_ApplyInlineAlignmentPadding_Return

    MOVE.L  D5,D0
    ADDQ.L  #1,D0
    PEA     (MEMF_PUBLIC).W
    MOVE.L  D0,-(A7)
    PEA     194.W
    PEA     Global_STR_DISPLIB_C_1
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   DISPLIB_ApplyInlineAlignmentPadding_Return

    MOVEA.L A3,A0
    MOVEA.L D0,A1

.branch_1:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .branch_1

    MOVE.L  A3,-8(A5)
    CLR.L   -24(A5)

.branch_2:
    MOVE.L  -24(A5),D0
    CMP.L   D4,D0
    BGE.S   .branch_3

    MOVEA.L -8(A5),A0
    MOVE.B  #$20,(A0)+
    MOVE.L  A0,-8(A5)
    ADDQ.L  #1,-24(A5)
    BRA.S   .branch_2

.branch_3:
    MOVEA.L -8(A5),A0
    CLR.B   (A0)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    MOVE.L  D5,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     204.W
    PEA     Global_STR_DISPLIB_C_2
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     20(A7),A7

;------------------------------------------------------------------------------
; FUNC: DISPLIB_ApplyInlineAlignmentPadding_Return   (Routine at DISPLIB_ApplyInlineAlignmentPadding_Return)
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
DISPLIB_ApplyInlineAlignmentPadding_Return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======