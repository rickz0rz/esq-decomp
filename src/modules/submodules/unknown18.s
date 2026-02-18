    XDEF    DOS_SeekWithErrorState

;------------------------------------------------------------------------------
; FUNC: DOS_SeekWithErrorState   (Seek wrapper that tracks IoErr/AppErrorCode.)
; ARGS:
;   (none observed)
; RET:
;   D0: resulting position or -1 on error
; CLOBBERS:
;   D0-D7/A6
; CALLS:
;   SIGNAL_PollAndDispatch (signal callback), _LVOSeek, _LVOIoErr
; READS:
;   Global_SignalCallbackPtr
; WRITES:
;   Global_DosIoErr, Global_AppErrorCode
; DESC:
;   Optionally calls a signal callback, then seeks with DOS Seek.
;   On error, captures IoErr and sets AppErrorCode to 22.
; NOTES:
;   Returns adjusted position based on mode (see D5 handling).
;------------------------------------------------------------------------------
DOS_SeekWithErrorState:
    MOVEM.L D2-D7,-(A7)

    MOVE.L  28(A7),D7
    MOVE.L  32(A7),D6
    MOVE.L  36(A7),D5

    TST.L   Global_SignalCallbackPtr(A4)
    BEQ.S   .after_signal_callback

    JSR     SIGNAL_PollAndDispatch(PC)

.after_signal_callback:
    CLR.L   Global_DosIoErr(A4)
    MOVE.L  D5,D0
    SUBQ.L  #(OFFSET_END),D0
    MOVE.L  D7,D1
    MOVE.L  D6,D2
    MOVE.L  D0,D3
    MOVEA.L Global_DosLibrary(A4),A6
    JSR     _LVOSeek(A6)

    MOVE.L  D0,D4
    MOVEQ   #-1,D0
    CMP.L   D0,D4
    BNE.S   .after_seek

    JSR     _LVOIoErr(A6)

    MOVE.L  D0,Global_DosIoErr(A4)
    MOVEQ   #22,D0
    MOVE.L  D0,Global_AppErrorCode(A4)

.after_seek:
    MOVE.L  D5,D0
    CMPI.L  #$2,D0
    BEQ.S   .mode_end_adjust

    CMPI.L  #$1,D0
    BEQ.S   .mode_current_adjust

    TST.L   D0
    BNE.S   .return

    MOVE.L  D6,D0
    BRA.S   .return

.mode_current_adjust:
    MOVE.L  D4,D0
    ADD.L   D6,D0
    BRA.S   .return

.mode_end_adjust:
    MOVE.L  D7,D1
    MOVEQ   #0,D2
    MOVEQ   #(OFFSET_CURRENT),D3
    MOVEA.L Global_DosLibrary(A4),A6
    JSR     _LVOSeek(A6)

.return:
    MOVEM.L (A7)+,D2-D7
    RTS

;!======

    ; Alignment
    ALIGN_WORD
