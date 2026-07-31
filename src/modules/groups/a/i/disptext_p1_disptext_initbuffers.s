    XDEF    _DISPTEXT_InitBuffers


;------------------------------------------------------------------------------
; FUNC: _DISPTEXT_InitBuffers   (Initialize disptext buffers)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7
; CALLS:
;   _DISPLIB_ResetLineTables, _GROUP_AG_JMPTBL_MEMORY_AllocateMemory
; READS:
;   _DISPTEXT_InitBuffersPending
; WRITES:
;   _DISPTEXT_TextBufferPtr, _DISPTEXT_InitBuffersPending, _Global_REF_1000_BYTES_ALLOCATED_1/2
; DESC:
;   Allocates working buffers for display text if initialization flag set.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISPTEXT_InitBuffers:
    TST.L   _DISPTEXT_InitBuffersPending
    BEQ.S   .return

    CLR.L   _DISPTEXT_TextBufferPtr
    BSR.W   _DISPLIB_ResetLineTables

    CLR.L   _DISPTEXT_InitBuffersPending

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     1000.W
    PEA     320.W
    PEA     _Global_STR_DISPTEXT_C_2
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    PEA     1000.W
    PEA     321.W
    PEA     _Global_STR_DISPTEXT_C_3
    MOVE.L  D0,_Global_REF_1000_BYTES_ALLOCATED_1
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     28(A7),A7
    MOVE.L  D0,_Global_REF_1000_BYTES_ALLOCATED_2

.return:
    RTS

;!======