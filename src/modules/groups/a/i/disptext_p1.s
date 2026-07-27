    XDEF    DISPTEXT_FreeBuffers
    XDEF    DISPTEXT_InitBuffers

;------------------------------------------------------------------------------
; FUNC: DISPTEXT_InitBuffers   (Initialize disptext buffers)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7
; CALLS:
;   _DISPLIB_ResetLineTables, _GROUP_AG_JMPTBL_MEMORY_AllocateMemory
; READS:
;   DISPTEXT_InitBuffersPending
; WRITES:
;   _DISPTEXT_TextBufferPtr, DISPTEXT_InitBuffersPending, _Global_REF_1000_BYTES_ALLOCATED_1/2
; DESC:
;   Allocates working buffers for display text if initialization flag set.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISPTEXT_InitBuffers:
    TST.L   DISPTEXT_InitBuffersPending
    BEQ.S   .return

    CLR.L   _DISPTEXT_TextBufferPtr
    BSR.W   _DISPLIB_ResetLineTables

    CLR.L   DISPTEXT_InitBuffersPending

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     1000.W
    PEA     320.W
    PEA     Global_STR_DISPTEXT_C_2
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    PEA     1000.W
    PEA     321.W
    PEA     Global_STR_DISPTEXT_C_3
    MOVE.L  D0,_Global_REF_1000_BYTES_ALLOCATED_1
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     28(A7),A7
    MOVE.L  D0,Global_REF_1000_BYTES_ALLOCATED_2

.return:
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_FreeBuffers   (Free disptext buffers)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7
; CALLS:
;   _DISPLIB_ResetTextBufferAndLineTables, _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _Global_REF_1000_BYTES_ALLOCATED_1/2
; WRITES:
;   _Global_REF_1000_BYTES_ALLOCATED_1/2
; DESC:
;   Releases the 1000-byte buffers used by display text.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISPTEXT_FreeBuffers:
    BSR.W   _DISPLIB_ResetTextBufferAndLineTables

    TST.L   _Global_REF_1000_BYTES_ALLOCATED_1
    BEQ.S   .freeSecondBlock

    PEA     1000.W
    MOVE.L  _Global_REF_1000_BYTES_ALLOCATED_1,-(A7)
    PEA     338.W
    PEA     Global_STR_DISPTEXT_C_4
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    CLR.L   _Global_REF_1000_BYTES_ALLOCATED_1

.freeSecondBlock:
    TST.L   Global_REF_1000_BYTES_ALLOCATED_2
    BEQ.S   .return

    PEA     1000.W
    MOVE.L  Global_REF_1000_BYTES_ALLOCATED_2,-(A7)
    PEA     343.W
    PEA     Global_STR_DISPTEXT_C_5
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    CLR.L   Global_REF_1000_BYTES_ALLOCATED_2

.return:
    RTS

;!======