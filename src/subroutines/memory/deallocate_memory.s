;------------------------------------------------------------------------------
; FUNC: DEALLOCATE_MEMORY   (DeallocateMemory??)
; ARGS:
;   stack +16: memoryBlock (loaded into A3)
;   stack +20: byteSize (loaded into D7)
; RET:
;   D0: none
; CLOBBERS:
;   D0/D1/D7/A1/A3/A6
; CALLS:
;   exec.library FreeMem
; READS:
;   (none)
; WRITES:
;   GLOB_MEM_BYTES_ALLOCATED, GLOB_MEM_DEALLOC_COUNT
; DESC:
;   Frees a memory block via Exec FreeMem when ptr and size are non-zero.
; NOTES:
;   Counters are updated only when both ptr and size are non-zero.
;------------------------------------------------------------------------------
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

    SUB.L   D7,GLOB_MEM_BYTES_ALLOCATED
    ADDQ.L  #1,GLOB_MEM_DEALLOC_COUNT

.return:
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS
