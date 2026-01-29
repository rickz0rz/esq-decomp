LAB_19F7:
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

CLEANUP_SIGNAL_AND_MSGPORT:
    MOVEM.L A3/A6,-(A7)

    MOVEA.L 12(A7),A3
    TST.L   10(A3)
    BEQ.S   .LAB_19F9

    MOVEA.L A3,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVORemPort(A6)

.LAB_19F9:
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

LAB_19FA:
    LINK.W  A5,#-4
    MOVEM.L D2/D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    TST.L   -616(A4)
    BEQ.S   LAB_19FB

    JSR     LAB_1AD3(PC)

LAB_19FB:
    CLR.L   -640(A4)
    MOVE.L  A3,D1
    MOVEQ   #-2,D2
    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    JSR     _LVOLock(A6)

    MOVE.L  D0,D7
    TST.L   D7
    BEQ.S   LAB_19FC

    MOVE.L  D7,D1
    JSR     _LVOUnLock(A6)

    MOVEQ   #-1,D0
    BRA.S   LAB_19FE

LAB_19FC:
    MOVE.L  A3,D1
    MOVE.L  #MODE_NEWFILE,D2
    JSR     _LVOOpen(A6)

    MOVE.L  D0,D7
    TST.L   D7
    BNE.S   LAB_19FD

    JSR     _LVOIoErr(A6)

    MOVE.L  D0,-640(A4)
    MOVEQ   #2,D0
    MOVE.L  D0,22828(A4)
    MOVEQ   #-1,D0
    BRA.S   LAB_19FE

LAB_19FD:
    MOVE.L  D7,D0

LAB_19FE:
    MOVEM.L (A7)+,D2/D7/A3
    UNLK    A5
    RTS

;!======

LAB_19FF:
    LINK.W  A5,#-4
    MOVEM.L D2/D7/A3,-(A7)
    MOVEA.L 24(A7),A3

    TST.L   -616(A4)
    BEQ.S   .deleteFileIfExists

    JSR     LAB_1AD3(PC)

.deleteFileIfExists:
    CLR.L   -640(A4)                            ; Clear the long at -640(A4)
    MOVE.L  A3,D1                               ; Filename -> D1
    MOVEQ   #ACCESS_READ,D2                     ; Filemode = -2 = ACCESS_READ
    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    JSR     _LVOLock(A6)

    MOVE.L  D0,D7                               ; D0 = result as BCPL pointer, copied to D7
    TST.L   D7                                  ; Test D7 against 0
    BEQ.S   .lockFailed                         ; If equal (it's a 0), lock failed so branch to .lockFailed

    MOVE.L  D7,D1                               ; Move the BCPL pointer back
    JSR     _LVOUnLock(A6)                      ; Remove the same lock we just created

    MOVE.L  A3,D1                               ; Filename -> D1
    JSR     _LVODeleteFile(A6)                  ; Delete the file.

.lockFailed:
    MOVE.L  A3,D1                               ; Filename -> D1
    MOVE.L  #MODE_NEWFILE,D2                    ; Access mode = MODE_NEWFILE
    JSR     _LVOOpen(A6)                        ; Open zee file!

    MOVE.L  D0,D7                               ; D0 = result as BCPL pointer, copied to D7
    TST.L   D7                                  ; Test D7 against 0
    BNE.S   .fileSuccessfullyOpened             ; If it's not zero (we have a valid pointer) jump to .fileSuccessfullyOpened

    JSR     _LVOIoErr(A6)                       ; Jump to IOErr

    MOVE.L  D0,-640(A4)
    MOVEQ   #2,D0
    MOVE.L  D0,22828(A4)
    MOVEQ   #-1,D0
    BRA.S   .endSubRoutine

.fileSuccessfullyOpened:
    MOVE.L  D7,D0                               ; Put the BCPL pointer back into D0

.endSubRoutine:
    MOVEM.L (A7)+,D2/D7/A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD
