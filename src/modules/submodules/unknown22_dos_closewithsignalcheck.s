    XDEF    _DOS_CloseWithSignalCheck


;------------------------------------------------------------------------------
; FUNC: _DOS_CloseWithSignalCheck   (Close a DOS handle, with signal callback.)
; ARGS:
;   stack +8: D7 = handle
; RET:
;   D0: 0
; CLOBBERS:
;   D0-D1/D7/A6
; CALLS:
;   _SIGNAL_PollAndDispatch (signal callback), _LVOClose
; READS:
;   Global_SignalCallbackPtr
;------------------------------------------------------------------------------
_DOS_CloseWithSignalCheck:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    TST.L   Global_SignalCallbackPtr(A4)
    BEQ.S   .after_signal_callback

    JSR     _SIGNAL_PollAndDispatch(PC)

.after_signal_callback:
    MOVE.L  D7,D1
    MOVEA.L Global_DosLibrary(A4),A6
    JSR     _LVOClose(A6)

    MOVEQ   #0,D0
    MOVE.L  (A7)+,D7
    RTS

;!======