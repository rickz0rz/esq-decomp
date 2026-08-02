    XDEF    _DISKIO_QueryVolumeSoftErrorCount



;------------------------------------------------------------------------------
; FUNC: _DISKIO_QueryVolumeSoftErrorCount   (Routine at _DISKIO_QueryVolumeSoftErrorCount)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A5/A6/A7/D0/D1/D2/D6/D7
; CALLS:
;   _GROUP_AG_JMPTBL_MEMORY_AllocateMemory, _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, _LVOInfo, _LVOLock, _LVOUnLock
; READS:
;   _Global_REF_DOS_LIBRARY_2, _Global_STR_DISKIO_C_7, _Global_STR_DISKIO_C_8, MEMF_CLEAR, Struct_InfoData_Size
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_DISKIO_QueryVolumeSoftErrorCount:
    LINK.W  A5,#-12
    MOVEM.L D2/D6-D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEQ   #0,D7
    MOVE.L  A3,D1
    MOVEQ   #-2,D2
    MOVEA.L _Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOLock(A6)

    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   .return

    MOVE.L  #(MEMF_CLEAR),-(A7)
    PEA     Struct_InfoData_Size.W
    PEA     593.W
    PEA     _Global_STR_DISKIO_C_7
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.S   .lab_03C6

    MOVE.L  D6,D1
    MOVE.L  D0,D2
    MOVEA.L _Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOInfo(A6)

    TST.L   D0
    BEQ.S   .lab_03C5

    MOVEA.L D2,A0
    MOVE.L  (A0),D7

.lab_03C5:
    PEA     Struct_InfoData_Size.W
    MOVE.L  D2,-(A7)
    PEA     599.W
    PEA     _Global_STR_DISKIO_C_8
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.lab_03C6:
    MOVE.L  D6,D1
    MOVEA.L _Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOUnLock(A6)

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D2/D6-D7/A3
    UNLK    A5
    RTS

;!======