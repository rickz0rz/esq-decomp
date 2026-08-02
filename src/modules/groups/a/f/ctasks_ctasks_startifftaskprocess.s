    XDEF    _CTASKS_StartIffTaskProcess

;------------------------------------------------------------------------------
; FUNC: _CTASKS_StartIffTaskProcess   (Start IFF task process)
; ARGS:
;   (none)
; RET:
;   D0: created task pointer (_CTASKS_IffTaskProcPtr)
; CLOBBERS:
;   D0-D4/A0-A1/A6
; CALLS:
;   _LVOForbid/_LVOPermit, _LVOFindTask, _GROUP_AG_JMPTBL_MEMORY_AllocateMemory, _LVOCreateProc
; READS:
;   _CTASKS_IffTaskState, _ESQIFF_AssetSourceSelect, _Global_STR_IFF_TASK_1/2, _Global_REF_DOS_LIBRARY_2
; WRITES:
;   _CTASKS_IffTaskDoneFlag, _CTASKS_IffTaskState, _Global_REF_LIST_IFF_TASK_PROC, _CTASKS_IffTaskSegListBPTR, _CTASKS_IffTaskProcPtr
; DESC:
;   Waits until no existing IFF task is present, sets the startup state,
;   allocates a List struct, installs _CTASKS_IFFTaskCleanup as its entry, and spawns the IFF task process.
; NOTES:
;   Selects initial _CTASKS_IffTaskState state based on _ESQIFF_AssetSourceSelect (4 vs 5 vs 6).
;------------------------------------------------------------------------------
_CTASKS_StartIffTaskProcess:
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
    MOVEA.L _Global_REF_DOS_LIBRARY_2,A6    ; spawn IFF task process
    JSR     _LVOCreateProc(A6)

    MOVE.L  D0,_CTASKS_IffTaskProcPtr
    MOVEM.L -16(A5),D2-D4
    UNLK    A5
    RTS

;!======