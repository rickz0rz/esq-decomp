    XDEF    CTASKS_CloseTaskTeardown
    XDEF    CTASKS_IFFTaskCleanup
    XDEF    CTASKS_StartCloseTaskProcess
    XDEF    CTASKS_StartIffTaskProcess

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_0386   (IFF task cleanup / SaveBrushResultuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   D0-D1/A0/A4/A6
; CALLS:
;   GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult (GCOMMAND_SaveBrushResult), _LVOForbid, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   CTASKS_IffTaskState (state), CTASKS_PendingLogoBrushDescriptor/CTASKS_PendingGAdsBrushDescriptor/CTASKS_PendingIffBrushDescriptor (scratch ptrs), BRUSH_LoadInProgressFlag
;   Global_REF_LIST_IFF_TASK_PROC, Global_STR_CTASKS_C_1
; WRITES:
;   CTASKS_PendingLogoBrushDescriptor/CTASKS_PendingGAdsBrushDescriptor/CTASKS_PendingIffBrushDescriptor, CTASKS_IffTaskDoneFlag, CTASKS_IffTaskState
; DESC:
;   Waits for brush load to finish, saves brush data, clears the active scratch
;   pointer based on CTASKS_IffTaskState, and frees the IFF task list before marking the task done.
; NOTES:
;   Spins while BRUSH_LoadInProgressFlag is nonzero; uses Forbid during teardown.
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
; FUNC: CTASKS_IFFTaskCleanup   (Routine at CTASKS_IFFTaskCleanup)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A4/A5/A6/A7/D0/D1
; CALLS:
;   GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, _LVOForbid
; READS:
;   AbsExecBase, BRUSH_LoadInProgressFlag, Global_REF_LIST_IFF_TASK_PROC, Global_REF_LONG_FILE_SCRATCH, Global_STR_CTASKS_C_1, CTASKS_PendingLogoBrushDescriptor, CTASKS_PendingGAdsBrushDescriptor, CTASKS_PendingIffBrushDescriptor, CTASKS_IffTaskState
; WRITES:
;   CTASKS_PendingLogoBrushDescriptor, CTASKS_PendingGAdsBrushDescriptor, CTASKS_PendingIffBrushDescriptor, CTASKS_IffTaskDoneFlag, CTASKS_IffTaskState
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
CTASKS_IFFTaskCleanup:
    LINK.W  A5,#-4
    MOVE.L  A4,-(A7)
    LEA     Global_REF_LONG_FILE_SCRATCH,A4
    MOVE.W  CTASKS_IffTaskState,D0                  ; pick scratch buffer based on current state
    SUBQ.W  #4,D0
    BNE.S   .check_state_5

    MOVE.L  CTASKS_PendingLogoBrushDescriptor,-4(A5)
    BRA.S   .wait_for_brush

.check_state_5:
    MOVE.W  CTASKS_IffTaskState,D0
    SUBQ.W  #5,D0
    BNE.S   .check_state_6_or_11

    MOVE.L  CTASKS_PendingGAdsBrushDescriptor,-4(A5)
    BRA.S   .wait_for_brush

.check_state_6_or_11:
    MOVE.W  CTASKS_IffTaskState,D0
    SUBQ.W  #6,D0
    BEQ.S   .state_6_or_11

    MOVE.W  CTASKS_IffTaskState,D0
    MOVEQ   #11,D1
    CMP.W   D1,D0
    BNE.S   .wait_for_brush

.state_6_or_11:
    MOVE.L  CTASKS_PendingIffBrushDescriptor,-4(A5)

.wait_for_brush:
    TST.L   BRUSH_LoadInProgressFlag      ; defer cleanup until brush list mutations finish
    BNE.S   .wait_for_brush

    MOVE.L  -4(A5),-(A7)
    JSR     GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult(PC)

    ADDQ.W  #4,A7
    MOVE.W  CTASKS_IffTaskState,D0
    SUBQ.W  #4,D0
    BNE.S   .clear_state5

    SUBA.L  A0,A0
    MOVE.L  A0,CTASKS_PendingLogoBrushDescriptor
    BRA.S   .finish_reset

.clear_state5:
    MOVE.W  CTASKS_IffTaskState,D0
    SUBQ.W  #5,D0
    BNE.S   .clear_state6

    SUBA.L  A0,A0
    MOVE.L  A0,CTASKS_PendingGAdsBrushDescriptor
    BRA.S   .finish_reset

.clear_state6:
    MOVE.W  CTASKS_IffTaskState,D0
    SUBQ.W  #6,D0
    BNE.S   .finish_reset

    CLR.L   CTASKS_PendingIffBrushDescriptor

.finish_reset:
    MOVEA.L AbsExecBase,A6               ; block task switches during teardown
    JSR     _LVOForbid(A6)

    MOVE.W  #1,CTASKS_IffTaskDoneFlag
    CLR.W   CTASKS_IffTaskState
    PEA     14.W
    MOVE.L  Global_REF_LIST_IFF_TASK_PROC,-(A7)
    PEA     127.W
    PEA     Global_STR_CTASKS_C_1
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEA.L -8(A5),A4
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: CTASKS_StartIffTaskProcess   (Start IFF task process)
; ARGS:
;   (none)
; RET:
;   D0: created task pointer (DATA_WDISP_BSS_LONG_21B7)
; CLOBBERS:
;   D0-D4/A0-A1/A6
; CALLS:
;   _LVOForbid/_LVOPermit, _LVOFindTask, GROUP_AG_JMPTBL_MEMORY_AllocateMemory, _LVOCreateProc
; READS:
;   CTASKS_IffTaskState, ESQIFF_AssetSourceSelect, Global_STR_IFF_TASK_1/2, Global_REF_DOS_LIBRARY_2
; WRITES:
;   CTASKS_IffTaskDoneFlag, CTASKS_IffTaskState, Global_REF_LIST_IFF_TASK_PROC, DATA_WDISP_BSS_LONG_21B6, DATA_WDISP_BSS_LONG_21B7
; DESC:
;   Waits until no existing IFF task is present, sets the startup state,
;   allocates a List struct, installs CTASKS_IFFTaskCleanup as its entry, and spawns the IFF task process.
; NOTES:
;   Selects initial CTASKS_IffTaskState state based on ESQIFF_AssetSourceSelect (4 vs 5 vs 6).
;------------------------------------------------------------------------------
CTASKS_StartIffTaskProcess:
    LINK.W  A5,#-4
    MOVEM.L D2-D4,-(A7)

.wait_for_prior_iff_task:
    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    LEA     Global_STR_IFF_TASK_1,A1
    JSR     _LVOFindTask(A6)

    MOVE.L  D0,-4(A5)                     ; keep result of FindTask
    JSR     _LVOPermit(A6)

    TST.L   -4(A5)
    BNE.S   .wait_for_prior_iff_task      ; spin until task is gone

    MOVEQ   #0,D0
    MOVE.W  D0,CTASKS_IffTaskDoneFlag
    MOVE.W  CTASKS_IffTaskState,D1                  ; seed state if caller already set it to 6
    SUBQ.W  #6,D1
    BEQ.S   .alloc_list_and_spawn

    MOVE.W  ESQIFF_AssetSourceSelect,D1                  ; choose default state (4 vs 5) based on flag
    BEQ.S   .set_state_to_5

    MOVE.W  #4,CTASKS_IffTaskState
    BRA.S   .alloc_list_and_spawn

.set_state_to_5:
    MOVE.W  #5,CTASKS_IffTaskState

.alloc_list_and_spawn:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     (Struct_List_Size).W
    PEA     159.W
    PEA     Global_STR_CTASKS_C_2
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVE.L  D0,Global_REF_LIST_IFF_TASK_PROC
    MOVEQ   #(Struct_List_Size),D1
    MOVEA.L D0,A0
    MOVE.L  D1,(A0)
    LEA     CTASKS_IFFTaskCleanup(PC),A0
    MOVEA.L Global_REF_LIST_IFF_TASK_PROC,A1
    MOVE.L  A0,10(A1)
    MOVE.W  #20217,8(A1)

    MOVEA.L Global_REF_LIST_IFF_TASK_PROC,A0
    ADDQ.L  #4,A0
    MOVE.L  A0,D0
    LSR.L   #2,D0
    MOVE.L  D0,DATA_WDISP_BSS_LONG_21B6
    MOVE.L  D0,D3
    LEA     Global_STR_IFF_TASK_2,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  #8192,D4
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6    ; spawn IFF task process
    JSR     _LVOCreateProc(A6)

    MOVE.L  D0,DATA_WDISP_BSS_LONG_21B7
    MOVEM.L -16(A5),D2-D4
    UNLK    A5
    RTS

;!======

; End the CLOSE_TASK task.
;------------------------------------------------------------------------------
; FUNC: CTASKS_CloseTaskTeardown   (Close task teardown)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D1/A0/A4/A6
; CALLS:
;   _LVOClose, _LVOForbid, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   DATA_CTASKS_BSS_LONG_1B8B (file handle), Global_REF_DOS_LIBRARY_2, Global_REF_LIST_CLOSE_TASK_PROC
; WRITES:
;   DATA_CTASKS_BSS_LONG_1B8B, DATA_CTASKS_CONST_WORD_1B8A
; DESC:
;   Closes the stored file handle (if any), frees the CLOSE_TASK list, and marks the task done.
; NOTES:
;   Uses Forbid during deallocation.
;------------------------------------------------------------------------------
CTASKS_CloseTaskTeardown:
    MOVE.L  A4,-(A7)

    LEA     Global_REF_LONG_FILE_SCRATCH,A4
    TST.L   DATA_CTASKS_BSS_LONG_1B8B
    BEQ.S   .skip_close_handle

    MOVE.L  DATA_CTASKS_BSS_LONG_1B8B,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

    MOVEQ   #0,D0
    MOVE.L  D0,DATA_CTASKS_BSS_LONG_1B8B                  ; clear stored handle

.skip_close_handle:
    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    PEA     14.W
    MOVE.L  Global_REF_LIST_CLOSE_TASK_PROC,-(A7)
    PEA     194.W
    PEA     Global_STR_CTASKS_C_3
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVE.W  #1,DATA_CTASKS_CONST_WORD_1B8A

    MOVEA.L (A7)+,A4
    RTS

;!======

; Start the CLOSE_TASK task
;------------------------------------------------------------------------------
; FUNC: CTASKS_StartCloseTaskProcess   (Start close-task process)
; ARGS:
;   (none observed)
; RET:
;   D0: created task pointer (DATA_WDISP_BSS_LONG_21BA)
; CLOBBERS:
;   D0-D4/D7/A0-A1/A6
; CALLS:
;   GROUP_AG_JMPTBL_MEMORY_AllocateMemory, _LVOCreateProc
; READS:
;   Global_STR_CLOSE_TASK, Global_REF_DOS_LIBRARY_2
; WRITES:
;   DATA_CTASKS_CONST_WORD_1B8A, DATA_CTASKS_BSS_LONG_1B8B, Global_REF_LIST_CLOSE_TASK_PROC, DATA_WDISP_BSS_LONG_21B9, DATA_WDISP_BSS_LONG_21BA
; DESC:
;   Stores the target handle, allocates a List struct, installs CTASKS_CloseTaskTeardown as its entry,
;   and spawns the CLOSE_TASK process.
; NOTES:
;   Clears DATA_CTASKS_CONST_WORD_1B8A before launch.
;------------------------------------------------------------------------------
CTASKS_StartCloseTaskProcess:
    MOVEM.L D2-D4/D7,-(A7)

    SetOffsetForStack 4
    UseStackLong    MOVE.L,1,D7

    CLR.W   DATA_CTASKS_CONST_WORD_1B8A                     ; mark task as running
    MOVE.L  D7,DATA_CTASKS_BSS_LONG_1B8B

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     (Struct_List_Size).W
    PEA     203.W
    PEA     Global_STR_CTASKS_C_4
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7

    MOVE.L  D0,Global_REF_LIST_CLOSE_TASK_PROC
    MOVEQ   #(Struct_List_Size),D1
    MOVEA.L D0,A0
    MOVE.L  D1,(A0)
    LEA     CTASKS_CloseTaskTeardown(PC),A0
    MOVEA.L Global_REF_LIST_CLOSE_TASK_PROC,A1
    MOVE.L  A0,10(A1)
    MOVE.W  #20217,8(A1)
    MOVEA.L Global_REF_LIST_CLOSE_TASK_PROC,A0
    ADDQ.L  #4,A0
    MOVE.L  A0,D0
    LSR.L   #2,D0
    MOVE.L  D0,DATA_WDISP_BSS_LONG_21B9
    MOVE.L  D0,D3

    LEA     Global_STR_CLOSE_TASK,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  #8192,D4
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOCreateProc(A6)

    MOVE.L  D0,DATA_WDISP_BSS_LONG_21BA
    MOVEM.L (A7)+,D2-D4/D7
    RTS

;!======

    ; Alignment
    ALIGN_WORD
