    XDEF    _DISKIO_OpenFileWithBuffer


;------------------------------------------------------------------------------
; FUNC: _DISKIO_OpenFileWithBuffer   (Open file and initialize I/O bufferuncertain)
; ARGS:
;   stack +16: filePathPtr (A3)
;   stack +20: accessMode (D7)
; RET:
;   D0: file handle or 0 on failure
; CLOBBERS:
;   D0/D6-D7/A3
; CALLS:
;   _GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning, DOS_OpenFileWithMode, _MEMORY_AllocateMemory
; READS:
;   _DISKIO_OpenCount, _ESQPARS2_ReadModeFlags, _DISKIO_BufferState+Struct_DiskIoBufferState__BufferSize
; WRITES:
;   _DISKIO_BufferControl+Struct_DiskIoBufferControl__BufferBase, _DISKIO_BufferControl+Struct_DiskIoBufferControl__ErrorFlag, _DISKIO_OpenCount, _ESQPARS2_ReadModeFlags, _DISKIO_BufferState+Struct_DiskIoBufferState__BufferPtr, _DISKIO_BufferState+Struct_DiskIoBufferState__Remaining, _DISKIO_BufferState+Struct_DiskIoBufferState__SavedF45
; DESC:
;   Opens a file and allocates a global buffer used by disk I/O helpers.
; NOTES:
;   Early-exits if _DISKIO_OpenCount is non-zero (already active). On first open, saves
;   _ESQPARS2_ReadModeFlags into _DISKIO_BufferState+Struct_DiskIoBufferState__SavedF45 and forces _ESQPARS2_ReadModeFlags = $0100. Buffer size is _DISKIO_BufferState+Struct_DiskIoBufferState__BufferSize.
;------------------------------------------------------------------------------
_DISKIO_OpenFileWithBuffer:
    MOVEM.L D6-D7/A3,-(A7)

    SetOffsetForStack 3
    UseStackLong    MOVEA.L,1,A3
    UseStackLong    MOVE.L,2,D7

    MOVEQ   #0,D6
    JSR     _GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(PC)

    TST.L   _DISKIO_OpenCount
    BNE.S   .return

    CLR.L   _DISKIO_BufferControl+Struct_DiskIoBufferControl__ErrorFlag
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    JSR     _GROUP_AG_JMPTBL_DOS_OpenFileWithMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   .lab_0398

    TST.L   _DISKIO_OpenCount
    BNE.S   .lab_0397

    MOVE.W  _ESQPARS2_ReadModeFlags,_DISKIO_BufferState+Struct_DiskIoBufferState__SavedF45

.lab_0397:
    ADDQ.L  #1,_DISKIO_OpenCount
    MOVE.W  #$100,_ESQPARS2_ReadModeFlags

    PEA     (MEMF_PUBLIC).W
    MOVE.L  _DISKIO_BufferState+Struct_DiskIoBufferState__BufferSize,-(A7)
    PEA     286.W
    PEA     Global_STR_DISKIO_C_1
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  _DISKIO_BufferState+Struct_DiskIoBufferState__BufferSize,_DISKIO_BufferState+Struct_DiskIoBufferState__Remaining
    MOVE.L  D0,_DISKIO_BufferState+Struct_DiskIoBufferState__BufferPtr
    MOVE.L  D0,_DISKIO_BufferControl+Struct_DiskIoBufferControl__BufferBase

.lab_0398:
    JSR     _GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(PC)

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======