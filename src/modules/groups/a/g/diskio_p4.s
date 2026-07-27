    XDEF    _DISKIO_QueryVolumeSoftErrorCount
    XDEF    DISKIO_WriteBytesToOutputHandleGuarded


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
;   Global_REF_DOS_LIBRARY_2, Global_STR_DISKIO_C_7, Global_STR_DISKIO_C_8, MEMF_CLEAR, Struct_InfoData_Size
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
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOLock(A6)

    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   .return

    MOVE.L  #(MEMF_CLEAR),-(A7)
    PEA     Struct_InfoData_Size.W
    PEA     593.W
    PEA     Global_STR_DISKIO_C_7
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

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
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

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
;   Global_REF_DOS_LIBRARY_2, _ESQPARS2_ReadModeFlags, DISKIO_WriteFileHandle, DISKIO_SavedReadModeFlags
; WRITES:
;   _ESQPARS2_ReadModeFlags, DISKIO_SavedReadModeFlags
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_WriteBytesToOutputHandleGuarded:
    MOVEM.L D2-D3/D6-D7/A3,-(A7)

    MOVEA.L 24(A7),A3
    MOVE.W  30(A7),D7
    MOVE.W  _ESQPARS2_ReadModeFlags,DISKIO_SavedReadModeFlags
    MOVE.W  #$100,_ESQPARS2_ReadModeFlags
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  A3,D2
    MOVE.L  D0,D3
    MOVE.L  DISKIO_WriteFileHandle,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOWrite(A6)

    MOVE.L  D0,D6
    CMP.W   D7,D6
    MOVE.W  DISKIO_SavedReadModeFlags,_ESQPARS2_ReadModeFlags
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