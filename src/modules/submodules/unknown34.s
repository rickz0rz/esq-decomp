;------------------------------------------------------------------------------
; FUNC: DOS_ReadByIndex   (Read using a handle index.)
; ARGS:
;   stack +24: D7 = handle index
;   stack +28: A3 = buffer pointer
;   stack +32: D6 = length
; RET:
;   D0: bytes read, or -1 on error
; CLOBBERS:
;   D0-D7/A2-A3
; CALLS:
;   HANDLE_GetEntryByIndex (HANDLE_GetEntryByIndex), DOS_ReadWithErrorState (read)
; READS:
;   Global_DosIoErr
; DESC:
;   Resolves a handle index to its entry and reads through it.
;------------------------------------------------------------------------------
DOS_ReadByIndex:
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
    MOVE.L  D6,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  4(A2),-(A7)
    JSR     DOS_ReadWithErrorState(PC)

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

    DC.W    $0000

;!======

;------------------------------------------------------------------------------
; FUNC: LIST_InitHeader   (Initialize a list header/anchor.)
; ARGS:
;   stack +4: A0 = list header pointer
; RET:
;   D0: none observed
; CLOBBERS:
;   A0
; DESC:
;   Initializes fields so the list is empty but self-linked.
; NOTES:
;   Structure layout still unknown.
;------------------------------------------------------------------------------
LIST_InitHeader:
    MOVEA.L 4(A7),A0
    MOVE.L  A0,(A0)
    ADDQ.L  #4,(A0)
    CLR.L   4(A0)
    MOVE.L  A0,8(A0)
    RTS

;!======

    DC.W    $0000

;!======

;------------------------------------------------------------------------------
; FUNC: MEM_Move   (Overlap-safe byte copy.)
; ARGS:
;   stack +4:  A0 = source
;   stack +8:  A1 = destination
;   stack +12: D0 = length
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/A0-A1
; DESC:
;   Copies D0 bytes from A0 to A1, handling overlap (memmove).
;------------------------------------------------------------------------------
MEM_Move:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVE.L  12(A7),D0
    BLE.S   .done

    CMPA.L  A0,A1
    BCS.S   .copy_forward

    ADDA.L  D0,A0
    ADDA.L  D0,A1

.copy_backward:
    MOVE.B  -(A0),-(A1)
    SUBQ.L  #1,D0
    BNE.S   .copy_backward

    RTS

.copy_forward:
    MOVE.B  (A0)+,(A1)+
    SUBQ.L  #1,D0
    BNE.S   .copy_forward

.done:
    RTS

;!======

    ; Alignment
    ALIGN_WORD
