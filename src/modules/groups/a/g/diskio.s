;------------------------------------------------------------------------------
; FUNC: DISKIO_OpenFileWithBuffer   (Open file and initialize I/O bufferuncertain)
; ARGS:
;   stack +16: filePathPtr (A3)
;   stack +20: accessMode (D7)
; RET:
;   D0: file handle or 0 on failure
; CLOBBERS:
;   D0/D6-D7/A3
; CALLS:
;   GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning, UNKNOWN2B_OpenFileWithAccessMode, MEMORY_AllocateMemory
; READS:
;   DISKIO_OpenCount, ESQPARS2_ReadModeFlags, DISKIO_BufferState+Struct_DiskIoBufferState__BufferSize
; WRITES:
;   DISKIO_BufferControl+Struct_DiskIoBufferControl__BufferBase, DISKIO_BufferControl+Struct_DiskIoBufferControl__ErrorFlag, DISKIO_OpenCount, ESQPARS2_ReadModeFlags, DISKIO_BufferState+Struct_DiskIoBufferState__BufferPtr, DISKIO_BufferState+Struct_DiskIoBufferState__Remaining, DISKIO_BufferState+Struct_DiskIoBufferState__SavedF45
; DESC:
;   Opens a file and allocates a global buffer used by disk I/O helpers.
; NOTES:
;   Early-exits if DISKIO_OpenCount is non-zero (already active). On first open, saves
;   ESQPARS2_ReadModeFlags into DISKIO_BufferState+Struct_DiskIoBufferState__SavedF45 and forces ESQPARS2_ReadModeFlags = $0100. Buffer size is DISKIO_BufferState+Struct_DiskIoBufferState__BufferSize.
;------------------------------------------------------------------------------
DISKIO_OpenFileWithBuffer:
    MOVEM.L D6-D7/A3,-(A7)

    SetOffsetForStack 3
    UseStackLong    MOVEA.L,1,A3
    UseStackLong    MOVE.L,2,D7

    MOVEQ   #0,D6
    JSR     GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(PC)

    TST.L   DISKIO_OpenCount
    BNE.S   .return

    CLR.L   DISKIO_BufferControl+Struct_DiskIoBufferControl__ErrorFlag
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    JSR     GROUP_AG_JMPTBL_UNKNOWN2B_OpenFileWithAccessMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   .lab_0398

    TST.L   DISKIO_OpenCount
    BNE.S   .lab_0397

    MOVE.W  ESQPARS2_ReadModeFlags,DISKIO_BufferState+Struct_DiskIoBufferState__SavedF45

.lab_0397:
    ADDQ.L  #1,DISKIO_OpenCount
    MOVE.W  #$100,ESQPARS2_ReadModeFlags

    PEA     (MEMF_PUBLIC).W
    MOVE.L  DISKIO_BufferState+Struct_DiskIoBufferState__BufferSize,-(A7)
    PEA     286.W
    PEA     Global_STR_DISKIO_C_1
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  DISKIO_BufferState+Struct_DiskIoBufferState__BufferSize,DISKIO_BufferState+Struct_DiskIoBufferState__Remaining
    MOVE.L  D0,DISKIO_BufferState+Struct_DiskIoBufferState__BufferPtr
    MOVE.L  D0,DISKIO_BufferControl+Struct_DiskIoBufferControl__BufferBase

.lab_0398:
    JSR     GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(PC)

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO_CloseBufferedFileAndFlush   (Routine at DISKIO_CloseBufferedFileAndFlush)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A6/A7/D0/D1/D2/D3/D6
; CALLS:
;   CTASKS_StartCloseTaskProcess, GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, _LVODelay, _LVOWrite
; READS:
;   DISKIO_BufferControl, DISKIO_BufferState, DISKIO_OpenCount, Global_REF_DOS_LIBRARY_2, Global_STR_DISKIO_C_2, DATA_CTASKS_CONST_WORD_1B8A, Global_UIBusyFlag, Struct_DiskIoBufferControl__BufferBase, Struct_DiskIoBufferState__BufferSize, Struct_DiskIoBufferState__Remaining, Struct_DiskIoBufferState__SavedF45
; WRITES:
;   DISKIO_BufferControl, DISKIO_OpenCount, ESQPARS2_ReadModeFlags, Struct_DiskIoBufferControl__ErrorFlag
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_CloseBufferedFileAndFlush:
    MOVEM.L D2-D3/D6-D7,-(A7)

    SetOffsetForStack 4
    UseStackLong    MOVE.L,1,D7

    JSR     GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(PC)

    TST.L   D7
    BEQ.S   .lab_039D

    CLR.L   DISKIO_BufferControl+Struct_DiskIoBufferControl__ErrorFlag
    MOVE.L  DISKIO_BufferState+Struct_DiskIoBufferState__BufferSize,D0
    SUB.L   DISKIO_BufferState+Struct_DiskIoBufferState__Remaining,D0
    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   .lab_039B

    MOVE.L  D7,D1
    MOVE.L  D6,D3
    MOVE.L  DISKIO_BufferControl+Struct_DiskIoBufferControl__BufferBase,D2
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOWrite(A6)

    CMP.L   D3,D0

.lab_039B:
    JSR     GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(PC)

    MOVE.L  D7,-(A7)
    JSR     CTASKS_StartCloseTaskProcess(PC)

    ADDQ.W  #4,A7

.branch:
    JSR     GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(PC)

    MOVEQ   #5,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVODelay(A6)

    JSR     GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(PC)

    TST.W   DATA_CTASKS_CONST_WORD_1B8A
    BEQ.S   .branch

    MOVE.L  DISKIO_BufferState+Struct_DiskIoBufferState__BufferSize,-(A7)
    MOVE.L  DISKIO_BufferControl+Struct_DiskIoBufferControl__BufferBase,-(A7)
    PEA     353.W
    PEA     Global_STR_DISKIO_C_2
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    JSR     GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(PC)

    LEA     16(A7),A7

.lab_039D:
    MOVE.L  DISKIO_OpenCount,D0
    TST.L   D0
    BLE.S   .branch_1

    SUBQ.L  #1,DISKIO_OpenCount

.branch_1:
    TST.L   DISKIO_OpenCount
    BNE.S   DISKIO_CloseBufferedFileAndFlush_Return

    TST.W   Global_UIBusyFlag
    BNE.S   DISKIO_CloseBufferedFileAndFlush_Return

    MOVE.W  DISKIO_BufferState+Struct_DiskIoBufferState__SavedF45,ESQPARS2_ReadModeFlags

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

;------------------------------------------------------------------------------
; FUNC: DISKIO_WriteBufferedBytes   (Routine at DISKIO_WriteBufferedBytes)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A6/A7/D0/D1/D2/D3/D4/D5/D6
; CALLS:
;   GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning, _LVOWrite
; READS:
;   DISKIO_BufferControl, DISKIO_BufferState, Global_REF_DOS_LIBRARY_2, Struct_DiskIoBufferControl__BufferBase, Struct_DiskIoBufferControl__ErrorFlag, Struct_DiskIoBufferState__BufferPtr, Struct_DiskIoBufferState__BufferSize, Struct_DiskIoBufferState__Remaining
; WRITES:
;   DISKIO_BufferControl, DISKIO_BufferState, Struct_DiskIoBufferControl__ErrorFlag, Struct_DiskIoBufferState__BufferPtr, Struct_DiskIoBufferState__Remaining
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_WriteBufferedBytes:
    MOVEM.L D2-D7/A3,-(A7)

    SetOffsetForStack 7
    UseStackLong    MOVE.L,1,D7     ; Value DISKIO2_OutputFileHandle
    UseStackLong    MOVEA.L,2,A3    ; Address DATA_ESQ_STR_B_1DC8
    UseStackLong    MOVE.L,3,D6     ; 21

    MOVE.L  D6,D5
    MOVE.L  D6,D4
    MOVE.L  A3,D0
    BEQ.S   .lab_03A1

    TST.L   D6
    BEQ.S   .lab_03A1

    MOVEQ   #1,D0
    CMP.L   DISKIO_BufferControl+Struct_DiskIoBufferControl__ErrorFlag,D0
    BEQ.S   .lab_03A1

    TST.L   D7
    BNE.S   .lab_03A2

.lab_03A1:
    MOVEQ   #0,D0
    BRA.S   DISKIO_WriteBufferedBytes_Return

.lab_03A2:
    JSR     GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(PC)

.lab_03A3:
    MOVEA.L DISKIO_BufferState+Struct_DiskIoBufferState__BufferPtr,A0
    MOVE.B  (A3)+,(A0)+
    MOVE.L  A0,DISKIO_BufferState+Struct_DiskIoBufferState__BufferPtr
    SUBQ.L  #1,DISKIO_BufferState+Struct_DiskIoBufferState__Remaining
    SUBQ.L  #1,D6
    MOVE.L  A0,DISKIO_BufferState+Struct_DiskIoBufferState__BufferPtr
    TST.L   DISKIO_BufferState+Struct_DiskIoBufferState__Remaining
    BEQ.S   .lab_03A4

    TST.L   D6
    BNE.S   .lab_03A3

.lab_03A4:
    JSR     GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(PC)

    TST.L   DISKIO_BufferState+Struct_DiskIoBufferState__Remaining
    BNE.S   .lab_03A6

    MOVE.L  D7,D1
    MOVE.L  DISKIO_BufferControl+Struct_DiskIoBufferControl__BufferBase,D2
    MOVE.L  DISKIO_BufferState+Struct_DiskIoBufferState__BufferSize,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOWrite(A6)

    MOVE.L  D0,D5
    CMP.L   D3,D5
    BEQ.S   .lab_03A5

    MOVEQ   #1,D0
    MOVE.L  D0,DISKIO_BufferControl+Struct_DiskIoBufferControl__ErrorFlag
    BRA.S   .lab_03A7

.lab_03A5:
    MOVE.L  D4,D5
    MOVE.L  D2,DISKIO_BufferState+Struct_DiskIoBufferState__BufferPtr
    MOVE.L  D3,DISKIO_BufferState+Struct_DiskIoBufferState__Remaining
    JSR     GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(PC)

.lab_03A6:
    TST.L   D6
    BNE.S   .lab_03A2

.lab_03A7:
    MOVE.L  D5,D0

;------------------------------------------------------------------------------
; FUNC: DISKIO_WriteBufferedBytes_Return   (Routine at DISKIO_WriteBufferedBytes_Return)
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
DISKIO_WriteBufferedBytes_Return:
    MOVEM.L (A7)+,D2-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO_WriteDecimalField   (Routine at DISKIO_WriteDecimalField)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +8: arg_3 (via 12(A5))
;   stack +16: arg_4 (via 20(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0/D6/D7
; CALLS:
;   GROUP_AE_JMPTBL_WDISP_SPrintf, DISKIO_WriteBufferedBytes
; READS:
;   Global_STR_PERCENT_LD
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_WriteDecimalField:
    LINK.W  A5,#-12
    MOVEM.L D6-D7,-(A7)

    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6

    MOVE.L  D6,-(A7)
    PEA     Global_STR_PERCENT_LD
    PEA     -10(A5)
    JSR     GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     -10(A5),A0
    MOVEA.L A0,A1

.lab_03AA:
    TST.B   (A1)+
    BNE.S   .lab_03AA

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D7,-(A7)
    BSR.W   DISKIO_WriteBufferedBytes

    MOVEM.L -20(A5),D6-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO_GetFilesizeFromHandle   (Routine at DISKIO_GetFilesizeFromHandle)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A6/A7/D0/D1/D2/D3/D6
; CALLS:
;   _LVOSeek
; READS:
;   Global_REF_DOS_LIBRARY_2, OFFSET_BEGINNING, OFFSET_END
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_GetFilesizeFromHandle:
    MOVEM.L D2-D3/D6-D7,-(A7)

    SetOffsetForStack 4
    UseStackLong    MOVE.L,1,D7

    ; Jump to the end of the file.
    MOVE.L  D7,D1
    MOVEQ   #0,D2
    MOVEQ   #(OFFSET_END),D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOSeek(A6)

    ; Seek to the current (end) of the file
    ; so that the oldPosition is set in D0
    MOVE.L  D7,D1
    MOVE.L  D2,D3   ; D2 is 0, so this is OFFSET_CURRENT
    JSR     _LVOSeek(A6)

    ; Copy the oldPosition to D6 then seek to the beginning
    ; of the file again.
    MOVE.L  D0,D6
    MOVE.L  D7,D1
    MOVEQ   #(OFFSET_BEGINNING),D3
    JSR     _LVOSeek(A6)

    ; Return the total size of the file in D0
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D2-D3/D6-D7
    RTS

;!======

; Load a file into memory?
;------------------------------------------------------------------------------
; FUNC: DISKIO_LoadFileToWorkBuffer   (Routine at DISKIO_LoadFileToWorkBuffer)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A6/A7/D0/D1/D2/D3/D7
; CALLS:
;   GROUP_AG_JMPTBL_MEMORY_AllocateMemory, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, GROUP_AG_JMPTBL_UNKNOWN2B_OpenFileWithAccessMode, _LVOClose, _LVORead
; READS:
;   Global_REF_DOS_LIBRARY_2, Global_REF_LONG_FILE_SCRATCH, Global_STR_DISKIO_C_3, Global_STR_DISKIO_C_4, Global_PTR_WORK_BUFFER, MEMF_CLEAR, MEMF_PUBLIC, MODE_OLDFILE, return
; WRITES:
;   Global_REF_LONG_FILE_SCRATCH, Global_PTR_WORK_BUFFER
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_LoadFileToWorkBuffer:
    MOVEM.L D2-D3/D7/A3,-(A7)

    SetOffsetForStack 4
    UseStackLong    MOVEA.L,1,A3

    ; Open the filename in A3
    PEA     (MODE_OLDFILE).W
    MOVE.L  A3,-(A7)
    JSR     GROUP_AG_JMPTBL_UNKNOWN2B_OpenFileWithAccessMode(PC)

    ADDQ.W  #8,A7

    MOVE.L  D0,D7
    TST.L   D7
    BNE.S   .successfullyOpenedFile

    MOVEQ   #-1,D0
    BRA.W   .return

.successfullyOpenedFile:
    MOVE.L  D7,-(A7)
    BSR.S   DISKIO_GetFilesizeFromHandle

    ADDQ.W  #4,A7
    MOVE.L  D0,Global_REF_LONG_FILE_SCRATCH
    TST.L   D0
    BGT.S   .lab_03AE

    MOVE.L  D7,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

    MOVEQ   #-1,D0
    BRA.W   .return

.lab_03AE:
    MOVE.L  Global_REF_LONG_FILE_SCRATCH,D0
    ADDQ.L  #1,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     472.W
    PEA     Global_STR_DISKIO_C_3
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,Global_PTR_WORK_BUFFER
    TST.L   D0
    BNE.S   .lab_03AF

    MOVE.L  D7,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

    MOVEQ   #-1,D0
    BRA.S   .return

.lab_03AF:
    MOVE.L  D7,D1
    MOVE.L  Global_PTR_WORK_BUFFER,D2
    MOVE.L  Global_REF_LONG_FILE_SCRATCH,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVORead(A6)

    MOVE.L  Global_REF_LONG_FILE_SCRATCH,D1
    CMP.L   D1,D0
    BEQ.S   .lab_03B0

    ADDQ.L  #1,D1
    MOVE.L  D1,-(A7)
    MOVE.L  Global_PTR_WORK_BUFFER,-(A7)
    PEA     492.W
    PEA     Global_STR_DISKIO_C_4
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D7,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

    MOVEQ   #-1,D0
    BRA.S   .return

.lab_03B0:
    MOVE.L  D7,D1
    JSR     _LVOClose(A6)

    MOVE.L  Global_REF_LONG_FILE_SCRATCH,D0

.return:
    MOVEM.L (A7)+,D2-D3/D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO_ConsumeCStringFromWorkBuffer   (Routine at DISKIO_ConsumeCStringFromWorkBuffer)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A5/D0
; CALLS:
;   (none)
; READS:
;   Global_REF_LONG_FILE_SCRATCH, Global_PTR_WORK_BUFFER, ffff
; WRITES:
;   Global_REF_LONG_FILE_SCRATCH, Global_PTR_WORK_BUFFER
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_ConsumeCStringFromWorkBuffer:
    LINK.W  A5,#-4
    MOVE.L  Global_PTR_WORK_BUFFER,-4(A5)

.lab_03B3:
    MOVE.L  Global_REF_LONG_FILE_SCRATCH,D0
    SUBQ.L  #1,Global_REF_LONG_FILE_SCRATCH
    TST.L   D0
    BLE.S   .lab_03B4

    MOVEA.L Global_PTR_WORK_BUFFER,A0
    MOVE.B  (A0)+,D0
    MOVE.L  A0,Global_PTR_WORK_BUFFER
    TST.B   D0
    BNE.S   .lab_03B3

.lab_03B4:
    MOVE.L  Global_REF_LONG_FILE_SCRATCH,D0
    TST.L   D0
    BPL.S   .lab_03B5

    MOVEA.W #$ffff,A0
    MOVE.L  A0,-4(A5)

.lab_03B5:
    MOVE.L  -4(A5),D0
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO_ParseLongFromWorkBuffer   (Routine at DISKIO_ParseLongFromWorkBuffer)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A5/A7/D0
; CALLS:
;   GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt
; READS:
;   ffff
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_ParseLongFromWorkBuffer:
    LINK.W  A5,#-4

    BSR.S   DISKIO_ConsumeCStringFromWorkBuffer

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-4(A5)
    CMP.L   A0,D0
    BNE.S   .lab_03B7

    MOVE.L  A0,D0
    BRA.S   .return

.lab_03B7:
    MOVE.L  D0,-(A7)
    JSR     GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

.return:
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO_ConsumeLineFromWorkBuffer   (Routine at DISKIO_ConsumeLineFromWorkBuffer)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A5/D0/D1
; CALLS:
;   (none)
; READS:
;   Global_REF_LONG_FILE_SCRATCH, Global_PTR_WORK_BUFFER
; WRITES:
;   Global_REF_LONG_FILE_SCRATCH, Global_PTR_WORK_BUFFER
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_ConsumeLineFromWorkBuffer:
    LINK.W  A5,#-4
    MOVE.L  Global_PTR_WORK_BUFFER,-4(A5)

.lab_03BA:
    MOVE.L  Global_REF_LONG_FILE_SCRATCH,D0
    SUBQ.L  #1,Global_REF_LONG_FILE_SCRATCH
    TST.L   D0
    BLE.S   .lab_03BB

    MOVEA.L Global_PTR_WORK_BUFFER,A0
    MOVE.B  (A0),D0
    MOVEQ   #13,D1
    CMP.B   D1,D0
    BEQ.S   .lab_03BB

    MOVEQ   #10,D1
    CMP.B   D1,D0
    BEQ.S   .lab_03BB

    ADDQ.L  #1,Global_PTR_WORK_BUFFER
    BRA.S   .lab_03BA

.lab_03BB:
    MOVEA.L Global_PTR_WORK_BUFFER,A0
    CLR.B   (A0)+
    MOVE.L  A0,Global_PTR_WORK_BUFFER
    MOVE.L  Global_REF_LONG_FILE_SCRATCH,D0
    TST.L   D0
    BPL.S   .lab_03BC

    MOVEA.W #(-1),A0
    MOVE.L  A0,D0
    BRA.S   .lab_03BF

.lab_03BC:
    MOVEA.L Global_PTR_WORK_BUFFER,A0
    MOVE.B  (A0),D0
    MOVEQ   #13,D1
    CMP.B   D1,D0
    BEQ.S   .lab_03BD

    MOVEQ   #10,D1
    CMP.B   D1,D0
    BNE.S   .lab_03BE

.lab_03BD:
    ADDQ.L  #1,Global_PTR_WORK_BUFFER
    SUBQ.L  #1,Global_REF_LONG_FILE_SCRATCH
    BRA.S   .lab_03BC

.lab_03BE:
    MOVE.L  -4(A5),D0

.lab_03BF:
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO_QueryDiskUsagePercentAndSetBufferSize   (Routine at DISKIO_QueryDiskUsagePercentAndSetBufferSize)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A5/A6/A7/D0/D1/D2/D6/D7
; CALLS:
;   GROUP_AG_JMPTBL_MATH_DivS32, GROUP_AG_JMPTBL_MATH_Mulu32, GROUP_AG_JMPTBL_MEMORY_AllocateMemory, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, _LVOInfo, _LVOLock, _LVOUnLock
; READS:
;   Global_REF_DOS_LIBRARY_2, Global_STR_DISKIO_C_5, Global_STR_DISKIO_C_6, MEMF_CLEAR, Struct_InfoData_Size
; WRITES:
;   DISKIO_BufferState, Struct_DiskIoBufferState__BufferSize
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_QueryDiskUsagePercentAndSetBufferSize:
    LINK.W  A5,#-12
    MOVEM.L D2/D6-D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEQ   #0,D7
    MOVE.L  A3,D1
    MOVEQ   #-2,D2
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOLock(A6)

    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   .return

    MOVE.L  #(MEMF_CLEAR),-(A7)
    PEA     Struct_InfoData_Size.W
    PEA     567.W
    PEA     Global_STR_DISKIO_C_5
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.S   .lab_03C2

    MOVE.L  D6,D1
    MOVE.L  D0,D2
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOInfo(A6)

    TST.L   D0
    BEQ.S   .lab_03C1

    MOVEA.L D2,A0
    MOVE.L  16(A0),D0
    MOVEQ   #100,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  12(A0),D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D0,D7
    MOVE.L  20(A0),D0
    ADD.L   D0,D0
    MOVE.L  D0,DISKIO_BufferState+Struct_DiskIoBufferState__BufferSize

.lab_03C1:
    PEA     Struct_InfoData_Size.W
    MOVE.L  D2,-(A7)
    PEA     574.W
    PEA     Global_STR_DISKIO_C_6
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.lab_03C2:
    MOVE.L  D6,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOUnLock(A6)

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D2/D6-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO_QueryVolumeSoftErrorCount   (Routine at DISKIO_QueryVolumeSoftErrorCount)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A5/A6/A7/D0/D1/D2/D6/D7
; CALLS:
;   GROUP_AG_JMPTBL_MEMORY_AllocateMemory, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, _LVOInfo, _LVOLock, _LVOUnLock
; READS:
;   Global_REF_DOS_LIBRARY_2, Global_STR_DISKIO_C_7, Global_STR_DISKIO_C_8, MEMF_CLEAR, Struct_InfoData_Size
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_QueryVolumeSoftErrorCount:
    LINK.W  A5,#-12
    MOVEM.L D2/D6-D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEQ   #0,D7
    MOVE.L  A3,D1
    MOVEQ   #-2,D2
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOLock(A6)

    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   .return

    MOVE.L  #(MEMF_CLEAR),-(A7)
    PEA     Struct_InfoData_Size.W
    PEA     593.W
    PEA     Global_STR_DISKIO_C_7
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.S   .lab_03C6

    MOVE.L  D6,D1
    MOVE.L  D0,D2
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOInfo(A6)

    TST.L   D0
    BEQ.S   .lab_03C5

    MOVEA.L D2,A0
    MOVE.L  (A0),D7

.lab_03C5:
    PEA     Struct_InfoData_Size.W
    MOVE.L  D2,-(A7)
    PEA     599.W
    PEA     Global_STR_DISKIO_C_8
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.lab_03C6:
    MOVE.L  D6,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOUnLock(A6)

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D2/D6-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO_WriteBytesToOutputHandleGuarded   (Routine at DISKIO_WriteBytesToOutputHandleGuarded)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A6/A7/D0/D1/D2/D3/D6/D7
; CALLS:
;   _LVOWrite
; READS:
;   Global_REF_DOS_LIBRARY_2, ESQPARS2_ReadModeFlags, DISKIO_WriteFileHandle, DISKIO_SavedReadModeFlags
; WRITES:
;   ESQPARS2_ReadModeFlags, DISKIO_SavedReadModeFlags
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_WriteBytesToOutputHandleGuarded:
    MOVEM.L D2-D3/D6-D7/A3,-(A7)

    MOVEA.L 24(A7),A3
    MOVE.W  30(A7),D7
    MOVE.W  ESQPARS2_ReadModeFlags,DISKIO_SavedReadModeFlags
    MOVE.W  #$100,ESQPARS2_ReadModeFlags
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  A3,D2
    MOVE.L  D0,D3
    MOVE.L  DISKIO_WriteFileHandle,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOWrite(A6)

    MOVE.L  D0,D6
    CMP.W   D7,D6
    MOVE.W  DISKIO_SavedReadModeFlags,ESQPARS2_ReadModeFlags
    CMP.W   D7,D6
    BEQ.S   .lab_03C9

    MOVEQ   #-1,D0
    BRA.S   .return

.lab_03C9:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D2-D3/D6-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO_ForceUiRefreshIfIdle   (Routine at DISKIO_ForceUiRefreshIfIdle)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   GROUP_AG_JMPTBL_TEXTDISP_ResetSelectionAndRefresh
; READS:
;   Global_UIBusyFlag
; WRITES:
;   ESQPARS2_ReadModeFlags, Global_RefreshTickCounter
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_ForceUiRefreshIfIdle:
    TST.W   Global_UIBusyFlag
    BNE.S   .return

    MOVE.W  #$100,ESQPARS2_ReadModeFlags
    MOVE.W  #(-1),Global_RefreshTickCounter
    JSR     GROUP_AG_JMPTBL_TEXTDISP_ResetSelectionAndRefresh(PC)

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO_ResetCtrlInputStateIfIdle   (Routine at DISKIO_ResetCtrlInputStateIfIdle)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A6/D0
; CALLS:
;   _LVODisable, _LVOEnable
; READS:
;   AbsExecBase, Global_UIBusyFlag
; WRITES:
;   CTRL_H, ESQPARS2_ReadModeFlags, CTRL_HPreviousSample, DATA_WDISP_BSS_WORD_2284, Global_RefreshTickCounter
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_ResetCtrlInputStateIfIdle:
    TST.W   Global_UIBusyFlag
    BNE.S   .return

    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVEQ   #0,D0
    MOVE.W  D0,DATA_WDISP_BSS_WORD_2284
    MOVE.W  D0,CTRL_HPreviousSample
    MOVE.W  D0,CTRL_H
    JSR     _LVOEnable(A6)

    MOVEQ   #0,D0
    MOVE.W  D0,Global_RefreshTickCounter
    MOVE.W  D0,ESQPARS2_ReadModeFlags

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO_ProbeDrivesAndAssignPaths   (Routine at DISKIO_ProbeDrivesAndAssignPaths)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A6/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport, GROUP_AG_JMPTBL_SCRIPT_CheckPathExists, GROUP_AG_JMPTBL_SIGNAL_CreateMsgPortWithSignal, GROUP_AG_JMPTBL_STRUCT_AllocWithOwner, GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField, _LVOCloseDevice, _LVODoIO, _LVOExecute, _LVOOpenDevice
; READS:
;   AbsExecBase, Global_REF_DOS_LIBRARY_2, LAB_03D0, LAB_03D6, LAB_03D7, LAB_03DA, DATA_DISKIO_CONST_LONG_1BD5, DATA_DISKIO_CONST_LONG_1BD6, DISKIO_STR_TRACKDISK_DEVICE, DISKIO_CMD_ASSIGN_FONTS_DH2, DISKIO_CMD_ASSIGN_ENV_DH2, DISKIO_CMD_ASSIGN_SYS_DH2, DISKIO_CMD_ASSIGN_S_DH2, DISKIO_CMD_ASSIGN_C_DH2, DISKIO_CMD_ASSIGN_L_DH2, DISKIO_CMD_ASSIGN_LIBS_DH2, DISKIO_CMD_ASSIGN_DEVS_DH2, DISKIO_PATH_DF1_G_ADS, DISKIO_CMD_ASSIGN_GFX_DF1, DISKIO_CMD_ASSIGN_GFX_PC1, DATA_ESQ_BSS_WORD_1DE5, ESQPARS2_ReadModeFlags, DISKIO_TrackdiskMsgPortPtr, DISKIO_TrackdiskIoReqPtr, DISKIO_Drive0WriteProtectedCode, DATA_WDISP_BSS_LONG_2319, DATA_WDISP_BSS_LONG_231A, df, e2, return
; WRITES:
;   DATA_DISKIO_CONST_LONG_1BD5, DATA_DISKIO_CONST_LONG_1BD6, ESQPARS2_ReadModeFlags, DATA_GCOMMAND_CONST_WORD_1FB0, DISKIO_TrackdiskMsgPortPtr, DISKIO_TrackdiskIoReqPtr
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_ProbeDrivesAndAssignPaths:
    MOVEM.L D2-D3/D5-D7/A2,-(A7)
    CLR.L   -(A7)
    CLR.L   -(A7)
    JSR     GROUP_AG_JMPTBL_SIGNAL_CreateMsgPortWithSignal(PC)

    MOVE.L  D0,DISKIO_TrackdiskMsgPortPtr
    PEA     56.W
    MOVE.L  D0,-(A7)
    JSR     GROUP_AG_JMPTBL_STRUCT_AllocWithOwner(PC)

    LEA     16(A7),A7
    MOVE.L  D0,DISKIO_TrackdiskIoReqPtr
    MOVEQ   #0,D7

.lab_03D0:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.W   .lab_03D7

    MOVE.L  D7,D1
    ASL.L   #2,D1
    LEA     DISKIO_Drive0WriteProtectedCode,A0
    ADDA.L  D1,A0
    MOVEQ   #0,D0
    MOVE.L  D0,(A0)
    LEA     DATA_WDISP_BSS_LONG_231A,A0
    ADDA.L  D1,A0
    MOVE.L  D0,(A0)
    MOVE.L  D7,D0
    LEA     DISKIO_STR_TRACKDISK_DEVICE,A0
    MOVEA.L DISKIO_TrackdiskIoReqPtr,A1
    MOVEQ   #0,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOOpenDevice(A6)

    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   .lab_03D1

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     DISKIO_Drive0WriteProtectedCode,A0
    ADDA.L  D0,A0
    MOVE.L  #218,(A0)
    LEA     DATA_WDISP_BSS_LONG_231A,A0
    ADDA.L  D0,A0
    MOVE.L  #223,(A0)
    BRA.W   .lab_03D6

.lab_03D1:
    MOVEA.L DISKIO_TrackdiskIoReqPtr,A0
    MOVE.W  #14,28(A0)
    MOVEA.L DISKIO_TrackdiskIoReqPtr,A1
    JSR     _LVODoIO(A6)

    MOVEA.L DISKIO_TrackdiskIoReqPtr,A0
    TST.B   31(A0)
    BEQ.S   .lab_03D2

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     DISKIO_Drive0WriteProtectedCode,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    MOVEQ   #113,D0
    ADD.L   D0,D0
    MOVE.L  D0,(A2)
    BRA.S   .lab_03D3

.lab_03D2:
    TST.L   32(A0)
    BEQ.S   .lab_03D3

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     DISKIO_Drive0WriteProtectedCode,A1
    ADDA.L  D0,A1
    MOVE.L  #$e2,(A1)

.lab_03D3:
    MOVEA.L DISKIO_TrackdiskIoReqPtr,A0
    MOVE.W  #15,28(A0)
    MOVEA.L DISKIO_TrackdiskIoReqPtr,A1
    JSR     _LVODoIO(A6)

    MOVEA.L DISKIO_TrackdiskIoReqPtr,A0
    TST.B   31(A0)
    BEQ.S   .lab_03D4

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     DATA_WDISP_BSS_LONG_231A,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #32,D0
    NOT.B   D0
    MOVE.L  D0,(A1)
    BRA.S   .lab_03D5

.lab_03D4:
    TST.L   32(A0)
    BEQ.S   .lab_03D5

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     DATA_WDISP_BSS_LONG_231A,A0
    ADDA.L  D0,A0
    MOVE.L  #$df,(A0)

.lab_03D5:
    MOVEA.L DISKIO_TrackdiskIoReqPtr,A1
    JSR     _LVOCloseDevice(A6)

.lab_03D6:
    ADDQ.L  #1,D7
    BRA.W   .lab_03D0

.lab_03D7:
    MOVE.L  DISKIO_TrackdiskIoReqPtr,-(A7)
    JSR     GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField(PC)

    MOVE.L  DISKIO_TrackdiskMsgPortPtr,(A7)
    JSR     GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(PC)

    ADDQ.W  #4,A7
    TST.W   DATA_ESQ_BSS_WORD_1DE5
    BEQ.W   .return

    CLR.W   DATA_GCOMMAND_CONST_WORD_1FB0
    TST.L   DISKIO_Drive0WriteProtectedCode
    BEQ.S   .lab_03D8

    MOVEQ   #1,D0
    MOVE.L  D0,DATA_DISKIO_CONST_LONG_1BD5

.lab_03D8:
    TST.L   DATA_WDISP_BSS_LONG_2319
    BEQ.S   .lab_03D9

    MOVEQ   #1,D0
    MOVE.L  D0,DATA_DISKIO_CONST_LONG_1BD6

.lab_03D9:
    TST.L   DATA_DISKIO_CONST_LONG_1BD5
    BEQ.W   .lab_03DA

    TST.L   DISKIO_Drive0WriteProtectedCode
    BNE.W   .lab_03DA

    MOVE.W  ESQPARS2_ReadModeFlags,D5
    MOVE.W  #$100,ESQPARS2_ReadModeFlags
    LEA     DISKIO_CMD_ASSIGN_FONTS_DH2,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     DISKIO_CMD_ASSIGN_ENV_DH2,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     DISKIO_CMD_ASSIGN_SYS_DH2,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     DISKIO_CMD_ASSIGN_S_DH2,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     DISKIO_CMD_ASSIGN_C_DH2,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     DISKIO_CMD_ASSIGN_L_DH2,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     DISKIO_CMD_ASSIGN_LIBS_DH2,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     DISKIO_CMD_ASSIGN_DEVS_DH2,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

    MOVE.W  D5,ESQPARS2_ReadModeFlags
    MOVE.L  D2,DATA_DISKIO_CONST_LONG_1BD5

.lab_03DA:
    TST.L   DATA_DISKIO_CONST_LONG_1BD6
    BEQ.S   .return

    TST.L   DATA_WDISP_BSS_LONG_2319
    BNE.S   .return

    PEA     DISKIO_PATH_DF1_G_ADS
    JSR     GROUP_AG_JMPTBL_SCRIPT_CheckPathExists(PC)

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .lab_03DB

    LEA     DISKIO_CMD_ASSIGN_GFX_DF1,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    BRA.S   .lab_03DC

.lab_03DB:
    LEA     DISKIO_CMD_ASSIGN_GFX_PC1,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

.lab_03DC:
    MOVE.L  D2,DATA_DISKIO_CONST_LONG_1BD6

.return:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO_DrawTransferErrorMessageIfDiagnostics   (Routine at DISKIO_DrawTransferErrorMessageIfDiagnostics)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0/D7
; CALLS:
;   DISPLIB_DisplayTextAtPosition, _LVOSetAPen
; READS:
;   Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, CTASKS_TerminationReasonPtrTable, ED_DiagnosticsScreenActive
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_DrawTransferErrorMessageIfDiagnostics:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    TST.W   ED_DiagnosticsScreenActive
    BEQ.S   .return

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #4,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.L  D7,D0
    ASL.L   #2,D0
    ; Layout-coupled table anchor: CTASKS_TerminationReasonPtrTable is
    ; followed by a termination-reason pointer table.
    LEA     (CTASKS_TerminationReasonPtrTable-4),A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    PEA     240.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO_ParseConfigBuffer   (Routine at DISKIO_ParseConfigBuffer)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +24: arg_3 (via 28(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A5/A7/D0/D1/D2/D5/D6/D7
; CALLS:
;   BRUSH_SelectBrushByLabel, GROUP_AG_JMPTBL_ESQFUNC_UpdateRefreshModeState, GROUP_AG_JMPTBL_MATH_Mulu32, GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, GROUP_AG_JMPTBL_SCRIPT_BeginBannerCharTransition, GROUP_AI_JMPTBL_UNKNOWN7_FindCharWrapper, DISKIO_EnsurePc1MountedAndGfxAssigned
; READS:
;   Global_JMPTBL_HALF_HOURS_12_HR_FMT, Global_JMPTBL_HALF_HOURS_24_HR_FMT, Global_REF_STR_USE_24_HR_CLOCK, Global_REF_WORD_HEX_CODE_8E, LAB_0409, DATA_CTASKS_CONST_BYTE_1BA2, ED_DiagTextModeChar, DATA_CTASKS_STR_N_1BC5, DATA_CTASKS_STR_N_1BC6, CONFIG_LRBN_FlagChar, DATA_DISKIO_TAG_NRLS_1BE3, DATA_DISKIO_TAG_LRBN_1BE4, DATA_DISKIO_TAG_MSN_1BE5, WDISP_CharClassTable, N
; WRITES:
;   Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES, Global_REF_STR_CLOCK_FORMAT, Global_REF_STR_USE_24_HR_CLOCK, Global_REF_WORD_HEX_CODE_8E, DATA_CTASKS_CONST_BYTE_1BA2, DATA_CTASKS_STR_C_1BA3, DATA_CTASKS_BSS_BYTE_1BA4, DATA_CTASKS_CONST_BYTE_1BA5, DATA_CTASKS_CONST_BYTE_1BA6, DATA_CTASKS_CONST_BYTE_1BA7, DATA_CTASKS_STR_G_1BA8, DATA_CTASKS_STR_N_1BA9, DATA_CTASKS_STR_A_1BAA, DATA_CTASKS_STR_E_1BAB, DATA_CTASKS_BSS_BYTE_1BAC, DATA_CTASKS_BSS_BYTE_1BAD, DATA_CTASKS_STR_Y_1BAE, DATA_CTASKS_STR_Y_1BAF, DATA_CTASKS_STR_N_1BB0, DATA_CTASKS_STR_N_1BB1, DATA_CTASKS_STR_Y_1BB2, DATA_CTASKS_STR_N_1BB3, DATA_CTASKS_STR_L_1BB4, DATA_CTASKS_CONST_BYTE_1BB5, DATA_CTASKS_CONST_BYTE_1BB6, DATA_CTASKS_STR_Y_1BB7, DATA_CTASKS_STR_Y_1BB8, DATA_CTASKS_STR_N_1BB9, DATA_CTASKS_CONST_BYTE_1BBA, DATA_CTASKS_CONST_BYTE_1BBB, DATA_CTASKS_CONST_BYTE_1BBC, CONFIG_TimeWindowMinutes, DATA_CTASKS_CONST_LONG_1BBE, DATA_CTASKS_STR_Y_1BBF, DATA_CTASKS_STR_Y_1BC1, ED_DiagTextModeChar, DATA_CTASKS_STR_N_1BC5, DATA_CTASKS_STR_N_1BC6, CONFIG_LRBN_FlagChar, CONFIG_MSN_FlagChar, DATA_CTASKS_STR_1_1BC9, DATA_CTASKS_CONST_LONG_1BCA
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_ParseConfigBuffer:
    LINK.W  A5,#-8
    MOVEM.L D2/D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7

    MOVEQ   #0,D6
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVEQ   #-48,D1
    ADD.B   0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_CONST_BYTE_1BA2
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_STR_C_1BA3
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVEQ   #-48,D1
    ADD.B   0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_BSS_BYTE_1BA4
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVEQ   #-48,D1
    ADD.B   0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_CONST_BYTE_1BA5
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    CLR.B   -5(A5)
    PEA     -7(A5)
    JSR     GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,DATA_CTASKS_CONST_BYTE_1BA6
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    CLR.B   -5(A5)
    PEA     -7(A5)
    JSR     GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,DATA_CTASKS_CONST_BYTE_1BA7
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_STR_G_1BA8
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03E1

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_STR_N_1BA9
    BRA.S   .lab_03E2

.lab_03E1:
    MOVEQ   #78,D0
    MOVE.B  D0,DATA_CTASKS_STR_N_1BA9

.lab_03E2:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03E3

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_STR_A_1BAA
    BRA.S   .lab_03E4

.lab_03E3:
    MOVE.B  #$41,DATA_CTASKS_STR_A_1BAA

.lab_03E4:
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_STR_E_1BAB
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03E6

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVEQ   #-48,D1
    ADD.B   0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_BSS_BYTE_1BAC
    TST.B   D1
    BMI.S   .lab_03E5

    MOVEQ   #9,D0
    CMP.B   D0,D1
    BLE.S   .lab_03E6

.lab_03E5:
    MOVEQ   #0,D0
    MOVE.B  D0,DATA_CTASKS_BSS_BYTE_1BAC

.lab_03E6:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03E8

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVEQ   #-48,D1
    ADD.B   0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_BSS_BYTE_1BAD
    TST.B   D1
    BMI.S   .lab_03E7

    MOVEQ   #9,D0
    CMP.B   D0,D1
    BLE.S   .lab_03E8

.lab_03E7:
    MOVEQ   #0,D0
    MOVE.B  D0,DATA_CTASKS_BSS_BYTE_1BAD

.lab_03E8:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03E9

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_STR_Y_1BAE
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03E9

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .lab_03E9

    MOVE.B  D0,DATA_CTASKS_STR_Y_1BAE

.lab_03E9:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03EA

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_STR_Y_1BAF
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03EA

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .lab_03EA

    MOVE.B  D0,DATA_CTASKS_STR_Y_1BAF

.lab_03EA:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03EB

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_STR_N_1BB0
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03EB

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .lab_03EB

    MOVE.B  D2,DATA_CTASKS_STR_N_1BB0

.lab_03EB:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03EC

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_STR_N_1BB1
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03EC

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .lab_03EC

    MOVE.B  D2,DATA_CTASKS_STR_N_1BB1

.lab_03EC:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03ED

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_STR_Y_1BB2
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03ED

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .lab_03ED

    MOVE.B  D0,DATA_CTASKS_STR_Y_1BB2

.lab_03ED:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03EE

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_STR_N_1BB3
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03EE

    MOVEQ   #78,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03EE

    MOVE.B  D0,DATA_CTASKS_STR_N_1BB3

.lab_03EE:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03EF

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_STR_L_1BB4
    MOVEQ   #76,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03EF

    MOVEQ   #83,D2
    CMP.B   D2,D1
    BEQ.S   .lab_03EF

    MOVEQ   #86,D2
    CMP.B   D2,D1
    BEQ.S   .lab_03EF

    MOVE.B  D0,DATA_CTASKS_STR_L_1BB4

.lab_03EF:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03F0

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    CLR.B   -5(A5)
    PEA     -7(A5)
    JSR     GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,DATA_CTASKS_CONST_BYTE_1BB5

.lab_03F0:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03F1

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    CLR.B   -5(A5)
    PEA     -7(A5)
    JSR     GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,DATA_CTASKS_CONST_BYTE_1BB6

.lab_03F1:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03F2

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_STR_Y_1BB7
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03F2

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .lab_03F2

    MOVE.B  D0,DATA_CTASKS_STR_Y_1BB7

.lab_03F2:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03F3

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_STR_Y_1BB8
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03F3

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .lab_03F3

    MOVE.B  D0,DATA_CTASKS_STR_Y_1BB8

.lab_03F3:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03F4

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_STR_N_1BB9
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03F4

    MOVEQ   #78,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03F4

    MOVE.B  D0,DATA_CTASKS_STR_N_1BB9

.lab_03F4:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03F5

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    CLR.B   -5(A5)
    PEA     -7(A5)
    JSR     GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,DATA_CTASKS_CONST_BYTE_1BBA

.lab_03F5:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03F6

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    CLR.B   -5(A5)
    PEA     -7(A5)
    JSR     GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,DATA_CTASKS_CONST_BYTE_1BBB

.lab_03F6:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03F7

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    CLR.B   -5(A5)
    PEA     -7(A5)
    JSR     GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,DATA_CTASKS_CONST_BYTE_1BBC

.lab_03F7:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03F8

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-5(A5)
    CLR.B   -4(A5)
    PEA     -7(A5)
    JSR     GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,CONFIG_TimeWindowMinutes

.lab_03F8:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03FA

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVEQ   #0,D1
    MOVE.B  0(A3,D0.W),D1
    MOVEQ   #48,D0
    SUB.L   D0,D1
    MOVE.L  D1,DATA_CTASKS_CONST_LONG_1BBE
    MOVEQ   #1,D0
    CMP.L   D0,D1
    BLT.S   .lab_03F9

    MOVEQ   #9,D2
    CMP.L   D2,D1
    BLE.S   .lab_03FA

.lab_03F9:
    MOVE.L  D0,DATA_CTASKS_CONST_LONG_1BBE

.lab_03FA:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03FB

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    CLR.B   -5(A5)
    PEA     -7(A5)
    JSR     BRUSH_SelectBrushByLabel(PC)

    ADDQ.W  #4,A7

.lab_03FB:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03FC

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_STR_Y_1BBF
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03FC

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .lab_03FC

    MOVE.B  D0,DATA_CTASKS_STR_Y_1BBF

.lab_03FC:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_0400

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,Global_REF_STR_USE_24_HR_CLOCK
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03FD

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .lab_03FD

    MOVE.B  D2,Global_REF_STR_USE_24_HR_CLOCK

.lab_03FD:
    MOVE.B  Global_REF_STR_USE_24_HR_CLOCK,D1
    CMP.B   D0,D1
    BNE.S   .lab_03FE

    LEA     Global_JMPTBL_HALF_HOURS_24_HR_FMT,A0
    BRA.S   .lab_03FF

.lab_03FE:
    LEA     Global_JMPTBL_HALF_HOURS_12_HR_FMT,A0

.lab_03FF:
    MOVE.L  A0,Global_REF_STR_CLOCK_FORMAT

.lab_0400:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_0401

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_STR_Y_1BC1
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_0401

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .lab_0401

    MOVE.B  D0,DATA_CTASKS_STR_Y_1BC1

.lab_0401:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.W   .lab_0409

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D5
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    LEA     WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   .lab_0402

    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .lab_0403

.lab_0402:
    MOVEQ   #0,D0
    MOVE.B  D5,D0

.lab_0403:
    MOVEQ   #67,D1
    SUB.L   D1,D0
    BEQ.S   .lab_0405

    SUBQ.L  #3,D0
    BEQ.S   .lab_0404

    SUBQ.L  #2,D0
    BEQ.S   .lab_0406

    SUBQ.L  #8,D0
    BEQ.S   .lab_0406

    BRA.S   .lab_0406

.lab_0404:
    MOVE.W  #128,Global_REF_WORD_HEX_CODE_8E
    ADDQ.W  #1,D6
    BRA.S   .lab_0407

.lab_0405:
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVEQ   #0,D1
    MOVE.B  0(A3,D0.W),D1
    MOVE.W  D1,Global_REF_WORD_HEX_CODE_8E
    BRA.S   .lab_0407

.lab_0406:
    MOVE.W  #$8e,Global_REF_WORD_HEX_CODE_8E
    ADDQ.W  #1,D6

.lab_0407:
    MOVE.W  Global_REF_WORD_HEX_CODE_8E,D0
    CMPI.W  #128,D0
    BCS.S   .lab_0408

    CMPI.W  #220,D0
    BLS.S   .lab_0409

.lab_0408:
    MOVE.W  #$8e,Global_REF_WORD_HEX_CODE_8E

.lab_0409:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_040B

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVEQ   #-48,D1
    ADD.B   0(A3,D0.W),D1
    MOVE.B  D1,Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES
    MOVEQ   #8,D0
    CMP.B   D0,D1
    BLT.S   .lab_040A

    CMP.B   D0,D1
    BLE.S   .lab_040B

.lab_040A:
    MOVE.B  D0,Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES

.lab_040B:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_040F

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D5
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    LEA     WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   .lab_040C

    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .lab_040D

.lab_040C:
    MOVEQ   #0,D0
    MOVE.B  D5,D0

.lab_040D:
    MOVE.B  D0,ED_DiagTextModeChar
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     DATA_DISKIO_TAG_NRLS_1BE3
    JSR     GROUP_AI_JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .lab_040E

    MOVE.B  ED_DiagTextModeChar,D0
    TST.B   D0
    BNE.S   .lab_040F

.lab_040E:
    MOVEQ   #78,D0
    MOVE.B  D0,ED_DiagTextModeChar

.lab_040F:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_0410

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_STR_N_1BC5
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_0410

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .lab_0410

    MOVE.B  D2,DATA_CTASKS_STR_N_1BC5

.lab_0410:
    MOVE.B  DATA_CTASKS_STR_N_1BC5,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .lab_0411

    BSR.W   DISKIO_EnsurePc1MountedAndGfxAssigned

.lab_0411:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_0413

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_STR_N_1BC6
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    PEA     DATA_DISKIO_TAG_LRBN_1BE4
    JSR     GROUP_AI_JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .lab_0412

    MOVE.B  DATA_CTASKS_STR_N_1BC6,D0
    TST.B   D0
    BNE.S   .lab_0413

.lab_0412:
    MOVEQ   #78,D0
    MOVE.B  D0,DATA_CTASKS_STR_N_1BC6

.lab_0413:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_0415

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,CONFIG_LRBN_FlagChar
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_0414

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .lab_0414

    MOVE.B  D0,CONFIG_LRBN_FlagChar

.lab_0414:
    MOVE.B  CONFIG_LRBN_FlagChar,D1
    CMP.B   D0,D1
    BEQ.S   .lab_0415

    MOVE.B  D0,CONFIG_LRBN_FlagChar
    MOVE.W  Global_REF_WORD_HEX_CODE_8E,D0
    EXT.L   D0
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUP_AG_JMPTBL_SCRIPT_BeginBannerCharTransition(PC)

    ADDQ.W  #8,A7
    MOVE.B  #$4e,CONFIG_LRBN_FlagChar

.lab_0415:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_0416

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,CONFIG_MSN_FlagChar
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    PEA     DATA_DISKIO_TAG_MSN_1BE5
    JSR     GROUP_AI_JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .lab_0416

    MOVE.B  #'N',CONFIG_MSN_FlagChar

.lab_0416:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .return

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,DATA_CTASKS_STR_1_1BC9
    MOVEQ   #49,D0
    CMP.B   D0,D1
    BEQ.S   .return

    MOVEQ   #50,D2
    CMP.B   D2,D1
    BEQ.S   .return

    MOVE.B  D0,DATA_CTASKS_STR_1_1BC9

.return:
    MOVE.B  DATA_CTASKS_CONST_BYTE_1BA2,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    JSR     GROUP_AG_JMPTBL_ESQFUNC_UpdateRefreshModeState(PC)

    MOVE.B  DATA_CTASKS_CONST_BYTE_1BA2,D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #60,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,DATA_CTASKS_CONST_LONG_1BCA
    MOVEM.L -28(A5),D2/D5-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO_EnsurePc1MountedAndGfxAssigned   (Routine at DISKIO_EnsurePc1MountedAndGfxAssigned)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A6/A7/D1/D2/D3
; CALLS:
;   _LVOExecute
; READS:
;   Global_REF_DOS_LIBRARY_2, DATA_DISKIO_BSS_WORD_1BE6, DISKIO_CMD_MOUNT_PC1, DISKIO_CMD_ASSIGN_GFX_PC1_EXPLICIT
; WRITES:
;   DATA_DISKIO_BSS_WORD_1BE6
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_EnsurePc1MountedAndGfxAssigned:
    MOVEM.L D2-D3,-(A7)
    TST.W   DATA_DISKIO_BSS_WORD_1BE6
    BNE.S   DISKIO_EnsurePc1MountedAndGfxAssigned_Return

    MOVE.W  #1,DATA_DISKIO_BSS_WORD_1BE6
    LEA     DISKIO_CMD_MOUNT_PC1,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     DISKIO_CMD_ASSIGN_GFX_PC1_EXPLICIT,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

;------------------------------------------------------------------------------
; FUNC: DISKIO_EnsurePc1MountedAndGfxAssigned_Return   (Routine at DISKIO_EnsurePc1MountedAndGfxAssigned_Return)
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
DISKIO_EnsurePc1MountedAndGfxAssigned_Return:
    MOVEM.L (A7)+,D2-D3
    RTS

;!======

; perhaps dealing with loading or saving configuration?
;------------------------------------------------------------------------------
; FUNC: DISKIO_SaveConfigToFileHandle   (Routine at DISKIO_SaveConfigToFileHandle)
; ARGS:
;   stack +54: arg_1 (via 58(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   DISKIO_OpenFileWithBuffer, GROUP_AE_JMPTBL_WDISP_SPrintf, DISKIO_CloseBufferedFileAndFlush, DISKIO_WriteBufferedBytes
; READS:
;   BRUSH_LabelScratch, Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES, Global_REF_STR_USE_24_HR_CLOCK, Global_REF_WORD_HEX_CODE_8E, Global_STR_DEFAULT_CONFIG_FORMATTED, Global_STR_DF0_CONFIG_DAT_1, DISKIO_SaveConfigToFileHandle_Return, DATA_CTASKS_CONST_BYTE_1BA2, DATA_CTASKS_STR_C_1BA3, DATA_CTASKS_BSS_BYTE_1BA4, DATA_CTASKS_CONST_BYTE_1BA5, DATA_CTASKS_CONST_BYTE_1BA6, DATA_CTASKS_CONST_BYTE_1BA7, DATA_CTASKS_STR_G_1BA8, DATA_CTASKS_STR_N_1BA9, DATA_CTASKS_STR_A_1BAA, DATA_CTASKS_STR_E_1BAB, DATA_CTASKS_BSS_BYTE_1BAC, DATA_CTASKS_BSS_BYTE_1BAD, DATA_CTASKS_STR_Y_1BAE, DATA_CTASKS_STR_Y_1BAF, DATA_CTASKS_STR_N_1BB0, DATA_CTASKS_STR_N_1BB1, DATA_CTASKS_STR_Y_1BB2, DATA_CTASKS_STR_N_1BB3, DATA_CTASKS_STR_L_1BB4, DATA_CTASKS_CONST_BYTE_1BB5, DATA_CTASKS_CONST_BYTE_1BB6, DATA_CTASKS_STR_Y_1BB7, DATA_CTASKS_STR_Y_1BB8, DATA_CTASKS_STR_N_1BB9, DATA_CTASKS_CONST_BYTE_1BBA, DATA_CTASKS_CONST_BYTE_1BBB, DATA_CTASKS_CONST_BYTE_1BBC, CONFIG_TimeWindowMinutes, DATA_CTASKS_CONST_LONG_1BBE, DATA_CTASKS_STR_Y_1BBF, DATA_CTASKS_STR_Y_1BC1, ED_DiagTextModeChar, DATA_CTASKS_STR_N_1BC5, DATA_CTASKS_STR_N_1BC6, CONFIG_LRBN_FlagChar, CONFIG_MSN_FlagChar, DATA_CTASKS_STR_1_1BC9, MODE_NEWFILE
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_SaveConfigToFileHandle:
    LINK.W  A5,#-212
    MOVEM.L D2-D7,-(A7)
    PEA     MODE_NEWFILE.W
    PEA     Global_STR_DF0_CONFIG_DAT_1
    BSR.W   DISKIO_OpenFileWithBuffer

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BNE.S   .lab_041B

    MOVEQ   #-1,D0
    BRA.W   DISKIO_SaveConfigToFileHandle_Return

.lab_041B:
    MOVEQ   #67,D6
    MOVEQ   #0,D0
    MOVE.W  Global_REF_WORD_HEX_CODE_8E,D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVE.L  D0,D5
    MOVE.B  DATA_CTASKS_CONST_BYTE_1BA2,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.B  DATA_CTASKS_STR_C_1BA3,D1
    EXT.W   D1
    EXT.L   D1
    MOVE.B  DATA_CTASKS_BSS_BYTE_1BA4,D2
    EXT.W   D2
    EXT.L   D2
    MOVE.B  DATA_CTASKS_CONST_BYTE_1BA5,D3
    EXT.W   D3
    EXT.L   D3
    MOVE.B  DATA_CTASKS_CONST_BYTE_1BA6,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,40(A7)
    MOVE.B  DATA_CTASKS_CONST_BYTE_1BA7,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,44(A7)
    MOVE.B  DATA_CTASKS_STR_G_1BA8,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,48(A7)
    MOVE.B  DATA_CTASKS_STR_N_1BA9,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,52(A7)
    MOVE.B  DATA_CTASKS_STR_A_1BAA,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,56(A7)
    MOVE.B  DATA_CTASKS_STR_E_1BAB,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,60(A7)
    MOVE.B  DATA_CTASKS_BSS_BYTE_1BAC,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,64(A7)
    MOVE.B  DATA_CTASKS_BSS_BYTE_1BAD,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,68(A7)
    MOVE.B  DATA_CTASKS_STR_Y_1BAE,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,72(A7)
    MOVE.B  DATA_CTASKS_STR_Y_1BAF,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,76(A7)
    MOVE.B  DATA_CTASKS_STR_N_1BB0,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,80(A7)
    MOVE.B  DATA_CTASKS_STR_N_1BB1,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,84(A7)
    MOVE.B  DATA_CTASKS_STR_Y_1BB2,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,88(A7)
    MOVE.B  DATA_CTASKS_STR_N_1BB3,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,92(A7)
    MOVE.B  DATA_CTASKS_STR_L_1BB4,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,96(A7)
    MOVE.B  DATA_CTASKS_CONST_BYTE_1BB5,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,100(A7)
    MOVE.B  DATA_CTASKS_CONST_BYTE_1BB6,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,104(A7)
    MOVE.B  DATA_CTASKS_STR_Y_1BB7,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,108(A7)
    MOVE.B  DATA_CTASKS_STR_Y_1BB8,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,112(A7)
    MOVE.B  DATA_CTASKS_STR_N_1BB9,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,116(A7)
    MOVE.B  DATA_CTASKS_CONST_BYTE_1BBA,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,120(A7)
    MOVE.B  DATA_CTASKS_CONST_BYTE_1BBB,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,124(A7)
    MOVE.B  DATA_CTASKS_CONST_BYTE_1BBC,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,128(A7)
    MOVE.B  DATA_CTASKS_STR_Y_1BBF,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,132(A7)
    MOVE.B  Global_REF_STR_USE_24_HR_CLOCK,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,136(A7)
    MOVE.B  DATA_CTASKS_STR_Y_1BC1,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,140(A7)
    MOVE.L  D6,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,144(A7)
    MOVE.L  D5,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,148(A7)
    MOVE.B  Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,152(A7)
    MOVE.B  ED_DiagTextModeChar,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,156(A7)
    MOVE.B  DATA_CTASKS_STR_N_1BC5,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,160(A7)
    MOVE.B  DATA_CTASKS_STR_N_1BC6,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,164(A7)
    MOVE.B  CONFIG_LRBN_FlagChar,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,168(A7)
    MOVE.B  CONFIG_MSN_FlagChar,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,172(A7)
    MOVE.B  DATA_CTASKS_STR_1_1BC9,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    PEA     BRUSH_LabelScratch
    MOVE.L  DATA_CTASKS_CONST_LONG_1BBE,-(A7)
    MOVE.L  CONFIG_TimeWindowMinutes,-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_DEFAULT_CONFIG_FORMATTED
    PEA     -58(A5)
    JSR     GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     176(A7),A7
    PEA     52.W
    PEA     -58(A5)
    MOVE.L  D7,-(A7)
    BSR.W   DISKIO_WriteBufferedBytes

    MOVE.L  D7,(A7)
    BSR.W   DISKIO_CloseBufferedFileAndFlush

;------------------------------------------------------------------------------
; FUNC: DISKIO_SaveConfigToFileHandle_Return   (Routine at DISKIO_SaveConfigToFileHandle_Return)
; ARGS:
;   stack +232: arg_1 (via 236(A5))
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
DISKIO_SaveConfigToFileHandle_Return:
    MOVEM.L -236(A5),D2-D7
    UNLK    A5
    RTS

;!======

; Load the configuration
;------------------------------------------------------------------------------
; FUNC: DISKIO_LoadConfigFromDisk   (Routine at DISKIO_LoadConfigFromDisk)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A5/A7/D0/D6/D7
; CALLS:
;   GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, DISKIO_LoadFileToWorkBuffer, DISKIO_ParseConfigBuffer
; READS:
;   Global_REF_LONG_FILE_SCRATCH, Global_STR_DF0_CONFIG_DAT_2, Global_STR_DISKIO_C_9, Global_PTR_WORK_BUFFER
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_LoadConfigFromDisk:
    LINK.W  A5,#-12
    MOVEM.L D6-D7,-(A7)

    PEA     Global_STR_DF0_CONFIG_DAT_2
    BSR.W   DISKIO_LoadFileToWorkBuffer

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BNE.S   .lab_041E

    MOVEQ   #-1,D6
    BRA.S   .return

.lab_041E:
    MOVE.L  Global_REF_LONG_FILE_SCRATCH,D7
    MOVEA.L Global_PTR_WORK_BUFFER,A0
    MOVE.L  Global_REF_LONG_FILE_SCRATCH,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-4(A5)
    BSR.W   DISKIO_ParseConfigBuffer

    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     1344.W
    PEA     Global_STR_DISKIO_C_9
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D6

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS
