    XDEF    _DISKIO_ConsumeCStringFromWorkBuffer


;------------------------------------------------------------------------------
; FUNC: _DISKIO_ConsumeCStringFromWorkBuffer   (Routine at _DISKIO_ConsumeCStringFromWorkBuffer)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A5/D0
; CALLS:
;   (none)
; READS:
;   _Global_REF_LONG_FILE_SCRATCH, _Global_PTR_WORK_BUFFER, ffff
; WRITES:
;   _Global_REF_LONG_FILE_SCRATCH, _Global_PTR_WORK_BUFFER
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_DISKIO_ConsumeCStringFromWorkBuffer:
    LINK.W  A5,#-4
    MOVE.L  _Global_PTR_WORK_BUFFER,-4(A5)

.lab_03B3:
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D0
    SUBQ.L  #1,_Global_REF_LONG_FILE_SCRATCH
    TST.L   D0
    BLE.S   .lab_03B4

    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    MOVE.B  (A0)+,D0
    MOVE.L  A0,_Global_PTR_WORK_BUFFER
    TST.B   D0
    BNE.S   .lab_03B3

.lab_03B4:
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D0
    TST.L   D0
    BPL.S   .lab_03B5

    MOVEA.W #$ffff,A0
    MOVE.L  A0,-4(A5)

.lab_03B5:
    MOVE.L  -4(A5),D0
    UNLK    A5
    RTS

;!======