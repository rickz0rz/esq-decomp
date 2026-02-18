    XDEF    DOS_WriteWithErrorState

;------------------------------------------------------------------------------
; FUNC: DOS_WriteWithErrorState   (Write wrapper that tracks IoErr/AppErrorCode.)
; ARGS:
;   stack +28: D7 = file handle
;   stack +32: A3 = buffer pointer
;   stack +36: D6 = length
; RET:
;   D0: bytes written (or -1 on error)
; CLOBBERS:
;   D0-D7/A3/A6
; CALLS:
;   SIGNAL_PollAndDispatch (signal callback), _LVOWrite, _LVOIoErr
; READS:
;   Global_SignalCallbackPtr
; WRITES:
;   Global_DosIoErr, Global_AppErrorCode
; DESC:
;   Optionally calls a signal callback, then performs DOS Write.
;   On error, captures IoErr and sets AppErrorCode to 5.
;------------------------------------------------------------------------------
DOS_WriteWithErrorState:
    MOVEM.L D2-D3/D5-D7/A3,-(A7)

    MOVE.L  28(A7),D7
    MOVEA.L 32(A7),A3
    MOVE.L  36(A7),D6

    TST.L   Global_SignalCallbackPtr(A4)
    BEQ.S   .after_signal_callback

    JSR     SIGNAL_PollAndDispatch(PC)

.after_signal_callback:
    CLR.L   Global_DosIoErr(A4)
    MOVE.L  D7,D1
    MOVE.L  A3,D2
    MOVE.L  D6,D3
    MOVEA.L Global_DosLibrary(A4),A6
    JSR     _LVOWrite(A6)

    MOVE.L  D0,D5
    MOVEQ   #-1,D0
    CMP.L   D0,D5
    BNE.S   .return

    JSR     _LVOIoErr(A6)

    MOVE.L  D0,Global_DosIoErr(A4)
    MOVEQ   #5,D0
    MOVE.L  D0,Global_AppErrorCode(A4)

.return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D2-D3/D5-D7/A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD
