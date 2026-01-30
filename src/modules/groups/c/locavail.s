LAB_0F03:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    CLR.B   (A3)
    MOVEQ   #0,D0
    MOVE.W  D0,2(A3)
    MOVE.W  D0,4(A3)
    CLR.L   6(A3)
    MOVEA.L (A7)+,A3
    RTS

;!======

LAB_0F04:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  A3,D0
    BEQ.S   LAB_0F06

    TST.L   6(A3)
    BEQ.S   LAB_0F05

    MOVE.W  4(A3),D0
    TST.W   D0
    BLE.S   LAB_0F05

    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  6(A3),-(A7)
    PEA     106.W
    PEA     GLOB_STR_LOCAVAIL_C_1
    JSR     GROUPC_JMP_TBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

LAB_0F05:
    MOVE.L  A3,-(A7)
    BSR.S   LAB_0F03

    ADDQ.W  #4,A7

LAB_0F06:
    MOVEA.L (A7)+,A3
    RTS

;!======

LAB_0F07:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    CLR.B   (A3)
    CLR.L   2(A3)
    SUBA.L  A0,A0
    MOVE.L  A0,16(A3)
    MOVE.L  A0,20(A3)
    MOVE.B  #$46,6(A3)
    MOVEQ   #-1,D0
    MOVE.L  D0,8(A3)
    MOVE.L  D0,12(A3)
    MOVEA.L (A7)+,A3
    RTS

;!======

; Release a LOCAVAIL structure (free node array/bitmap and associated memory).
LOCAVAIL_FreeResourceChain:
LAB_0F08:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.L  A3,D0
    BEQ.W   LAB_0F0D

    TST.L   16(A3)
    BEQ.W   LAB_0F0C

    MOVEA.L 16(A3),A0
    MOVE.L  (A0),D0
    TST.L   D0
    BLE.S   LAB_0F09

    SUBQ.L  #1,(A0)

LAB_0F09:
    TST.L   20(A3)
    BEQ.S   LAB_0F0C

    MOVE.L  2(A3),D0
    TST.L   D0
    BLE.S   LAB_0F0C

    MOVEA.L 16(A3),A0
    TST.L   (A0)
    BNE.S   LAB_0F0C

    PEA     4.W
    MOVE.L  A0,-(A7)
    PEA     159.W
    PEA     GLOB_STR_LOCAVAIL_C_2
    JSR     GROUPC_JMP_TBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVEQ   #0,D7

LAB_0F0A:
    CMP.L   2(A3),D7
    BGE.S   LAB_0F0B

    MOVE.L  D7,D0
    MOVEQ   #10,D1
    JSR     JMP_TBL_LAB_1A06_6(PC)

    MOVEA.L 20(A3),A0
    ADDA.L  D0,A0
    MOVE.L  A0,-(A7)
    BSR.W   LAB_0F04

    ADDQ.W  #4,A7
    ADDQ.L  #1,D7
    BRA.S   LAB_0F0A

LAB_0F0B:
    MOVE.L  2(A3),D0
    MOVEQ   #10,D1
    JSR     JMP_TBL_LAB_1A06_5(PC)

    MOVE.L  D0,-(A7)
    MOVE.L  20(A3),-(A7)
    PEA     164.W
    PEA     GLOB_STR_LOCAVAIL_C_3
    JSR     GROUPC_JMP_TBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

LAB_0F0C:
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0F07

    ADDQ.W  #4,A7

LAB_0F0D:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

LAB_0F0E:
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEA.L 16(A7),A2
    MOVE.B  (A2),(A3)
    MOVE.L  2(A2),2(A3)
    MOVE.B  6(A2),6(A3)
    MOVEA.L 16(A2),A0
    MOVE.L  A0,16(A3)
    MOVE.L  20(A2),20(A3)
    TST.L   16(A3)
    BEQ.S   LAB_0F0F

    MOVEA.L 16(A3),A0
    ADDQ.L  #1,(A0)

LAB_0F0F:
    MOVEM.L (A7)+,A2-A3
    RTS

;!======

LAB_0F10:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7
    MOVE.L  2(A3),D0
    TST.L   D0
    BLE.S   LAB_0F11

    MOVEQ   #100,D1
    CMP.L   D1,D0
    BGE.S   LAB_0F11

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     4.W
    PEA     218.W
    PEA     GLOB_STR_LOCAVAIL_C_4
    JSR     GROUPC_JMP_TBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,16(A3)
    TST.L   D0
    BEQ.S   LAB_0F11

    MOVEA.L D0,A0
    CLR.L   (A0)
    MOVE.L  2(A3),D0
    MOVEQ   #10,D1
    JSR     JMP_TBL_LAB_1A06_5(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     229.W
    PEA     GLOB_STR_LOCAVAIL_C_5
    JSR     GROUPC_JMP_TBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,20(A3)
    BEQ.S   LAB_0F11

    MOVEQ   #1,D7

LAB_0F11:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

LAB_0F12:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVEQ   #-1,D0
    MOVE.L  D0,8(A3)
    MOVE.L  D0,12(A3)
    MOVE.L  D0,LAB_1FE8
    CLR.L   LAB_1FE7
    MOVEA.L (A7)+,A3
    RTS

;!======

LAB_0F13:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    MOVE.L  LAB_1FE6,D0
    CMP.L   D7,D0
    BEQ.S   LAB_0F15

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BEQ.S   LAB_0F14

    TST.L   D7
    BNE.S   LAB_0F15

LAB_0F14:
    MOVE.L  D7,LAB_1FE6
    PEA     LAB_2321
    BSR.S   LAB_0F12

    ADDQ.W  #4,A7

LAB_0F15:
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_0F16:
    LINK.W  A5,#-52
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEQ   #1,D5
    PEA     -24(A5)
    BSR.W   LAB_0F07

    ADDQ.W  #4,A7
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-24(A5)
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-51(A5)
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   LAB_0F17

    MOVE.B  -51(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   LAB_0F18

LAB_0F17:
    MOVE.B  -51(A5),D0
    EXT.W   D0
    EXT.L   D0

LAB_0F18:
    MOVE.B  D0,-51(A5)
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1FF0
    JSR     GCOMMAND_JMP_TBL_LAB_1979(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.W   LAB_0F32

    MOVE.B  -51(A5),D0
    MOVE.B  D0,-18(A5)
    MOVEQ   #0,D7

LAB_0F19:
    MOVEQ   #2,D0
    CMP.L   D0,D7
    BGE.S   LAB_0F1A

    MOVEA.L D7,A0
    ADDQ.L  #1,D7
    MOVE.L  A0,D0
    MOVE.B  (A3)+,-51(A5,D0.L)
    BRA.S   LAB_0F19

LAB_0F1A:
    CLR.B   -51(A5,D7.L)
    PEA     -51(A5)
    JSR     LAB_134E(PC)

    MOVE.L  D0,-22(A5)
    PEA     -24(A5)
    BSR.W   LAB_0F10

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.W   LAB_0F31

    MOVEQ   #0,D7

LAB_0F1B:
    TST.L   D5
    BEQ.W   LAB_0F33

    CMP.L   -22(A5),D7
    BGE.W   LAB_0F33

    MOVE.B  (A3)+,D0
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BNE.W   LAB_0F2F

    MOVE.L  D7,D0
    MOVEQ   #10,D1
    JSR     JMP_TBL_LAB_1A06_6(PC)

    MOVEA.L -4(A5),A0
    ADDA.L  D0,A0
    MOVEQ   #0,D6
    MOVE.L  A0,-28(A5)

LAB_0F1C:
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BGE.S   LAB_0F1D

    MOVEA.L D6,A0
    ADDQ.L  #1,D6
    MOVE.L  A0,D0
    MOVE.B  (A3)+,-51(A5,D0.L)
    BRA.S   LAB_0F1C

LAB_0F1D:
    CLR.B   -51(A5,D6.L)
    PEA     -51(A5)
    JSR     LAB_134E(PC)

    ADDQ.W  #4,A7
    MOVEA.L -28(A5),A0
    MOVE.B  D0,(A0)
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.W   LAB_0F2E

    MOVEQ   #100,D1
    CMP.B   D1,D0
    BCC.W   LAB_0F2E

    MOVEQ   #0,D6

LAB_0F1E:
    MOVEQ   #4,D0
    CMP.L   D0,D6
    BGE.S   LAB_0F1F

    MOVEA.L D6,A0
    ADDQ.L  #1,D6
    MOVE.L  A0,D0
    MOVE.B  (A3)+,-51(A5,D0.L)
    BRA.S   LAB_0F1E

LAB_0F1F:
    CLR.B   -51(A5,D6.L)
    PEA     -51(A5)
    JSR     LAB_134E(PC)

    ADDQ.W  #4,A7
    MOVEA.L -28(A5),A0
    MOVE.W  D0,2(A0)
    BLE.W   LAB_0F2D

    CMPI.W  #$e11,D0
    BGE.W   LAB_0F2D

    MOVEQ   #0,D6

LAB_0F20:
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BGE.S   LAB_0F21

    MOVEA.L D6,A0
    ADDQ.L  #1,D6
    MOVE.L  A0,D0
    MOVE.B  (A3)+,-51(A5,D0.L)
    BRA.S   LAB_0F20

LAB_0F21:
    CLR.B   -51(A5,D6.L)
    PEA     -51(A5)
    JSR     LAB_134E(PC)

    ADDQ.W  #4,A7
    MOVEA.L -28(A5),A0
    MOVE.W  D0,4(A0)
    TST.W   D0
    BLE.W   LAB_0F2C

    MOVEQ   #100,D1
    CMP.W   D1,D0
    BGE.W   LAB_0F2C

    EXT.L   D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     341.W
    PEA     GLOB_STR_LOCAVAIL_C_6
    JSR     GROUPC_JMP_TBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L -28(A5),A0
    MOVE.L  D0,6(A0)
    BEQ.W   LAB_0F2B

    MOVEQ   #0,D6

LAB_0F22:
    TST.L   D5
    BEQ.W   LAB_0F30

    MOVEA.L -28(A5),A0
    MOVE.W  4(A0),D0
    EXT.L   D0
    CMP.L   D0,D6
    BGE.W   LAB_0F30

    MOVE.B  (A3)+,D0
    MOVE.B  D0,-51(A5)
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   LAB_0F23

    MOVE.B  -51(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   LAB_0F24

LAB_0F23:
    MOVE.B  -51(A5),D0
    EXT.W   D0
    EXT.L   D0

LAB_0F24:
    MOVEQ   #48,D1
    SUB.L   D1,D0
    BEQ.S   LAB_0F28

    MOVEQ   #23,D1
    SUB.L   D1,D0
    BEQ.S   LAB_0F25

    SUBQ.L  #2,D0
    BEQ.S   LAB_0F27

    SUBQ.L  #3,D0
    BEQ.S   LAB_0F28

    SUBQ.L  #8,D0
    BEQ.S   LAB_0F26

    SUBQ.L  #1,D0
    BEQ.S   LAB_0F28

    SUBQ.L  #1,D0
    BNE.S   LAB_0F29

    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  #$1,(A0)
    BRA.S   LAB_0F2A

LAB_0F25:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  #$2,(A0)
    BRA.S   LAB_0F2A

LAB_0F26:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  #$3,(A0)
    BRA.S   LAB_0F2A

LAB_0F27:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  #$4,(A0)
    BRA.S   LAB_0F2A

LAB_0F28:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    CLR.B   (A0)
    BRA.S   LAB_0F2A

LAB_0F29:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    CLR.B   (A0)
    MOVEQ   #0,D5

LAB_0F2A:
    ADDQ.L  #1,D6
    BRA.W   LAB_0F22

LAB_0F2B:
    MOVEQ   #0,D5
    BRA.S   LAB_0F30

LAB_0F2C:
    MOVEQ   #0,D5
    BRA.S   LAB_0F30

LAB_0F2D:
    MOVEQ   #0,D5
    BRA.S   LAB_0F30

LAB_0F2E:
    MOVEQ   #0,D5
    BRA.S   LAB_0F30

LAB_0F2F:
    MOVEQ   #0,D5

LAB_0F30:
    ADDQ.L  #1,D7
    BRA.W   LAB_0F1B

LAB_0F31:
    TST.L   -22(A5)
    BEQ.S   LAB_0F33

    MOVEQ   #0,D5
    BRA.S   LAB_0F33

LAB_0F32:
    MOVEQ   #0,D5

LAB_0F33:
    TST.L   D5
    BEQ.S   LAB_0F34

    MOVE.L  A2,-(A7)
    BSR.W   LAB_0F08

    PEA     -24(A5)
    MOVE.L  A2,-(A7)
    BSR.W   LAB_0F0E

    LEA     12(A7),A7
    BRA.S   LAB_0F35

LAB_0F34:
    PEA     -24(A5)
    BSR.W   LAB_0F08

    ADDQ.W  #4,A7

LAB_0F35:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_0F36:
    MOVEM.L D6-D7,-(A7)
    MOVE.B  15(A7),D7
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   LAB_0F37

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D6
    MOVEQ   #48,D1
    SUB.L   D1,D6
    BRA.S   LAB_0F3B

LAB_0F37:
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #3,D0
    AND.B   (A1),D0
    TST.B   D0
    BEQ.S   LAB_0F3A

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   LAB_0F38

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   LAB_0F39

LAB_0F38:
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0

LAB_0F39:
    MOVE.L  D0,D6
    MOVEQ   #55,D1
    SUB.L   D1,D6
    BRA.S   LAB_0F3B

LAB_0F3A:
    MOVEQ   #0,D6

LAB_0F3B:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.L  20(A7),D7
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BEQ.S   LAB_0F3C

    TST.L   D7
    BMI.S   LAB_0F3C

    CMP.L   2(A3),D7
    BGE.S   LAB_0F3C

    MOVE.L  D7,D0
    MOVEQ   #10,D1
    JSR     JMP_TBL_LAB_1A06_6(PC)

    MOVEA.L 20(A3),A0
    ADDA.L  D0,A0
    MOVE.W  2(A0),D6

LAB_0F3C:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

LAB_0F3D:
    LINK.W  A5,#-28
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEQ   #-1,D4
    MOVEQ   #-1,D0
    CLR.L   -28(A5)
    MOVE.L  D0,-20(A5)
    TST.L   LAB_1FE7
    BNE.W   LAB_0F4C

    CMP.L   LAB_1FE9,D0
    BNE.W   LAB_0F4C

    MOVEQ   #0,D7

LAB_0F3E:
    TST.B   (A3)
    BEQ.W   LAB_0F43

    MOVE.B  (A3),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0F36

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    CLR.L   -24(A5)
    MOVEQ   #0,D6

LAB_0F3F:
    TST.L   D5
    BEQ.S   LAB_0F41

    CMP.L   2(A2),D6
    BGE.S   LAB_0F41

    MOVE.L  D6,D0
    MOVEQ   #10,D1
    JSR     JMP_TBL_LAB_1A06_6(PC)

    MOVEA.L 20(A2),A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVEQ   #0,D1
    MOVE.B  (A0),D1
    CMP.L   D1,D0
    BNE.S   LAB_0F40

    MOVE.L  6(A0),-28(A5)
    MOVE.L  A0,-24(A5)
    BRA.S   LAB_0F41

LAB_0F40:
    ADDQ.L  #1,D6
    BRA.S   LAB_0F3F

LAB_0F41:
    TST.L   D5
    BEQ.S   LAB_0F42

    TST.L   -24(A5)
    BEQ.S   LAB_0F42

    SUBQ.L  #1,D5
    MOVEA.L -24(A5),A0
    MOVE.W  4(A0),D0
    EXT.L   D0
    CMP.L   D0,D5
    BGE.S   LAB_0F42

    MOVEA.L -28(A5),A0
    TST.B   0(A0,D5.L)
    BEQ.S   LAB_0F42

    MOVEQ   #-1,D0
    CMP.L   D0,D4
    BNE.S   LAB_0F43

    CMP.L   -20(A5),D0
    BNE.S   LAB_0F43

    MOVE.L  D6,D4
    MOVE.L  D5,-20(A5)
    BRA.S   LAB_0F43

LAB_0F42:
    ADDQ.L  #1,D7
    ADDQ.L  #1,A3
    BRA.W   LAB_0F3E

LAB_0F43:
    MOVEQ   #-1,D0
    CMP.L   D0,D4
    BEQ.W   LAB_0F4B

    MOVE.L  -20(A5),D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BEQ.W   LAB_0F4B

    MOVE.L  D4,D0
    MOVEQ   #10,D1
    JSR     JMP_TBL_LAB_1A06_6(PC)

    MOVEA.L 20(A2),A0
    ADDA.L  D0,A0
    MOVEA.L 6(A0),A1
    MOVEQ   #0,D0
    MOVE.L  -20(A5),D1
    MOVE.B  0(A1,D1.L),D0
    MOVE.L  A0,-24(A5)
    MOVE.L  A1,-28(A5)
    SUBQ.W  #1,D0
    BEQ.S   LAB_0F44

    SUBQ.W  #1,D0
    BEQ.S   LAB_0F46

    SUBQ.W  #1,D0
    BEQ.S   LAB_0F48

    SUBQ.W  #1,D0
    BEQ.S   LAB_0F49

    BRA.S   LAB_0F4A

LAB_0F44:
    MOVEQ   #0,D0
    MOVE.B  LAB_1DD7,D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1FF2
    JSR     GCOMMAND_JMP_TBL_LAB_1979(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_0F45

    JSR     LAB_0F9C(PC)

    TST.B   D0
    BNE.S   LAB_0F4B

LAB_0F45:
    MOVEQ   #-1,D4
    MOVEQ   #-1,D0
    MOVE.L  D0,-20(A5)
    BRA.S   LAB_0F4B

LAB_0F46:
    MOVE.B  LAB_1DD6,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BEQ.S   LAB_0F47

    TST.L   LAB_1B27
    BNE.S   LAB_0F4B

LAB_0F47:
    MOVEQ   #-1,D4
    MOVEQ   #-1,D0
    MOVE.L  D0,-20(A5)
    BRA.S   LAB_0F4B

LAB_0F48:
    TST.W   WDISP_HighlightActive
    BNE.S   LAB_0F4B

    MOVEQ   #-1,D4
    MOVEQ   #-1,D0
    MOVE.L  D0,-20(A5)
    BRA.S   LAB_0F4B

LAB_0F49:
    MOVEQ   #-1,D4
    MOVEQ   #-1,D0
    MOVE.L  D0,-20(A5)
    BRA.S   LAB_0F4B

LAB_0F4A:
    MOVEQ   #-1,D4
    MOVEQ   #-1,D0
    MOVE.L  D0,-20(A5)

LAB_0F4B:
    MOVE.L  D4,8(A2)
    MOVE.L  -20(A5),12(A2)

LAB_0F4C:
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_0F4D:
    LINK.W  A5,#-160
    MOVEM.L D4-D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEQ   #1,D5
    LEA     LAB_1FF3,A0
    LEA     -154(A5),A1
    MOVEQ   #5,D0

LAB_0F4E:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,LAB_0F4E
    PEA     MODE_NEWFILE.W
    PEA     LAB_1FF4
    JSR     JMP_TBL_DISKIO_OpenFileWithBuffer_1(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D4
    TST.L   D4
    BEQ.W   LAB_0F5B

    MOVE.L  A3,-4(A5)
    LEA     LAB_1FF5,A0
    LEA     -148(A5),A1
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.W  (A0),(A1)

LAB_0F4F:
    LEA     -148(A5),A0
    MOVEA.L A0,A1

LAB_0F50:
    TST.B   (A1)+
    BNE.S   LAB_0F50

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D4,-(A7)
    JSR     LAB_0F97(PC)

    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    MOVE.L  D0,(A7)
    MOVE.L  D4,-(A7)
    JSR     LAB_0F96(PC)

    MOVEA.L -4(A5),A0
    MOVE.L  2(A0),(A7)
    MOVE.L  D4,-(A7)
    JSR     LAB_0F96(PC)

    MOVEA.L -4(A5),A0
    MOVE.B  6(A0),D0
    MOVE.B  D0,-148(A5)
    CLR.B   -147(A5)
    LEA     -148(A5),A0
    MOVEA.L A0,A1

LAB_0F51:
    TST.B   (A1)+
    BNE.S   LAB_0F51

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D4,-(A7)
    JSR     LAB_0F97(PC)

    LEA     28(A7),A7
    MOVEQ   #0,D7

LAB_0F52:
    MOVEA.L -4(A5),A0
    CMP.L   2(A0),D7
    BGE.W   LAB_0F5A

    MOVE.L  D7,D0
    MOVEQ   #10,D1
    JSR     JMP_TBL_LAB_1A06_6(PC)

    MOVEA.L -4(A5),A1
    MOVEA.L 20(A1),A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  A0,-8(A5)
    JSR     LAB_0F96(PC)

    MOVEA.L -8(A5),A0
    MOVE.W  2(A0),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  D4,-(A7)
    JSR     LAB_0F96(PC)

    MOVEA.L -8(A5),A0
    MOVE.W  4(A0),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  D4,-(A7)
    JSR     LAB_0F96(PC)

    LEA     16(A7),A7
    MOVEQ   #0,D6

LAB_0F53:
    MOVEA.L -8(A5),A0
    MOVE.W  4(A0),D0
    EXT.L   D0
    CMP.L   D0,D6
    BGE.S   LAB_0F58

    MOVEA.L -8(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    CMPI.W  #5,D0
    BCC.S   LAB_0F56

    ADD.W   D0,D0
    MOVE.W  LAB_0F54(PC,D0.W),D0
    JMP     LAB_0F54+2(PC,D0.W)

; switch/jumptable
LAB_0F54:
    DC.W    LAB_0F54_0008-LAB_0F54-2
    DC.W    LAB_0F54_0008-LAB_0F54-2
    DC.W    LAB_0F54_0008-LAB_0F54-2
    DC.W    LAB_0F54_0008-LAB_0F54-2
    DC.W    LAB_0F54_0008-LAB_0F54-2

LAB_0F54_0008:
    LEA     -148(A5),A0
    ADDA.L  D6,A0
    MOVEA.L -8(A5),A6
    MOVEA.L 6(A6),A1
    ADDA.L  D6,A1
    MOVEQ   #0,D0
    MOVE.B  (A1),D0
    LEA     -154(A5),A1
    ADDA.W  D0,A1
    MOVE.B  (A1),(A0)
    BRA.S   LAB_0F57

LAB_0F56:
    LEA     -148(A5),A0
    ADDA.L  D6,A0
    MOVE.B  -154(A5),(A0)

LAB_0F57:
    ADDQ.L  #1,D6
    BRA.S   LAB_0F53

LAB_0F58:
    LEA     -148(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D6,A1
    CLR.B   (A1)
    MOVEA.L A0,A1

LAB_0F59:
    TST.B   (A1)+
    BNE.S   LAB_0F59

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D4,-(A7)
    JSR     LAB_0F97(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D7
    BRA.W   LAB_0F52

LAB_0F5A:
    MOVE.L  A2,-4(A5)
    SUBA.L  A2,A2
    LEA     LAB_1FF6,A0
    LEA     -148(A5),A1
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.W  (A0),(A1)
    TST.L   -4(A5)
    BNE.W   LAB_0F4F

    MOVE.L  D4,-(A7)
    JSR     LAB_0F98(PC)

    ADDQ.W  #4,A7
    BRA.S   LAB_0F5C

LAB_0F5B:
    MOVEQ   #0,D5

LAB_0F5C:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D4-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

LAB_0F5D:
    LINK.W  A5,#-52
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEQ   #1,D5
    CLR.L   -48(A5)
    MOVEQ   #0,D4
    PEA     LAB_1FF7
    JSR     LAB_0F9B(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.W   LAB_0F74

    MOVE.L  A3,-(A7)
    BSR.W   LAB_0F08

    MOVE.B  LAB_2230,(A3)
    MOVE.L  A2,(A7)
    BSR.W   LAB_0F08

    MOVE.B  LAB_222D,(A2)
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D4
    MOVE.L  LAB_21BC,-48(A5)
    JSR     LAB_0F94(PC)

    ADDQ.W  #4,A7
    MOVEA.W #$ffff,A0
    MOVE.L  D0,-44(A5)
    CMP.L   A0,D0
    BNE.S   LAB_0F5E

    CLR.L   -44(A5)

LAB_0F5E:
    TST.L   D5
    BEQ.W   LAB_0F73

    TST.L   -44(A5)
    BEQ.W   LAB_0F73

    PEA     6.W
    PEA     LAB_1FF8
    MOVE.L  -44(A5),-(A7)
    JSR     LAB_0F99(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.W   LAB_0F73

    PEA     -24(A5)
    BSR.W   LAB_0F07

    JSR     LAB_0F95(PC)

    MOVE.B  D0,-24(A5)
    JSR     LAB_0F95(PC)

    MOVE.L  D0,-22(A5)
    JSR     LAB_0F94(PC)

    MOVEA.L D0,A0
    MOVE.B  (A0),D1
    MOVE.B  D1,-18(A5)
    PEA     -24(A5)
    MOVE.L  D0,-44(A5)
    BSR.W   LAB_0F10

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.W   LAB_0F6D

    MOVEQ   #0,D7

LAB_0F5F:
    TST.L   D5
    BEQ.W   LAB_0F6E

    CMP.L   -22(A5),D7
    BGE.W   LAB_0F6E

    MOVE.L  D7,D0
    MOVEQ   #10,D1
    JSR     JMP_TBL_LAB_1A06_6(PC)

    MOVEA.L -4(A5),A0
    ADDA.L  D0,A0
    MOVE.L  A0,-28(A5)
    JSR     LAB_0F95(PC)

    MOVEA.L -28(A5),A0
    MOVE.B  D0,(A0)
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.W   LAB_0F6B

    MOVEQ   #100,D1
    CMP.B   D1,D0
    BCC.W   LAB_0F6B

    JSR     LAB_0F95(PC)

    MOVEA.L -28(A5),A0
    MOVE.W  D0,2(A0)
    TST.W   D0
    BLE.W   LAB_0F6A

    CMPI.W  #$e11,D0
    BGE.W   LAB_0F6A

    JSR     LAB_0F95(PC)

    MOVEA.L -28(A5),A0
    MOVE.W  D0,4(A0)
    TST.W   D0
    BLE.W   LAB_0F69

    MOVEQ   #100,D1
    CMP.W   D1,D0
    BGE.W   LAB_0F69

    EXT.L   D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     786.W
    PEA     GLOB_STR_LOCAVAIL_C_7
    JSR     GROUPC_JMP_TBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L -28(A5),A0
    MOVE.L  D0,6(A0)
    BEQ.W   LAB_0F68

    JSR     LAB_0F94(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-44(A5)
    CMP.L   A0,D0
    BEQ.W   LAB_0F67

    MOVEQ   #0,D6

LAB_0F60:
    TST.L   D5
    BEQ.W   LAB_0F6C

    MOVEA.L -28(A5),A0
    MOVE.W  4(A0),D0
    EXT.L   D0
    CMP.L   D0,D6
    BGE.W   LAB_0F6C

    MOVEA.L -44(A5),A0
    MOVE.B  (A0)+,D0
    EXT.W   D0
    MOVE.L  A0,-44(A5)
    SUBI.W  #$47,D0
    BEQ.S   LAB_0F61

    SUBQ.W  #2,D0
    BEQ.S   LAB_0F63

    SUBI.W  #11,D0
    BEQ.S   LAB_0F62

    SUBQ.W  #1,D0
    BEQ.S   LAB_0F64

    SUBQ.W  #1,D0
    BNE.S   LAB_0F65

    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  #$1,(A0)
    BRA.S   LAB_0F66

LAB_0F61:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  #$2,(A0)
    BRA.S   LAB_0F66

LAB_0F62:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  #$3,(A0)
    BRA.S   LAB_0F66

LAB_0F63:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  #$4,(A0)
    BRA.S   LAB_0F66

LAB_0F64:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    CLR.B   (A0)
    BRA.S   LAB_0F66

LAB_0F65:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    CLR.B   (A0)
    MOVEQ   #0,D5

LAB_0F66:
    ADDQ.L  #1,D6
    BRA.W   LAB_0F60

LAB_0F67:
    MOVEQ   #0,D5
    BRA.S   LAB_0F6C

LAB_0F68:
    MOVEQ   #0,D5
    BRA.S   LAB_0F6C

LAB_0F69:
    MOVEQ   #0,D5
    BRA.S   LAB_0F6C

LAB_0F6A:
    MOVEQ   #0,D5
    BRA.S   LAB_0F6C

LAB_0F6B:
    MOVEQ   #0,D5

LAB_0F6C:
    ADDQ.L  #1,D7
    BRA.W   LAB_0F5F

LAB_0F6D:
    TST.L   -22(A5)
    BEQ.S   LAB_0F6E

    MOVEQ   #0,D5

LAB_0F6E:
    TST.L   D5
    BEQ.S   LAB_0F71

    MOVE.B  -24(A5),D0
    MOVE.B  LAB_2230,D1
    CMP.B   D1,D0
    BNE.S   LAB_0F6F

    PEA     -24(A5)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0F0E

    ADDQ.W  #8,A7
    BRA.S   LAB_0F72

LAB_0F6F:
    MOVE.B  LAB_222D,D1
    CMP.B   D1,D0
    BNE.S   LAB_0F70

    PEA     -24(A5)
    MOVE.L  A2,-(A7)
    BSR.W   LAB_0F0E

    ADDQ.W  #8,A7
    BRA.S   LAB_0F72

LAB_0F70:
    PEA     -24(A5)
    BSR.W   LAB_0F08

    ADDQ.W  #4,A7
    BRA.S   LAB_0F72

LAB_0F71:
    PEA     -24(A5)
    BSR.W   LAB_0F08

    ADDQ.W  #4,A7

LAB_0F72:
    JSR     LAB_0F94(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-44(A5)
    CMP.L   A0,D0
    BNE.W   LAB_0F5E

    CLR.L   -44(A5)
    BRA.W   LAB_0F5E

LAB_0F73:
    MOVE.L  D4,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -48(A5),-(A7)
    PEA     897.W
    PEA     GLOB_STR_LOCAVAIL_C_8
    JSR     GROUPC_JMP_TBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    BRA.S   LAB_0F77

LAB_0F74:
    MOVE.B  LAB_2230,D0
    MOVE.B  (A3),D1
    CMP.B   D0,D1
    BEQ.S   LAB_0F75

    MOVE.L  A3,-(A7)
    BSR.W   LAB_0F08

    ADDQ.W  #4,A7
    MOVE.B  LAB_2230,(A3)

LAB_0F75:
    MOVE.B  LAB_222D,D0
    MOVE.B  (A2),D1
    CMP.B   D0,D1
    BEQ.S   LAB_0F76

    MOVE.L  A2,-(A7)
    BSR.W   LAB_0F08

    ADDQ.W  #4,A7
    MOVE.B  LAB_222D,(A2)

LAB_0F76:
    MOVEQ   #0,D5

LAB_0F77:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_0F78:
    MOVE.L  D7,-(A7)
    MOVEQ   #1,D0
    CMP.L   LAB_1FE6,D0
    BNE.S   LAB_0F7B

    MOVE.W  LAB_1FEA,D0
    BLE.S   LAB_0F79

    EXT.L   D0
    BRA.S   LAB_0F7A

LAB_0F79:
    MOVEQ   #30,D0

LAB_0F7A:
    MOVE.L  D0,D7
    BRA.S   LAB_0F7C

LAB_0F7B:
    MOVEQ   #30,D7

LAB_0F7C:
    ASR.W   #1,D7
    ADDQ.W  #1,D7
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_0F7D:
    LINK.W  A5,#-4
    MOVEM.L D2-D5/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    SUBA.L  A0,A0
    MOVE.L  A0,-4(A5)
    MOVEQ   #1,D0
    CMP.L   LAB_1FE6,D0
    BNE.W   LAB_0F90

    TST.L   LAB_1FE7
    BNE.W   LAB_0F84

    MOVEQ   #-1,D1
    CMP.L   LAB_1FE8,D1
    BNE.W   LAB_0F84

    MOVE.L  8(A2),D2
    CMP.L   D1,D2
    BEQ.W   LAB_0F90

    MOVE.L  12(A2),D3
    CMP.L   D1,D3
    BEQ.W   LAB_0F90

    TST.L   D2
    BMI.S   LAB_0F7E

    CMP.L   2(A2),D2
    BGE.S   LAB_0F7E

    MOVE.L  D2,D0
    MOVEQ   #10,D1
    JSR     JMP_TBL_LAB_1A06_6(PC)

    MOVEA.L 20(A2),A1
    ADDA.L  D0,A1
    MOVE.L  A1,-4(A5)

LAB_0F7E:
    TST.L   -4(A5)
    BEQ.W   LAB_0F90

    TST.L   D3
    BMI.W   LAB_0F90

    MOVEA.L -4(A5),A0
    MOVE.W  4(A0),D0
    EXT.L   D0
    CMP.L   D0,D3
    BGE.W   LAB_0F90

    MOVEA.L -4(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D3,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,LAB_1FE8
    MOVEQ   #1,D1
    MOVE.L  D1,LAB_1FE7
    MOVEQ   #-1,D1
    MOVE.L  D1,LAB_1FE9
    CMPI.L  #$5,D0
    BCC.W   LAB_0F83

    ADD.W   D0,D0
    MOVE.W  LAB_0F7F(PC,D0.W),D0
    JMP     LAB_0F7F+2(PC,D0.W)

; switch/jumptable
LAB_0F7F:
	DC.W    LAB_0F7F_0078-LAB_0F7F-2
    DC.W    LAB_0F7F_0008-LAB_0F7F-2
    DC.W    LAB_0F7F_0040-LAB_0F7F-2
	DC.W    LAB_0F7F_0062-LAB_0F7F-2
    DC.W    LAB_0F7F_0078-LAB_0F7F-2

LAB_0F7F_0008:
    MOVEQ   #0,D0
    MOVE.B  LAB_1DD7,D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1FFB
    JSR     GCOMMAND_JMP_TBL_LAB_1979(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_0F81

    JSR     LAB_0F9C(PC)

    TST.B   D0
    BEQ.S   LAB_0F81

    MOVEQ   #10,D0
    MOVE.L  D0,20(A3)
    BRA.W   LAB_0F90

LAB_0F81:
    MOVE.L  A2,-(A7)
    BSR.W   LAB_0F12

    ADDQ.W  #4,A7
    BRA.W   LAB_0F90

LAB_0F7F_0040:
    MOVE.B  LAB_1DD6,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BEQ.S   LAB_0F82

    TST.L   LAB_1B27
    BNE.W   LAB_0F90

LAB_0F82:
    MOVE.L  A2,-(A7)
    BSR.W   LAB_0F12

    ADDQ.W  #4,A7
    BRA.W   LAB_0F90

LAB_0F7F_0062:
    TST.W   WDISP_HighlightActive
    BNE.W   LAB_0F90

    MOVE.L  A2,-(A7)
    BSR.W   LAB_0F12

    ADDQ.W  #4,A7
    BRA.W   LAB_0F90

LAB_0F7F_0078:
LAB_0F83:
    MOVE.L  A2,-(A7)
    BSR.W   LAB_0F12

    ADDQ.W  #4,A7
    BRA.W   LAB_0F90

LAB_0F84:
    MOVEQ   #1,D0
    CMP.L   LAB_1FE7,D0
    BNE.W   LAB_0F89

    MOVEQ   #-1,D0
    CMP.L   LAB_1FE8,D0
    BEQ.W   LAB_0F89

    MOVE.L  8(A2),D1
    CMP.L   D0,D1
    BEQ.W   LAB_0F89

    MOVE.L  12(A2),D0
    MOVEQ   #-1,D2
    CMP.L   D2,D0
    BEQ.W   LAB_0F89

    TST.L   D1
    BMI.S   LAB_0F85

    CMP.L   2(A2),D1
    BGE.S   LAB_0F85

    MOVEQ   #10,D0
    JSR     JMP_TBL_LAB_1A06_6(PC)

    MOVEA.L 20(A2),A0
    ADDA.L  D0,A0
    MOVE.L  A0,-4(A5)

LAB_0F85:
    TST.L   -4(A5)
    BEQ.W   LAB_0F90

    MOVE.L  12(A2),D0
    TST.L   D0
    BMI.W   LAB_0F90

    MOVEA.L -4(A5),A0
    MOVE.W  4(A0),D1
    EXT.L   D1
    CMP.L   D1,D0
    BGE.W   LAB_0F90

    MOVE.L  20(A3),D0
    CMPI.L  #$10,D0
    BCC.W   LAB_0F90

    ADD.W   D0,D0
    MOVE.W  LAB_0F86(PC,D0.W),D0
    JMP     LAB_0F86+2(PC,D0.W)

; switch/jumptable
LAB_0F86:
	DC.W    LAB_0F86_012C-LAB_0F86-2
    DC.W    LAB_0F86_001E-LAB_0F86-2
	DC.W    LAB_0F86_001E-LAB_0F86-2
    DC.W    LAB_0F86_001E-LAB_0F86-2
	DC.W    LAB_0F86_0066-LAB_0F86-2
    DC.W    LAB_0F86_001E-LAB_0F86-2
	DC.W    LAB_0F86_001E-LAB_0F86-2
    DC.W    LAB_0F86_001E-LAB_0F86-2
    DC.W    LAB_0F86_001E-LAB_0F86-2
	DC.W    LAB_0F86_012C-LAB_0F86-2
    DC.W    LAB_0F86_012C-LAB_0F86-2
	DC.W    LAB_0F86_012C-LAB_0F86-2
    DC.W    LAB_0F86_012C-LAB_0F86-2
	DC.W    LAB_0F86_012C-LAB_0F86-2
    DC.W    LAB_0F86_012C-LAB_0F86-2
	DC.W    LAB_0F86_012C-LAB_0F86-2

LAB_0F86_001E:
    MOVEA.L -4(A5),A0
    MOVE.W  2(A0),D0
    MOVE.L  D0,D1
    SUBQ.W  #5,D1
    MOVE.W  D1,LAB_2325
    MOVE.W  2(A0),LAB_1FEA
    MOVEQ   #-1,D0
    MOVE.L  D0,8(A2)
    MOVE.L  D0,12(A2)
    MOVEQ   #2,D0
    MOVE.L  D0,LAB_1FE7
    MOVE.L  LAB_1FE8,D0
    MOVEQ   #2,D1
    CMP.L   D1,D0
    BEQ.S   LAB_0F88

    SUBQ.L  #3,D0
    BNE.W   LAB_0F90

LAB_0F88:
    MOVEQ   #4,D0
    MOVE.L  D0,20(A3)
    BRA.W   LAB_0F90

LAB_0F86_0066:
    CLR.L   20(A3)
    BRA.W   LAB_0F90

LAB_0F89:
    MOVE.L  LAB_1FE7,D0
    MOVEQ   #2,D1
    CMP.L   D1,D0
    BNE.S   LAB_0F8A

    MOVE.L  LAB_1FE8,D1
    MOVEQ   #-1,D2
    CMP.L   D2,D1
    BEQ.S   LAB_0F8A

    MOVE.L  8(A2),D3
    CMP.L   D2,D3
    BNE.S   LAB_0F8A

    MOVE.L  12(A2),D4
    CMP.L   D2,D4
    BNE.S   LAB_0F8A

    MOVEQ   #0,D5
    MOVE.L  D5,20(A3)
    BRA.W   LAB_0F90

LAB_0F8A:
    MOVEQ   #3,D1
    CMP.L   D1,D0
    BEQ.S   LAB_0F8B

    SUBQ.L  #4,D0
    BNE.S   LAB_0F8F

LAB_0F8B:
    MOVEQ   #-1,D0
    CMP.L   LAB_1FE8,D0
    BEQ.S   LAB_0F8F

    CMP.L   8(A2),D0
    BNE.S   LAB_0F8F

    CMP.L   12(A2),D0
    BNE.S   LAB_0F8F

    MOVE.L  20(A3),D0
    CMPI.L  #$10,D0
    BCC.S   LAB_0F90

    ADD.W   D0,D0
    MOVE.W  LAB_0F8C(PC,D0.W),D0
    JMP     LAB_0F8C+2(PC,D0.W)

; switch/jumptable
LAB_0F8C:
	DC.W    LAB_0F8C_0054-LAB_0F8C-2
    DC.W    LAB_0F8C_001E-LAB_0F8C-2
	DC.W    LAB_0F8C_001E-LAB_0F8C-2
    DC.W    LAB_0F8C_001E-LAB_0F8C-2
	DC.W    LAB_0F8C_0046-LAB_0F8C-2
    DC.W    LAB_0F8C_001E-LAB_0F8C-2
	DC.W    LAB_0F8C_001E-LAB_0F8C-2
    DC.W    LAB_0F8C_001E-LAB_0F8C-2
	DC.W    LAB_0F8C_001E-LAB_0F8C-2
    DC.W    LAB_0F8C_0054-LAB_0F8C-2
	DC.W    LAB_0F8C_0054-LAB_0F8C-2
    DC.W    LAB_0F8C_0054-LAB_0F8C-2
	DC.W    LAB_0F8C_0054-LAB_0F8C-2
    DC.W    LAB_0F8C_0054-LAB_0F8C-2
	DC.W    LAB_0F8C_0054-LAB_0F8C-2
    DC.W    LAB_0F8C_0054-LAB_0F8C-2

LAB_0F8C_001E:
    MOVEQ   #1,D0
    CMP.L   LAB_1FE8,D0
    BNE.S   LAB_0F8E

    MOVE.W  #3,24(A3)

LAB_0F8E:
    MOVEQ   #-1,D0
    MOVE.L  D0,LAB_1FE8
    CLR.L   LAB_1FE7
    MOVE.W  #(-1),LAB_1FEA
    BRA.S   LAB_0F90

LAB_0F8C_0046:
    CLR.L   20(A3)
    BRA.S   LAB_0F90

LAB_0F8F:
    MOVE.L  A2,-(A7)
    BSR.W   LAB_0F12

    ADDQ.W  #4,A7

LAB_0F86_012C:
LAB_0F8C_0054:
LAB_0F90:
    MOVEM.L (A7)+,D2-D5/A2-A3
    UNLK    A5
    RTS

;!======

LAB_0F91:
    MOVE.B  LAB_2324,D0
    MOVE.B  LAB_222D,D1
    CMP.B   D1,D0
    BEQ.S   LAB_0F92

    MOVE.B  LAB_2321,D0
    MOVE.B  LAB_2230,D1
    CMP.B   D1,D0
    BNE.S   LAB_0F92

    PEA     LAB_2324
    BSR.W   LAB_0F08

    PEA     LAB_2321
    PEA     LAB_2324
    BSR.W   LAB_0F0E

    LEA     12(A7),A7
    MOVE.B  LAB_222D,LAB_2324

LAB_0F92:
    RTS

;!======

LAB_0F93:
    PEA     LAB_2321
    BSR.W   LAB_0F08

    PEA     LAB_2324
    PEA     LAB_2321
    BSR.W   LAB_0F0E

    PEA     LAB_2324
    BSR.W   LAB_0F08

    LEA     16(A7),A7
    MOVE.B  LAB_2230,D0
    SUBQ.B  #1,D0
    MOVE.B  D0,LAB_2324
    PEA     LAB_2321
    BSR.W   LAB_0F12

    ADDQ.W  #4,A7
    RTS

;!======

LAB_0F94:
    JMP     LAB_03B2

LAB_0F95:
    JMP     LAB_03B6

LAB_0F96:
    JMP     LAB_03A9

LAB_0F97:
    JMP     LAB_03A0

LAB_0F98:
    JMP     LAB_039A

LAB_0F99:
    JMP     LAB_194E

JMP_TBL_LAB_1A06_5:
    JMP     LAB_1A06

LAB_0F9B:
    JMP     LAB_03AC

LAB_0F9C:
    JMP     SCRIPT_ReadCiaBBit5Mask

JMP_TBL_DISKIO_OpenFileWithBuffer_1:
    JMP     DISKIO_OpenFileWithBuffer

    RTS

;!======

    ; Alignment
    ALIGN_WORD
