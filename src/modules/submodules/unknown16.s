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
;   Global_A4_1120_Base (buffered output list)
; DESC:
;   Walks a linked list of buffered outputs, flushing pending bytes,
;   then closes handles/returns with the provided status.
; NOTES:
;   List node fields are still unknown; flush is gated by flags in offset 27.
;------------------------------------------------------------------------------
BUFFER_FlushAllAndCloseWithCode:
    MOVEM.L D6-D7/A3,-(A7)
    MOVE.L  16(A7),D7
    LEA     Global_A4_1120_Base(A4),A3

.flush_loop:
    MOVE.L  A3,D0
    BEQ.S   .after_flush

    BTST    #2,27(A3)
    BNE.S   .next_node

    BTST    #1,27(A3)
    BEQ.S   .next_node

    MOVE.L  4(A3),D0
    SUB.L   16(A3),D0
    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   .next_node

    MOVE.L  D6,-(A7)
    MOVE.L  16(A3),-(A7)
    MOVE.L  28(A3),-(A7)
    JSR     DOS_WriteByIndex(PC)

    LEA     12(A7),A7

.next_node:
    MOVEA.L (A3),A3
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
