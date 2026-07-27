    XDEF    _DISKIO_CloseBufferedFileAndFlush
    XDEF    DISKIO_CloseBufferedFileAndFlush_Return



;------------------------------------------------------------------------------
; FUNC: _DISKIO_CloseBufferedFileAndFlush   (Routine at _DISKIO_CloseBufferedFileAndFlush)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A6/A7/D0/D1/D2/D3/D6
; CALLS:
;   _CTASKS_StartCloseTaskProcess, _GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning, _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, _LVODelay, _LVOWrite
; READS:
;   _DISKIO_BufferControl, _DISKIO_BufferState, _DISKIO_OpenCount, Global_REF_DOS_LIBRARY_2, _Global_STR_DISKIO_C_2, _CTASKS_CloseTaskCompletionFlag, _Global_UIBusyFlag, Struct_DiskIoBufferControl__BufferBase, Struct_DiskIoBufferState__BufferSize, Struct_DiskIoBufferState__Remaining, Struct_DiskIoBufferState__SavedF45
; WRITES:
;   _DISKIO_BufferControl, _DISKIO_OpenCount, _ESQPARS2_ReadModeFlags, Struct_DiskIoBufferControl__ErrorFlag
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_DISKIO_CloseBufferedFileAndFlush:
    MOVEM.L D2-D3/D6-D7,-(A7)

    SetOffsetForStack 4
    UseStackLong    MOVE.L,1,D7

    JSR     _GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(PC)

    TST.L   D7
    BEQ.S   .lab_039D

    CLR.L   _DISKIO_BufferControl+Struct_DiskIoBufferControl__ErrorFlag
    MOVE.L  _DISKIO_BufferState+Struct_DiskIoBufferState__BufferSize,D0
    SUB.L   _DISKIO_BufferState+Struct_DiskIoBufferState__Remaining,D0
    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   .lab_039B

    MOVE.L  D7,D1
    MOVE.L  D6,D3
    MOVE.L  _DISKIO_BufferControl+Struct_DiskIoBufferControl__BufferBase,D2
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOWrite(A6)

    CMP.L   D3,D0

.lab_039B:
    JSR     _GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(PC)

    MOVE.L  D7,-(A7)
    JSR     _CTASKS_StartCloseTaskProcess(PC)

    ADDQ.W  #4,A7

.branch:
    JSR     _GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(PC)

    MOVEQ   #5,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVODelay(A6)

    JSR     _GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(PC)

    TST.W   _CTASKS_CloseTaskCompletionFlag
    BEQ.S   .branch

    MOVE.L  _DISKIO_BufferState+Struct_DiskIoBufferState__BufferSize,-(A7)
    MOVE.L  _DISKIO_BufferControl+Struct_DiskIoBufferControl__BufferBase,-(A7)
    PEA     353.W
    PEA     _Global_STR_DISKIO_C_2
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    JSR     _GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(PC)

    LEA     16(A7),A7

.lab_039D:
    MOVE.L  _DISKIO_OpenCount,D0
    TST.L   D0
    BLE.S   .branch_1

    SUBQ.L  #1,_DISKIO_OpenCount

.branch_1:
    TST.L   _DISKIO_OpenCount
    BNE.S   DISKIO_CloseBufferedFileAndFlush_Return

    TST.W   _Global_UIBusyFlag
    BNE.S   DISKIO_CloseBufferedFileAndFlush_Return

    MOVE.W  _DISKIO_BufferState+Struct_DiskIoBufferState__SavedF45,_ESQPARS2_ReadModeFlags

;------------------------------------------------------------------------------
; FUNC: DISKIO_CloseBufferedFileAndFlush_Return   (Routine at DISKIO_CloseBufferedFileAndFlush_Return)
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
DISKIO_CloseBufferedFileAndFlush_Return:
    MOVEM.L (A7)+,D2-D3/D6-D7
    RTS

;!======