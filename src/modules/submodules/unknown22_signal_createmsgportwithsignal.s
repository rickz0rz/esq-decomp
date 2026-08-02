    XDEF    _SIGNAL_CreateMsgPortWithSignal


;------------------------------------------------------------------------------
; FUNC: _SIGNAL_CreateMsgPortWithSignal   (Allocate signal + MsgPort.)
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
_SIGNAL_CreateMsgPortWithSignal:
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