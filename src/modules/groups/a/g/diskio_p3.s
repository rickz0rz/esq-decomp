    XDEF    DISKIO_ConsumeLineFromWorkBuffer


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
;   _Global_REF_LONG_FILE_SCRATCH, _Global_PTR_WORK_BUFFER
; WRITES:
;   _Global_REF_LONG_FILE_SCRATCH, _Global_PTR_WORK_BUFFER
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_ConsumeLineFromWorkBuffer:
    LINK.W  A5,#-4
    MOVE.L  _Global_PTR_WORK_BUFFER,-4(A5)

.lab_03BA:
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D0
    SUBQ.L  #1,_Global_REF_LONG_FILE_SCRATCH
    TST.L   D0
    BLE.S   .lab_03BB

    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    MOVE.B  (A0),D0
    MOVEQ   #13,D1
    CMP.B   D1,D0
    BEQ.S   .lab_03BB

    MOVEQ   #10,D1
    CMP.B   D1,D0
    BEQ.S   .lab_03BB

    ADDQ.L  #1,_Global_PTR_WORK_BUFFER
    BRA.S   .lab_03BA

.lab_03BB:
    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    CLR.B   (A0)+
    MOVE.L  A0,_Global_PTR_WORK_BUFFER
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D0
    TST.L   D0
    BPL.S   .lab_03BC

    MOVEA.W #(-1),A0
    MOVE.L  A0,D0
    BRA.S   .lab_03BF

.lab_03BC:
    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    MOVE.B  (A0),D0
    MOVEQ   #13,D1
    CMP.B   D1,D0
    BEQ.S   .lab_03BD

    MOVEQ   #10,D1
    CMP.B   D1,D0
    BNE.S   .lab_03BE

.lab_03BD:
    ADDQ.L  #1,_Global_PTR_WORK_BUFFER
    SUBQ.L  #1,_Global_REF_LONG_FILE_SCRATCH
    BRA.S   .lab_03BC

.lab_03BE:
    MOVE.L  -4(A5),D0

.lab_03BF:
    UNLK    A5
    RTS

;!======