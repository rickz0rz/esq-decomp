;!======

LAB_0B34:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

LAB_0B35:
    MOVE.W  LAB_1DDA,D0
    CMP.W   D0,D7
    BGE.S   LAB_0B37

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_224F,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-6(A5)
    MOVE.L  A1,D0
    BEQ.S   LAB_0B36

    MOVE.L  (A1),-(A7)
    CLR.L   -(A7)
    BSR.W   LAB_0B44

    MOVEA.L -6(A5),A0
    MOVE.L  D0,(A0)
    MOVE.L  4(A0),(A7)
    CLR.L   -(A7)
    BSR.W   LAB_0B44

    MOVEA.L -6(A5),A0
    MOVE.L  D0,4(A0)
    PEA     8.W
    MOVE.L  A0,-(A7)
    PEA     945.W
    PEA     GLOB_STR_ESQPARS_C_1
    JSR     GROUPB_JMP_TBL_MEMORY_DeallocateMemory(PC)

    LEA     28(A7),A7
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_224F,A0
    ADDA.L  D0,A0
    CLR.L   (A0)

LAB_0B36:
    ADDQ.W  #1,D7
    BRA.S   LAB_0B35

LAB_0B37:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

LAB_0B38:
    LINK.W  A5,#-16
    MOVEM.L D5-D7/A2,-(A7)
    MOVE.W  10(A5),D7
    JSR     LAB_0BF5(PC)

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0AC8

    ADDQ.W  #4,A7
    MOVEQ   #2,D0
    CMP.W   D0,D7
    BNE.S   LAB_0B39

    MOVE.W  LAB_222F,D0
    MOVE.L  D0,D5
    SUBQ.W  #1,D5
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_222F
    MOVEQ   #0,D1
    MOVE.B  D1,LAB_222E
    BRA.S   LAB_0B3A

LAB_0B39:
    MOVE.W  LAB_2231,D0
    MOVE.L  D0,D5
    SUBQ.W  #1,D5
    CLR.W   LAB_2231
    CLR.B   LAB_224A

LAB_0B3A:
    TST.W   D5
    BMI.W   LAB_0B43

    MOVEQ   #2,D0
    CMP.W   D0,D7
    BNE.S   LAB_0B3B

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2235,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  (A1),-4(A5)
    ADDA.L  D0,A0
    SUBA.L  A1,A1
    MOVE.L  A1,(A0)
    LEA     LAB_2237,A0
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVE.L  (A2),-8(A5)
    ADDA.L  D0,A0
    MOVE.L  A1,(A0)
    BRA.S   LAB_0B3C

LAB_0B3B:
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  (A1),-4(A5)
    ADDA.L  D0,A0
    SUBA.L  A1,A1
    MOVE.L  A1,(A0)
    LEA     LAB_2236,A0
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVE.L  (A2),-8(A5)
    ADDA.L  D0,A0
    MOVE.L  A1,(A0)

LAB_0B3C:
    MOVEQ   #0,D6

LAB_0B3D:
    TST.L   -8(A5)
    BEQ.S   LAB_0B40

    MOVEQ   #49,D0
    CMP.W   D0,D6
    BGE.S   LAB_0B40

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    MOVEA.L 56(A0,D0.L),A0
    MOVE.L  A0,-12(A5)
    MOVE.L  A0,D0
    BEQ.S   LAB_0B3F

LAB_0B3E:
    TST.B   (A0)+
    BNE.S   LAB_0B3E

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    PEA     1025.W
    PEA     GLOB_STR_ESQPARS_C_2
    JSR     GROUPB_JMP_TBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    CLR.L   56(A0,D0.L)

LAB_0B3F:
    ADDQ.W  #1,D6
    BRA.S   LAB_0B3D

LAB_0B40:
    TST.L   -8(A5)
    BEQ.S   LAB_0B41

    PEA     500.W
    MOVE.L  -8(A5),-(A7)
    PEA     1031.W
    PEA     GLOB_STR_ESQPARS_C_3
    JSR     GROUPB_JMP_TBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

LAB_0B41:
    MOVE.L  -4(A5),-(A7)
    JSR     LAB_0BFD(PC)

    ADDQ.W  #4,A7
    TST.L   -4(A5)
    BEQ.S   LAB_0B42

    PEA     52.W
    MOVE.L  -4(A5),-(A7)
    PEA     1040.W
    PEA     GLOB_STR_ESQPARS_C_4
    JSR     GROUPB_JMP_TBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

LAB_0B42:
    SUBQ.W  #1,D5
    BRA.W   LAB_0B3A

LAB_0B43:
    MOVEM.L (A7)+,D5-D7/A2
    UNLK    A5
    RTS

;!======

LAB_0B44:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEA.L 24(A7),A2

    MOVE.L  A2,D0
    BEQ.S   LAB_0B46

    MOVEA.L A2,A0

LAB_0B45:
    TST.B   (A0)+
    BNE.S   LAB_0B45

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,D0
    MOVE.L  D0,D7
    ADDQ.L  #1,D7
    MOVE.L  D7,-(A7)
    MOVE.L  A2,-(A7)
    PEA     1081.W
    PEA     GLOB_STR_ESQPARS_C_5
    JSR     GROUPB_JMP_TBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

LAB_0B46:
    MOVE.L  A3,D0
    BNE.S   LAB_0B47

    MOVEQ   #0,D0
    BRA.S   LAB_0B4D

LAB_0B47:
    MOVEA.L A3,A0

LAB_0B48:
    TST.B   (A0)+
    BNE.S   LAB_0B48

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D0
    MOVE.L  D0,D6
    ADDQ.L  #1,D6
    MOVEQ   #1,D0
    CMP.L   D0,D6
    BNE.S   LAB_0B49

    MOVEQ   #0,D0
    BRA.S   LAB_0B4D

LAB_0B49:
    SUBA.L  A2,A2
    MOVEQ   #1,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAvailMem(A6)

    CMPI.L  #$2710,D0
    BLE.S   LAB_0B4A

    PEA     (MEMF_PUBLIC).W
    MOVE.L  D6,-(A7)
    PEA     1100.W
    PEA     GLOB_STR_ESQPARS_C_6
    JSR     GROUPB_JMP_TBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A2

LAB_0B4A:
    MOVE.L  A2,D0
    BEQ.S   LAB_0B4C

    MOVEA.L A3,A0
    MOVEA.L A2,A1

LAB_0B4B:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_0B4B

LAB_0B4C:
    MOVE.L  A2,D0

LAB_0B4D:
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

LAB_0B4E:
    LINK.W  A5,#-24
    MOVEM.L D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.B  (A3),D0
    EXT.W   D0
    MOVE.W  D0,-24(A5)
    MOVE.B  1(A3),D0
    EXT.W   D0
    MOVE.W  D0,-22(A5)
    MOVE.B  2(A3),D0
    EXT.W   D0
    MOVE.W  D0,-20(A5)
    MOVE.B  3(A3),D0
    EXT.W   D0
    EXT.L   D0
    ADDI.L  #1900,D0
    MOVE.W  D0,-18(A5)
    MOVE.B  4(A3),D0
    EXT.W   D0
    MOVE.W  D0,-16(A5)
    MOVE.B  5(A3),D0
    EXT.W   D0
    MOVE.W  D0,-14(A5)
    MOVE.B  6(A3),D0
    EXT.W   D0
    MOVE.W  D0,-12(A5)
    MOVE.B  7(A3),D0
    EXT.W   D0
    MOVE.W  D0,-10(A5)
    PEA     -24(A5)
    JSR     LAB_0931(PC)

    MOVE.W  LAB_1F45,D7
    MOVE.W  #256,LAB_1F45
    JSR     LAB_0BF6(PC)

    MOVE.W  D7,LAB_1F45

    MOVEM.L -32(A5),D7/A3
    UNLK    A5
    RTS

;!======

; This whole sub-routine appears to be for processing control data
LAB_0B4F:
    LINK.W  A5,#-232
    MOVEM.L D2/D5-D7/A2,-(A7)

    JSR     LAB_0C03(PC)

    MOVE.W  LAB_229F,D1
    MOVE.B  D0,-5(A5)
    TST.W   D1
    BNE.S   .LAB_0B52

    MOVEQ   #$55,D1         ; Copy 0x55 ('U') into D1
    CMP.B   D1,D0           ; Compare that byte to D0
    BNE.S   .LAB_0B50       ; and jump to .LAB_0B50 if it's not equa.

    MOVEQ   #1,D1           ; Copy 1 into D1...
    MOVE.W  D1,LAB_229E     ; and then 0x0001 into LAB_229E
    MOVEQ   #0,D2           ; Copy 0 into D2...
    MOVE.W  D2,LAB_229F     ; and then 0x0000 into LAB_229F
    BRA.W   .LAB_0BE5       ; and branch to .LAB_0BE5

.LAB_0B50:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #$55,D2
    ADD.L   D2,D2
    CMP.L   D2,D1
    BNE.S   .LAB_0B51

    MOVE.W  LAB_229E,D1
    SUBQ.W  #1,D1
    BNE.S   .LAB_0B51

    MOVEQ   #0,D1
    MOVE.W  D1,LAB_229E
    MOVEQ   #1,D2
    MOVE.W  D2,LAB_229F
    BRA.W   .LAB_0BE5

.LAB_0B51:
    MOVEQ   #0,D1
    MOVE.W  D1,LAB_229E
    MOVE.W  D1,LAB_229F
    BRA.W   .LAB_0BE5

.LAB_0B52:
    SUBQ.W  #1,D1
    BNE.W   .cmdTableDATA

    MOVE.W  LAB_22A0,D1
    BNE.W   .cmdTableDATA

    MOVEQ   #65,D1
    CMP.B   D1,D0
    BNE.W   .LAB_0B55

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_0B0E

    MOVE.W  D0,LAB_2232
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_1(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0B54

    MOVE.W  LAB_2232,D0
    MOVEQ   #16,D1
    CMP.W   D1,D0
    BHI.S   .LAB_0B53

    MOVE.L  LAB_229A,-(A7)
    JSR     LAB_0C0A(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.W  D1,LAB_22A0
    SUBQ.W  #1,D1
    BNE.S   .clearValues

    MOVE.W  #1,LAB_22A1
    PEA     1.W
    PEA     2.W
    JSR     LAB_08DA(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_21BD
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    BRA.S   .clearValues

.LAB_0B53:
    MOVE.W  LAB_2287,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2287
    BRA.S   .clearValues

;!======

; Increment the number of DATACErrs encountered
.LAB_0B54:
    MOVE.W  DATACErrs,D0    ; Move DATACErrs to D0
    ADDQ.W  #1,D0           ; Add 1 to D0
    MOVE.W  D0,DATACErrs    ; Move D0 back to DATACErrs
    BRA.S   .clearValues    ; Clear the values

.LAB_0B55:
    MOVEQ   #87,D1
    CMP.B   D1,D0
    BNE.S   .LAB_0B56

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    JSR     LAB_0BFF(PC)

    ADDQ.W  #4,A7
    BRA.S   .clearValues

.LAB_0B56:
    MOVEQ   #119,D1         ; Copy 119 ('w') into D1
    CMP.B   D1,D0           ; Compare 'w' in D1 to D0
    BNE.S   .clearValues    ; If they're not equal, jump to clear values

    MOVEQ   #0,D1           ; Move 0 into D1 to clear out all the bits
    MOVE.B  D0,D1           ; Then move a byte from D0 into D1
    MOVE.L  D1,-(A7)        ; Push D1 to the stack
    JSR     LAB_0BED(PC)    ; Jump to LAB_0BED(PC)

    ADDQ.W  #4,A7           ; Add 4 to the stack (nuking the last value in it)

.clearValues:               ; Clear out LAB_229E and LAB_229F
    MOVEQ   #0,D0           ; Copy 0 into D0
    MOVE.W  D0,LAB_229E     ; Copy D0 (0) into LAB_229E
    MOVE.W  D0,LAB_229F     ; Copy D0 (0) into LAB_229F
    BRA.W   .LAB_0BE5

.cmdTableDATA:
    ; https://prevueguide.com/Documentation/D2400.pdf
    MOVE.W  LAB_229F,D0
    SUBQ.W  #1,D0
    BNE.W   .LAB_0BE5

    MOVE.W  LAB_22A0,D0
    SUBQ.W  #1,D0
    BNE.W   .LAB_0BE5

    MOVEQ   #0,D0       ; Move 0 into D0 to clear it out
    MOVE.B  -5(A5),D0   ; Copy the byte at -5(A5) which is the byte from serial to D0

    SUBI.W  #$21,D0   ; Subtract x21/33 from D0
    BEQ.W   .LAB_0B59   ; Does D0 equal zero (exactly)? Means D0 was 33 or '!'

    SUBQ.W  #4,D0       ; Subtract 4 more so x25/37
    BEQ.W   .LAB_0BB9   ; Does D0 equal zero now? This is mode '%'

    SUBI.W  #$18,D0   ; Subtract x18/24 so x3D/61
    BEQ.W   .cmdDATABinaryDL ; Does D0 equal zero now? This is mode '='

    SUBQ.W  #6,D0       ; Subtract x6/6 so 67
    BEQ.W   .LAB_0B99   ; Same as above... this time mode 'C'

    SUBQ.W  #1,D0       ; Subtract 1 so 68
    BEQ.W   .processCommand_D_Diagnostics   ; Mode 'D' (diagnostic command)

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0BA2   ; 'E'

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0BA6   ; 'F'

    SUBQ.W  #2,D0
    BEQ.W   .cmdDATABinaryDL ; 'H'

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0BB1 ; 'I'

    SUBQ.W  #2,D0
    BEQ.W   .processCommand_K_Clock ; 'K'

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0B91 ; 'L'

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0BC1 ; 'M'

    SUBQ.W  #2,D0
    BEQ.W   .LAB_0BC2 ; 'O'

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0B6B ; 'P'

    SUBQ.W  #2,D0
    BEQ.W   .processCommand_R_Reset ; 'R'

    SUBQ.W  #4,D0
    BEQ.W   .processCommand_V_Version ; 'V'

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0BC8 ; 'W'

    SUBI.W  #12,D0
    BEQ.W   .LAB_0B9C ; 'c'

    SUBQ.W  #3,D0
    BEQ.W   .LAB_0BD1 ; 'f'

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0BD5 ; 'g'

    SUBQ.W  #1,D0
    BEQ.W   .cmdDATABinaryDL ; 'h'

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0BB5 ; 'i'

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0BAD ; 'j'

    SUBQ.W  #6,D0
    BEQ.W   .LAB_0B6F ; 'p'

    SUBQ.W  #4,D0
    BEQ.W   .LAB_0B91 ; 't'

    SUBQ.W  #2,D0
    BEQ.W   .LAB_0B9F ; 'v'

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0BC9 ; 'w'

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0BCE ; 'x'

    SUBI.W  #$43,D0
    BEQ.W   .processCommand_xBB_BoxOff ; xBB (Box off)

    BRA.W   .LAB_0BE4

.LAB_0B59:
    CLR.B   -62(A5)
    MOVE.B  #$de,-71(A5)
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    PEA     -71(A5)
    PEA     1.W
    PEA     -61(A5)
    BSR.W   LAB_0B0B

    MOVEQ   #0,D0
    MOVE.B  -61(A5),D0
    PEA     -71(A5)
    PEA     1.W
    PEA     -61(A5)
    MOVE.L  D0,-14(A5)
    BSR.W   LAB_0B0B

    MOVE.B  -61(A5),-7(A5)
    PEA     -71(A5)
    PEA     1.W
    PEA     -61(A5)
    BSR.W   LAB_0B0B

    LEA     36(A7),A7
    MOVE.B  -61(A5),D0
    MOVE.B  D0,-8(A5)
    MOVE.B  -7(A5),D0
    MOVEQ   #1,D1
    CMP.B   D1,D0
    BCS.S   .LAB_0B5A

    MOVE.B  -8(A5),D1
    MOVEQ   #48,D2
    CMP.B   D2,D1
    BHI.S   .LAB_0B5A

    CMP.B   D0,D1
    BCS.S   .LAB_0B5A

    MOVEQ   #0,D0
    MOVE.B  LAB_2230,D0
    MOVE.L  -14(A5),D1
    CMP.L   D1,D0
    BEQ.S   .LAB_0B5B

    MOVEQ   #0,D0
    MOVE.B  LAB_222D,D0

    CMP.L   D0,D1
    BEQ.S   .LAB_0B5B

.LAB_0B5A:
    CLR.B   -62(A5)
    BRA.W   .LAB_0BE4

.LAB_0B5B:
    CLR.L   -22(A5)
    PEA     -71(A5)
    PEA     1.W
    PEA     -61(A5)
    BSR.W   LAB_0B0B

    LEA     12(A7),A7

.LAB_0B5C:
    TST.B   -61(A5)
    BEQ.S   .LAB_0B5D

    MOVE.B  -61(A5),D0
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_0B5D

    MOVEQ   #32,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_0B5D

    MOVE.L  -22(A5),D1
    MOVEQ   #6,D2
    CMP.L   D2,D1
    BGE.S   .LAB_0B5D

    ADDQ.L  #1,-22(A5)
    MOVE.B  D0,-41(A5,D1.L)
    PEA     -71(A5)
    PEA     1.W
    PEA     -61(A5)
    BSR.W   LAB_0B0B

    LEA     12(A7),A7
    BRA.S   .LAB_0B5C

.LAB_0B5D:
    MOVE.L  -22(A5),D0
    CLR.B   -41(A5,D0.L)

.LAB_0B5E:
    TST.B   -61(A5)
    BEQ.S   .LAB_0B5F

    PEA     -71(A5)
    PEA     1.W
    PEA     -61(A5)
    BSR.W   LAB_0B0B

    LEA     12(A7),A7
    BRA.S   .LAB_0B5E

.LAB_0B5F:
    PEA     1.W
    PEA     -31(A5)
    BSR.W   LAB_0B08

    ADDQ.W  #8,A7
    MOVE.B  -71(A5),D0
    MOVE.B  -31(A5),D1
    CMP.B   D1,D0
    BEQ.S   .LAB_0B60

    MOVEQ   #0,D0
    MOVE.B  D0,-62(A5)
    BRA.S   .LAB_0B61

.LAB_0B60:
    MOVEQ   #1,D0
    MOVE.B  D0,-62(A5)

.LAB_0B61:
    SUBQ.B  #1,D0
    BNE.W   .LAB_0BE4

    CLR.B   -62(A5)
    MOVEQ   #89,D0
    CMP.B   -7(A5),D0
    BNE.S   .LAB_0B62

    MOVEQ   #1,D0
    MOVE.B  #$30,-8(A5)
    MOVE.B  D0,-7(A5)

.LAB_0B62:
    MOVEQ   #0,D0
    MOVE.B  LAB_222D,D0
    MOVE.L  -14(A5),D1
    CMP.L   D1,D0
    BNE.S   .LAB_0B63

    MOVE.B  LAB_222E,D0
    SUBQ.B  #1,D0
    BNE.S   .LAB_0B63

    MOVEQ   #0,D0
    MOVE.W  LAB_222F,D0
    MOVEQ   #2,D2
    MOVE.L  D2,-30(A5)
    MOVE.L  D0,-18(A5)
    BRA.S   .LAB_0B64

.LAB_0B63:
    MOVEQ   #0,D0
    MOVE.B  LAB_2230,D0
    CMP.L   D0,D1
    BNE.W   .LAB_0BE4

    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    MOVEQ   #1,D1
    MOVE.L  D1,-30(A5)
    MOVE.L  D0,-18(A5)

.LAB_0B64:
    CLR.L   -26(A5)

.LAB_0B65:
    MOVE.L  -26(A5),D0
    CMP.L   -18(A5),D0
    BGE.S   .LAB_0B68

    MOVE.L  -30(A5),-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0923(PC)

    MOVE.L  -30(A5),(A7)
    MOVE.L  -26(A5),-(A7)
    MOVE.L  D0,-66(A5)
    JSR     LAB_0926(PC)

    LEA     12(A7),A7
    LEA     -41(A5),A0
    MOVEA.L D0,A1
    MOVE.L  D0,-70(A5)

.LAB_0B66:
    MOVE.B  (A0)+,D1
    CMP.B   (A1)+,D1
    BNE.S   .LAB_0B67

    TST.B   D1
    BNE.S   .LAB_0B66

    BNE.S   .LAB_0B67

    MOVE.B  #$1,-62(A5)
    BRA.S   .LAB_0B68

.LAB_0B67:
    ADDQ.L  #1,-26(A5)
    BRA.S   .LAB_0B65

.LAB_0B68:
    MOVEQ   #1,D0
    CMP.B   -62(A5),D0
    BNE.W   .LAB_0BE4

    MOVE.B  -7(A5),D0
    MOVEQ   #1,D1
    CMP.B   D1,D0
    BNE.S   .LAB_0B69

    MOVEQ   #48,D1
    CMP.B   -8(A5),D1
    BNE.S   .LAB_0B69

    MOVEQ   #0,D1
    MOVEA.L -66(A5),A0
    MOVE.B  40(A0),D1
    ANDI.W  #$ff7f,D1
    MOVE.B  D1,40(A0)

.LAB_0B69:
    MOVE.B  D0,-9(A5)

.LAB_0B6A:
    MOVE.B  -9(A5),D0
    CMP.B   -8(A5),D0
    BHI.W   .LAB_0BE4

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D2
    EXT.L   D2
    ASL.L   #2,D2
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -70(A5),A0
    MOVE.L  56(A0,D0.L),-(A7)
    CLR.L   -(A7)
    MOVE.L  D2,28(A7)
    BSR.W   LAB_0B44

    ADDQ.W  #8,A7
    MOVEA.L -70(A5),A0
    MOVE.L  20(A7),D1
    MOVE.L  D0,56(A0,D1.L)
    MOVEQ   #0,D0
    MOVE.B  -9(A5),D0
    MOVE.B  #$1,7(A0,D0.W)
    ADDQ.B  #1,-9(A5)
    BRA.S   .LAB_0B6A

.LAB_0B6B:
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    CLR.L   -(A7)
    PEA     2.W
    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_0B0E

    MOVE.W  D0,LAB_2232
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_1(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0B6D

    MOVE.W  LAB_2232,D0
    CMPI.W  #$1ff,D0
    BHI.S   .LAB_0B6C

    MOVE.L  LAB_229A,-(A7)
    JSR     LAB_0C07(PC)

    ADDQ.W  #4,A7
    BRA.S   .LAB_0B6E

.LAB_0B6C:
    MOVE.W  LAB_2287,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2287
    BRA.S   .LAB_0B6E

.LAB_0B6D:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0B6E:
    CLR.W   LAB_22A1
    BRA.W   .LAB_0BE4

.LAB_0B6F:
    CLR.B   -213(A5)
    MOVE.B  #$1,-224(A5)
    MOVE.B  #$8f,-227(A5)
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    PEA     -227(A5)
    PEA     1.W
    PEA     -62(A5)
    BSR.W   LAB_0B0B

    MOVEQ   #0,D0
    MOVE.B  -62(A5),D0
    PEA     -227(A5)
    PEA     1.W
    PEA     -62(A5)
    MOVE.L  D0,-10(A5)
    BSR.W   LAB_0B0B

    LEA     24(A7),A7
    CLR.L   -18(A5)

.LAB_0B70:
    MOVE.B  -62(A5),D0
    MOVE.L  -18(A5),D1
    MOVE.B  D0,-36(A5,D1.L)
    MOVEQ   #18,D2
    CMP.B   D2,D0
    BEQ.S   .LAB_0B71

    MOVEQ   #8,D0
    CMP.L   D0,D1
    BGE.S   .LAB_0B71

    PEA     -227(A5)
    PEA     1.W
    PEA     -62(A5)
    BSR.W   LAB_0B0B

    LEA     12(A7),A7
    ADDQ.L  #1,-18(A5)
    BRA.S   .LAB_0B70

.LAB_0B71:
    MOVE.L  -18(A5),D0
    CLR.B   -36(A5,D0.L)
    MOVEQ   #0,D0
    MOVE.B  LAB_222D,D0
    MOVE.L  -10(A5),D1
    CMP.L   D1,D0
    BNE.S   .LAB_0B72

    MOVE.B  LAB_222E,D0
    SUBQ.B  #1,D0
    BNE.S   .LAB_0B72

    MOVEQ   #0,D0
    MOVE.W  LAB_222F,D0
    MOVE.L  D0,-14(A5)
    BRA.S   .LAB_0B73

.LAB_0B72:
    MOVEQ   #0,D0
    MOVE.B  LAB_2230,D0
    CMP.L   D0,D1
    BNE.W   .LAB_0BE4

    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    MOVE.L  D0,-14(A5)

.LAB_0B73:
    PEA     -227(A5)
    PEA     6.W
    PEA     -62(A5)
    BSR.W   LAB_0B0B

    LEA     12(A7),A7
    CLR.L   -18(A5)

.LAB_0B74:
    MOVE.L  -18(A5),D0
    MOVEQ   #6,D1
    CMP.L   D1,D0
    BGE.S   .LAB_0B76

    TST.B   -62(A5,D0.L)
    BEQ.S   .LAB_0B75

    CLR.B   -224(A5)

.LAB_0B75:
    ADDQ.L  #1,-18(A5)
    BRA.S   .LAB_0B74

.LAB_0B76:
    PEA     -62(A5)
    PEA     -42(A5)
    JSR     GROUPB_JMP_TBL_ESQ_ReverseBitsIn6Bytes(PC)

    ADDQ.W  #8,A7
    CLR.L   -26(A5)

.LAB_0B77:
    MOVE.L  -26(A5),D0
    CMP.L   -14(A5),D0
    BGE.S   .LAB_0B7C

    MOVEQ   #0,D1
    MOVE.B  LAB_222D,D1
    MOVE.L  -10(A5),D2
    CMP.L   D1,D2
    BNE.S   .LAB_0B78

    MOVE.B  LAB_222E,D1
    SUBQ.B  #1,D1
    BNE.S   .LAB_0B78

    ASL.L   #2,D0
    LEA     LAB_2235,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-218(A5)
    LEA     LAB_2237,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-222(A5)
    BRA.S   .LAB_0B79

.LAB_0B78:
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-218(A5)
    LEA     LAB_2236,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-222(A5)

.LAB_0B79:
    LEA     -36(A5),A0
    MOVEA.L -222(A5),A1

.LAB_0B7A:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   .LAB_0B7B

    TST.B   D0
    BNE.S   .LAB_0B7A

    BNE.S   .LAB_0B7B

    MOVE.B  #$1,-213(A5)
    BRA.S   .LAB_0B7C

.LAB_0B7B:
    ADDQ.L  #1,-26(A5)
    BRA.S   .LAB_0B77

.LAB_0B7C:
    PEA     -227(A5)
    PEA     1.W
    PEA     -223(A5)
    BSR.W   LAB_0B0B

    LEA     12(A7),A7
    MOVE.B  -223(A5),D0
    MOVEQ   #1,D1
    CMP.B   D1,D0
    BCS.S   .LAB_0B7D

    MOVEQ   #3,D1
    CMP.B   D1,D0
    BLS.S   .LAB_0B7E

.LAB_0B7D:
    MOVEQ   #0,D1
    MOVE.B  D1,-213(A5)

.LAB_0B7E:
    TST.B   -224(A5)
    BEQ.W   .LAB_0B86

    TST.B   -213(A5)
    BEQ.W   .LAB_0B86

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    EXT.L   D1
    PEA     -227(A5)
    MOVE.L  D1,-(A7)
    PEA     -212(A5)
    BSR.W   LAB_0B0B

    PEA     -227(A5)
    PEA     1.W
    PEA     -226(A5)
    BSR.W   LAB_0B0B

    LEA     24(A7),A7
    MOVE.B  -226(A5),D0
    TST.B   D0
    BEQ.S   .LAB_0B7F

    CLR.B   -213(A5)

.LAB_0B7F:
    PEA     1.W
    PEA     -225(A5)
    BSR.W   LAB_0B08

    ADDQ.W  #8,A7
    MOVE.B  -227(A5),D0
    MOVE.B  -225(A5),D1
    CMP.B   D1,D0
    BEQ.S   .LAB_0B80

    MOVEQ   #0,D0
    MOVE.B  D0,-213(A5)

.LAB_0B80:
    TST.B   -213(A5)
    BEQ.W   .LAB_0B90

    MOVE.B  -223(A5),D0
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.S   .LAB_0B81

    MOVE.B  -212(A5),D0
    MOVEQ   #5,D1
    CMP.B   D1,D0
    BCS.S   .LAB_0B81

    MOVEQ   #10,D1
    CMP.B   D1,D0
    BHI.S   .LAB_0B81

    MOVEA.L -218(A5),A0
    BSET    #0,40(A0)

.LAB_0B81:
    CLR.L   -18(A5)

.LAB_0B82:
    MOVE.L  -18(A5),D0
    MOVEQ   #49,D1
    CMP.L   D1,D0
    BGE.W   .LAB_0B90

    MOVE.B  -223(A5),D1
    MOVEQ   #0,D2
    CMP.B   D2,D1
    BLS.S   .LAB_0B83

    MOVEA.L -222(A5),A0
    MOVE.L  D0,D2
    ADDI.L  #$fc,D2
    MOVE.B  -212(A5),0(A0,D2.L)

.LAB_0B83:
    MOVE.B  -223(A5),D1
    MOVEQ   #1,D2
    CMP.B   D2,D1
    BLS.S   .LAB_0B84

    MOVEA.L -222(A5),A0
    MOVE.L  D0,D2
    ADDI.L  #$12d,D2
    MOVE.B  -211(A5),0(A0,D2.L)

.LAB_0B84:
    MOVE.B  -223(A5),D1
    MOVEQ   #2,D2
    CMP.B   D2,D1
    BLS.S   .LAB_0B85

    MOVEA.L -222(A5),A0
    MOVE.L  D0,D0
    ADDI.L  #$15e,D0
    MOVE.B  -210(A5),0(A0,D0.L)

.LAB_0B85:
    ADDQ.L  #1,-18(A5)
    BRA.S   .LAB_0B82

.LAB_0B86:
    TST.B   -213(A5)
    BEQ.W   .LAB_0B90

    CLR.L   -26(A5)
    MOVEQ   #1,D0
    MOVE.L  D0,-18(A5)

.LAB_0B87:
    MOVE.L  -18(A5),D0
    MOVEQ   #49,D1
    CMP.L   D1,D0
    BGE.S   .LAB_0B89

    MOVE.L  D0,-(A7)
    PEA     -42(A5)
    JSR     GROUPB_JMP_TBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-22(A5)
    ADDQ.L  #1,D0
    BNE.S   .LAB_0B88

    ADDQ.L  #1,-26(A5)

.LAB_0B88:
    ADDQ.L  #1,-18(A5)
    BRA.S   .LAB_0B87

.LAB_0B89:
    MOVEQ   #0,D0
    MOVE.B  -223(A5),D0
    MOVE.L  -26(A5),D1
    JSR     GROUPB_JMP_TBL_LAB_1A06(PC)

    EXT.L   D0
    PEA     -227(A5)
    MOVE.L  D0,-(A7)
    PEA     -212(A5)
    BSR.W   LAB_0B0B

    PEA     -227(A5)
    PEA     1.W
    PEA     -226(A5)
    BSR.W   LAB_0B0B

    LEA     24(A7),A7
    MOVE.B  -226(A5),D0
    TST.B   D0
    BEQ.S   .LAB_0B8A

    CLR.B   -213(A5)

.LAB_0B8A:
    PEA     1.W
    PEA     -225(A5)
    BSR.W   LAB_0B08

    ADDQ.W  #8,A7
    MOVE.B  -227(A5),D0
    MOVE.B  -225(A5),D1
    CMP.B   D1,D0
    BEQ.S   .LAB_0B8B

    MOVEQ   #0,D0
    MOVE.B  D0,-213(A5)

.LAB_0B8B:
    TST.B   -213(A5)
    BEQ.W   .LAB_0B90

    CLR.L   -26(A5)
    MOVEQ   #1,D0
    MOVE.L  D0,-18(A5)

.LAB_0B8C:
    MOVE.L  -18(A5),D0
    MOVEQ   #49,D1
    CMP.L   D1,D0
    BGE.W   .LAB_0B90

    MOVE.L  D0,-(A7)
    PEA     -42(A5)
    JSR     GROUPB_JMP_TBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-22(A5)
    ADDQ.L  #1,D0
    BNE.W   .LAB_0B8F

    MOVE.B  -223(A5),D0
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.S   .LAB_0B8D

    LEA     -212(A5),A0
    MOVE.L  -26(A5),D1
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVEA.L -222(A5),A2
    MOVE.L  -18(A5),D2
    ADDI.L  #$fc,D2
    MOVE.B  (A1),0(A2,D2.L)
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    CMPI.B  #$5,(A1)
    BCS.S   .LAB_0B8D

    MOVEA.L A0,A1
    ADDA.L  D1,A1
    CMPI.B  #$a,(A1)
    BHI.S   .LAB_0B8D

    MOVEA.L -218(A5),A1
    BSET    #0,40(A1)

.LAB_0B8D:
    ADDQ.L  #1,-26(A5)
    MOVE.B  -223(A5),D0
    MOVEQ   #1,D1
    CMP.B   D1,D0
    BLS.S   .LAB_0B8E

    LEA     -212(A5),A0
    MOVEA.L A0,A1
    ADDA.L  -26(A5),A1
    ADDQ.L  #1,-26(A5)
    MOVEA.L -222(A5),A2
    MOVE.L  -18(A5),D1
    ADDI.L  #301,D1
    MOVE.B  (A1),0(A2,D1.L)

.LAB_0B8E:
    MOVE.B  -223(A5),D0
    MOVEQ   #2,D1
    CMP.B   D1,D0
    BLS.S   .LAB_0B8F

    LEA     -212(A5),A0
    ADDA.L  -26(A5),A0
    ADDQ.L  #1,-26(A5)
    MOVEA.L -222(A5),A1
    MOVE.L  -18(A5),D0
    ADDI.L  #$15e,D0
    MOVE.B  (A0),0(A1,D0.L)

.LAB_0B8F:
    ADDQ.L  #1,-18(A5)
    BRA.W   .LAB_0B8C

.LAB_0B90:
    CLR.W   LAB_22A1
    BRA.W   .LAB_0BE4

.LAB_0B91:
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_0B0E

    MOVE.W  D0,LAB_2232
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_1(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0B93

    MOVE.W  LAB_2232,D0
    CMPI.W  #$130,D0
    BHI.S   .LAB_0B92

    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0E33(PC)

    ADDQ.W  #8,A7
    BRA.S   .LAB_0B94

.LAB_0B92:
    MOVE.W  LAB_2287,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2287
    BRA.S   .LAB_0B94

.LAB_0B93:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0B94:
    CLR.W   LAB_22A1
    BRA.W   .LAB_0BE4

.processCommand_xBB_BoxOff:
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    JSR     LAB_096D(PC)

    JSR     LAB_0C03(PC)

    MOVE.B  D0,-5(A5)
    JSR     LAB_096D(PC)

    JSR     LAB_0C03(PC)

    JSR     LAB_096D(PC)

    JSR     LAB_0C03(PC)

    MOVE.B  D0,LAB_2253
    MOVEQ   #0,D1
    MOVE.B  -5(A5),D1
    MOVEQ   #68,D2
    NOT.B   D2
    CMP.L   D2,D1
    BNE.S   .LAB_0B97

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #0,D0
    NOT.B   D0
    CMP.L   D0,D1
    BNE.S   .LAB_0B97

    TST.W   LAB_1DF6
    BEQ.S   .LAB_0B96

    BSR.W   LAB_0BE9

    MOVEQ   #0,D0
    MOVE.W  D0,LAB_1DF6

.LAB_0B96:
    CLR.W   LAB_22A0
    CLR.L   -(A7)
    PEA     2.W
    JSR     LAB_08DA(PC)

    ADDQ.W  #8,A7
    BRA.S   .LAB_0B98

.LAB_0B97:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0B98:
    CLR.W   LAB_22A1
    BRA.W   .LAB_0BE4

.LAB_0B99:
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    PEA     6.W
    PEA     1.W
    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_0B0E

    LEA     12(A7),A7
    MOVE.W  D0,LAB_2232
    TST.W   D0
    BEQ.W   .LAB_0BE4

    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,-(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_1(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0B9A

    MOVE.W  LAB_2299,D0
    SUBQ.W  #1,D0
    BNE.S   .LAB_0B9B

    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_0AD8

    ADDQ.W  #4,A7
    BRA.S   .LAB_0B9B

.LAB_0B9A:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0B9B:
    CLR.W   LAB_22A1
    BRA.W   .LAB_0BE4

.LAB_0B9C:
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    CLR.L   -(A7)
    PEA     1.W
    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_0B0E

    LEA     12(A7),A7
    MOVE.W  D0,LAB_2232
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .LAB_0B9D

    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,-(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_1(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0B9D

    MOVE.L  LAB_229A,-(A7)
    JSR     LAB_08E4(PC)

    ADDQ.W  #4,A7
    BRA.S   .LAB_0B9E

.LAB_0B9D:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0B9E:
    CLR.W   LAB_22A1
    BRA.W   .LAB_0BE4

.LAB_0B9F:
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    CLR.L   -(A7)
    PEA     1.W
    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_0B0E

    LEA     12(A7),A7
    MOVE.W  D0,LAB_2232
    TST.W   D0
    BEQ.W   .LAB_0BE4

    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,-(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_1(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BA0

    MOVEA.L LAB_229A,A0
    MOVE.B  1(A0),D0
    MOVEQ   #49,D1
    CMP.B   D1,D0
    BNE.S   .LAB_0BA1

    MOVE.L  A0,-(A7)
    JSR     LAB_0C02(PC)

    ADDQ.W  #4,A7
    BRA.S   .LAB_0BA1

.LAB_0BA0:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BA1:
    CLR.W   LAB_22A1
    BRA.W   .LAB_0BE4

.LAB_0BA2:
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_0B0E

    MOVE.W  D0,LAB_2232
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_1(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BA4

    MOVEA.L LAB_229A,A0
    LEA     LAB_2298,A1

.LAB_0BA3:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_0BA3

    BRA.S   .LAB_0BA5

.LAB_0BA4:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BA5:
    CLR.W   LAB_22A1
    BRA.W   .LAB_0BE4

    if includeCustomAriAssembly

.LAB_0BA5_2:
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    JSR     ESQ_PollCtrlInput

    MOVEQ   #0,D0
    LEA     76(A7),A7
    MOVE.W  SCRIPT_CTRL_STATE,D4
    MOVEQ   #0,D0
    MOVE.W  CTRL_H,D0
    MOVEQ   #0,D3
    MOVE.W  SCRIPT_CTRL_CHECKSUM,D3
    MOVEQ   #0,D1
    MOVE.W  SCRIPT_CTRL_READ_INDEX,D1
    MOVEQ   #0,D2
    LEA     CTRL_BUFFER,A3
    ADDA    D0,A3
    SUBA    #1,A3
    MOVEQ   #0,D2
    MOVE.B (A3),D2
    MOVE.L  D2,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_CTRLHTCMAX
    PEA     -72(A5)
    JSR     GROUPB_JMP_TBL_WDISP_SPrintf(PC)
    PEA     -72(A5)
    PEA     262.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    CLR.W   LAB_22A1
    BRA.W   .LAB_0BE4
    endif

.LAB_0BA6:
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    PEA     21.W
    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_0B08

    JSR     LAB_096D(PC)

    JSR     LAB_0C03(PC)

    MOVE.B  D0,LAB_2253
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    PEA     20.W
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_1(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BA8

    MOVEA.L LAB_229A,A0
    MOVE.B  (A0),D0
    MOVEQ   #65,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_0BA7

    MOVEQ   #66,D2
    CMP.B   D2,D0
    BNE.S   .LAB_0BA8

.LAB_0BA7:
    MOVE.B  1(A0),D0
    CMP.B   D1,D0
    BCS.S   .LAB_0BA8

    MOVEQ   #74,D1
    CMP.B   D1,D0
    BCC.S   .LAB_0BA8

    MOVE.L  A0,-(A7)
    BSR.W   LAB_0AB8

    ADDQ.W  #4,A7
    BRA.S   .LAB_0BA9

.LAB_0BA8:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BA9:
    CLR.W   LAB_22A1
    BRA.W   .LAB_0BE4

.processCommand_K_Clock:
    MOVE.W  LAB_226A,D0
    SUBQ.W  #1,D0
    BEQ.W   .LAB_0BE4

    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    PEA     8.W
    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_0B08

    JSR     LAB_096D(PC)

    JSR     LAB_0C03(PC)

    JSR     LAB_096D(PC)

    JSR     LAB_0C03(PC)

    MOVE.B  D0,LAB_2253
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    PEA     8.W
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_1(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .command_K_Increment_Data_CErrs

    ; At this point A0 is a pointer to a struct or array that
    ; matches the data received from the request.
    ; See: https://prevueguide.com/Documentation/D2400.pdf
    ; (Byte 4 and onward)

    ; Small sanity checks: check day (not over 7)
    MOVEA.L LAB_229A,A0 ; Pointer to all the data received.
    MOVE.B  (A0),D0     ; Byte 0: Day
    MOVEQ   #7,D1
    CMP.B   D1,D0
    BCC.S   .command_K_Increment_Data_CErrs

    ; Small sanity checks: check month (not over 12)
    MOVE.B  1(A0),D0    ; Byte 1: Month
    MOVEQ   #12,D1
    CMP.B   D1,D0
    BCC.S   .command_K_Increment_Data_CErrs

    MOVE.B  6(A0),D0    ; Byte 6: Second
    MOVEQ   #60,D1
    CMP.B   D1,D0
    BCC.S   .command_K_Increment_Data_CErrs

    MOVE.B  LAB_1BC9,D0
    MOVEQ   #50,D1
    CMP.B   D1,D0
    BNE.S   .command_K_Increment_Data_CErrs

    MOVE.L  A0,-(A7)    ; Push the address of the data to the stack
    BSR.W   LAB_0B4E

    ADDQ.W  #4,A7
    BRA.S   .LAB_0BAC

.command_K_Increment_Data_CErrs:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BAC:
    CLR.W   LAB_22A1
    BRA.W   .LAB_0BE4

.LAB_0BAD:
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    CLR.L   -(A7)
    PEA     2.W
    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_0B0E

    MOVE.W  D0,LAB_2232
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_1(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BAF

    MOVE.W  LAB_2232,D0
    CMPI.W  #$1f4,D0
    BHI.S   .LAB_0BAE

    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_0ACB

    ADDQ.W  #4,A7
    BRA.S   .LAB_0BB0

.LAB_0BAE:
    MOVE.W  LAB_2287,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2287
    BRA.S   .LAB_0BB0

.LAB_0BAF:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BB0:
    CLR.W   LAB_22A1
    BRA.W   .LAB_0BE4

.LAB_0BB1:
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_0B0E

    MOVE.W  D0,LAB_2232
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_1(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BB3

    MOVE.W  LAB_2232,D0
    MOVEQ   #39,D1
    CMP.W   D1,D0
    BHI.S   .LAB_0BB2

    MOVE.L  LAB_229A,-(A7)
    JSR     LAB_0C00(PC)

    ADDQ.W  #4,A7
    BRA.S   .LAB_0BB4

.LAB_0BB2:
    MOVE.W  LAB_2287,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2287
    BRA.S   .LAB_0BB4

.LAB_0BB3:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BB4:
    CLR.W   LAB_22A1
    BRA.W   .LAB_0BE4

.LAB_0BB5:
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_0B0E

    MOVE.W  D0,LAB_2232
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_1(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BB7

    MOVE.W  LAB_2232,D0
    MOVEQ   #39,D1
    CMP.W   D1,D0
    BHI.S   .LAB_0BB6

    MOVE.L  LAB_229A,-(A7)
    JSR     LAB_0BEF(PC)

    ADDQ.W  #4,A7
    BRA.S   .LAB_0BB8

.LAB_0BB6:
    MOVE.W  LAB_2287,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2287
    BRA.S   .LAB_0BB8

.LAB_0BB7:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BB8:
    CLR.W   LAB_22A1
    BRA.W   .LAB_0BE4

.LAB_0BB9:
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    JSR     LAB_096D(PC)

    JSR     LAB_0C03(PC)

    JSR     LAB_096D(PC)

    JSR     LAB_0C03(PC)

    MOVE.B  D0,LAB_2253
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #109,D0
    ADD.L   D0,D0
    CMP.L   D0,D1
    BNE.S   .LAB_0BBA

    MOVEQ   #1,D0
    MOVE.W  D0,LAB_1DF6
    BRA.S   .LAB_0BBB

.LAB_0BBA:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BBB:
    CLR.W   LAB_22A1
    BRA.W   .LAB_0BE4

.processCommand_R_Reset:
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    JSR     LAB_096D(PC)

    JSR     LAB_0C03(PC)

    JSR     LAB_096D(PC)

    JSR     LAB_0C03(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #82,D0
    NOT.B   D0
    CMP.L   D0,D1
    BNE.S   .LAB_0BBF

    MOVE.W  LAB_22A1,D0
    SUBQ.W  #1,D0
    BNE.S   .LAB_0BC0

    MOVE.W  #21000,LAB_2363
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)

.LAB_0BBD:
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    MOVEQ   #34,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .LAB_0BBE

    ADDQ.L  #1,D1

.LAB_0BBE:
    ASR.L   #1,D1
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D1
    MOVEQ   #29,D0
    ADD.L   D0,D1
    PEA     GLOB_STR_RESET_COMMAND_RECEIVED
    MOVE.L  D1,-(A7)
    PEA     40.W
    MOVE.L  A1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_3(PC)

    LEA     16(A7),A7
    BRA.S   .LAB_0BBD

.LAB_0BBF:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BC0:
    CLR.W   LAB_22A1
    BRA.W   .LAB_0BE4

.LAB_0BC1:
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    CLR.W   LAB_22A1
    BRA.W   .LAB_0BE4

.LAB_0BC2:
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    JSR     LAB_096D(PC)

    JSR     LAB_0C03(PC)

    JSR     LAB_096D(PC)

    JSR     LAB_0C03(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #88,D0
    ADD.L   D0,D0
    CMP.L   D0,D1
    BNE.S   .LAB_0BC3

    BSR.W   LAB_0B2F

    BRA.S   .LAB_0BC4

.LAB_0BC3:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BC4:
    CLR.W   LAB_22A1
    BRA.W   .LAB_0BE4

.cmdDATABinaryDL:
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_22A1
    MOVE.L  D0,D5
    MOVEQ   #1,D0
    CMP.L   LAB_21BD,D0
    BNE.W   .LAB_0BE4

    MOVEQ   #61,D1
    CMP.B   -5(A5),D1
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    JSR     LAB_0BFB(PC)

    ADDQ.W  #4,A7
    BRA.W   .LAB_0BE4

.processCommand_D_Diagnostics:
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    PEA     256.W
    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_0B08

    JSR     LAB_096D(PC)

    JSR     LAB_0C03(PC)

    MOVE.B  D0,LAB_2253
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    PEA     256.W
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_1(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BEQ.S   .LAB_0BC7

    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BC7:
    CLR.W   LAB_22A1
    BRA.W   .LAB_0BE4

.LAB_0BC8:
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0BFF(PC)

    ADDQ.W  #4,A7
    BRA.W   .LAB_0BE4

.LAB_0BC9:
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0BED(PC)

    ADDQ.W  #4,A7
    BRA.W   .LAB_0BE4

.processCommand_V_Version:
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_0B0E

    MOVE.W  D0,LAB_2232
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_1(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BCC

    MOVE.W  LAB_2232,D0
    CMPI.W  #$8b,D0
    BHI.S   .LAB_0BCB

    BSR.W   LAB_0B22

    BRA.S   .LAB_0BCD

.LAB_0BCB:
    MOVE.W  LAB_2287,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2287
    BRA.S   .LAB_0BCD

.LAB_0BCC:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BCD:
    CLR.W   LAB_22A1
    BRA.W   .LAB_0BE4

.LAB_0BCE:
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_0B0E

    MOVE.W  D0,LAB_2232
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_1(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BCF

    MOVE.W  LAB_2232,D0
    MOVEQ   #80,D1
    CMP.W   D1,D0
    BHI.S   .LAB_0BCF

    MOVE.L  LAB_229A,-(A7)
    JSR     LAB_0BF2(PC)

    ADDQ.W  #4,A7
    BRA.S   .LAB_0BD0

.LAB_0BCF:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BD0:
    CLR.W   LAB_22A1
    BRA.W   .LAB_0BE4

.LAB_0BD1:
    JSR     LAB_096D(PC)

    JSR     LAB_0C03(PC)

    MOVE.L  D0,D6
    MOVE.B  -5(A5),D0
    MOVE.B  D0,-6(A5)
    EOR.B   D6,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    MOVE.B  D0,-6(A5)
    BSR.W   LAB_0BE6

    ADDQ.W  #4,A7
    MOVE.W  LAB_2232,D1
    MOVE.B  D0,-6(A5)
    CMPI.W  #$2328,D1
    BCS.S   .LAB_0BD2

    MOVE.W  LAB_2287,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2287
    BRA.W   .LAB_0BE4

.LAB_0BD2:
    MOVE.W  LAB_2232,D0
    MOVE.L  D0,D1
    SUBQ.W  #1,D1
    MOVE.W  D1,LAB_2232
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_0B08

    JSR     LAB_096D(PC)

    JSR     LAB_0C03(PC)

    MOVE.B  D0,LAB_2253
    MOVEQ   #0,D0
    MOVE.B  -6(A5),D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_1(PC)

    LEA     16(A7),A7
    MOVE.L  D0,D7
    MOVE.B  LAB_2253,D0
    CMP.B   D0,D7
    BNE.S   .LAB_0BD3

    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    MOVEQ   #0,D0
    MOVE.W  LAB_2232,D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_229A,-(A7)
    JSR     LAB_0C01(PC)

    JSR     LAB_0C06(PC)

    ADDQ.W  #8,A7
    BRA.S   .LAB_0BD4

.LAB_0BD3:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BD4:
    CLR.W   LAB_22A1
    BRA.W   .LAB_0BE4

.LAB_0BD5:
    JSR     LAB_096D(PC)

    JSR     LAB_0C03(PC)

    MOVE.L  D0,D6
    MOVE.B  -5(A5),D0
    MOVE.B  D0,-6(A5)
    EOR.B   D6,D0
    MOVE.B  D0,-6(A5)
    MOVEQ   #49,D0
    CMP.B   D0,D6
    BNE.W   .LAB_0BD9

    JSR     LAB_096D(PC)

    JSR     LAB_0C03(PC)

    MOVEA.L LAB_229A,A0
    MOVE.B  D0,(A0)
    LEA     1(A0),A1
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    BSR.W   LAB_0B0E

    LEA     12(A7),A7
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2232
    MOVEQ   #0,D1
    MOVE.B  -6(A5),D1
    MOVEQ   #0,D2
    MOVE.W  D0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D1,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_1(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BD8

    MOVEA.L LAB_229A,A0
    MOVE.B  (A0),D0
    MOVE.B  LAB_2230,D1
    CMP.B   D1,D0
    BNE.S   .LAB_0BD6

    PEA     LAB_2321
    MOVE.L  A0,-(A7)
    JSR     LAB_0F16(PC)

    ADDQ.W  #8,A7
    BRA.S   .LAB_0BD7

.LAB_0BD6:
    MOVE.B  LAB_222D,D1
    CMP.B   D1,D0
    BNE.S   .LAB_0BD7

    PEA     LAB_2324
    MOVE.L  A0,-(A7)
    JSR     LAB_0F16(PC)

    ADDQ.W  #8,A7

.LAB_0BD7:
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    BRA.W   .LAB_0BE4

.LAB_0BD8:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs
    BRA.W   .LAB_0BE4

.LAB_0BD9:
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_23
    JSR     GCOMMAND_JMP_TBL_LAB_1979(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.W   .LAB_0BDC

    PEA     2.W
    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_0B17

    ADDQ.W  #8,A7
    MOVE.W  D0,LAB_2232
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .LAB_0BDB

    MOVEQ   #0,D1
    MOVE.B  -6(A5),D1
    MOVEQ   #0,D2
    MOVE.W  D0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D1,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_1(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BDA

    MOVE.L  D6,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_0BF0(PC)

    ADDQ.W  #8,A7
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    BRA.W   .LAB_0BE4

.LAB_0BDA:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs
    BRA.W   .LAB_0BE4

.LAB_0BDB:
    MOVE.W  LAB_2287,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2287
    BRA.W   .LAB_0BE4

.LAB_0BDC:
    MOVEQ   #53,D0
    CMP.B   D0,D6
    BNE.S   .LAB_0BDE

    JSR     LAB_096D(PC)

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_0B0E

    MOVE.W  D0,LAB_2232
    MOVEQ   #0,D0
    MOVE.B  -6(A5),D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_1(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BDD

    MOVE.L  LAB_229A,-(A7)
    JSR     LAB_0BEE(PC)

    ADDQ.W  #4,A7
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    BRA.W   .LAB_0BE4

.LAB_0BDD:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs
    BRA.W   .LAB_0BE4

.LAB_0BDE:
    MOVEQ   #54,D0
    CMP.B   D0,D6
    BNE.S   .LAB_0BE0

    JSR     LAB_096D(PC)

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_0B0E

    MOVE.W  D0,LAB_2232
    MOVEQ   #0,D0
    MOVE.B  -6(A5),D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_1(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BDF

    MOVE.L  LAB_229A,-(A7)
    JSR     GCOMMAND_ParseCommandOptions(PC)

    ADDQ.W  #4,A7
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    BRA.W   .LAB_0BE4

.LAB_0BDF:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs
    BRA.W   .LAB_0BE4

.LAB_0BE0:
    MOVEQ   #55,D0
    CMP.B   D0,D6
    BNE.S   .LAB_0BE2

    JSR     LAB_096D(PC)

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_0B0E

    MOVE.W  D0,LAB_2232
    MOVEQ   #0,D0
    MOVE.B  -6(A5),D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_1(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BE1

    MOVE.L  LAB_229A,-(A7)
    JSR     GCOMMAND_ParseCommandString(PC)

    ADDQ.W  #4,A7
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    BRA.W   .LAB_0BE4

.LAB_0BE1:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs
    BRA.S   .LAB_0BE4

.LAB_0BE2:
    MOVEQ   #56,D0
    CMP.B   D0,D6
    BNE.S   .LAB_0BE4

    JSR     LAB_096D(PC)

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_0B0E

    MOVE.W  D0,LAB_2232
    MOVEQ   #0,D0
    MOVE.B  -6(A5),D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_1(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BE3

    MOVE.L  LAB_229A,-(A7)
    JSR     GCOMMAND_ParsePPVCommand(PC)

    ADDQ.W  #4,A7
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    BRA.S   .LAB_0BE4

.LAB_0BE3:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BE4:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_229E
    MOVE.W  D0,LAB_229F

.LAB_0BE5:
    MOVEM.L (A7)+,D2/D5-D7/A2
    UNLK    A5
    RTS

;!======

LAB_0BE6:
    MOVEM.L D5-D7,-(A7)
    MOVE.B  19(A7),D7
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_2232
    MOVE.L  D0,D5

LAB_0BE7:
    MOVEQ   #2,D0
    CMP.W   D0,D5
    BGE.S   LAB_0BE8

    JSR     LAB_096D(PC)

    JSR     LAB_0C03(PC)

    MOVE.L  D0,D6
    EOR.B   D6,D7
    MOVEQ   #0,D0
    MOVE.W  LAB_2232,D0
    ASL.L   #8,D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    ADD.L   D1,D0
    MOVE.W  D0,LAB_2232
    ADDQ.W  #1,D5
    BRA.S   LAB_0BE7

LAB_0BE8:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D5-D7
    RTS

;!======

LAB_0BE9:
    JSR     LAB_0BEA(PC)

    JSR     LAB_0E48(PC)

    PEA     LAB_21DF
    JSR     LAB_0BEC(PC)

    PEA     LAB_2324
    PEA     LAB_2321
    JSR     LAB_0F4D(PC)

    JSR     LAB_0BFC(PC)

    LEA     12(A7),A7
    RTS

;!======

LAB_0BEA:
    JMP     LAB_0535

LAB_0BEB:
    JMP     LAB_1070

LAB_0BEC:
    JMP     LAB_0610

LAB_0BED:
    JMP     LAB_18F2

LAB_0BEE:
    JMP     LAB_1373

LAB_0BEF:
    JMP     LAB_18FC

LAB_0BF0:
    JMP     LAB_0623

LAB_0BF1:
    JMP     ESQ_SeedMinuteEventThresholds

LAB_0BF2:
    JMP     LAB_1416

LAB_0BF3:
    JMP     LAB_1670

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

LAB_0BF4:
    JMP     BRUSH_PlaneMaskForIndex

LAB_0BF5:
    JMP     LAB_1591

LAB_0BF6:
    JMP     LAB_146E

LAB_0BF7:
    JMP     LAB_0F4D

JMP_TBL_DISPLAY_TEXT_AT_POSITION_1:
    JMP     DISPLAY_TEXT_AT_POSITION

LAB_0BF9:
    JMP     LAB_0E48

LAB_0BFA:
    JMP     LAB_1A23

LAB_0BFB:
    JMP     LAB_04FF

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000
