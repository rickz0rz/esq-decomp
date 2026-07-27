    XDEF    _CTASKS_CloseTaskTeardown


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