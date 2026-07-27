    XDEF    _CTASKS_CloseTaskTeardown
    XDEF    _CTASKS_IFFTaskCleanup
    XDEF    _CTASKS_StartCloseTaskProcess
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
;   _GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult (GCOMMAND_SaveBrushResult), _LVOForbid, _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _CTASKS_IffTaskState (state), _CTASKS_PendingLogoBrushDescriptor/_CTASKS_PendingGAdsBrushDescriptor/_CTASKS_PendingIffBrushDescriptor (scratch ptrs), _BRUSH_LoadInProgressFlag
;   _Global_REF_LIST_IFF_TASK_PROC, _Global_STR_CTASKS_C_1
; WRITES:
;   _CTASKS_PendingLogoBrushDescriptor/_CTASKS_PendingGAdsBrushDescriptor/_CTASKS_PendingIffBrushDescriptor, _CTASKS_IffTaskDoneFlag, _CTASKS_IffTaskState
; DESC:
;   Waits for brush load to finish, saves brush data, clears the active scratch
;   pointer based on _CTASKS_IffTaskState, and frees the IFF task list before marking the task done.
; NOTES:
;   Spins while _BRUSH_LoadInProgressFlag is nonzero; uses Forbid during teardown.
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
; FUNC: _CTASKS_IFFTaskCleanup   (Routine at _CTASKS_IFFTaskCleanup)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A4/A5/A6/A7/D0/D1
; CALLS:
;   _GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult, _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, _LVOForbid
; READS:
;   AbsExecBase, _BRUSH_LoadInProgressFlag, _Global_REF_LIST_IFF_TASK_PROC, _Global_REF_LONG_FILE_SCRATCH, _Global_STR_CTASKS_C_1, _CTASKS_PendingLogoBrushDescriptor, _CTASKS_PendingGAdsBrushDescriptor, _CTASKS_PendingIffBrushDescriptor, _CTASKS_IffTaskState
; WRITES:
;   _CTASKS_PendingLogoBrushDescriptor, _CTASKS_PendingGAdsBrushDescriptor, _CTASKS_PendingIffBrushDescriptor, _CTASKS_IffTaskDoneFlag, _CTASKS_IffTaskState
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_CTASKS_IFFTaskCleanup:
    LINK.W  A5,#-4
    MOVE.L  A4,-(A7)
    LEA     _Global_REF_LONG_FILE_SCRATCH,A4
    MOVE.W  _CTASKS_IffTaskState,D0                  ; pick scratch buffer based on current state
    SUBQ.W  #4,D0
    BNE.S   .check_state_5

    MOVE.L  _CTASKS_PendingLogoBrushDescriptor,-4(A5)
    BRA.S   .wait_for_brush

.check_state_5:
    MOVE.W  _CTASKS_IffTaskState,D0
    SUBQ.W  #5,D0
    BNE.S   .check_state_6_or_11

    MOVE.L  _CTASKS_PendingGAdsBrushDescriptor,-4(A5)
    BRA.S   .wait_for_brush

.check_state_6_or_11:
    MOVE.W  _CTASKS_IffTaskState,D0
    SUBQ.W  #6,D0
    BEQ.S   .state_6_or_11

    MOVE.W  _CTASKS_IffTaskState,D0
    MOVEQ   #11,D1
    CMP.W   D1,D0
    BNE.S   .wait_for_brush

.state_6_or_11:
    MOVE.L  _CTASKS_PendingIffBrushDescriptor,-4(A5)

.wait_for_brush:
    TST.L   _BRUSH_LoadInProgressFlag      ; defer cleanup until brush list mutations finish
    BNE.S   .wait_for_brush

    MOVE.L  -4(A5),-(A7)
    JSR     _GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult(PC)

    ADDQ.W  #4,A7
    MOVE.W  _CTASKS_IffTaskState,D0
    SUBQ.W  #4,D0
    BNE.S   .clear_state5

    SUBA.L  A0,A0
    MOVE.L  A0,_CTASKS_PendingLogoBrushDescriptor
    BRA.S   .finish_reset

.clear_state5:
    MOVE.W  _CTASKS_IffTaskState,D0
    SUBQ.W  #5,D0
    BNE.S   .clear_state6

    SUBA.L  A0,A0
    MOVE.L  A0,_CTASKS_PendingGAdsBrushDescriptor
    BRA.S   .finish_reset

.clear_state6:
    MOVE.W  _CTASKS_IffTaskState,D0
    SUBQ.W  #6,D0
    BNE.S   .finish_reset

    CLR.L   _CTASKS_PendingIffBrushDescriptor

.finish_reset:
    MOVEA.L AbsExecBase,A6               ; block task switches during teardown
    JSR     _LVOForbid(A6)

    MOVE.W  #1,_CTASKS_IffTaskDoneFlag
    CLR.W   _CTASKS_IffTaskState
    PEA     14.W
    MOVE.L  _Global_REF_LIST_IFF_TASK_PROC,-(A7)
    PEA     127.W
    PEA     _Global_STR_CTASKS_C_1
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEA.L -8(A5),A4
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: CTASKS_StartIffTaskProcess   (Start IFF task process)
; ARGS:
;   (none)
; RET:
;   D0: created task pointer (_CTASKS_IffTaskProcPtr)
; CLOBBERS:
;   D0-D4/A0-A1/A6
; CALLS:
;   _LVOForbid/_LVOPermit, _LVOFindTask, _GROUP_AG_JMPTBL_MEMORY_AllocateMemory, _LVOCreateProc
; READS:
;   _CTASKS_IffTaskState, _ESQIFF_AssetSourceSelect, _Global_STR_IFF_TASK_1/2, Global_REF_DOS_LIBRARY_2
; WRITES:
;   _CTASKS_IffTaskDoneFlag, _CTASKS_IffTaskState, _Global_REF_LIST_IFF_TASK_PROC, _CTASKS_IffTaskSegListBPTR, _CTASKS_IffTaskProcPtr
; DESC:
;   Waits until no existing IFF task is present, sets the startup state,
;   allocates a List struct, installs _CTASKS_IFFTaskCleanup as its entry, and spawns the IFF task process.
; NOTES:
;   Selects initial _CTASKS_IffTaskState state based on _ESQIFF_AssetSourceSelect (4 vs 5 vs 6).
;------------------------------------------------------------------------------
CTASKS_StartIffTaskProcess:
    LINK.W  A5,#-4
    MOVEM.L D2-D4,-(A7)

.wait_for_prior_iff_task:
    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    LEA     _Global_STR_IFF_TASK_1,A1
    JSR     _LVOFindTask(A6)

    MOVE.L  D0,-4(A5)                     ; keep result of FindTask
    JSR     _LVOPermit(A6)

    TST.L   -4(A5)
    BNE.S   .wait_for_prior_iff_task      ; spin until task is gone

    MOVEQ   #0,D0
    MOVE.W  D0,_CTASKS_IffTaskDoneFlag
    MOVE.W  _CTASKS_IffTaskState,D1                  ; seed state if caller already set it to 6
    SUBQ.W  #6,D1
    BEQ.S   .alloc_list_and_spawn

    MOVE.W  _ESQIFF_AssetSourceSelect,D1                  ; choose default state (4 vs 5) based on flag
    BEQ.S   .set_state_to_5

    MOVE.W  #4,_CTASKS_IffTaskState
    BRA.S   .alloc_list_and_spawn

.set_state_to_5:
    MOVE.W  #5,_CTASKS_IffTaskState

.alloc_list_and_spawn:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     (Struct_List_Size).W
    PEA     159.W
    PEA     _Global_STR_CTASKS_C_2
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVE.L  D0,_Global_REF_LIST_IFF_TASK_PROC
    MOVEQ   #(Struct_List_Size),D1
    MOVEA.L D0,A0
    MOVE.L  D1,(A0)
    LEA     _CTASKS_IFFTaskCleanup(PC),A0
    MOVEA.L _Global_REF_LIST_IFF_TASK_PROC,A1
    MOVE.L  A0,10(A1)
    MOVE.W  #20217,8(A1)

    MOVEA.L _Global_REF_LIST_IFF_TASK_PROC,A0
    ADDQ.L  #4,A0
    MOVE.L  A0,D0
    LSR.L   #2,D0
    MOVE.L  D0,_CTASKS_IffTaskSegListBPTR
    MOVE.L  D0,D3
    LEA     _Global_STR_IFF_TASK_2,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  #8192,D4
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6    ; spawn IFF task process
    JSR     _LVOCreateProc(A6)

    MOVE.L  D0,_CTASKS_IffTaskProcPtr
    MOVEM.L -16(A5),D2-D4
    UNLK    A5
    RTS

;!======

; End the CLOSE_TASK task.
;------------------------------------------------------------------------------
; FUNC: _CTASKS_CloseTaskTeardown   (Close task teardown)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D1/A0/A4/A6
; CALLS:
;   _LVOClose, _LVOForbid, _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _CTASKS_CloseTaskFileHandle (file handle), Global_REF_DOS_LIBRARY_2, _Global_REF_LIST_CLOSE_TASK_PROC
; WRITES:
;   _CTASKS_CloseTaskFileHandle, _CTASKS_CloseTaskCompletionFlag
; DESC:
;   Closes the stored file handle (if any), frees the CLOSE_TASK list, and marks the task done.
; NOTES:
;   Uses Forbid during deallocation.
;------------------------------------------------------------------------------
_CTASKS_CloseTaskTeardown:
    MOVE.L  A4,-(A7)

    LEA     _Global_REF_LONG_FILE_SCRATCH,A4
    TST.L   _CTASKS_CloseTaskFileHandle
    BEQ.S   .skip_close_handle

    MOVE.L  _CTASKS_CloseTaskFileHandle,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

    MOVEQ   #0,D0
    MOVE.L  D0,_CTASKS_CloseTaskFileHandle                  ; clear stored handle

.skip_close_handle:
    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    PEA     14.W
    MOVE.L  _Global_REF_LIST_CLOSE_TASK_PROC,-(A7)
    PEA     194.W
    PEA     _Global_STR_CTASKS_C_3
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVE.W  #1,_CTASKS_CloseTaskCompletionFlag

    MOVEA.L (A7)+,A4
    RTS

;!======

; Start the CLOSE_TASK task
;------------------------------------------------------------------------------
; FUNC: _CTASKS_StartCloseTaskProcess   (Start close-task process)
; ARGS:
;   (none observed)
; RET:
;   D0: created task pointer (_CTASKS_CloseTaskProcPtr)
; CLOBBERS:
;   D0-D4/D7/A0-A1/A6
; CALLS:
;   _GROUP_AG_JMPTBL_MEMORY_AllocateMemory, _LVOCreateProc
; READS:
;   _Global_STR_CLOSE_TASK, Global_REF_DOS_LIBRARY_2
; WRITES:
;   _CTASKS_CloseTaskCompletionFlag, _CTASKS_CloseTaskFileHandle, _Global_REF_LIST_CLOSE_TASK_PROC, _CTASKS_CloseTaskSegListBPTR, _CTASKS_CloseTaskProcPtr
; DESC:
;   Stores the target handle, allocates a List struct, installs _CTASKS_CloseTaskTeardown as its entry,
;   and spawns the CLOSE_TASK process.
; NOTES:
;   Clears _CTASKS_CloseTaskCompletionFlag before launch.
;------------------------------------------------------------------------------
_CTASKS_StartCloseTaskProcess:
    MOVEM.L D2-D4/D7,-(A7)

    SetOffsetForStack 4
    UseStackLong    MOVE.L,1,D7

    CLR.W   _CTASKS_CloseTaskCompletionFlag                     ; mark task as running
    MOVE.L  D7,_CTASKS_CloseTaskFileHandle

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     (Struct_List_Size).W
    PEA     203.W
    PEA     _Global_STR_CTASKS_C_4
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7

    MOVE.L  D0,_Global_REF_LIST_CLOSE_TASK_PROC
    MOVEQ   #(Struct_List_Size),D1
    MOVEA.L D0,A0
    MOVE.L  D1,(A0)
    LEA     _CTASKS_CloseTaskTeardown(PC),A0
    MOVEA.L _Global_REF_LIST_CLOSE_TASK_PROC,A1
    MOVE.L  A0,10(A1)
    MOVE.W  #20217,8(A1)
    MOVEA.L _Global_REF_LIST_CLOSE_TASK_PROC,A0
    ADDQ.L  #4,A0
    MOVE.L  A0,D0
    LSR.L   #2,D0
    MOVE.L  D0,_CTASKS_CloseTaskSegListBPTR
    MOVE.L  D0,D3

    LEA     _Global_STR_CLOSE_TASK,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  #8192,D4
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOCreateProc(A6)

    MOVE.L  D0,_CTASKS_CloseTaskProcPtr
    MOVEM.L (A7)+,D2-D4/D7
    RTS

;!======

    ; Alignment
    ALIGN_WORD
