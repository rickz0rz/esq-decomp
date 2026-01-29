LAB_19B7:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVE.L  20(A7),D7
    TST.L   D7
    BGT.S   LAB_19B8

    MOVEQ   #0,D0
    BRA.W   LAB_19BF

LAB_19B8:
    MOVEQ   #8,D0
    CMP.L   D0,D7
    BCC.S   LAB_19B9

    MOVE.L  D0,D7

LAB_19B9:
    MOVE.L  D7,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,D7
    ANDI.W  #$fffc,D7
    LEA     -1132(A4),A2
    MOVEA.L (A2),A3

LAB_19BA:
    MOVE.L  A3,D0
    BEQ.S   LAB_19BD

    MOVE.L  4(A3),D0
    CMP.L   D7,D0
    BLT.S   LAB_19BC

    CMP.L   D7,D0
    BNE.S   LAB_19BB

    MOVEA.L (A3),A0
    MOVE.L  A0,(A2)
    SUB.L   D7,-1128(A4)
    MOVE.L  A3,D0
    BRA.S   LAB_19BF

LAB_19BB:
    MOVE.L  4(A3),D0
    SUB.L   D7,D0
    MOVEQ   #8,D1
    CMP.L   D1,D0
    BCS.S   LAB_19BC

    MOVEA.L A3,A0
    ADDA.L  D7,A0
    MOVE.L  A0,(A2)
    MOVEA.L A0,A2
    MOVE.L  (A3),(A2)
    MOVE.L  D0,4(A2)
    SUB.L   D7,-1128(A4)
    MOVE.L  A3,D0
    BRA.S   LAB_19BF

LAB_19BC:
    MOVEA.L A3,A2
    MOVEA.L (A3),A3
    BRA.S   LAB_19BA

LAB_19BD:
    MOVE.L  D7,D0
    MOVE.L  -1012(A4),D1
    ADD.L   D1,D0
    SUBQ.L  #1,D0
    JSR     LAB_1A07(PC)

    MOVE.L  -1012(A4),D1
    JSR     LAB_1A06(PC)

    MOVE.L  D0,D6
    ADDQ.L  #8,D6
    MOVE.L  D6,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,D6
    ANDI.W  #$fffc,D6
    MOVE.L  D6,-(A7)
    JSR     LAB_1A29(PC)

    ADDQ.W  #4,A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BEQ.S   LAB_19BE

    MOVE.L  D6,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1A9D(PC)

    MOVE.L  D7,(A7)
    BSR.W   LAB_19B7

    ADDQ.W  #8,A7
    BRA.S   LAB_19BF

LAB_19BE:
    MOVEQ   #0,D0

LAB_19BF:
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    MOVEQ   #97,D0

;!======

LAB_19C0:
    MOVEM.L D7/A2,-(A7)
    MOVE.L  12(A7),D7
    ADDQ.L  #1,22824(A4)
    MOVEA.L 22820(A4),A0
    SUBQ.L  #1,12(A0)
    BLT.S   .LAB_19C1

    MOVEA.L 4(A0),A1
    LEA     1(A1),A2
    MOVE.L  A2,4(A0)
    MOVE.L  D7,D0
    MOVE.B  D0,(A1)
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .LAB_19C2

.LAB_19C1:
    MOVE.L  D7,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  A0,-(A7)
    MOVE.L  D1,-(A7)
    JSR     LAB_1916(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D1

.LAB_19C2:
    MOVEM.L (A7)+,D7/A2
    RTS

;!======

LAB_19C3:
    LINK.W  A5,#0
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEA.L 20(A7),A2
    CLR.L   22824(A4)
    MOVE.L  A3,22820(A4)
    PEA     16(A5)
    MOVE.L  A2,-(A7)
    PEA     LAB_19C0(PC)
    JSR     WDISP_FormatWithCallback(PC)

    MOVE.L  A3,(A7)
    PEA     -1.W
    JSR     LAB_1916(PC)

    MOVE.L  22824(A4),D0
    MOVEM.L -8(A5),A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_19C4:
    LINK.W  A5,#-16
    MOVEM.L D4-D7/A2-A3,-(A7)

    MOVEA.L 52(A7),A3
    MOVEA.L 56(A7),A2

    TST.L   24(A2)
    BEQ.S   LAB_19C5

    MOVE.L  A2,-(A7)
    JSR     LAB_1AB9(PC)

    ADDQ.W  #4,A7

LAB_19C5:
    MOVE.L  -1016(A4),D5
    MOVEQ   #1,D7
    MOVEQ   #0,D0
    MOVE.B  0(A3,D7.L),D0
    CMPI.W  #$62,D0
    BEQ.S   LAB_19C6

    CMPI.W  #$61,D0
    BNE.S   LAB_19C8

    MOVEQ   #0,D5
    BRA.S   LAB_19C7

LAB_19C6:
    MOVE.L  #$8000,D5

LAB_19C7:
    ADDQ.L  #1,D7

LAB_19C8:
    MOVEQ   #43,D1
    CMP.B   0(A3,D7.L),D1
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    CMPI.W  #$77,D0
    BEQ.W   LAB_19D2

    CMPI.W  #$72,D0
    BEQ.S   LAB_19CC

    CMPI.W  #$61,D0
    BNE.W   LAB_19D8

    PEA     12.W
    MOVE.L  #$8102,-(A7)
    MOVE.L  8(A5),-(A7)
    JSR     LAB_19A1(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D6
    MOVEQ   #-1,D0
    CMP.L   D0,D6
    BNE.S   LAB_19C9

    MOVEQ   #0,D0
    BRA.W   LAB_19DB

LAB_19C9:
    TST.L   D4
    BEQ.S   LAB_19CA

    MOVEQ   #64,D0
    ADD.L   D0,D0
    BRA.S   LAB_19CB

LAB_19CA:
    MOVEQ   #2,D0

LAB_19CB:
    MOVE.L  D0,D7
    ORI.W   #$4000,D7
    BRA.W   LAB_19D9

LAB_19CC:
    TST.L   D4
    BEQ.S   LAB_19CD

    MOVEQ   #2,D0
    BRA.S   LAB_19CE

LAB_19CD:
    MOVEQ   #0,D0

LAB_19CE:
    ORI.W   #$8000,D0
    PEA     12.W
    MOVE.L  D0,-(A7)
    MOVE.L  8(A5),-(A7)
    JSR     LAB_19A1(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D6
    MOVEQ   #-1,D0
    CMP.L   D0,D6
    BNE.S   LAB_19CF

    MOVEQ   #0,D0
    BRA.W   LAB_19DB

LAB_19CF:
    TST.L   D4
    BEQ.S   LAB_19D0

    MOVEQ   #64,D0
    ADD.L   D0,D0
    BRA.S   LAB_19D1

LAB_19D0:
    MOVEQ   #1,D0

LAB_19D1:
    MOVE.L  D0,D7
    BRA.S   LAB_19D9

LAB_19D2:
    TST.L   D4
    BEQ.S   LAB_19D3

    MOVEQ   #2,D0
    BRA.S   LAB_19D4

LAB_19D3:
    MOVEQ   #1,D0

LAB_19D4:
    ORI.W   #$8000,D0
    ORI.W   #$100,D0
    ORI.W   #$200,D0
    PEA     12.W
    MOVE.L  D0,-(A7)
    MOVE.L  8(A5),-(A7)
    JSR     LAB_19A1(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D6
    MOVEQ   #-1,D0
    CMP.L   D0,D6
    BNE.S   LAB_19D5

    MOVEQ   #0,D0
    BRA.S   LAB_19DB

LAB_19D5:
    TST.L   D4
    BEQ.S   LAB_19D6

    MOVEQ   #64,D0
    ADD.L   D0,D0
    BRA.S   LAB_19D7

LAB_19D6:
    MOVEQ   #2,D0

LAB_19D7:
    MOVE.L  D0,D7
    BRA.S   LAB_19D9

LAB_19D8:
    MOVEQ   #0,D0
    BRA.S   LAB_19DB

LAB_19D9:
    SUBA.L  A0,A0
    MOVE.L  A0,16(A2)
    MOVEQ   #0,D0
    MOVE.L  D0,20(A2)
    MOVE.L  D6,28(A2)
    MOVE.L  16(A2),4(A2)
    MOVE.L  D0,12(A2)
    MOVE.L  D0,8(A2)
    TST.L   D5
    BNE.S   LAB_19DA

    MOVE.L  #$8000,D0

LAB_19DA:
    MOVE.L  D7,D1
    OR.L    D0,D1
    MOVE.L  D1,24(A2)
    MOVE.L  A2,D0

LAB_19DB:
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_19DC:
    MOVEM.L D4-D7/A2-A3,-(A7)

    MOVEA.L 28(A7),A3
    MOVE.L  32(A7),D7
    MOVEA.L 36(A7),A2

    MOVE.L  A3,D4
    SUBQ.L  #1,D7
    MOVE.L  D7,D6

.LAB_19DD:
    TST.L   D6
    BMI.S   .LAB_19E0

    SUBQ.L  #1,8(A2)
    BLT.S   .LAB_19DE

    MOVEA.L 4(A2),A0
    LEA     1(A0),A1
    MOVE.L  A1,4(A2)
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    BRA.S   .LAB_19DF

.LAB_19DE:
    MOVE.L  A2,-(A7)
    JSR     LAB_1934(PC)

    ADDQ.W  #4,A7

.LAB_19DF:
    MOVE.L  D0,D5
    MOVEQ   #-1,D0
    CMP.L   D0,D5
    BEQ.S   .LAB_19E0

    SUBQ.L  #1,D6
    MOVE.L  D5,D0
    MOVE.B  D0,(A3)+
    MOVEQ   #10,D1
    CMP.L   D1,D5
    BNE.S   .LAB_19DD

.LAB_19E0:
    CLR.B   (A3)
    CMP.L   D7,D6
    BNE.S   .LAB_19E1

    MOVEQ   #0,D0
    BRA.S   .return

.LAB_19E1:
    MOVEA.L D4,A0
    MOVE.L  A0,D0

.return:
    MOVEM.L (A7)+,D4-D7/A2-A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LIBRARIES_LOAD_FAILED:
    MOVEM.L D6-D7/A3,-(A7)
    MOVE.L  16(A7),D7
    LEA     -1120(A4),A3

.LAB_19E4:
    MOVE.L  A3,D0
    BEQ.S   .LAB_19E6

    BTST    #2,27(A3)
    BNE.S   .LAB_19E5

    BTST    #1,27(A3)
    BEQ.S   .LAB_19E5

    MOVE.L  4(A3),D0
    SUB.L   16(A3),D0
    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   .LAB_19E5

    MOVE.L  D6,-(A7)
    MOVE.L  16(A3),-(A7)
    MOVE.L  28(A3),-(A7)
    JSR     LAB_1A34(PC)

    LEA     12(A7),A7

.LAB_19E5:
    MOVEA.L (A3),A3
    BRA.S   .LAB_19E4

.LAB_19E6:
    MOVE.L  D7,-(A7)
    JSR     LAB_1A92(PC)

    ADDQ.W  #4,A7
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_19E7:
    MOVEM.L D2-D3/D5-D7/A3,-(A7)

    MOVE.L  28(A7),D7
    MOVEA.L 32(A7),A3
    MOVE.L  36(A7),D6

    TST.L   -616(A4)
    BEQ.S   .LAB_19E8

    JSR     LAB_1AD3(PC)

.LAB_19E8:
    CLR.L   -640(A4)
    MOVE.L  D7,D1
    MOVE.L  A3,D2
    MOVE.L  D6,D3
    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    JSR     _LVOWrite(A6)

    MOVE.L  D0,D5
    MOVEQ   #-1,D0
    CMP.L   D0,D5
    BNE.S   .LAB_19E9

    JSR     _LVOIoErr(A6)

    MOVE.L  D0,-640(A4)
    MOVEQ   #5,D0
    MOVE.L  D0,22828(A4)

.LAB_19E9:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D2-D3/D5-D7/A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_19EA:
    MOVEM.L D2-D7,-(A7)

    MOVE.L  28(A7),D7
    MOVE.L  32(A7),D6
    MOVE.L  36(A7),D5

    TST.L   -616(A4)
    BEQ.S   .LAB_19EB

    JSR     LAB_1AD3(PC)

.LAB_19EB:
    CLR.L   -640(A4)
    MOVE.L  D5,D0
    SUBQ.L  #(OFFSET_END),D0
    MOVE.L  D7,D1
    MOVE.L  D6,D2
    MOVE.L  D0,D3
    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    JSR     _LVOSeek(A6)

    MOVE.L  D0,D4
    MOVEQ   #-1,D0
    CMP.L   D0,D4
    BNE.S   .LAB_19EC

    JSR     _LVOIoErr(A6)

    MOVE.L  D0,-640(A4)
    MOVEQ   #22,D0
    MOVE.L  D0,22828(A4)

.LAB_19EC:
    MOVE.L  D5,D0
    CMPI.L  #$2,D0
    BEQ.S   .LAB_19EE

    CMPI.L  #$1,D0
    BEQ.S   .LAB_19ED

    TST.L   D0
    BNE.S   .return

    MOVE.L  D6,D0
    BRA.S   .return

.LAB_19ED:
    MOVE.L  D4,D0
    ADD.L   D6,D0
    BRA.S   .return

.LAB_19EE:
    MOVE.L  D7,D1
    MOVEQ   #0,D2
    MOVEQ   #(OFFSET_CURRENT),D3
    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    JSR     _LVOSeek(A6)

.return:
    MOVEM.L (A7)+,D2-D7
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_19F0:
    MOVEM.L D2-D3/D5-D7/A3,-(A7)

    MOVE.L  28(A7),D7
    MOVEA.L 32(A7),A3
    MOVE.L  36(A7),D6

    TST.L   -616(A4)
    BEQ.S   .LAB_19F1

    JSR     LAB_1AD3(PC)

.LAB_19F1:
    CLR.L   -640(A4)
    MOVE.L  D7,D1
    MOVE.L  A3,D2
    MOVE.L  D6,D3
    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    JSR     _LVORead(A6)

    MOVE.L  D0,D5
    MOVEQ   #-1,D0
    CMP.L   D0,D5
    BNE.S   .return

    JSR     _LVOIoErr(A6)

    MOVE.L  D0,-640(A4)
    MOVEQ   #5,D0
    MOVE.L  D0,22828(A4)

.return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D2-D3/D5-D7/A3
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    DC.W    $0000

;!======

LAB_19F3:
    MOVEM.L D2/D6-D7/A3,-(A7)

    MOVEA.L 20(A7),A3
    MOVE.L  24(A7),D7

    TST.L   -616(A4)
    BEQ.S   .LAB_19F4

    JSR     LAB_1AD3(PC)

.LAB_19F4:
    CLR.L   -640(A4)
    MOVE.L  A3,D1
    MOVE.L  D7,D2
    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    JSR     _LVOOpen(A6)

    MOVE.L  D0,D6
    TST.L   D6
    BNE.S   .LAB_19F5

    JSR     _LVOIoErr(A6)

    MOVE.L  D0,-640(A4)
    MOVEQ   #2,D0
    MOVE.L  D0,22828(A4)
    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_19F5:
    MOVE.L  D6,D0

.return:
    MOVEM.L (A7)+,D2/D6-D7/A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

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

;!======

LAB_1A04:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    TST.L   -616(A4)
    BEQ.S   .LAB_1A05

    JSR     LAB_1AD3(PC)

.LAB_1A05:
    MOVE.L  D7,D1
    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    JSR     _LVOClose(A6)

    MOVEQ   #0,D0
    MOVE.L  (A7)+,D7
    RTS

;!======

; what fancy banana pants math is going on here?
LAB_1A06:
    MOVEM.L D2-D3,-(A7)

    MOVE.L  D0,D2
    MOVE.L  D1,D3
    SWAP    D2          ; D2 swaps upper and lower words
    SWAP    D3          ; Same for D3
    MULU    D1,D2       ; Multiply D1 and D2 unsigned (just the lower word?), store in D2
    MULU    D0,D3       ; Multiple D0 and D3 unsigned, store in D3
    MULU    D1,D0       ;
    ADD.W   D3,D2       ; Add lower D3 and D2 words into D2
    SWAP    D2          ; Make the lower D2 word upper
    CLR.W   D2          ; Clear the lower D2 word
    ADD.L   D2,D0       ; Add D2 into D0

    MOVEM.L (A7)+,D2-D3
    RTS

;!======

LAB_1A07:
    TST.L   D0
    BPL.W   LAB_1A09

    NEG.L   D0
    TST.L   D1
    BPL.W   LAB_1A08

    NEG.L   D1
    BSR.W   LAB_1A0A

    NEG.L   D1
    RTS

;!======

LAB_1A08:
    BSR.W   LAB_1A0A

    NEG.L   D0
    NEG.L   D1
    RTS

;!======

LAB_1A09:
    TST.L   D1
    BPL.W   LAB_1A0A

    NEG.L   D1
    BSR.W   LAB_1A0A

    NEG.L   D0
    RTS

;!======

LAB_1A0A:
    MOVE.L  D2,-(A7)

    SWAP    D1
    MOVE.W  D1,D2
    BNE.W   LAB_1A0C

    SWAP    D0
    SWAP    D1
    SWAP    D2
    MOVE.W  D0,D2
    BEQ.W   .LAB_1A0B

    DIVU    D1,D2
    MOVE.W  D2,D0

.LAB_1A0B:
    SWAP    D0
    MOVE.W  D0,D2
    DIVU    D1,D2
    MOVE.W  D2,D0
    SWAP    D2
    MOVE.W  D2,D1

    MOVE.L  (A7)+,D2
    RTS

;!======

LAB_1A0C:
    MOVE.L  D3,-(A7)
    MOVEQ   #16,D3
    CMPI.W  #$80,D1
    BCC.W   .LAB_1A0D

    ROL.L   #8,D1
    SUBQ.W  #8,D3

.LAB_1A0D:
    CMPI.W  #$800,D1
    BCC.W   .LAB_1A0E

    ROL.L   #4,D1
    SUBQ.W  #4,D3

.LAB_1A0E:
    CMPI.W  #$2000,D1
    BCC.W   .LAB_1A0F

    ROL.L   #2,D1
    SUBQ.W  #2,D3

.LAB_1A0F:
    TST.W   D1
    BMI.W   .LAB_1A10

    ROL.L   #1,D1
    SUBQ.W  #1,D3

.LAB_1A10:
    MOVE.W  D0,D2
    LSR.L   D3,D0
    SWAP    D2
    CLR.W   D2
    LSR.L   D3,D2
    SWAP    D3
    DIVU    D1,D0
    MOVE.W  D0,D3
    MOVE.W  D2,D0
    MOVE.W  D3,D2
    SWAP    D1
    MULU    D1,D2
    SUB.L   D2,D0
    BCC.W   .LAB_1A12

    SUBQ.W  #1,D3
    ADD.L   D1,D0

.LAB_1A11:
    BCC.S   .LAB_1A11

.LAB_1A12:
    MOVEQ   #0,D1
    MOVE.W  D3,D1
    SWAP    D3
    ROL.L   D3,D0
    SWAP    D0
    EXG     D0,D1
    MOVE.L  (A7)+,D3
    MOVE.L  (A7)+,D2
    RTS

;!======

ALLOCATE_IOSTDREQ:
    MOVEM.L A2-A3/A6,-(A7)

    SetOffsetForStack 3

    MOVEA.L (.stackOffsetBytes+4)(A7),A3    ; Pass the last address pushed to the stack before calling this subroutine in A3
    MOVE.L  A3,D0               ; ...then move it to D0
    BNE.S   .a3NotZero          ; If it's not 0, jump.

    MOVEQ   #0,D0               ; Set D0 to 0
    BRA.S   .return             ; ... and terminate.

.a3NotZero:
    MOVEQ   #48,D0              ; Struct_IOStdReq_Size = 48 (can't use the def here becaues MOVEQ though)
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAllocMem(A6)

    MOVEA.L D0,A2               ; D0 is a pointer, so grab the value of D0 as an address, and move it to A2.
    MOVE.L  A2,D0               ; Then grab the value and put it in D0.
    BEQ.S   .setA2ToD0          ; If it's zero jump

    MOVE.B  #(NT_MESSAGE),(Struct_IOStdReq__io_Message+Struct__Message__mn_Node+Struct_Node__ln_Type)(A2)
    CLR.B   (Struct_IOStdReq__io_Message+Struct__Message__mn_Node+Struct_Node__ln_Pri)(A2)
    MOVE.L  A3,(Struct_IOStdReq__io_Message+Struct__Message__mn_ReplyPort)(A2)

.setA2ToD0:
    MOVE.L  A2,D0               ; Copy value A2 to D0

.return:
    MOVEM.L (A7)+,A2-A3/A6
    RTS

;!======

SETUP_SIGNAL_AND_MSGPORT:
    MOVEM.L D6-D7/A2-A3/A6,-(A7)

    SetOffsetForStack 5

    MOVEA.L (.stackOffsetBytes+4)(A7),A3
    MOVE.L  (.stackOffsetBytes+8)(A7),D7

    ; Allocate a signal, with...
    MOVEQ   #-1,D0              ; no preference on the signal number (-1)
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAllocSignal(A6)

    MOVE.L  D0,D6               ; Returned signal #
    CMPI.B  #(-1),D6            ; Compare to -1 (No signals available)
    BNE.S   .gotSignal          ; If it's not equal, jump

    MOVEQ   #0,D0               ; Set D0 to 0
    BRA.S   .return

.gotSignal:
    MOVEQ   #34,D0              ; Allocate enough memory for a MsgPort struct (34 bytes)
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),D1
    JSR     _LVOAllocMem(A6)

    MOVEA.L D0,A2               ; Store the response from the alloc in D0 to A2 as an address
    MOVE.L  A2,D0               ; Store the value back from A2 to D0 (to utilize it for the BNE)
    BNE.S   .populateMsgPort    ; If it's not 0 (we were able to allocate the memory), jump to .populateMsgPort

    MOVEQ   #0,D0               ; Clear out D0
    MOVE.B  D6,D0               ; Move the signal byte (signal number) we got earlier back into D0 from D6
    JSR     _LVOFreeSignal(A6)  ; free that signal

    BRA.S   .setReturnValue     ; Jump to .setReturnValue

; Here we're just populating a bunch of stuff into the
; memory we allocated earlier (for the MsgPort struct)
; so this looks pretty ugly.
.populateMsgPort:
    MOVE.L  A3,(Struct_MsgPort__mp_Node+Struct_Node__ln_Name)(A2)
    MOVE.L  D7,D0               ; D7 is some value on the stack passed in..
    MOVE.B  D0,(Struct_MsgPort__mp_Node+Struct_Node__ln_Pri)(A2)
    MOVE.B  #(NT_MSGPORT),(Struct_MsgPort__mp_Node+Struct_Node__ln_Type)(A2)
    CLR.B   Struct_MsgPort__mp_Flags(A2)
    MOVE.B  D6,Struct_MsgPort__mp_SigBit(A2)
    SUBA.L  A1,A1               ; A1 = A1 - A1 (zero out A1 in a single instruction?)
    JSR     _LVOFindTask(A6)    ; Find the task in A1. Since A1 is null,

                                ; it returns a pointer to the current task.

    MOVE.L  D0,Struct_MsgPort__mp_SigTask(A2) ; Copy the task we got previously
    MOVE.L  A3,D0               ; Put A3 into D0 so we can...
    BEQ.S   .LAB_1A1A           ; ...jump if A3/D0 is 0

    MOVEA.L A2,A1               ; A1 = A2
    JSR     _LVOAddPort(A6)     ; Add port

    BRA.S   .setReturnValue

.LAB_1A1A:
    LEA     24(A2),A0
    MOVE.L  A0,20(A2)
    LEA     20(A2),A0
    MOVE.L  A0,28(A2)
    CLR.L   24(A2)
    MOVE.B  #$2,32(A2)

.setReturnValue:
    MOVE.L  A2,D0                   ; Move A2 into D0 for consumption

.return:
    MOVEM.L (A7)+,D6-D7/A2-A3/A6
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_1A1D:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7

    MOVEQ   #0,D0
    MOVE.L  D0,-640(A4)
    TST.L   D7
    BMI.S   .LAB_1A1E

    CMP.L   -1148(A4),D7
    BGE.S   .LAB_1A1E

    MOVE.L  D7,D0
    ASL.L   #3,D0
    LEA     22492(A4),A0
    TST.L   0(A0,D0.L)
    BEQ.S   .LAB_1A1E

    MOVE.L  D7,D0
    ASL.L   #3,D0
    LEA     22492(A4),A0
    ADDA.L  D0,A0
    MOVE.L  A0,D0
    BRA.S   .return

.LAB_1A1E:
    MOVEQ   #9,D0
    MOVE.L  D0,22828(A4)
    MOVEQ   #0,D0

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_1A20:
    LINK.W  A5,#-4
    MOVE.L  A3,-(A7)
    MOVEA.L 16(A7),A3

    MOVE.L  A3,D0
    BNE.S   .LAB_1A21

    MOVEQ   #0,D0
    BRA.S   .return

.LAB_1A21:
    MOVE.L  A3,-(A7)
    JSR     LAB_1985(PC)

    MOVEA.L D0,A3
    PEA     -4(A5)
    MOVE.L  A3,-(A7)
    JSR     LAB_1992(PC)

    MOVE.L  -4(A5),D0

.return:
    MOVEA.L -8(A5),A3
    UNLK    A5
    RTS

;!======

LAB_1A23:
    LINK.W  A5,#-4
    MOVE.L  A3,-(A7)
    MOVEA.L 16(A7),A3

    MOVE.L  A3,D0
    BNE.S   .LAB_1A24

    MOVEQ   #0,D0
    BRA.S   .return

.LAB_1A24:
    MOVE.L  A3,-(A7)
    JSR     LAB_1985(PC)

    MOVEA.L D0,A3
    PEA     -4(A5)
    MOVE.L  A3,-(A7)
    JSR     LAB_199A(PC)

    MOVE.L  -4(A5),D0

.return:
    MOVEA.L -8(A5),A3
    UNLK    A5
    RTS

;!======

LAB_1A26:
    MOVEM.L A2-A3/A6,-(A7)
    MOVEA.L 22836(A4),A3

.LAB_1A27:
    MOVE.L  A3,D0
    BEQ.S   .LAB_1A28

    MOVEA.L (A3),A2
    MOVEA.L A3,A1
    MOVE.L  8(A3),D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOFreeMem(A6)

    MOVEA.L A2,A3
    BRA.S   .LAB_1A27

.LAB_1A28:
    SUBA.L  A0,A0
    MOVE.L  A0,22840(A4)
    MOVE.L  A0,22836(A4)
    MOVEM.L (A7)+,A2-A3/A6
    RTS

;!======

LAB_1A29:
    MOVEM.L D7/A2-A3/A6,-(A7)
    MOVE.L  20(A7),D7

    MOVEQ   #12,D0
    ADD.L   D0,D7
    MOVE.L  D7,D0
    MOVEQ   #0,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAllocMem(A6)

    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BNE.S   .LAB_1A2A

    MOVEQ   #0,D0
    BRA.S   .return

.LAB_1A2A:
    MOVE.L  D7,8(A3)
    LEA     22836(A4),A2
    MOVEA.L 4(A2),A0
    MOVE.L  A0,4(A3)
    SUBA.L  A0,A0
    MOVE.L  A0,(A3)
    TST.L   (A2)
    BNE.S   .LAB_1A2B

    MOVE.L  A3,(A2)

.LAB_1A2B:
    TST.L   4(A2)
    BEQ.S   .LAB_1A2C

    MOVEA.L 4(A2),A1
    MOVE.L  A3,(A1)

.LAB_1A2C:
    MOVE.L  A3,4(A2)
    TST.L   -1144(A4)
    BNE.S   .LAB_1A2D

    MOVE.L  A3,-1144(A4)

.LAB_1A2D:
    LEA     12(A3),A0
    MOVE.L  A0,D0

.return:
    MOVEM.L (A7)+,D7/A2-A3/A6
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    DC.W    $0000

;!======

LAB_1A2F:
    MOVEM.L A3/A6,-(A7)
    MOVEA.L 12(A7),A3

    MOVE.B  #$ff,8(A3)
    MOVEA.W #$ffff,A0
    MOVE.L  A0,20(A3)
    MOVE.L  A0,24(A3)
    MOVEQ   #0,D0

    ; This must be pointing to a property in a struct?
    MOVE.W  18(A3),D0
    MOVEA.L A3,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOFreeMem(A6)

    MOVEM.L (A7)+,A3/A6
    RTS

;!======

; dynamically allocate memory
LAB_1A30:
    MOVEM.L D7/A2-A3/A6,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.L  24(A7),D7
    MOVE.L  A3,D0
    BNE.S   .LAB_1A31

    MOVEQ   #0,D0
    BRA.S   .return

.LAB_1A31:
    MOVE.L  D7,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAllocMem(A6)

    MOVEA.L D0,A2
    MOVE.L  A2,D0
    BEQ.S   .failedToAllocateMemory

    MOVE.B  #$5,8(A2)
    CLR.B   9(A2)
    MOVE.L  A3,14(A2)
    MOVE.L  D7,D0
    MOVE.W  D0,18(A2)

.failedToAllocateMemory:
    MOVE.L  A2,D0

.return:
    MOVEM.L (A7)+,D7/A2-A3/A6
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_1A34:
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVE.L  24(A7),D7
    MOVEA.L 28(A7),A3
    MOVE.L  32(A7),D6

    MOVE.L  D7,-(A7)
    JSR     LAB_1A1D(PC)

    ADDQ.W  #4,A7
    MOVEA.L D0,A2
    MOVE.L  A2,D0
    BNE.S   .LAB_1A35

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_1A35:
    BTST    #3,3(A2)
    BEQ.S   .LAB_1A36

    PEA     2.W
    CLR.L   -(A7)
    MOVE.L  D7,-(A7)
    JSR     LAB_19B3(PC)

    LEA     12(A7),A7

.LAB_1A36:
    MOVE.L  D6,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  4(A2),-(A7)
    JSR     LAB_19E7(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5
    TST.L   -640(A4)
    BEQ.S   .LAB_1A37

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_1A37:
    MOVE.L  D5,D0

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_1A39:
    MOVE.L  D7,-(A7)

    MOVE.L  8(A7),D7
    ADDQ.L  #1,22852(A4)
    MOVE.L  D7,D0
    MOVEA.L 22848(A4),A0
    MOVE.B  D0,(A0)+
    MOVE.L  A0,22848(A4)

    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_1A3A:
    LINK.W  A5,#0
    MOVEM.L A2-A3,-(A7)

    MOVEA.L 16(A7),A3
    MOVEA.L 20(A7),A2
    CLR.L   22852(A4)
    MOVE.L  A3,22848(A4)
    MOVE.L  16(A5),-(A7)
    MOVE.L  A2,-(A7)
    PEA     LAB_1A39(PC)
    JSR     WDISP_FormatWithCallback(PC)

    MOVEA.L 22848(A4),A0
    CLR.B   (A0)
    MOVE.L  22852(A4),D0

    MOVEM.L -8(A5),A2-A3
    UNLK    A5
    RTS

;!======

; More core printf logic
LAB_1A3B:
    LINK.W  A5,#-60
    MOVEM.L D2/D5-D7/A2-A3,-(A7)
    MOVEA.L 92(A7),A3
    MOVEA.L 96(A7),A2

    MOVEQ   #0,D7
    MOVEQ   #0,D6
    MOVEQ   #0,D5
    MOVEQ   #0,D0
    MOVE.B  #$20,-5(A5)
    MOVEQ   #0,D1
    MOVE.L  D1,-10(A5)
    MOVEQ   #-1,D2
    MOVE.L  D2,-14(A5)
    LEA     -48(A5),A0
    MOVE.B  D0,-15(A5)
    MOVE.B  D0,-4(A5)
    MOVE.L  D1,-28(A5)
    MOVE.L  D1,-24(A5)
    MOVE.L  A0,-52(A5)

.LAB_1A3C:
    TST.B   (A3)
    BEQ.S   .LAB_1A41

    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    SUBI.W  #' ',D0
    BEQ.S   .LAB_1A3E

    SUBQ.W  #3,D0
    BEQ.S   .LAB_1A3F

    SUBQ.W  #8,D0
    BEQ.S   .LAB_1A3D

    SUBQ.W  #2,D0
    BNE.S   .LAB_1A41

    MOVEQ   #1,D7
    BRA.S   .LAB_1A40

.LAB_1A3D:
    MOVEQ   #1,D6
    BRA.S   .LAB_1A40

.LAB_1A3E:
    MOVEQ   #1,D5
    BRA.S   .LAB_1A40

.LAB_1A3F:
    MOVE.B  #$1,-4(A5)

.LAB_1A40:
    ADDQ.L  #1,A3
    BRA.S   .LAB_1A3C

.LAB_1A41:
    MOVE.B  (A3),D0
    MOVEQ   #'0',D1
    CMP.B   D1,D0
    BNE.S   .LAB_1A42

    ADDQ.L  #1,A3
    MOVE.B  D1,-5(A5)

.LAB_1A42:
    MOVEQ   #'*',D0
    CMP.B   (A3),D0
    BNE.S   .LAB_1A43

    MOVEA.L (A2),A0
    ADDQ.L  #4,(A2)
    MOVE.L  (A0),-10(A5)
    ADDQ.L  #1,A3
    BRA.S   .LAB_1A44

.LAB_1A43:
    PEA     -10(A5)
    MOVE.L  A3,-(A7)
    JSR     LAB_199A(PC)

    ADDQ.W  #8,A7
    ADDA.L  D0,A3

.LAB_1A44:
    MOVE.B  (A3),D0
    MOVEQ   #'.',D1
    CMP.B   D1,D0
    BNE.S   .LAB_1A46

    ADDQ.L  #1,A3
    MOVEQ   #'*',D0
    CMP.B   (A3),D0
    BNE.S   .LAB_1A45

    MOVEA.L (A2),A0
    ADDQ.L  #4,(A2)
    MOVE.L  (A0),-14(A5)
    ADDQ.L  #1,A3
    BRA.S   .LAB_1A46

.LAB_1A45:
    PEA     -14(A5)
    MOVE.L  A3,-(A7)
    JSR     LAB_199A(PC)

    ADDQ.W  #8,A7
    ADDA.L  D0,A3

.LAB_1A46:
    MOVE.B  (A3),D0
    MOVEQ   #'l',D1
    CMP.B   D1,D0
    BNE.S   .LAB_1A47

    MOVE.B  #$1,-15(A5)
    ADDQ.L  #1,A3
    BRA.S   .LAB_1A48

.LAB_1A47:
    MOVEQ   #104,D1
    CMP.B   D1,D0

    BNE.S   .LAB_1A48

    ADDQ.L  #1,A3

.LAB_1A48:
    MOVE.B  (A3)+,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.B  D0,-16(A5)
    SUBI.W  #$58,D1
    BEQ.W   .LAB_1A5E

    SUBI.W  #11,D1
    BEQ.W   .LAB_1A65

    SUBQ.W  #1,D1
    BEQ.S   .LAB_1A49

    SUBI.W  #11,D1
    BEQ.W   .LAB_1A59

    SUBQ.W  #1,D1
    BEQ.W   .LAB_1A5D

    SUBQ.W  #3,D1
    BEQ.W   .LAB_1A62

    SUBQ.W  #2,D1
    BEQ.W   .LAB_1A56

    SUBQ.W  #3,D1
    BEQ.W   .LAB_1A5E

    BRA.W   .LAB_1A66

.LAB_1A49:
    TST.B   -15(A5)
    BEQ.S   .LAB_1A4A

    MOVEA.L (A2),A0
    ADDQ.L  #4,(A2)
    MOVE.L  (A0),D0
    BRA.S   .LAB_1A4B

.LAB_1A4A:
    MOVEA.L (A2),A0
    ADDQ.L  #4,(A2)
    MOVE.L  (A0),D0

.LAB_1A4B:
    MOVE.L  D0,-20(A5)
    BGE.S   .LAB_1A4C

    MOVEQ   #1,D1
    NEG.L   -20(A5)
    MOVE.L  D1,-24(A5)

.LAB_1A4C:
    TST.L   -24(A5)
    BEQ.S   .LAB_1A4D

    MOVEQ   #'-',D0
    BRA.S   .LAB_1A4F

.LAB_1A4D:
    TST.B   D6
    BEQ.S   .LAB_1A4E

    MOVEQ   #'+',D0
    BRA.S   .LAB_1A4F

.LAB_1A4E:
    MOVEQ   #32,D0

.LAB_1A4F:
    MOVE.B  D0,-48(A5)
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  -24(A5),D1
    OR.L    D0,D1
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    OR.L    D0,D1
    BEQ.S   .LAB_1A50

    ADDQ.L  #1,-52(A5)
    ADDQ.L  #1,-28(A5)

.LAB_1A50:
    MOVE.L  -20(A5),-(A7)
    MOVE.L  -52(A5),-(A7)
    JSR     LAB_1988(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-56(A5)

.LAB_1A51:
    MOVE.L  -14(A5),D0
    TST.L   D0
    BPL.S   .LAB_1A52

    MOVEQ   #1,D1
    MOVE.L  D1,-14(A5)

.LAB_1A52:
    MOVE.L  -56(A5),D0
    MOVE.L  -14(A5),D1
    SUB.L   D0,D1
    MOVEM.L D1,-60(A5)
    BLE.S   .LAB_1A55

    MOVEA.L -52(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1AAE(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVE.L  -60(A5),D1
    MOVEA.L -52(A5),A0
    BRA.S   .LAB_1A54

.LAB_1A53:
    MOVE.B  D0,(A0)+

.LAB_1A54:
    SUBQ.L  #1,D1
    BCC.S   .LAB_1A53

    MOVE.L  -14(A5),D0
    MOVE.L  D0,-56(A5)

.LAB_1A55:
    ADD.L   D0,-28(A5)
    LEA     -48(A5),A0
    MOVE.L  A0,-52(A5)
    TST.B   D7
    BEQ.W   .LAB_1A67

    MOVE.B  #' ',-5(A5)
    BRA.W   .LAB_1A67

.LAB_1A56:
    TST.B   -15(A5)
    BEQ.S   .LAB_1A57

    MOVEA.L (A2),A0
    ADDQ.L  #4,(A2)
    MOVE.L  (A0),D0
    BRA.S   .LAB_1A58

.LAB_1A57:
    MOVEA.L (A2),A0
    ADDQ.L  #4,(A2)
    MOVE.L  (A0),D0

.LAB_1A58:
    MOVE.L  D0,-20(A5)
    BRA.W   .LAB_1A50

.LAB_1A59:
    TST.B   -15(A5)
    BEQ.S   .LAB_1A5A

    MOVEA.L (A2),A0
    ADDQ.L  #4,(A2)
    MOVE.L  (A0),D0
    BRA.S   .LAB_1A5B

.LAB_1A5A:
    MOVEA.L (A2),A0
    ADDQ.L  #4,(A2)
    MOVE.L  (A0),D0

.LAB_1A5B:
    MOVE.L  D0,-20(A5)
    TST.B   -4(A5)
    BEQ.S   .LAB_1A5C

    MOVEA.L -52(A5),A0
    MOVE.B  #$30,(A0)+
    MOVEQ   #1,D1
    MOVE.L  D1,-28(A5)
    MOVE.L  A0,-52(A5)

.LAB_1A5C:
    MOVE.L  D0,-(A7)
    MOVE.L  -52(A5),-(A7)
    JSR     LAB_198B(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-56(A5)
    BRA.W   .LAB_1A51

.LAB_1A5D:
    MOVE.B  #'0',-5(A5)
    MOVE.L  -14(A5),D0
    TST.L   D0
    BPL.S   .LAB_1A5E

    MOVEQ   #8,D0
    MOVE.L  D0,-14(A5)

.LAB_1A5E:
    TST.B   -15(A5)
    BEQ.S   .LAB_1A5F

    MOVEA.L (A2),A0
    ADDQ.L  #4,(A2)
    MOVE.L  (A0),D0
    BRA.S   .LAB_1A60

.LAB_1A5F:
    MOVEA.L (A2),A0
    ADDQ.L  #4,(A2)
    MOVE.L  (A0),D0

.LAB_1A60:
    MOVE.L  D0,-20(A5)
    TST.B   -4(A5)
    BEQ.S   .LAB_1A61

    MOVEA.L -52(A5),A0
    MOVE.B  #'0',(A0)+
    MOVE.B  #'x',(A0)+
    MOVEQ   #2,D1
    MOVE.L  D1,-28(A5)
    MOVE.L  A0,-52(A5)

.LAB_1A61:
    MOVE.L  D0,-(A7)
    MOVE.L  -52(A5),-(A7)
    JSR     LAB_198F(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-56(A5)
    MOVEQ   #'X',D0
    CMP.B   -16(A5),D0
    BNE.W   .LAB_1A51

    PEA     -48(A5)
    JSR     LAB_1949(PC)

    ADDQ.W  #4,A7
    BRA.W   .LAB_1A51

.LAB_1A62:
    MOVEA.L (A2),A0
    ADDQ.L  #4,(A2)
    MOVEA.L (A0),A1
    MOVE.L  A1,-52(A5)
    BNE.S   .LAB_1A63

    LEA     LAB_1A70(PC),A0
    MOVE.L  A0,-52(A5)

.LAB_1A63:
    MOVEA.L -52(A5),A0

.LAB_1A64:
    TST.B   (A0)+
    BNE.S   .LAB_1A64

    SUBQ.L  #1,A0
    SUBA.L  -52(A5),A0
    MOVE.L  A0,-28(A5)
    MOVE.L  -14(A5),D0
    TST.L   D0
    BMI.S   .LAB_1A67

    CMPA.L  D0,A0
    BLE.S   .LAB_1A67

    MOVE.L  D0,-28(A5)
    BRA.S   .LAB_1A67

.LAB_1A65:
    MOVEQ   #1,D0
    MOVE.L  D0,-28(A5)
    MOVEA.L (A2),A0
    ADDQ.L  #4,(A2)
    MOVE.L  (A0),D0
    MOVE.B  D0,-48(A5)
    CLR.B   -47(A5)
    BRA.S   .LAB_1A67

.LAB_1A66:
    MOVEQ   #0,D0
    BRA.W   .return

.LAB_1A67:
    MOVE.L  -28(A5),D0
    MOVE.L  -10(A5),D1
    CMP.L   D0,D1
    BGE.S   .LAB_1A68

    MOVEQ   #0,D2
    MOVE.L  D2,-10(A5)
    BRA.S   .LAB_1A69

.LAB_1A68:
    SUB.L   D0,-10(A5)

.LAB_1A69:
    TST.B   D7
    BEQ.S   .LAB_1A6C

.LAB_1A6A:
    SUBQ.L  #1,-28(A5)
    BLT.S   .LAB_1A6B

    MOVEQ   #0,D0
    MOVEA.L -52(A5),A0
    MOVE.B  (A0)+,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-52(A5)
    MOVEA.L 16(A5),A0
    JSR     (A0)

    ADDQ.W  #4,A7
    BRA.S   .LAB_1A6A

.LAB_1A6B:
    SUBQ.L  #1,-10(A5)
    BLT.S   .LAB_1A6E

    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVE.L  D0,-(A7)
    MOVEA.L 16(A5),A0
    JSR     (A0)

    ADDQ.W  #4,A7
    BRA.S   .LAB_1A6B

.LAB_1A6C:
    SUBQ.L  #1,-10(A5)
    BLT.S   .LAB_1A6D

    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVE.L  D0,-(A7)
    MOVEA.L 16(A5),A0
    JSR     (A0)

    ADDQ.W  #4,A7
    BRA.S   .LAB_1A6C

.LAB_1A6D:
    SUBQ.L  #1,-28(A5)
    BLT.S   .LAB_1A6E

    MOVEQ   #0,D0
    MOVEA.L -52(A5),A0
    MOVE.B  (A0)+,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-52(A5)
    MOVEA.L 16(A5),A0
    JSR     (A0)

    ADDQ.W  #4,A7
    BRA.S   .LAB_1A6D

.LAB_1A6E:
    MOVE.L  A3,D0

.return:
    MOVEM.L (A7)+,D2/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment?
LAB_1A70:
    DC.W    $0000

;!======

;------------------------------------------------------------------------------
; FUNC: WDISP_FormatWithCallback   (FormatWithCallback??)
; ARGS:
;   stack +4: outputFunc (called with D0=byte)
;   stack +8: formatStr
;   stack +12: varArgsPtr (pointer to arguments)
; RET:
;   D0: ?? (format parser return)
; CLOBBERS:
;   D0, D7, A2-A3
; CALLS:
;   LAB_1A3B, outputFunc
; READS:
;   [formatStr], [varArgsPtr]
; WRITES:
;   (none)
; DESC:
;   Core printf-style formatter that emits bytes via a callback.
; NOTES:
;   Handles %% and delegates spec parsing to LAB_1A3B.
;------------------------------------------------------------------------------
WDISP_FormatWithCallback:
LAB_1A71:
    LINK.W  A5,#-12
    MOVEM.L D7/A2-A3,-(A7)

    MOVEA.L 32(A7),A3
    MOVEA.L 36(A7),A2
    MOVE.L  16(A5),-10(A5)

.LAB_1A72:
    MOVE.B  (A2)+,D7
    TST.B   D7
    BEQ.S   .return

    MOVEQ   #'%',D0
    CMP.B   D0,D7
    BNE.S   .LAB_1A74

    CMP.B   (A2),D0
    BNE.S   .LAB_1A73

    ADDQ.L  #1,A2
    BRA.S   .LAB_1A74

.LAB_1A73:
    MOVE.L  A3,-(A7)
    PEA     -10(A5)
    MOVE.L  A2,-(A7)
    BSR.W   LAB_1A3B

    LEA     12(A7),A7
    MOVE.L  D0,-6(A5)
    BEQ.S   .LAB_1A74

    MOVEA.L D0,A2
    BRA.S   .LAB_1A72

.LAB_1A74:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    JSR     (A3)

    ADDQ.W  #4,A7
    BRA.S   .LAB_1A72

.return:
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_1A76:
    LINK.W  A5,#-16
    MOVEM.L D2/D7/A2-A3/A6,-(A7)

    SetOffsetForStack   5
    UseStackLong    MOVEA.L,6,A3

LAB_1A77:
    CMPI.L  #' ',22914(A4)
    BGE.W   LAB_1A82

LAB_1A78:
    MOVE.B  (A3),D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BEQ.S   LAB_1A79

    MOVEQ   #9,D1
    CMP.B   D1,D0
    BEQ.S   LAB_1A79

    MOVEQ   #10,D1
    CMP.B   D1,D0
    BNE.S   LAB_1A7A

LAB_1A79:
    ADDQ.L  #1,A3
    BRA.S   LAB_1A78

LAB_1A7A:
    TST.B   (A3)
    BEQ.S   LAB_1A82

    MOVE.L  22914(A4),D0
    ASL.L   #2,D0
    ADDQ.L  #1,22914(A4)
    LEA     22922(A4),A0
    ADDA.L  D0,A0
    MOVEA.L A0,A2
    MOVEQ   #34,D0
    CMP.B   (A3),D0
    BNE.S   LAB_1A7E

    ADDQ.L  #1,A3
    MOVE.L  A3,(A2)

LAB_1A7B:
    TST.B   (A3)
    BEQ.S   LAB_1A7C

    MOVEQ   #34,D0
    CMP.B   (A3),D0
    BEQ.S   LAB_1A7C

    ADDQ.L  #1,A3
    BRA.S   LAB_1A7B

LAB_1A7C:
    TST.B   (A3)
    BNE.S   LAB_1A7D

    PEA     1.W
    JSR     LAB_1A92(PC)

    ADDQ.W  #4,A7
    BRA.S   LAB_1A77

LAB_1A7D:
    CLR.B   (A3)+
    BRA.S   LAB_1A77

LAB_1A7E:
    MOVE.L  A3,(A2)

LAB_1A7F:
    TST.B   (A3)
    BEQ.S   LAB_1A80

    MOVE.B  (A3),D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BEQ.S   LAB_1A80

    MOVEQ   #9,D1
    CMP.B   D1,D0
    BEQ.S   LAB_1A80

    MOVEQ   #10,D1
    CMP.B   D1,D0
    BEQ.S   LAB_1A80

    ADDQ.L  #1,A3
    BRA.S   LAB_1A7F

LAB_1A80:
    TST.B   (A3)
    BNE.S   LAB_1A81

    BRA.S   LAB_1A82

LAB_1A81:
    CLR.B   (A3)+
    BRA.W   LAB_1A77

LAB_1A82:
    TST.L   22914(A4)
    BNE.S   LAB_1A83

    MOVEA.L -604(A4),A0
    BRA.S   LAB_1A84

LAB_1A83:
    LEA     22922(A4),A0

LAB_1A84:
    MOVE.L  A0,22918(A4)
    TST.L   22914(A4)
    BNE.S   LAB_1A85

    LEA     GLOB_STR_CON_10_10_320_80(PC),A1
    LEA     22856(A4),A6
    MOVE.L  (A1)+,(A6)+
    MOVE.L  (A1)+,(A6)+
    MOVE.L  (A1)+,(A6)+
    MOVE.L  (A1)+,(A6)+
    MOVE.W  (A1),(A6)
    MOVEA.L -604(A4),A1
    MOVEA.L 36(A1),A0
    PEA     40.W
    MOVE.L  4(A0),-(A7)
    PEA     22856(A4)
    JSR     LAB_1962(PC)

    LEA     12(A7),A7
    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    LEA     22856(A4),A0
    MOVE.L  A0,D1
    MOVE.L  #MODE_NEWFILE,D2
    JSR     _LVOOpen(A6)

    MOVE.L  D0,22496(A4)
    MOVE.L  D0,22504(A4)
    MOVEQ   #16,D1
    MOVE.L  D1,22500(A4)
    MOVE.L  D0,22512(A4)
    MOVE.L  D1,22508(A4)
    ASL.L   #2,D0
    MOVE.L  D0,-16(A5)
    MOVEA.L AbsExecBase,A6
    SUBA.L  A1,A1
    JSR     _LVOFindTask(A6)

    MOVEA.L -16(A5),A0
    MOVEA.L D0,A1
    MOVE.L  8(A0),164(A1)
    MOVEQ   #0,D7
    MOVE.L  D0,-12(A5)
    BRA.S   LAB_1A86

LAB_1A85:
    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    JSR     _LVOInput(A6)

    MOVE.L  D0,22496(A4)    ; Original input file handle
    JSR     _LVOOutput(A6)

    MOVE.L  D0,22504(A4)    ; Original output file handle
    LEA     GLOB_STR_ASTERISK_1(PC),A0
    MOVE.L  A0,D1
    MOVE.L  #MODE_OLDFILE,D2
    JSR     _LVOOpen(A6)

    MOVE.L  D0,22512(A4)
    MOVEQ   #16,D7

LAB_1A86:
    MOVE.L  D7,D0
    ORI.W   #$8001,D0
    OR.L    D0,22492(A4)
    MOVE.L  D7,D0
    ORI.W   #$8002,D0
    OR.L    D0,22500(A4)
    ORI.L   #$8003,22508(A4) ; memory thing?
    TST.L   -1016(A4)
    BEQ.S   LAB_1A87

    MOVEQ   #0,D0
    BRA.S   LAB_1A88

LAB_1A87:
    MOVE.L  #$8000,D0

LAB_1A88:
    MOVE.L  D0,D7
    CLR.L   -1092(A4)
    MOVE.L  D7,D0
    ORI.W   #1,D0
    MOVE.L  D0,-1096(A4)
    MOVEQ   #1,D0
    MOVE.L  D0,-1058(A4)
    MOVE.L  D7,D0
    ORI.W   #2,D0
    MOVE.L  D0,-1062(A4)
    MOVEQ   #2,D0
    MOVE.L  D0,-1024(A4)
    MOVE.L  D7,D0
    ORI.W   #$80,D0
    MOVE.L  D0,-1028(A4)
    LEA     LAB_1ABE(PC),A0
    MOVE.L  A0,-616(A4)
    MOVE.L  22918(A4),-(A7)
    MOVE.L  22914(A4),-(A7)
    JSR     WDISP_JMP_TBL_ESQ_MainInitAndRun(PC)

    CLR.L   (A7)
    JSR     LIBRARIES_LOAD_FAILED(PC)

    MOVEM.L -36(A5),D2/D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

GLOB_STR_CON_10_10_320_80:
    NStr    "con.10/10/320/80/"

GLOB_STR_ASTERISK_1:
    NStr    "*"

;!======

WDISP_JMP_TBL_ESQ_MainInitAndRun:
LAB_1A8B:
    JMP     ESQ_MainInitAndRun

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    MOVEQ   #97,D0

;!======

LAB_1A8C:
    MOVEM.L D2-D3/A2-A3/A6,-(A7)

    SetOffsetForStack 5
    UseStackLong    MOVEA.L,9,A6

; LAB_1A8D:
    MOVEA.L 24(A7),A0
    MOVEA.L 28(A7),A1
    MOVEA.L 32(A7),A2
    MOVEA.L 36(A7),A3
    MOVE.L  40(A7),D0
    MOVE.L  44(A7),D1
    MOVE.L  48(A7),D2
    MOVE.L  52(A7),D3
    JSR     -348(A6)                    ; Traced A6 to AbsExecBase here...? FreeTrap

    MOVEM.L (A7)+,D2-D3/A2-A3/A6
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_1A8E:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    TST.L   20(A3)
    BEQ.S   .LAB_1A8F

    BTST    #3,27(A3)
    BNE.S   .LAB_1A8F

    MOVEQ   #0,D0
    BRA.S   .LAB_1A91

.LAB_1A8F:
    MOVE.L  -748(A4),-(A7)
    JSR     LAB_19B7(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,4(A3)
    MOVE.L  D0,16(A3)
    TST.L   D0
    BNE.S   .LAB_1A90

    MOVEQ   #12,D0
    MOVE.L  D0,22828(A4)
    MOVEQ   #-1,D0
    BRA.S   .LAB_1A91

.LAB_1A90:
    MOVE.L  -748(A4),20(A3)
    MOVEQ   #-13,D0
    AND.L   D0,24(A3)
    MOVEQ   #0,D0
    MOVE.L  D0,12(A3)
    MOVE.L  D0,8(A3)

.LAB_1A91:
    MOVEA.L (A7)+,A3
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    MOVEQ   #97,D0

;!======

LAB_1A92:
    MOVEM.L D5-D7,-(A7)

    SetOffsetForStack 3
    UseStackLong    MOVE.L,1,D7

    MOVE.L  -1148(A4),D0
    SUBQ.L  #1,D0
    MOVE.L  D0,D6

LAB_1A93:
    TST.W   D6
    BMI.S   LAB_1A95

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #3,D0
    LEA     22492(A4),A0
    MOVE.L  0(A0,D0.L),D5
    TST.B   D5
    BEQ.S   LAB_1A94

    BTST    #4,D5
    BNE.S   LAB_1A94

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #3,D0
    LEA     22492(A4),A0
    MOVE.L  4(A0,D0.L),-(A7)
    JSR     LAB_1A04(PC)

    ADDQ.W  #4,A7

LAB_1A94:
    SUBQ.W  #1,D6
    BRA.S   LAB_1A93

LAB_1A95:
    MOVE.L  D7,-(A7)
    JSR     LAB_1A96(PC)

    ADDQ.W  #4,A7
    MOVEM.L (A7)+,D5-D7
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

WDISP_JMP_TBL_ESQ_ReturnWithStackCode:
LAB_1A96:
    JMP     ESQ_ReturnWithStackCode

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

LAB_1A97:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVEM.L A2-A3,-(A7)
    BRA.S   LAB_1A99

LAB_1A98:
    CMPI.B  #0,(A2)
    BEQ.S   LAB_1A9B

    ADDQ.L  #1,A0
    CMPI.B  #0,(A0)
    BEQ.S   LAB_1A9B

LAB_1A99:
    MOVEA.L A0,A2
    MOVEA.L A1,A3

LAB_1A9A:
    CMPI.B  #0,(A3)
    BEQ.S   LAB_1A9C

    CMPM.B  (A2)+,(A3)+
    BNE.S   LAB_1A98

    BRA.S   LAB_1A9A

LAB_1A9B:
    MOVEQ   #0,D0
    MOVEM.L (A7)+,A2-A3
    RTS

;!======

LAB_1A9C:
    MOVE.L  A0,D0
    MOVEM.L (A7)+,A2-A3
    RTS

;!======

LAB_1A9D:
    LINK.W  A5,#-24
    MOVEM.L D7/A2-A3/A6,-(A7)
    MOVE.L  52(A7),D7
    TST.L   D7
    BGT.S   LAB_1A9E

    MOVEQ   #-1,D0
    BRA.W   LAB_1AA8

LAB_1A9E:
    MOVEQ   #8,D0
    CMP.L   D0,D7
    BCC.S   LAB_1A9F

    MOVE.L  D0,D7

LAB_1A9F:
    MOVE.L  D7,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,D7
    ANDI.W  #$fffc,D7
    MOVEA.L 8(A5),A2
    MOVE.L  8(A5),D0
    ADD.L   D7,D0
    ADD.L   D7,-1128(A4)
    LEA     -1132(A4),A0
    MOVEA.L (A0),A3
    MOVE.L  D0,-16(A5)
    MOVE.L  A0,-12(A5)

LAB_1AA0:
    MOVE.L  A3,D0
    BEQ.W   LAB_1AA7

    MOVEA.L A3,A0
    MOVE.L  4(A3),D0
    ADDA.L  D0,A0
    MOVE.L  A0,-20(A5)
    MOVEA.L -16(A5),A1
    CMPA.L  A1,A3
    BLS.S   LAB_1AA1

    MOVE.L  A3,(A2)
    MOVE.L  D7,4(A2)
    MOVEA.L -12(A5),A6
    MOVE.L  A2,(A6)
    MOVEQ   #0,D0
    BRA.S   LAB_1AA8

LAB_1AA1:
    CMPA.L  A1,A3
    BNE.S   LAB_1AA2

    MOVEA.L (A3),A6
    MOVE.L  A6,(A2)
    MOVE.L  4(A3),D0
    MOVE.L  D0,D1
    ADD.L   D7,D1
    MOVE.L  D1,4(A2)
    MOVEA.L -12(A5),A6
    MOVE.L  A2,(A6)
    MOVEQ   #0,D0
    BRA.S   LAB_1AA8

LAB_1AA2:
    CMPA.L  A0,A2
    BCC.S   LAB_1AA3

    SUB.L   D7,-1128(A4)
    MOVEQ   #-1,D0
    BRA.S   LAB_1AA8

LAB_1AA3:
    CMPA.L  A0,A2
    BNE.S   LAB_1AA6

    TST.L   (A3)
    BEQ.S   LAB_1AA4

    MOVEA.L (A3),A0
    CMPA.L  A0,A1
    BLS.S   LAB_1AA4

    SUB.L   D7,-1128(A4)
    MOVEQ   #-1,D0
    BRA.S   LAB_1AA8

LAB_1AA4:
    ADD.L   D7,4(A3)
    TST.L   (A3)
    BEQ.S   LAB_1AA5

    CMPA.L  (A3),A1
    BNE.S   LAB_1AA5

    MOVE.L  4(A1),D0
    ADD.L   D0,4(A3)
    MOVE.L  (A1),(A3)

LAB_1AA5:
    MOVEQ   #0,D0
    BRA.S   LAB_1AA8

LAB_1AA6:
    MOVE.L  A3,-12(A5)
    MOVE.L  -20(A5),-24(A5)
    MOVEA.L (A3),A3
    BRA.W   LAB_1AA0

LAB_1AA7:
    MOVEA.L -12(A5),A0
    MOVE.L  A2,(A0)
    CLR.L   (A2)
    MOVE.L  D7,4(A2)
    MOVEQ   #0,D0

LAB_1AA8:
    MOVEM.L (A7)+,D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    MOVEQ   #97,D0

;!======

LAB_1AA9:
    MOVEM.L D5-D7/A2-A3,-(A7)

    MOVE.L  24(A7),D7
    MOVEA.L 28(A7),A3
    MOVE.L  32(A7),D6

    MOVE.L  D7,-(A7)
    JSR     LAB_1A1D(PC)

    ADDQ.W  #4,A7
    MOVEA.L D0,A2
    MOVE.L  A2,D0
    BNE.S   .LAB_1AAA

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_1AAA:
    MOVE.L  D6,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  4(A2),-(A7)
    JSR     LAB_19F0(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5
    TST.L   -640(A4)
    BEQ.S   .LAB_1AAB

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_1AAB:
    MOVE.L  D5,D0

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3
    RTS

;!======

    DC.W    $0000

;!======

LAB_1AAD:
    MOVEA.L 4(A7),A0
    MOVE.L  A0,(A0)
    ADDQ.L  #4,(A0)
    CLR.L   4(A0)
    MOVE.L  A0,8(A0)
    RTS

;!======

    DC.W    $0000

;!======

LAB_1AAE:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVE.L  12(A7),D0
    BLE.S   LAB_1AB1

    CMPA.L  A0,A1
    BCS.S   LAB_1AB0

    ADDA.L  D0,A0
    ADDA.L  D0,A1

.LAB_1AAF:
    MOVE.B  -(A0),-(A1)
    SUBQ.L  #1,D0
    BNE.S   .LAB_1AAF

    RTS

;!======

LAB_1AB0:
    MOVE.B  (A0)+,(A1)+
    SUBQ.L  #1,D0
    BNE.S   LAB_1AB0

LAB_1AB1:
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_1AB2:
    LINK.W  A5,#-8
    MOVEM.L A2-A3,-(A7)
    LEA     -1120(A4),A3

LAB_1AB3:
    MOVE.L  A3,D0
    BEQ.S   LAB_1AB4

    TST.L   24(A3)
    BEQ.S   LAB_1AB4

    MOVEA.L A3,A2
    MOVEA.L (A3),A3
    BRA.S   LAB_1AB3

LAB_1AB4:
    MOVE.L  A3,D0
    BNE.S   LAB_1AB7

    PEA     34.W
    JSR     LAB_19B7(PC)

    ADDQ.W  #4,A7
    MOVEA.L D0,A3
    TST.L   D0
    BNE.S   LAB_1AB5

    MOVEQ   #0,D0
    BRA.S   LAB_1AB8

LAB_1AB5:
    MOVE.L  A3,(A2)
    MOVEQ   #33,D0
    MOVEQ   #0,D1
    MOVEA.L A3,A0

LAB_1AB6:
    MOVE.B  D1,(A0)+
    DBF     D0,LAB_1AB6

LAB_1AB7:
    MOVE.L  A3,-(A7)
    MOVE.L  12(A5),-(A7)
    MOVE.L  8(A5),-(A7)
    JSR     LAB_19C4(PC)

LAB_1AB8:
    MOVEM.L -16(A5),A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_1AB9:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    BTST    #1,27(A3)
    BEQ.S   LAB_1ABA

    MOVE.L  A3,-(A7)
    PEA     -1.W
    JSR     LAB_1916(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    BRA.S   LAB_1ABB

LAB_1ABA:
    MOVEQ   #0,D7

LAB_1ABB:
    MOVEQ   #12,D0
    AND.L   24(A3),D0
    BNE.S   LAB_1ABC

    TST.L   20(A3)
    BEQ.S   LAB_1ABC

    MOVE.L  20(A3),-(A7)
    MOVE.L  16(A3),-(A7)
    JSR     LAB_1A9D(PC)

    ADDQ.W  #8,A7

LAB_1ABC:
    CLR.L   24(A3)
    MOVE.L  28(A3),-(A7)
    JSR     LAB_1ACC(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D6
    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BEQ.S   LAB_1ABD

    TST.L   D6
    BNE.S   LAB_1ABD

    MOVEQ   #0,D0

LAB_1ABD:
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

LAB_1ABE:
    LINK.W  A5,#-104
    MOVEM.L D2-D3/D6-D7/A6,-(A7)

    MOVEQ   #0,D7
    MOVEA.L -592(A4),A0
    MOVE.B  -1(A0),D7
    MOVEQ   #79,D0
    CMP.L   D0,D7
    BLE.S   LAB_1ABF

    MOVE.L  D0,D7

LAB_1ABF:
    MOVE.L  D7,D0
    LEA     -81(A5),A1
    BRA.S   LAB_1AC1

LAB_1AC0:
    MOVE.B  (A0)+,(A1)+

LAB_1AC1:
    SUBQ.L  #1,D0
    BCC.S   LAB_1AC0

    CLR.B   -81(A5,D7.L)
    MOVEA.L AbsExecBase,A6
    SUBA.L  A1,A1
    JSR     _LVOFindTask(A6)

    MOVE.L  D0,-90(A5)
    MOVEA.L D0,A0
    TST.L   172(A0)
    BEQ.S   LAB_1AC3

    MOVE.L  172(A0),D1
    ASL.L   #2,D1
    MOVEA.L D1,A1
    MOVE.L  56(A1),D6
    MOVEM.L D1,-98(A5)
    TST.L   D6
    BNE.S   LAB_1AC2

    MOVE.L  160(A0),D6

LAB_1AC2:
    TST.L   D6
    BEQ.S   LAB_1AC3

    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    MOVE.L  D6,D1
    LEA     LAB_1ACA(PC),A0
    MOVE.L  A0,D2
    MOVEQ   #11,D3
    JSR     _LVOWrite(A6)

    MOVEA.L D7,A0
    ADDQ.L  #1,D7
    MOVE.L  A0,D0
    MOVE.B  #$a,-81(A5,D0.L)
    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    MOVE.L  D6,D1
    MOVE.L  D7,D3
    LEA     -81(A5),A0
    MOVE.L  A0,D2
    JSR     _LVOWrite(A6)

    MOVEQ   #-1,D0
    BRA.S   LAB_1AC6

LAB_1AC3:
    MOVEA.L AbsExecBase,A6
    LEA     LOCAL_STR_INTUITION_LIBRARY(PC),A1
    MOVEQ   #0,D0
    JSR     _LVOOpenLibrary(A6)

    MOVE.L  D0,-102(A5)
    BNE.S   LAB_1AC4

    MOVEQ   #-1,D0
    BRA.S   LAB_1AC6

LAB_1AC4:
    LEA     -81(A5),A0
    MOVE.L  A0,-712(A4)
    MOVE.L  -102(A5),-(A7)
    PEA     60.W
    PEA     250.W
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -684(A4)
    PEA     -704(A4)
    PEA     -724(A4)
    CLR.L   -(A7)
    JSR     LAB_1A8C(PC)

    LEA     36(A7),A7
    SUBQ.L  #1,D0
    BEQ.S   LAB_1AC5

    MOVEQ   #-1,D0
    BRA.S   LAB_1AC6

LAB_1AC5:
    MOVEQ   #0,D0

LAB_1AC6:
    MOVEM.L (A7)+,D2-D3/D6-D7/A6
    UNLK    A5
    RTS

;!======

LAB_1AC7:
    DC.B    "** User Abort Requested **",0,0

LAB_1AC8:
    DC.B    "CONTINUE",0,0

LAB_1AC9:
    DC.B    "ABORT",0

LAB_1ACA:
    DC.B    "*** Break: ",0

LOCAL_STR_INTUITION_LIBRARY:
    DC.B    "intuition.library",0

;!======

    ; Alignment
    DS.W    3
    DC.W    $7061

;!=====

LAB_1ACC:
    MOVEM.L D7/A3,-(A7)

    MOVE.L  12(A7),D7
    MOVE.L  D7,-(A7)
    JSR     LAB_1A1D(PC)

    ADDQ.W  #4,A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BNE.S   .LAB_1ACD

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_1ACD:
    BTST    #4,3(A3)
    BEQ.S   .LAB_1ACF

    MOVEQ   #0,D0
    MOVE.L  D0,(A3)
    BRA.S   .return

.LAB_1ACF:
    MOVE.L  4(A3),-(A7)
    JSR     LAB_1A04(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D0
    MOVE.L  D0,(A3)
    TST.L   -640(A4)
    BEQ.S   .LAB_1AD1

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_1AD1:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

    ; Alignment?
    ORI.B   #0,D0
    DC.W    $0000
    MOVEQ   #97,D0

;!======

LAB_1AD3:
    MOVE.L  D7,-(A7)

    MOVEQ   #0,D0
    MOVE.L  #$3000,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOSetSignal(A6)

    MOVE.L  D0,D7
    ANDI.L  #$3000,D7
    TST.L   D7
    BEQ.S   .LAB_1AD9

    TST.L   -616(A4)
    BEQ.S   .LAB_1AD9

    MOVEA.L -616(A4),A0
    JSR     (A0)

    TST.L   D0
    BNE.S   .LAB_1AD8

    BRA.S   .LAB_1AD9

.LAB_1AD8:
    CLR.L   -616(A4)
    PEA     20.W
    JSR     LAB_1A92(PC)

    ADDQ.W  #4,A7

.LAB_1AD9:
    MOVE.L  (A7)+,D7
    RTS

;!======

    ; Alignment?
    BSR.S   LAB_1AD3

    RTS
    DC.W    $0000

;!======

LAB_1ADA:
    MOVEM.L D2-D6/A6,-(A7)

    MOVEA.L -22440(A4),A6
    MOVEA.L 28(A7),A0
    MOVEM.L 32(A7),D0-D1
    MOVEA.L 40(A7),A1
    MOVEM.L 44(A7),D2-D6
    JSR     -606(A6)            ; I think this may be BltBitMapRastPort in Graphics.library

    MOVEM.L (A7)+,D2-D6/A6
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    MOVEQ   #97,D0

;!======

GET_CLOCK_CHIP_TIME:
    MOVE.L  A6,-(A7)

    MOVEA.L GLOB_REF_BATTCLOCK_RESOURCE,A6
    JSR     _LVOReadBattClock(A6)

    MOVEA.L (A7)+,A6
    RTS

;!======

SET_CLOCK_CHIP_TIME:
    MOVE.L  A6,-(A7)

    MOVEA.L GLOB_REF_BATTCLOCK_RESOURCE,A6
    MOVE.L  8(A7),D0
    JSR     _LVOWriteBattClock(A6)

    MOVEA.L (A7)+,A6
    RTS

;!======

LAB_1ADD:
    MOVEM.L A2/A6,-(A7)

    MOVEA.L LAB_231E,A6
    MOVEM.L 12(A7),A0-A1
    MOVEM.L 20(A7),D1/A2
    JSR     -48(A6)         ; Traced A6 to be AbsExecBase here? _LVOexecPrivate3

    MOVEM.L (A7)+,A2/A6
    RTS

;!======

DO_DELAY:
    MOVE.L  A6,-(A7)

    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    MOVE.L  8(A7),D1
    JSR     _LVODelay(A6)

    MOVEA.L (A7)+,A6
    RTS

;!======

LAB_1ADF:
    MOVEM.L D2/A6,-(A7)

    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    MOVEM.L 12(A7),D1-D2
    JSR     _LVOSystemTagList(A6)

    MOVEM.L (A7)+,D2/A6
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

; Fill in a ClockData struct with the date and time calculated from
; a provided ULONG of the number of seconds from Amiga epoch
POPULATE_CLOCKDATA_FROM_SECS:
    MOVE.L  A6,-(A7)

    MOVEA.L GLOB_REF_UTILITY_LIBRARY,A6
    MOVEM.L 8(A7),D0/A0
    JSR     _LVOAmiga2Date(A6)

    MOVEA.L (A7)+,A6
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

; Given a valid ClockData struct pushed to the stack, return the number of
; seconds from Amiga epoch, or 0 if illegal and store in D0.
GET_LEGAL_OR_SECONDS_FROM_EPOCH:
    MOVE.L  A6,-(A7)

    SetOffsetForStack 1

    MOVEA.L GLOB_REF_UTILITY_LIBRARY,A6
    MOVEA.L .stackOffsetBytes+4(A7),A0
    JSR     _LVOCheckDate(A6)

    MOVEA.L (A7)+,A6
    RTS

;!======

; Given a valid ClockData struct in 8(A7) return the number of
; seconds from Amiga epoch.
GET_SECONDS_FROM_EPOCH:
    MOVE.L  A6,-(A7)

    MOVEA.L GLOB_REF_UTILITY_LIBRARY,A6
    MOVEA.L 8(A7),A0
    JSR     _LVODate2Amiga(A6)

    MOVEA.L (A7)+,A6        ;33a6c: 2c5f
    RTS

;!======

    MOVE.L  4(A7),D0

;!======

LAB_1AE3:
    JSR     LAB_1AEB

    RTS

;!======

    MOVEA.L 4(A7),A0

;!======

LAB_1AE4:
    MOVE.B  (A0)+,D0
    BEQ.S   .return

    BSR.S   LAB_1AE3

    BRA.S   LAB_1AE4

.return:
    RTS

;!======

LAB_1AE6:
    BSR.S   LAB_1AE7

    TST.L   D0
    BMI.S   LAB_1AE6

    RTS

;!======

LAB_1AE7:
    JSR     LAB_1AEF

    RTS

;!======
; Below seems to be dead code...
;!======

    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    BRA.S   LAB_1AE9

LAB_1AE8:
    MOVEA.L 4(A7),A0
    LEA     8(A7),A1

LAB_1AE9:
    MOVEM.L A2,-(A7)
    LEA     LAB_1AE3(PC),A2
    BSR.S   JMP_TBL_RAW_DO_FMT_AGAINST_LAB_1AEB

    MOVEM.L (A7)+,A2
    RTS

;!======

JMP_TBL_RAW_DO_FMT_AGAINST_LAB_1AEB:
    JSR     RAW_DO_FMT_AGAINST_LAB_1AEB

    RTS

;!======

    MOVEM.L A2-A3,-(A7)
    MOVEM.L 12(A7),A0-A3
    BSR.S   JMP_TBL_RAW_DO_FMT_AGAINST_LAB_1AEB

    MOVEM.L (A7)+,A2-A3
    RTS

;!======

    ; ???
    DC.W    $0000
    MOVE.L  4(A7),D0

LAB_1AEB:
    MOVE.B  D0,-(A7)
    CMPI.B  #$a,D0
    BNE.S   LAB_1AEC

    MOVEQ   #13,D0
    BSR.S   LAB_1AED

LAB_1AEC:
    MOVE.B  (A7)+,D0

LAB_1AED:
    MOVE.B  CIAB_PRA,D1
    BTST    #0,D1
    BNE.S   LAB_1AED

    MOVE.B  #$ff,CIAA_DDRB
    MOVE.B  D0,CIAA_PRB
    RTS

;!======

RAW_DO_FMT_AGAINST_LAB_1AEB:
    MOVEM.L A2/A6,-(A7)

    LEA     LAB_1AEB(PC),A2
    MOVEA.L AbsExecBase,A6
    JSR     _LVORawDoFmt(A6)

    MOVEM.L (A7)+,A2/A6
    RTS

;!======

LAB_1AEF:
    MOVEQ   #-1,D0
    RTS

;!======

    ; Alignment
    ALIGN_WORD
