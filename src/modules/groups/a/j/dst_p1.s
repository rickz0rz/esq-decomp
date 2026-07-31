    XDEF    _DST_AllocateBannerStruct


;------------------------------------------------------------------------------
; FUNC: _DST_AllocateBannerStruct   (Allocate banner struct and its buffers)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D7
; CALLS:
;   _DST_FreeBannerStruct, _GROUP_AG_JMPTBL_MEMORY_AllocateMemory
; READS:
;   _Global_STR_DST_C_4, _Global_STR_DST_C_5, _Global_STR_DST_C_6, MEMF_CLEAR, MEMF_PUBLIC
; WRITES:
;   A3+0/4/16 (buffer pointers, state)
; DESC:
;   Frees any existing banner struct, then allocates a new struct plus two buffers.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DST_AllocateBannerStruct:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7
    ; Tear down existing buffers, then allocate fresh struct+buffers.
    MOVE.L  A3,-(A7)
    BSR.W   _DST_FreeBannerStruct

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    PEA     18.W                            ; What's 18 bytes big?
    PEA     798.W
    PEA     _Global_STR_DST_C_4
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A3
    TST.L   D0
    BEQ.S   .alloc_failed

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     22.W                            ; What's 22 bytes big?
    PEA     803.W
    PEA     _Global_STR_DST_C_5
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,(A3)
    TST.L   D0
    BEQ.S   .alloc_failed

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     22.W                            ; What's 22 bytes big?
    PEA     807.W
    PEA     _Global_STR_DST_C_6
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,4(A3)
    TST.L   D0
    BEQ.S   .alloc_failed

    MOVEQ   #1,D7
    CLR.W   16(A3)

.alloc_failed:
    ; Allocation failed: free any partial state.
    TST.L   D7
    BNE.S   .return

    MOVE.L  A3,-(A7)
    BSR.W   _DST_FreeBannerStruct

    ADDQ.W  #4,A7

.return:
    MOVE.L  A3,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======