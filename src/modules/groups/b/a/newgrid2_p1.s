    XDEF    _NEWGRID2_EnsureBuffersAllocated


;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_EnsureBuffersAllocated   (Allocate grid buffers on demand)
; ARGS:
;   none
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/A0-A1
; CALLS:
;   _SCRIPT_JMPTBL_MEMORY_AllocateMemory, _NEWGRID_RebuildIndexCache
; READS:
;   _NEWGRID2_BufferAllocationFlag
; WRITES:
;   _NEWGRID_SecondaryIndexCachePtr, _NEWGRID_EntryTextScratchPtr, _NEWGRID2_BufferAllocationFlag
; DESC:
;   Allocates the grid backing buffers when the request flag is set.
; NOTES:
;   Allocates 1208-byte index cache plus 1000-byte text scratch, then clears
;   _NEWGRID2_BufferAllocationFlag to mark allocation complete.
;------------------------------------------------------------------------------
_NEWGRID2_EnsureBuffersAllocated:
    TST.L   _NEWGRID2_BufferAllocationFlag
    BEQ.S   .buffers_already_ready

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     1208.W
    PEA     4153.W
    PEA     _Global_STR_NEWGRID2_C_3
    JSR     _SCRIPT_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVE.L  D0,_NEWGRID_SecondaryIndexCachePtr
    ; Rebuild secondary index cache immediately after allocation.
    BSR.W   _NEWGRID_RebuildIndexCache

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    PEA     1000.W
    PEA     4156.W
    PEA     _Global_STR_NEWGRID2_C_4
    JSR     _SCRIPT_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     28(A7),A7
    CLR.L   _NEWGRID2_BufferAllocationFlag
    MOVE.L  D0,_NEWGRID_EntryTextScratchPtr

.buffers_already_ready:
    RTS

;!======