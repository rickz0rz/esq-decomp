    XDEF    _ALLOCATE_AllocAndInitializeIOStdReq


;------------------------------------------------------------------------------
; FUNC: _ALLOCATE_AllocAndInitializeIOStdReq   (Allocate and initialize an IOStdReq.)
; ARGS:
;   stack +4: A3 = reply port (MsgPort) pointer
; RET:
;   D0: IOStdReq pointer or 0 on failure
; CLOBBERS:
;   D0/A2-A3/A6
; CALLS:
;   _LVOAllocMem
; DESC:
;   Allocates 48 bytes, initializes the embedded Message header.
;------------------------------------------------------------------------------
_ALLOCATE_AllocAndInitializeIOStdReq:
    MOVEM.L A2-A3/A6,-(A7)

    SetOffsetForStack 3

    MOVEA.L (.stackOffsetBytes+4)(A7),A3    ; Pass the last address pushed to the stack before calling this subroutine in A3
    MOVE.L  A3,D0               ; ...then move it to D0
    BNE.S   .have_reply_port    ; If it's not 0, jump.

    MOVEQ   #0,D0               ; Set D0 to 0
    BRA.S   .return             ; ... and terminate.

.have_reply_port:
    MOVEQ   #48,D0              ; Struct_IOStdReq_Size = 48 (can't use the def here becaues MOVEQ though)
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAllocMem(A6)

    MOVEA.L D0,A2               ; D0 is a pointer, so grab the value of D0 as an address, and move it to A2.
    MOVE.L  A2,D0               ; Then grab the value and put it in D0.
    BEQ.S   .return_ptr         ; If it's zero jump

    MOVE.B  #(NT_MESSAGE),(Struct_IOStdReq__io_Message+Struct__Message__mn_Node+Struct_Node__ln_Type)(A2)
    CLR.B   (Struct_IOStdReq__io_Message+Struct__Message__mn_Node+Struct_Node__ln_Pri)(A2)
    MOVE.L  A3,(Struct_IOStdReq__io_Message+Struct__Message__mn_ReplyPort)(A2)

.return_ptr:
    MOVE.L  A2,D0               ; Copy value A2 to D0

.return:
    MOVEM.L (A7)+,A2-A3/A6
    RTS

;!======