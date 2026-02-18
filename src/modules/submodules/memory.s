    XDEF    MEMORY_AllocateMemory
    XDEF    MEMORY_DeallocateMemory

;------------------------------------------------------------------------------
; FUNC: MEMORY_AllocateMemory   (AllocateMemoryuncertain)
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
;   Global_MEM_BYTES_ALLOCATED, Global_MEM_ALLOC_COUNT
; DESC:
;   Allocates a memory block via Exec AllocMem and updates global counters.
; NOTES:
;   Counters are incremented regardless of allocation success.
;------------------------------------------------------------------------------
MEMORY_AllocateMemory:
    LINK.W  A5,#-4
    MOVEM.L D6-D7,-(A7)

    MOVE.L  16(A5),D7
    MOVE.L  20(A5),D6

    MOVE.L  D7,D0
    MOVE.L  D6,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAllocMem(A6)

    ADD.L   D7,Global_MEM_BYTES_ALLOCATED
    ADDQ.L  #1,Global_MEM_ALLOC_COUNT

    MOVEM.L (A7)+,D6-D7
    UNLK    A5

    RTS

;------------------------------------------------------------------------------
; FUNC: MEMORY_DeallocateMemory   (DeallocateMemoryuncertain)
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
;   Global_MEM_BYTES_ALLOCATED, Global_MEM_DEALLOC_COUNT
; DESC:
;   Frees a memory block via Exec FreeMem when ptr and size are non-zero.
; NOTES:
;   Counters are updated only when both ptr and size are non-zero.
;------------------------------------------------------------------------------
MEMORY_DeallocateMemory:
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

    SUB.L   D7,Global_MEM_BYTES_ALLOCATED
    ADDQ.L  #1,Global_MEM_DEALLOC_COUNT

.return:
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

    RTS

;!======

; Useful memory constants.
MEMF_ANY       = 0
MEMF_PUBLIC    = 1
MEMF_CHIP      = 2
MEMF_FAST      = 4
MEMF_LOCAL     = 256
MEMF_24BITDMA  = 512
MEMF_KICK      = 1024
MEMF_CLEAR     = 65536
MEMF_LARGEST   = 131072
MEMF_REVERSE   = 262144
MEMF_TOTAL     = 524288
