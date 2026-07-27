    XDEF    _DISKIO_LoadFileToWorkBuffer


; Load a file into memory?
;------------------------------------------------------------------------------
; FUNC: _DISKIO_LoadFileToWorkBuffer   (Routine at _DISKIO_LoadFileToWorkBuffer)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A6/A7/D0/D1/D2/D3/D7
; CALLS:
;   _GROUP_AG_JMPTBL_MEMORY_AllocateMemory, _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, GROUP_AG_JMPTBL_DOS_OpenFileWithMode, _LVOClose, _LVORead
; READS:
;   Global_REF_DOS_LIBRARY_2, _Global_REF_LONG_FILE_SCRATCH, Global_STR_DISKIO_C_3, Global_STR_DISKIO_C_4, _Global_PTR_WORK_BUFFER, MEMF_CLEAR, MEMF_PUBLIC, MODE_OLDFILE, return
; WRITES:
;   _Global_REF_LONG_FILE_SCRATCH, _Global_PTR_WORK_BUFFER
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_DISKIO_LoadFileToWorkBuffer:
    MOVEM.L D2-D3/D7/A3,-(A7)

    SetOffsetForStack 4
    UseStackLong    MOVEA.L,1,A3

    ; Open the filename in A3
    PEA     (MODE_OLDFILE).W
    MOVE.L  A3,-(A7)
    JSR     GROUP_AG_JMPTBL_DOS_OpenFileWithMode(PC)

    ADDQ.W  #8,A7

    MOVE.L  D0,D7
    TST.L   D7
    BNE.S   .successfullyOpenedFile

    MOVEQ   #-1,D0
    BRA.W   .return

.successfullyOpenedFile:
    MOVE.L  D7,-(A7)
    BSR.S   _DISKIO_GetFilesizeFromHandle

    ADDQ.W  #4,A7
    MOVE.L  D0,_Global_REF_LONG_FILE_SCRATCH
    TST.L   D0
    BGT.S   .lab_03AE

    MOVE.L  D7,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

    MOVEQ   #-1,D0
    BRA.W   .return

.lab_03AE:
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D0
    ADDQ.L  #1,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     472.W
    PEA     Global_STR_DISKIO_C_3
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,_Global_PTR_WORK_BUFFER
    TST.L   D0
    BNE.S   .lab_03AF

    MOVE.L  D7,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

    MOVEQ   #-1,D0
    BRA.S   .return

.lab_03AF:
    MOVE.L  D7,D1
    MOVE.L  _Global_PTR_WORK_BUFFER,D2
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVORead(A6)

    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D1
    CMP.L   D1,D0
    BEQ.S   .lab_03B0

    ADDQ.L  #1,D1
    MOVE.L  D1,-(A7)
    MOVE.L  _Global_PTR_WORK_BUFFER,-(A7)
    PEA     492.W
    PEA     Global_STR_DISKIO_C_4
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D7,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

    MOVEQ   #-1,D0
    BRA.S   .return

.lab_03B0:
    MOVE.L  D7,D1
    JSR     _LVOClose(A6)

    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D0

.return:
    MOVEM.L (A7)+,D2-D3/D7/A3
    RTS

;!======