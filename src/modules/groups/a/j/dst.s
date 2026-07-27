    XDEF    _DST_FreeBannerStruct


;------------------------------------------------------------------------------
; FUNC: _DST_FreeBannerStruct   (Free banner struct and its two buffers)
; ARGS:
;   (none observed)
; RET:
;   D0: none
; CLOBBERS:
;   A3/A7/D0
; CALLS:
;   _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   A3+0/4 (buffer pointers)
; WRITES:
;   (none observed)
; DESC:
;   Frees the two buffers referenced by the banner struct, then the struct itself.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DST_FreeBannerStruct:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  A3,D0
    BEQ.S   .return

    ; Free primary banner buffer if present.
    TST.L   (A3)
    BEQ.S   .free_slot1

    PEA     22.W
    MOVE.L  (A3),-(A7)
    PEA     773.W
    PEA     Global_STR_DST_C_1
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.free_slot1:
    ; Free secondary banner buffer if present.
    TST.L   4(A3)
    BEQ.S   .free_struct

    PEA     22.W
    MOVE.L  4(A3),-(A7)
    PEA     777.W
    PEA     Global_STR_DST_C_2
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.free_struct:
    ; Free the container struct.
    PEA     18.W
    MOVE.L  A3,-(A7)
    PEA     779.W
    PEA     Global_STR_DST_C_3
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.return:
    MOVEA.L (A7)+,A3
    RTS

;!======