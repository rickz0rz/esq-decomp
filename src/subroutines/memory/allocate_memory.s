ALLOCATE_MEMORY:
    LINK.W  A5,#-4
    MOVEM.L D6-D7,-(A7)

    MOVE.L  16(A5),D7
    MOVE.L  20(A5),D6

    MOVE.L  D7,D0               ; Number of bytes
    MOVE.L  D6,D1               ; Attributes
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAllocMem(A6)    ; D0 gets set to a pointer to the mem block or zero if it fails

    ADD.L   D7,GLOB_BYTES_ALLOCATED
    ADDQ.L  #1,GLOB_ALLOCATIONS

    MOVEM.L (A7)+,D6-D7
    UNLK    A5

    RTS
