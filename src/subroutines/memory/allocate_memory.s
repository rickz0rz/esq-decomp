;------------------------------------------------------------------------------
; FUNC: ALLOCATE_MEMORY   (AllocateMemory??)
; ARGS:
;   stack +16: byteSize (loaded into D7)
;   stack +20: attributes (MEMF_* flags) (loaded into D6)
; RET:
;   D0: allocated pointer to a memoryBlock or 0
; CLOBBERS:
;   D0/D1/D6/D7/A6
; CALLS:
;   exec.library AllocMem
; READS:
;   (none)
; WRITES:
;   GLOB_MEM_BYTES_ALLOCATED, GLOB_MEM_ALLOC_COUNT
; DESC:
;   Allocates a memory block via Exec AllocMem and updates global counters.
; NOTES:
;   Counters are incremented regardless of allocation success.
;------------------------------------------------------------------------------
ALLOCATE_MEMORY:
    LINK.W  A5,#-4
    MOVEM.L D6-D7,-(A7)

    MOVE.L  16(A5),D7
    MOVE.L  20(A5),D6

    MOVE.L  D7,D0
    MOVE.L  D6,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAllocMem(A6)

    ADD.L   D7,GLOB_MEM_BYTES_ALLOCATED
    ADDQ.L  #1,GLOB_MEM_ALLOC_COUNT

    MOVEM.L (A7)+,D6-D7
    UNLK    A5

    RTS
