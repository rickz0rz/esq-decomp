    XDEF    LOCAVAIL_AllocNodeArraysForState


;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_AllocNodeArraysForState   (Allocate shared header and node array for filter state)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A7/D0/D1/D7
; CALLS:
;   GROUP_AY_JMPTBL_MATH_Mulu32, _NEWGRID_JMPTBL_MEMORY_AllocateMemory
; READS:
;   Global_STR_LOCAVAIL_C_4, Global_STR_LOCAVAIL_C_5, MEMF_CLEAR, MEMF_PUBLIC
; WRITES:
;   A3+16 shared header ptr, A3+20 node array ptr
; DESC:
;   Allocates shared header and contiguous node array when node count is within
;   valid bounds (1..99), returning success flag in D0.
; NOTES:
;   Initializes shared header refcount to zero before array allocation.
;------------------------------------------------------------------------------
LOCAVAIL_AllocNodeArraysForState:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7
    MOVE.L  2(A3),D0
    TST.L   D0
    BLE.S   .return

    MOVEQ   #100,D1
    CMP.L   D1,D0
    BGE.S   .return

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     4.W
    PEA     218.W
    PEA     Global_STR_LOCAVAIL_C_4
    JSR     _NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,16(A3)
    TST.L   D0
    BEQ.S   .return

    MOVEA.L D0,A0
    CLR.L   (A0)
    MOVE.L  2(A3),D0
    MOVEQ   #10,D1
    JSR     GROUP_AY_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     229.W
    PEA     Global_STR_LOCAVAIL_C_5
    JSR     _NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,20(A3)
    BEQ.S   .return

    MOVEQ   #1,D7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======