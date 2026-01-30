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

    ; Alignment
LAB_1A70:
    DC.W    $0000
