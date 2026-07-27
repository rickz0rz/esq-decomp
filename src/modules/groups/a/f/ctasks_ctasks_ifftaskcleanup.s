    XDEF    _CTASKS_IFFTaskCleanup

;------------------------------------------------------------------------------
; FUNC: LAB_0386   (IFF task cleanup / SaveBrushResultuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   D0-D1/A0/A4/A6
; CALLS:
;   _GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult (_GCOMMAND_SaveBrushResult), _LVOForbid, _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
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