    XDEF    _DISKIO_WriteBufferedBytes
    XDEF    DISKIO_WriteBufferedBytes_Return


;------------------------------------------------------------------------------
; FUNC: _DISKIO_WriteBufferedBytes   (Routine at _DISKIO_WriteBufferedBytes)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A6/A7/D0/D1/D2/D3/D4/D5/D6
; CALLS:
;   _GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning, _LVOWrite
; READS:
;   _DISKIO_BufferControl, _DISKIO_BufferState, Global_REF_DOS_LIBRARY_2, Struct_DiskIoBufferControl__BufferBase, Struct_DiskIoBufferControl__ErrorFlag, Struct_DiskIoBufferState__BufferPtr, Struct_DiskIoBufferState__BufferSize, Struct_DiskIoBufferState__Remaining
; WRITES:
;   _DISKIO_BufferControl, _DISKIO_BufferState, Struct_DiskIoBufferControl__ErrorFlag, Struct_DiskIoBufferState__BufferPtr, Struct_DiskIoBufferState__Remaining
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_DISKIO_WriteBufferedBytes:
    MOVEM.L D2-D7/A3,-(A7)

    SetOffsetForStack 7
    UseStackLong    MOVE.L,1,D7     ; Value DISKIO2_OutputFileHandle
    UseStackLong    MOVEA.L,2,A3    ; Address _ESQ_STR_B
    UseStackLong    MOVE.L,3,D6     ; 21

    MOVE.L  D6,D5
    MOVE.L  D6,D4
    MOVE.L  A3,D0
    BEQ.S   .lab_03A1

    TST.L   D6
    BEQ.S   .lab_03A1

    MOVEQ   #1,D0
    CMP.L   _DISKIO_BufferControl+Struct_DiskIoBufferControl__ErrorFlag,D0
    BEQ.S   .lab_03A1

    TST.L   D7
    BNE.S   .lab_03A2

.lab_03A1:
    MOVEQ   #0,D0
    BRA.S   DISKIO_WriteBufferedBytes_Return

.lab_03A2:
    JSR     _GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(PC)

.lab_03A3:
    MOVEA.L _DISKIO_BufferState+Struct_DiskIoBufferState__BufferPtr,A0
    MOVE.B  (A3)+,(A0)+
    MOVE.L  A0,_DISKIO_BufferState+Struct_DiskIoBufferState__BufferPtr
    SUBQ.L  #1,_DISKIO_BufferState+Struct_DiskIoBufferState__Remaining
    SUBQ.L  #1,D6
    MOVE.L  A0,_DISKIO_BufferState+Struct_DiskIoBufferState__BufferPtr
    TST.L   _DISKIO_BufferState+Struct_DiskIoBufferState__Remaining
    BEQ.S   .lab_03A4

    TST.L   D6
    BNE.S   .lab_03A3

.lab_03A4:
    JSR     _GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(PC)

    TST.L   _DISKIO_BufferState+Struct_DiskIoBufferState__Remaining
    BNE.S   .lab_03A6

    MOVE.L  D7,D1
    MOVE.L  _DISKIO_BufferControl+Struct_DiskIoBufferControl__BufferBase,D2
    MOVE.L  _DISKIO_BufferState+Struct_DiskIoBufferState__BufferSize,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOWrite(A6)

    MOVE.L  D0,D5
    CMP.L   D3,D5
    BEQ.S   .lab_03A5

    MOVEQ   #1,D0
    MOVE.L  D0,_DISKIO_BufferControl+Struct_DiskIoBufferControl__ErrorFlag
    BRA.S   .lab_03A7

.lab_03A5:
    MOVE.L  D4,D5
    MOVE.L  D2,_DISKIO_BufferState+Struct_DiskIoBufferState__BufferPtr
    MOVE.L  D3,_DISKIO_BufferState+Struct_DiskIoBufferState__Remaining
    JSR     _GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(PC)

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