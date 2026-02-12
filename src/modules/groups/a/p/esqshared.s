
;------------------------------------------------------------------------------
; FUNC: ESQSHARED_ParseCompactEntryRecord   (Routine at ESQSHARED_ParseCompactEntryRecord)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +11: arg_2 (via 15(A5))
;   stack +36: arg_3 (via 40(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   ESQSHARED_UpdateMatchingEntriesByTitle
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED_ParseCompactEntryRecord:
    LINK.W  A5,#-16
    MOVEM.L D2/D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.B  (A3)+,D6
    MOVE.B  (A3)+,D5
    MOVEQ   #0,D7

.branch:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-15(A5,D7.W)
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BEQ.S   .lab_0C09

    MOVEQ   #8,D0
    CMP.W   D0,D7
    BGE.S   .lab_0C09

    ADDQ.W  #1,D7
    BRA.S   .branch

.lab_0C09:
    CLR.B   -15(A5,D7.W)
    MOVE.B  (A3)+,D4
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    MOVEQ   #0,D2
    MOVE.B  D4,D2
    MOVE.L  A3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -15(A5)
    BSR.W   ESQSHARED_UpdateMatchingEntriesByTitle

    MOVEM.L -40(A5),D2/D4-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED_MatchSelectionCodeWithOptionalSuffix   (Routine at ESQSHARED_MatchSelectionCodeWithOptionalSuffix)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +5: arg_2 (via 9(A5))
;   stack +6: arg_3 (via 10(A5))
;   stack +22: arg_4 (via 26(A5))
;   stack +26: arg_5 (via 30(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   ESQSHARED_JMPTBL_ESQ_WildcardMatch
; READS:
;   ESQ_SelectCodeBuffer, DATA_ESQ_STR_A_1DEB, DATA_WDISP_BSS_LONG_2298
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED_MatchSelectionCodeWithOptionalSuffix:
    LINK.W  A5,#-32
    MOVEM.L D4-D7/A3,-(A7)

    MOVEA.L 8(A5),A3

    CLR.B   -10(A5)
    MOVE.B  DATA_ESQ_STR_A_1DEB,D0
    MOVEQ   #0,D6
    MOVE.B  D0,-8(A5)
    MOVE.B  D0,-9(A5)

.branch:
    MOVE.B  (A3)+,D4
    TST.B   D4
    BEQ.S   .lab_0C13

    MOVEQ   #0,D0
    MOVE.B  D4,D0
    SUBI.W  #$2e,D0
    BEQ.S   .lab_0C0F

    SUBI.W  #12,D0
    BNE.S   .lab_0C10

    MOVE.B  -8(A5),D0
    MOVEQ   #63,D1
    CMP.B   D1,D0
    BEQ.S   .lab_0C0C

    MOVEQ   #42,D1
    CMP.B   D1,D0
    BEQ.S   .lab_0C0C

    TST.W   D6
    BNE.S   .lab_0C0D

.lab_0C0C:
    MOVE.B  DATA_ESQ_STR_A_1DEB,-9(A5)
    BRA.S   .branch_1

.lab_0C0D:
    MOVE.B  D0,-9(A5)

.branch_1:
    MOVEQ   #0,D6
    BRA.S   .branch

.lab_0C0F:
    CLR.B   -26(A5,D6.W)
    MOVE.B  #$1,-10(A5)
    MOVEQ   #0,D6
    BRA.S   .branch

.lab_0C10:
    MOVE.B  D4,-8(A5)
    TST.B   -10(A5)
    BEQ.S   .branch_2

    MOVE.B  D4,-30(A5,D6.W)
    BRA.S   .branch_3

.branch_2:
    MOVE.B  D4,-26(A5,D6.W)

.branch_3:
    ADDQ.W  #1,D6
    BRA.S   .branch

.lab_0C13:
    TST.B   -10(A5)
    BEQ.S   .branch_4

    MOVEQ   #0,D0
    MOVE.B  D0,-30(A5,D6.W)
    BRA.S   .branch_5

.branch_4:
    CLR.B   -26(A5,D6.W)

.branch_5:
    LEA     -26(A5),A0
    MOVEA.L A0,A1

.branch_6:
    TST.B   (A1)+
    BNE.S   .branch_6

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    BNE.S   .branch_7

    MOVEQ   #-1,D7
    BRA.S   .branch_8

.branch_7:
    MOVE.L  A0,-(A7)
    PEA     ESQ_SelectCodeBuffer
    JSR     ESQSHARED_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    MOVE.B  D0,D7
    EXT.W   D7

.branch_8:
    MOVEQ   #0,D5
    MOVEQ   #1,D0
    CMP.B   -10(A5),D0
    BNE.S   .branch_9

    PEA     -30(A5)
    PEA     DATA_WDISP_BSS_LONG_2298
    JSR     ESQSHARED_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    MOVE.B  D0,D5
    EXT.W   D5

.branch_9:
    TST.W   D7
    BNE.S   .branch_10

    TST.W   D5
    BNE.S   .branch_10

    MOVE.B  DATA_ESQ_STR_A_1DEB,D0
    MOVE.B  -9(A5),D1
    CMP.B   D0,D1
    BNE.S   .branch_10

    MOVEQ   #1,D0
    BRA.S   ESQSHARED_MatchSelectionCodeWithOptionalSuffix_Return

.branch_10:
    MOVEQ   #0,D0

;------------------------------------------------------------------------------
; FUNC: ESQSHARED_MatchSelectionCodeWithOptionalSuffix_Return   (Routine at ESQSHARED_MatchSelectionCodeWithOptionalSuffix_Return)
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
ESQSHARED_MatchSelectionCodeWithOptionalSuffix_Return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED_InitEntryDefaults   (Routine at ESQSHARED_InitEntryDefaults)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A7/D0
; CALLS:
;   (none)
; READS:
;   Global_STR_00
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED_InitEntryDefaults:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.B  #$2,40(A3)
    MOVEQ   #-1,D0
    MOVE.B  D0,41(A3)
    MOVE.B  D0,42(A3)
    LEA     43(A3),A0
    LEA     Global_STR_00,A1

.lab_0C1D:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .lab_0C1D

    MOVE.W  #3,46(A3)
    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED_CreateGroupEntryAndTitle   (Routine at ESQSHARED_CreateGroupEntryAndTitle)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +7: arg_2 (via 11(A5))
;   stack +8: arg_3 (via 12(A5))
;   stack +11: arg_4 (via 15(A5))
;   stack +12: arg_5 (via 16(A5))
;   stack +16: arg_6 (via 20(A5))
;   stack +20: arg_7 (via 24(A5))
;   stack +24: arg_8 (via 28(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D5/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_MEMORY_AllocateMemory, ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes, ESQSHARED_JMPTBL_COI_EnsureAnimObjectAllocated, ESQSHARED_InitEntryDefaults
; READS:
;   Global_ESQPARS2_C_1, Global_ESQPARS2_C_2, Global_ESQPARS2_C_3, Global_ESQPARS2_C_4, ESQSHARED_CreateGroupEntryAndTitle_Return, TEXTDISP_SecondaryGroupCode, TEXTDISP_SecondaryGroupEntryCount, TEXTDISP_PrimaryGroupCode, TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryEntryPtrTable, TEXTDISP_SecondaryEntryPtrTable, TEXTDISP_PrimaryTitlePtrTable, TEXTDISP_SecondaryTitlePtrTable, TEXTDISP_GroupMutationState, TEXTDISP_MaxEntryTitleLength, MEMF_CLEAR, MEMF_PUBLIC, lab_0C1F, lab_0C20, lab_0C21
; WRITES:
;   TEXTDISP_SecondaryGroupPresentFlag, TEXTDISP_SecondaryGroupEntryCount, TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryGroupHeaderCode, TEXTDISP_SecondaryGroupHeaderCode, TEXTDISP_PrimaryGroupPresentFlag, TEXTDISP_GroupMutationState, TEXTDISP_MaxEntryTitleLength
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED_CreateGroupEntryAndTitle:
    LINK.W  A5,#-24
    MOVEM.L D5-D7/A2-A3/A6,-(A7)
    MOVE.B  11(A5),D7
    MOVE.B  15(A5),D6
    MOVEA.L 16(A5),A3
    MOVEA.L 20(A5),A2
    MOVE.B  TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D0,D7
    BNE.W   .lab_0C1F

    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     52.W
    PEA     299.W
    PEA     Global_ESQPARS2_C_1
    MOVE.L  A0,40(A7)
    JSR     ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVEA.L 40(A7),A0
    MOVE.L  D0,(A0)
    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    PEA     500.W
    PEA     301.W
    PEA     Global_ESQPARS2_C_2
    MOVE.L  A0,52(A7)
    JSR     ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     28(A7),A7
    MOVEA.L 24(A7),A0
    MOVE.L  D0,(A0)
    MOVE.B  #$1,TEXTDISP_SecondaryGroupPresentFlag
    MOVE.B  D7,TEXTDISP_SecondaryGroupHeaderCode
    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    LEA     TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    BRA.W   .lab_0C21

.lab_0C1F:
    MOVE.B  TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D0,D7
    BNE.W   .lab_0C20

    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     52.W
    PEA     314.W
    PEA     Global_ESQPARS2_C_3
    MOVE.L  A0,40(A7)
    JSR     ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVEA.L 40(A7),A0
    MOVE.L  D0,(A0)
    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    PEA     500.W
    PEA     315.W
    PEA     Global_ESQPARS2_C_4
    MOVE.L  A0,52(A7)
    JSR     ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     28(A7),A7
    MOVEA.L 24(A7),A0
    MOVE.L  D0,(A0)
    MOVE.B  #$1,TEXTDISP_PrimaryGroupPresentFlag
    MOVE.B  D7,TEXTDISP_PrimaryGroupHeaderCode
    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    LEA     TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    MOVE.L  A1,-4(A5)
    BRA.S   .lab_0C21

.lab_0C20:
    MOVEQ   #0,D0
    BRA.W   ESQSHARED_CreateGroupEntryAndTitle_Return

.lab_0C21:
    MOVE.L  -4(A5),-(A7)
    BSR.W   ESQSHARED_InitEntryDefaults

    MOVE.L  -4(A5),(A7)
    JSR     ESQSHARED_JMPTBL_COI_EnsureAnimObjectAllocated(PC)

    ADDQ.W  #4,A7
    MOVEA.L -4(A5),A0
    MOVE.B  D7,(A0)
    MOVE.L  A2,-12(A5)
    LEA     1(A0),A1
    MOVEA.L A2,A0

.branch:
    TST.B   (A0)+
    BNE.S   .branch

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,D5
    MOVE.L  A1,-16(A5)

.branch_1:
    TST.W   D5
    BEQ.S   .branch_3

    MOVEA.L -12(A5),A0
    MOVE.B  (A0),D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BEQ.S   .branch_2

    MOVEA.L -16(A5),A1
    MOVE.B  D0,(A1)+
    MOVE.L  A1,-16(A5)

.branch_2:
    ADDQ.L  #1,-12(A5)
    SUBQ.W  #1,D5
    BRA.S   .branch_1

.branch_3:
    MOVEA.L -16(A5),A0
    MOVE.B  #$20,(A0)+
    CLR.B   (A0)
    MOVEA.L -4(A5),A1
    ADDQ.L  #1,A1
    MOVEA.L A1,A6

.branch_4:
    TST.B   (A6)+
    BNE.S   .branch_4

    SUBQ.L  #1,A6
    SUBA.L  A1,A6
    MOVE.L  A6,D5
    MOVE.W  TEXTDISP_MaxEntryTitleLength,D0
    MOVE.L  A0,-16(A5)
    CMP.W   D0,D5
    BLE.S   .branch_5

    MOVE.W  D5,TEXTDISP_MaxEntryTitleLength

.branch_5:
    MOVEA.L -4(A5),A0
    ADDA.W  #12,A0
    MOVEA.L A3,A1

.branch_6:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .branch_6

    MOVEA.L -4(A5),A0
    ADDA.W  #19,A0
    MOVEA.L 28(A5),A1

.branch_7:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .branch_7

    MOVEA.L -4(A5),A0
    MOVE.B  D6,27(A0)
    LEA     28(A0),A1
    MOVE.L  24(A5),-(A7)
    MOVE.L  A1,-(A7)
    JSR     ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D5

.branch_8:
    MOVEQ   #6,D0
    CMP.W   D0,D5
    BGE.S   .branch_9

    MOVEA.L -4(A5),A0
    CLR.B   34(A0,D5.W)
    ADDQ.W  #1,D5
    BRA.S   .branch_8

.branch_9:
    MOVEA.L A3,A0
    MOVEA.L -8(A5),A1

.branch_10:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .branch_10

    MOVEA.L -8(A5),A0
    MOVE.B  D7,498(A0)
    MOVEQ   #0,D5

.branch_11:
    MOVEQ   #49,D0
    CMP.W   D0,D5
    BGE.S   .branch_12

    MOVEA.L -8(A5),A0
    MOVE.B  #$1,7(A0,D5.W)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    CLR.L   56(A0,D0.L)
    ADDQ.W  #1,D5
    BRA.S   .branch_11

.branch_12:
    MOVE.B  TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D7,D0
    BNE.S   .branch_13

    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,TEXTDISP_PrimaryGroupEntryCount
    MOVE.W  TEXTDISP_GroupMutationState,D0
    SUBQ.W  #2,D0
    BEQ.S   ESQSHARED_CreateGroupEntryAndTitle_Return

    MOVEQ   #1,D0
    MOVE.W  D0,TEXTDISP_GroupMutationState
    BRA.S   ESQSHARED_CreateGroupEntryAndTitle_Return

.branch_13:
    MOVE.B  TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   ESQSHARED_CreateGroupEntryAndTitle_Return

    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,TEXTDISP_SecondaryGroupEntryCount
    MOVE.W  #2,TEXTDISP_GroupMutationState

;------------------------------------------------------------------------------
; FUNC: ESQSHARED_CreateGroupEntryAndTitle_Return   (Routine at ESQSHARED_CreateGroupEntryAndTitle_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D5
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
ESQSHARED_CreateGroupEntryAndTitle_Return:
    MOVEM.L (A7)+,D5-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED_ApplyProgramTitleTextFilters   (Routine at ESQSHARED_ApplyProgramTitleTextFilters)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A3/A7/D7
; CALLS:
;   ESQSHARED_CompressClosedCaptionedTag, ESQSHARED_NormalizeInStereoTag, ESQSHARED_ReplaceMovieRatingToken, ESQSHARED_ReplaceTvRatingToken
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED_ApplyProgramTitleTextFilters:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.L  16(A7),D7
    MOVE.L  A3,-(A7)
    BSR.W   ESQSHARED_CompressClosedCaptionedTag

    MOVE.L  D7,(A7)
    MOVE.L  A3,-(A7)
    BSR.W   ESQSHARED_NormalizeInStereoTag

    MOVE.L  A3,(A7)
    BSR.W   ESQSHARED_ReplaceMovieRatingToken

    MOVE.L  A3,(A7)
    BSR.W   ESQSHARED_ReplaceTvRatingToken

    ADDQ.W  #8,A7
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED_CompressClosedCaptionedTag   (Routine at ESQSHARED_CompressClosedCaptionedTag)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0
; CALLS:
;   GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold, _LVOCopyMem
; READS:
;   AbsExecBase, Global_STR_CLOSED_CAPTIONED
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED_CompressClosedCaptionedTag:
    LINK.W  A5,#-4
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 8(A5),A3

    PEA     Global_STR_CLOSED_CAPTIONED
    MOVE.L  A3,-(A7)
    JSR     GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   .lab_0C34

    MOVEA.L D0,A0
    MOVE.B  #$7c,(A0)+
    LEA     3(A0),A1
    MOVEA.L A1,A2

.lab_0C33:
    TST.B   (A2)+
    BNE.S   .lab_0C33

    SUBQ.L  #1,A2
    SUBA.L  A1,A2
    MOVE.L  A2,D0
    ADDQ.L  #1,D0
    MOVE.L  A0,-4(A5)
    MOVEA.L A1,A0
    MOVEA.L -4(A5),A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

.lab_0C34:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED_NormalizeInStereoTag   (Routine at ESQSHARED_NormalizeInStereoTag)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A6/A7/D0/D1/D7
; CALLS:
;   ESQSHARED_JMPTBL_UNKNOWN7_SkipCharClass3, GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold, _LVOCopyMem
; READS:
;   AbsExecBase, Global_STR_IN_STEREO, ESQSHARED_NormalizeInStereoTag_Return, WDISP_CharClassTable
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED_NormalizeInStereoTag:
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    PEA     Global_STR_IN_STEREO
    MOVE.L  A3,-(A7)
    JSR     GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   ESQSHARED_NormalizeInStereoTag_Return

    MOVEA.L D0,A0
    MOVE.B  #$91,(A0)
    LEA     9(A0),A1
    MOVE.L  A1,-8(A5)
    BTST    #7,D7
    BNE.S   .lab_0C39

    TST.B   (A1)
    BNE.S   .lab_0C37

.lab_0C36:
    MOVEA.L -4(A5),A0
    CLR.B   (A0)
    SUBQ.L  #1,-4(A5)
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #3,(A0)
    BNE.S   .lab_0C36

    BRA.S   ESQSHARED_NormalizeInStereoTag_Return

.lab_0C37:
    MOVE.L  -8(A5),-(A7)
    JSR     ESQSHARED_JMPTBL_UNKNOWN7_SkipCharClass3(PC)

    ADDQ.W  #4,A7
    MOVEA.L D0,A0

.lab_0C38:
    TST.B   (A0)+
    BNE.S   .lab_0C38

    SUBQ.L  #1,A0
    SUBA.L  D0,A0
    MOVE.L  A0,D1
    ADDQ.L  #1,D1
    MOVE.L  D0,-8(A5)
    MOVEA.L D0,A0
    MOVE.L  D1,D0
    MOVEA.L -4(A5),A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    BRA.S   ESQSHARED_NormalizeInStereoTag_Return

.lab_0C39:
    ADDQ.L  #1,-4(A5)
    MOVEA.L -8(A5),A0

.lab_0C3A:
    TST.B   (A0)+
    BNE.S   .lab_0C3A

    SUBQ.L  #1,A0
    SUBA.L  -8(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVEA.L -8(A5),A0
    MOVEA.L -4(A5),A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

;------------------------------------------------------------------------------
; FUNC: ESQSHARED_NormalizeInStereoTag_Return   (Routine at ESQSHARED_NormalizeInStereoTag_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D7
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
ESQSHARED_NormalizeInStereoTag_Return:
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

; Possibly the code that replaces the strings of TV ratings like (TV-G) into
; a corresponding character in the font
;------------------------------------------------------------------------------
; FUNC: ESQSHARED_ReplaceMovieRatingToken   (Routine at ESQSHARED_ReplaceMovieRatingToken)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A5/A6/A7/D0/D5/D6/D7
; CALLS:
;   GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold, _LVOCopyMem
; READS:
;   AbsExecBase, Global_TBL_MOVIE_RATINGS, DATA_ESQPARS2_CONST_BYTE_1F1E
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED_ReplaceMovieRatingToken:
    LINK.W  A5,#-16
    MOVEM.L D5-D7/A2-A3,-(A7)

    UseLinkStackLong    MOVEA.L,1,A3

    MOVEQ   #0,D5
    MOVEQ   #0,D7

.lab_0C3D:
    MOVEQ   #7,D0
    CMP.L   D0,D7
    BGE.S   .return

    TST.W   D5
    BNE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     Global_TBL_MOVIE_RATINGS,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    MOVE.L  A3,-(A7)
    JSR     GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   .lab_0C40

    LEA     DATA_ESQPARS2_CONST_BYTE_1F1E,A0
    ADDA.L  D7,A0
    MOVE.B  (A0),D0
    MOVEA.L -4(A5),A1
    MOVE.B  D0,(A1)+
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     Global_TBL_MOVIE_RATINGS,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2

.lab_0C3E:
    TST.B   (A2)+
    BNE.S   .lab_0C3E

    SUBQ.L  #1,A2
    SUBA.L  (A0),A2
    MOVE.L  A2,D0
    MOVE.L  D0,D6
    SUBQ.L  #1,D6
    MOVE.L  A1,-4(A5)
    ADDA.L  D6,A1
    MOVEA.L A1,A0

.lab_0C3F:
    TST.B   (A0)+
    BNE.S   .lab_0C3F

    SUBQ.L  #1,A0
    SUBA.L  A1,A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVEA.L A1,A0
    MOVEA.L -4(A5),A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    MOVEQ   #1,D5

.lab_0C40:
    ADDQ.L  #1,D7
    BRA.S   .lab_0C3D

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

; Possibly the code that replaces the strings of movie ratings like (R) into
; a corresponding character in the font
;------------------------------------------------------------------------------
; FUNC: ESQSHARED_ReplaceTvRatingToken   (Routine at ESQSHARED_ReplaceTvRatingToken)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A5/A6/A7/D0/D5/D6/D7
; CALLS:
;   GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold, _LVOCopyMem
; READS:
;   AbsExecBase, Global_TBL_TV_PROGRAM_RATINGS, DATA_ESQPARS2_CONST_BYTE_1F27
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED_ReplaceTvRatingToken:
    LINK.W  A5,#-16
    MOVEM.L D5-D7/A2-A3,-(A7)

    UseLinkStackLong    MOVEA.L,1,A3

    MOVEQ   #0,D5
    MOVEQ   #0,D7

.lab_0C43:
    MOVEQ   #7,D0
    CMP.L   D0,D7
    BGE.S   .return

    TST.W   D5
    BNE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     Global_TBL_TV_PROGRAM_RATINGS,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    MOVE.L  A3,-(A7)
    JSR     GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   .lab_0C46

    LEA     DATA_ESQPARS2_CONST_BYTE_1F27,A0
    ADDA.L  D7,A0
    MOVE.B  (A0),D0
    MOVEA.L -4(A5),A1
    MOVE.B  D0,(A1)+
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     Global_TBL_TV_PROGRAM_RATINGS,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2

.lab_0C44:
    TST.B   (A2)+
    BNE.S   .lab_0C44

    SUBQ.L  #1,A2
    SUBA.L  (A0),A2
    MOVE.L  A2,D0
    MOVE.L  D0,D6
    SUBQ.L  #1,D6
    MOVE.L  A1,-4(A5)
    ADDA.L  D6,A1
    MOVEA.L A1,A0

.lab_0C45:
    TST.B   (A0)+
    BNE.S   .lab_0C45

    SUBQ.L  #1,A0
    SUBA.L  A1,A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVEA.L A1,A0
    MOVEA.L -4(A5),A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    MOVEQ   #1,D5

.lab_0C46:
    ADDQ.L  #1,D7
    BRA.S   .lab_0C43

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;------------------------------------------------------------------------------
; FUNC: ESQSHARED_UpdateMatchingEntriesByTitle   (Routine at ESQSHARED_UpdateMatchingEntriesByTitle)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +8: arg_3 (via 12(A5))
;   stack +10: arg_4 (via 14(A5))
;   stack +11: arg_5 (via 15(A5))
;   stack +15: arg_6 (via 19(A5))
;   stack +16: arg_7 (via 20(A5))
;   stack +18: arg_8 (via 22(A5))
;   stack +19: arg_9 (via 23(A5))
;   stack +20: arg_10 (via 24(A5))
;   stack +24: arg_11 (via 28(A5))
;   stack +25: arg_12 (via 29(A5))
;   stack +26: arg_13 (via 30(A5))
;   stack +30: arg_14 (via 34(A5))
;   stack +34: arg_15 (via 38(A5))
;   stack +38: arg_16 (via 42(A5))
;   stack +48: arg_17 (via 52(A5))
;   stack +58: arg_18 (via 62(A5))
;   stack +62: arg_19 (via 66(A5))
;   stack +66: arg_20 (via 70(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_MATH_Mulu32, ESQIFF_JMPTBL_MEMORY_AllocateMemory, ESQIFF_JMPTBL_MEMORY_DeallocateMemory, ESQSHARED_JMPTBL_DST_BuildBannerTimeWord, ESQSHARED_JMPTBL_ESQ_AdjustBracketedHourInString, ESQSHARED_JMPTBL_ESQ_SetBit1Based, ESQSHARED_JMPTBL_ESQ_TestBit1Based, ESQSHARED_JMPTBL_ESQ_WildcardMatch, GROUP_AR_JMPTBL_STRING_AppendAtNull, GROUP_AS_JMPTBL_UNKNOWN7_FindCharWrapper, GROUP_AW_JMPTBL_WDISP_SPrintf, ESQPARS_ReplaceOwnedString, ESQSHARED_ApplyProgramTitleTextFilters, NEWGRID_JMPTBL_MATH_DivS32
; READS:
;   Global_STR_ESQPARS2_C_1, Global_STR_ESQPARS2_C_2, ESQSHARED_UpdateMatchingEntriesByTitle_Return, CLOCK_FormatVariantCode, DATA_ESQPARS2_FMT_PCT_D_1F29, DATA_ESQPARS2_FMT_PCT_D_1F2A, DATA_ESQPARS2_FMT_PCT_D_1F2B, DATA_ESQPARS2_STR_VALUE_1F2C, DATA_SCRIPT_STR_HRS_2102, DATA_SCRIPT_STR_HR_2103, DATA_SCRIPT_STR_MIN_2104, WDISP_CharClassTable, TEXTDISP_SecondaryGroupCode, TEXTDISP_SecondaryGroupPresentFlag, TEXTDISP_SecondaryGroupEntryCount, TEXTDISP_PrimaryGroupCode, TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryEntryPtrTable, TEXTDISP_SecondaryEntryPtrTable, TEXTDISP_PrimaryTitlePtrTable, TEXTDISP_SecondaryTitlePtrTable, MEMF_CLEAR, MEMF_PUBLIC, branch, branch_21, lab_0C5F, lab_0C6F
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED_UpdateMatchingEntriesByTitle:
    LINK.W  A5,#-76
    MOVEM.L D2-D7/A2-A3/A6,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.B  15(A5),D7
    MOVE.B  19(A5),D6
    MOVE.B  23(A5),D5
    MOVEA.L 24(A5),A2

    MOVE.L  D6,D0
    ANDI.B  #$40,D0
    ANDI.B  #$3f,D6
    MOVE.B  D0,-15(A5)
    MOVEQ   #1,D0
    CMP.B   D0,D6
    BCS.S   .lab_0C49

    MOVEQ   #48,D1
    CMP.B   D1,D6
    BLS.S   .lab_0C4A

.lab_0C49:
    MOVEQ   #0,D0
    BRA.W   ESQSHARED_UpdateMatchingEntriesByTitle_Return

.lab_0C4A:
    MOVE.B  TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D7,D0
    BNE.S   .lab_0C4B

    MOVE.B  TEXTDISP_SecondaryGroupPresentFlag,D0
    SUBQ.B  #1,D0
    BNE.S   .lab_0C4B

    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    MOVE.W  D0,-14(A5)
    BRA.S   .lab_0C4D

.lab_0C4B:
    MOVE.B  TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   .lab_0C4C

    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.W  D0,-14(A5)
    BRA.S   .lab_0C4D

.lab_0C4C:
    MOVEQ   #0,D0
    BRA.W   ESQSHARED_UpdateMatchingEntriesByTitle_Return

.lab_0C4D:
    CLR.W   -10(A5)

.branch:
    MOVE.W  -10(A5),D0
    CMP.W   -14(A5),D0
    BGE.W   ESQSHARED_UpdateMatchingEntriesByTitle_Return

    MOVE.B  TEXTDISP_SecondaryGroupCode,D1
    CMP.B   D1,D7
    BNE.S   .lab_0C4F

    MOVE.B  TEXTDISP_SecondaryGroupPresentFlag,D1
    SUBQ.B  #1,D1
    BNE.S   .lab_0C4F

    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-4(A5)
    LEA     TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-8(A5)
    BRA.S   .lab_0C50

.lab_0C4F:
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-4(A5)
    LEA     TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-8(A5)

.lab_0C50:
    MOVE.L  A3,-(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     ESQSHARED_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.W   .lab_0C6F

    MOVEA.L -4(A5),A0
    ADDA.W  #$22,A0
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ESQSHARED_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    MOVE.W  D0,-12(A5)
    TST.B   -15(A5)
    BNE.S   .lab_0C51

    TST.W   D0
    BNE.W   .lab_0C6F

.lab_0C51:
    TST.B   -15(A5)
    BEQ.S   .lab_0C52

    MOVEA.L -4(A5),A0
    ADDA.W  #$22,A0
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ESQSHARED_JMPTBL_ESQ_SetBit1Based(PC)

    ADDQ.W  #8,A7

.lab_0C52:
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVEA.L -8(A5),A0
    MOVE.B  D5,7(A0,D0.W)
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A1
    MOVE.B  27(A1),D0
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    BSR.W   ESQSHARED_ApplyProgramTitleTextFilters

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    MOVEA.L A2,A0
    MOVEA.L A0,A1

.lab_0C53:
    TST.B   (A1)+
    BNE.S   .lab_0C53

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D1
    MOVE.L  A0,-34(A5)
    ADDA.L  D1,A0
    MOVE.B  D0,-30(A5)
    MOVE.B  D0,-29(A5)
    MOVE.L  A0,-28(A5)
    MOVE.B  -1(A0),D0
    MOVEQ   #41,D1
    CMP.B   D1,D0
    BNE.S   .lab_0C54

    MOVE.B  -4(A0),D2
    MOVEQ   #58,D3
    CMP.B   D3,D2
    BNE.S   .lab_0C54

    MOVEQ   #40,D4
    CMP.B   -6(A0),D4
    BNE.S   .lab_0C54

    MOVEQ   #1,D4
    MOVE.B  D4,-29(A5)

.lab_0C54:
    CMP.B   D1,D0
    BNE.S   .lab_0C55

    MOVEQ   #58,D0
    CMP.B   -4(A0),D0
    BNE.S   .lab_0C55

    MOVEQ   #40,D0
    CMP.B   -5(A0),D0
    BNE.S   .lab_0C55

    MOVEQ   #1,D0
    MOVE.B  D0,-30(A5)

.lab_0C55:
    TST.B   -29(A5)
    BNE.S   .lab_0C56

    TST.B   -30(A5)
    BEQ.W   .lab_0C5F

.lab_0C56:
    MOVEQ   #0,D0
    SUBA.L  A1,A1
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     50.W
    PEA     720.W
    PEA     Global_STR_ESQPARS2_C_1
    MOVE.L  D0,-42(A5)
    MOVE.L  D0,-38(A5)
    MOVE.L  A1,-70(A5)
    MOVE.L  A1,-66(A5)
    JSR     ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-70(A5)
    MOVE.L  D0,-66(A5)
    TST.B   -29(A5)
    BEQ.S   .lab_0C57

    MOVEA.L -28(A5),A0
    MOVE.B  -5(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,-38(A5)

.lab_0C57:
    MOVEA.L -28(A5),A0
    MOVE.B  -3(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    MOVE.L  D0,-42(A5)
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.B  -2(A0),D1
    EXT.W   D1
    EXT.L   D1
    ADD.L   D1,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEM.L D0,-42(A5)
    MOVE.L  -38(A5),D1
    TST.L   D1
    BLE.S   .branch_2

    MOVE.L  D0,-(A7)
    PEA     DATA_ESQPARS2_FMT_PCT_D_1F29
    PEA     -52(A5)
    JSR     GROUP_AW_JMPTBL_WDISP_SPrintf(PC)

    MOVE.L  -38(A5),(A7)
    PEA     DATA_ESQPARS2_FMT_PCT_D_1F2A
    PEA     -62(A5)
    JSR     GROUP_AW_JMPTBL_WDISP_SPrintf(PC)

    PEA     -62(A5)
    MOVE.L  -66(A5),-(A7)
    JSR     GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    LEA     28(A7),A7
    MOVEQ   #1,D0
    CMP.L   -38(A5),D0
    BNE.S   .branch_1

    PEA     DATA_SCRIPT_STR_HR_2103
    MOVE.L  -66(A5),-(A7)
    JSR     GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    BRA.S   .branch_3

.branch_1:
    PEA     DATA_SCRIPT_STR_HRS_2102
    MOVE.L  -66(A5),-(A7)
    JSR     GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    BRA.S   .branch_3

.branch_2:
    MOVE.L  D0,-(A7)
    PEA     DATA_ESQPARS2_FMT_PCT_D_1F2B
    PEA     -52(A5)
    JSR     GROUP_AW_JMPTBL_WDISP_SPrintf(PC)

    LEA     12(A7),A7

.branch_3:
    MOVE.L  -42(A5),D0
    TST.L   D0
    BLE.S   .branch_4

    PEA     -52(A5)
    MOVE.L  -66(A5),-(A7)
    JSR     GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    PEA     DATA_SCRIPT_STR_MIN_2104
    MOVE.L  -66(A5),-(A7)
    JSR     GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    LEA     16(A7),A7
    BRA.S   .branch_6

.branch_4:
    MOVEA.L -66(A5),A0

.branch_5:
    TST.B   (A0)+
    BNE.S   .branch_5

    SUBQ.L  #1,A0
    SUBA.L  -66(A5),A0
    MOVEA.L -66(A5),A1
    MOVE.L  A0,D0
    CLR.B   -1(A1,D0.L)
    PEA     DATA_ESQPARS2_STR_VALUE_1F2C
    MOVE.L  A1,-(A7)
    JSR     GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.branch_6:
    MOVEA.L -28(A5),A0
    SUBQ.L  #6,A0
    MOVEA.L -66(A5),A1

.branch_7:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .branch_7

    TST.L   -70(A5)
    BEQ.S   .lab_0C5F

    PEA     50.W
    MOVE.L  -70(A5),-(A7)
    PEA     765.W
    PEA     Global_STR_ESQPARS2_C_2
    JSR     ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.lab_0C5F:
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,D2
    EXT.L   D2
    ASL.L   #2,D2
    MOVEA.L -8(A5),A0
    MOVE.L  56(A0,D2.L),-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  D1,44(A7)
    JSR     ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVEA.L -8(A5),A0
    MOVE.L  36(A7),D1
    MOVE.L  D0,56(A0,D1.L)
    MOVE.B  CLOCK_FormatVariantCode,D0
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.W   .branch_21

    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    PEA     91.W
    MOVE.L  56(A0,D1.L),-(A7)
    JSR     GROUP_AS_JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-20(A5)
    TST.L   D0
    BEQ.W   .branch_21

    MOVEA.L D0,A0
    MOVE.B  1(A0),D1
    EXT.W   D1
    EXT.L   D1
    LEA     WDISP_CharClassTable,A1
    MOVEA.L A1,A6
    ADDA.L  D1,A6
    BTST    #2,(A6)
    BEQ.S   .branch_8

    MOVE.B  1(A0),D1
    EXT.W   D1
    EXT.L   D1
    MOVEQ   #48,D2
    SUB.L   D2,D1
    MOVEQ   #10,D0
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    BRA.S   .branch_9

.branch_8:
    MOVEQ   #0,D0

.branch_9:
    MOVE.B  2(A0),D1
    EXT.W   D1
    EXT.L   D1
    MOVEA.L A1,A6
    ADDA.L  D1,A6
    MOVE.W  D0,-22(A5)
    BTST    #2,(A6)
    BEQ.S   .branch_10

    MOVE.B  2(A0),D1
    EXT.W   D1
    EXT.L   D1
    MOVEQ   #48,D2
    SUB.L   D2,D1
    BRA.S   .branch_11

.branch_10:
    MOVEQ   #0,D1

.branch_11:
    EXT.L   D0
    ADD.L   D1,D0
    MOVE.B  4(A0),D1
    EXT.W   D1
    EXT.L   D1
    MOVEA.L A1,A6
    ADDA.L  D1,A6
    MOVE.W  D0,-22(A5)
    BTST    #2,(A6)
    BEQ.S   .branch_12

    MOVE.B  4(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    BRA.S   .branch_13

.branch_12:
    MOVEQ   #0,D0

.branch_13:
    MOVE.B  5(A0),D1
    EXT.W   D1
    EXT.L   D1
    ADDA.L  D1,A1
    MOVE.W  D0,-24(A5)
    BTST    #2,(A1)
    BEQ.S   .branch_14

    MOVE.B  5(A0),D1
    EXT.W   D1
    EXT.L   D1
    MOVEQ   #48,D2
    SUB.L   D2,D1
    BRA.S   .branch_15

.branch_14:
    MOVEQ   #0,D1

.branch_15:
    EXT.L   D0
    ADD.L   D1,D0
    MOVE.W  D0,-24(A5)
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  CLOCK_FormatVariantCode,D1
    ADD.L   D1,D0
    MOVE.W  D0,-24(A5)

.branch_16:
    MOVE.W  -24(A5),D0
    MOVEQ   #59,D1
    CMP.W   D1,D0
    BLE.S   .branch_17

    MOVEQ   #60,D1
    SUB.W   D1,-24(A5)
    ADDQ.W  #1,-22(A5)
    BRA.S   .branch_16

.branch_17:
    MOVE.W  -22(A5),D0
    MOVEQ   #12,D1
    CMP.W   D1,D0
    BLE.S   .branch_18

    MOVEQ   #12,D1
    SUB.W   D1,-22(A5)
    BRA.S   .branch_17

.branch_18:
    MOVE.W  -22(A5),D0
    EXT.L   D0
    MOVEQ   #10,D1
    JSR     NEWGRID_JMPTBL_MATH_DivS32(PC)

    MOVEQ   #48,D0
    ADD.L   D0,D1
    MOVEA.L -20(A5),A0
    MOVE.B  D1,2(A0)
    MOVE.W  -22(A5),D1
    EXT.L   D1
    DIVS    #10,D1
    MOVEM.W D1,-22(A5)
    BLE.S   .branch_19

    EXT.L   D1
    ADD.L   D0,D1
    BRA.S   .branch_20

.branch_19:
    MOVEQ   #32,D1

.branch_20:
    MOVE.B  D1,1(A0)
    MOVE.W  -24(A5),D1
    EXT.L   D1
    MOVE.L  D1,D0
    MOVEQ   #10,D1
    JSR     NEWGRID_JMPTBL_MATH_DivS32(PC)

    MOVEQ   #48,D1
    ADD.L   D1,D0
    MOVE.B  D0,4(A0)
    MOVE.W  -24(A5),D0
    EXT.L   D0
    MOVEQ   #10,D1
    JSR     NEWGRID_JMPTBL_MATH_DivS32(PC)

    MOVEQ   #48,D0
    ADD.L   D0,D1
    MOVE.B  D1,5(A0)

.branch_21:
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    EXT.L   D0
    MOVEQ   #0,D2
    MOVEA.L -8(A5),A0
    MOVE.B  498(A0),D2
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,44(A7)
    JSR     ESQSHARED_JMPTBL_DST_BuildBannerTimeWord(PC)

    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  44(A7),D1
    MOVE.L  56(A0,D1.L),-(A7)
    JSR     ESQSHARED_JMPTBL_ESQ_AdjustBracketedHourInString(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVEA.L -8(A5),A0
    BTST    #4,7(A0,D0.W)
    BEQ.S   .branch_22

    MOVEA.L -4(A5),A0
    BSET    #0,40(A0)

.branch_22:
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  40(A0),D0
    ORI.W   #$80,D0
    MOVE.B  D0,40(A0)

.lab_0C6F:
    ADDQ.W  #1,-10(A5)
    BRA.W   .branch

;------------------------------------------------------------------------------
; FUNC: ESQSHARED_UpdateMatchingEntriesByTitle_Return   (Routine at ESQSHARED_UpdateMatchingEntriesByTitle_Return)
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
ESQSHARED_UpdateMatchingEntriesByTitle_Return:
    MOVEM.L (A7)+,D2-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

;------------------------------------------------------------------------------
; FUNC: ESQSHARED_JMPTBL_DST_BuildBannerTimeWord   (Routine at ESQSHARED_JMPTBL_DST_BuildBannerTimeWord)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DST_BuildBannerTimeWord
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED_JMPTBL_DST_BuildBannerTimeWord:
    JMP     DST_BuildBannerTimeWord

;------------------------------------------------------------------------------
; FUNC: ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes   (Routine at ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_ReverseBitsIn6Bytes
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes:
    JMP     ESQ_ReverseBitsIn6Bytes

;------------------------------------------------------------------------------
; FUNC: ESQSHARED_JMPTBL_ESQ_SetBit1Based   (Routine at ESQSHARED_JMPTBL_ESQ_SetBit1Based)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_SetBit1Based
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED_JMPTBL_ESQ_SetBit1Based:
    JMP     ESQ_SetBit1Based

;------------------------------------------------------------------------------
; FUNC: ESQSHARED_JMPTBL_ESQ_AdjustBracketedHourInString   (Routine at ESQSHARED_JMPTBL_ESQ_AdjustBracketedHourInString)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_AdjustBracketedHourInString
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED_JMPTBL_ESQ_AdjustBracketedHourInString:
    JMP     ESQ_AdjustBracketedHourInString

;------------------------------------------------------------------------------
; FUNC: ESQSHARED_JMPTBL_COI_EnsureAnimObjectAllocated   (Routine at ESQSHARED_JMPTBL_COI_EnsureAnimObjectAllocated)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   COI_EnsureAnimObjectAllocated
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED_JMPTBL_COI_EnsureAnimObjectAllocated:
    JMP     COI_EnsureAnimObjectAllocated

;------------------------------------------------------------------------------
; FUNC: ESQSHARED_JMPTBL_ESQ_WildcardMatch   (Routine at ESQSHARED_JMPTBL_ESQ_WildcardMatch)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_WildcardMatch
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED_JMPTBL_ESQ_WildcardMatch:
    JMP     ESQ_WildcardMatch

;------------------------------------------------------------------------------
; FUNC: ESQSHARED_JMPTBL_UNKNOWN7_SkipCharClass3   (Routine at ESQSHARED_JMPTBL_UNKNOWN7_SkipCharClass3)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   UNKNOWN7_SkipCharClass3
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED_JMPTBL_UNKNOWN7_SkipCharClass3:
    JMP     UNKNOWN7_SkipCharClass3

;------------------------------------------------------------------------------
; FUNC: ESQSHARED_JMPTBL_ESQ_TestBit1Based   (Routine at ESQSHARED_JMPTBL_ESQ_TestBit1Based)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_TestBit1Based
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED_JMPTBL_ESQ_TestBit1Based:
    JMP     ESQ_TestBit1Based
