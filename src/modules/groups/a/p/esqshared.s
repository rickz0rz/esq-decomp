
LAB_0C07:
    LINK.W  A5,#-16
    MOVEM.L D2/D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.B  (A3)+,D6
    MOVE.B  (A3)+,D5
    MOVEQ   #0,D7

LAB_0C08:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-15(A5,D7.W)
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BEQ.S   LAB_0C09

    MOVEQ   #8,D0
    CMP.W   D0,D7
    BGE.S   LAB_0C09

    ADDQ.W  #1,D7
    BRA.S   LAB_0C08

LAB_0C09:
    CLR.B   -15(A5,D7.W)
    MOVE.B  (A3)+,D4
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    MOVEQ   #0,D2
    MOVE.B  D4,D2
    MOVE.L  A3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -15(A5)
    BSR.W   LAB_0C48

    MOVEM.L -40(A5),D2/D4-D7/A3
    UNLK    A5
    RTS

;!======

LAB_0C0A:
    LINK.W  A5,#-32
    MOVEM.L D4-D7/A3,-(A7)

    MOVEA.L 8(A5),A3

    CLR.B   -10(A5)
    MOVE.B  LAB_1DEB,D0
    MOVEQ   #0,D6
    MOVE.B  D0,-8(A5)
    MOVE.B  D0,-9(A5)

LAB_0C0B:
    MOVE.B  (A3)+,D4
    TST.B   D4
    BEQ.S   LAB_0C13

    MOVEQ   #0,D0
    MOVE.B  D4,D0
    SUBI.W  #$2e,D0
    BEQ.S   LAB_0C0F

    SUBI.W  #12,D0
    BNE.S   LAB_0C10

    MOVE.B  -8(A5),D0
    MOVEQ   #63,D1
    CMP.B   D1,D0
    BEQ.S   LAB_0C0C

    MOVEQ   #42,D1
    CMP.B   D1,D0
    BEQ.S   LAB_0C0C

    TST.W   D6
    BNE.S   LAB_0C0D

LAB_0C0C:
    MOVE.B  LAB_1DEB,-9(A5)
    BRA.S   LAB_0C0E

LAB_0C0D:
    MOVE.B  D0,-9(A5)

LAB_0C0E:
    MOVEQ   #0,D6
    BRA.S   LAB_0C0B

LAB_0C0F:
    CLR.B   -26(A5,D6.W)
    MOVE.B  #$1,-10(A5)
    MOVEQ   #0,D6
    BRA.S   LAB_0C0B

LAB_0C10:
    MOVE.B  D4,-8(A5)
    TST.B   -10(A5)
    BEQ.S   LAB_0C11

    MOVE.B  D4,-30(A5,D6.W)
    BRA.S   LAB_0C12

LAB_0C11:
    MOVE.B  D4,-26(A5,D6.W)

LAB_0C12:
    ADDQ.W  #1,D6
    BRA.S   LAB_0C0B

LAB_0C13:
    TST.B   -10(A5)
    BEQ.S   LAB_0C14

    MOVEQ   #0,D0
    MOVE.B  D0,-30(A5,D6.W)
    BRA.S   LAB_0C15

LAB_0C14:
    CLR.B   -26(A5,D6.W)

LAB_0C15:
    LEA     -26(A5),A0
    MOVEA.L A0,A1

LAB_0C16:
    TST.B   (A1)+
    BNE.S   LAB_0C16

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    BNE.S   LAB_0C17

    MOVEQ   #-1,D7
    BRA.S   LAB_0C18

LAB_0C17:
    MOVE.L  A0,-(A7)
    PEA     GLOB_PTR_STR_SELECT_CODE
    JSR     GROUPB_JMP_TBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    MOVE.B  D0,D7
    EXT.W   D7

LAB_0C18:
    MOVEQ   #0,D5
    MOVEQ   #1,D0
    CMP.B   -10(A5),D0
    BNE.S   LAB_0C19

    PEA     -30(A5)
    PEA     LAB_2298
    JSR     GROUPB_JMP_TBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    MOVE.B  D0,D5
    EXT.W   D5

LAB_0C19:
    TST.W   D7
    BNE.S   LAB_0C1A

    TST.W   D5
    BNE.S   LAB_0C1A

    MOVE.B  LAB_1DEB,D0
    MOVE.B  -9(A5),D1
    CMP.B   D0,D1
    BNE.S   LAB_0C1A

    MOVEQ   #1,D0
    BRA.S   LAB_0C1B

LAB_0C1A:
    MOVEQ   #0,D0

LAB_0C1B:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

LAB_0C1C:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.B  #$2,40(A3)
    MOVEQ   #-1,D0
    MOVE.B  D0,41(A3)
    MOVE.B  D0,42(A3)
    LEA     43(A3),A0
    LEA     GLOB_STR_00,A1

LAB_0C1D:
    MOVE.B  (A1)+,(A0)+
    BNE.S   LAB_0C1D

    MOVE.W  #3,46(A3)
    MOVEA.L (A7)+,A3
    RTS

;!======

LAB_0C1E:
    LINK.W  A5,#-24
    MOVEM.L D5-D7/A2-A3/A6,-(A7)
    MOVE.B  11(A5),D7
    MOVE.B  15(A5),D6
    MOVEA.L 16(A5),A3
    MOVEA.L 20(A5),A2
    MOVE.B  LAB_222D,D0
    CMP.B   D0,D7
    BNE.W   LAB_0C1F

    MOVEQ   #0,D0
    MOVE.W  LAB_222F,D0
    ASL.L   #2,D0
    LEA     LAB_2235,A0
    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     52.W
    PEA     299.W
    PEA     GLOB_ESQPARS2_C_1
    MOVE.L  A0,40(A7)
    JSR     GROUPB_JMP_TBL_MEMORY_AllocateMemory(PC)

    MOVEA.L 40(A7),A0
    MOVE.L  D0,(A0)
    MOVEQ   #0,D0
    MOVE.W  LAB_222F,D0
    ASL.L   #2,D0
    LEA     LAB_2237,A0
    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    PEA     500.W
    PEA     301.W
    PEA     GLOB_ESQPARS2_C_2
    MOVE.L  A0,52(A7)
    JSR     GROUPB_JMP_TBL_MEMORY_AllocateMemory(PC)

    LEA     28(A7),A7
    MOVEA.L 24(A7),A0
    MOVE.L  D0,(A0)
    MOVE.B  #$1,LAB_222E
    MOVE.B  D7,LAB_2239
    MOVEQ   #0,D0
    MOVE.W  LAB_222F,D0
    ASL.L   #2,D0
    LEA     LAB_2235,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    LEA     LAB_2237,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    BRA.W   LAB_0C21

LAB_0C1F:
    MOVE.B  LAB_2230,D0
    CMP.B   D0,D7
    BNE.W   LAB_0C20

    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     52.W
    PEA     314.W
    PEA     GLOB_ESQPARS2_C_3
    MOVE.L  A0,40(A7)
    JSR     GROUPB_JMP_TBL_MEMORY_AllocateMemory(PC)

    MOVEA.L 40(A7),A0
    MOVE.L  D0,(A0)
    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    ASL.L   #2,D0
    LEA     LAB_2236,A0
    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    PEA     500.W
    PEA     315.W
    PEA     GLOB_ESQPARS2_C_4
    MOVE.L  A0,52(A7)
    JSR     GROUPB_JMP_TBL_MEMORY_AllocateMemory(PC)

    LEA     28(A7),A7
    MOVEA.L 24(A7),A0
    MOVE.L  D0,(A0)
    MOVE.B  #$1,LAB_224A
    MOVE.B  D7,LAB_2238
    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    LEA     LAB_2236,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    MOVE.L  A1,-4(A5)
    BRA.S   LAB_0C21

LAB_0C20:
    MOVEQ   #0,D0
    BRA.W   LAB_0C30

LAB_0C21:
    MOVE.L  -4(A5),-(A7)
    BSR.W   LAB_0C1C

    MOVE.L  -4(A5),(A7)
    JSR     LAB_0C75(PC)

    ADDQ.W  #4,A7
    MOVEA.L -4(A5),A0
    MOVE.B  D7,(A0)
    MOVE.L  A2,-12(A5)
    LEA     1(A0),A1
    MOVEA.L A2,A0

LAB_0C22:
    TST.B   (A0)+
    BNE.S   LAB_0C22

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,D5
    MOVE.L  A1,-16(A5)

LAB_0C23:
    TST.W   D5
    BEQ.S   LAB_0C25

    MOVEA.L -12(A5),A0
    MOVE.B  (A0),D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BEQ.S   LAB_0C24

    MOVEA.L -16(A5),A1
    MOVE.B  D0,(A1)+
    MOVE.L  A1,-16(A5)

LAB_0C24:
    ADDQ.L  #1,-12(A5)
    SUBQ.W  #1,D5
    BRA.S   LAB_0C23

LAB_0C25:
    MOVEA.L -16(A5),A0
    MOVE.B  #$20,(A0)+
    CLR.B   (A0)
    MOVEA.L -4(A5),A1
    ADDQ.L  #1,A1
    MOVEA.L A1,A6

LAB_0C26:
    TST.B   (A6)+
    BNE.S   LAB_0C26

    SUBQ.L  #1,A6
    SUBA.L  A1,A6
    MOVE.L  A6,D5
    MOVE.W  LAB_224C,D0
    MOVE.L  A0,-16(A5)
    CMP.W   D0,D5
    BLE.S   LAB_0C27

    MOVE.W  D5,LAB_224C

LAB_0C27:
    MOVEA.L -4(A5),A0
    ADDA.W  #12,A0
    MOVEA.L A3,A1

LAB_0C28:
    MOVE.B  (A1)+,(A0)+
    BNE.S   LAB_0C28

    MOVEA.L -4(A5),A0
    ADDA.W  #19,A0
    MOVEA.L 28(A5),A1

LAB_0C29:
    MOVE.B  (A1)+,(A0)+
    BNE.S   LAB_0C29

    MOVEA.L -4(A5),A0
    MOVE.B  D6,27(A0)
    LEA     28(A0),A1
    MOVE.L  24(A5),-(A7)
    MOVE.L  A1,-(A7)
    JSR     GROUPB_JMP_TBL_ESQ_ReverseBitsIn6Bytes(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D5

LAB_0C2A:
    MOVEQ   #6,D0
    CMP.W   D0,D5
    BGE.S   LAB_0C2B

    MOVEA.L -4(A5),A0
    CLR.B   34(A0,D5.W)
    ADDQ.W  #1,D5
    BRA.S   LAB_0C2A

LAB_0C2B:
    MOVEA.L A3,A0
    MOVEA.L -8(A5),A1

LAB_0C2C:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_0C2C

    MOVEA.L -8(A5),A0
    MOVE.B  D7,498(A0)
    MOVEQ   #0,D5

LAB_0C2D:
    MOVEQ   #49,D0
    CMP.W   D0,D5
    BGE.S   LAB_0C2E

    MOVEA.L -8(A5),A0
    MOVE.B  #$1,7(A0,D5.W)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    CLR.L   56(A0,D0.L)
    ADDQ.W  #1,D5
    BRA.S   LAB_0C2D

LAB_0C2E:
    MOVE.B  LAB_2230,D0
    CMP.B   D7,D0
    BNE.S   LAB_0C2F

    MOVE.W  LAB_2231,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2231
    MOVE.W  LAB_224B,D0
    SUBQ.W  #2,D0
    BEQ.S   LAB_0C30

    MOVEQ   #1,D0
    MOVE.W  D0,LAB_224B
    BRA.S   LAB_0C30

LAB_0C2F:
    MOVE.B  LAB_222D,D0
    CMP.B   D0,D7
    BNE.S   LAB_0C30

    MOVE.W  LAB_222F,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_222F
    MOVE.W  #2,LAB_224B

LAB_0C30:
    MOVEM.L (A7)+,D5-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

LAB_0C31:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.L  16(A7),D7
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0C32

    MOVE.L  D7,(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0C35

    MOVE.L  A3,(A7)
    BSR.W   LAB_0C3C

    MOVE.L  A3,(A7)
    BSR.W   LAB_0C42

    ADDQ.W  #8,A7
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

LAB_0C32:
    LINK.W  A5,#-4
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 8(A5),A3

    PEA     GLOB_STR_CLOSED_CAPTIONED
    MOVE.L  A3,-(A7)
    JSR     GCOMMAND_JMP_TBL_LAB_00C3(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   .LAB_0C34

    MOVEA.L D0,A0
    MOVE.B  #$7c,(A0)+
    LEA     3(A0),A1
    MOVEA.L A1,A2

.LAB_0C33:
    TST.B   (A2)+
    BNE.S   .LAB_0C33

    SUBQ.L  #1,A2
    SUBA.L  A1,A2
    MOVE.L  A2,D0
    ADDQ.L  #1,D0
    MOVE.L  A0,-4(A5)
    MOVEA.L A1,A0
    MOVEA.L -4(A5),A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

.LAB_0C34:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======

LAB_0C35:
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    PEA     GLOB_STR_IN_STEREO
    MOVE.L  A3,-(A7)
    JSR     GCOMMAND_JMP_TBL_LAB_00C3(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   LAB_0C3B

    MOVEA.L D0,A0
    MOVE.B  #$91,(A0)
    LEA     9(A0),A1
    MOVE.L  A1,-8(A5)
    BTST    #7,D7
    BNE.S   LAB_0C39

    TST.B   (A1)
    BNE.S   LAB_0C37

LAB_0C36:
    MOVEA.L -4(A5),A0
    CLR.B   (A0)
    SUBQ.L  #1,-4(A5)
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #3,(A0)
    BNE.S   LAB_0C36

    BRA.S   LAB_0C3B

LAB_0C37:
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_0C77(PC)

    ADDQ.W  #4,A7
    MOVEA.L D0,A0

LAB_0C38:
    TST.B   (A0)+
    BNE.S   LAB_0C38

    SUBQ.L  #1,A0
    SUBA.L  D0,A0
    MOVE.L  A0,D1
    ADDQ.L  #1,D1
    MOVE.L  D0,-8(A5)
    MOVEA.L D0,A0
    MOVE.L  D1,D0
    MOVEA.L -4(A5),A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    BRA.S   LAB_0C3B

LAB_0C39:
    ADDQ.L  #1,-4(A5)
    MOVEA.L -8(A5),A0

LAB_0C3A:
    TST.B   (A0)+
    BNE.S   LAB_0C3A

    SUBQ.L  #1,A0
    SUBA.L  -8(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVEA.L -8(A5),A0
    MOVEA.L -4(A5),A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

LAB_0C3B:
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

; Possibly the code that replaces the strings of TV ratings like (TV-G) into
; a corresponding character in the font
LAB_0C3C:
    LINK.W  A5,#-16
    MOVEM.L D5-D7/A2-A3,-(A7)

    UseLinkStackLong    MOVEA.L,1,A3

    MOVEQ   #0,D5
    MOVEQ   #0,D7

.LAB_0C3D:
    MOVEQ   #7,D0
    CMP.L   D0,D7
    BGE.S   .return

    TST.W   D5
    BNE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     GLOB_TBL_MOVIE_RATINGS,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    MOVE.L  A3,-(A7)
    JSR     GCOMMAND_JMP_TBL_LAB_00C3(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   .LAB_0C40

    LEA     LAB_1F1E,A0
    ADDA.L  D7,A0
    MOVE.B  (A0),D0
    MOVEA.L -4(A5),A1
    MOVE.B  D0,(A1)+
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     GLOB_TBL_MOVIE_RATINGS,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2

.LAB_0C3E:
    TST.B   (A2)+
    BNE.S   .LAB_0C3E

    SUBQ.L  #1,A2
    SUBA.L  (A0),A2
    MOVE.L  A2,D0
    MOVE.L  D0,D6
    SUBQ.L  #1,D6
    MOVE.L  A1,-4(A5)
    ADDA.L  D6,A1
    MOVEA.L A1,A0

.LAB_0C3F:
    TST.B   (A0)+
    BNE.S   .LAB_0C3F

    SUBQ.L  #1,A0
    SUBA.L  A1,A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVEA.L A1,A0
    MOVEA.L -4(A5),A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    MOVEQ   #1,D5

.LAB_0C40:
    ADDQ.L  #1,D7
    BRA.S   .LAB_0C3D

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

; Possibly the code that replaces the strings of movie ratings like (R) into
; a corresponding character in the font
LAB_0C42:
    LINK.W  A5,#-16
    MOVEM.L D5-D7/A2-A3,-(A7)

    UseLinkStackLong    MOVEA.L,1,A3

    MOVEQ   #0,D5
    MOVEQ   #0,D7

.LAB_0C43:
    MOVEQ   #7,D0
    CMP.L   D0,D7
    BGE.S   .return

    TST.W   D5
    BNE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     GLOB_TBL_TV_PROGRAM_RATINGS,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    MOVE.L  A3,-(A7)
    JSR     GCOMMAND_JMP_TBL_LAB_00C3(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   .LAB_0C46

    LEA     LAB_1F27,A0
    ADDA.L  D7,A0
    MOVE.B  (A0),D0
    MOVEA.L -4(A5),A1
    MOVE.B  D0,(A1)+
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     GLOB_TBL_TV_PROGRAM_RATINGS,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2

.LAB_0C44:
    TST.B   (A2)+
    BNE.S   .LAB_0C44

    SUBQ.L  #1,A2
    SUBA.L  (A0),A2
    MOVE.L  A2,D0
    MOVE.L  D0,D6
    SUBQ.L  #1,D6
    MOVE.L  A1,-4(A5)
    ADDA.L  D6,A1
    MOVEA.L A1,A0

.LAB_0C45:
    TST.B   (A0)+
    BNE.S   .LAB_0C45

    SUBQ.L  #1,A0
    SUBA.L  A1,A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVEA.L A1,A0
    MOVEA.L -4(A5),A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    MOVEQ   #1,D5

.LAB_0C46:
    ADDQ.L  #1,D7
    BRA.S   .LAB_0C43

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

LAB_0C48:
    LINK.W  A5,#-76
    MOVEM.L D2-D7/A2-A3/A6,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.B  15(A5),D7
    MOVE.B  19(A5),D6
    MOVE.B  23(A5),D5
    MOVEA.L 24(A5),A2

    MOVE.L  D6,D0
    ANDI.B  #$40,D0
    ANDI.B  #$3f,D6
    MOVE.B  D0,-15(A5)
    MOVEQ   #1,D0
    CMP.B   D0,D6
    BCS.S   LAB_0C49

    MOVEQ   #48,D1
    CMP.B   D1,D6
    BLS.S   LAB_0C4A

LAB_0C49:
    MOVEQ   #0,D0
    BRA.W   LAB_0C70

LAB_0C4A:
    MOVE.B  LAB_222D,D0
    CMP.B   D7,D0
    BNE.S   LAB_0C4B

    MOVE.B  LAB_222E,D0
    SUBQ.B  #1,D0
    BNE.S   LAB_0C4B

    MOVE.W  LAB_222F,D0
    MOVE.W  D0,-14(A5)
    BRA.S   LAB_0C4D

LAB_0C4B:
    MOVE.B  LAB_2230,D0
    CMP.B   D0,D7
    BNE.S   LAB_0C4C

    MOVE.W  LAB_2231,D0
    MOVE.W  D0,-14(A5)
    BRA.S   LAB_0C4D

LAB_0C4C:
    MOVEQ   #0,D0
    BRA.W   LAB_0C70

LAB_0C4D:
    CLR.W   -10(A5)

LAB_0C4E:
    MOVE.W  -10(A5),D0
    CMP.W   -14(A5),D0
    BGE.W   LAB_0C70

    MOVE.B  LAB_222D,D1
    CMP.B   D1,D7
    BNE.S   LAB_0C4F

    MOVE.B  LAB_222E,D1
    SUBQ.B  #1,D1
    BNE.S   LAB_0C4F

    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     LAB_2235,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-4(A5)
    LEA     LAB_2237,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-8(A5)
    BRA.S   LAB_0C50

LAB_0C4F:
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     LAB_2233,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-4(A5)
    LEA     LAB_2236,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-8(A5)

LAB_0C50:
    MOVE.L  A3,-(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     GROUPB_JMP_TBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.W   LAB_0C6F

    MOVEA.L -4(A5),A0
    ADDA.W  #$22,A0
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     GROUPB_JMP_TBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    MOVE.W  D0,-12(A5)
    TST.B   -15(A5)
    BNE.S   LAB_0C51

    TST.W   D0
    BNE.W   LAB_0C6F

LAB_0C51:
    TST.B   -15(A5)
    BEQ.S   LAB_0C52

    MOVEA.L -4(A5),A0
    ADDA.W  #$22,A0
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     GROUPB_JMP_TBL_ESQ_SetBit1Based(PC)

    ADDQ.W  #8,A7

LAB_0C52:
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVEA.L -8(A5),A0
    MOVE.B  D5,7(A0,D0.W)
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A1
    MOVE.B  27(A1),D0
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    BSR.W   LAB_0C31

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    MOVEA.L A2,A0
    MOVEA.L A0,A1

LAB_0C53:
    TST.B   (A1)+
    BNE.S   LAB_0C53

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D1
    MOVE.L  A0,-34(A5)
    ADDA.L  D1,A0
    MOVE.B  D0,-30(A5)
    MOVE.B  D0,-29(A5)
    MOVE.L  A0,-28(A5)
    MOVE.B  -1(A0),D0
    MOVEQ   #41,D1
    CMP.B   D1,D0
    BNE.S   LAB_0C54

    MOVE.B  -4(A0),D2
    MOVEQ   #58,D3
    CMP.B   D3,D2
    BNE.S   LAB_0C54

    MOVEQ   #40,D4
    CMP.B   -6(A0),D4
    BNE.S   LAB_0C54

    MOVEQ   #1,D4
    MOVE.B  D4,-29(A5)

LAB_0C54:
    CMP.B   D1,D0
    BNE.S   LAB_0C55

    MOVEQ   #58,D0
    CMP.B   -4(A0),D0
    BNE.S   LAB_0C55

    MOVEQ   #40,D0
    CMP.B   -5(A0),D0
    BNE.S   LAB_0C55

    MOVEQ   #1,D0
    MOVE.B  D0,-30(A5)

LAB_0C55:
    TST.B   -29(A5)
    BNE.S   LAB_0C56

    TST.B   -30(A5)
    BEQ.W   LAB_0C5F

LAB_0C56:
    MOVEQ   #0,D0
    SUBA.L  A1,A1
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     50.W
    PEA     720.W
    PEA     GLOB_STR_ESQPARS2_C_1
    MOVE.L  D0,-42(A5)
    MOVE.L  D0,-38(A5)
    MOVE.L  A1,-70(A5)
    MOVE.L  A1,-66(A5)
    JSR     GROUPB_JMP_TBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-70(A5)
    MOVE.L  D0,-66(A5)
    TST.B   -29(A5)
    BEQ.S   LAB_0C57

    MOVEA.L -28(A5),A0
    MOVE.B  -5(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,-38(A5)

LAB_0C57:
    MOVEA.L -28(A5),A0
    MOVE.B  -3(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    MOVE.L  D0,-42(A5)
    JSR     GROUPB_JMP_TBL_LAB_1A06(PC)

    MOVE.B  -2(A0),D1
    EXT.W   D1
    EXT.L   D1
    ADD.L   D1,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEM.L D0,-42(A5)
    MOVE.L  -38(A5),D1
    TST.L   D1
    BLE.S   LAB_0C59

    MOVE.L  D0,-(A7)
    PEA     LAB_1F29
    PEA     -52(A5)
    JSR     JMP_TBL_PRINTF_3(PC)

    MOVE.L  -38(A5),(A7)
    PEA     LAB_1F2A
    PEA     -62(A5)
    JSR     JMP_TBL_PRINTF_3(PC)

    PEA     -62(A5)
    MOVE.L  -66(A5),-(A7)
    JSR     GROUP_AR_JMP_TBL_UNKNOWN6_AppendDataAtNull(PC)

    LEA     28(A7),A7
    MOVEQ   #1,D0
    CMP.L   -38(A5),D0
    BNE.S   LAB_0C58

    PEA     LAB_2103
    MOVE.L  -66(A5),-(A7)
    JSR     GROUP_AR_JMP_TBL_UNKNOWN6_AppendDataAtNull(PC)

    ADDQ.W  #8,A7
    BRA.S   LAB_0C5A

LAB_0C58:
    PEA     LAB_2102
    MOVE.L  -66(A5),-(A7)
    JSR     GROUP_AR_JMP_TBL_UNKNOWN6_AppendDataAtNull(PC)

    ADDQ.W  #8,A7
    BRA.S   LAB_0C5A

LAB_0C59:
    MOVE.L  D0,-(A7)
    PEA     LAB_1F2B
    PEA     -52(A5)
    JSR     JMP_TBL_PRINTF_3(PC)

    LEA     12(A7),A7

LAB_0C5A:
    MOVE.L  -42(A5),D0
    TST.L   D0
    BLE.S   LAB_0C5B

    PEA     -52(A5)
    MOVE.L  -66(A5),-(A7)
    JSR     GROUP_AR_JMP_TBL_UNKNOWN6_AppendDataAtNull(PC)

    PEA     LAB_2104
    MOVE.L  -66(A5),-(A7)
    JSR     GROUP_AR_JMP_TBL_UNKNOWN6_AppendDataAtNull(PC)

    LEA     16(A7),A7
    BRA.S   LAB_0C5D

LAB_0C5B:
    MOVEA.L -66(A5),A0

LAB_0C5C:
    TST.B   (A0)+
    BNE.S   LAB_0C5C

    SUBQ.L  #1,A0
    SUBA.L  -66(A5),A0
    MOVEA.L -66(A5),A1
    MOVE.L  A0,D0
    CLR.B   -1(A1,D0.L)
    PEA     LAB_1F2C
    MOVE.L  A1,-(A7)
    JSR     GROUP_AR_JMP_TBL_UNKNOWN6_AppendDataAtNull(PC)

    ADDQ.W  #8,A7

LAB_0C5D:
    MOVEA.L -28(A5),A0
    SUBQ.L  #6,A0
    MOVEA.L -66(A5),A1

LAB_0C5E:
    MOVE.B  (A1)+,(A0)+
    BNE.S   LAB_0C5E

    TST.L   -70(A5)
    BEQ.S   LAB_0C5F

    PEA     50.W
    MOVE.L  -70(A5),-(A7)
    PEA     765.W
    PEA     GLOB_STR_ESQPARS2_C_2
    JSR     GROUPB_JMP_TBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

LAB_0C5F:
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,D2
    EXT.L   D2
    ASL.L   #2,D2
    MOVEA.L -8(A5),A0
    MOVE.L  56(A0,D2.L),-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  D1,44(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVEA.L -8(A5),A0
    MOVE.L  36(A7),D1
    MOVE.L  D0,56(A0,D1.L)
    MOVE.B  LAB_1DD8,D0
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.W   LAB_0C6D

    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    PEA     91.W
    MOVE.L  56(A0,D1.L),-(A7)
    JSR     GCOMMAND_JMP_TBL_LAB_1979(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-20(A5)
    TST.L   D0
    BEQ.W   LAB_0C6D

    MOVEA.L D0,A0
    MOVE.B  1(A0),D1
    EXT.W   D1
    EXT.L   D1
    LEA     LAB_21A8,A1
    MOVEA.L A1,A6
    ADDA.L  D1,A6
    BTST    #2,(A6)
    BEQ.S   LAB_0C60

    MOVE.B  1(A0),D1
    EXT.W   D1
    EXT.L   D1
    MOVEQ   #48,D2
    SUB.L   D2,D1
    MOVEQ   #10,D0
    JSR     GROUPB_JMP_TBL_LAB_1A06(PC)

    BRA.S   LAB_0C61

LAB_0C60:
    MOVEQ   #0,D0

LAB_0C61:
    MOVE.B  2(A0),D1
    EXT.W   D1
    EXT.L   D1
    MOVEA.L A1,A6
    ADDA.L  D1,A6
    MOVE.W  D0,-22(A5)
    BTST    #2,(A6)
    BEQ.S   LAB_0C62

    MOVE.B  2(A0),D1
    EXT.W   D1
    EXT.L   D1
    MOVEQ   #48,D2
    SUB.L   D2,D1
    BRA.S   LAB_0C63

LAB_0C62:
    MOVEQ   #0,D1

LAB_0C63:
    EXT.L   D0
    ADD.L   D1,D0
    MOVE.B  4(A0),D1
    EXT.W   D1
    EXT.L   D1
    MOVEA.L A1,A6
    ADDA.L  D1,A6
    MOVE.W  D0,-22(A5)
    BTST    #2,(A6)
    BEQ.S   LAB_0C64

    MOVE.B  4(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     GROUPB_JMP_TBL_LAB_1A06(PC)

    BRA.S   LAB_0C65

LAB_0C64:
    MOVEQ   #0,D0

LAB_0C65:
    MOVE.B  5(A0),D1
    EXT.W   D1
    EXT.L   D1
    ADDA.L  D1,A1
    MOVE.W  D0,-24(A5)
    BTST    #2,(A1)
    BEQ.S   LAB_0C66

    MOVE.B  5(A0),D1
    EXT.W   D1
    EXT.L   D1
    MOVEQ   #48,D2
    SUB.L   D2,D1
    BRA.S   LAB_0C67

LAB_0C66:
    MOVEQ   #0,D1

LAB_0C67:
    EXT.L   D0
    ADD.L   D1,D0
    MOVE.W  D0,-24(A5)
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  LAB_1DD8,D1
    ADD.L   D1,D0
    MOVE.W  D0,-24(A5)

LAB_0C68:
    MOVE.W  -24(A5),D0
    MOVEQ   #59,D1
    CMP.W   D1,D0
    BLE.S   LAB_0C69

    MOVEQ   #60,D1
    SUB.W   D1,-24(A5)
    ADDQ.W  #1,-22(A5)
    BRA.S   LAB_0C68

LAB_0C69:
    MOVE.W  -22(A5),D0
    MOVEQ   #12,D1
    CMP.W   D1,D0
    BLE.S   LAB_0C6A

    MOVEQ   #12,D1
    SUB.W   D1,-22(A5)
    BRA.S   LAB_0C69

LAB_0C6A:
    MOVE.W  -22(A5),D0
    EXT.L   D0
    MOVEQ   #10,D1
    JSR     JMP_TBL_LAB_1A07_3(PC)

    MOVEQ   #48,D0
    ADD.L   D0,D1
    MOVEA.L -20(A5),A0
    MOVE.B  D1,2(A0)
    MOVE.W  -22(A5),D1
    EXT.L   D1
    DIVS    #10,D1
    MOVEM.W D1,-22(A5)
    BLE.S   LAB_0C6B

    EXT.L   D1
    ADD.L   D0,D1
    BRA.S   LAB_0C6C

LAB_0C6B:
    MOVEQ   #32,D1

LAB_0C6C:
    MOVE.B  D1,1(A0)
    MOVE.W  -24(A5),D1
    EXT.L   D1
    MOVE.L  D1,D0
    MOVEQ   #10,D1
    JSR     JMP_TBL_LAB_1A07_3(PC)

    MOVEQ   #48,D1
    ADD.L   D1,D0
    MOVE.B  D0,4(A0)
    MOVE.W  -24(A5),D0
    EXT.L   D0
    MOVEQ   #10,D1
    JSR     JMP_TBL_LAB_1A07_3(PC)

    MOVEQ   #48,D0
    ADD.L   D0,D1
    MOVE.B  D1,5(A0)

LAB_0C6D:
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    EXT.L   D0
    MOVEQ   #0,D2
    MOVEA.L -8(A5),A0
    MOVE.B  498(A0),D2
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,44(A7)
    JSR     LAB_0C71(PC)

    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  44(A7),D1
    MOVE.L  56(A0,D1.L),-(A7)
    JSR     GROUPB_JMP_TBL_ESQ_AdjustBracketedHourInString(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVEA.L -8(A5),A0
    BTST    #4,7(A0,D0.W)
    BEQ.S   LAB_0C6E

    MOVEA.L -4(A5),A0
    BSET    #0,40(A0)

LAB_0C6E:
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  40(A0),D0
    ORI.W   #$80,D0
    MOVE.B  D0,40(A0)

LAB_0C6F:
    ADDQ.W  #1,-10(A5)
    BRA.W   LAB_0C4E

LAB_0C70:
    MOVEM.L (A7)+,D2-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_0C71:
    JMP     LAB_064D

GROUPB_JMP_TBL_ESQ_ReverseBitsIn6Bytes:
    JMP     ESQ_ReverseBitsIn6Bytes

GROUPB_JMP_TBL_ESQ_SetBit1Based:
    JMP     ESQ_SetBit1Based

GROUPB_JMP_TBL_ESQ_AdjustBracketedHourInString:
    JMP     ESQ_AdjustBracketedHourInString

LAB_0C75:
    JMP     LAB_0345

GROUPB_JMP_TBL_ESQ_WildcardMatch:
    JMP     ESQ_WildcardMatch

LAB_0C77:
    JMP     LAB_1985

GROUPB_JMP_TBL_ESQ_TestBit1Based:
    JMP     ESQ_TestBit1Based
