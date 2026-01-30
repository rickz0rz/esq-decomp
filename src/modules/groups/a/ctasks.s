;!======
;------------------------------------------------------------------------------
; FUNC: CTASKS_IFFTaskCleanup   (IFF task cleanup / SaveBrushResult??)
; ARGS:
;   (none)
; RET:
;   D0: ?? (passes through from JMP_TBL_DEALLOCATE_MEMORY_1?)
; CLOBBERS:
;   D0-D1/A0/A4/A6
; CALLS:
;   LAB_0395 (GCOMMAND_SaveBrushResult), _LVOForbid, JMP_TBL_DEALLOCATE_MEMORY_1
; READS:
;   LAB_1B84 (state), LAB_1B20/LAB_1B21/LAB_1B24 (scratch ptrs), BRUSH_LoadInProgressFlag
;   GLOB_REF_LIST_IFF_TASK_PROC, GLOB_STR_CTASKS_C_1
; WRITES:
;   LAB_1B20/LAB_1B21/LAB_1B24, LAB_1B83, LAB_1B84
; DESC:
;   Waits for brush load to finish, saves brush data, clears the active scratch
;   pointer based on LAB_1B84, and frees the IFF task list before marking the task done.
; NOTES:
;   Spins while BRUSH_LoadInProgressFlag is nonzero; uses Forbid during teardown.
;------------------------------------------------------------------------------
CTASKS_IFFTaskCleanup:
LAB_0386:
    LINK.W  A5,#-4
    MOVE.L  A4,-(A7)
    LEA     GLOB_REF_LONG_FILE_SCRATCH,A4
    MOVE.W  LAB_1B84,D0                  ; pick scratch buffer based on current state
    SUBQ.W  #4,D0
    BNE.S   .check_state_5

    MOVE.L  LAB_1B20,-4(A5)
    BRA.S   .wait_for_brush

.check_state_5:
    MOVE.W  LAB_1B84,D0
    SUBQ.W  #5,D0
    BNE.S   .check_state_6_or_11

    MOVE.L  LAB_1B21,-4(A5)
    BRA.S   .wait_for_brush

.check_state_6_or_11:
    MOVE.W  LAB_1B84,D0
    SUBQ.W  #6,D0
    BEQ.S   .state_6_or_11

    MOVE.W  LAB_1B84,D0
    MOVEQ   #11,D1
    CMP.W   D1,D0
    BNE.S   .wait_for_brush

.state_6_or_11:
    MOVE.L  LAB_1B24,-4(A5)

.wait_for_brush:
    TST.L   BRUSH_LoadInProgressFlag      ; defer cleanup until brush list mutations finish
    BNE.S   .wait_for_brush

    MOVE.L  -4(A5),-(A7)
    JSR     LAB_0395(PC)

    ADDQ.W  #4,A7
    MOVE.W  LAB_1B84,D0
    SUBQ.W  #4,D0
    BNE.S   .clear_state5

    SUBA.L  A0,A0
    MOVE.L  A0,LAB_1B20
    BRA.S   .finish_reset

.clear_state5:
    MOVE.W  LAB_1B84,D0
    SUBQ.W  #5,D0
    BNE.S   .clear_state6

    SUBA.L  A0,A0
    MOVE.L  A0,LAB_1B21
    BRA.S   .finish_reset

.clear_state6:
    MOVE.W  LAB_1B84,D0
    SUBQ.W  #6,D0
    BNE.S   .finish_reset

    CLR.L   LAB_1B24

.finish_reset:
    MOVEA.L AbsExecBase,A6               ; block task switches during teardown
    JSR     _LVOForbid(A6)

    MOVE.W  #1,LAB_1B83
    CLR.W   LAB_1B84
    PEA     14.W
    MOVE.L  GLOB_REF_LIST_IFF_TASK_PROC,-(A7)
    PEA     127.W
    PEA     GLOB_STR_CTASKS_C_1
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    MOVEA.L -8(A5),A4
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: CTASKS_StartIffTaskProcess   (Start IFF task process)
; ARGS:
;   (none)
; RET:
;   D0: created task pointer (LAB_21B7)
; CLOBBERS:
;   D0-D4/A0-A1/A6
; CALLS:
;   _LVOForbid/_LVOPermit, _LVOFindTask, JMP_TBL_ALLOCATE_MEMORY_1, _LVOCreateProc
; READS:
;   LAB_1B84, LAB_22C0, GLOB_STR_IFF_TASK_1/2, GLOB_REF_DOS_LIBRARY_2
; WRITES:
;   LAB_1B83, LAB_1B84, GLOB_REF_LIST_IFF_TASK_PROC, LAB_21B6, LAB_21B7
; DESC:
;   Waits until no existing IFF task is present, sets the startup state,
;   allocates a List struct, installs LAB_0386 as its entry, and spawns the IFF task process.
; NOTES:
;   Selects initial LAB_1B84 state based on LAB_22C0 (4 vs 5 vs 6).
;------------------------------------------------------------------------------
CTASKS_StartIffTaskProcess:
LAB_038E:
    LINK.W  A5,#-4
    MOVEM.L D2-D4,-(A7)

.wait_for_prior_iff_task:
    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    LEA     GLOB_STR_IFF_TASK_1,A1
    JSR     _LVOFindTask(A6)

    MOVE.L  D0,-4(A5)                     ; keep result of FindTask
    JSR     _LVOPermit(A6)

    TST.L   -4(A5)
    BNE.S   .wait_for_prior_iff_task      ; spin until task is gone

    MOVEQ   #0,D0
    MOVE.W  D0,LAB_1B83
    MOVE.W  LAB_1B84,D1                  ; seed state if caller already set it to 6
    SUBQ.W  #6,D1
    BEQ.S   .alloc_list_and_spawn

    MOVE.W  LAB_22C0,D1                  ; choose default state (4 vs 5) based on flag
    BEQ.S   .set_state_to_5

    MOVE.W  #4,LAB_1B84
    BRA.S   .alloc_list_and_spawn

.set_state_to_5:
    MOVE.W  #5,LAB_1B84

.alloc_list_and_spawn:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     (Struct_List_Size).W
    PEA     159.W
    PEA     GLOB_STR_CTASKS_C_2
    JSR     JMP_TBL_ALLOCATE_MEMORY_1(PC)

    MOVE.L  D0,GLOB_REF_LIST_IFF_TASK_PROC
    MOVEQ   #(Struct_List_Size),D1
    MOVEA.L D0,A0
    MOVE.L  D1,(A0)
    LEA     LAB_0386(PC),A0
    MOVEA.L GLOB_REF_LIST_IFF_TASK_PROC,A1
    MOVE.L  A0,10(A1)
    MOVE.W  #20217,8(A1)

    MOVEA.L GLOB_REF_LIST_IFF_TASK_PROC,A0
    ADDQ.L  #4,A0
    MOVE.L  A0,D0
    LSR.L   #2,D0
    MOVE.L  D0,LAB_21B6
    MOVE.L  D0,D3
    LEA     GLOB_STR_IFF_TASK_2,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  #8192,D4
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6    ; spawn IFF task process
    JSR     _LVOCreateProc(A6)

    MOVE.L  D0,LAB_21B7
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
;   D0: ??
; CLOBBERS:
;   D0-D1/A0/A4/A6
; CALLS:
;   _LVOClose, _LVOForbid, JMP_TBL_DEALLOCATE_MEMORY_1
; READS:
;   LAB_1B8B (file handle), GLOB_REF_DOS_LIBRARY_2, GLOB_REF_LIST_CLOSE_TASK_PROC
; WRITES:
;   LAB_1B8B, LAB_1B8A
; DESC:
;   Closes the stored file handle (if any), frees the CLOSE_TASK list, and marks the task done.
; NOTES:
;   Uses Forbid during deallocation.
;------------------------------------------------------------------------------
CTASKS_CloseTaskTeardown:
LAB_0392:
    MOVE.L  A4,-(A7)

    LEA     GLOB_REF_LONG_FILE_SCRATCH,A4
    TST.L   LAB_1B8B
    BEQ.S   .skip_close_handle

    MOVE.L  LAB_1B8B,D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

    MOVEQ   #0,D0
    MOVE.L  D0,LAB_1B8B                  ; clear stored handle

.skip_close_handle:
    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    PEA     14.W
    MOVE.L  GLOB_REF_LIST_CLOSE_TASK_PROC,-(A7)
    PEA     194.W
    PEA     GLOB_STR_CTASKS_C_3
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7
    MOVE.W  #1,LAB_1B8A

    MOVEA.L (A7)+,A4
    RTS

;!======

; Start the CLOSE_TASK task
;------------------------------------------------------------------------------
; FUNC: CTASKS_StartCloseTaskProcess   (Start close-task process)
; ARGS:
;   stack +8: D7 = file handle to close??
; RET:
;   D0: created task pointer (LAB_21BA)
; CLOBBERS:
;   D0-D4/D7/A0-A1/A6
; CALLS:
;   JMP_TBL_ALLOCATE_MEMORY_1, _LVOCreateProc
; READS:
;   GLOB_STR_CLOSE_TASK, GLOB_REF_DOS_LIBRARY_2
; WRITES:
;   LAB_1B8A, LAB_1B8B, GLOB_REF_LIST_CLOSE_TASK_PROC, LAB_21B9, LAB_21BA
; DESC:
;   Stores the target handle, allocates a List struct, installs LAB_0392 as its entry,
;   and spawns the CLOSE_TASK process.
; NOTES:
;   Clears LAB_1B8A before launch.
;------------------------------------------------------------------------------
CTASKS_StartCloseTaskProcess:
LAB_0394:
    MOVEM.L D2-D4/D7,-(A7)

    SetOffsetForStack 4
    UseStackLong    MOVE.L,1,D7

    CLR.W   LAB_1B8A                     ; mark task as running
    MOVE.L  D7,LAB_1B8B

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     (Struct_List_Size).W
    PEA     203.W
    PEA     GLOB_STR_CTASKS_C_4
    JSR     JMP_TBL_ALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7

    MOVE.L  D0,GLOB_REF_LIST_CLOSE_TASK_PROC
    MOVEQ   #(Struct_List_Size),D1
    MOVEA.L D0,A0
    MOVE.L  D1,(A0)
    LEA     LAB_0392(PC),A0
    MOVEA.L GLOB_REF_LIST_CLOSE_TASK_PROC,A1
    MOVE.L  A0,10(A1)
    MOVE.W  #20217,8(A1)
    MOVEA.L GLOB_REF_LIST_CLOSE_TASK_PROC,A0
    ADDQ.L  #4,A0
    MOVE.L  A0,D0
    LSR.L   #2,D0
    MOVE.L  D0,LAB_21B9
    MOVE.L  D0,D3

    LEA     GLOB_STR_CLOSE_TASK,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  #8192,D4
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOCreateProc(A6)

    MOVE.L  D0,LAB_21BA
    MOVEM.L (A7)+,D2-D4/D7
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======
;------------------------------------------------------------------------------
; FUNC: CTASKS_JMP_TBL_SaveBrushResult   (JumpStub_GCOMMAND_SaveBrushResult)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   GCOMMAND_SaveBrushResult
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Jump stub to GCOMMAND_SaveBrushResult.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
CTASKS_JMP_TBL_SaveBrushResult:
LAB_0395:
    JMP     GCOMMAND_SaveBrushResult

    MOVEQ   #97,D0
    RTS

;!======

    ; Alignment
    ALIGN_WORD
