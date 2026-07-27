    XDEF    _CTASKS_StartCloseTaskProcess


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