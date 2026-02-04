;------------------------------------------------------------------------------
; FUNC: SIGNAL_PollAndDispatch   (Poll Ctrl-C/D break signals and invoke callback.)
; ARGS:
;   none
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D1/A0/A6
; CALLS:
;   _LVOSetSignal, Global_SignalCallbackPtr, HANDLE_CloseAllAndReturnWithCode (close handles/exit?)
; READS:
;   Global_SignalCallbackPtr
; WRITES:
;   Global_SignalCallbackPtr (cleared on callback failure)
; DESC:
;   Checks for signals 0x3000; if present, calls the registered callback.
;   If callback returns non-zero, clears it and calls HANDLE_CloseAllAndReturnWithCode with code 20.
;------------------------------------------------------------------------------
SIGNAL_PollAndDispatch:
    MOVE.L  D7,-(A7)

    MOVEQ   #0,D0
    MOVE.L  #$3000,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOSetSignal(A6)

    MOVE.L  D0,D7
    ANDI.L  #$3000,D7
    TST.L   D7
    BEQ.S   .return

    TST.L   Global_SignalCallbackPtr(A4)
    BEQ.S   .return

    MOVEA.L Global_SignalCallbackPtr(A4),A0
    JSR     (A0)

    TST.L   D0
    BNE.S   .callback_failed

    BRA.S   .return

.callback_failed:
    CLR.L   Global_SignalCallbackPtr(A4)
    PEA     20.W
    JSR     HANDLE_CloseAllAndReturnWithCode(PC)

    ADDQ.W  #4,A7

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

    ; Unreachable code?
    BSR.S   SIGNAL_PollAndDispatch
    RTS

    ; Alignment?
    DC.W    $0000
