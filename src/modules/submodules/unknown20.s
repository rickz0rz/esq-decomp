    XDEF    DOS_OpenWithErrorState

;------------------------------------------------------------------------------
; FUNC: DOS_OpenWithErrorState   (Open wrapper that tracks IoErr/AppErrorCode.)
; ARGS:
;   stack +20: A3 = path string
;   stack +24: D7 = open mode
; RET:
;   D0: file handle, or -1 on error
; CLOBBERS:
;   D0-D7/A3/A6
; CALLS:
;   SIGNAL_PollAndDispatch (signal callback), _LVOOpen, _LVOIoErr
; READS:
;   Global_SignalCallbackPtr
; WRITES:
;   Global_DosIoErr, Global_AppErrorCode
; DESC:
;   Optionally calls a signal callback, then performs DOS Open.
;   On error, captures IoErr and sets AppErrorCode to 2.
;------------------------------------------------------------------------------
DOS_OpenWithErrorState:
    MOVEM.L D2/D6-D7/A3,-(A7)

    MOVEA.L 20(A7),A3
    MOVE.L  24(A7),D7

    TST.L   Global_SignalCallbackPtr(A4)
    BEQ.S   .after_signal_callback

    JSR     SIGNAL_PollAndDispatch(PC)

.after_signal_callback:
    CLR.L   Global_DosIoErr(A4)
    MOVE.L  A3,D1
    MOVE.L  D7,D2
    MOVEA.L Global_DosLibrary(A4),A6
    JSR     _LVOOpen(A6)

    MOVE.L  D0,D6
    TST.L   D6
    BNE.S   .have_handle

    JSR     _LVOIoErr(A6)

    MOVE.L  D0,Global_DosIoErr(A4)
    MOVEQ   #2,D0
    MOVE.L  D0,Global_AppErrorCode(A4)
    MOVEQ   #-1,D0
    BRA.S   .return

.have_handle:
    MOVE.L  D6,D0

.return:
    MOVEM.L (A7)+,D2/D6-D7/A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD
