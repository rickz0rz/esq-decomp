    XDEF    _LOCAVAIL_FreeResourceChain


; Release a LOCAVAIL structure (free node array/bitmap and associated memory).
;------------------------------------------------------------------------------
; FUNC: _LOCAVAIL_FreeResourceChain   (Release shared refs, free node array/payloads, reset state)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A7/D0/D1/D7
; CALLS:
;   GROUP_AY_JMPTBL_MATH_Mulu32, _LOCAVAIL_FreeNodeAtPointer, _LOCAVAIL_ResetFilterStateStruct, _NEWGRID_JMPTBL_MATH_Mulu32, _NEWGRID_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _Global_STR_LOCAVAIL_C_2, _Global_STR_LOCAVAIL_C_3
; WRITES:
;   shared refcount at *(A3+16), released node payload/array ownership
; DESC:
;   Decrements shared refcount for retained header, frees node payloads/array when
;   the shared count reaches zero, then resets the owning filter-state struct.
; NOTES:
;   Safe to call with NULL state pointer.
;------------------------------------------------------------------------------
_LOCAVAIL_FreeResourceChain:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.L  A3,D0
    BEQ.W   .return

    TST.L   16(A3)
    BEQ.W   .reset_state_struct

    MOVEA.L 16(A3),A0
    MOVE.L  (A0),D0
    TST.L   D0
    BLE.S   .decrement_shared_refcount

    SUBQ.L  #1,(A0)

.decrement_shared_refcount:
    TST.L   20(A3)
    BEQ.S   .reset_state_struct

    MOVE.L  2(A3),D0
    TST.L   D0
    BLE.S   .reset_state_struct

    MOVEA.L 16(A3),A0
    TST.L   (A0)
    BNE.S   .reset_state_struct

    PEA     4.W
    MOVE.L  A0,-(A7)
    PEA     159.W
    PEA     _Global_STR_LOCAVAIL_C_2
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVEQ   #0,D7

.free_each_node_loop:
    CMP.L   2(A3),D7
    BGE.S   .free_node_array

    MOVE.L  D7,D0
    MOVEQ   #10,D1
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEA.L 20(A3),A0
    ADDA.L  D0,A0
    MOVE.L  A0,-(A7)
    BSR.W   _LOCAVAIL_FreeNodeAtPointer

    ADDQ.W  #4,A7
    ADDQ.L  #1,D7
    BRA.S   .free_each_node_loop

.free_node_array:
    MOVE.L  2(A3),D0
    MOVEQ   #10,D1
    JSR     GROUP_AY_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,-(A7)
    MOVE.L  20(A3),-(A7)
    PEA     164.W
    PEA     _Global_STR_LOCAVAIL_C_3
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.reset_state_struct:
    MOVE.L  A3,-(A7)
    BSR.W   _LOCAVAIL_ResetFilterStateStruct

    ADDQ.W  #4,A7

.return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======