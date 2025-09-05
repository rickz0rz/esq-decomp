DEALLOCATE_MEMORY:
    LINK.W  A5,#0
    MOVEM.L D7/A3,-(A7)

    MOVEA.L 16(A5),A3
    MOVE.L  20(A5),D7

    MOVE.L  A3,D0
    BEQ.S   .return

    TST.L   D7
    BEQ.S   .return

    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOFreeMem(A6)

    SUB.L   D7,GLOB_BYTES_ALLOCATED
    ADDQ.L  #1,GLOB_DEALLOCATIONS

.return:
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS
