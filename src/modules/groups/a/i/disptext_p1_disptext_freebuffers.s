    XDEF    _DISPTEXT_FreeBuffers

;------------------------------------------------------------------------------
; FUNC: _DISPTEXT_FreeBuffers   (Free disptext buffers)
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
_DISPTEXT_FreeBuffers:
    BSR.W   _DISPLIB_ResetTextBufferAndLineTables

    TST.L   _Global_REF_1000_BYTES_ALLOCATED_1
    BEQ.S   .freeSecondBlock

    PEA     1000.W
    MOVE.L  _Global_REF_1000_BYTES_ALLOCATED_1,-(A7)
    PEA     338.W
    PEA     _Global_STR_DISPTEXT_C_4
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    CLR.L   _Global_REF_1000_BYTES_ALLOCATED_1

.freeSecondBlock:
    TST.L   _Global_REF_1000_BYTES_ALLOCATED_2
    BEQ.S   .return

    PEA     1000.W
    MOVE.L  _Global_REF_1000_BYTES_ALLOCATED_2,-(A7)
    PEA     343.W
    PEA     _Global_STR_DISPTEXT_C_5
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    CLR.L   _Global_REF_1000_BYTES_ALLOCATED_2

.return:
    RTS

;!======