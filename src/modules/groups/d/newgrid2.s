;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_ProcessGridState   (Process grid state machine)
; ARGS:
;   stack +8: A3 = grid struct
;   stack +12: A2 = entry struct
;   stack +16: D7 = key/index
; RET:
;   D0: current state (LAB_203D)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID2_JMP_TBL_LAB_058D, LAB_130C, LAB_107F, GROUPD_JMP_TBL_MEMORY_AllocateMemory,
;   NEWGRID2_JMP_TBL_LAB_05AC, LAB_12D0, NEWGRID2_JMP_TBL_LAB_059F,
;   GROUPD_JMP_TBL_MEMORY_DeallocateMemory, LAB_12FD, NEWGRID2_JMP_TBL_LAB_05AE
; READS:
;   LAB_203D, LAB_2016
; WRITES:
;   LAB_203D, 32(A3)
; DESC:
;   Executes a state machine to render/update the grid, allocate buffers, and
;   advance to the next UI state.
; NOTES:
;   Uses LAB_203D to track state 4/5 transitions.
;------------------------------------------------------------------------------
NEWGRID2_ProcessGridState:
LAB_1311:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7
    SUBA.L  A0,A0
    MOVE.L  A0,-6(A5)
    MOVE.L  A3,D0
    BNE.S   .state_check

    MOVEQ   #4,D0
    MOVE.L  D0,LAB_203D
    BRA.W   .return_state

.state_check:
    MOVE.L  LAB_203D,D0
    SUBQ.L  #4,D0
    BEQ.S   .state_4

    SUBQ.L  #1,D0
    BEQ.W   .state_5

    BRA.W   .force_state_4

.state_4:
    TST.L   (A2)
    BEQ.W   .return_state

    TST.L   4(A2)
    BEQ.W   .return_state

    PEA     1.W
    PEA     20.W
    PEA     612.W
    JSR     NEWGRID2_JMP_TBL_LAB_058D(PC)

    LEA     12(A7),A7
    MOVE.W  20(A2),D6
    MOVEQ   #48,D0
    CMP.W   D0,D6
    BLE.S   .ascii_ok

    SUBI.W  #$30,D6

.ascii_ok:
    TST.W   LAB_2016
    BEQ.S   .draw_alt

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  (A2),-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_130C

    ADDQ.W  #8,A7
    TST.W   D0
    BNE.S   .draw_alt

    LEA     60(A3),A0
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     3.W
    MOVEQ   #1,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  4(A2),-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_107F

    LEA     28(A7),A7
    BRA.S   .allocate_buffer

.draw_alt:
    LEA     60(A3),A0
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEQ   #3,D1
    MOVE.L  D1,-(A7)
    PEA     1.W
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  4(A2),-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_107F

    LEA     28(A7),A7

.allocate_buffer:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     2000.W
    PEA     3947.W
    PEA     GLOB_STR_NEWGRID2_C_1
    JSR     GROUPD_JMP_TBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-6(A5)
    BEQ.S   .post_alloc

    PEA     3.W
    JSR     NEWGRID2_JMP_TBL_LAB_05AC(PC)

    MOVE.L  D7,(A7)
    MOVE.L  -6(A5),-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_12D0

    LEA     60(A3),A0
    MOVE.L  -6(A5),(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMP_TBL_LAB_059F(PC)

    PEA     2000.W
    MOVE.L  -6(A5),-(A7)
    PEA     3953.W
    PEA     GLOB_STR_NEWGRID2_C_2
    JSR     GROUPD_JMP_TBL_MEMORY_DeallocateMemory(PC)

    LEA     36(A7),A7

.post_alloc:
    MOVE.L  A3,-(A7)
    BSR.W   LAB_12FD

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .set_state_5

    MOVEQ   #4,D0
    BRA.S   .store_state

.set_state_5:
    MOVEQ   #5,D0

.store_state:
    PEA     2.W
    MOVE.L  D0,LAB_203D
    JSR     NEWGRID2_JMP_TBL_LAB_05AE(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,32(A3)
    BRA.S   .return_state

.state_5:
    MOVE.L  A3,-(A7)
    BSR.W   LAB_12FD

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .state5_set

    MOVEQ   #4,D0
    BRA.S   .state5_store

.state5_set:
    MOVEQ   #5,D0

.state5_store:
    MOVEQ   #-1,D1
    MOVE.L  D1,32(A3)
    MOVE.L  D0,LAB_203D
    BRA.S   .return_state

.force_state_4:
    MOVEQ   #4,D0
    MOVE.L  D0,LAB_203D

.return_state:
    MOVE.L  LAB_203D,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_HandleGridState   (Handle grid state transitions)
; ARGS:
;   stack +8: A3 = grid struct
;   stack +12: D7 = row index
;   stack +16: D6 = data pointer
; RET:
;   D0: state (LAB_2041)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID2_ProcessGridState, LAB_12B4, LAB_12BB
; READS:
;   LAB_2041
; WRITES:
;   LAB_2041
; DESC:
;   State machine wrapper around NEWGRID2_ProcessGridState with jump table dispatch.
; NOTES:
;   Uses LAB_2041 as a 0..5 state index.
;------------------------------------------------------------------------------
NEWGRID2_HandleGridState:
LAB_131F:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVE.L  28(A7),D6
    MOVEQ   #0,D5
    MOVE.L  A3,D0
    BNE.S   .dispatch_state

    MOVEQ   #5,D0
    CMP.L   LAB_2041,D0
    BNE.S   .reset_state

    MOVE.L  D6,-(A7)
    PEA     LAB_2332
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID2_ProcessGridState

    LEA     12(A7),A7

.reset_state:
    MOVEQ   #0,D0
    MOVE.L  D0,LAB_2041
    BRA.W   .return_state

.dispatch_state:
    MOVE.L  LAB_2041,D0
    CMPI.L  #$6,D0
    BCC.W   .done

    ADD.W   D0,D0
    MOVE.W  .state_jumptable(PC,D0.W),D0
    JMP     .state_jumptable+2(PC,D0.W)

; switch/jumptable
.state_jumptable:
    DC.W    .case_state0-.state_jumptable-2
    DC.W    .case_state1-.state_jumptable-2
    DC.W    .case_state2-.state_jumptable-2
    DC.W    .case_state3-.state_jumptable-2
    DC.W    .case_state3-.state_jumptable-2
    DC.W    .case_state5-.state_jumptable-2

.case_state0:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_2332
    BSR.W   LAB_12B4

    LEA     12(A7),A7

.case_state1:
    MOVE.L  D6,-(A7)
    PEA     LAB_2332
    MOVE.L  LAB_2041,-(A7)
    BSR.W   LAB_12BB

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .case_state1_no_data

    MOVE.L  D6,-(A7)
    MOVE.L  LAB_2332,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_12EF

    LEA     12(A7),A7
    MOVEQ   #0,D0
    MOVEQ   #3,D1
    MOVE.L  D1,LAB_2041
    MOVE.L  D0,LAB_2040
    BRA.W   .return_state

.case_state1_no_data:
    CLR.L   LAB_2041
    BRA.W   .return_state

.case_state3:
    MOVE.L  D6,-(A7)
    PEA     LAB_2332
    MOVE.L  LAB_2041,-(A7)
    BSR.W   LAB_12BB

    MOVE.L  D6,(A7)
    BSR.W   LAB_129F

    LEA     12(A7),A7
    MOVE.L  D0,D5

.case_state5:
    TST.L   LAB_2332
    BEQ.S   .case_state5_no_data

    MOVE.L  D6,-(A7)
    PEA     LAB_2332
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID2_ProcessGridState

    MOVE.L  D6,(A7)
    MOVE.L  D0,LAB_2041
    BSR.W   LAB_129F

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .return_state

    TST.L   D5
    BEQ.S   .case_state5_skip_hint

    CMPI.L  #$1,LAB_2040
    BGE.S   .case_state5_skip_hint

    PEA     50.W
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1038

    BSR.W   LAB_106E

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_2040

.case_state5_skip_hint:
    MOVE.L  A3,-(A7)
    BSR.W   LAB_106B

    ADDQ.W  #4,A7
    SUB.L   D0,LAB_2040
    BRA.S   .return_state

.case_state5_no_data:
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_2041
    BRA.S   .return_state

.case_state2:
.done:
    CLR.L   LAB_2041

.return_state:
    TST.L   LAB_2041
    BNE.S   .skip_reset

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    BSR.W   LAB_12AB

    ADDQ.W  #8,A7

.skip_reset:
    MOVE.L  LAB_2041,D0
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_DispatchGridOperation   (Dispatch grid operation)
; ARGS:
;   stack +8: D7 = operation index ?? (0 uses saved index)
;   stack +12: A3 = grid struct ??
;   stack +16: D6 = row index ?? 
;   stack +20: D5 = column index ??
; RET:
;   D0: boolean (-1/0) success flag
; CLOBBERS:
;   D0-D7/A3
; CALLS:
;   NEWGRID2_HandleGridState, LAB_1149, LAB_11AD, LAB_1168, LAB_11DF, LAB_128A
; READS:
;   LAB_1E86, LAB_2042
; WRITES:
;   LAB_2014, LAB_2042, LAB_2043
; DESC:
;   Dispatches a grid operation by index using a switch/jumptable.
; NOTES:
;   Booleanizes the return value via SNE/NEG/EXT.
;------------------------------------------------------------------------------
NEWGRID2_DispatchGridOperation:
LAB_132A:
    MOVEM.L D5-D7/A3,-(A7)
    MOVE.L  20(A7),D7
    MOVEA.L 24(A7),A3
    MOVE.W  30(A7),D6
    MOVE.W  34(A7),D5
    TST.L   D7
    BNE.S   .store_pending_index

    SUBA.L  A3,A3
    MOVE.L  LAB_2042,D7
    CLR.L   LAB_2042
    BRA.S   .prepare_index

.store_pending_index:
    MOVE.L  D7,LAB_2042

.prepare_index:
    TST.W   LAB_1E86
    BEQ.S   .after_reset_check

    CLR.W   LAB_1E86
    SUBA.L  A3,A3

.after_reset_check:
    MOVE.L  D7,LAB_2014
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    BLT.W   .out_of_range

    CMPI.L  #$7,D0
    BGE.W   .out_of_range

    ADD.W   D0,D0
    MOVE.W  .operation_jumptable(PC,D0.W),D0
    JMP     .operation_jumptable+2(PC,D0.W)

; switch/jumptable
.operation_jumptable:
    DC.W    .case_op1-.operation_jumptable-2
    DC.W    .case_op2-.operation_jumptable-2
    DC.W    .case_op3-.operation_jumptable-2
    DC.W    .case_op4-.operation_jumptable-2
    DC.W    .case_op5-.operation_jumptable-2
    DC.W    .case_op6-.operation_jumptable-2
    DC.W    .case_op7-.operation_jumptable-2

.case_op1:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1149

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_2043
    BRA.W   .return_bool

.case_op2:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_11AD

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2043
    BRA.W   .return_bool

.case_op3:
    MOVE.L  D6,D0
    EXT.L   D0
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID2_HandleGridState

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2043
    BRA.S   .return_bool

.case_op4:
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID2_HandleGridState

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2043
    BRA.S   .return_bool

.case_op5:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1168

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_2043
    BRA.S   .return_bool

.case_op6:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_11DF

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2043
    BRA.S   .return_bool

.case_op7:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_128A

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2043
    BRA.S   .return_bool

.out_of_range:
    CLR.L   LAB_2014

.return_bool:
    TST.L   LAB_2043
    ; booleanize to 0/-1
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_DispatchOperationDefault   (Dispatch default grid operation)
; ARGS:
;   none
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A3
; CALLS:
;   NEWGRID2_DispatchGridOperation
; DESC:
;   Dispatches the grid operation with zeroed inputs.
;------------------------------------------------------------------------------
NEWGRID2_DispatchOperationDefault:
LAB_1332:
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    BSR.W   NEWGRID2_DispatchGridOperation

    LEA     16(A7),A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_EnsureBuffersAllocated   (Allocate grid buffers on demand)
; ARGS:
;   none
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/A0-A1
; CALLS:
;   GROUPD_JMP_TBL_MEMORY_AllocateMemory, LAB_1070
; READS:
;   LAB_2044
; WRITES:
;   LAB_2013, LAB_2335, LAB_2044
; DESC:
;   Allocates the grid backing buffers when the request flag is set.
;------------------------------------------------------------------------------
NEWGRID2_EnsureBuffersAllocated:
LAB_1333:
    TST.L   LAB_2044
    BEQ.S   .done

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     1208.W
    PEA     4153.W
    PEA     GLOB_STR_NEWGRID2_C_3
    JSR     GROUPD_JMP_TBL_MEMORY_AllocateMemory(PC)

    MOVE.L  D0,LAB_2013
    BSR.W   LAB_1070

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    PEA     1000.W
    PEA     4156.W
    PEA     GLOB_STR_NEWGRID2_C_4
    JSR     GROUPD_JMP_TBL_MEMORY_AllocateMemory(PC)

    LEA     28(A7),A7
    CLR.L   LAB_2044
    MOVE.L  D0,LAB_2335

.done:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_FreeBuffersIfAllocated   (Free grid buffers)
; ARGS:
;   none
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/A0-A1
; CALLS:
;   GROUPD_JMP_TBL_MEMORY_DeallocateMemory
; READS:
;   LAB_2335, LAB_2013
; WRITES:
;   LAB_2335, LAB_2013
; DESC:
;   Frees any allocated grid buffers and clears stored pointers.
;------------------------------------------------------------------------------
NEWGRID2_FreeBuffersIfAllocated:
LAB_1335:
    TST.L   LAB_2335
    BEQ.S   .done

    PEA     1000.W
    MOVE.L  LAB_2335,-(A7)
    PEA     4164.W
    PEA     GLOB_STR_NEWGRID2_C_5
    JSR     GROUPD_JMP_TBL_MEMORY_DeallocateMemory(PC)

    CLR.L   LAB_2335
    PEA     1208.W
    MOVE.L  LAB_2013,-(A7)
    PEA     4167.W
    PEA     GLOB_STR_NEWGRID2_C_6
    JSR     GROUPD_JMP_TBL_MEMORY_DeallocateMemory(PC)

    LEA     32(A7),A7
    CLR.L   LAB_2013

.done:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_0347   (Jump stub)
; ARGS:
;   ?? (see LAB_0347)
; RET:
;   ?? (see LAB_0347)
; CLOBBERS:
;   ?? (see LAB_0347)
; CALLS:
;   LAB_0347
; DESC:
;   Jump table entry that forwards to LAB_0347.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_0347:
LAB_1337:
    JMP     LAB_0347

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_05AC   (Jump stub)
; ARGS:
;   ?? (see LAB_05AC)
; RET:
;   ?? (see LAB_05AC)
; CLOBBERS:
;   ?? (see LAB_05AC)
; CALLS:
;   LAB_05AC
; DESC:
;   Jump table entry that forwards to LAB_05AC.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_05AC:
LAB_1338:
    JMP     LAB_05AC

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_059F   (Jump stub)
; ARGS:
;   ?? (see LAB_059F)
; RET:
;   ?? (see LAB_059F)
; CLOBBERS:
;   ?? (see LAB_059F)
; CALLS:
;   LAB_059F
; DESC:
;   Jump table entry that forwards to LAB_059F.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_059F:
LAB_1339:
    JMP     LAB_059F

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_05B5   (Jump stub)
; ARGS:
;   ?? (see LAB_05B5)
; RET:
;   ?? (see LAB_05B5)
; CLOBBERS:
;   ?? (see LAB_05B5)
; CALLS:
;   LAB_05B5
; DESC:
;   Jump table entry that forwards to LAB_05B5.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_05B5:
LAB_133A:
    JMP     LAB_05B5

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_17E6   (Jump stub)
; ARGS:
;   ?? (see LAB_17E6)
; RET:
;   ?? (see LAB_17E6)
; CLOBBERS:
;   ?? (see LAB_17E6)
; CALLS:
;   LAB_17E6
; DESC:
;   Jump table entry that forwards to LAB_17E6.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_17E6:
LAB_133B:
    JMP     LAB_17E6

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_05AA   (Jump stub)
; ARGS:
;   ?? (see LAB_05AA)
; RET:
;   ?? (see LAB_05AA)
; CLOBBERS:
;   ?? (see LAB_05AA)
; CALLS:
;   LAB_05AA
; DESC:
;   Jump table entry that forwards to LAB_05AA.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_05AA:
LAB_133C:
    JMP     LAB_05AA

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_BEVEL_DrawBevelFrameWithTopRight   (Jump stub)
; ARGS:
;   ?? (see BEVEL_DrawBevelFrameWithTopRight)
; RET:
;   ?? (see BEVEL_DrawBevelFrameWithTopRight)
; CLOBBERS:
;   ?? (see BEVEL_DrawBevelFrameWithTopRight)
; CALLS:
;   BEVEL_DrawBevelFrameWithTopRight
; DESC:
;   Jump table entry that forwards to BEVEL_DrawBevelFrameWithTopRight.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_BEVEL_DrawBevelFrameWithTopRight:
LAB_133D:
    JMP     BEVEL_DrawBevelFrameWithTopRight

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_0926   (Jump stub)
; ARGS:
;   ?? (see LAB_0926)
; RET:
;   ?? (see LAB_0926)
; CLOBBERS:
;   ?? (see LAB_0926)
; CALLS:
;   LAB_0926
; DESC:
;   Jump table entry that forwards to LAB_0926.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_0926:
LAB_133E:
    JMP     LAB_0926

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_BEVEL_DrawVerticalBevel   (Jump stub)
; ARGS:
;   ?? (see BEVEL_DrawVerticalBevel)
; RET:
;   ?? (see BEVEL_DrawVerticalBevel)
; CLOBBERS:
;   ?? (see BEVEL_DrawVerticalBevel)
; CALLS:
;   BEVEL_DrawVerticalBevel
; DESC:
;   Jump table entry that forwards to BEVEL_DrawVerticalBevel.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_BEVEL_DrawVerticalBevel:
LAB_133F:
    JMP     BEVEL_DrawVerticalBevel

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_0597   (Jump stub)
; ARGS:
;   ?? (see LAB_0597)
; RET:
;   ?? (see LAB_0597)
; CLOBBERS:
;   ?? (see LAB_0597)
; CALLS:
;   LAB_0597
; DESC:
;   Jump table entry that forwards to LAB_0597.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_0597:
LAB_1340:
    JMP     LAB_0597

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_CLEANUP_UpdateEntryFlagBytes   (Jump stub)
; ARGS:
;   ?? (see CLEANUP_UpdateEntryFlagBytes)
; RET:
;   ?? (see CLEANUP_UpdateEntryFlagBytes)
; CLOBBERS:
;   ?? (see CLEANUP_UpdateEntryFlagBytes)
; CALLS:
;   CLEANUP_UpdateEntryFlagBytes
; DESC:
;   Jump table entry that forwards to CLEANUP_UpdateEntryFlagBytes.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_CLEANUP_UpdateEntryFlagBytes:
LAB_1341:
    JMP     CLEANUP_UpdateEntryFlagBytes

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_0358   (Jump stub)
; ARGS:
;   ?? (see LAB_0358)
; RET:
;   ?? (see LAB_0358)
; CLOBBERS:
;   ?? (see LAB_0358)
; CALLS:
;   LAB_0358
; DESC:
;   Jump table entry that forwards to LAB_0358.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_0358:
LAB_1342:
    JMP     LAB_0358

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_091F   (Jump stub)
; ARGS:
;   ?? (see LAB_091F)
; RET:
;   ?? (see LAB_091F)
; CLOBBERS:
;   ?? (see LAB_091F)
; CALLS:
;   LAB_091F
; DESC:
;   Jump table entry that forwards to LAB_091F.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_091F:
LAB_1343:
    JMP     LAB_091F

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_05AE   (Jump stub)
; ARGS:
;   ?? (see LAB_05AE)
; RET:
;   ?? (see LAB_05AE)
; CLOBBERS:
;   ?? (see LAB_05AE)
; CALLS:
;   LAB_05AE
; DESC:
;   Jump table entry that forwards to LAB_05AE.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_05AE:
LAB_1344:
    JMP     LAB_05AE

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_0923   (Jump stub)
; ARGS:
;   ?? (see LAB_0923)
; RET:
;   ?? (see LAB_0923)
; CLOBBERS:
;   ?? (see LAB_0923)
; CALLS:
;   LAB_0923
; DESC:
;   Jump table entry that forwards to LAB_0923.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_0923:
LAB_1345:
    JMP     LAB_0923

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_05BC   (Jump stub)
; ARGS:
;   ?? (see LAB_05BC)
; RET:
;   ?? (see LAB_05BC)
; CLOBBERS:
;   ?? (see LAB_05BC)
; CALLS:
;   LAB_05BC
; DESC:
;   Jump table entry that forwards to LAB_05BC.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_05BC:
LAB_1346:
    JMP     LAB_05BC

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_036C   (Jump stub)
; ARGS:
;   ?? (see LAB_036C)
; RET:
;   ?? (see LAB_036C)
; CLOBBERS:
;   ?? (see LAB_036C)
; CALLS:
;   LAB_036C
; DESC:
;   Jump table entry that forwards to LAB_036C.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_036C:
LAB_1347:
    JMP     LAB_036C

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_CLEANUP_FormatClockFormatEntry   (Jump stub)
; ARGS:
;   ?? (see CLEANUP_FormatClockFormatEntry)
; RET:
;   ?? (see CLEANUP_FormatClockFormatEntry)
; CLOBBERS:
;   ?? (see CLEANUP_FormatClockFormatEntry)
; CALLS:
;   CLEANUP_FormatClockFormatEntry
; DESC:
;   Jump table entry that forwards to CLEANUP_FormatClockFormatEntry.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_CLEANUP_FormatClockFormatEntry:
LAB_1348:
    JMP     CLEANUP_FormatClockFormatEntry

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_BEVEL_DrawBevelFrameWithTop   (Jump stub)
; ARGS:
;   ?? (see BEVEL_DrawBevelFrameWithTop)
; RET:
;   ?? (see BEVEL_DrawBevelFrameWithTop)
; CLOBBERS:
;   ?? (see BEVEL_DrawBevelFrameWithTop)
; CALLS:
;   BEVEL_DrawBevelFrameWithTop
; DESC:
;   Jump table entry that forwards to BEVEL_DrawBevelFrameWithTop.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_BEVEL_DrawBevelFrameWithTop:
LAB_1349:
    JMP     BEVEL_DrawBevelFrameWithTop

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_ESQ_GetHalfHourSlotIndex   (Jump stub)
; ARGS:
;   ?? (see ESQ_GetHalfHourSlotIndex)
; RET:
;   ?? (see ESQ_GetHalfHourSlotIndex)
; CLOBBERS:
;   ?? (see ESQ_GetHalfHourSlotIndex)
; CALLS:
;   ESQ_GetHalfHourSlotIndex
; DESC:
;   Jump table entry that forwards to ESQ_GetHalfHourSlotIndex.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_ESQ_GetHalfHourSlotIndex:
LAB_134A:
    JMP     ESQ_GetHalfHourSlotIndex

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_1985   (Jump stub)
; ARGS:
;   ?? (see LAB_1985)
; RET:
;   ?? (see LAB_1985)
; CLOBBERS:
;   ?? (see LAB_1985)
; CALLS:
;   LAB_1985
; DESC:
;   Jump table entry that forwards to LAB_1985.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_1985:
LAB_134B:
    JMP     LAB_1985

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_1962   (Jump stub)
; ARGS:
;   ?? (see LAB_1962)
; RET:
;   ?? (see LAB_1962)
; CLOBBERS:
;   ?? (see LAB_1962)
; CALLS:
;   LAB_1962
; DESC:
;   Jump table entry that forwards to LAB_1962.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_1962:
LAB_134C:
    JMP     LAB_1962

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_08DF   (Jump stub)
; ARGS:
;   ?? (see LAB_08DF)
; RET:
;   ?? (see LAB_08DF)
; CLOBBERS:
;   ?? (see LAB_08DF)
; CALLS:
;   LAB_08DF
; DESC:
;   Jump table entry that forwards to LAB_08DF.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_08DF:
LAB_134D:
    JMP     LAB_08DF

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_1A23   (Jump stub)
; ARGS:
;   ?? (see LAB_1A23)
; RET:
;   ?? (see LAB_1A23)
; CLOBBERS:
;   ?? (see LAB_1A23)
; CALLS:
;   LAB_1A23
; DESC:
;   Jump table entry that forwards to LAB_1A23.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_1A23:
LAB_134E:
    JMP     LAB_1A23

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_CLEANUP_TestEntryFlagYAndBit1   (Jump stub)
; ARGS:
;   ?? (see CLEANUP_TestEntryFlagYAndBit1)
; RET:
;   ?? (see CLEANUP_TestEntryFlagYAndBit1)
; CLOBBERS:
;   ?? (see CLEANUP_TestEntryFlagYAndBit1)
; CALLS:
;   CLEANUP_TestEntryFlagYAndBit1
; DESC:
;   Jump table entry that forwards to CLEANUP_TestEntryFlagYAndBit1.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_CLEANUP_TestEntryFlagYAndBit1:
LAB_134F:
    JMP     CLEANUP_TestEntryFlagYAndBit1

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_05BA   (Jump stub)
; ARGS:
;   ?? (see LAB_05BA)
; RET:
;   ?? (see LAB_05BA)
; CLOBBERS:
;   ?? (see LAB_05BA)
; CALLS:
;   LAB_05BA
; DESC:
;   Jump table entry that forwards to LAB_05BA.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_05BA:
LAB_1350:
    JMP     LAB_05BA

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_05B9   (Jump stub)
; ARGS:
;   ?? (see LAB_05B9)
; RET:
;   ?? (see LAB_05B9)
; CLOBBERS:
;   ?? (see LAB_05B9)
; CALLS:
;   LAB_05B9
; DESC:
;   Jump table entry that forwards to LAB_05B9.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_05B9:
LAB_1351:
    JMP     LAB_05B9

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_BEVEL_DrawBeveledFrame   (Jump stub)
; ARGS:
;   ?? (see BEVEL_DrawBeveledFrame)
; RET:
;   ?? (see BEVEL_DrawBeveledFrame)
; CLOBBERS:
;   ?? (see BEVEL_DrawBeveledFrame)
; CALLS:
;   BEVEL_DrawBeveledFrame
; DESC:
;   Jump table entry that forwards to BEVEL_DrawBeveledFrame.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_BEVEL_DrawBeveledFrame:
LAB_1352:
    JMP     BEVEL_DrawBeveledFrame

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_054C   (Jump stub)
; ARGS:
;   ?? (see LAB_054C)
; RET:
;   ?? (see LAB_054C)
; CLOBBERS:
;   ?? (see LAB_054C)
; CALLS:
;   LAB_054C
; DESC:
;   Jump table entry that forwards to LAB_054C.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_054C:
LAB_1353:
    JMP     LAB_054C

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_0592   (Jump stub)
; ARGS:
;   ?? (see LAB_0592)
; RET:
;   ?? (see LAB_0592)
; CLOBBERS:
;   ?? (see LAB_0592)
; CALLS:
;   LAB_0592
; DESC:
;   Jump table entry that forwards to LAB_0592.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_0592:
LAB_1354:
    JMP     LAB_0592

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_ESQ_TestBit1Based   (Jump stub)
; ARGS:
;   ?? (see ESQ_TestBit1Based)
; RET:
;   ?? (see ESQ_TestBit1Based)
; CLOBBERS:
;   ?? (see ESQ_TestBit1Based)
; CALLS:
;   ESQ_TestBit1Based
; DESC:
;   Jump table entry that forwards to ESQ_TestBit1Based.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_ESQ_TestBit1Based:
LAB_1355:
    JMP     ESQ_TestBit1Based

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_BEVEL_DrawVerticalBevelPair   (Jump stub)
; ARGS:
;   ?? (see BEVEL_DrawVerticalBevelPair)
; RET:
;   ?? (see BEVEL_DrawVerticalBevelPair)
; CLOBBERS:
;   ?? (see BEVEL_DrawVerticalBevelPair)
; CALLS:
;   BEVEL_DrawVerticalBevelPair
; DESC:
;   Jump table entry that forwards to BEVEL_DrawVerticalBevelPair.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_BEVEL_DrawVerticalBevelPair:
LAB_1356:
    JMP     BEVEL_DrawVerticalBevelPair

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_05BB   (Jump stub)
; ARGS:
;   ?? (see LAB_05BB)
; RET:
;   ?? (see LAB_05BB)
; CLOBBERS:
;   ?? (see LAB_05BB)
; CALLS:
;   LAB_05BB
; DESC:
;   Jump table entry that forwards to LAB_05BB.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_05BB:
LAB_1357:
    JMP     LAB_05BB

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_058D   (Jump stub)
; ARGS:
;   ?? (see LAB_058D)
; RET:
;   ?? (see LAB_058D)
; CLOBBERS:
;   ?? (see LAB_058D)
; CALLS:
;   LAB_058D
; DESC:
;   Jump table entry that forwards to LAB_058D.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_058D:
LAB_1358:
    JMP     LAB_058D

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_LAB_05B6   (Jump stub)
; ARGS:
;   ?? (see LAB_05B6)
; RET:
;   ?? (see LAB_05B6)
; CLOBBERS:
;   ?? (see LAB_05B6)
; CALLS:
;   LAB_05B6
; DESC:
;   Jump table entry that forwards to LAB_05B6.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_LAB_05B6:
LAB_1359:
    JMP     LAB_05B6

;------------------------------------------------------------------------------
; FUNC: NEWGRID2_JMP_TBL_BEVEL_DrawHorizontalBevel   (Jump stub)
; ARGS:
;   ?? (see BEVEL_DrawHorizontalBevel)
; RET:
;   ?? (see BEVEL_DrawHorizontalBevel)
; CLOBBERS:
;   ?? (see BEVEL_DrawHorizontalBevel)
; CALLS:
;   BEVEL_DrawHorizontalBevel
; DESC:
;   Jump table entry that forwards to BEVEL_DrawHorizontalBevel.
;------------------------------------------------------------------------------
NEWGRID2_JMP_TBL_BEVEL_DrawHorizontalBevel:
LAB_135A:
    JMP     BEVEL_DrawHorizontalBevel

    RTS

;!======

    ; Alignment
    ALIGN_WORD
