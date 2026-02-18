    XDEF    DOS_DeleteAndRecreateFile
    XDEF    DOS_OpenNewFileIfMissing
    XDEF    IOSTDREQ_CleanupSignalAndMsgport
    XDEF    IOSTDREQ_Free

;------------------------------------------------------------------------------
; FUNC: IOSTDREQ_Free   (Free IOStdReq-like struct.)
; ARGS:
;   stack +12: A3 = struct pointer
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/A0-A3/A6
; CALLS:
;   _LVOFreeMem
; DESC:
;   Marks fields invalid and frees a 48-byte structure.
; NOTES:
;   Assumes 48-byte size; likely IOStdReq.
;------------------------------------------------------------------------------
IOSTDREQ_Free:
    MOVEM.L A3/A6,-(A7)

    MOVEA.L 12(A7),A3

    MOVE.B  #$ff,8(A3)
    MOVEA.W #$ffff,A0
    MOVE.L  A0,20(A3)
    MOVE.L  A0,24(A3)
    MOVEA.L A3,A1
    MOVEQ   #48,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOFreeMem(A6)

    MOVEM.L (A7)+,A3/A6
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: IOSTDREQ_CleanupSignalAndMsgport   (Remove MsgPort and free signal.)
; ARGS:
;   stack +12: A3 = MsgPort pointer
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/A1-A3/A6
; CALLS:
;   _LVORemPort, _LVOFreeSignal, _LVOFreeMem
; DESC:
;   Removes the port if registered, frees its signal, and releases memory.
;------------------------------------------------------------------------------
IOSTDREQ_CleanupSignalAndMsgport:
    MOVEM.L A3/A6,-(A7)

    MOVEA.L 12(A7),A3
    TST.L   10(A3)
    BEQ.S   .after_remove

    MOVEA.L A3,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVORemPort(A6)

.after_remove:
    MOVE.B  #$ff,8(A3)
    MOVEQ   #-1,D0
    MOVE.L  D0,20(A3)
    MOVEQ   #0,D0
    MOVE.B  15(A3),D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOFreeSignal(A6)

    MOVEA.L A3,A1
    MOVEQ   #34,D0
    JSR     _LVOFreeMem(A6)

    MOVEM.L (A7)+,A3/A6
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DOS_OpenNewFileIfMissing   (Open new file if it doesn't already exist.)
; ARGS:
;   stack +24: A3 = filename
; RET:
;   D0: file handle, or -1 if exists/failure
; CLOBBERS:
;   D0-D2/D7/A3/A6
; CALLS:
;   SIGNAL_PollAndDispatch, _LVOLock, _LVOUnLock, _LVOOpen, _LVOIoErr
; READS:
;   Global_SignalCallbackPtr
; WRITES:
;   Global_DosIoErr, Global_AppErrorCode
; DESC:
;   If file exists (lock succeeds), returns -1. Otherwise opens MODE_NEWFILE.
;------------------------------------------------------------------------------
DOS_OpenNewFileIfMissing:
    LINK.W  A5,#-4
    MOVEM.L D2/D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    TST.L   Global_SignalCallbackPtr(A4)
    BEQ.S   .after_signal

    JSR     SIGNAL_PollAndDispatch(PC)

.after_signal:
    CLR.L   Global_DosIoErr(A4)
    MOVE.L  A3,D1
    MOVEQ   #-2,D2
    MOVEA.L Global_DosLibrary(A4),A6
    JSR     _LVOLock(A6)

    MOVE.L  D0,D7
    TST.L   D7
    BEQ.S   .open_new

    MOVE.L  D7,D1
    JSR     _LVOUnLock(A6)

    MOVEQ   #-1,D0
    BRA.S   .return

.open_new:
    MOVE.L  A3,D1
    MOVE.L  #MODE_NEWFILE,D2
    JSR     _LVOOpen(A6)

    MOVE.L  D0,D7
    TST.L   D7
    BNE.S   .open_ok

    JSR     _LVOIoErr(A6)

    MOVE.L  D0,Global_DosIoErr(A4)
    MOVEQ   #2,D0
    MOVE.L  D0,Global_AppErrorCode(A4)
    MOVEQ   #-1,D0
    BRA.S   .return

.open_ok:
    MOVE.L  D7,D0

.return:
    MOVEM.L (A7)+,D2/D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DOS_DeleteAndRecreateFile   (Delete existing file, then open new.)
; ARGS:
;   stack +24: A3 = filename
; RET:
;   D0: file handle, or -1 on failure
; CLOBBERS:
;   D0-D2/D7/A3/A6
; CALLS:
;   SIGNAL_PollAndDispatch, _LVOLock, _LVOUnLock, _LVODeleteFile, _LVOOpen, _LVOIoErr
; READS:
;   Global_SignalCallbackPtr
; WRITES:
;   Global_DosIoErr, Global_AppErrorCode
; DESC:
;   Deletes the file if it exists, then opens MODE_NEWFILE.
;------------------------------------------------------------------------------
DOS_DeleteAndRecreateFile:
    LINK.W  A5,#-4
    MOVEM.L D2/D7/A3,-(A7)
    MOVEA.L 24(A7),A3

    TST.L   Global_SignalCallbackPtr(A4)
    BEQ.S   .delete_if_exists

    JSR     SIGNAL_PollAndDispatch(PC)

.delete_if_exists:
    CLR.L   Global_DosIoErr(A4)                            ; Clear the long at Global_DosIoErr(A4)
    MOVE.L  A3,D1                               ; Filename -> D1
    MOVEQ   #ACCESS_READ,D2                     ; Filemode = -2 = ACCESS_READ
    MOVEA.L Global_DosLibrary(A4),A6
    JSR     _LVOLock(A6)

    MOVE.L  D0,D7                               ; D0 = result as BCPL pointer, copied to D7
    TST.L   D7                                  ; Test D7 against 0
    BEQ.S   .lock_failed                        ; If equal (it's a 0), lock failed so branch to .lock_failed

    MOVE.L  D7,D1                               ; Move the BCPL pointer back
    JSR     _LVOUnLock(A6)                      ; Remove the same lock we just created

    MOVE.L  A3,D1                               ; Filename -> D1
    JSR     _LVODeleteFile(A6)                  ; Delete the file.

.lock_failed:
    MOVE.L  A3,D1                               ; Filename -> D1
    MOVE.L  #MODE_NEWFILE,D2                    ; Access mode = MODE_NEWFILE
    JSR     _LVOOpen(A6)                        ; Open zee file!

    MOVE.L  D0,D7                               ; D0 = result as BCPL pointer, copied to D7
    TST.L   D7                                  ; Test D7 against 0
    BNE.S   .open_ok                            ; If it's not zero (we have a valid pointer) jump to .open_ok

    JSR     _LVOIoErr(A6)                       ; Jump to IOErr

    MOVE.L  D0,Global_DosIoErr(A4)
    MOVEQ   #2,D0
    MOVE.L  D0,Global_AppErrorCode(A4)
    MOVEQ   #-1,D0
    BRA.S   .return

.open_ok:
    MOVE.L  D7,D0                               ; Put the BCPL pointer back into D0

.return:
    MOVEM.L (A7)+,D2/D7/A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD
