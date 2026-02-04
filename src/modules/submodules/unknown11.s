;------------------------------------------------------------------------------
; FUNC: DOS_SeekByIndex   (Seek using a handle index.)
; ARGS:
;   stack +24: D7 = handle index
;   stack +28: D6 = offset ??
;   stack +32: D5 = mode (OFFSET_BEGIN/CURRENT/END ??)
; RET:
;   D0: seek result, or -1 on error
; CLOBBERS:
;   D0-D7/A3
; CALLS:
;   HANDLE_GetEntryByIndex (HANDLE_GetEntryByIndex), DOS_SeekWithErrorState (seek)
; READS:
;   Global_DosIoErr
; DESC:
;   Resolves a handle index to its entry, then performs a seek on the handle.
;------------------------------------------------------------------------------
DOS_SeekByIndex:
    MOVEM.L D4-D7/A3,-(A7)
    MOVE.L  24(A7),D7
    MOVE.L  28(A7),D6
    MOVE.L  32(A7),D5
    MOVE.L  D7,-(A7)
    JSR     HANDLE_GetEntryByIndex(PC)

    ADDQ.W  #4,A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BNE.S   .have_entry

    MOVEQ   #-1,D0
    BRA.S   .return

.have_entry:
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  4(A3),-(A7)
    JSR     DOS_SeekWithErrorState(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D4
    TST.L   Global_DosIoErr(A4)
    BEQ.S   .no_ioerr

    MOVEQ   #-1,D0
    BRA.S   .return

.no_ioerr:
    MOVE.L  D4,D0

.return:
    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD
