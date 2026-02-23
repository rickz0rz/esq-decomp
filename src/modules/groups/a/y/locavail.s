    XDEF    LOCAVAIL_AllocNodeArraysForState
    XDEF    LOCAVAIL_ComputeFilterOffsetForEntry
    XDEF    LOCAVAIL_CopyFilterStateStructRetainRefs
    XDEF    LOCAVAIL_FreeNodeAtPointer
    XDEF    LOCAVAIL_FreeNodeRecord
    XDEF    LOCAVAIL_FreeResourceChain
    XDEF    LOCAVAIL_GetFilterWindowHalfSpan
    XDEF    LOCAVAIL_GetNodeDurationByIndex
    XDEF    LOCAVAIL_LoadAvailabilityDataFile
    XDEF    LOCAVAIL_MapFilterTokenCharToClass
    XDEF    LOCAVAIL_ParseFilterStateFromBuffer
    XDEF    LOCAVAIL_RebuildFilterStateFromCurrentGroup
    XDEF    LOCAVAIL_ResetFilterCursorState
    XDEF    LOCAVAIL_ResetFilterStateStruct
    XDEF    LOCAVAIL_SaveAvailabilityDataFile
    XDEF    LOCAVAIL_SetFilterModeAndResetState
    XDEF    LOCAVAIL_SyncSecondaryFilterForCurrentGroup
    XDEF    LOCAVAIL_UpdateFilterStateMachine
    XDEF    LOCAVAIL_ComputeFilterOffsetForEntry_Return
    XDEF    LOCAVAIL_LoadAvailabilityDataFile_Return
    XDEF    LOCAVAIL_MapFilterTokenCharToClass_Return
    XDEF    LOCAVAIL_ParseFilterStateFromBuffer_Return
    XDEF    LOCAVAIL_SaveAvailabilityDataFile_Return
    XDEF    LOCAVAIL_UpdateFilterStateMachine_Return

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_FreeNodeRecord   (Clear one availability-node record in place)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   node record bytes at A3 (+0,+2,+4,+6)
; DESC:
;   Zeroes flag/count/length/pointer fields for a single node record.
; NOTES:
;   Does not free external buffers; call `LOCAVAIL_FreeNodeAtPointer` for owned data.
;------------------------------------------------------------------------------
LOCAVAIL_FreeNodeRecord:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    CLR.B   (A3)
    MOVEQ   #0,D0
    MOVE.W  D0,2(A3)
    MOVE.W  D0,4(A3)
    CLR.L   6(A3)
    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_FreeNodeAtPointer   (Free node payload buffer then clear node record)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0
; CALLS:
;   NEWGRID_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   Global_STR_LOCAVAIL_C_1
; WRITES:
;   (none observed)
; DESC:
;   Releases node-owned payload at +6 when present and length (+4) is positive,
;   then clears the node fields via `LOCAVAIL_FreeNodeRecord`.
; NOTES:
;   No-op for NULL node pointers.
;------------------------------------------------------------------------------
LOCAVAIL_FreeNodeAtPointer:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  A3,D0
    BEQ.S   .return

    TST.L   6(A3)
    BEQ.S   .clear_node_record

    MOVE.W  4(A3),D0
    TST.W   D0
    BLE.S   .clear_node_record

    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  6(A3),-(A7)
    PEA     106.W
    PEA     Global_STR_LOCAVAIL_C_1
    JSR     NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.clear_node_record:
    MOVE.L  A3,-(A7)
    BSR.S   LOCAVAIL_FreeNodeRecord

    ADDQ.W  #4,A7

.return:
    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_ResetFilterStateStruct   (Reset filter-state struct to defaults)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A7/D0
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   filter-state fields at A3 (+0,+2,+6,+8,+12,+16,+20)
; DESC:
;   Clears transient state, nulls shared refs/arrays, sets default mode marker (`'F'`),
;   and initializes cursor-related longs to `-1`.
; NOTES:
;   Does not free prior allocations; intended for fresh/init path or post-free reset.
;------------------------------------------------------------------------------
LOCAVAIL_ResetFilterStateStruct:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    CLR.B   (A3)
    CLR.L   2(A3)
    SUBA.L  A0,A0
    MOVE.L  A0,16(A3)
    MOVE.L  A0,20(A3)
    MOVE.B  #'F',6(A3)
    MOVEQ   #-1,D0
    MOVE.L  D0,8(A3)
    MOVE.L  D0,12(A3)
    MOVEA.L (A7)+,A3
    RTS

;!======

; Release a LOCAVAIL structure (free node array/bitmap and associated memory).
;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_FreeResourceChain   (Release shared refs, free node array/payloads, reset state)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A7/D0/D1/D7
; CALLS:
;   GROUP_AY_JMPTBL_MATH_Mulu32, LOCAVAIL_FreeNodeAtPointer, LOCAVAIL_ResetFilterStateStruct, NEWGRID_JMPTBL_MATH_Mulu32, NEWGRID_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   Global_STR_LOCAVAIL_C_2, Global_STR_LOCAVAIL_C_3
; WRITES:
;   shared refcount at *(A3+16), released node payload/array ownership
; DESC:
;   Decrements shared refcount for retained header, frees node payloads/array when
;   the shared count reaches zero, then resets the owning filter-state struct.
; NOTES:
;   Safe to call with NULL state pointer.
;------------------------------------------------------------------------------
LOCAVAIL_FreeResourceChain:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.L  A3,D0
    BEQ.W   .return

    TST.L   16(A3)
    BEQ.W   .reset_state_struct

    MOVEA.L 16(A3),A0
    MOVE.L  (A0),D0
    TST.L   D0
    BLE.S   .decrement_shared_refcount

    SUBQ.L  #1,(A0)

.decrement_shared_refcount:
    TST.L   20(A3)
    BEQ.S   .reset_state_struct

    MOVE.L  2(A3),D0
    TST.L   D0
    BLE.S   .reset_state_struct

    MOVEA.L 16(A3),A0
    TST.L   (A0)
    BNE.S   .reset_state_struct

    PEA     4.W
    MOVE.L  A0,-(A7)
    PEA     159.W
    PEA     Global_STR_LOCAVAIL_C_2
    JSR     NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVEQ   #0,D7

.free_each_node_loop:
    CMP.L   2(A3),D7
    BGE.S   .free_node_array

    MOVE.L  D7,D0
    MOVEQ   #10,D1
    JSR     NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEA.L 20(A3),A0
    ADDA.L  D0,A0
    MOVE.L  A0,-(A7)
    BSR.W   LOCAVAIL_FreeNodeAtPointer

    ADDQ.W  #4,A7
    ADDQ.L  #1,D7
    BRA.S   .free_each_node_loop

.free_node_array:
    MOVE.L  2(A3),D0
    MOVEQ   #10,D1
    JSR     GROUP_AY_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,-(A7)
    MOVE.L  20(A3),-(A7)
    PEA     164.W
    PEA     Global_STR_LOCAVAIL_C_3
    JSR     NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.reset_state_struct:
    MOVE.L  A3,-(A7)
    BSR.W   LOCAVAIL_ResetFilterStateStruct

    ADDQ.W  #4,A7

.return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_CopyFilterStateStructRetainRefs   (Copy filter state while retaining shared refs)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A2/A3/A7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   destination state fields at A3; increments shared refcount when present
; DESC:
;   Copies scalar state plus shared-header/node-array pointers from source to
;   destination and bumps shared refcount for retained shared resources.
; NOTES:
;   Shallow copy by design for retained arrays.
;------------------------------------------------------------------------------
LOCAVAIL_CopyFilterStateStructRetainRefs:
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEA.L 16(A7),A2
    MOVE.B  (A2),(A3)
    MOVE.L  2(A2),2(A3)
    MOVE.B  6(A2),6(A3)
    MOVEA.L 16(A2),A0
    MOVE.L  A0,16(A3)
    MOVE.L  20(A2),20(A3)
    TST.L   16(A3)
    BEQ.S   .return

    MOVEA.L 16(A3),A0
    ADDQ.L  #1,(A0)

.return:
    MOVEM.L (A7)+,A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_AllocNodeArraysForState   (Allocate shared header and node array for filter state)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A7/D0/D1/D7
; CALLS:
;   GROUP_AY_JMPTBL_MATH_Mulu32, NEWGRID_JMPTBL_MEMORY_AllocateMemory
; READS:
;   Global_STR_LOCAVAIL_C_4, Global_STR_LOCAVAIL_C_5, MEMF_CLEAR, MEMF_PUBLIC
; WRITES:
;   A3+16 shared header ptr, A3+20 node array ptr
; DESC:
;   Allocates shared header and contiguous node array when node count is within
;   valid bounds (1..99), returning success flag in D0.
; NOTES:
;   Initializes shared header refcount to zero before array allocation.
;------------------------------------------------------------------------------
LOCAVAIL_AllocNodeArraysForState:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7
    MOVE.L  2(A3),D0
    TST.L   D0
    BLE.S   .return

    MOVEQ   #100,D1
    CMP.L   D1,D0
    BGE.S   .return

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     4.W
    PEA     218.W
    PEA     Global_STR_LOCAVAIL_C_4
    JSR     NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,16(A3)
    TST.L   D0
    BEQ.S   .return

    MOVEA.L D0,A0
    CLR.L   (A0)
    MOVE.L  2(A3),D0
    MOVEQ   #10,D1
    JSR     GROUP_AY_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     229.W
    PEA     Global_STR_LOCAVAIL_C_5
    JSR     NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,20(A3)
    BEQ.S   .return

    MOVEQ   #1,D7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_ResetFilterCursorState   (Reset active filter cursor/class trackers)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   LOCAVAIL_FilterStep, LOCAVAIL_FilterClassId
; DESC:
;   Clears global filter step and sets cursor/class fields to `-1` sentinels.
; NOTES:
;   Leaves mode and allocation pointers unchanged.
;------------------------------------------------------------------------------
LOCAVAIL_ResetFilterCursorState:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVEQ   #-1,D0
    MOVE.L  D0,8(A3)
    MOVE.L  D0,12(A3)
    MOVE.L  D0,LOCAVAIL_FilterClassId
    CLR.L   LOCAVAIL_FilterStep
    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_SetFilterModeAndResetState   (Apply filter mode change and reset cursors)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   (none)
; READS:
;   LOCAVAIL_FilterModeFlag, LOCAVAIL_PrimaryFilterState
; WRITES:
;   LOCAVAIL_FilterModeFlag
; DESC:
;   Updates `LOCAVAIL_FilterModeFlag` only for supported mode values (0/1) and
;   resets primary filter cursor state when mode actually changes.
; NOTES:
;   Ignores unsupported mode values and no-op transitions.
;------------------------------------------------------------------------------
LOCAVAIL_SetFilterModeAndResetState:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    MOVE.L  LOCAVAIL_FilterModeFlag,D0
    CMP.L   D7,D0
    BEQ.S   .return

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BEQ.S   .set_mode_and_reset

    TST.L   D7
    BNE.S   .return

.set_mode_and_reset:
    MOVE.L  D7,LOCAVAIL_FilterModeFlag
    PEA     LOCAVAIL_PrimaryFilterState
    BSR.S   LOCAVAIL_ResetFilterCursorState

    ADDQ.W  #4,A7

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_ParseFilterStateFromBuffer   (Parse serialized filter-state buffer)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +14: arg_3 (via 18(A5))
;   stack +18: arg_4 (via 22(A5))
;   stack +20: arg_5 (via 24(A5))
;   stack +24: arg_6 (via 28(A5))
;   stack +47: arg_7 (via 51(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D5/D6/D7
; CALLS:
;   GROUP_AS_JMPTBL_STR_FindCharPtr, LOCAVAIL_ResetFilterStateStruct, LOCAVAIL_CopyFilterStateStructRetainRefs, LOCAVAIL_AllocNodeArraysForState, LOCAVAIL_FreeResourceChain, NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, NEWGRID_JMPTBL_MATH_Mulu32, NEWGRID_JMPTBL_MEMORY_AllocateMemory
; READS:
;   Global_STR_LOCAVAIL_C_6, LOCAVAIL_TAG_FV, WDISP_CharClassTable, MEMF_CLEAR, MEMF_PUBLIC, branch, branch_14, branch_15, branch_16, branch_17, branch_5, e11, lab_0F2E, lab_0F2F, lab_0F31, lab_0F32, lab_0F33
; WRITES:
;   (none observed)
; DESC:
;   Parses filter-state header/tags and node payloads from a serialized buffer,
;   allocating/resetting state arrays as needed and restoring filter resources.
; NOTES:
;   Uses FV-tag gating and per-node numeric parsing via ReadSignedLong helper.
;------------------------------------------------------------------------------
LOCAVAIL_ParseFilterStateFromBuffer:
    LINK.W  A5,#-52
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEQ   #1,D5
    PEA     -24(A5)
    BSR.W   LOCAVAIL_ResetFilterStateStruct

    ADDQ.W  #4,A7
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-24(A5)
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-51(A5)
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   .lab_0F17

    MOVE.B  -51(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .lab_0F18

.lab_0F17:
    MOVE.B  -51(A5),D0
    EXT.W   D0
    EXT.L   D0

.lab_0F18:
    MOVE.B  D0,-51(A5)
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     LOCAVAIL_TAG_FV
    JSR     GROUP_AS_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.W   .lab_0F32

    MOVE.B  -51(A5),D0
    MOVE.B  D0,-18(A5)
    MOVEQ   #0,D7

.lab_0F19:
    MOVEQ   #2,D0
    CMP.L   D0,D7
    BGE.S   .lab_0F1A

    MOVEA.L D7,A0
    ADDQ.L  #1,D7
    MOVE.L  A0,D0
    MOVE.B  (A3)+,-51(A5,D0.L)
    BRA.S   .lab_0F19

.lab_0F1A:
    CLR.B   -51(A5,D7.L)
    PEA     -51(A5)
    JSR     NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    MOVE.L  D0,-22(A5)
    PEA     -24(A5)
    BSR.W   LOCAVAIL_AllocNodeArraysForState

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.W   .lab_0F31

    MOVEQ   #0,D7

.branch:
    TST.L   D5
    BEQ.W   .lab_0F33

    CMP.L   -22(A5),D7
    BGE.W   .lab_0F33

    MOVE.B  (A3)+,D0
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BNE.W   .lab_0F2F

    MOVE.L  D7,D0
    MOVEQ   #10,D1
    JSR     NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEA.L -4(A5),A0
    ADDA.L  D0,A0
    MOVEQ   #0,D6
    MOVE.L  A0,-28(A5)

.lab_0F1C:
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BGE.S   .lab_0F1D

    MOVEA.L D6,A0
    ADDQ.L  #1,D6
    MOVE.L  A0,D0
    MOVE.B  (A3)+,-51(A5,D0.L)
    BRA.S   .lab_0F1C

.lab_0F1D:
    CLR.B   -51(A5,D6.L)
    PEA     -51(A5)
    JSR     NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVEA.L -28(A5),A0
    MOVE.B  D0,(A0)
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.W   .lab_0F2E

    MOVEQ   #100,D1
    CMP.B   D1,D0
    BCC.W   .lab_0F2E

    MOVEQ   #0,D6

.branch_1:
    MOVEQ   #4,D0
    CMP.L   D0,D6
    BGE.S   .branch_2

    MOVEA.L D6,A0
    ADDQ.L  #1,D6
    MOVE.L  A0,D0
    MOVE.B  (A3)+,-51(A5,D0.L)
    BRA.S   .branch_1

.branch_2:
    CLR.B   -51(A5,D6.L)
    PEA     -51(A5)
    JSR     NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVEA.L -28(A5),A0
    MOVE.W  D0,2(A0)
    BLE.W   .branch_16

    CMPI.W  #$e11,D0
    BGE.W   .branch_16

    MOVEQ   #0,D6

.branch_3:
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BGE.S   .branch_4

    MOVEA.L D6,A0
    ADDQ.L  #1,D6
    MOVE.L  A0,D0
    MOVE.B  (A3)+,-51(A5,D0.L)
    BRA.S   .branch_3

.branch_4:
    CLR.B   -51(A5,D6.L)
    PEA     -51(A5)
    JSR     NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVEA.L -28(A5),A0
    MOVE.W  D0,4(A0)
    TST.W   D0
    BLE.W   .branch_15

    MOVEQ   #100,D1
    CMP.W   D1,D0
    BGE.W   .branch_15

    EXT.L   D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     341.W
    PEA     Global_STR_LOCAVAIL_C_6
    JSR     NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L -28(A5),A0
    MOVE.L  D0,6(A0)
    BEQ.W   .branch_14

    MOVEQ   #0,D6

.branch_5:
    TST.L   D5
    BEQ.W   .branch_17

    MOVEA.L -28(A5),A0
    MOVE.W  4(A0),D0
    EXT.L   D0
    CMP.L   D0,D6
    BGE.W   .branch_17

    MOVE.B  (A3)+,D0
    MOVE.B  D0,-51(A5)
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   .branch_6

    MOVE.B  -51(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .branch_7

.branch_6:
    MOVE.B  -51(A5),D0
    EXT.W   D0
    EXT.L   D0

.branch_7:
    MOVEQ   #48,D1
    SUB.L   D1,D0
    BEQ.S   .branch_11

    MOVEQ   #23,D1
    SUB.L   D1,D0
    BEQ.S   .branch_8

    SUBQ.L  #2,D0
    BEQ.S   .branch_10

    SUBQ.L  #3,D0
    BEQ.S   .branch_11

    SUBQ.L  #8,D0
    BEQ.S   .branch_9

    SUBQ.L  #1,D0
    BEQ.S   .branch_11

    SUBQ.L  #1,D0
    BNE.S   .branch_12

    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  #$1,(A0)
    BRA.S   .branch_13

.branch_8:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  #$2,(A0)
    BRA.S   .branch_13

.branch_9:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  #$3,(A0)
    BRA.S   .branch_13

.branch_10:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  #$4,(A0)
    BRA.S   .branch_13

.branch_11:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    CLR.B   (A0)
    BRA.S   .branch_13

.branch_12:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    CLR.B   (A0)
    MOVEQ   #0,D5

.branch_13:
    ADDQ.L  #1,D6
    BRA.W   .branch_5

.branch_14:
    MOVEQ   #0,D5
    BRA.S   .branch_17

.branch_15:
    MOVEQ   #0,D5
    BRA.S   .branch_17

.branch_16:
    MOVEQ   #0,D5
    BRA.S   .branch_17

.lab_0F2E:
    MOVEQ   #0,D5
    BRA.S   .branch_17

.lab_0F2F:
    MOVEQ   #0,D5

.branch_17:
    ADDQ.L  #1,D7
    BRA.W   .branch

.lab_0F31:
    TST.L   -22(A5)
    BEQ.S   .lab_0F33

    MOVEQ   #0,D5
    BRA.S   .lab_0F33

.lab_0F32:
    MOVEQ   #0,D5

.lab_0F33:
    TST.L   D5
    BEQ.S   .branch_18

    MOVE.L  A2,-(A7)
    BSR.W   LOCAVAIL_FreeResourceChain

    PEA     -24(A5)
    MOVE.L  A2,-(A7)
    BSR.W   LOCAVAIL_CopyFilterStateStructRetainRefs

    LEA     12(A7),A7
    BRA.S   LOCAVAIL_ParseFilterStateFromBuffer_Return

.branch_18:
    PEA     -24(A5)
    BSR.W   LOCAVAIL_FreeResourceChain

    ADDQ.W  #4,A7

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_ParseFilterStateFromBuffer_Return   (Return parse success/failure and unwind frame)
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
;   Returns parser success flag (D5) and restores saved registers/frame.
; NOTES:
;   Shared return target for both success and cleanup-failure paths.
;------------------------------------------------------------------------------
LOCAVAIL_ParseFilterStateFromBuffer_Return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_MapFilterTokenCharToClass   (Map token character to filter-class index)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0/D1/D6/D7
; CALLS:
;   (none)
; READS:
;   WDISP_CharClassTable
; WRITES:
;   (none observed)
; DESC:
;   Converts numeric/alphabetic token chars into compact class indices used by
;   filter parsing logic; returns 0 for unsupported characters.
; NOTES:
;   Digits map via `'0'` base; alphabetic classes map via `'7'`-relative base.
;------------------------------------------------------------------------------
LOCAVAIL_MapFilterTokenCharToClass:
    MOVEM.L D6-D7,-(A7)
    MOVE.B  15(A7),D7
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   .class_is_not_digit

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D6
    MOVEQ   #48,D1
    SUB.L   D1,D6
    BRA.S   LOCAVAIL_MapFilterTokenCharToClass_Return

.class_is_not_digit:
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #3,D0
    AND.B   (A1),D0
    TST.B   D0
    BEQ.S   .class_unknown

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   .skip_uppercase_fold

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .class_alpha_ready

.skip_uppercase_fold:
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0

.class_alpha_ready:
    MOVE.L  D0,D6
    MOVEQ   #55,D1
    SUB.L   D1,D6
    BRA.S   LOCAVAIL_MapFilterTokenCharToClass_Return

.class_unknown:
    MOVEQ   #0,D6

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_MapFilterTokenCharToClass_Return   (Return token character class index)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A7/D0/D1/D6/D7
; CALLS:
;   NEWGRID_JMPTBL_MATH_Mulu32
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Returns computed class index from D6.
; NOTES:
;   Class 0 indicates unrecognized token character.
;------------------------------------------------------------------------------
LOCAVAIL_MapFilterTokenCharToClass_Return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.L  20(A7),D7
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BEQ.S   LOCAVAIL_GetNodeDurationByIndex

    TST.L   D7
    BMI.S   LOCAVAIL_GetNodeDurationByIndex

    CMP.L   2(A3),D7
    BGE.S   LOCAVAIL_GetNodeDurationByIndex

    MOVE.L  D7,D0
    MOVEQ   #10,D1
    JSR     NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEA.L 20(A3),A0
    ADDA.L  D0,A0
    MOVE.W  2(A0),D6

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_GetNodeDurationByIndex   (Return node duration by index with bounds checks)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D6
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Returns node duration word (+2) for valid index, else returns 0.
; NOTES:
;   Handles NULL state pointer and out-of-range indices as empty result.
;------------------------------------------------------------------------------
LOCAVAIL_GetNodeDurationByIndex:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_ComputeFilterOffsetForEntry   (Routine at LOCAVAIL_ComputeFilterOffsetForEntry)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +16: arg_3 (via 20(A5))
;   stack +20: arg_4 (via 24(A5))
;   stack +24: arg_5 (via 28(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   GROUP_AS_JMPTBL_STR_FindCharPtr, GROUP_AY_JMPTBL_SCRIPT_ReadCiaBBit5Mask, LOCAVAIL_MapFilterTokenCharToClass, NEWGRID_JMPTBL_MATH_Mulu32
; READS:
;   LOCAVAIL_ComputeFilterOffsetForEntry_Return, ESQIFF_GAdsBrushListCount, ED_DiagGraphModeChar, ED_DiagVinModeChar, LOCAVAIL_FilterStep, LOCAVAIL_FilterPrevClassId, LOCAVAIL_STR_YYLLZ_FilterGateCheck, WDISP_HighlightActive, lab_0F3E, lab_0F43, lab_0F4B
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
LOCAVAIL_ComputeFilterOffsetForEntry:
    LINK.W  A5,#-28
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEQ   #-1,D4
    MOVEQ   #-1,D0
    CLR.L   -28(A5)
    MOVE.L  D0,-20(A5)
    TST.L   LOCAVAIL_FilterStep
    BNE.W   LOCAVAIL_ComputeFilterOffsetForEntry_Return

    CMP.L   LOCAVAIL_FilterPrevClassId,D0
    BNE.W   LOCAVAIL_ComputeFilterOffsetForEntry_Return

    MOVEQ   #0,D7

.lab_0F3E:
    TST.B   (A3)
    BEQ.W   .lab_0F43

    MOVE.B  (A3),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LOCAVAIL_MapFilterTokenCharToClass

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    CLR.L   -24(A5)
    MOVEQ   #0,D6

.lab_0F3F:
    TST.L   D5
    BEQ.S   .lab_0F41

    CMP.L   2(A2),D6
    BGE.S   .lab_0F41

    MOVE.L  D6,D0
    MOVEQ   #10,D1
    JSR     NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEA.L 20(A2),A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVEQ   #0,D1
    MOVE.B  (A0),D1
    CMP.L   D1,D0
    BNE.S   .lab_0F40

    MOVE.L  6(A0),-28(A5)
    MOVE.L  A0,-24(A5)
    BRA.S   .lab_0F41

.lab_0F40:
    ADDQ.L  #1,D6
    BRA.S   .lab_0F3F

.lab_0F41:
    TST.L   D5
    BEQ.S   .lab_0F42

    TST.L   -24(A5)
    BEQ.S   .lab_0F42

    SUBQ.L  #1,D5
    MOVEA.L -24(A5),A0
    MOVE.W  4(A0),D0
    EXT.L   D0
    CMP.L   D0,D5
    BGE.S   .lab_0F42

    MOVEA.L -28(A5),A0
    TST.B   0(A0,D5.L)
    BEQ.S   .lab_0F42

    MOVEQ   #-1,D0
    CMP.L   D0,D4
    BNE.S   .lab_0F43

    CMP.L   -20(A5),D0
    BNE.S   .lab_0F43

    MOVE.L  D6,D4
    MOVE.L  D5,-20(A5)
    BRA.S   .lab_0F43

.lab_0F42:
    ADDQ.L  #1,D7
    ADDQ.L  #1,A3
    BRA.W   .lab_0F3E

.lab_0F43:
    MOVEQ   #-1,D0
    CMP.L   D0,D4
    BEQ.W   .lab_0F4B

    MOVE.L  -20(A5),D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BEQ.W   .lab_0F4B

    MOVE.L  D4,D0
    MOVEQ   #10,D1
    JSR     NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEA.L 20(A2),A0
    ADDA.L  D0,A0
    MOVEA.L 6(A0),A1
    MOVEQ   #0,D0
    MOVE.L  -20(A5),D1
    MOVE.B  0(A1,D1.L),D0
    MOVE.L  A0,-24(A5)
    MOVE.L  A1,-28(A5)
    SUBQ.W  #1,D0
    BEQ.S   .lab_0F44

    SUBQ.W  #1,D0
    BEQ.S   .lab_0F46

    SUBQ.W  #1,D0
    BEQ.S   .lab_0F48

    SUBQ.W  #1,D0
    BEQ.S   .lab_0F49

    BRA.S   .lab_0F4A

.lab_0F44:
    MOVEQ   #0,D0
    MOVE.B  ED_DiagVinModeChar,D0
    MOVE.L  D0,-(A7)
    PEA     LOCAVAIL_STR_YYLLZ_FilterGateCheck
    JSR     GROUP_AS_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .lab_0F45

    JSR     GROUP_AY_JMPTBL_SCRIPT_ReadCiaBBit5Mask(PC)

    TST.B   D0
    BNE.S   .lab_0F4B

.lab_0F45:
    MOVEQ   #-1,D4
    MOVEQ   #-1,D0
    MOVE.L  D0,-20(A5)
    BRA.S   .lab_0F4B

.lab_0F46:
    MOVE.B  ED_DiagGraphModeChar,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BEQ.S   .lab_0F47

    TST.L   ESQIFF_GAdsBrushListCount
    BNE.S   .lab_0F4B

.lab_0F47:
    MOVEQ   #-1,D4
    MOVEQ   #-1,D0
    MOVE.L  D0,-20(A5)
    BRA.S   .lab_0F4B

.lab_0F48:
    TST.W   WDISP_HighlightActive
    BNE.S   .lab_0F4B

    MOVEQ   #-1,D4
    MOVEQ   #-1,D0
    MOVE.L  D0,-20(A5)
    BRA.S   .lab_0F4B

.lab_0F49:
    MOVEQ   #-1,D4
    MOVEQ   #-1,D0
    MOVE.L  D0,-20(A5)
    BRA.S   .lab_0F4B

.lab_0F4A:
    MOVEQ   #-1,D4
    MOVEQ   #-1,D0
    MOVE.L  D0,-20(A5)

.lab_0F4B:
    MOVE.L  D4,8(A2)
    MOVE.L  -20(A5),12(A2)

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_ComputeFilterOffsetForEntry_Return   (Return tail for filter-offset computation)
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
;   Restores saved registers/frame and returns to caller.
; NOTES:
;   Shared exit for early-reject and computed-offset paths.
;------------------------------------------------------------------------------
LOCAVAIL_ComputeFilterOffsetForEntry_Return:
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_SaveAvailabilityDataFile   (Routine at LOCAVAIL_SaveAvailabilityDataFile)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +143: arg_3 (via 147(A5))
;   stack +144: arg_4 (via 148(A5))
;   stack +150: arg_5 (via 154(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer, GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush, GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes, GROUP_AY_JMPTBL_DISKIO_WriteDecimalField, NEWGRID_JMPTBL_MATH_Mulu32
; READS:
;   LOCAVAIL_TAG_UVGTI, LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Save, LOCAVAIL_STR_LA_VER_1_COLON_CURDAY, LOCAVAIL_STR_LA_VER_1_COLON_NXTDAY, MODE_NEWFILE, lab_0F4E, lab_0F4F, lab_0F52, lab_0F54, lab_0F54_0008, lab_0F5A, lab_0F5B
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
LOCAVAIL_SaveAvailabilityDataFile:
    LINK.W  A5,#-160
    MOVEM.L D4-D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEQ   #1,D5
    LEA     LOCAVAIL_TAG_UVGTI,A0
    LEA     -154(A5),A1
    MOVEQ   #5,D0

.lab_0F4E:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,.lab_0F4E
    PEA     MODE_NEWFILE.W
    PEA     LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Save
    JSR     GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D4
    TST.L   D4
    BEQ.W   .lab_0F5B

    MOVE.L  A3,-4(A5)
    LEA     LOCAVAIL_STR_LA_VER_1_COLON_CURDAY,A0
    LEA     -148(A5),A1
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.W  (A0),(A1)

.lab_0F4F:
    LEA     -148(A5),A0
    MOVEA.L A0,A1

.lab_0F50:
    TST.B   (A1)+
    BNE.S   .lab_0F50

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D4,-(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    MOVE.L  D0,(A7)
    MOVE.L  D4,-(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(PC)

    MOVEA.L -4(A5),A0
    MOVE.L  2(A0),(A7)
    MOVE.L  D4,-(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(PC)

    MOVEA.L -4(A5),A0
    MOVE.B  6(A0),D0
    MOVE.B  D0,-148(A5)
    CLR.B   -147(A5)
    LEA     -148(A5),A0
    MOVEA.L A0,A1

.lab_0F51:
    TST.B   (A1)+
    BNE.S   .lab_0F51

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D4,-(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    LEA     28(A7),A7
    MOVEQ   #0,D7

.lab_0F52:
    MOVEA.L -4(A5),A0
    CMP.L   2(A0),D7
    BGE.W   .lab_0F5A

    MOVE.L  D7,D0
    MOVEQ   #10,D1
    JSR     NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEA.L -4(A5),A1
    MOVEA.L 20(A1),A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  A0,-8(A5)
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(PC)

    MOVEA.L -8(A5),A0
    MOVE.W  2(A0),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  D4,-(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(PC)

    MOVEA.L -8(A5),A0
    MOVE.W  4(A0),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  D4,-(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(PC)

    LEA     16(A7),A7
    MOVEQ   #0,D6

.lab_0F53:
    MOVEA.L -8(A5),A0
    MOVE.W  4(A0),D0
    EXT.L   D0
    CMP.L   D0,D6
    BGE.S   .lab_0F58

    MOVEA.L -8(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    CMPI.W  #5,D0
    BCC.S   .lab_0F56

    ADD.W   D0,D0
    MOVE.W  .lab_0F54(PC,D0.W),D0
    JMP     .lab_0F54+2(PC,D0.W)

; switch/jumptable
.lab_0F54:
    DC.W    .lab_0F54_0008-.lab_0F54-2
    DC.W    .lab_0F54_0008-.lab_0F54-2
    DC.W    .lab_0F54_0008-.lab_0F54-2
    DC.W    .lab_0F54_0008-.lab_0F54-2
    DC.W    .lab_0F54_0008-.lab_0F54-2

.lab_0F54_0008:
    LEA     -148(A5),A0
    ADDA.L  D6,A0
    MOVEA.L -8(A5),A6
    MOVEA.L 6(A6),A1
    ADDA.L  D6,A1
    MOVEQ   #0,D0
    MOVE.B  (A1),D0
    LEA     -154(A5),A1
    ADDA.W  D0,A1
    MOVE.B  (A1),(A0)
    BRA.S   .lab_0F57

.lab_0F56:
    LEA     -148(A5),A0
    ADDA.L  D6,A0
    MOVE.B  -154(A5),(A0)

.lab_0F57:
    ADDQ.L  #1,D6
    BRA.S   .lab_0F53

.lab_0F58:
    LEA     -148(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D6,A1
    CLR.B   (A1)
    MOVEA.L A0,A1

.lab_0F59:
    TST.B   (A1)+
    BNE.S   .lab_0F59

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D4,-(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D7
    BRA.W   .lab_0F52

.lab_0F5A:
    MOVE.L  A2,-4(A5)
    SUBA.L  A2,A2
    LEA     LOCAVAIL_STR_LA_VER_1_COLON_NXTDAY,A0
    LEA     -148(A5),A1
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.W  (A0),(A1)
    TST.L   -4(A5)
    BNE.W   .lab_0F4F

    MOVE.L  D4,-(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(PC)

    ADDQ.W  #4,A7
    BRA.S   LOCAVAIL_SaveAvailabilityDataFile_Return

.lab_0F5B:
    MOVEQ   #0,D5

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_SaveAvailabilityDataFile_Return   (Routine at LOCAVAIL_SaveAvailabilityDataFile_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D4
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
LOCAVAIL_SaveAvailabilityDataFile_Return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D4-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_LoadAvailabilityDataFile   (Routine at LOCAVAIL_LoadAvailabilityDataFile)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +14: arg_3 (via 18(A5))
;   stack +18: arg_4 (via 22(A5))
;   stack +20: arg_5 (via 24(A5))
;   stack +24: arg_6 (via 28(A5))
;   stack +40: arg_7 (via 44(A5))
;   stack +44: arg_8 (via 48(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer, GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer, GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer, GROUP_AY_JMPTBL_STRING_CompareNoCaseN, LOCAVAIL_ResetFilterStateStruct, LOCAVAIL_CopyFilterStateStructRetainRefs, LOCAVAIL_AllocNodeArraysForState, LOCAVAIL_FreeResourceChain, NEWGRID_JMPTBL_MATH_Mulu32, NEWGRID_JMPTBL_MEMORY_AllocateMemory, NEWGRID_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   Global_REF_LONG_FILE_SCRATCH, Global_STR_LOCAVAIL_C_7, Global_STR_LOCAVAIL_C_8, LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Load, LOCAVAIL_STR_LA_VER, Global_PTR_WORK_BUFFER, TEXTDISP_SecondaryGroupCode, TEXTDISP_PrimaryGroupCode, MEMF_CLEAR, MEMF_PUBLIC, e11, ffff, lab_0F5E, lab_0F5F, lab_0F60, lab_0F67, lab_0F68, lab_0F69, lab_0F6A, lab_0F6B, lab_0F6C, lab_0F6D, lab_0F6E, lab_0F73, lab_0F74
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
LOCAVAIL_LoadAvailabilityDataFile:
    LINK.W  A5,#-52
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEQ   #1,D5
    CLR.L   -48(A5)
    MOVEQ   #0,D4
    PEA     LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Load
    JSR     GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.W   .lab_0F74

    MOVE.L  A3,-(A7)
    BSR.W   LOCAVAIL_FreeResourceChain

    MOVE.B  TEXTDISP_PrimaryGroupCode,(A3)
    MOVE.L  A2,(A7)
    BSR.W   LOCAVAIL_FreeResourceChain

    MOVE.B  TEXTDISP_SecondaryGroupCode,(A2)
    MOVE.L  Global_REF_LONG_FILE_SCRATCH,D4
    MOVE.L  Global_PTR_WORK_BUFFER,-48(A5)
    JSR     GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer(PC)

    ADDQ.W  #4,A7
    MOVEA.W #$ffff,A0
    MOVE.L  D0,-44(A5)
    CMP.L   A0,D0
    BNE.S   .lab_0F5E

    CLR.L   -44(A5)

.lab_0F5E:
    TST.L   D5
    BEQ.W   .lab_0F73

    TST.L   -44(A5)
    BEQ.W   .lab_0F73

    PEA     6.W
    PEA     LOCAVAIL_STR_LA_VER
    MOVE.L  -44(A5),-(A7)
    JSR     GROUP_AY_JMPTBL_STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.W   .lab_0F73

    PEA     -24(A5)
    BSR.W   LOCAVAIL_ResetFilterStateStruct

    JSR     GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.B  D0,-24(A5)
    JSR     GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.L  D0,-22(A5)
    JSR     GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer(PC)

    MOVEA.L D0,A0
    MOVE.B  (A0),D1
    MOVE.B  D1,-18(A5)
    PEA     -24(A5)
    MOVE.L  D0,-44(A5)
    BSR.W   LOCAVAIL_AllocNodeArraysForState

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.W   .lab_0F6D

    MOVEQ   #0,D7

.lab_0F5F:
    TST.L   D5
    BEQ.W   .lab_0F6E

    CMP.L   -22(A5),D7
    BGE.W   .lab_0F6E

    MOVE.L  D7,D0
    MOVEQ   #10,D1
    JSR     NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEA.L -4(A5),A0
    ADDA.L  D0,A0
    MOVE.L  A0,-28(A5)
    JSR     GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(PC)

    MOVEA.L -28(A5),A0
    MOVE.B  D0,(A0)
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.W   .lab_0F6B

    MOVEQ   #100,D1
    CMP.B   D1,D0
    BCC.W   .lab_0F6B

    JSR     GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(PC)

    MOVEA.L -28(A5),A0
    MOVE.W  D0,2(A0)
    TST.W   D0
    BLE.W   .lab_0F6A

    CMPI.W  #$e11,D0
    BGE.W   .lab_0F6A

    JSR     GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(PC)

    MOVEA.L -28(A5),A0
    MOVE.W  D0,4(A0)
    TST.W   D0
    BLE.W   .lab_0F69

    MOVEQ   #100,D1
    CMP.W   D1,D0
    BGE.W   .lab_0F69

    EXT.L   D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     786.W
    PEA     Global_STR_LOCAVAIL_C_7
    JSR     NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L -28(A5),A0
    MOVE.L  D0,6(A0)
    BEQ.W   .lab_0F68

    JSR     GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-44(A5)
    CMP.L   A0,D0
    BEQ.W   .lab_0F67

    MOVEQ   #0,D6

.lab_0F60:
    TST.L   D5
    BEQ.W   .lab_0F6C

    MOVEA.L -28(A5),A0
    MOVE.W  4(A0),D0
    EXT.L   D0
    CMP.L   D0,D6
    BGE.W   .lab_0F6C

    MOVEA.L -44(A5),A0
    MOVE.B  (A0)+,D0
    EXT.W   D0
    MOVE.L  A0,-44(A5)
    SUBI.W  #$47,D0
    BEQ.S   .lab_0F61

    SUBQ.W  #2,D0
    BEQ.S   .lab_0F63

    SUBI.W  #11,D0
    BEQ.S   .lab_0F62

    SUBQ.W  #1,D0
    BEQ.S   .lab_0F64

    SUBQ.W  #1,D0
    BNE.S   .lab_0F65

    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  #$1,(A0)
    BRA.S   .lab_0F66

.lab_0F61:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  #$2,(A0)
    BRA.S   .lab_0F66

.lab_0F62:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  #$3,(A0)
    BRA.S   .lab_0F66

.lab_0F63:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  #$4,(A0)
    BRA.S   .lab_0F66

.lab_0F64:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    CLR.B   (A0)
    BRA.S   .lab_0F66

.lab_0F65:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    CLR.B   (A0)
    MOVEQ   #0,D5

.lab_0F66:
    ADDQ.L  #1,D6
    BRA.W   .lab_0F60

.lab_0F67:
    MOVEQ   #0,D5
    BRA.S   .lab_0F6C

.lab_0F68:
    MOVEQ   #0,D5
    BRA.S   .lab_0F6C

.lab_0F69:
    MOVEQ   #0,D5
    BRA.S   .lab_0F6C

.lab_0F6A:
    MOVEQ   #0,D5
    BRA.S   .lab_0F6C

.lab_0F6B:
    MOVEQ   #0,D5

.lab_0F6C:
    ADDQ.L  #1,D7
    BRA.W   .lab_0F5F

.lab_0F6D:
    TST.L   -22(A5)
    BEQ.S   .lab_0F6E

    MOVEQ   #0,D5

.lab_0F6E:
    TST.L   D5
    BEQ.S   .lab_0F71

    MOVE.B  -24(A5),D0
    MOVE.B  TEXTDISP_PrimaryGroupCode,D1
    CMP.B   D1,D0
    BNE.S   .lab_0F6F

    PEA     -24(A5)
    MOVE.L  A3,-(A7)
    BSR.W   LOCAVAIL_CopyFilterStateStructRetainRefs

    ADDQ.W  #8,A7
    BRA.S   .lab_0F72

.lab_0F6F:
    MOVE.B  TEXTDISP_SecondaryGroupCode,D1
    CMP.B   D1,D0
    BNE.S   .lab_0F70

    PEA     -24(A5)
    MOVE.L  A2,-(A7)
    BSR.W   LOCAVAIL_CopyFilterStateStructRetainRefs

    ADDQ.W  #8,A7
    BRA.S   .lab_0F72

.lab_0F70:
    PEA     -24(A5)
    BSR.W   LOCAVAIL_FreeResourceChain

    ADDQ.W  #4,A7
    BRA.S   .lab_0F72

.lab_0F71:
    PEA     -24(A5)
    BSR.W   LOCAVAIL_FreeResourceChain

    ADDQ.W  #4,A7

.lab_0F72:
    JSR     GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-44(A5)
    CMP.L   A0,D0
    BNE.W   .lab_0F5E

    CLR.L   -44(A5)
    BRA.W   .lab_0F5E

.lab_0F73:
    MOVE.L  D4,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -48(A5),-(A7)
    PEA     897.W
    PEA     Global_STR_LOCAVAIL_C_8
    JSR     NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    BRA.S   LOCAVAIL_LoadAvailabilityDataFile_Return

.lab_0F74:
    MOVE.B  TEXTDISP_PrimaryGroupCode,D0
    MOVE.B  (A3),D1
    CMP.B   D0,D1
    BEQ.S   .branch

    MOVE.L  A3,-(A7)
    BSR.W   LOCAVAIL_FreeResourceChain

    ADDQ.W  #4,A7
    MOVE.B  TEXTDISP_PrimaryGroupCode,(A3)

.branch:
    MOVE.B  TEXTDISP_SecondaryGroupCode,D0
    MOVE.B  (A2),D1
    CMP.B   D0,D1
    BEQ.S   .branch_1

    MOVE.L  A2,-(A7)
    BSR.W   LOCAVAIL_FreeResourceChain

    ADDQ.W  #4,A7
    MOVE.B  TEXTDISP_SecondaryGroupCode,(A2)

.branch_1:
    MOVEQ   #0,D5

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_LoadAvailabilityDataFile_Return   (Routine at LOCAVAIL_LoadAvailabilityDataFile_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D4
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
LOCAVAIL_LoadAvailabilityDataFile_Return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_GetFilterWindowHalfSpan   (Routine at LOCAVAIL_GetFilterWindowHalfSpan)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   (none)
; READS:
;   LOCAVAIL_FilterModeFlag, LOCAVAIL_FilterWindowHalfSpan
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
LOCAVAIL_GetFilterWindowHalfSpan:
    MOVE.L  D7,-(A7)
    MOVEQ   #1,D0
    CMP.L   LOCAVAIL_FilterModeFlag,D0
    BNE.S   .lab_0F7B

    MOVE.W  LOCAVAIL_FilterWindowHalfSpan,D0
    BLE.S   .lab_0F79

    EXT.L   D0
    BRA.S   .lab_0F7A

.lab_0F79:
    MOVEQ   #30,D0

.lab_0F7A:
    MOVE.L  D0,D7
    BRA.S   .lab_0F7C

.lab_0F7B:
    MOVEQ   #30,D7

.lab_0F7C:
    ASR.W   #1,D7
    ADDQ.W  #1,D7
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS

;!======

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
;   GROUP_AS_JMPTBL_STR_FindCharPtr, GROUP_AY_JMPTBL_SCRIPT_ReadCiaBBit5Mask, LOCAVAIL_ResetFilterCursorState, NEWGRID_JMPTBL_MATH_Mulu32
; READS:
;   LOCAVAIL_UpdateFilterStateMachine_Return, ESQIFF_GAdsBrushListCount, ED_DiagGraphModeChar, ED_DiagVinModeChar, LOCAVAIL_FilterModeFlag, LOCAVAIL_FilterStep, LOCAVAIL_FilterClassId, LOCAVAIL_STR_YYLLZ_FilterStateUpdate, WDISP_HighlightActive, lab_0F7F, lab_0F7F_0008, lab_0F7F_0040, lab_0F7F_0062, lab_0F83, lab_0F84, lab_0F86, lab_0F86_001E, lab_0F86_0066, lab_0F89, lab_0F8C, lab_0F8C_001E, lab_0F8C_0046
; WRITES:
;   LOCAVAIL_FilterStep, LOCAVAIL_FilterClassId, LOCAVAIL_FilterPrevClassId, LOCAVAIL_FilterWindowHalfSpan, LOCAVAIL_FilterCooldownTicks
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
    CMP.L   LOCAVAIL_FilterModeFlag,D0
    BNE.W   LOCAVAIL_UpdateFilterStateMachine_Return

    TST.L   LOCAVAIL_FilterStep
    BNE.W   .lab_0F84

    MOVEQ   #-1,D1
    CMP.L   LOCAVAIL_FilterClassId,D1
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
    JSR     NEWGRID_JMPTBL_MATH_Mulu32(PC)

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
    MOVE.L  D0,LOCAVAIL_FilterClassId
    MOVEQ   #1,D1
    MOVE.L  D1,LOCAVAIL_FilterStep
    MOVEQ   #-1,D1
    MOVE.L  D1,LOCAVAIL_FilterPrevClassId
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
    MOVE.B  ED_DiagVinModeChar,D0
    MOVE.L  D0,-(A7)
    PEA     LOCAVAIL_STR_YYLLZ_FilterStateUpdate
    JSR     GROUP_AS_JMPTBL_STR_FindCharPtr(PC)

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
    BSR.W   LOCAVAIL_ResetFilterCursorState

    ADDQ.W  #4,A7
    BRA.W   LOCAVAIL_UpdateFilterStateMachine_Return

.lab_0F7F_0040:
    MOVE.B  ED_DiagGraphModeChar,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BEQ.S   .lab_0F82

    TST.L   ESQIFF_GAdsBrushListCount
    BNE.W   LOCAVAIL_UpdateFilterStateMachine_Return

.lab_0F82:
    MOVE.L  A2,-(A7)
    BSR.W   LOCAVAIL_ResetFilterCursorState

    ADDQ.W  #4,A7
    BRA.W   LOCAVAIL_UpdateFilterStateMachine_Return

.lab_0F7F_0062:
    TST.W   WDISP_HighlightActive
    BNE.W   LOCAVAIL_UpdateFilterStateMachine_Return

    MOVE.L  A2,-(A7)
    BSR.W   LOCAVAIL_ResetFilterCursorState

    ADDQ.W  #4,A7
    BRA.W   LOCAVAIL_UpdateFilterStateMachine_Return

.lab_0F83:
    MOVE.L  A2,-(A7)
    BSR.W   LOCAVAIL_ResetFilterCursorState

    ADDQ.W  #4,A7
    BRA.W   LOCAVAIL_UpdateFilterStateMachine_Return

.lab_0F84:
    MOVEQ   #1,D0
    CMP.L   LOCAVAIL_FilterStep,D0
    BNE.W   .lab_0F89

    MOVEQ   #-1,D0
    CMP.L   LOCAVAIL_FilterClassId,D0
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
    JSR     NEWGRID_JMPTBL_MATH_Mulu32(PC)

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
    MOVE.W  D1,LOCAVAIL_FilterCooldownTicks
    MOVE.W  2(A0),LOCAVAIL_FilterWindowHalfSpan
    MOVEQ   #-1,D0
    MOVE.L  D0,8(A2)
    MOVE.L  D0,12(A2)
    MOVEQ   #2,D0
    MOVE.L  D0,LOCAVAIL_FilterStep
    MOVE.L  LOCAVAIL_FilterClassId,D0
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
    MOVE.L  LOCAVAIL_FilterStep,D0
    MOVEQ   #2,D1
    CMP.L   D1,D0
    BNE.S   .lab_0F8A

    MOVE.L  LOCAVAIL_FilterClassId,D1
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
    CMP.L   LOCAVAIL_FilterClassId,D0
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
    CMP.L   LOCAVAIL_FilterClassId,D0
    BNE.S   .lab_0F8E

    MOVE.W  #3,24(A3)

.lab_0F8E:
    MOVEQ   #-1,D0
    MOVE.L  D0,LOCAVAIL_FilterClassId
    CLR.L   LOCAVAIL_FilterStep
    MOVE.W  #(-1),LOCAVAIL_FilterWindowHalfSpan
    BRA.S   LOCAVAIL_UpdateFilterStateMachine_Return

.lab_0F8C_0046:
    CLR.L   20(A3)
    BRA.S   LOCAVAIL_UpdateFilterStateMachine_Return

.lab_0F8F:
    MOVE.L  A2,-(A7)
    BSR.W   LOCAVAIL_ResetFilterCursorState

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

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_SyncSecondaryFilterForCurrentGroup   (Routine at LOCAVAIL_SyncSecondaryFilterForCurrentGroup)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1
; CALLS:
;   LOCAVAIL_CopyFilterStateStructRetainRefs, LOCAVAIL_FreeResourceChain
; READS:
;   TEXTDISP_SecondaryGroupCode, TEXTDISP_PrimaryGroupCode, LOCAVAIL_PrimaryFilterState, LOCAVAIL_SecondaryFilterState
; WRITES:
;   LOCAVAIL_SecondaryFilterState
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
LOCAVAIL_SyncSecondaryFilterForCurrentGroup:
    MOVE.B  LOCAVAIL_SecondaryFilterState,D0
    MOVE.B  TEXTDISP_SecondaryGroupCode,D1
    CMP.B   D1,D0
    BEQ.S   .lab_0F92

    MOVE.B  LOCAVAIL_PrimaryFilterState,D0
    MOVE.B  TEXTDISP_PrimaryGroupCode,D1
    CMP.B   D1,D0
    BNE.S   .lab_0F92

    PEA     LOCAVAIL_SecondaryFilterState
    BSR.W   LOCAVAIL_FreeResourceChain

    PEA     LOCAVAIL_PrimaryFilterState
    PEA     LOCAVAIL_SecondaryFilterState
    BSR.W   LOCAVAIL_CopyFilterStateStructRetainRefs

    LEA     12(A7),A7
    MOVE.B  TEXTDISP_SecondaryGroupCode,LOCAVAIL_SecondaryFilterState

.lab_0F92:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_RebuildFilterStateFromCurrentGroup   (Routine at LOCAVAIL_RebuildFilterStateFromCurrentGroup)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0
; CALLS:
;   LOCAVAIL_CopyFilterStateStructRetainRefs, LOCAVAIL_ResetFilterCursorState, LOCAVAIL_FreeResourceChain
; READS:
;   TEXTDISP_PrimaryGroupCode, LOCAVAIL_PrimaryFilterState, LOCAVAIL_SecondaryFilterState
; WRITES:
;   LOCAVAIL_SecondaryFilterState
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
LOCAVAIL_RebuildFilterStateFromCurrentGroup:
    PEA     LOCAVAIL_PrimaryFilterState
    BSR.W   LOCAVAIL_FreeResourceChain

    PEA     LOCAVAIL_SecondaryFilterState
    PEA     LOCAVAIL_PrimaryFilterState
    BSR.W   LOCAVAIL_CopyFilterStateStructRetainRefs

    PEA     LOCAVAIL_SecondaryFilterState
    BSR.W   LOCAVAIL_FreeResourceChain

    LEA     16(A7),A7
    MOVE.B  TEXTDISP_PrimaryGroupCode,D0
    SUBQ.B  #1,D0
    MOVE.B  D0,LOCAVAIL_SecondaryFilterState
    PEA     LOCAVAIL_PrimaryFilterState
    BSR.W   LOCAVAIL_ResetFilterCursorState

    ADDQ.W  #4,A7
    RTS
