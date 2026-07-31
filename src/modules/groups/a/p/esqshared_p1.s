    XDEF    _ESQSHARED_CreateGroupEntryAndTitle
    XDEF    ESQSHARED_CreateGroupEntryAndTitle_Return


;------------------------------------------------------------------------------
; FUNC: _ESQSHARED_CreateGroupEntryAndTitle   (Allocate and register group entry/title pair)
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
;   _ESQIFF_JMPTBL_MEMORY_AllocateMemory, _ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes, _ESQSHARED_JMPTBL_COI_EnsureAnimObjectAllocated, _ESQSHARED_InitEntryDefaults
; READS:
;   _Global_ESQPARS2_C_1, _Global_ESQPARS2_C_2, _Global_ESQPARS2_C_3, _Global_ESQPARS2_C_4, ESQSHARED_CreateGroupEntryAndTitle_Return, _TEXTDISP_SecondaryGroupCode, _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryGroupCode, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryEntryPtrTable, _TEXTDISP_SecondaryEntryPtrTable, _TEXTDISP_PrimaryTitlePtrTable, _TEXTDISP_SecondaryTitlePtrTable, _TEXTDISP_GroupMutationState, _TEXTDISP_MaxEntryTitleLength, MEMF_CLEAR, MEMF_PUBLIC, lab_0C1F, lab_0C20, lab_0C21
; WRITES:
;   _TEXTDISP_SecondaryGroupPresentFlag, _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryGroupHeaderCode, _TEXTDISP_SecondaryGroupHeaderCode, _TEXTDISP_PrimaryGroupPresentFlag, _TEXTDISP_GroupMutationState, _TEXTDISP_MaxEntryTitleLength
; DESC:
;   Allocates one entry record and one title table for the target group, seeds
;   defaults/flags/text fields, and appends the new pointers to group tables.
; NOTES:
;   Initializes all 49 title-slot flags to present and clears slot string pointers.
;------------------------------------------------------------------------------
_ESQSHARED_CreateGroupEntryAndTitle:
    LINK.W  A5,#-24
    MOVEM.L D5-D7/A2-A3/A6,-(A7)
    MOVE.B  11(A5),D7
    MOVE.B  15(A5),D6
    MOVEA.L 16(A5),A3
    MOVEA.L 20(A5),A2
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D0,D7
    BNE.W   .lab_0C1F

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     52.W
    PEA     299.W
    PEA     _Global_ESQPARS2_C_1
    MOVE.L  A0,40(A7)
    JSR     _ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVEA.L 40(A7),A0
    MOVE.L  D0,(A0)
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    PEA     500.W
    PEA     301.W
    PEA     _Global_ESQPARS2_C_2
    MOVE.L  A0,52(A7)
    JSR     _ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     28(A7),A7
    MOVEA.L 24(A7),A0
    MOVE.L  D0,(A0)
    MOVE.B  #$1,_TEXTDISP_SecondaryGroupPresentFlag
    MOVE.B  D7,_TEXTDISP_SecondaryGroupHeaderCode
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    BRA.W   .lab_0C21

.lab_0C1F:
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D0,D7
    BNE.W   .lab_0C20

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     52.W
    PEA     314.W
    PEA     _Global_ESQPARS2_C_3
    MOVE.L  A0,40(A7)
    JSR     _ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVEA.L 40(A7),A0
    MOVE.L  D0,(A0)
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    PEA     500.W
    PEA     315.W
    PEA     _Global_ESQPARS2_C_4
    MOVE.L  A0,52(A7)
    JSR     _ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     28(A7),A7
    MOVEA.L 24(A7),A0
    MOVE.L  D0,(A0)
    MOVE.B  #$1,_TEXTDISP_PrimaryGroupPresentFlag
    MOVE.B  D7,_TEXTDISP_PrimaryGroupHeaderCode
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    MOVE.L  A1,-4(A5)
    BRA.S   .lab_0C21

.lab_0C20:
    MOVEQ   #0,D0
    BRA.W   ESQSHARED_CreateGroupEntryAndTitle_Return

.lab_0C21:
    MOVE.L  -4(A5),-(A7)
    BSR.W   _ESQSHARED_InitEntryDefaults

    MOVE.L  -4(A5),(A7)
    JSR     _ESQSHARED_JMPTBL_COI_EnsureAnimObjectAllocated(PC)

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
    MOVE.W  _TEXTDISP_MaxEntryTitleLength,D0
    MOVE.L  A0,-16(A5)
    CMP.W   D0,D5
    BLE.S   .branch_5

    MOVE.W  D5,_TEXTDISP_MaxEntryTitleLength

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
    JSR     _ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes(PC)

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
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D7,D0
    BNE.S   .branch_13

    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_TEXTDISP_PrimaryGroupEntryCount
    MOVE.W  _TEXTDISP_GroupMutationState,D0
    SUBQ.W  #2,D0
    BEQ.S   ESQSHARED_CreateGroupEntryAndTitle_Return

    MOVEQ   #1,D0
    MOVE.W  D0,_TEXTDISP_GroupMutationState
    BRA.S   ESQSHARED_CreateGroupEntryAndTitle_Return

.branch_13:
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   ESQSHARED_CreateGroupEntryAndTitle_Return

    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_TEXTDISP_SecondaryGroupEntryCount
    MOVE.W  #2,_TEXTDISP_GroupMutationState

;------------------------------------------------------------------------------
; FUNC: ESQSHARED_CreateGroupEntryAndTitle_Return   (Return tail for group entry/title allocator)
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
;   Shared return tail for _ESQSHARED_CreateGroupEntryAndTitle.
; NOTES:
;   Restores D5-D7/A2-A3/A6 and frame state.
;------------------------------------------------------------------------------
ESQSHARED_CreateGroupEntryAndTitle_Return:
    MOVEM.L (A7)+,D5-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======