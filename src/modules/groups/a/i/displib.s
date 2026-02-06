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
;   DATA_WDISP_BSS_WORD_2255
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
    CLR.W   DATA_WDISP_BSS_WORD_2255
    BRA.S   DISPLIB_FindPreviousValidEntryIndex_Return

.branch_1:
    BTST    #5,27(A3)
    BNE.S   .branch

    MOVE.W  #1,DATA_WDISP_BSS_WORD_2255
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
;   GROUP_AG_JMPTBL_MATH_DivS32, GROUP_AG_JMPTBL_MEMORY_AllocateMemory, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, GROUP_AI_JMPTBL_STRING_AppendAtNull, _LVOTextLength
; READS:
;   GLOB_REF_GRAPHICS_LIBRARY, GLOB_REF_RASTPORT_1, GLOB_STR_DISPLIB_C_1, GLOB_STR_DISPLIB_C_2, DISPLIB_ApplyInlineAlignmentPadding_Return, DATA_DISKIO2_SPACE_VALUE_1CE4, DATA_DISKIO2_SPACE_VALUE_1CE5, MEMF_PUBLIC
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
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  #624,D1
    SUB.L   D0,D1
    MOVE.L  D1,D6
    TST.L   D6
    BLE.W   DISPLIB_ApplyInlineAlignmentPadding_Return

    MOVEQ   #24,D0
    CMP.B   D0,D7
    BNE.S   .lab_0555

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     DATA_DISKIO2_SPACE_VALUE_1CE4,A0
    MOVEQ   #1,D0
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,20(A7)
    MOVE.L  D6,D0
    MOVE.L  20(A7),D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

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

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     DATA_DISKIO2_SPACE_VALUE_1CE5,A0
    MOVEQ   #1,D0
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,20(A7)
    MOVE.L  D6,D0
    MOVE.L  20(A7),D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

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
    PEA     GLOB_STR_DISPLIB_C_1
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

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
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    MOVE.L  D5,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     204.W
    PEA     GLOB_STR_DISPLIB_C_2
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

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

;------------------------------------------------------------------------------
; FUNC: DISPLIB_DisplayTextAtPosition   (Routine at DISPLIB_DisplayTextAtPosition)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A6/A7/D0/D1/D6/D7
; CALLS:
;   _LVOMove, _LVOText
; READS:
;   GLOB_REF_GRAPHICS_LIBRARY
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISPLIB_DisplayTextAtPosition:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A2-A3,-(A7)

    ; Copy additional parameters from the stack
    MOVEA.L 28(A7),A3   ; RastPort
    MOVE.L  32(A7),D7   ; X
    MOVE.L  36(A7),D6   ; Y
    MOVEA.L 40(A7),A2   ; String

    ; Check to see if A2 (our target string) is an empty address.
    ; If it is, jump to the end.
    MOVE.L  A2,D0
    BEQ.S   .return

    MOVEA.L A3,A1   ; RastPort
    MOVE.L  D7,D0   ; X (short)
    MOVE.L  D6,D1   ; Y (short)
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L A2,A0

; Count the number of characters in the string by testing each
; character, and then subtracting the address of the null character
; from the starting address of the string (minus 1)
.currentCharacterIsNotNull:
    TST.B   (A0)+
    BNE.S   .currentCharacterIsNotNull

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,16(A7)

    MOVEA.L A3,A1       ; RastPort
    MOVEA.L A2,A0       ; String
    MOVE.L  16(A7),D0   ; Number of characters in the string
    JSR     _LVOText(A6)

.return:
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISPLIB_NormalizeValueByStep   (Routine at DISPLIB_NormalizeValueByStep)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D5/D6/D7
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
DISPLIB_NormalizeValueByStep:
    MOVEM.L D5-D7,-(A7)
    MOVE.W  18(A7),D7
    MOVE.W  22(A7),D6
    MOVE.W  26(A7),D5

.lab_0560:
    CMP.W   D6,D7
    BGE.S   .lab_0561

    ADD.W   D5,D7
    BRA.S   .lab_0560

.lab_0561:
    CMP.W   D5,D7
    BLE.S   .return

    SUB.W   D5,D7
    BRA.S   .lab_0561

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D5-D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISPLIB_ResetLineTables   (Routine at DISPLIB_ResetLineTables)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0/D1/D7
; CALLS:
;   (none)
; READS:
;   DISPTEXT_LinePtrTable, DISPTEXT_LineLengthTable, DISPTEXT_LinePenTable
; WRITES:
;   DISPTEXT_TargetLineIndex, DISPTEXT_CurrentLineIndex, DISPTEXT_LineWidthPx, DATA_WDISP_BSS_LONG_21DA, DISPTEXT_LineTableLockFlag, DATA_WDISP_BSS_WORD_21DC
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISPLIB_ResetLineTables:
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D0
    MOVE.W  D0,DISPTEXT_TargetLineIndex
    MOVE.W  D0,DISPTEXT_CurrentLineIndex
    MOVEQ   #0,D1
    MOVE.L  D1,DISPTEXT_LineWidthPx
    MOVE.L  D1,DATA_WDISP_BSS_LONG_21DA
    MOVE.L  D1,DISPTEXT_LineTableLockFlag
    MOVE.W  D0,DATA_WDISP_BSS_WORD_21DC
    MOVE.L  D1,D7

.lab_0564:
    MOVEQ   #20,D0
    CMP.L   D0,D7
    BGE.S   .lab_0565

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     DISPTEXT_LinePtrTable,A0
    ADDA.L  D0,A0
    CLR.L   (A0)
    MOVE.L  D7,D1
    ADD.L   D1,D1
    LEA     DISPTEXT_LineLengthTable,A0
    ADDA.L  D1,A0
    CLR.W   (A0)
    LEA     DISPTEXT_LinePenTable,A0
    ADDA.L  D0,A0
    MOVEQ   #1,D0
    MOVE.L  D0,(A0)
    ADDQ.L  #1,D7
    BRA.S   .lab_0564

.lab_0565:
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISPLIB_ResetTextBufferAndLineTables   (Routine at DISPLIB_ResetTextBufferAndLineTables)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7
; CALLS:
;   GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   DISPTEXT_TextBufferPtr
; WRITES:
;   DISPTEXT_TextBufferPtr
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISPLIB_ResetTextBufferAndLineTables:
    MOVE.L  DISPTEXT_TextBufferPtr,-(A7)
    CLR.L   -(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,DISPTEXT_TextBufferPtr
    BSR.S   DISPLIB_ResetLineTables

    ADDQ.W  #8,A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISPLIB_CommitCurrentLinePenAndAdvance   (Routine at DISPLIB_CommitCurrentLinePenAndAdvance)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0/D1/D7
; CALLS:
;   (none)
; READS:
;   DISPTEXT_TargetLineIndex, DISPTEXT_CurrentLineIndex, DISPTEXT_LineLengthTable, DISPTEXT_LinePenTable
; WRITES:
;   DISPTEXT_CurrentLineIndex
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISPLIB_CommitCurrentLinePenAndAdvance:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    MOVEQ   #0,D0
    MOVE.W  DISPTEXT_CurrentLineIndex,D0
    ADD.L   D0,D0
    LEA     DISPTEXT_LineLengthTable,A0
    ADDA.L  D0,A0
    TST.W   (A0)
    BEQ.S   .lab_0568

    MOVE.W  DISPTEXT_CurrentLineIndex,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,DISPTEXT_CurrentLineIndex

.lab_0568:
    MOVE.W  DISPTEXT_CurrentLineIndex,D0
    MOVE.W  DISPTEXT_TargetLineIndex,D1
    CMP.W   D1,D0
    BCC.S   .lab_0569

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ASL.L   #2,D1
    LEA     DISPTEXT_LinePenTable,A0
    ADDA.L  D1,A0
    MOVE.L  D7,(A0)

.lab_0569:
    MOVE.L  (A7)+,D7
    RTS
