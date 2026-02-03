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
    JSR     GROUP_BA_JMPTBL_BRUSH_FindBrushByPredicate(PC)

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
    JSR     GROUP_BA_JMPTBL_BRUSH_FindBrushByPredicate(PC)

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
    JSR     GROUPD_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  184(A0),D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,-184(A5)
    JSR     GROUPD_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

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
    JSR     GROUP_BA_JMPTBL_BRUSH_SelectBrushSlot(PC)

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
    JSR     GROUPD_JMPTBL_LAB_09E2(PC)

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
    JSR     GROUPD_JMPTBL_LAB_09E2(PC)

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
    JSR     MEMORY_DeallocateMemory(PC)

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
    JSR     GROUP_BA_JMPTBL_BRUSH_FindBrushByPredicate(PC)

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
    JSR     GROUPD_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVEQ   #0,D0
    MOVEA.L -104(A5),A0
    MOVE.B  184(A0),D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,-76(A5)
    JSR     GROUPD_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

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
    JSR     GROUP_BA_JMPTBL_BRUSH_SelectBrushSlot(PC)

    LEA     28(A7),A7
    BRA.S   .LAB_188E

.LAB_188D:
    JSR     GROUPD_JMPTBL_LAB_0A45(PC)

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
    JSR     UNKNOWN6_AppendDataAtNull(PC)

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
    JSR     GROUP_BA_JMPTBL_LAB_0FFB(PC)

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
    JSR     GROUP_BA_JMPTBL_LAB_0FFB(PC)

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
    JSR     GROUP_BA_JMPTBL_LAB_0FFB(PC)

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
    LEA     GLOB_JMPTBL_DAYS_OF_WEEK,A0
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
    JSR     GROUP_BA_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEQ   #0,D6
    MOVEA.L LAB_2216,A1
    MOVE.W  4(A1),D6
    MOVEQ   #0,D5
    MOVE.W  2(A1),D5
    MOVE.L  A0,.localRastport(A5)
    JSR     GROUPD_JMPTBL_LAB_0A45(PC)

    JSR     GROUPD_JMPTBL_LAB_0A49(PC)

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
    JSR     GROUP_BA_JMPTBL_BRUSH_FindBrushByPredicate(PC)

    MOVE.L  D0,(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-6(A5)
    JSR     GROUPD_JMPTBL_LAB_0A00(PC)

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
    JSR     GROUPD_JMPTBL_LAB_0A00(PC)

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
    JSR     GROUPD_JMPTBL_LAB_0D75(PC)

    MOVE.L  A2,(A7)
    JSR     GROUPD_JMPTBL_LAB_102C(PC)

    ADDQ.W  #4,A7
    BRA.S   .LAB_18C6

.LAB_18C5:
    MOVEQ   #7,D0
    CMP.L   LAB_2194,D0
    BNE.S   .LAB_18C6

    MOVE.L  LAB_1B25,-(A7)
    MOVE.L  A2,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0A00(PC)

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
    JSR     GROUPD_JMPTBL_BRUSH_FreeBrushList(PC)

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
    JSR     GROUPD_JMPTBL_LAB_09F9(PC)

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

GROUPD_JMPTBL_LAB_0A45:
    JMP     LAB_0A45

GROUPD_JMPTBL_LAB_09E2:
    JMP     LAB_09E2

GROUPD_JMPTBL_LAB_0D75:
    JMP     LAB_0D75

GROUPD_JMPTBL_LAB_09F9:
    JMP     LAB_09F9

GROUPD_JMPTBL_LAB_0A49:
    JMP     LAB_0A49

GROUP_BA_JMPTBL_BRUSH_FindBrushByPredicate:
    JMP     BRUSH_FindBrushByPredicate

GROUPD_JMPTBL_BRUSH_FreeBrushList:
    JMP     BRUSH_FreeBrushList

GROUPD_JMPTBL_BRUSH_PlaneMaskForIndex:
    JMP     BRUSH_PlaneMaskForIndex

GROUP_BA_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight:
    JMP     ESQ_SetCopperEffect_OnEnableHighlight

GROUPD_JMPTBL_LAB_0A00:
    JMP     LAB_0A00

GROUP_BA_JMPTBL_BRUSH_SelectBrushSlot:
    JMP     BRUSH_SelectBrushSlot

GROUP_BA_JMPTBL_LAB_0FFB:
    JMP     LAB_0FFB

GROUPD_JMPTBL_LAB_102C:
    JMP     LAB_102C

;!======

    ; Alignment
    MOVEQ   #97,D0
