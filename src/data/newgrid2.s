; ========== NEWGRID2.c ==========

Global_STR_NEWGRID2_C_1:
    NStr    "NEWGRID2.c"
Global_STR_NEWGRID2_C_2:
    NStr    "NEWGRID2.c"
;------------------------------------------------------------------------------
; SYM: NEWGRID2_CachedModeIndex   (cached mode index)
; TYPE: s32
; PURPOSE: Caches baseline mode/index value for delta-based NEWGRID2 state updates.
; USED BY: NEWGRID2_ProcessGridState
; NOTES: Initialized on first pass then adjusted by computed offsets.
;------------------------------------------------------------------------------
NEWGRID2_CachedModeIndex:
    DC.L    0
;------------------------------------------------------------------------------
; SYM: NEWGRID2_DispatchStateIndex   (newgrid2 dispatch state index)
; TYPE: s32
; PURPOSE: Tracks current NEWGRID2 state-machine index for dispatch/update routines.
; USED BY: NEWGRID2_*
; NOTES: Operates as a bounded 0..5 state index in NEWGRID2 control flow.
;------------------------------------------------------------------------------
NEWGRID2_DispatchStateIndex:
    DC.L    0
;------------------------------------------------------------------------------
; SYM: NEWGRID2_PendingOperationId/NEWGRID2_LastDispatchResult   (dispatch staging/result)
; TYPE: s32/s32
; PURPOSE: Stages pending operation IDs and records most recent dispatch result.
; USED BY: NEWGRID2_DispatchGridOperation
; NOTES:
;   PendingOperationId is reused when dispatch receives operation 0.
;   LastDispatchResult is booleanized before return.
;------------------------------------------------------------------------------
NEWGRID2_PendingOperationId:
    DC.L    0
NEWGRID2_LastDispatchResult:
    DC.L    0
;------------------------------------------------------------------------------
; SYM: NEWGRID2_BufferAllocationFlag   (buffer allocation gate)
; TYPE: s32 flag
; PURPOSE: Prevents repeat allocations once NEWGRID2 buffers are initialized.
; USED BY: NEWGRID2_EnsureBuffersAllocated
; NOTES: Cleared when buffers are released/deinitialized.
;------------------------------------------------------------------------------
NEWGRID2_BufferAllocationFlag:
    DC.L    1
Global_STR_NEWGRID2_C_3:
    NStr    "NEWGRID2.c"
Global_STR_NEWGRID2_C_4:
    NStr    "NEWGRID2.c"
Global_STR_NEWGRID2_C_5:
    NStr    "NEWGRID2.c"
Global_STR_NEWGRID2_C_6:
    NStr    "NEWGRID2.c"
;------------------------------------------------------------------------------
; SYM: NEWGRID2_ErrorLogEntryPtr   (error log entry pointer)
; TYPE: pointer
; PURPOSE: Points to active NEWGRID2/parse error-log entry text buffer.
; USED BY: PARSEINI3 logging helpers
; NOTES: Updated by logging paths that prepend NEWGRID2 source tags.
;------------------------------------------------------------------------------
NEWGRID2_ErrorLogEntryPtr:
    DC.L    0
