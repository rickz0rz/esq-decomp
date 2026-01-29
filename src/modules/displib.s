LAB_0552:
    LINK.W  A5,#-28
    MOVEM.L D4-D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.B  15(A5),D7
    MOVEA.L A3,A0

LAB_0553:
    TST.B   (A0)+
    BNE.S   LAB_0553

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D5
    MOVEA.L A3,A0
    MOVE.L  D5,D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  #624,D1
    SUB.L   D0,D1
    MOVE.L  D1,D6
    TST.L   D6
    BLE.W   LAB_055B

    MOVEQ   #24,D0
    CMP.B   D0,D7
    BNE.S   LAB_0555

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     LAB_1CE4,A0
    MOVEQ   #1,D0
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,20(A7)
    MOVE.L  D6,D0
    MOVE.L  20(A7),D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    TST.L   D0
    BPL.S   LAB_0554

    ADDQ.L  #1,D0

LAB_0554:
    ASR.L   #1,D0
    MOVE.L  D0,D4
    BRA.S   LAB_0557

LAB_0555:
    MOVEQ   #26,D0
    CMP.B   D0,D7
    BNE.S   LAB_0556

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     LAB_1CE5,A0
    MOVEQ   #1,D0
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,20(A7)
    MOVE.L  D6,D0
    MOVE.L  20(A7),D1
    JSR     JMP_TBL_LAB_1A07_1(PC)

    MOVE.L  D0,D4
    BRA.S   LAB_0557

LAB_0556:
    MOVEQ   #0,D4

LAB_0557:
    TST.L   D4
    BEQ.S   LAB_055B

    MOVE.L  D5,D0
    ADDQ.L  #1,D0
    PEA     (MEMF_PUBLIC).W
    MOVE.L  D0,-(A7)
    PEA     194.W
    PEA     GLOB_STR_DISPLIB_C_1
    JSR     JMP_TBL_ALLOCATE_MEMORY_1(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   LAB_055B

    MOVEA.L A3,A0
    MOVEA.L D0,A1

LAB_0558:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_0558

    MOVE.L  A3,-8(A5)
    CLR.L   -24(A5)

LAB_0559:
    MOVE.L  -24(A5),D0
    CMP.L   D4,D0
    BGE.S   LAB_055A

    MOVEA.L -8(A5),A0
    MOVE.B  #$20,(A0)+
    MOVE.L  A0,-8(A5)
    ADDQ.L  #1,-24(A5)
    BRA.S   LAB_0559

LAB_055A:
    MOVEA.L -8(A5),A0
    CLR.B   (A0)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    MOVE.L  D5,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     204.W
    PEA     GLOB_STR_DISPLIB_C_2
    JSR     JMP_TBL_DEALLOCATE_MEMORY_1(PC)

    LEA     20(A7),A7

LAB_055B:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

DISPLAY_TEXT_AT_POSITION:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A2-A3,-(A7)

    ; Copy additional parameters from the stack
    MOVEA.L 28(A7),A3   ; RastPort
    MOVE.L  32(A7),D7   ; X
    MOVE.L  36(A7),D6   ; Y
    MOVEA.L 40(A7),A2   ; String

    ; Check to see if A2 (our target string) is an empty address.
    ; If it is, jump to the end.
    MOVE.L  A2,D0
    BEQ.S   .return

    MOVEA.L A3,A1   ; RastPort
    MOVE.L  D7,D0   ; X (short)
    MOVE.L  D6,D1   ; Y (short)
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L A2,A0

; Count the number of characters in the string by testing each
; character, and then subtracting the address of the null character
; from the starting address of the string (minus 1)
.currentCharacterIsNotNull:
    TST.B   (A0)+
    BNE.S   .currentCharacterIsNotNull

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,16(A7)

    MOVEA.L A3,A1       ; RastPort
    MOVEA.L A2,A0       ; String
    MOVE.L  16(A7),D0   ; Number of characters in the string
    JSR     _LVOText(A6)

.return:
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_055F:
    MOVEM.L D5-D7,-(A7)
    MOVE.W  18(A7),D7
    MOVE.W  22(A7),D6
    MOVE.W  26(A7),D5

.LAB_0560:
    CMP.W   D6,D7
    BGE.S   .LAB_0561

    ADD.W   D5,D7
    BRA.S   .LAB_0560

.LAB_0561:
    CMP.W   D5,D7
    BLE.S   .return

    SUB.W   D5,D7
    BRA.S   .LAB_0561

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D5-D7
    RTS

;!======

LAB_0563:
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_21D5
    MOVE.W  D0,LAB_21D6
    MOVEQ   #0,D1
    MOVE.L  D1,LAB_21D9
    MOVE.L  D1,LAB_21DA
    MOVE.L  D1,LAB_21DB
    MOVE.W  D0,LAB_21DC
    MOVE.L  D1,D7

LAB_0564:
    MOVEQ   #20,D0
    CMP.L   D0,D7
    BGE.S   LAB_0565

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_21D4,A0
    ADDA.L  D0,A0
    CLR.L   (A0)
    MOVE.L  D7,D1
    ADD.L   D1,D1
    LEA     LAB_21D7,A0
    ADDA.L  D1,A0
    CLR.W   (A0)
    LEA     LAB_21D8,A0
    ADDA.L  D0,A0
    MOVEQ   #1,D0
    MOVE.L  D0,(A0)
    ADDQ.L  #1,D7
    BRA.S   LAB_0564

LAB_0565:
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_0566:
    MOVE.L  LAB_21D3,-(A7)
    CLR.L   -(A7)
    JSR     LAB_0385(PC)

    MOVE.L  D0,LAB_21D3
    BSR.S   LAB_0563

    ADDQ.W  #8,A7
    RTS

;!======

LAB_0567:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ADD.L   D0,D0
    LEA     LAB_21D7,A0
    ADDA.L  D0,A0
    TST.W   (A0)
    BEQ.S   LAB_0568

    MOVE.W  LAB_21D6,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,LAB_21D6

LAB_0568:
    MOVE.W  LAB_21D6,D0
    MOVE.W  LAB_21D5,D1
    CMP.W   D1,D0
    BCC.S   LAB_0569

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ASL.L   #2,D1
    LEA     LAB_21D8,A0
    ADDA.L  D1,A0
    MOVE.L  D7,(A0)

LAB_0569:
    MOVE.L  (A7)+,D7
    RTS
