    XDEF    _NEWGRID2_FreeBuffersIfAllocated


;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_FreeBuffersIfAllocated   (Free grid buffers)
; ARGS:
;   none
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/A0-A1
; CALLS:
;   _SCRIPT_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _NEWGRID_EntryTextScratchPtr, _NEWGRID_SecondaryIndexCachePtr
; WRITES:
;   _NEWGRID_EntryTextScratchPtr, _NEWGRID_SecondaryIndexCachePtr
; DESC:
;   Frees any allocated grid buffers and clears stored pointers.
; NOTES:
;   Uses _NEWGRID_EntryTextScratchPtr as the gate before freeing both buffers.
;------------------------------------------------------------------------------
_NEWGRID2_FreeBuffersIfAllocated:
    TST.L   _NEWGRID_EntryTextScratchPtr
    BEQ.S   .buffers_already_freed

    PEA     1000.W
    MOVE.L  _NEWGRID_EntryTextScratchPtr,-(A7)
    PEA     4164.W
    PEA     _Global_STR_NEWGRID2_C_5
    JSR     _SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

    CLR.L   _NEWGRID_EntryTextScratchPtr
    PEA     1208.W
    MOVE.L  _NEWGRID_SecondaryIndexCachePtr,-(A7)
    PEA     4167.W
    PEA     Global_STR_NEWGRID2_C_6
    JSR     _SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     32(A7),A7
    CLR.L   _NEWGRID_SecondaryIndexCachePtr

.buffers_already_freed:
    RTS

;!======