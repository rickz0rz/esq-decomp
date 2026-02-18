    XDEF    BUFFER_EnsureAllocated

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
;   Global_StreamBufferAllocSize
; WRITES:
;   Global_AppErrorCode, Struct_PreallocHandleNode__BufferBase/BufferCursor/
;   ReadRemaining/WriteRemaining/BufferCapacity/OpenFlags(A3)
; DESC:
;   Allocates and initializes buffer fields if needed.
; NOTES:
;   Returns success immediately if a buffer is already present and not flagged.
;------------------------------------------------------------------------------
BUFFER_EnsureAllocated:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    TST.L   Struct_PreallocHandleNode__BufferCapacity(A3)
    BEQ.S   .alloc_buffer

    BTST    #3,Struct_PreallocHandleNode__StateFlags(A3)
    BNE.S   .alloc_buffer

    MOVEQ   #0,D0
    BRA.S   .return

.alloc_buffer:
    MOVE.L  Global_StreamBufferAllocSize(A4),-(A7)
    JSR     ALLOC_AllocFromFreeList(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,Struct_PreallocHandleNode__BufferCursor(A3)
    MOVE.L  D0,Struct_PreallocHandleNode__BufferBase(A3)
    TST.L   D0
    BNE.S   .alloc_ok

    MOVEQ   #12,D0
    MOVE.L  D0,Global_AppErrorCode(A4)
    MOVEQ   #-1,D0
    BRA.S   .return

.alloc_ok:
    MOVE.L  Global_StreamBufferAllocSize(A4),Struct_PreallocHandleNode__BufferCapacity(A3)
    MOVEQ   #-13,D0
    AND.L   D0,Struct_PreallocHandleNode__OpenFlags(A3)
    MOVEQ   #0,D0
    MOVE.L  D0,Struct_PreallocHandleNode__WriteRemaining(A3)
    MOVE.L  D0,Struct_PreallocHandleNode__ReadRemaining(A3)

.return:
    MOVEA.L (A7)+,A3
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    MOVEQ   #97,D0
