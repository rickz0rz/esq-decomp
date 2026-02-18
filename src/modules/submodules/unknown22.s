    XDEF    ALLOCATE_AllocAndInitializeIOStdReq
    XDEF    DOS_CloseWithSignalCheck
    XDEF    MATH_DivS32
    XDEF    MATH_DivU32
    XDEF    MATH_Mulu32
    XDEF    SIGNAL_CreateMsgPortWithSignal

;------------------------------------------------------------------------------
; FUNC: DOS_CloseWithSignalCheck   (Close a DOS handle, with signal callback.)
; ARGS:
;   stack +8: D7 = handle
; RET:
;   D0: 0
; CLOBBERS:
;   D0-D1/D7/A6
; CALLS:
;   SIGNAL_PollAndDispatch (signal callback), _LVOClose
; READS:
;   Global_SignalCallbackPtr
;------------------------------------------------------------------------------
DOS_CloseWithSignalCheck:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    TST.L   Global_SignalCallbackPtr(A4)
    BEQ.S   .after_signal_callback

    JSR     SIGNAL_PollAndDispatch(PC)

.after_signal_callback:
    MOVE.L  D7,D1
    MOVEA.L Global_DosLibrary(A4),A6
    JSR     _LVOClose(A6)

    MOVEQ   #0,D0
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: MATH_Mulu32   (Unsigned 32-bit multiply helper.)
; ARGS:
;   D0 = multiplicand
;   D1 = multiplier
; RET:
;   D0: lower 32 bits of product
; CLOBBERS:
;   D0-D3
; DESC:
;   Computes a 32-bit product using 16-bit MULU pieces.
;------------------------------------------------------------------------------
MATH_Mulu32:
    MOVEM.L D2-D3,-(A7)

    MOVE.L  D0,D2
    MOVE.L  D1,D3
    SWAP    D2          ; D2 swaps upper and lower words
    SWAP    D3          ; Same for D3
    MULU    D1,D2       ; Multiply D1 and D2 unsigned (just the lower word?), store in D2
    MULU    D0,D3       ; Multiple D0 and D3 unsigned, store in D3
    MULU    D1,D0       ;
    ADD.W   D3,D2       ; Add lower D3 and D2 words into D2
    SWAP    D2          ; Make the lower D2 word upper
    CLR.W   D2          ; Clear the lower D2 word
    ADD.L   D2,D0       ; Add D2 into D0

    MOVEM.L (A7)+,D2-D3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: MATH_DivS32   (Signed 32-bit division helper.)
; ARGS:
;   D0 = dividend
;   D1 = divisor
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D3
; CALLS:
;   MATH_DivU32 (unsigned division core)
; DESC:
;   Handles signed division by normalizing signs and dispatching to unsigned.
;------------------------------------------------------------------------------
MATH_DivS32:
    TST.L   D0
    BPL.W   .dividend_pos

    NEG.L   D0
    TST.L   D1
    BPL.W   .divisor_pos_after_neg

    NEG.L   D1
    BSR.W   MATH_DivU32

    NEG.L   D1
    RTS

.divisor_pos_after_neg:
    BSR.W   MATH_DivU32

    NEG.L   D0
    NEG.L   D1
    RTS

.dividend_pos:
    TST.L   D1
    BPL.W   MATH_DivU32

    NEG.L   D1
    BSR.W   MATH_DivU32

    NEG.L   D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: MATH_DivU32   (Unsigned 32-bit division core.)
; ARGS:
;   D0 = dividend
;   D1 = divisor
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D3
;------------------------------------------------------------------------------
MATH_DivU32:
    MOVE.L  D2,-(A7)

    SWAP    D1
    MOVE.W  D1,D2
    BNE.W   .div_long

    SWAP    D0
    SWAP    D1
    SWAP    D2
    MOVE.W  D0,D2
    BEQ.W   .div_simple_done

    DIVU    D1,D2
    MOVE.W  D2,D0

.div_simple_done:
    SWAP    D0
    MOVE.W  D0,D2
    DIVU    D1,D2
    MOVE.W  D2,D0
    SWAP    D2
    MOVE.W  D2,D1

    MOVE.L  (A7)+,D2
    RTS

.div_long:
    MOVE.L  D3,-(A7)
    MOVEQ   #16,D3
    CMPI.W  #$80,D1
    BCC.W   .shift8

    ROL.L   #8,D1
    SUBQ.W  #8,D3

.shift8:
    CMPI.W  #$800,D1
    BCC.W   .shift4

    ROL.L   #4,D1
    SUBQ.W  #4,D3

.shift4:
    CMPI.W  #$2000,D1
    BCC.W   .shift2

    ROL.L   #2,D1
    SUBQ.W  #2,D3

.shift2:
    TST.W   D1
    BMI.W   .shift1

    ROL.L   #1,D1
    SUBQ.W  #1,D3

.shift1:
    MOVE.W  D0,D2
    LSR.L   D3,D0
    SWAP    D2
    CLR.W   D2
    LSR.L   D3,D2
    SWAP    D3
    DIVU    D1,D0
    MOVE.W  D0,D3
    MOVE.W  D2,D0
    MOVE.W  D3,D2
    SWAP    D1
    MULU    D1,D2
    SUB.L   D2,D0
    BCC.W   .div_finalize

    SUBQ.W  #1,D3
    ADD.L   D1,D0

.adjust_loop:
    BCC.S   .adjust_loop

.div_finalize:
    MOVEQ   #0,D1
    MOVE.W  D3,D1
    SWAP    D3
    ROL.L   D3,D0
    SWAP    D0
    EXG     D0,D1
    MOVE.L  (A7)+,D3
    MOVE.L  (A7)+,D2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ALLOCATE_AllocAndInitializeIOStdReq   (Allocate and initialize an IOStdReq.)
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
ALLOCATE_AllocAndInitializeIOStdReq:
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

;------------------------------------------------------------------------------
; FUNC: SIGNAL_CreateMsgPortWithSignal   (Allocate signal + MsgPort.)
; ARGS:
;   stack +4: A3 = port name (can be 0)
;   stack +8: D7 = port priority
; RET:
;   D0: MsgPort pointer or 0 on failure
; CLOBBERS:
;   D0-D7/A2-A3/A6
; CALLS:
;   _LVOAllocSignal, _LVOFreeSignal, _LVOAllocMem, _LVOFindTask, _LVOAddPort
; DESC:
;   Allocates a signal and a MsgPort, initializes fields, and registers it.
;------------------------------------------------------------------------------
SIGNAL_CreateMsgPortWithSignal:
    MOVEM.L D6-D7/A2-A3/A6,-(A7)

    SetOffsetForStack 5

    MOVEA.L (.stackOffsetBytes+4)(A7),A3
    MOVE.L  (.stackOffsetBytes+8)(A7),D7

    ; Allocate a signal, with...
    MOVEQ   #-1,D0              ; no preference on the signal number (-1)
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAllocSignal(A6)

    MOVE.L  D0,D6               ; Returned signal #
    CMPI.B  #(-1),D6            ; Compare to -1 (No signals available)
    BNE.S   .got_signal         ; If it's not equal, jump

    MOVEQ   #0,D0               ; Set D0 to 0
    BRA.S   .return

.got_signal:
    MOVEQ   #34,D0              ; Allocate enough memory for a MsgPort struct (34 bytes)
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),D1
    JSR     _LVOAllocMem(A6)

    MOVEA.L D0,A2               ; Store the response from the alloc in D0 to A2 as an address
    MOVE.L  A2,D0               ; Store the value back from A2 to D0 (to utilize it for the BNE)
    BNE.S   .populate_msgport   ; If it's not 0 (we were able to allocate the memory), jump to .populate_msgport

    MOVEQ   #0,D0               ; Clear out D0
    MOVE.B  D6,D0               ; Move the signal byte (signal number) we got earlier back into D0 from D6
    JSR     _LVOFreeSignal(A6)  ; free that signal

    BRA.S   .set_return         ; Jump to .set_return

; Here we're just populating a bunch of stuff into the
; memory we allocated earlier (for the MsgPort struct)
; so this looks pretty ugly.
.populate_msgport:
    MOVE.L  A3,(Struct_MsgPort__mp_Node+Struct_Node__ln_Name)(A2)
    MOVE.L  D7,D0               ; D7 is some value on the stack passed in..
    MOVE.B  D0,(Struct_MsgPort__mp_Node+Struct_Node__ln_Pri)(A2)
    MOVE.B  #(NT_MSGPORT),(Struct_MsgPort__mp_Node+Struct_Node__ln_Type)(A2)
    CLR.B   Struct_MsgPort__mp_Flags(A2)
    MOVE.B  D6,Struct_MsgPort__mp_SigBit(A2)
    SUBA.L  A1,A1               ; A1 = A1 - A1 (zero out A1 in a single instruction?)
    JSR     _LVOFindTask(A6)    ; Find the task in A1. Since A1 is null,

                                ; it returns a pointer to the current task.

    MOVE.L  D0,Struct_MsgPort__mp_SigTask(A2) ; Copy the task we got previously
    MOVE.L  A3,D0               ; Put A3 into D0 so we can...
    BEQ.S   .init_port_list     ; ...jump if A3/D0 is 0

    MOVEA.L A2,A1               ; A1 = A2
    JSR     _LVOAddPort(A6)     ; Add port

    BRA.S   .set_return

.init_port_list:
    LEA     24(A2),A0
    MOVE.L  A0,20(A2)
    LEA     20(A2),A0
    MOVE.L  A0,28(A2)
    CLR.L   24(A2)
    MOVE.B  #$2,32(A2)

.set_return:
    MOVE.L  A2,D0                   ; Move A2 into D0 for consumption

.return:
    MOVEM.L (A7)+,D6-D7/A2-A3/A6
    RTS

;!======

    ; Alignment
    ALIGN_WORD
