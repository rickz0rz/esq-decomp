;!======

; weather related code?
LAB_185C:
    LINK.W  A5,#-228
    MOVEM.L D2-D3/D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    CLR.L   -8(A5)
    MOVEQ   #0,D0
    MOVE.B  LAB_227F,D1
    MOVE.L  D0,-156(A5)
    MOVE.L  D0,-152(A5)
    MOVEQ   #0,D0
    CMP.B   D0,D1
    BLS.W   .LAB_187C

    MOVE.W  LAB_229D,D0
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BEQ.W   .LAB_187C

    MOVE.B  LAB_229C,D0
    SUBQ.B  #1,D0
    BNE.S   .LAB_185D

    PEA     LAB_1ED4
    MOVE.L  LAB_1EDF,-(A7)
    JSR     LAB_18CF(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    BRA.S   .LAB_185E

.LAB_185D:
    MOVEQ   #0,D0
    MOVE.B  LAB_229C,D0
    ASL.L   #2,D0
    LEA     LAB_1EDD,A0
    ADDA.L  D0,A0
    PEA     LAB_1ED4
    MOVE.L  (A0),-(A7)
    JSR     LAB_18CF(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)

.LAB_185E:
    TST.L   D0
    BEQ.S   .LAB_185F

    MOVEQ   #0,D1
    MOVEA.L D0,A0
    MOVE.W  178(A0),D1
    MOVEQ   #0,D0
    MOVE.W  176(A0),D0
    MOVE.L  D0,-216(A5)
    MOVE.L  D1,-212(A5)
    BRA.S   .LAB_1860

.LAB_185F:
    MOVEQ   #90,D0
    MOVE.L  D0,-212(A5)
    MOVE.L  #$aa,-216(A5)

.LAB_1860:
    MOVE.L  -8(A5),-(A7)
    MOVE.L  LAB_1DEC,-(A7)
    JSR     LAB_1905(PC)

    ADDQ.W  #8,A7
    MOVEA.L D0,A0

.LAB_1861:
    TST.B   (A0)+
    BNE.S   .LAB_1861

    SUBQ.L  #1,A0
    SUBA.L  D0,A0
    MOVE.L  A0,D1
    ADDQ.L  #1,D1
    MOVE.L  D0,-12(A5)
    MOVE.L  D0,-8(A5)
    MOVE.L  D1,-160(A5)

.LAB_1862:
    MOVEA.L -12(A5),A0
    TST.B   (A0)
    BEQ.S   .LAB_1864

    MOVEQ   #24,D0
    CMP.B   (A0),D0
    BNE.S   .LAB_1863

    CLR.B   (A0)
    ADDQ.L  #1,-152(A5)

.LAB_1863:
    ADDQ.L  #1,-12(A5)
    BRA.S   .LAB_1862

.LAB_1864:
    MOVEA.L -8(A5),A0
    MOVE.L  A0,-12(A5)
    TST.B   (A0)
    BNE.S   .LAB_1865

    ADDQ.L  #1,-12(A5)
    SUBQ.L  #1,-152(A5)

.LAB_1865:
    CMPI.L  #$a,-152(A5)
    BLE.S   .LAB_1866

    MOVEQ   #10,D0
    MOVE.L  D0,-152(A5)

.LAB_1866:
    MOVEA.L A3,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L A3,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVEQ   #0,D0
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVE.W  26(A0),D0
    MOVE.L  D6,D1
    SUB.L   D0,D1
    SUB.L   -212(A5),D1
    SUBQ.L  #5,D1
    MOVE.B  LAB_229C,D0
    MOVE.L  D1,-196(A5)
    SUBQ.B  #1,D0
    BEQ.W   .LAB_186B

    TST.L   -4(A5)
    BEQ.W   .LAB_186B

    MOVEQ   #1,D0
    MOVEA.L -4(A5),A0
    MOVE.L  D0,356(A0)
    MOVE.L  D0,360(A0)
    PEA     5.W
    JSR     LAB_18D1(PC)

    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  184(A0),D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,-184(A5)
    JSR     LAB_18D1(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    CLR.L   -192(A5)
    MOVE.L  D1,-188(A5)

.LAB_1867:
    MOVE.L  -192(A5),D0
    CMP.L   -188(A5),D0
    BGE.S   .LAB_1868

    CMP.L   -184(A5),D0
    BGE.S   .LAB_1868

    LEA     LAB_2295,A0
    ADDA.L  D0,A0
    MOVEA.L -4(A5),A1
    MOVE.L  D0,D0
    ADDI.L  #$e8,D0
    MOVE.B  0(A1,D0.L),(A0)
    ADDQ.L  #1,-192(A5)
    BRA.S   .LAB_1867

.LAB_1868:
    MOVE.W  #1,LAB_22AA
    CLR.W   LAB_22AB
    CLR.L   -192(A5)

.LAB_1869:
    MOVE.L  -192(A5),D0
    MOVEQ   #4,D1
    CMP.L   D1,D0
    BGE.S   .LAB_186A

    ASL.L   #3,D0
    MOVEA.L -4(A5),A0
    ADDA.L  D0,A0
    LEA     200(A0),A1
    LEA     LAB_22AF,A0
    ADDA.L  D0,A0
    MOVE.L  A0,32(A7)
    MOVEA.L A1,A0
    MOVEA.L 32(A7),A1
    MOVEQ   #8,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    ADDQ.L  #1,-192(A5)
    BRA.S   .LAB_1869

.LAB_186A:
    CLR.W   LAB_22AA
    MOVE.W  #1,LAB_22AB
    MOVE.L  -196(A5),D0
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-148(A5)
    JSR     LAB_18D4(PC)

    LEA     28(A7),A7

.LAB_186B:
    TST.L   LAB_1DD9
    BEQ.S   .LAB_186D

    MOVEA.L LAB_1DD9,A0
    TST.B   (A0)
    BEQ.S   .LAB_186D

    LEA     -140(A5),A1

.LAB_186C:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_186C

    BRA.S   .LAB_186E

.LAB_186D:
    CLR.B   -140(A5)

.LAB_186E:
    LEA     -140(A5),A0
    MOVEA.L A0,A1

.LAB_186F:
    TST.B   (A1)+
    BNE.S   .LAB_186F

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,-204(A5)
    BLE.S   .LAB_1871

    MOVEA.L A3,A1
    MOVE.L  -204(A5),D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D7,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .LAB_1870

    ADDQ.L  #1,D1

.LAB_1870:
    ASR.L   #1,D1
    MOVE.L  D1,D5
    MOVEQ   #0,D0
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVE.W  20(A0),D0
    MOVE.L  D6,D1
    SUB.L   D0,D1
    SUB.L   -212(A5),D1
    SUBQ.L  #5,D1
    MOVE.L  D1,-148(A5)
    MOVEA.L A3,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L A3,A1
    MOVE.L  D5,D0
    MOVE.L  -148(A5),D1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    LEA     -140(A5),A0
    MOVE.L  -204(A5),D0
    JSR     _LVOText(A6)

.LAB_1871:
    MOVEQ   #0,D0
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVE.W  20(A0),D0
    MOVE.L  -152(A5),D1
    ADDQ.L  #1,D1
    TST.L   D1
    BPL.S   .LAB_1872

    ADDQ.L  #1,D1

.LAB_1872:
    ASR.L   #1,D1
    MOVE.L  D1,D2
    ADDQ.L  #1,D2
    MOVEQ   #0,D3
    MOVE.W  26(A0),D3
    ADD.L   -212(A5),D3
    MOVE.L  D0,-180(A5)
    MOVE.L  D1,-164(A5)
    JSR     LAB_1A06(PC)

    SUB.L   D0,D3
    ADDQ.L  #5,D3
    MOVE.L  D3,D0
    MOVE.L  D2,D1
    MOVE.L  D0,-172(A5)
    MOVE.L  D1,-168(A5)
    JSR     LAB_1A07(PC)

    MOVE.L  D7,D1
    SUB.L   -216(A5),D1
    TST.L   D1
    BPL.S   .LAB_1873

    ADDQ.L  #1,D1

.LAB_1873:
    ASR.L   #1,D1
    MOVE.L  D0,-176(A5)
    MOVE.L  D1,-200(A5)
    MOVEA.L A3,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

.LAB_1874:
    MOVE.L  -156(A5),D0
    CMP.L   -152(A5),D0
    BGE.W   .LAB_187B

    TST.L   D0
    BPL.S   .LAB_1875

    ADDQ.L  #1,D0

.LAB_1875:
    ASR.L   #1,D0
    MOVE.L  -176(A5),D1
    MOVE.L  -180(A5),D2
    ADD.L   D1,D2
    MOVE.L  D2,D1
    JSR     LAB_1A06(PC)

    MOVE.L  -196(A5),D1
    ADD.L   D0,D1
    ADD.L   -176(A5),D1
    MOVEQ   #0,D0
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVE.W  26(A0),D0
    ADD.L   D0,D1
    MOVEQ   #0,D2
    MOVE.W  20(A0),D2
    MOVE.L  D1,-148(A5)
    ADD.L   D2,D1
    MOVEQ   #0,D2
    MOVE.W  D0,D2
    SUB.L   D2,D1
    CMP.L   D6,D1
    BGE.W   .LAB_187B

    MOVE.L  -12(A5),-(A7)
    MOVE.L  -200(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_18CB(PC)

    LEA     12(A7),A7
    MOVE.L  D0,-204(A5)
    MOVEA.L A3,A1
    MOVEA.L -12(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -200(A5),D1
    SUB.L   D0,D1
    SUBQ.L  #1,D1
    TST.L   D1
    BPL.S   .LAB_1876

    ADDQ.L  #1,D1

.LAB_1876:
    ASR.L   #1,D1
    MOVE.L  D1,D5
    MOVE.L  D0,-208(A5)
    MOVEA.L A3,A1
    MOVE.L  D5,D0
    MOVE.L  -148(A5),D1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVEA.L -12(A5),A0
    MOVE.L  -204(A5),D0
    JSR     _LVOText(A6)

    ADDQ.L  #1,-156(A5)
    MOVE.L  -156(A5),D0
    CMP.L   -152(A5),D0
    BGE.S   .LAB_1879

    MOVEA.L -12(A5),A0

.LAB_1877:
    TST.B   (A0)+
    BNE.S   .LAB_1877

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    ADD.L   D0,-12(A5)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  -200(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_18CB(PC)

    LEA     12(A7),A7
    MOVE.L  D0,-204(A5)
    MOVEA.L A3,A1
    MOVEA.L -12(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -200(A5),D1
    ADD.L   D0,D1
    TST.L   D1
    BPL.S   .LAB_1878

    ADDQ.L  #1,D1

.LAB_1878:
    ASR.L   #1,D1
    MOVE.L  D7,D2
    SUB.L   D1,D2
    MOVE.L  D2,D5
    SUBQ.L  #1,D5
    MOVE.L  D0,-208(A5)
    MOVEA.L A3,A1
    MOVE.L  D5,D0
    MOVE.L  -148(A5),D1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVEA.L -12(A5),A0
    MOVE.L  -204(A5),D0
    JSR     _LVOText(A6)

    ADDQ.L  #1,-156(A5)

.LAB_1879:
    MOVEA.L -12(A5),A0

.LAB_187A:
    TST.B   (A0)+
    BNE.S   .LAB_187A

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    ADD.L   D0,-12(A5)
    BRA.W   .LAB_1874

.LAB_187B:
    MOVE.L  -160(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    PEA     301.W
    PEA     GLOB_STR_WDISP_C
    JSR     DEALLOCATE_MEMORY(PC)

    LEA     16(A7),A7
    BRA.W   .return

.LAB_187C:
    TST.L   LAB_205A
    BEQ.S   .LAB_187D

    MOVE.L  LAB_205A,-12(A5)
    BRA.S   .LAB_187E

.LAB_187D:
    MOVEA.L GLOB_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE,A0
    MOVE.L  A0,-12(A5)

.LAB_187E:
    MOVEA.L -12(A5),A0

.LAB_187F:
    TST.B   (A0)+
    BNE.S   .LAB_187F

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVE.L  A0,-204(A5)
    MOVEA.L A3,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L A3,A1
    MOVEA.L -12(A5),A0
    MOVE.L  -204(A5),D0
    JSR     _LVOTextLength(A6)

    MOVE.L  D7,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .LAB_1880

    ADDQ.L  #1,D1

.LAB_1880:
    ASR.L   #1,D1
    MOVEQ   #0,D0
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVE.W  20(A0),D0
    MOVE.L  D6,D2
    SUB.L   D0,D2
    TST.L   D2
    BPL.S   .LAB_1881

    ADDQ.L  #1,D2

.LAB_1881:
    ASR.L   #1,D2
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D2
    MOVEA.L A3,A1
    MOVE.L  D1,D0
    MOVE.L  D2,D1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVEA.L -12(A5),A0
    MOVE.L  -204(A5),D0
    JSR     _LVOText(A6)

.return:
    MOVEM.L (A7)+,D2-D3/D5-D7/A3
    UNLK    A5
    RTS

;!======

LAB_1883:
    LINK.W  A5,#-116
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    MOVE.L  20(A5),D5

    MOVEQ   #0,D0
    MOVEQ   #1,D1
    CLR.L   -104(A5)
    MOVE.L  D0,-68(A5)
    MOVE.L  D0,-64(A5)
    MOVE.L  D1,-100(A5)
    TST.L   D7
    BMI.W   .return

    MOVEQ   #4,D2
    CMP.L   D2,D7
    BGE.W   .return

    MOVE.L  D6,D0
    MOVEQ   #3,D1
    JSR     LAB_1A07(PC)

    MOVE.L  D7,D1
    MOVE.L  D0,-4(A5)
    JSR     LAB_1A06(PC)

    MOVE.L  D0,-8(A5)
    MOVE.L  D7,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  4(A1),D1
    ADDA.L  D0,A0
    MOVEM.L D1,-88(A5)
    MOVEQ   #1,D0
    CMP.L   16(A0),D0
    BEQ.S   .LAB_1884

    MOVEQ   #2,D0
    CMP.L   D0,D1
    BLT.S   .LAB_1884

    MOVEQ   #6,D3
    CMP.L   D3,D1
    BLE.S   .LAB_1885

.LAB_1884:
    MOVEQ   #2,D0
    CLR.L   -100(A5)
    MOVE.L  D0,-88(A5)

.LAB_1885:
    MOVE.L  -88(A5),D0
    ASL.L   #2,D0
    LEA     LAB_1EDD,A0
    ADDA.L  D0,A0
    PEA     LAB_1ED4
    MOVE.L  (A0),-(A7)
    JSR     LAB_18CF(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-104(A5)
    TST.L   D0
    BEQ.S   .LAB_1886

    MOVEQ   #0,D1
    MOVEA.L D0,A0
    MOVE.W  178(A0),D1
    MOVEQ   #0,D2
    MOVE.W  176(A0),D2
    MOVE.L  D1,-12(A5)
    MOVE.L  D2,-16(A5)
    BRA.S   .LAB_1887

.LAB_1886:
    MOVEQ   #90,D1
    MOVE.L  D1,-12(A5)
    MOVEQ   #0,D1
    MOVE.L  D1,-100(A5)
    MOVE.L  D1,-16(A5)

.LAB_1887:
    MOVE.L  D7,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    ADDA.L  D0,A0
    TST.L   16(A0)
    BNE.W   .LAB_1895

    MOVE.W  #1,LAB_22AA
    CLR.W   LAB_22AB
    TST.L   -100(A5)
    BEQ.W   .LAB_188D

    PEA     5.W
    JSR     LAB_18D1(PC)

    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVEQ   #0,D0
    MOVEA.L -104(A5),A0
    MOVE.B  184(A0),D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,-76(A5)
    JSR     LAB_18D1(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    CLR.L   -84(A5)
    MOVE.L  D1,-80(A5)

.LAB_1888:
    MOVE.L  -84(A5),D0
    CMP.L   -80(A5),D0
    BGE.S   .LAB_1889

    CMP.L   -76(A5),D0
    BGE.S   .LAB_1889

    LEA     LAB_2295,A0
    ADDA.L  D0,A0
    MOVEA.L -104(A5),A1
    MOVE.L  D0,D0
    ADDI.L  #$e8,D0
    MOVE.B  0(A1,D0.L),(A0)
    ADDQ.L  #1,-84(A5)
    BRA.S   .LAB_1888

.LAB_1889:
    CLR.L   -84(A5)

.LAB_188A:
    MOVE.L  -84(A5),D0
    MOVEQ   #4,D1
    CMP.L   D1,D0
    BGE.S   .LAB_188B

    ASL.L   #3,D0
    MOVEA.L -104(A5),A0
    ADDA.L  D0,A0
    LEA     200(A0),A1
    LEA     LAB_22AF,A0
    ADDA.L  D0,A0
    MOVE.L  A0,40(A7)
    MOVEA.L A1,A0
    MOVEA.L 40(A7),A1
    MOVEQ   #8,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    ADDQ.L  #1,-84(A5)
    BRA.S   .LAB_188A

.LAB_188B:
    CLR.W   LAB_22AA
    MOVE.W  #1,LAB_22AB
    MOVE.L  -16(A5),D0
    MOVE.L  -4(A5),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .LAB_188C

    ADDQ.L  #1,D1

.LAB_188C:
    ASR.L   #1,D1
    MOVE.L  -8(A5),D2
    ADD.L   D1,D2
    MOVE.L  D5,D1
    MOVE.L  -12(A5),D3
    SUB.L   D3,D1
    MOVEQ   #0,D4
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVE.W  26(A0),D4
    SUB.L   D4,D1
    SUBQ.L  #5,D1
    ADD.L   D2,D0
    ADD.L   D1,D3
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  -104(A5),-(A7)
    MOVE.L  D1,-96(A5)
    MOVE.L  D2,-92(A5)
    JSR     LAB_18D4(PC)

    LEA     28(A7),A7
    BRA.S   .LAB_188E

.LAB_188D:
    JSR     LAB_18CA(PC)

.LAB_188E:
    MOVE.L  D7,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    ADDA.L  D0,A0
    CMPI.L  #$fffffc19,8(A0)
    BNE.S   .LAB_188F

    LEA     LAB_219D,A0
    LEA     -46(A5),A1
    MOVE.L  (A0)+,(A1)+
    CLR.B   (A1)
    BRA.S   .LAB_1890

.LAB_188F:
    MOVE.L  D7,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    ADDA.L  D0,A0
    MOVE.L  8(A0),-(A7)
    PEA     GLOB_STR_PERCENT_D_SLASH
    PEA     -46(A5)
    JSR     WDISP_SPrintf(PC)

    LEA     12(A7),A7

.LAB_1890:
    MOVE.L  D7,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    ADDA.L  D0,A0
    CMPI.L  #$fffffc19,12(A0)   ; -999
    BNE.S   .LAB_1891

    LEA     LAB_219F,A0
    LEA     -26(A5),A1
    MOVE.L  (A0)+,(A1)+
    BRA.S   .LAB_1892

.LAB_1891:
    MOVE.L  D7,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    ADDA.L  D0,A0
    MOVE.L  12(A0),-(A7)
    PEA     GLOB_STR_PERCENT_D
    PEA     -26(A5)
    JSR     WDISP_SPrintf(PC)

    LEA     12(A7),A7

.LAB_1892:
    PEA     -26(A5)
    PEA     -46(A5)
    JSR     APPEND_DATA_AT_NULL(PC)

    ADDQ.W  #8,A7
    MOVEA.L A3,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    LEA     -46(A5),A0
    MOVEA.L A0,A1

.LAB_1893:
    TST.B   (A1)+
    BNE.S   .LAB_1893

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,-50(A5)
    MOVEA.L A3,A1
    MOVE.L  -50(A5),D0
    JSR     _LVOTextLength(A6)

    MOVE.L  -4(A5),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .LAB_1894

    ADDQ.L  #1,D1

.LAB_1894:
    ASR.L   #1,D1
    MOVE.L  -8(A5),D0
    ADD.L   D1,D0
    MOVE.L  D5,D1
    SUBQ.L  #5,D1
    MOVE.L  D0,-92(A5)
    MOVE.L  D1,-96(A5)
    MOVEA.L A3,A1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    LEA     -46(A5),A0
    MOVE.L  -50(A5),D0
    JSR     _LVOText(A6)

    BRA.W   .LAB_189F

.LAB_1895:
    MOVE.L  LAB_205B,-54(A5)
    MOVEQ   #20,D0
    SUB.L   D0,-4(A5)
    CLR.L   -68(A5)
    MOVE.L  #$8c,-64(A5)
    MOVEA.L A3,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

.LAB_1896:
    TST.L   -54(A5)
    BEQ.W   .LAB_189E

    CMPI.L  #$4,-68(A5)
    BGE.W   .LAB_189E

.LAB_1897:
    MOVEA.L -54(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .LAB_1898

    ADDQ.L  #1,-54(A5)
    BRA.S   .LAB_1897

.LAB_1898:
    CLR.L   -(A7)
    MOVE.L  -54(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  -64(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_18D5(PC)

    LEA     24(A7),A7
    MOVE.L  D0,-58(A5)
    TST.L   D0
    BEQ.W   .LAB_189B

    MOVEA.L D0,A0
    MOVE.B  (A0),-59(A5)
    CLR.B   (A0)
    MOVEA.L -54(A5),A0

.LAB_1899:
    TST.B   (A0)+
    BNE.S   .LAB_1899

    SUBQ.L  #1,A0
    SUBA.L  -54(A5),A0
    MOVEA.L D0,A1
    MOVE.B  -59(A5),(A1)
    MOVE.L  A0,-72(A5)
    MOVEA.L A3,A1
    MOVE.L  A0,D0
    MOVEA.L -54(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -4(A5),D1
    MOVE.L  D1,D2
    SUB.L   D0,D2
    MOVEQ   #20,D0
    ADD.L   D0,D2
    TST.L   D2
    BPL.S   .LAB_189A

    ADDQ.L  #1,D2

.LAB_189A:
    ASR.L   #1,D2
    MOVE.L  -8(A5),D0
    ADD.L   D2,D0
    PEA     1.W
    MOVE.L  -54(A5),-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -64(A5),-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-92(A5)
    JSR     LAB_18D5(PC)

    LEA     24(A7),A7
    MOVEQ   #0,D1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVE.W  20(A0),D1
    ADDQ.L  #4,D1
    ADD.L   D1,-64(A5)
    ADDQ.L  #1,-68(A5)
    MOVE.L  D0,-54(A5)
    BRA.W   .LAB_1896

.LAB_189B:
    MOVEA.L -54(A5),A0

.LAB_189C:
    TST.B   (A0)+
    BNE.S   .LAB_189C

    SUBQ.L  #1,A0
    SUBA.L  -54(A5),A0
    MOVEA.L A3,A1
    MOVE.L  A0,D0
    MOVEA.L -54(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -4(A5),D1
    MOVE.L  D1,D2
    SUB.L   D0,D2
    MOVEQ   #20,D0
    ADD.L   D0,D2
    TST.L   D2
    BPL.S   .LAB_189D

    ADDQ.L  #1,D2

.LAB_189D:
    ASR.L   #1,D2
    MOVE.L  -8(A5),D0
    ADD.L   D2,D0
    PEA     1.W
    MOVE.L  -54(A5),-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -64(A5),-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-92(A5)
    JSR     LAB_18D5(PC)

    LEA     24(A7),A7
    MOVE.L  D0,-54(A5)
    BRA.W   .LAB_1896

.LAB_189E:
    MOVEQ   #20,D0
    ADD.L   D0,-4(A5)

.LAB_189F:
    MOVE.W  LAB_2274,D0
    EXT.L   D0
    ADD.L   D7,D0
    ADDQ.L  #1,D0
    MOVEQ   #7,D1
    JSR     LAB_1A07(PC)

    ASL.L   #2,D1
    LEA     GLOB_JMP_TBL_DAYS_OF_WEEK,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    LEA     -46(A5),A2

.LAB_18A0:
    MOVE.B  (A1)+,(A2)+
    BNE.S   .LAB_18A0

    LEA     -46(A5),A0
    MOVEA.L A0,A1

.LAB_18A1:
    TST.B   (A1)+
    BNE.S   .LAB_18A1

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,-50(A5)
    MOVEA.L A3,A1
    MOVE.L  -50(A5),D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -4(A5),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .LAB_18A2

    ADDQ.L  #1,D1

.LAB_18A2:
    ASR.L   #1,D1
    MOVE.L  -8(A5),D0
    ADD.L   D1,D0
    MOVE.L  D5,D1
    SUB.L   -12(A5),D1
    MOVEQ   #0,D2
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVE.W  20(A0),D2
    SUB.L   D2,D1
    SUBQ.L  #5,D1
    MOVE.L  D0,-92(A5)
    MOVE.L  D1,-96(A5)
    MOVEA.L A3,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L A3,A1
    MOVE.L  -92(A5),D0
    MOVE.L  -96(A5),D1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    LEA     -46(A5),A0
    MOVE.L  -50(A5),D0
    JSR     _LVOText(A6)

.return:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_18A4:
    LINK.W  A5,#-12
    MOVEM.L D2/D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVE.B  LAB_2196,D0
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.S   .LAB_18A6

    MOVE.W  LAB_229D,D0
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BEQ.S   .LAB_18A6

    MOVEQ   #0,D4

.LAB_18A5:
    MOVEQ   #3,D0
    CMP.L   D0,D4
    BGE.W   .return

    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1883

    LEA     16(A7),A7
    ADDQ.L  #1,D4
    BRA.S   .LAB_18A5

.LAB_18A6:
    TST.L   LAB_205B
    BEQ.S   .LAB_18A7

    MOVE.L  LAB_205B,-4(A5)
    BRA.S   .LAB_18A8

.LAB_18A7:
    MOVEA.L LAB_20B0,A0
    MOVE.L  A0,-4(A5)

.LAB_18A8:
    MOVEA.L -4(A5),A0

.LAB_18A9:
    TST.B   (A0)+
    BNE.S   .LAB_18A9

    SUBQ.L  #1,A0
    SUBA.L  -4(A5),A0
    MOVE.L  A0,D5
    MOVEA.L A3,A1
    MOVE.L  D5,D0
    MOVEA.L -4(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D7,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .LAB_18AA

    ADDQ.L  #1,D1

.LAB_18AA:
    ASR.L   #1,D1
    MOVEQ   #0,D0
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVE.W  20(A0),D0
    MOVE.L  D6,D2
    SUB.L   D0,D2
    TST.L   D2
    BPL.S   .LAB_18AB

    ADDQ.L  #1,D2

.LAB_18AB:
    ASR.L   #1,D2
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D2
    MOVEA.L A3,A1
    MOVE.L  D1,D0
    MOVE.L  D2,D1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVE.L  D5,D0
    MOVEA.L -4(A5),A0
    JSR     _LVOText(A6)

.return:
    MOVEM.L (A7)+,D2/D4-D7/A3
    UNLK    A5
    RTS

;!======

LAB_18AD:
    LINK.W  A5,#-12
    MOVEM.L D2/D5-D7,-(A7)

.localRastport = -12

    MOVE.L  8(A5),D7
    MOVEQ   #48,D0
    CMP.L   D0,D7
    BEQ.S   .LAB_18AE

    MOVEQ   #51,D0
    CMP.L   D0,D7
    BNE.W   .LAB_18BC

.LAB_18AE:
    CLR.L   -(A7)
    PEA     4.W
    JSR     LAB_183C(PC)

    MOVEQ   #4,D0
    MOVE.L  D0,(A7)
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_183E(PC)

    MOVE.L  D0,LAB_2216
    JSR     LAB_18D2(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEQ   #0,D6
    MOVEA.L LAB_2216,A1
    MOVE.W  4(A1),D6
    MOVEQ   #0,D5
    MOVE.W  2(A1),D5
    MOVE.L  A0,.localRastport(A5)
    JSR     LAB_18CA(PC)

    JSR     LAB_18CE(PC)

    MOVEQ   #0,D0
    MOVE.L  D0,(A7)
    MOVE.L  D0,-(A7)
    PEA     3.W
    JSR     LAB_183E(PC)

    LEA     24(A7),A7
    MOVE.L  D0,LAB_2216

    MOVEA.L .localRastport(A5),A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L .localRastport(A5),A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L .localRastport(A5),A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVEQ   #48,D0
    CMP.L   D0,D7
    BNE.S   .LAB_18AF

    MOVE.L  D6,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  .localRastport(A5),-(A7)
    BSR.W   LAB_185C

    LEA     12(A7),A7
    BRA.S   .LAB_18B0

.LAB_18AF:
    MOVEQ   #51,D0
    CMP.L   D0,D7
    BNE.S   .LAB_18B0

    MOVE.L  D6,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  .localRastport(A5),-(A7)
    BSR.W   LAB_18A4

    LEA     12(A7),A7

.LAB_18B0:
    MOVEQ   #4,D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_183E(PC)

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2216
    MOVE.B  LAB_22B2,D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BCC.S   .LAB_18B1

    MOVE.B  LAB_22B3,D0
    CMP.B   D1,D0
    BCC.S   .LAB_18B1

    MOVE.W  LAB_22B0,D0
    CMPI.W  #$4000,D0
    BGE.S   .LAB_18B1

    MOVE.W  D0,LAB_1B0D
    BRA.S   .LAB_18B2

.LAB_18B1:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_1B0D

.LAB_18B2:
    MOVE.B  LAB_22B6,D2
    CMP.B   D1,D2
    BCC.S   .LAB_18B3

    MOVE.B  LAB_22B7,D2
    CMP.B   D1,D2
    BCC.S   .LAB_18B3

    MOVE.W  LAB_22B4,D2
    CMPI.W  #$4000,D2
    BGE.S   .LAB_18B3

    MOVE.W  D2,LAB_1B0E
    BRA.S   .LAB_18B4

.LAB_18B3:
    MOVEQ   #0,D2
    MOVE.W  D2,LAB_1B0E

.LAB_18B4:
    MOVE.B  LAB_22BA,D0
    CMP.B   D1,D0
    BCC.S   .LAB_18B5

    MOVE.B  LAB_22BB,D0
    CMP.B   D1,D0
    BCC.S   .LAB_18B5

    MOVE.W  LAB_22B8,D0
    CMPI.W  #16384,D0
    BGE.S   .LAB_18B5

    MOVE.W  D0,LAB_1B0F
    BRA.S   .LAB_18B6

.LAB_18B5:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_1B0F

.LAB_18B6:
    MOVE.B  LAB_22BE,D2
    CMP.B   D1,D2
    BCC.S   .LAB_18B7

    MOVE.B  LAB_22BF,D2
    CMP.B   D1,D2
    BCC.S   .LAB_18B7

    MOVE.W  LAB_22BC,D1
    CMPI.W  #16384,D1
    BGE.S   .LAB_18B7

    MOVE.W  D1,LAB_1B10
    BRA.S   .LAB_18B8

.LAB_18B7:
    MOVEQ   #0,D1
    MOVE.W  D1,LAB_1B10

.LAB_18B8:
    TST.W   LAB_1B0D
    BNE.S   .LAB_18B9

    TST.W   LAB_1B0E
    BNE.S   .LAB_18B9

    TST.W   LAB_1B0F
    BNE.S   .LAB_18B9

    TST.W   D1
    BEQ.S   .LAB_18BA

.LAB_18B9:
    MOVE.W  #1,LAB_22AA
    BRA.S   .LAB_18BB

.LAB_18BA:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_22AA

.LAB_18BB:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_1B11
    MOVE.W  D0,LAB_1B15
    MOVE.W  D0,LAB_1B12
    MOVE.W  D0,LAB_1B16
    MOVE.W  D0,LAB_1B13
    MOVE.W  D0,LAB_1B17
    MOVE.W  D0,LAB_1B14
    MOVE.W  D0,LAB_1B18
    JSR     LAB_167A(PC)

    BRA.S   .LAB_18BD

.LAB_18BC:
    JSR     LAB_167D(PC)

.LAB_18BD:
    MOVEM.L (A7)+,D2/D5-D7
    UNLK    A5
    RTS

;!======

    ; Dead code.
    MOVEM.L D2-D3,-(A7)

    MOVE.W  LAB_229D,D0
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BEQ.S   .return

    MOVE.B  LAB_227F,D2
    TST.B   D2
    BEQ.S   .return

    MOVE.W  LAB_2380,D2
    MOVE.L  D2,D3
    SUBQ.W  #1,D3
    MOVE.W  D3,LAB_2380
    BGT.S   .return

    SUBI.W  #$30,D0
    MOVE.W  D0,LAB_2380

.return:
    MOVEM.L (A7)+,D2-D3
    RTS

;!======

    ; Dead code.
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.B  LAB_229C,D0
    SUBQ.B  #1,D0
    BEQ.S   .LAB_18BF

    MOVE.B  LAB_229C,D0
    MOVEQ   #6,D1
    CMP.B   D1,D0
    BLS.S   .LAB_18C0

.LAB_18BF:
    MOVEQ   #0,D0
    BRA.S   .LAB_18C1

.LAB_18C0:
    MOVEQ   #0,D0
    MOVE.B  LAB_229C,D0
    ASL.L   #2,D0
    LEA     LAB_1EDD,A0
    ADDA.L  D0,A0
    PEA     LAB_1ED4
    MOVE.L  (A0),-(A7)
    JSR     LAB_18CF(PC)

    MOVE.L  D0,(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-6(A5)
    JSR     LAB_18D3(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,D0

.LAB_18C1:
    MOVEM.L -16(A5),D7/A3
    UNLK    A5
    RTS

;!======

LAB_18C2:
    LINK.W  A5,#-4
    MOVEM.L D2/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2

    MOVEQ   #8,D0
    CMP.L   LAB_2194,D0
    BNE.S   .LAB_18C3

    MOVEQ   #0,D0
    MOVE.L  D0,LAB_2194
    MOVE.L  D0,LAB_2195
    BRA.W   .LAB_18C9

.LAB_18C3:
    LEA     60(A2),A0
    MOVEA.L A0,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-4(A5)
    MOVE.L  4(A3),4(A0)
    TST.L   LAB_2194
    BNE.S   .LAB_18C5

    MOVE.L  LAB_1B25,-(A7)
    MOVE.L  A2,-(A7)
    JSR     LAB_18D3(PC)

    ADDQ.W  #8,A7
    EXT.L   D0
    MOVE.L  D0,LAB_2195
    TST.L   D0
    BEQ.S   .LAB_18C4

    MOVEQ   #7,D0
    MOVE.L  D0,LAB_2194

.LAB_18C4:
    TST.L   LAB_1B25
    BEQ.S   .LAB_18C6

    MOVEA.L LAB_1B25,A0
    ADDA.W  #$e8,A0
    MOVE.L  A0,-(A7)
    JSR     LAB_18CC(PC)

    MOVE.L  A2,(A7)
    JSR     LAB_18D6(PC)

    ADDQ.W  #4,A7
    BRA.S   .LAB_18C6

.LAB_18C5:
    MOVEQ   #7,D0
    CMP.L   LAB_2194,D0
    BNE.S   .LAB_18C6

    MOVE.L  LAB_1B25,-(A7)
    MOVE.L  A2,-(A7)
    JSR     LAB_18D3(PC)

    ADDQ.W  #8,A7
    EXT.L   D0
    MOVE.L  D0,LAB_2195
    MOVEQ   #-1,D1
    MOVE.L  D1,32(A2)

.LAB_18C6:
    TST.L   LAB_2195
    BNE.S   .LAB_18C8

    CLR.L   -(A7)
    PEA     LAB_1B25
    JSR     LAB_18D0(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    TST.L   D0
    BEQ.S   .LAB_18C7

    MOVE.W  LAB_229D,D1
    MOVEQ   #48,D2
    CMP.W   D2,D1
    BEQ.S   .LAB_18C7

    MOVE.B  LAB_227F,D1
    TST.B   D1
    BEQ.S   .LAB_18C7

    MOVE.W  LAB_2380,D1
    MOVEQ   #1,D2
    CMP.W   D2,D1
    BGT.S   .LAB_18C7

    TST.L   LAB_2059
    BNE.S   .LAB_18C7

    PEA     2.W
    JSR     LAB_18CD(PC)

    ADDQ.W  #4,A7

.LAB_18C7:
    MOVEQ   #8,D0
    MOVE.L  D0,LAB_2194
    MOVEQ   #-1,D0
    MOVE.L  D0,LAB_2195

.LAB_18C8:
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)

.LAB_18C9:
    TST.L   LAB_2195
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0

    MOVEM.L (A7)+,D2/A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_18CA:
    JMP     LAB_0A45

LAB_18CB:
    JMP     LAB_09E2

LAB_18CC:
    JMP     LAB_0D75

LAB_18CD:
    JMP     LAB_09F9

LAB_18CE:
    JMP     LAB_0A49

LAB_18CF:
    JMP     BRUSH_FindBrushByPredicate

LAB_18D0:
    JMP     BRUSH_FreeBrushList

LAB_18D1:
    JMP     BRUSH_PlaneMaskForIndex

LAB_18D2:
    JMP     ESQ_SetCopperEffect_OnEnableHighlight

LAB_18D3:
    JMP     LAB_0A00

LAB_18D4:
    JMP     BRUSH_SelectBrushSlot

LAB_18D5:
    JMP     LAB_0FFB

LAB_18D6:
    JMP     LAB_102C

;!======

    MOVEQ   #97,D0

;!======

LAB_18D7:
    LINK.W  A5,#-16
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3

    MOVE.B  (A3)+,D6
    MOVE.B  (A3)+,D5
    MOVE.B  (A3)+,D4
    ADDQ.L  #1,A3
    MOVEQ   #2,D0
    CMP.B   D0,D4
    BCS.S   .LAB_18D8

    MOVEQ   #6,D0
    CMP.B   D0,D4
    BLS.S   .LAB_18D9

.LAB_18D8:
    MOVEQ   #1,D4

.LAB_18D9:
    MOVEQ   #0,D7

.LAB_18DA:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-16(A5,D7.W)
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_18DB

    MOVEQ   #10,D0
    CMP.W   D0,D7
    BGE.S   .LAB_18DB

    ADDQ.W  #1,D7
    BRA.S   .LAB_18DA

.LAB_18DB:
    MOVEQ   #0,D0
    MOVE.B  D0,-16(A5,D7.W)
    MOVE.B  -16(A5),D1
    TST.B   D1
    BEQ.S   .return

    PEA     -16(A5)
    PEA     LAB_2245
    JSR     LAB_1902(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .return

    MOVE.L  LAB_1DEC,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1905(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_1DEC
    MOVE.B  D6,LAB_227F
    MOVE.B  D5,LAB_229B
    MOVE.B  D4,LAB_229C
    TST.W   LAB_2252
    BEQ.S   .return

    MOVE.L  LAB_1DEC,-(A7)
    PEA     172.W
    CLR.L   -(A7)
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_2(PC)

    LEA     16(A7),A7

.return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

LAB_18DD:
    LINK.W  A5,#-36
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3

    MOVEQ   #0,D7

.LAB_18DE:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-15(A5,D7.W)
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_18DF

    MOVEQ   #10,D0
    CMP.W   D0,D7
    BGE.S   .LAB_18DF

    ADDQ.W  #1,D7
    BRA.S   .LAB_18DE

.LAB_18DF:
    MOVEQ   #0,D0
    MOVE.B  D0,-15(A5,D7.W)
    MOVE.B  -15(A5),D1
    TST.B   D1
    BEQ.W   .return

    PEA     -15(A5)
    PEA     LAB_2246
    JSR     LAB_1902(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.W   .return

    MOVEQ   #0,D7

.LAB_18E0:
    MOVEQ   #4,D0
    CMP.W   D0,D7
    BGE.S   .LAB_18E1

    MOVE.L  D7,D0
    MULS    #20,D0
    LEA     LAB_2197,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #1,D1
    MOVE.L  D1,16(A1)
    MOVE.W  LAB_227C,D1
    ADD.W   D7,D1
    MOVE.L  D1,D6
    ADDQ.W  #1,D6
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.W  LAB_2277,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,28(A7)
    JSR     LAB_1903(PC)

    ADDQ.W  #8,A7
    EXT.L   D0
    MOVEA.L 20(A7),A0
    MOVE.L  D0,(A0)
    ADDQ.W  #1,D7
    BRA.S   .LAB_18E0

.LAB_18E1:
    MOVE.B  (A3)+,LAB_2196
    MOVE.B  (A3)+,D5

.LAB_18E2:
    MOVEQ   #43,D0
    CMP.B   D0,D5
    BNE.W   .return

    PEA     3.W
    MOVE.L  A3,-(A7)
    PEA     -25(A5)
    JSR     LAB_1955(PC)

    CLR.B   -22(A5)
    PEA     -25(A5)
    JSR     LAB_1A23(PC)

    LEA     16(A7),A7
    MOVE.L  D0,D6
    ADDQ.L  #3,A3
    MOVEQ   #0,D4

.LAB_18E3:
    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    EXT.L   D0
    CMP.L   (A0),D0
    BEQ.S   .LAB_18E4

    MOVEQ   #4,D0
    CMP.L   D0,D4
    BGE.S   .LAB_18E4

    ADDQ.L  #1,D4
    BRA.S   .LAB_18E3

.LAB_18E4:
    TST.L   D4
    BMI.S   .LAB_18E5

    MOVEQ   #3,D0
    CMP.L   D0,D4
    BLE.S   .LAB_18E6

.LAB_18E5:
    MOVEQ   #0,D5

.LAB_18E6:
    MOVEQ   #43,D0
    CMP.B   D0,D5
    BNE.W   .LAB_18ED

    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    ADDA.L  D0,A0
    CLR.L   16(A0)
    PEA     1.W
    MOVE.L  A3,-(A7)
    PEA     -25(A5)
    JSR     LAB_1955(PC)

    LEA     12(A7),A7
    CLR.B   -24(A5)
    MOVE.B  -25(A5),D0
    MOVEQ   #63,D1
    CMP.B   D1,D0
    BNE.S   .LAB_18E7

    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #1,D0
    MOVE.L  D0,4(A1)
    BRA.S   .LAB_18E8

.LAB_18E7:
    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    ADDA.L  D0,A0
    PEA     -25(A5)
    MOVE.L  A0,24(A7)
    JSR     LAB_1A23(PC)

    ADDQ.W  #4,A7
    MOVEA.L 20(A7),A0
    MOVE.L  D0,4(A0)

.LAB_18E8:
    ADDQ.L  #1,A3
    PEA     3.W
    MOVE.L  A3,-(A7)
    PEA     -25(A5)
    JSR     LAB_1955(PC)

    LEA     12(A7),A7
    CLR.B   -22(A5)
    MOVE.B  -25(A5),D0
    MOVEQ   #63,D1
    CMP.B   D1,D0
    BNE.S   .LAB_18E9

    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  #(-999),8(A1)
    BRA.S   .LAB_18EA

.LAB_18E9:
    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    ADDA.L  D0,A0
    PEA     -25(A5)
    MOVE.L  A0,24(A7)
    JSR     LAB_1A23(PC)

    ADDQ.W  #4,A7
    MOVEA.L 20(A7),A0
    MOVE.L  D0,8(A0)

.LAB_18EA:
    ADDQ.L  #3,A3
    PEA     3.W
    MOVE.L  A3,-(A7)
    PEA     -25(A5)
    JSR     LAB_1955(PC)

    LEA     12(A7),A7
    CLR.B   -22(A5)
    MOVE.B  -25(A5),D0
    MOVEQ   #63,D1
    CMP.B   D1,D0
    BNE.S   .LAB_18EB

    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  #(-999),12(A1)
    BRA.S   .LAB_18EC

.LAB_18EB:
    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    ADDA.L  D0,A0
    PEA     -25(A5)
    MOVE.L  A0,24(A7)
    JSR     LAB_1A23(PC)

    ADDQ.W  #4,A7
    MOVEA.L 20(A7),A0
    MOVE.L  D0,12(A0)

.LAB_18EC:
    ADDQ.L  #3,A3
    MOVE.B  (A3)+,D5
    BRA.W   .LAB_18E2

.LAB_18ED:
    ADDQ.L  #7,A3
    MOVE.B  (A3)+,D5
    BRA.W   .LAB_18E2

.return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

LAB_18EF:
    MOVE.L  D7,-(A7)

    MOVE.B  11(A7),D7
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_229A,-(A7)
    JSR     LAB_1900(PC)

    MOVE.W  D0,LAB_2232
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_2(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_18F0

    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_18D7

    ADDQ.W  #4,A7
    BRA.S   .return

.LAB_18F0:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_18F2:
    MOVE.L  D7,-(A7)

    MOVE.B  11(A7),D7
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_229A,-(A7)
    JSR     LAB_1900(PC)

    MOVE.W  D0,LAB_2232
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_2(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_18F3

    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_18DD

    ADDQ.W  #4,A7
    BRA.S   .return

.LAB_18F3:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_18F5:
    LINK.W  A5,#-16
    MOVEM.L D2/D7/A3,-(A7)
    MOVEA.L 8(A5),A3

    MOVEQ   #0,D0
    MOVE.B  (A3)+,D0
    MOVE.W  D0,LAB_229D
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BLT.S   .LAB_18F6

    MOVEQ   #57,D2
    CMP.W   D2,D0
    BLE.S   .LAB_18F7

.LAB_18F6:
    MOVE.W  D1,LAB_229D

.LAB_18F7:
    MOVEQ   #0,D7

.LAB_18F8:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-13(A5,D7.W)
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_18F9

    MOVEQ   #10,D0
    CMP.W   D0,D7
    BGE.S   .LAB_18F9

    ADDQ.W  #1,D7
    BRA.S   .LAB_18F8

.LAB_18F9:
    CLR.B   -13(A5,D7.W)
    LEA     -13(A5),A0
    LEA     LAB_2245,A1

.LAB_18FA:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_18FA

    MOVE.L  LAB_1DD9,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1905(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_1DD9
    TST.W   LAB_2252
    BEQ.S   .return

    MOVE.L  D0,-(A7)
    PEA     172.W
    CLR.L   -(A7)
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_2(PC)

    LEA     16(A7),A7

.return:
    MOVEM.L (A7)+,D2/D7/A3
    UNLK    A5
    RTS

;!======

LAB_18FC:
    LINK.W  A5,#-16
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D7

.LAB_18FD:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-13(A5,D7.W)
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_18FE

    MOVEQ   #10,D0
    CMP.W   D0,D7
    BGE.S   .LAB_18FE

    ADDQ.W  #1,D7
    BRA.S   .LAB_18FD

.LAB_18FE:
    CLR.B   -13(A5,D7.W)
    LEA     -13(A5),A0
    LEA     LAB_2246,A1

.LAB_18FF:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_18FF

    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

LAB_1900:
    JMP     LAB_0B0E

JMP_TBL_DISPLAY_TEXT_AT_POSITION_2:
    JMP     DISPLAY_TEXT_AT_POSITION

LAB_1902:
    JMP     ESQ_WildcardMatch

LAB_1903:
    JMP     LAB_0631

JMP_TBL_GENERATE_CHECKSUM_BYTE_INTO_D0_2:
    JMP     GENERATE_CHECKSUM_BYTE_INTO_D0

LAB_1905:
    JMP     LAB_0B44

;!======

    ; Alignment
    RTS
    DC.W    $0000

;!======

    ; Dead code.
    LINK.W  A5,#-4

    LEA     12(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  8(A5),-(A7)
    PEA     LAB_2381
    MOVE.L  A0,-4(A5)
    JSR     LAB_1A3A(PC)

    PEA     LAB_2381
    JSR     LAB_1AE8(PC)

    UNLK    A5
    RTS

;!======

LAB_1906:
    LINK.W  A5,#-4
    LEA     12(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  8(A5),-(A7)
    PEA     LAB_2381
    MOVE.L  A0,-4(A5)
    JSR     LAB_1A3A(PC)

    PEA     LAB_2381
    JSR     LAB_1AE8(PC)

    UNLK    A5
    RTS

;!======

    ; Dead code.
    LINK.W  A5,#-8

    PEA     GLOB_STR_A_PLUS
    PEA     GLOB_STR_DF1_DEBUG_LOG
    JSR     LAB_1AB2(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    BEQ.S   .LAB_1907

    LEA     12(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  8(A5),-(A7)
    PEA     LAB_2381
    MOVE.L  A0,-4(A5)
    JSR     LAB_1A3A(PC)

    PEA     LAB_2381
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_19C3(PC)

    MOVE.L  -8(A5),(A7)
    JSR     LAB_1AB9(PC)

    LEA     20(A7),A7

.LAB_1907:
    UNLK    A5
    RTS

;!======

LAB_1908:
    RTS

;!======

    include "subroutines/memory/allocate_memory.s"
    include "subroutines/memory/deallocate_memory.s"
    include "subroutines/memory/constants.s"

;!======

    RTS

;!======

ALLOC_RASTER:
    LINK.W  A5,#-4
    MOVEM.L D6-D7,-(A7)
    MOVE.L  16(A5),D7   ; Width
    MOVE.L  20(A5),D6   ; Height

    MOVE.L  D7,D0       ; Width
    MOVE.L  D6,D1       ; Height
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOAllocRaster(A6)

    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS

;!======

FREE_RASTER:
    LINK.W  A5,#0
    MOVEM.L D6-D7/A3,-(A7)

    MOVEA.L 16(A5),A3
    MOVE.L  20(A5),D7
    MOVE.L  24(A5),D6

    MOVEA.L A3,A0
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOFreeRaster(A6)

    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

OPEN_FILE_WITH_ACCESS_MODE:
    MOVEM.L D2/D6-D7/A3,-(A7)

    SetOffsetForStack 4

    MOVEA.L .stackOffsetBytes+4(A7),A3
    MOVE.L  .stackOffsetBytes+8(A7),D7

    MOVE.L  A3,D1
    MOVE.L  D7,D2
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOOpen(A6)

    MOVE.L  D0,D6
    MOVE.L  D6,D0

    MOVEM.L (A7)+,D2/D6-D7/A3
    RTS

;!======

LAB_190F:
    RTS

;!======

LAB_1910:
    RTS

;!======

LAB_1911:
    MOVEM.L D6-D7/A3,-(A7)

    SetOffsetForStack 3

    MOVEA.L .stackOffsetBytes+4(A7),A3
    MOVEA.L A3,A0

.incrementAddressForStringLength:
    TST.B   (A0)+
    BNE.S   .incrementAddressForStringLength

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D6   ; String length

.LAB_1913:
    MOVEQ   #0,D7
    MOVE.B  (A3)+,D7
    TST.L   D7
    BEQ.S   .LAB_1915

    SUBQ.L  #1,-1074(A4)
    BLT.S   .LAB_1914

    MOVEA.L -1082(A4),A0
    LEA     1(A0),A1
    MOVE.L  A1,-1082(A4)
    MOVE.L  D7,D0
    MOVE.B  D0,(A0)
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .LAB_1913

.LAB_1914:
    MOVE.L  D7,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    PEA     -1086(A4)
    MOVE.L  D1,-(A7)
    JSR     LAB_1916(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D1
    BRA.S   .LAB_1913

.LAB_1915:
    PEA     -1086(A4)
    PEA     -1.W
    JSR     LAB_1916(PC)

    ADDQ.W  #8,A7
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

LAB_1916:
    LINK.W  A5,#-20
    MOVEM.L D2/D4-D7/A3,-(A7)

    SetOffsetForStackAfterLink 20,6

    MOVE.L  .stackOffsetBytes+4(A7),D7
    MOVEA.L .stackOffsetBytes+8(A7),A3
    MOVE.L  D7,D4
    MOVEQ   #49,D0
    AND.L   24(A3),D0
    BEQ.S   .LAB_1917

    MOVEQ   #-1,D0
    BRA.W   .return

.LAB_1917:
    BTST    #7,26(A3)
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D6
    TST.L   20(A3)
    BNE.W   .LAB_191D

    BTST    #2,27(A3)
    BNE.S   .LAB_191D

    MOVEQ   #0,D0
    MOVE.L  D0,12(A3)
    MOVEQ   #-1,D1
    CMP.L   D1,D7
    BEQ.W   .return

    MOVE.L  A3,-(A7)
    JSR     LAB_1A8E(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .LAB_1918

    BSET    #5,27(A3)
    MOVEQ   #-1,D0
    BRA.W   .return

.LAB_1918:
    BSET    #1,27(A3)
    TST.B   D6
    BEQ.S   .LAB_1919

    MOVE.L  20(A3),D0
    MOVE.L  D0,D1
    NEG.L   D1
    MOVE.L  D1,12(A3)
    BRA.S   .LAB_191A

.LAB_1919:
    MOVE.L  20(A3),D0
    MOVE.L  D0,12(A3)

.LAB_191A:
    SUBQ.L  #1,12(A3)
    BLT.S   .LAB_191B

    MOVEA.L 4(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,4(A3)
    MOVE.L  D7,D0
    MOVE.B  D0,(A0)
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .LAB_191C

.LAB_191B:
    MOVE.L  D7,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  A3,-(A7)
    MOVE.L  D1,-(A7)
    BSR.W   LAB_1916

    ADDQ.W  #8,A7
    MOVE.L  D0,D1

.LAB_191C:
    MOVE.L  D1,D0
    BRA.W   .return

.LAB_191D:
    BTST    #2,27(A3)
    BEQ.S   .LAB_1921

    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BNE.S   .LAB_191E

    MOVEQ   #0,D0
    BRA.W   .return

.LAB_191E:
    MOVE.L  D7,D0
    MOVE.B  D0,-1(A5)
    TST.B   D6
    BEQ.S   .LAB_191F

    MOVEQ   #10,D1
    CMP.L   D1,D7
    BNE.S   .LAB_191F

    MOVEQ   #2,D1
    MOVE.L  D1,-(A7)
    PEA     LAB_1933(PC)
    MOVE.L  28(A3),-(A7)
    MOVE.L  D1,-16(A5)
    JSR     LAB_1A34(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5
    BRA.S   .LAB_1920

.LAB_191F:
    MOVEQ   #1,D1
    MOVE.L  D1,-(A7)
    PEA     -1(A5)
    MOVE.L  28(A3),-(A7)
    MOVE.L  D1,-16(A5)
    JSR     LAB_1A34(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5

.LAB_1920:
    MOVEQ   #-1,D7
    BRA.W   .LAB_1928

.LAB_1921:
    BSET    #1,27(A3)
    TST.B   D6
    BEQ.S   .LAB_1924

    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BEQ.S   .LAB_1924

    ADDQ.L  #2,12(A3)
    MOVEQ   #10,D1
    CMP.L   D1,D7
    BNE.S   .LAB_1923

    MOVEA.L 4(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,4(A3)
    MOVE.B  #$d,(A0)
    MOVE.L  12(A3),D1
    TST.L   D1
    BMI.S   .LAB_1922

    MOVE.L  A3,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_1916

    ADDQ.W  #8,A7

.LAB_1922:
    ADDQ.L  #1,12(A3)

.LAB_1923:
    MOVEA.L 4(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,4(A3)
    MOVE.L  D7,D0
    MOVE.B  D0,(A0)
    MOVE.L  12(A3),D1
    TST.L   D1
    BMI.W   .return

    MOVEQ   #-1,D7

.LAB_1924:
    MOVE.L  4(A3),D0
    SUB.L   16(A3),D0
    MOVE.L  D0,-16(A5)
    BEQ.S   .LAB_1927

    BTST    #6,26(A3)
    BEQ.S   .LAB_1926

    PEA     2.W
    CLR.L   -(A7)
    MOVE.L  28(A3),-(A7)
    JSR     LAB_19B3(PC)

    LEA     12(A7),A7
    MOVE.L  D0,-20(A5)
    TST.B   D6
    BEQ.S   .LAB_1926

.LAB_1925:
    SUBQ.L  #1,-20(A5)
    BLT.S   .LAB_1926

    CLR.L   -(A7)
    MOVE.L  -20(A5),-(A7)
    MOVE.L  28(A3),-(A7)
    JSR     LAB_19B3(PC)

    PEA     1.W
    PEA     -3(A5)
    MOVE.L  28(A3),-(A7)
    JSR     LAB_1AA9(PC)

    LEA     24(A7),A7
    TST.L   -640(A4)
    BNE.S   .LAB_1926

    MOVE.B  -3(A5),D0
    MOVEQ   #26,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_1925

.LAB_1926:
    MOVE.L  -16(A5),-(A7)
    MOVE.L  16(A3),-(A7)
    MOVE.L  28(A3),-(A7)
    JSR     LAB_1A34(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5
    BRA.S   .LAB_1928

.LAB_1927:
    MOVEQ   #0,D5

.LAB_1928:
    MOVEQ   #-1,D0
    CMP.L   D0,D5
    BNE.S   .LAB_1929

    BSET    #5,27(A3)
    BRA.S   .LAB_192A

.LAB_1929:
    CMP.L   -16(A5),D5
    BEQ.S   .LAB_192A

    BSET    #4,27(A3)

.LAB_192A:
    TST.B   D6
    BEQ.S   .LAB_192B

    MOVE.L  20(A3),D1
    MOVE.L  D1,D2
    NEG.L   D2
    MOVE.L  D2,12(A3)
    BRA.S   .LAB_192D

.LAB_192B:
    BTST    #2,27(A3)
    BEQ.S   .LAB_192C

    MOVEQ   #0,D1
    MOVE.L  D1,12(A3)
    BRA.S   .LAB_192D

.LAB_192C:
    MOVE.L  20(A3),D1
    MOVE.L  D1,12(A3)

.LAB_192D:
    MOVEA.L 16(A3),A0
    MOVE.L  A0,4(A3)
    CMP.L   D0,D7
    BEQ.S   .LAB_192F

    SUBQ.L  #1,12(A3)
    BLT.S   .LAB_192E

    MOVEA.L 4(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,4(A3)
    MOVE.L  D7,D0
    MOVE.B  D0,(A0)
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .LAB_192F

.LAB_192E:
    MOVE.L  D7,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  A3,-(A7)
    MOVE.L  D1,-(A7)
    BSR.W   LAB_1916

    ADDQ.W  #8,A7
    MOVE.L  D0,D1

.LAB_192F:
    MOVEQ   #48,D0
    AND.L   24(A3),D0
    BEQ.S   .LAB_1930

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_1930:
    MOVEQ   #-1,D0
    CMP.L   D0,D4
    BNE.S   .LAB_1931

    MOVEQ   #0,D0
    BRA.S   .return

.LAB_1931:
    MOVE.L  D4,D0

.return:
    MOVEM.L (A7)+,D2/D4-D7/A3
    UNLK    A5
    RTS

;!======

LAB_1933:
    MOVEP.W 0(A2),D6
    DC.W    $0000

;!======

LAB_1934:
    MOVEM.L D5-D7/A3,-(A7)

    SetOffsetForStack 4

    MOVEA.L .stackOffsetBytes+4(A7),A3
    BTST    #7,26(A3)
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D7
    MOVEQ   #48,D0
    AND.L   24(A3),D0
    BEQ.S   .LAB_1935

    CLR.L   8(A3)
    MOVEQ   #-1,D0
    BRA.W   .return

.LAB_1935:
    BTST    #7,27(A3)
    BEQ.S   .LAB_1936

    BTST    #6,27(A3)
    BEQ.S   .LAB_1936

    MOVE.L  A3,-(A7)
    PEA     -1.W
    JSR     LAB_1916(PC)

    ADDQ.W  #8,A7

.LAB_1936:
    TST.L   20(A3)
    BNE.S   .LAB_1938

    CLR.L   8(A3)
    BTST    #2,27(A3)
    BEQ.S   .LAB_1937

    MOVEQ   #1,D0
    MOVE.L  D0,20(A3)
    LEA     32(A3),A0
    MOVE.L  A0,16(A3)
    BRA.W   .LAB_193C

.LAB_1937:
    MOVE.L  A3,-(A7)
    JSR     LAB_1A8E(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .LAB_193C

    BSET    #5,27(A3)
    MOVEQ   #-1,D0
    BRA.W   .return

.LAB_1938:
    TST.B   D7
    BEQ.S   .LAB_193C

    ADDQ.L  #2,8(A3)
    MOVE.L  8(A3),D0
    TST.L   D0
    BGT.S   .LAB_193C

    MOVEA.L 4(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,4(A3)
    MOVEQ   #0,D6
    MOVE.B  (A0),D6
    MOVE.L  D6,D0
    CMPI.L  #$1a,D0
    BEQ.S   .LAB_193A

    CMPI.L  #$d,D0
    BNE.S   .LAB_193B

    SUBQ.L  #1,8(A3)
    BLT.S   .LAB_1939

    MOVEA.L 4(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,4(A3)
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    BRA.W   .return

.LAB_1939:
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1934

    ADDQ.W  #4,A7
    BRA.W   .return

.LAB_193A:
    BSET    #4,27(A3)
    MOVEQ   #-1,D0
    BRA.W   .return

.LAB_193B:
    MOVE.L  D6,D0
    BRA.W   .return

.LAB_193C:
    BTST    #1,27(A3)
    BNE.S   .LAB_1941

    BSET    #0,27(A3)
    MOVE.L  20(A3),-(A7)
    MOVE.L  16(A3),-(A7)
    MOVE.L  28(A3),-(A7)
    JSR     LAB_1AA9(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5
    TST.L   D5
    BPL.S   .LAB_193D

    BSET    #5,27(A3)

.LAB_193D:
    TST.L   D5
    BNE.S   .LAB_193E

    BSET    #4,27(A3)

.LAB_193E:
    TST.L   D5
    BLE.S   .LAB_1941

    TST.B   D7
    BEQ.S   .LAB_193F

    MOVE.L  D5,D0
    NEG.L   D0
    MOVE.L  D0,8(A3)
    BRA.S   .LAB_1940

.LAB_193F:
    MOVE.L  D5,8(A3)

.LAB_1940:
    MOVEA.L 16(A3),A0
    MOVE.L  A0,4(A3)

.LAB_1941:
    MOVEQ   #50,D0
    AND.L   24(A3),D0
    BEQ.S   .LAB_1944

    TST.B   D7
    BEQ.S   .LAB_1942

    MOVEQ   #-1,D0
    MOVE.L  D0,8(A3)
    BRA.S   .LAB_1943

.LAB_1942:
    MOVEQ   #0,D0
    MOVE.L  D0,8(A3)

.LAB_1943:
    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_1944:
    SUBQ.L  #1,8(A3)
    BLT.S   .LAB_1945

    MOVEA.L 4(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,4(A3)
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    BRA.S   .return

.LAB_1945:
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1934

    ADDQ.W  #4,A7

.return:
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!=====

REPLACE_LOWER_CASE_LETTER_WITH_SPACE:
    MOVE.L  4(A7),D0

    CMPI.B  #'a',D0
    BLT.S   .return

    CMPI.B  #'z',D0
    BGT.S   .return

    SUBI.B  #' ',D0

.return:
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_1949:
    MOVEM.L D2/A2-A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEA.L A3,A2

.LAB_194A:
    TST.B   (A2)
    BEQ.S   .return

    MOVEQ   #0,D0
    MOVE.B  (A2),D0
    LEA     -1007(A4),A0
    BTST    #1,0(A0,D0.L)
    BEQ.S   .LAB_194B

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #32,D2
    SUB.L   D2,D1
    BRA.S   .LAB_194C

.LAB_194B:
    MOVEQ   #0,D1
    MOVE.B  D0,D1

.LAB_194C:
    MOVE.B  D1,(A2)
    ADDQ.L  #1,A2
    BRA.S   .LAB_194A

.return:
    MOVE.L  A3,D0
    MOVEM.L (A7)+,D2/A2-A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_194E:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A2-A3,-(A7)

    MOVEA.L 28(A7),A3
    MOVEA.L 32(A7),A2
    MOVE.L  36(A7),D7

.LAB_194F:
    TST.L   D7
    BEQ.S   .LAB_1951

    TST.B   (A3)
    BEQ.S   .LAB_1951

    TST.B   (A2)
    BEQ.S   .LAB_1951

    MOVEQ   #0,D0
    MOVE.B  (A3)+,D0
    MOVE.L  D0,-(A7)
    JSR     REPLACE_LOWER_CASE_LETTER_WITH_SPACE(PC)

    MOVEQ   #0,D1
    MOVE.B  (A2)+,D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,20(A7)
    JSR     REPLACE_LOWER_CASE_LETTER_WITH_SPACE(PC)

    ADDQ.W  #4,A7
    MOVE.L  16(A7),D1
    SUB.L   D0,D1
    MOVE.L  D1,D6
    TST.L   D6
    BEQ.S   .LAB_1950

    MOVE.L  D6,D0
    BRA.S   .return

.LAB_1950:
    SUBQ.L  #1,D7
    BRA.S   .LAB_194F

.LAB_1951:
    TST.L   D7
    BEQ.S   .LAB_1953

    TST.B   (A3)
    BEQ.S   .LAB_1952

    MOVEQ   #1,D0

    BRA.S   .return

.LAB_1952:
    TST.B   (A2)
    BEQ.S   .LAB_1953

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_1953:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_1955:
    MOVEA.L 8(A7),A1
    MOVEA.L 4(A7),A0
    MOVE.L  12(A7),D0
    MOVE.L  A0,D1
    BRA.S   .LAB_1957

.LAB_1956:
    MOVE.B  (A1)+,(A0)+
    BEQ.S   .LAB_1959

.LAB_1957:
    SUBQ.L  #1,D0
    BCC.S   .LAB_1956

    BRA.S   .return

.LAB_1958:
    CLR.B   (A0)+

.LAB_1959:
    SUBQ.L  #1,D0
    BCC.S   .LAB_1958

.return:
    MOVE.L  D1,D0
    RTS

;!======

LAB_195B:
    MOVEM.L D6-D7/A2-A3,-(A7)

    SetOffsetForStack 4

    MOVEA.L .stackOffsetBytes+4(A7),A3
    MOVEA.L .stackOffsetBytes+8(A7),A2
    MOVE.L  .stackOffsetBytes+12(A7),D7

.LAB_195C:
    TST.L   D7
    BEQ.S   .LAB_195E

    TST.B   (A3)
    BEQ.S   .LAB_195E

    TST.B   (A2)
    BEQ.S   .LAB_195E

    MOVEQ   #0,D0
    MOVE.B  (A3)+,D0
    MOVEQ   #0,D1
    MOVE.B  (A2)+,D1
    SUB.L   D1,D0
    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   .LAB_195D

    MOVE.L  D6,D0
    BRA.S   .return

.LAB_195D:
    SUBQ.L  #1,D7
    BRA.S   .LAB_195C

.LAB_195E:
    TST.L   D7
    BEQ.S   .LAB_1960

    TST.B   (A3)
    BEQ.S   .LAB_195F

    MOVEQ   #1,D0
    BRA.S   .return

.LAB_195F:
    TST.B   (A2)
    BEQ.S   .LAB_1960

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_1960:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

LAB_1962:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A2-A3,-(A7)

    SetOffsetForStackAfterLink 8,4

    MOVEA.L .stackOffsetBytes+4(A7),A3
    MOVEA.L .stackOffsetBytes+8(A7),A2
    MOVE.L  .stackOffsetBytes+12(A7),D7
    MOVEA.L A2,A0

.LAB_1963:
    TST.B   (A0)+
    BNE.S   .LAB_1963

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,D6
    MOVEA.L A3,A0

.LAB_1964:
    TST.B   (A0)+
    BNE.S   .LAB_1964

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D0
    MOVEA.L A3,A1
    ADDA.L  D0,A1
    MOVE.L  A1,-8(A5)
    CMP.L   D7,D6
    BLS.S   .LAB_1965

    MOVE.L  D7,D6

.LAB_1965:
    MOVE.L  D6,D0
    MOVEA.L A2,A0
    BRA.S   .LAB_1967

.LAB_1966:
    MOVE.B  (A0)+,(A1)+

.LAB_1967:
    SUBQ.L  #1,D0
    BCC.S   .LAB_1966

    MOVEA.L -8(A5),A0
    CLR.B   0(A0,D6.L)
    MOVE.L  A3,D0

    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_1968:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVEQ   #0,D0
    MOVEQ   #0,D1

.LAB_1969:
    MOVE.B  (A0)+,D0
    MOVE.B  (A1)+,D1
    CMPI.B  #$61,D0
    BLT.S   .LAB_196A

    CMPI.B  #$7a,D0
    BGT.S   .LAB_196A

    SUBI.B  #$20,D0

.LAB_196A:
    CMPI.B  #$61,D1
    BLT.S   .LAB_196B

    CMPI.B  #$7a,D1
    BGT.S   .LAB_196B

    SUBI.B  #$20,D1

.LAB_196B:
    SUB.L   D1,D0
    BNE.S   .return

    TST.B   D1
    BNE.S   .LAB_1969

.return:
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

APPEND_DATA_AT_NULL:
    MOVEA.L 8(A7),A1
    MOVEA.L 4(A7),A0
    MOVE.L  A0,D0

.findFirstNullByte:
    TST.B   (A0)+
    BNE.S   .findFirstNullByte

    SUBQ.L  #1,A0

.copyUntilNull:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .copyUntilNull

    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_1970:
    LINK.W  A5,#-8
    MOVEM.L D5-D7/A2-A3,-(A7)

    MOVEA.L 36(A7),A3
    MOVE.L  44(A7),D7
    MOVEA.L 48(A7),A2
    MOVEQ   #0,D6

.LAB_1971:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    CMP.L   D0,D6
    BGE.S   .LAB_1974

    TST.B   0(A3,D6.L)
    BEQ.S   .LAB_1974

    MOVEQ   #0,D5

.LAB_1972:
    TST.B   0(A2,D5.L)
    BEQ.S   .LAB_1973

    MOVE.B  0(A3,D6.L),D0
    CMP.B   0(A2,D5.L),D0
    BEQ.S   .LAB_1973

    ADDQ.L  #1,D5
    BRA.S   .LAB_1972

.LAB_1973:
    TST.B   0(A2,D5.L)
    BNE.S   .LAB_1974

    MOVEA.L 12(A5),A0
    MOVE.B  0(A3,D6.L),0(A0,D6.L)
    ADDQ.L  #1,D6
    BRA.S   .LAB_1971

.LAB_1974:
    MOVEA.L 12(A5),A0
    CLR.B   0(A0,D6.L)
    MOVEA.L A3,A0
    ADDA.L  D6,A0
    MOVE.L  A0,D0

    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_1975:
    MOVEM.L D7/A3,-(A7)

    MOVEA.L 12(A7),A3
    MOVE.L  16(A7),D7

.LAB_1976:
    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    CMP.L   D7,D0
    BNE.S   .LAB_1977

    MOVE.L  A3,D0
    BRA.S   .return

.LAB_1977:
    MOVE.B  (A3)+,D0
    TST.B   D0
    BNE.S   .LAB_1976

    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

LAB_1979:
    MOVEM.L D7/A3,-(A7)

    MOVEA.L 12(A7),A3
    MOVE.L  16(A7),D7
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.S   LAB_1975

    ADDQ.W  #8,A7

    MOVEM.L (A7)+,D7/A3
    RTS

;!======

    ; Dead code
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.L  20(A7),D7
    SUBA.L  A2,A2

LAB_197A:
    TST.B   (A3)
    BEQ.S   .return

    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    CMP.L   D7,D0
    BNE.S   .LAB_197B

    MOVEA.L A3,A2

.LAB_197B:
    ADDQ.L  #1,A3
    BRA.S   LAB_197A

.return:
    MOVE.L  A2,D0
    MOVEM.L (A7)+,D7/A2-A3
    RTS

;!======

LAB_197D:
    LINK.W  A5,#-4
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEA.L 24(A7),A2

.LAB_197E:
    TST.B   (A3)
    BEQ.S   .LAB_1982

    MOVE.L  A2,-4(A5)

.LAB_197F:
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   .LAB_1981

    MOVE.B  (A0),D0
    CMP.B   (A3),D0
    BNE.S   .LAB_1980

    MOVE.L  A3,D0
    BRA.S   .return

.LAB_1980:
    ADDQ.L  #1,-4(A5)
    BRA.S   .LAB_197F

.LAB_1981:
    ADDQ.L  #1,A3
    BRA.S   .LAB_197E

.LAB_1982:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======

LAB_1984:
    MOVEM.L A2-A3,-(A7)

    MOVEA.L 12(A7),A3
    MOVEA.L 16(A7),A2
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.S   LAB_197D

    ADDQ.W  #8,A7

    MOVEM.L (A7)+,A2-A3
    RTS

;!======

LAB_1985:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3

.LAB_1986:
    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    LEA     -1007(A4),A0
    BTST    #3,0(A0,D0.L)
    BEQ.S   .LAB_1987

    ADDQ.L  #1,A3
    BRA.S   .LAB_1986

.LAB_1987:
    MOVE.L  A3,D0
    MOVEA.L (A7)+,A3
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000
    MOVEQ   #97,D0

;!======

LAB_1988:
    MOVE.L  8(A7),D0
    MOVEA.L 4(A7),A0
    LINK.W  A5,#-12
    MOVEA.L A7,A1

.LAB_1989:
    MOVEQ   #10,D1
    JSR     LAB_1A0A(PC)

    ADDI.W  #$30,D1
    MOVE.B  D1,(A1)+
    TST.L   D0
    BNE.S   .LAB_1989

    MOVE.L  A1,D0

.LAB_198A:
    MOVE.B  -(A1),(A0)+
    CMPA.L  A1,A7
    BNE.S   .LAB_198A

    CLR.B   (A0)
    SUB.L   A7,D0
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_198B:
    MOVE.L  8(A7),D0
    MOVEA.L 4(A7),A0
    LINK.W  A5,#-12
    MOVEA.L A7,A1

.LAB_198C:
    MOVE.L  D0,D1
    ANDI.W  #7,D1
    ADDI.W  #$30,D1
    MOVE.B  D1,(A1)+
    LSR.L   #3,D0
    BNE.S   .LAB_198C

    MOVE.L  A1,D0

.LAB_198D:
    MOVE.B  -(A1),(A0)+
    CMPA.L  A1,A7
    BNE.S   .LAB_198D

    CLR.B   (A0)
    SUB.L   A7,D0
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_198E:
    DC.W    $3031
    DC.W    $3233
    DC.W    $3435
    MOVE.W  57(A7,D3.L),D3
    BSR.S   LAB_1995

    BLS.S   LAB_1996+2

    BCS.S   LAB_1998

LAB_198F:
    MOVE.L  8(A7),D0
    MOVEA.L 4(A7),A0
    LEA     4(A7),A1

.LAB_1990:
    MOVE.W  D0,D1
    ANDI.W  #15,D1
    MOVE.B  LAB_198E(PC,D1.W),(A1)+
    LSR.L   #4,D0
    BNE.S   .LAB_1990

    MOVE.L  A1,D0
    MOVE.L  A7,D1
    ADDQ.L  #4,D1

.LAB_1991:
    MOVE.B  -(A1),(A0)+
    CMP.L   A1,D1
    BNE.S   .LAB_1991

    CLR.B   (A0)
    SUB.L   D1,D0
    RTS

;!======

LAB_1992:
    MOVEA.L 4(A7),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D1
    MOVEQ   #0,D0
    MOVE.L  D2,-(A7)
    CMPI.B  #$2b,(A0)
    BEQ.S   .LAB_1993

    CMPI.B  #$2d,(A0)
    BNE.S   LAB_1994

.LAB_1993:
    ADDQ.W  #1,A0

LAB_1994:
    MOVE.B  (A0)+,D0
    SUBI.B  #$30,D0
    BLT.S   LAB_1996

    CMPI.B  #$9,D0
    BGT.S   LAB_1996

    MOVE.L  D1,D2
    ASL.L   #2,D1
    ADD.L   D2,D1
    ADD.L   D1,D1
    ADD.L   D0,D1

LAB_1995:
    BRA.S   LAB_1994

LAB_1996:
    CMPI.B  #$2d,(A1)
    BNE.S   LAB_1999

LAB_1998:
    NEG.L   D1

LAB_1999:
    MOVE.L  (A7)+,D2
    MOVE.L  A0,D0
    SUBQ.L  #1,D0
    MOVEA.L 8(A7),A0
    MOVE.L  D1,(A0)
    SUB.L   A1,D0
    RTS

;!======

LAB_199A:
    MOVEA.L 4(A7),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D1
    MOVEQ   #0,D0
    MOVE.L  D2,-(A7)
    CMPI.B  #$2b,(A0)
    BEQ.S   LAB_199B

    CMPI.B  #$2d,(A0)
    BNE.S   LAB_199C

LAB_199B:
    ADDQ.W  #1,A0

LAB_199C:
    MOVE.B  (A0)+,D0
    SUBI.B  #$30,D0
    BLT.S   LAB_199D

    CMPI.B  #$9,D0
    BGT.S   LAB_199D

    MOVE.L  D1,D2
    ASL.L   #2,D1
    ADD.L   D2,D1
    ADD.L   D1,D1
    ADD.L   D0,D1
    BRA.S   LAB_199C

LAB_199D:
    CMPI.B  #$2d,(A1)
    BNE.S   LAB_199E

    NEG.L   D1

LAB_199E:
    MOVE.L  (A7)+,D2
    MOVE.L  A0,D0
    SUBQ.L  #1,D0
    MOVEA.L 8(A7),A0
    MOVE.L  D1,(A0)
    SUB.L   A1,D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: WDISP_PrintfPutc   (PrintfPutcToBuffer)
; ARGS:
;   D0.b: character to append
; RET:
;   (none)
; CLOBBERS:
;   D0, D7
; CALLS:
;   (none)
; READS:
;   22812(A4), 22816(A4)
; WRITES:
;   22812(A4), 22816(A4), [buffer]
; DESC:
;   Appends one byte to the current printf output buffer and advances the cursor.
; NOTES:
;   Uses A4-relative globals for the buffer pointer and byte count.
;------------------------------------------------------------------------------
WDISP_PrintfPutc:
LAB_199F:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7

    ADDQ.L  #1,22816(A4)
    MOVE.L  D7,D0
    MOVEA.L 22812(A4),A0
    MOVE.B  D0,(A0)+
    MOVE.L  A0,22812(A4)

    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: WDISP_SPrintf   (SPrintfToBuffer)
; ARGS:
;   stack +4: outBuf
;   stack +8: formatStr
;   stack +12+: varargs
; RET:
;   D0: bytes written (excluding terminator)
; CLOBBERS:
;   D0, A0, A2-A3
; CALLS:
;   WDISP_FormatWithCallback (core formatter), WDISP_PrintfPutc
; READS:
;   (none)
; WRITES:
;   outBuf, 22812(A4), 22816(A4)
; DESC:
;   Formats into the provided buffer using the local printf core and returns length.
; NOTES:
;   Zero-terminates the output.
;------------------------------------------------------------------------------
WDISP_SPrintf:
PRINTF:
    LINK.W  A5,#0
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEA.L 20(A7),A2

    CLR.L   22816(A4)       ; Clear 22816(A4)
    MOVE.L  A3,22812(A4)
    PEA     16(A5)
    MOVE.L  A2,-(A7)
    PEA     WDISP_PrintfPutc(PC)
    JSR     WDISP_FormatWithCallback(PC)

    MOVEA.L 22812(A4),A0
    CLR.B   (A0)
    MOVE.L  22816(A4),D0    ; Store 22816(A4) in D0

    MOVEM.L -8(A5),A2-A3
    UNLK    A5
    RTS

;!======

LAB_19A1:
    LINK.W  A5,#-26
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 58(A7),A3
    MOVE.L  62(A7),D7

    CLR.B   -1(A5)
    CLR.L   -640(A4)
    MOVE.L  22828(A4),-14(A5)
    MOVEQ   #3,D5

.LAB_19A2:
    CMP.L   -1148(A4),D5
    BGE.S   .LAB_19A3

    MOVE.L  D5,D0
    ASL.L   #3,D0
    LEA     22492(A4),A0
    TST.L   0(A0,D0.L)
    BEQ.S   .LAB_19A3

    ADDQ.L  #1,D5
    BRA.S   .LAB_19A2

.LAB_19A3:
    MOVE.L  -1148(A4),D0
    CMP.L   D5,D0
    BNE.S   .LAB_19A4

    MOVEQ   #24,D0
    MOVE.L  D0,22828(A4)
    MOVEQ   #-1,D0
    BRA.W   .return

.LAB_19A4:
    MOVE.L  D5,D0
    ASL.L   #3,D0
    LEA     22492(A4),A0
    ADDA.L  D0,A0
    MOVEA.L A0,A2
    TST.L   16(A5)
    BEQ.S   .LAB_19A5

    BTST    #2,19(A5)
    BEQ.S   .LAB_19A6

.LAB_19A5:
    MOVE.L  #$3ec,-18(A5)
    BRA.S   .LAB_19A7

.LAB_19A6:
    MOVE.L  #$3ee,-18(A5)

.LAB_19A7:
    MOVE.L  #$8000,D0
    AND.L   -1124(A4),D0
    EOR.L   D0,D7
    BTST    #3,D7
    BEQ.S   .LAB_19A8

    MOVE.L  D7,D0
    ANDI.W  #$fffc,D0
    MOVE.L  D0,D7
    ORI.W   #2,D7

.LAB_19A8:
    MOVE.L  D7,D0
    MOVEQ   #3,D1
    AND.L   D1,D0
    CMPI.L  #$2,D0
    BEQ.S   .LAB_19A9

    CMPI.L  #$1,D0
    BEQ.S   .LAB_19A9

    TST.L   D0
    BNE.S   .LAB_19AA

.LAB_19A9:
    MOVE.L  D7,D6
    ADDQ.L  #1,D6
    BRA.S   .LAB_19AB

.LAB_19AA:
    MOVEQ   #22,D0
    MOVE.L  D0,22828(A4)
    MOVEQ   #-1,D0
    BRA.W   .return

.LAB_19AB:
    MOVE.L  D7,D0
    ANDI.L  #$300,D0
    BEQ.W   .LAB_19AF

    BTST    #10,D7
    BEQ.S   .LAB_19AC

    MOVE.B  #$1,-1(A5)
    MOVE.L  -18(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_19FA(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D4
    BRA.S   .LAB_19AE

.LAB_19AC:
    BTST    #9,D7
    BNE.S   .LAB_19AD

    PEA     1005.W
    MOVE.L  A3,-(A7)
    JSR     LAB_19F3(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D4
    TST.L   D4
    BPL.S   .LAB_19AD

    BSET    #9,D7

.LAB_19AD:
    BTST    #9,D7
    BEQ.S   .LAB_19AE

    MOVE.B  #$1,-1(A5)
    MOVE.L  -14(A5),22828(A4)
    MOVE.L  -18(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_19FF(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D4

.LAB_19AE:
    TST.B   -1(A5)
    BEQ.S   .LAB_19B0

    MOVE.L  D7,D0
    MOVEQ   #120,D1
    ADD.L   D1,D1
    AND.L   D1,D0
    TST.L   D0
    BEQ.S   .LAB_19B0

    TST.L   D4
    BMI.S   .LAB_19B0

    MOVE.L  D4,-(A7)
    JSR     LAB_1A04(PC)

    PEA     1005.W
    MOVE.L  A3,-(A7)
    JSR     LAB_19F3(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D4
    BRA.S   .LAB_19B0

.LAB_19AF:
    PEA     1005.W
    MOVE.L  A3,-(A7)
    JSR     LAB_19F3(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D4

.LAB_19B0:
    TST.L   -640(A4)
    BEQ.S   .LAB_19B1

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_19B1:
    MOVE.L  D6,(A2)
    MOVE.L  D4,4(A2)
    MOVE.L  D5,D0

.return:
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000
    MOVEQ   #97,D0

;!======

LAB_19B3:
    MOVEM.L D4-D7/A3,-(A7)
    MOVE.L  24(A7),D7
    MOVE.L  28(A7),D6
    MOVE.L  32(A7),D5
    MOVE.L  D7,-(A7)
    JSR     LAB_1A1D(PC)

    ADDQ.W  #4,A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BNE.S   .LAB_19B4

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_19B4:
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  4(A3),-(A7)
    JSR     LAB_19EA(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D4
    TST.L   -640(A4)
    BEQ.S   .LAB_19B5

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_19B5:
    MOVE.L  D4,D0

.return:
    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!=====

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

;!======
