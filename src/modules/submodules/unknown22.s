LAB_1A04:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    TST.L   -616(A4)
    BEQ.S   .LAB_1A05

    JSR     LAB_1AD3(PC)

.LAB_1A05:
    MOVE.L  D7,D1
    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    JSR     _LVOClose(A6)

    MOVEQ   #0,D0
    MOVE.L  (A7)+,D7
    RTS

;!======

; what fancy banana pants math is going on here?
LAB_1A06:
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

LAB_1A07:
    TST.L   D0
    BPL.W   LAB_1A09

    NEG.L   D0
    TST.L   D1
    BPL.W   LAB_1A08

    NEG.L   D1
    BSR.W   LAB_1A0A

    NEG.L   D1
    RTS

;!======

LAB_1A08:
    BSR.W   LAB_1A0A

    NEG.L   D0
    NEG.L   D1
    RTS

;!======

LAB_1A09:
    TST.L   D1
    BPL.W   LAB_1A0A

    NEG.L   D1
    BSR.W   LAB_1A0A

    NEG.L   D0
    RTS

;!======

LAB_1A0A:
    MOVE.L  D2,-(A7)

    SWAP    D1
    MOVE.W  D1,D2
    BNE.W   LAB_1A0C

    SWAP    D0
    SWAP    D1
    SWAP    D2
    MOVE.W  D0,D2
    BEQ.W   .LAB_1A0B

    DIVU    D1,D2
    MOVE.W  D2,D0

.LAB_1A0B:
    SWAP    D0
    MOVE.W  D0,D2
    DIVU    D1,D2
    MOVE.W  D2,D0
    SWAP    D2
    MOVE.W  D2,D1

    MOVE.L  (A7)+,D2
    RTS

;!======

LAB_1A0C:
    MOVE.L  D3,-(A7)
    MOVEQ   #16,D3
    CMPI.W  #$80,D1
    BCC.W   .LAB_1A0D

    ROL.L   #8,D1
    SUBQ.W  #8,D3

.LAB_1A0D:
    CMPI.W  #$800,D1
    BCC.W   .LAB_1A0E

    ROL.L   #4,D1
    SUBQ.W  #4,D3

.LAB_1A0E:
    CMPI.W  #$2000,D1
    BCC.W   .LAB_1A0F

    ROL.L   #2,D1
    SUBQ.W  #2,D3

.LAB_1A0F:
    TST.W   D1
    BMI.W   .LAB_1A10

    ROL.L   #1,D1
    SUBQ.W  #1,D3

.LAB_1A10:
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
    BCC.W   .LAB_1A12

    SUBQ.W  #1,D3
    ADD.L   D1,D0

.LAB_1A11:
    BCC.S   .LAB_1A11

.LAB_1A12:
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

ALLOCATE_IOSTDREQ:
    MOVEM.L A2-A3/A6,-(A7)

    SetOffsetForStack 3

    MOVEA.L (.stackOffsetBytes+4)(A7),A3    ; Pass the last address pushed to the stack before calling this subroutine in A3
    MOVE.L  A3,D0               ; ...then move it to D0
    BNE.S   .a3NotZero          ; If it's not 0, jump.

    MOVEQ   #0,D0               ; Set D0 to 0
    BRA.S   .return             ; ... and terminate.

.a3NotZero:
    MOVEQ   #48,D0              ; Struct_IOStdReq_Size = 48 (can't use the def here becaues MOVEQ though)
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAllocMem(A6)

    MOVEA.L D0,A2               ; D0 is a pointer, so grab the value of D0 as an address, and move it to A2.
    MOVE.L  A2,D0               ; Then grab the value and put it in D0.
    BEQ.S   .setA2ToD0          ; If it's zero jump

    MOVE.B  #(NT_MESSAGE),(Struct_IOStdReq__io_Message+Struct__Message__mn_Node+Struct_Node__ln_Type)(A2)
    CLR.B   (Struct_IOStdReq__io_Message+Struct__Message__mn_Node+Struct_Node__ln_Pri)(A2)
    MOVE.L  A3,(Struct_IOStdReq__io_Message+Struct__Message__mn_ReplyPort)(A2)

.setA2ToD0:
    MOVE.L  A2,D0               ; Copy value A2 to D0

.return:
    MOVEM.L (A7)+,A2-A3/A6
    RTS

;!======

SETUP_SIGNAL_AND_MSGPORT:
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
    BNE.S   .gotSignal          ; If it's not equal, jump

    MOVEQ   #0,D0               ; Set D0 to 0
    BRA.S   .return

.gotSignal:
    MOVEQ   #34,D0              ; Allocate enough memory for a MsgPort struct (34 bytes)
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),D1
    JSR     _LVOAllocMem(A6)

    MOVEA.L D0,A2               ; Store the response from the alloc in D0 to A2 as an address
    MOVE.L  A2,D0               ; Store the value back from A2 to D0 (to utilize it for the BNE)
    BNE.S   .populateMsgPort    ; If it's not 0 (we were able to allocate the memory), jump to .populateMsgPort

    MOVEQ   #0,D0               ; Clear out D0
    MOVE.B  D6,D0               ; Move the signal byte (signal number) we got earlier back into D0 from D6
    JSR     _LVOFreeSignal(A6)  ; free that signal

    BRA.S   .setReturnValue     ; Jump to .setReturnValue

; Here we're just populating a bunch of stuff into the
; memory we allocated earlier (for the MsgPort struct)
; so this looks pretty ugly.
.populateMsgPort:
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
    BEQ.S   .LAB_1A1A           ; ...jump if A3/D0 is 0

    MOVEA.L A2,A1               ; A1 = A2
    JSR     _LVOAddPort(A6)     ; Add port

    BRA.S   .setReturnValue

.LAB_1A1A:
    LEA     24(A2),A0
    MOVE.L  A0,20(A2)
    LEA     20(A2),A0
    MOVE.L  A0,28(A2)
    CLR.L   24(A2)
    MOVE.B  #$2,32(A2)

.setReturnValue:
    MOVE.L  A2,D0                   ; Move A2 into D0 for consumption

.return:
    MOVEM.L (A7)+,D6-D7/A2-A3/A6
    RTS

;!======

    ; Alignment
    ALIGN_WORD
