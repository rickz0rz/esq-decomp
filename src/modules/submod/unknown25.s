LAB_1A2F:
    MOVEM.L A3/A6,-(A7)
    MOVEA.L 12(A7),A3

    MOVE.B  #$ff,8(A3)
    MOVEA.W #$ffff,A0
    MOVE.L  A0,20(A3)
    MOVE.L  A0,24(A3)
    MOVEQ   #0,D0

    ; This must be pointing to a property in a struct?
    MOVE.W  18(A3),D0
    MOVEA.L A3,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOFreeMem(A6)

    MOVEM.L (A7)+,A3/A6
    RTS

;!======

; dynamically allocate memory
LAB_1A30:
    MOVEM.L D7/A2-A3/A6,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.L  24(A7),D7
    MOVE.L  A3,D0
    BNE.S   .LAB_1A31

    MOVEQ   #0,D0
    BRA.S   .return

.LAB_1A31:
    MOVE.L  D7,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAllocMem(A6)

    MOVEA.L D0,A2
    MOVE.L  A2,D0
    BEQ.S   .failedToAllocateMemory

    MOVE.B  #$5,8(A2)
    CLR.B   9(A2)
    MOVE.L  A3,14(A2)
    MOVE.L  D7,D0
    MOVE.W  D0,18(A2)

.failedToAllocateMemory:
    MOVE.L  A2,D0

.return:
    MOVEM.L (A7)+,D7/A2-A3/A6
    RTS

;!======

    ; Alignment
    ALIGN_WORD
