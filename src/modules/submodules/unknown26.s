    XDEF    DOS_WriteByIndex

;------------------------------------------------------------------------------
; FUNC: DOS_WriteByIndex   (Write using a handle index.)
; ARGS:
;   stack +24: D7 = handle index
;   stack +28: A3 = buffer pointer
;   stack +32: D6 = length
; RET:
;   D0: bytes written, or -1 on error
; CLOBBERS:
;   D0-D7/A2-A3
; CALLS:
;   HANDLE_GetEntryByIndex (HANDLE_GetEntryByIndex), DOS_SeekByIndex (seek), DOS_WriteWithErrorState (write)
; READS:
;   Global_DosIoErr, handle entry flags at 3(A2)
; DESC:
;   Resolves a handle index to its entry and writes through it.
;   If flag bit 3 is set, seeks before writing (mode 2, offset 0).
;------------------------------------------------------------------------------
DOS_WriteByIndex:
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVE.L  24(A7),D7
    MOVEA.L 28(A7),A3
    MOVE.L  32(A7),D6

    MOVE.L  D7,-(A7)
    JSR     HANDLE_GetEntryByIndex(PC)

    ADDQ.W  #4,A7
    MOVEA.L D0,A2
    MOVE.L  A2,D0
    BNE.S   .have_entry

    MOVEQ   #-1,D0
    BRA.S   .return

.have_entry:
    BTST    #3,3(A2)
    BEQ.S   .after_optional_seek

    PEA     2.W
    CLR.L   -(A7)
    MOVE.L  D7,-(A7)
    JSR     DOS_SeekByIndex(PC)

    LEA     12(A7),A7

.after_optional_seek:
    MOVE.L  D6,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  4(A2),-(A7)
    JSR     DOS_WriteWithErrorState(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5
    TST.L   Global_DosIoErr(A4)
    BEQ.S   .no_ioerr

    MOVEQ   #-1,D0
    BRA.S   .return

.no_ioerr:
    MOVE.L  D5,D0

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD
