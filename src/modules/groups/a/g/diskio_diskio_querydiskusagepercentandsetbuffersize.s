    XDEF    _DISKIO_QueryDiskUsagePercentAndSetBufferSize


;------------------------------------------------------------------------------
; FUNC: _DISKIO_QueryDiskUsagePercentAndSetBufferSize   (Routine at _DISKIO_QueryDiskUsagePercentAndSetBufferSize)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A5/A6/A7/D0/D1/D2/D6/D7
; CALLS:
;   _GROUP_AG_JMPTBL_MATH_DivS32, _GROUP_AG_JMPTBL_MATH_Mulu32, _GROUP_AG_JMPTBL_MEMORY_AllocateMemory, _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, _LVOInfo, _LVOLock, _LVOUnLock
; READS:
;   Global_REF_DOS_LIBRARY_2, _Global_STR_DISKIO_C_5, _Global_STR_DISKIO_C_6, MEMF_CLEAR, Struct_InfoData_Size
; WRITES:
;   _DISKIO_BufferState, Struct_DiskIoBufferState__BufferSize
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_DISKIO_QueryDiskUsagePercentAndSetBufferSize:
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
    PEA     _Global_STR_DISKIO_C_5
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

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
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  12(A0),D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D0,D7
    MOVE.L  20(A0),D0
    ADD.L   D0,D0
    MOVE.L  D0,_DISKIO_BufferState+Struct_DiskIoBufferState__BufferSize

.lab_03C1:
    PEA     Struct_InfoData_Size.W
    MOVE.L  D2,-(A7)
    PEA     574.W
    PEA     _Global_STR_DISKIO_C_6
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

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