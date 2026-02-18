    XDEF    HANDLE_CloseByIndex

;------------------------------------------------------------------------------
; FUNC: HANDLE_CloseByIndex   (Close and clear handle entry by index.)
; ARGS:
;   stack +12: D7 = handle index
; RET:
;   D0: 0 on success, -1 on error
; CLOBBERS:
;   D0/D7/A3
; CALLS:
;   HANDLE_GetEntryByIndex (HANDLE_GetEntryByIndex), DOS_CloseWithSignalCheck (close)
; READS:
;   Global_DosIoErr, handle entry flags at 3(A3)
; WRITES:
;   handle entry at (A3)
; DESC:
;   Closes a handle unless flagged as non-closable, then clears its entry.
;------------------------------------------------------------------------------
HANDLE_CloseByIndex:
    MOVEM.L D7/A3,-(A7)

    MOVE.L  12(A7),D7
    MOVE.L  D7,-(A7)
    JSR     HANDLE_GetEntryByIndex(PC)

    ADDQ.W  #4,A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BNE.S   .have_entry

    MOVEQ   #-1,D0
    BRA.S   .return

.have_entry:
    BTST    #4,3(A3)
    BEQ.S   .do_close

    MOVEQ   #0,D0
    MOVE.L  D0,(A3)
    BRA.S   .return

.do_close:
    MOVE.L  4(A3),-(A7)
    JSR     DOS_CloseWithSignalCheck(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D0
    MOVE.L  D0,(A3)
    TST.L   Global_DosIoErr(A4)
    BEQ.S   .return_ok

    MOVEQ   #-1,D0
    BRA.S   .return

.return_ok:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

    ; Alignment?
    ORI.B   #0,D0
    DC.W    $0000
    MOVEQ   #97,D0
