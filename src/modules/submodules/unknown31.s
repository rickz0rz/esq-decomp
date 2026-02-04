;------------------------------------------------------------------------------
; FUNC: BUFFER_EnsureAllocated   (Ensure buffer memory exists for a stream.)
; ARGS:
;   stack +8: A3 = stream/handle struct pointer
; RET:
;   D0: 0 on success, -1 on allocation failure
; CLOBBERS:
;   D0/A3
; CALLS:
;   ALLOC_AllocFromFreeList (allocator)
; READS:
;   Global_A4_748_Ptr
; WRITES:
;   Global_AppErrorCode, A3+4/8/12/16/20/24
; DESC:
;   Allocates and initializes buffer fields if needed.
; NOTES:
;   Returns success immediately if a buffer is already present and not flagged.
;------------------------------------------------------------------------------
BUFFER_EnsureAllocated:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    TST.L   20(A3)
    BEQ.S   .alloc_buffer

    BTST    #3,27(A3)
    BNE.S   .alloc_buffer

    MOVEQ   #0,D0
    BRA.S   .return

.alloc_buffer:
    MOVE.L  Global_A4_748_Ptr(A4),-(A7)
    JSR     ALLOC_AllocFromFreeList(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,4(A3)
    MOVE.L  D0,16(A3)
    TST.L   D0
    BNE.S   .alloc_ok

    MOVEQ   #12,D0
    MOVE.L  D0,Global_AppErrorCode(A4)
    MOVEQ   #-1,D0
    BRA.S   .return

.alloc_ok:
    MOVE.L  Global_A4_748_Ptr(A4),20(A3)
    MOVEQ   #-13,D0
    AND.L   D0,24(A3)
    MOVEQ   #0,D0
    MOVE.L  D0,12(A3)
    MOVE.L  D0,8(A3)

.return:
    MOVEA.L (A7)+,A3
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    MOVEQ   #97,D0
