    XDEF    BUFFER_FlushAllAndCloseWithCode

;------------------------------------------------------------------------------
; FUNC: BUFFER_FlushAllAndCloseWithCode   (Flush buffered outputs, then close.)
; ARGS:
;   stack +16: D7 = return/status code
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D6-D7/A3
; CALLS:
;   DOS_WriteByIndex (write by handle index), HANDLE_CloseAllAndReturnWithCode (close handles/return)
; READS:
;   Global_PreallocHandleNode0 (buffered output list head)
; DESC:
;   Walks a linked list of buffered outputs, flushing pending bytes,
;   then closes handles/returns with the provided status.
; NOTES:
;   Flush is gated by state bits:
;   Struct_PreallocHandleNode_OpenFlagsLowBit1_WritePending_Bit /
;   Struct_PreallocHandleNode_OpenFlagsLowBit2_Unbuffered_Bit.
;------------------------------------------------------------------------------
BUFFER_FlushAllAndCloseWithCode:
    MOVEM.L D6-D7/A3,-(A7)
    MOVE.L  16(A7),D7
    LEA     Global_PreallocHandleNode0(A4),A3

.flush_loop:
    MOVE.L  A3,D0
    BEQ.S   .after_flush

    BTST    #Struct_PreallocHandleNode_OpenFlagsLowBit2_Unbuffered_Bit,Struct_PreallocHandleNode__StateFlags(A3)
    BNE.S   .next_node

    BTST    #Struct_PreallocHandleNode_OpenFlagsLowBit1_WritePending_Bit,Struct_PreallocHandleNode__StateFlags(A3)
    BEQ.S   .next_node

    MOVE.L  Struct_PreallocHandleNode__BufferCursor(A3),D0
    SUB.L   Struct_PreallocHandleNode__BufferBase(A3),D0
    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   .next_node

    MOVE.L  D6,-(A7)
    MOVE.L  Struct_PreallocHandleNode__BufferBase(A3),-(A7)
    MOVE.L  Struct_PreallocHandleNode__HandleIndex(A3),-(A7)
    JSR     DOS_WriteByIndex(PC)

    LEA     12(A7),A7

.next_node:
    MOVEA.L Struct_PreallocHandleNode__Next(A3),A3
    BRA.S   .flush_loop

.after_flush:
    MOVE.L  D7,-(A7)
    JSR     HANDLE_CloseAllAndReturnWithCode(PC)

    ADDQ.W  #4,A7
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD
