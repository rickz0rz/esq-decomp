;!======

; INI loading?
;------------------------------------------------------------------------------
; FUNC: PARSE_INI   (Parse INI-like configuration file??)
; ARGS:
;   stack +8: A3 = pointer to buffer/string to parse
; RET:
;   D0: -1 on failure, 0/?? on success
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   LAB_1465, LAB_145C, LAB_1455, LAB_1462, JMP_TBL_LAB_1968_3, LAB_1667, LAB_146B,
;   LAB_145B, LAB_1456/1457/1458..., LAB_13E6/LAB_1400/LAB_1404/LAB_1408 helpers
; READS:
;   LAB_21BC, LAB_21A8 (char class table), many LAB_205* globals, LAB_1B1F, LAB_233D
; WRITES:
;   LAB_2059-2064/206A..., LAB_1DDA, LAB_2073, LAB_233D, LAB_206D, LAB_205A-C, etc.
; DESC:
;   Top-level INI parser: scans the buffer, skips whitespace/comment chars, detects
;   section headers and key/value pairs, and dispatches to per-section handlers.
; NOTES:
;   Uses BRACKETED sections '['...']', lower-level helpers validate/allocate strings.
;------------------------------------------------------------------------------
PARSE_INI:
    LINK.W  A5,#-44
    MOVEM.L D5-D7/A2-A3,-(A7)

    MOVEA.L 8(A5),A3

    MOVEQ   #0,D7
    MOVEQ   #-1,D5
    MOVE.L  A3,-(A7)
    JSR     LAB_1465(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BNE.S   .LAB_139C

    MOVEQ   #-1,D0
    BRA.W   .return

.LAB_139C:
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D6
    MOVE.L  LAB_21BC,-16(A5)

.LAB_139D:
    JSR     LAB_145C(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-8(A5)
    CMP.L   A0,D0
    BEQ.W   .LAB_13D2

.LAB_139E:
    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.B  (A0),D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .LAB_139F

    ADDQ.L  #1,-8(A5)
    BRA.S   .LAB_139E

.LAB_139F:
    MOVEQ   #91,D0
    MOVEA.L -8(A5),A0
    CMP.B   (A0),D0
    BNE.W   .LAB_13A8

    LEA     1(A0),A1
    PEA     93.W
    MOVE.L  A1,-(A7)
    JSR     LAB_1455(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-28(A5)
    TST.L   D0
    BEQ.S   .LAB_139D

    MOVEA.L D0,A0
    CLR.B   (A0)
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     LAB_205D
    MOVE.L  A0,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .LAB_13A0

    MOVEQ   #1,D7
    BRA.S   .LAB_139D

.LAB_13A0:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     LAB_205E
    MOVE.L  A0,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .LAB_13A1

    MOVEQ   #2,D7
    BRA.W   .LAB_139D

.LAB_13A1:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     LAB_205F
    MOVE.L  A0,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .LAB_13A2

    MOVEQ   #3,D7
    PEA     LAB_233F
    JSR     LAB_1462(PC)

    ADDQ.W  #4,A7
    BRA.W   .LAB_139D

.LAB_13A2:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     LAB_2060
    MOVE.L  A0,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .LAB_13A3

    MOVEQ   #4,D7
    BRA.W   .LAB_139D

.LAB_13A3:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     LAB_2061
    MOVE.L  A0,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .LAB_13A4

    MOVEQ   #5,D7
    BRA.W   .LAB_139D

.LAB_13A4:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     LAB_2062
    MOVE.L  A0,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .LAB_13A5

    MOVEQ   #6,D7
    CLR.L   LAB_2059
    BRA.W   .LAB_139D

.LAB_13A5:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     LAB_2063
    MOVE.L  A0,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .LAB_13A6

    MOVEQ   #7,D7
    MOVE.L  LAB_205A,-(A7)
    MOVE.L  GLOB_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE,-(A7)
    JSR     LAB_146B(PC)

    MOVE.L  D0,LAB_205A
    MOVE.L  LAB_205B,(A7)
    MOVE.L  LAB_20B0,-(A7)
    JSR     LAB_146B(PC)

    MOVE.L  D0,LAB_205B
    MOVE.L  LAB_205C,(A7)
    MOVE.L  LAB_20B2,-(A7)
    JSR     LAB_146B(PC)

    LEA     16(A7),A7
    MOVE.L  D0,LAB_205C
    BRA.W   .LAB_139D

.LAB_13A6:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     LAB_2064
    MOVE.L  A0,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .LAB_13A7

    JSR     LAB_1667(PC)

    MOVEQ   #8,D7
    BRA.W   .LAB_139D

.LAB_13A7:
    MOVEQ   #0,D7
    BRA.W   .LAB_139D

.LAB_13A8:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    BLT.W   .LAB_139D

    CMPI.L  #$8,D0
    BGE.W   .LAB_139D

    ADD.W   D0,D0
    MOVE.W  .LAB_13A9(PC,D0.W),D0
    JMP     .LAB_13A9+2(PC,D0.W)

; switch/jumptable
.LAB_13A9:
    DC.W    .LAB_13A9_000E-.LAB_13A9-2
    DC.W    .LAB_13B3_0176-.LAB_13A9-2
    DC.W    .LAB_13B9_0222-.LAB_13A9-2
    DC.W    .LAB_13B9_0236-.LAB_13A9-2
    DC.W    .LAB_13B9_0236-.LAB_13A9-2
    DC.W    .LAB_13BF_02E6-.LAB_13A9-2
	DC.W    .LAB_13C5_0392-.LAB_13A9-2
    DC.W    .LAB_13CB_043E-.LAB_13A9-2

.LAB_13A9_000E:
    PEA     61.W
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_1455(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-32(A5)
    BEQ.W   .LAB_13B3

    MOVEA.L D0,A0
    CLR.B   (A0)+
    MOVE.L  A0,-32(A5)

.LAB_13AB:
    MOVEA.L -32(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .LAB_13AC

    ADDQ.L  #1,-32(A5)
    BRA.S   .LAB_13AB

.LAB_13AC:
    PEA     LAB_2065
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_1469(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-36(A5)
    TST.L   D0
    BEQ.S   .LAB_13AD

    MOVEA.L D0,A0
    CLR.B   (A0)

.LAB_13AD:
    MOVEA.L -32(A5),A0

.LAB_13AE:
    TST.B   (A0)+
    BNE.S   .LAB_13AE

    SUBQ.L  #1,A0
    SUBA.L  -32(A5),A0
    MOVE.L  A0,D0
    MOVEA.L -32(A5),A1
    ADDA.L  D0,A1
    SUBQ.L  #1,A1
    MOVE.L  A1,-36(A5)

.LAB_13AF:
    MOVEA.L -36(A5),A0
    CMPA.L  -32(A5),A0
    BLS.S   .LAB_13B0

    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .LAB_13B0

    CLR.B   (A0)
    SUBQ.L  #1,-36(A5)
    BRA.S   .LAB_13AF

.LAB_13B0:
    ADDQ.L  #1,D5
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     LAB_224F,A0
    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     8.W
    PEA     219.W
    PEA     GLOB_STR_PARSEINI_C_1
    MOVE.L  A0,36(A7)
    JSR     GROUPD_JMP_TBL_MEMORY_AllocateMemory(PC)

    MOVEA.L 36(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     LAB_224F,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    SUBA.L  A0,A0
    MOVE.L  A0,(A2)
    MOVE.L  A0,4(A2)
    MOVE.L  (A2),(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_146B(PC)

    MOVE.L  D0,(A2)
    PEA     34.W
    MOVE.L  -32(A5),-(A7)
    JSR     LAB_1455(PC)

    LEA     28(A7),A7
    MOVE.L  D0,-40(A5)
    TST.L   D0
    BNE.S   .LAB_13B1

    CLR.W   LAB_1DDA
    MOVEQ   #0,D0
    BRA.W   .return

.LAB_13B1:
    MOVEA.L D0,A0
    ADDQ.L  #1,A0
    MOVE.L  A0,-32(A5)
    PEA     34.W
    MOVE.L  -32(A5),-(A7)
    JSR     LAB_1455(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-40(A5)
    TST.L   D0
    BNE.S   .LAB_13B2

    CLR.W   LAB_1DDA

    MOVEQ   #0,D0
    BRA.W   .return

.LAB_13B2:
    MOVEA.L D0,A0
    CLR.B   (A0)
    MOVE.L  4(A2),-(A7)
    MOVE.L  -32(A5),-(A7)
    JSR     LAB_146B(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,4(A2)
    MOVE.L  D5,D0
    ADDQ.L  #1,D0
    MOVE.W  D0,LAB_1DDA
    BRA.W   .LAB_139D

.LAB_13B3:
    CLR.W   LAB_1DDA
    BRA.W   .LAB_139D

.LAB_13B3_0176:
    PEA     61.W
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_1455(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-32(A5)
    BEQ.W   .LAB_139D

    MOVEA.L D0,A0
    CLR.B   (A0)+
    MOVE.L  A0,-32(A5)

.LAB_13B4:
    MOVEA.L -32(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .LAB_13B5

    ADDQ.L  #1,-32(A5)
    BRA.S   .LAB_13B4

.LAB_13B5:
    PEA     LAB_2067
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_1469(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-36(A5)
    TST.L   D0
    BEQ.S   .LAB_13B6

    MOVEA.L D0,A0
    CLR.B   (A0)

.LAB_13B6:
    MOVEA.L -32(A5),A0

.LAB_13B7:
    TST.B   (A0)+
    BNE.S   .LAB_13B7

    SUBQ.L  #1,A0
    SUBA.L  -32(A5),A0
    MOVE.L  A0,D0
    MOVEA.L -32(A5),A1
    ADDA.L  D0,A1
    SUBQ.L  #1,A1
    MOVE.L  A1,-36(A5)

.LAB_13B8:
    MOVEA.L -36(A5),A0
    CMPA.L  -32(A5),A0
    BLS.S   .LAB_13B9

    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .LAB_13B9

    CLR.B   (A0)
    SUBQ.L  #1,-36(A5)
    BRA.S   .LAB_13B8

.LAB_13B9:
    MOVE.L  -32(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    BSR.W   LAB_13E6

    ADDQ.W  #8,A7
    BRA.W   .LAB_139D

.LAB_13B9_0222:
    PEA     LAB_233F
    MOVE.L  -8(A5),-(A7)
    BSR.W   LAB_13D7

    ADDQ.W  #8,A7
    BRA.W   .LAB_139D

.LAB_13B9_0236:
    PEA     61.W
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_1455(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-32(A5)
    BEQ.W   .LAB_139D

    MOVEA.L D0,A0
    CLR.B   (A0)+
    MOVE.L  A0,-32(A5)

.LAB_13BA:
    MOVEA.L -32(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .LAB_13BB

    ADDQ.L  #1,-32(A5)
    BRA.S   .LAB_13BA

.LAB_13BB:
    PEA     LAB_2068
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_1469(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-36(A5)
    TST.L   D0
    BEQ.S   .LAB_13BC

    MOVEA.L D0,A0

    CLR.B   (A0)

.LAB_13BC:
    MOVEA.L -32(A5),A0

.LAB_13BD:
    TST.B   (A0)+
    BNE.S   .LAB_13BD

    SUBQ.L  #1,A0

    SUBA.L  -32(A5),A0
    MOVE.L  A0,D0
    MOVEA.L -32(A5),A1
    ADDA.L  D0,A1
    SUBQ.L  #1,A1
    MOVE.L  A1,-36(A5)

.LAB_13BE:
    MOVEA.L -36(A5),A0
    CMPA.L  -32(A5),A0
    BLS.S   .LAB_13BF

    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .LAB_13BF

    CLR.B   (A0)
    SUBQ.L  #1,-36(A5)
    BRA.S   .LAB_13BE

.LAB_13BF:
    MOVE.L  D7,-(A7)
    MOVE.L  -32(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    BSR.W   LAB_1408

    LEA     12(A7),A7
    BRA.W   .LAB_139D

.LAB_13BF_02E6:
    PEA     61.W
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_1455(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-32(A5)
    BEQ.W   .LAB_139D

    MOVEA.L D0,A0
    CLR.B   (A0)+
    MOVE.L  A0,-32(A5)

.LAB_13C0:
    MOVEA.L -32(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .LAB_13C1

    ADDQ.L  #1,-32(A5)
    BRA.S   .LAB_13C0

.LAB_13C1:
    PEA     LAB_2069
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_1469(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-36(A5)
    TST.L   D0
    BEQ.S   .LAB_13C2

    MOVEA.L D0,A0
    CLR.B   (A0)

.LAB_13C2:
    MOVEA.L -32(A5),A0

.LAB_13C3:
    TST.B   (A0)+
    BNE.S   .LAB_13C3

    SUBQ.L  #1,A0
    SUBA.L  -32(A5),A0
    MOVE.L  A0,D0
    MOVEA.L -32(A5),A1
    ADDA.L  D0,A1
    SUBQ.L  #1,A1
    MOVE.L  A1,-36(A5)

.LAB_13C4:
    MOVEA.L -36(A5),A0
    CMPA.L  -32(A5),A0
    BLS.S   .LAB_13C5

    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .LAB_13C5

    CLR.B   (A0)
    SUBQ.L  #1,-36(A5)
    BRA.S   .LAB_13C4

.LAB_13C5:
    MOVE.L  -32(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    BSR.W   LAB_1400

    ADDQ.W  #8,A7
    BRA.W   .LAB_139D

.LAB_13C5_0392:
    PEA     61.W
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_1455(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-32(A5)
    BEQ.W   .LAB_139D

    MOVEA.L D0,A0
    CLR.B   (A0)+
    MOVE.L  A0,-32(A5)

.LAB_13C6:
    MOVEA.L -32(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .LAB_13C7

    ADDQ.L  #1,-32(A5)
    BRA.S   .LAB_13C6

.LAB_13C7:
    PEA     LAB_206A
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_1469(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-36(A5)
    TST.L   D0
    BEQ.S   .LAB_13C8

    MOVEA.L D0,A0
    CLR.B   (A0)

.LAB_13C8:
    MOVEA.L -32(A5),A0

.LAB_13C9:
    TST.B   (A0)+
    BNE.S   .LAB_13C9

    SUBQ.L  #1,A0
    SUBA.L  -32(A5),A0
    MOVE.L  A0,D0
    MOVEA.L -32(A5),A1
    ADDA.L  D0,A1
    SUBQ.L  #1,A1
    MOVE.L  A1,-36(A5)

.LAB_13CA:
    MOVEA.L -36(A5),A0
    CMPA.L  -32(A5),A0
    BLS.S   .LAB_13CB

    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .LAB_13CB

    CLR.B   (A0)
    SUBQ.L  #1,-36(A5)
    BRA.S   .LAB_13CA

.LAB_13CB:
    MOVE.L  -32(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    BSR.W   LAB_1404

    ADDQ.W  #8,A7
    BRA.W   .LAB_139D

.LAB_13CB_043E:
    PEA     61.W
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_1455(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-32(A5)
    BEQ.W   .LAB_139D

    MOVEA.L D0,A0
    CLR.B   (A0)+
    MOVE.L  A0,-32(A5)

.LAB_13CC:
    MOVEA.L -32(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .LAB_13CD

    ADDQ.L  #1,-32(A5)
    BRA.S   .LAB_13CC

.LAB_13CD:
    PEA     LAB_206B
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_1469(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-36(A5)
    TST.L   D0
    BEQ.S   .LAB_13CE

    MOVEA.L D0,A0
    CLR.B   (A0)

.LAB_13CE:
    MOVEA.L -32(A5),A0

.LAB_13CF:
    TST.B   (A0)+
    BNE.S   .LAB_13CF

    SUBQ.L  #1,A0
    SUBA.L  -32(A5),A0
    MOVE.L  A0,D0
    MOVEA.L -32(A5),A1
    ADDA.L  D0,A1
    SUBQ.L  #1,A1
    MOVE.L  A1,-36(A5)

.LAB_13D0:
    MOVEA.L -36(A5),A0
    CMPA.L  -32(A5),A0
    BLS.S   .LAB_13D1

    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .LAB_13D1

    CLR.B   (A0)
    SUBQ.L  #1,-36(A5)
    BRA.S   .LAB_13D0

.LAB_13D1:
    MOVE.L  -32(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_1675(PC)

    ADDQ.W  #8,A7
    BRA.W   .LAB_139D

.LAB_13D2:
    MOVE.L  D6,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     403.W
    PEA     GLOB_STR_PARSEINI_C_2
    JSR     GROUPD_JMP_TBL_MEMORY_DeallocateMemory(PC)

.return:
    MOVEM.L -64(A5),D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_13D4:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7

LAB_13D5:
    MOVE.L  A3,D0
    BEQ.S   LAB_13D6

    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   LAB_13D6

    ASL.L   #4,D7
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_1598(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    ADD.L   D1,D7
    ADDQ.L  #1,A3
    BRA.S   LAB_13D5

LAB_13D6:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_ParseRangeKeyValue   (Parse range key/value??)
; ARGS:
;   stack +8: A3 = source string pointer
;   stack +12: A2 = output struct pointer
; RET:
;   D0: status (0 = ok, -1 on invalid)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   LAB_1455, LAB_134B, LAB_1469, LAB_1463, LAB_145F, LAB_159A
; READS:
;   LAB_206D, LAB_206E/206F/2070-2072 lookup strings, LAB_223A-D fields
; WRITES:
;   LAB_206D, LAB_206D-indexed output in A2, LAB_206D sentinel when invalid
; DESC:
;   Parses a pair of bracketed numeric fields (two strings), validates them,
;   and writes results into a 16-entry table pointed to by A2.
; NOTES:
;   Uses 61 '=' delimiter; clamps/validates ranges 0..15 for index, 1..999 for value.
;------------------------------------------------------------------------------
PARSEINI_ParseRangeKeyValue:
LAB_13D7:
    LINK.W  A5,#-16
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEA.L A3,A0
    MOVE.L  A0,-4(A5)
    BEQ.S   LAB_13D8

    PEA     61.W
    MOVE.L  A3,-(A7)
    JSR     LAB_1455(PC)

    ADDQ.W  #8,A7
    MOVEA.L D0,A0
    BRA.S   LAB_13D9

LAB_13D8:
    SUBA.L  A0,A0

LAB_13D9:
    MOVE.L  A0,-8(A5)
    TST.L   -4(A5)
    BEQ.S   LAB_13DB

    MOVE.L  A0,D0
    BEQ.S   LAB_13DB

    MOVE.L  -4(A5),-(A7)
    JSR     LAB_134B(PC)

    PEA     LAB_206E
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     LAB_1469(PC)

    LEA     12(A7),A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BEQ.S   LAB_13DA

    MOVEQ   #0,D0
    MOVE.B  D0,(A3)

LAB_13DA:
    MOVEA.L -8(A5),A0
    CLR.B   (A0)+
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-8(A5)
    JSR     LAB_134B(PC)

    PEA     LAB_206F
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-8(A5)
    JSR     LAB_1469(PC)

    LEA     12(A7),A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BEQ.S   LAB_13DB

    CLR.B   (A3)

LAB_13DB:
    TST.L   -4(A5)
    BEQ.W   LAB_13E5

    TST.L   -8(A5)
    BEQ.W   LAB_13E5

    PEA     5.W
    PEA     LAB_2070
    MOVE.L  -4(A5),-(A7)
    JSR     LAB_1463(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   LAB_13DC

    PEA     4.W
    PEA     LAB_2071
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_1463(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   LAB_13DC

    MOVE.L  A2,-(A7)
    JSR     LAB_145F(PC)

    ADDQ.W  #4,A7
    MOVEQ   #-1,D0
    MOVE.L  D0,LAB_206D
    BRA.W   LAB_13E5

LAB_13DC:
    PEA     5.W
    PEA     LAB_2072
    MOVE.L  -4(A5),-(A7)
    JSR     LAB_1463(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.W   LAB_13E4

    MOVEA.L -4(A5),A0
    ADDQ.L  #5,A0
    MOVEQ   #0,D7
    MOVE.L  A0,-12(A5)
    MOVE.L  A0,D0
    BEQ.S   LAB_13DD

    TST.B   (A0)
    BEQ.S   LAB_13DD

    MOVE.L  A0,-(A7)
    JSR     LAB_159A(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7

LAB_13DD:
    TST.W   D7
    BMI.S   LAB_13DE

    MOVEQ   #16,D0
    CMP.W   D0,D7
    BLT.S   LAB_13DF

LAB_13DE:
    MOVEQ   #-1,D0
    MOVE.L  D0,LAB_206D
    BRA.S   LAB_13E0

LAB_13DF:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,LAB_206D
    ADD.L   D0,D0
    CLR.W   0(A2,D0.L)

LAB_13E0:
    MOVE.L  LAB_206D,D0
    TST.L   D0
    BMI.W   LAB_13E5

    MOVEQ   #16,D1
    CMP.L   D1,D0
    BGE.W   LAB_13E5

    MOVE.L  -8(A5),-(A7)
    JSR     LAB_159A(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D6
    MOVEQ   #1,D0
    CMP.W   D0,D6
    BLT.S   LAB_13E1

    MOVEQ   #63,D1
    CMP.W   D1,D6
    BLE.S   LAB_13E2

LAB_13E1:
    MOVEQ   #-1,D6
    BRA.S   LAB_13E3

LAB_13E2:
    ADDQ.W  #1,D6

LAB_13E3:
    MOVE.L  LAB_206D,D0
    MOVE.L  D0,D1
    ADD.L   D1,D1
    MOVE.W  D6,0(A2,D1.L)
    BRA.S   LAB_13E5

LAB_13E4:
    MOVE.L  LAB_206D,D0
    TST.L   D0
    BMI.S   LAB_13E5

    MOVEQ   #16,D1
    CMP.L   D1,D0
    BGE.S   LAB_13E5

    ADD.L   D0,D0
    MOVE.W  0(A2,D0.L),D1
    TST.W   D1
    BLE.S   LAB_13E5

    MOVE.L  -4(A5),-(A7)
    JSR     LAB_159A(PC)

    MOVE.L  D0,D7
    MOVE.L  -8(A5),(A7)
    BSR.W   LAB_13D4

    ADDQ.W  #4,A7
    MOVE.L  D0,D6
    TST.W   D7
    BLE.S   LAB_13E5

    MOVE.L  LAB_206D,D0
    MOVE.L  D0,D1
    ADD.L   D1,D1
    CMP.W   0(A2,D1.L),D7
    BGE.S   LAB_13E5

    TST.W   D6
    BMI.S   LAB_13E5

    CMPI.W  #$1000,D6
    BGE.S   LAB_13E5

    ASL.L   #7,D0
    MOVEA.L A2,A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    EXT.L   D0
    ADD.L   D0,D0
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    MOVE.W  D0,32(A0)

LAB_13E5:
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_ProcessWeatherBlocks   (Process weather-related INI blocks??)
; ARGS:
;   stack +8: A3 = current line pointer
;   stack +12: A2 = target struct pointer
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   JMP_TBL_LAB_1968_3, LAB_1460, LAB_1463, LAB_159A, LAB_15A1
; READS:
;   LAB_1B1F, LAB_233D, LAB_2073, LAB_2059, LAB_206D
; WRITES:
;   LAB_233D, LAB_1B1F, LAB_2073, LAB_206D, fields at offsets 190+ in LAB_233D struct
; DESC:
;   Handles a collection of weather configuration keys (WX strings, codes, timing)
;   populating a weather/display struct and related globals.
; NOTES:
;   Many keys are matched via JMP_TBL_LAB_1968_3 against literal strings LAB_2074..208A.
;------------------------------------------------------------------------------
PARSEINI_ProcessWeatherBlocks:
LAB_13E6:
    LINK.W  A5,#-8
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    SUBA.L  A0,A0
    MOVE.L  A0,-8(A5)
    TST.L   LAB_1B1F
    BNE.S   LAB_13E7

    MOVE.L  A0,LAB_2073
    MOVE.L  A0,LAB_233D

LAB_13E7:
    PEA     LAB_2074
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13E8

    CLR.L   LAB_2073
    MOVE.L  LAB_233D,-(A7)
    MOVE.L  A2,-(A7)
    JSR     LAB_1460(PC)

    ADDQ.W  #8,A7
    MOVEA.L D0,A0
    MOVE.B  #$1,190(A0)
    MOVE.L  D0,LAB_233D
    TST.L   LAB_1B1F
    BNE.S   LAB_13E8

    MOVE.L  D0,LAB_1B1F

LAB_13E8:
    TST.L   LAB_233D
    BEQ.W   LAB_13FF

    PEA     LAB_2075
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13EC

    PEA     LAB_2076
    MOVE.L  A2,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13E9

    MOVEA.L LAB_233D,A0
    CLR.L   194(A0)
    BRA.W   LAB_13FF

LAB_13E9:
    PEA     LAB_2077
    MOVE.L  A2,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13EA

    MOVEQ   #2,D0
    MOVEA.L LAB_233D,A0
    MOVE.L  D0,194(A0)
    BRA.W   LAB_13FF

LAB_13EA:
    PEA     LAB_2078
    MOVE.L  A2,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13EB

    MOVEQ   #3,D0
    MOVEA.L LAB_233D,A0
    MOVE.L  D0,194(A0)
    BRA.W   LAB_13FF

LAB_13EB:
    MOVEQ   #1,D0
    MOVEA.L LAB_233D,A0
    MOVE.L  D0,194(A0)
    BRA.W   LAB_13FF

LAB_13EC:
    PEA     LAB_2079
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13ED

    MOVE.L  A2,-(A7)
    JSR     LAB_159A(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    MOVEA.L LAB_233D,A0
    MOVE.L  D7,198(A0)
    BRA.W   LAB_13FF

LAB_13ED:
    PEA     LAB_207A
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13EE

    PEA     LAB_207B
    MOVE.L  A2,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.W   LAB_13FF

    MOVEA.L LAB_233D,A0
    MOVE.B  #$2,190(A0)
    BRA.W   LAB_13FF

LAB_13EE:
    PEA     LAB_207C
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13EF

    MOVE.L  A2,-(A7)
    JSR     LAB_159A(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    MOVEA.L LAB_233D,A0
    MOVE.L  D7,202(A0)
    BRA.W   LAB_13FF

LAB_13EF:
    PEA     LAB_207D
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13F0

    MOVE.L  A2,-(A7)
    JSR     LAB_159A(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    MOVEA.L LAB_233D,A0
    MOVE.L  D7,206(A0)
    BRA.W   LAB_13FF

LAB_13F0:
    PEA     LAB_207E
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13F1

    MOVE.L  A2,-(A7)
    JSR     LAB_159A(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    MOVEA.L LAB_233D,A0
    MOVE.L  D7,210(A0)
    BRA.W   LAB_13FF

LAB_13F1:
    PEA     LAB_207F
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13F2

    MOVE.L  A2,-(A7)
    JSR     LAB_159A(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    MOVEA.L LAB_233D,A0
    MOVE.L  D7,214(A0)
    BRA.W   LAB_13FF

LAB_13F2:
    PEA     LAB_2080
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13F3

    MOVE.L  A2,-(A7)
    JSR     LAB_159A(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    MOVEA.L LAB_233D,A0
    MOVE.L  D7,218(A0)
    BRA.W   LAB_13FF

LAB_13F3:
    PEA     LAB_2081
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.W   LAB_13F8

    MOVEA.L A2,A0

LAB_13F4:
    TST.B   (A0)+
    BNE.S   LAB_13F4

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,D0
    TST.L   D0
    BLE.W   LAB_13F8

    PEA     LAB_2082
    MOVE.L  A2,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13F5

    MOVEA.L LAB_233D,A0
    MOVE.B  #$3,190(A0)
    BRA.W   LAB_13FF

LAB_13F5:
    MOVE.L  LAB_2073,-8(A5)
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     12.W
    PEA     670.W
    PEA     GLOB_STR_PARSEINI_C_3
    JSR     GROUPD_JMP_TBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,LAB_2073
    TST.L   D0
    BEQ.W   LAB_13FF

    MOVEA.L D0,A0
    CLR.L   8(A0)
    MOVEA.L A2,A0
    MOVEA.L D0,A1

LAB_13F6:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_13F6

    MOVEA.L LAB_233D,A0
    TST.L   230(A0)
    BNE.S   LAB_13F7

    MOVEA.L LAB_2073,A1
    MOVE.L  A1,230(A0)
    BRA.W   LAB_13FF

LAB_13F7:
    MOVEA.L -8(A5),A1
    MOVE.L  LAB_2073,8(A1)
    BRA.W   LAB_13FF

LAB_13F8:
    PEA     LAB_2084
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13FB

    PEA     LAB_2085
    MOVE.L  A2,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13F9

    MOVEQ   #2,D0
    MOVEA.L LAB_233D,A0
    MOVE.L  D0,222(A0)
    BRA.W   LAB_13FF

LAB_13F9:
    PEA     LAB_2086
    MOVE.L  A2,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13FA

    MOVEQ   #1,D0
    MOVEA.L LAB_233D,A0
    MOVE.L  D0,222(A0)
    BRA.W   LAB_13FF

LAB_13FA:
    MOVEA.L LAB_233D,A0
    CLR.L   222(A0)
    BRA.W   LAB_13FF

LAB_13FB:
    PEA     LAB_2087
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13FE

    PEA     LAB_2088
    MOVE.L  A2,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13FC

    MOVEQ   #2,D0
    MOVEA.L LAB_233D,A0
    MOVE.L  D0,226(A0)
    BRA.S   LAB_13FF

LAB_13FC:
    PEA     LAB_2089
    MOVE.L  A2,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13FD

    MOVEQ   #1,D0
    MOVEA.L LAB_233D,A0
    MOVE.L  D0,226(A0)
    BRA.S   LAB_13FF

LAB_13FD:
    MOVEA.L LAB_233D,A0
    CLR.L   226(A0)
    BRA.S   LAB_13FF

LAB_13FE:
    PEA     LAB_208A
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13FF

    MOVEA.L LAB_233D,A0
    ADDA.W  #191,A0
    PEA     2.W
    MOVE.L  A2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_15A1(PC)

    LEA     12(A7),A7
    MOVEA.L LAB_233D,A0
    CLR.B   193(A0)

LAB_13FF:
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_LoadWeatherStrings   (Load weather strings/locations??)
; ARGS:
;   stack +8: A3 = source string pointer
;   stack +12: A2 = destination buffer/struct
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   JMP_TBL_LAB_1968_3, LAB_1460, LAB_1469, LAB_1463, LAB_159A
; READS:
;   LAB_1B23, LAB_233E, LAB_2059
; WRITES:
;   LAB_233E, LAB_1B23, LAB_2059
; DESC:
;   Parses weather string keys, allocates/sets current weather display entries,
;   and handles default/fallback cases.
; NOTES:
;   Sets field 190(A0) to 0x0A when a new block is created.
;------------------------------------------------------------------------------
PARSEINI_LoadWeatherStrings:
LAB_1400:
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEA.L 16(A7),A2
    TST.L   LAB_1B23
    BNE.S   LAB_1401

    CLR.L   LAB_233E

LAB_1401:
    PEA     LAB_208B
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_1402

    MOVE.L  LAB_233E,-(A7)
    MOVE.L  A2,-(A7)
    JSR     LAB_1460(PC)

    ADDQ.W  #8,A7
    MOVEA.L D0,A0
    MOVE.B  #$a,190(A0)
    MOVE.L  D0,LAB_233E
    TST.L   LAB_1B23
    BNE.S   LAB_1403

    MOVE.L  D0,LAB_1B23
    BRA.S   LAB_1403

LAB_1402:
    MOVEQ   #0,D0
    TST.L   D0
    BEQ.S   LAB_1403

    PEA     LAB_208C
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_1403

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_2059
    MOVE.L  LAB_233E,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1460(PC)

    ADDQ.W  #8,A7
    MOVEA.L D0,A0
    MOVE.B  #10,190(A0)
    MOVE.L  D0,LAB_233E
    TST.L   LAB_1B23
    BNE.S   LAB_1403

    MOVE.L  D0,LAB_1B23

LAB_1403:
    MOVEM.L (A7)+,A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_LoadWeatherMessageStrings   (Load message strings??)
; ARGS:
;   stack +12: A3 = source string pointer
;   stack +16: A2 = destination buffer
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   JMP_TBL_LAB_1968_3, LAB_146B
; READS:
;   LAB_205A/B/C, LAB_2059
; WRITES:
;   LAB_205A/B/C
; DESC:
;   Parses three related message strings and stores them in LAB_205A/B/C.
; NOTES:
;   Uses sequential key matching LAB_208D/E/F.
;------------------------------------------------------------------------------
PARSEINI_LoadWeatherMessageStrings:
LAB_1404:
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEA.L 16(A7),A2
    PEA     LAB_208D
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_1405

    MOVE.L  LAB_205A,-(A7)
    MOVE.L  A2,-(A7)
    JSR     LAB_146B(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_205A
    BRA.S   LAB_1407

LAB_1405:
    PEA     LAB_208E
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_1406

    MOVE.L  LAB_205B,-(A7)
    MOVE.L  A2,-(A7)
    JSR     LAB_146B(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_205B
    BRA.S   LAB_1407

LAB_1406:
    PEA     LAB_208F
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_1407

    MOVE.L  LAB_205C,-(A7)
    MOVE.L  A2,-(A7)
    JSR     LAB_146B(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_205C

LAB_1407:
    MOVEM.L (A7)+,A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_ParseColorTable   (Parse color table entries??)
; ARGS:
;   stack +8: A3 = source string pointer
;   stack +12: A2 = destination table ptr
;   stack +16: D7 = mode selector (0: rgb?, 1: palette??, 4 triggers checksum)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   JMP_TBL_PRINTF_4, JMP_TBL_LAB_1968_3, LAB_1598, LAB_167A
; READS:
;   LAB_1ECC/LAB_1FB8 tables, GLOB_STR_COLOR_PERCENT_D
; WRITES:
;   color tables pointed by A2 (8x3 bytes)
; DESC:
;   Iterates through color percentages strings, converts them, and fills a table;
;   for mode 4 triggers LAB_167A afterward.
; NOTES:
;   Converts using LAB_1598 (string→value) and stores into preset tables.
;------------------------------------------------------------------------------
PARSEINI_ParseColorTable:
LAB_1408:
    LINK.W  A5,#-120
    MOVEM.L D4-D7/A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7

    MOVE.L  D7,D0
    SUBQ.L  #4,D0
    BEQ.S   .LAB_1409

    SUBQ.L  #1,D0
    BEQ.S   .LAB_140A

    BRA.S   .LAB_140B

.LAB_1409:
    MOVE.L  #LAB_1FB8,-116(A5)
    MOVEQ   #8,D4
    BRA.S   .LAB_140B

.LAB_140A:
    MOVE.L  #LAB_1ECC,-116(A5)
    MOVEQ   #8,D4

.LAB_140B:
    MOVEQ   #0,D6

.LAB_140C:
    CMP.L   D4,D6
    BGE.S   .LAB_140F

    MOVE.L  D6,-(A7)
    PEA     GLOB_STR_COLOR_PERCENT_D
    PEA     -112(A5)
    JSR     JMP_TBL_PRINTF_4(PC)

    PEA     -112(A5)
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    LEA     20(A7),A7
    TST.L   D0
    BNE.S   .LAB_140E

    MOVEQ   #0,D5

.LAB_140D:
    MOVEQ   #3,D0
    CMP.L   D0,D5
    BGE.S   .LAB_140E

    MOVE.L  D6,D1
    LSL.L   #2,D1
    SUB.L   D6,D1
    ADD.L   D5,D1
    MOVE.B  0(A2,D5.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D1,28(A7)
    JSR     LAB_1598(PC)

    ADDQ.W  #4,A7
    MOVEA.L -116(A5),A0
    MOVE.L  24(A7),D1
    MOVE.B  D0,0(A0,D1.L)
    ADDQ.L  #1,D5
    BRA.S   .LAB_140D

.LAB_140E:
    ADDQ.L  #1,D6
    BRA.S   .LAB_140C

.LAB_140F:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BNE.S   .return

    JSR     LAB_167A(PC)

.return:
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_TestMemoryAndOpenTopazFont   (Test memory then open Topaz)
; ARGS:
;   stack +8: A3 = pointer to font handle storage
;   stack +12: A2 = TextAttr for desired font
; RET:
;   D0: 0 on success, 1 on failure
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _LVOCloseFont, _LVOForbid/_LVOPermit, _LVOAllocMem/_LVOFreeMem, _LVOOpenDiskFont
; READS:
;   GLOB_HANDLE_TOPAZ_FONT
; WRITES:
;   (A3) font handle
; DESC:
;   Ensures a Topaz font is open, first probing for a small alloc; closes an
;   existing non-Topaz handle, tries to open the requested font, otherwise falls
;   back to the global Topaz handle.
; NOTES:
;   Sets D0=1 when it could not load the desired font.
;------------------------------------------------------------------------------
PARSEINI_TestMemoryAndOpenTopazFont:
TEST_MEMORY_AND_OPEN_TOPAZ_FONT:
    LINK.W  A5,#-8
    MOVEM.L D7/A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2

    MOVEQ   #0,D7
    TST.L   (A3)
    BEQ.S   .return

    MOVEA.L (A3),A0
    MOVEA.L GLOB_HANDLE_TOPAZ_FONT,A1
    CMPA.L  A0,A1
    BEQ.S   .testDesiredMemoryAvailability

    MOVEA.L A0,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOCloseFont(A6)

.testDesiredMemoryAvailability:
    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    MOVE.L  #DesiredMemoryAvailability,D0
    MOVEQ   #1,D1
    JSR     _LVOAllocMem(A6)

    MOVE.L  D0,-4(A5)
    BEQ.S   .openTopazFont

    MOVEA.L D0,A1
    MOVE.L  #DesiredMemoryAvailability,D0
    JSR     _LVOFreeMem(A6)

.openTopazFont:
    JSR     _LVOPermit(A6)

    MOVEA.L A2,A0
    MOVEA.L GLOB_REF_DISKFONT_LIBRARY,A6
    JSR     _LVOOpenDiskFont(A6)

    MOVE.L  D0,(A3)
    BNE.S   .couldNotLoadTopazFont

    MOVE.L  GLOB_HANDLE_TOPAZ_FONT,(A3)
    BRA.S   .return

.couldNotLoadTopazFont:
    MOVEQ   #1,D7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

; we're doing a bunch of font stuff in here!
;------------------------------------------------------------------------------
; FUNC: PARSEINI_HandleFontCommand   (Parse font command sequence??)
; ARGS:
;   stack +8: A3 = command string pointer
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   JMP_TBL_PRINTF_4, _LVOExecute, PARSEINI_TestMemoryAndOpenTopazFont, LAB_1429
; READS:
;   GLOB_REF_DOS_LIBRARY_2, GLOB_HANDLE_TOPAZ_FONT
; WRITES:
;   (font handles via PARSEINI_TestMemoryAndOpenTopazFont)
; DESC:
;   Parses a command string starting with '3' '2' ... handling subcommands to
;   execute shell commands or open fonts depending on the trailing byte.
; NOTES:
;   Matches subcodes 0x34–0x38 etc.; returns early on non-matching prefixes.
;------------------------------------------------------------------------------
PARSEINI_HandleFontCommand:
LAB_1416:
    LINK.W  A5,#-88
    MOVEM.L D2-D3/D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.B  (A3)+,D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    SUBI.W  #$33,D0
    BNE.W   .return

    MOVE.B  (A3)+,D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    SUBI.W  #$32,D0
    BEQ.S   .LAB_1417

    SUBQ.W  #1,D0
    BEQ.S   .LAB_1418

    SUBQ.W  #1,D0
    BEQ.W   .LAB_1429

    BRA.W   .return

.LAB_1417:
    MOVE.L  A3,-(A7)
    PEA     GLOB_STR_PERCENT_S_2
    PEA     -80(A5)
    JSR     JMP_TBL_PRINTF_4(PC)

    LEA     12(A7),A7
    LEA     -80(A5),A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    BRA.W   .return

.LAB_1418:
    MOVE.B  (A3)+,D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    SUBI.W  #$34,D0
    BEQ.S   .LAB_1419

    SUBQ.W  #1,D0
    BEQ.S   .LAB_141A

    SUBQ.W  #1,D0
    BEQ.S   .LAB_141C

    SUBQ.W  #1,D0
    BEQ.S   .LAB_141D

    SUBQ.W  #1,D0
    BEQ.W   .LAB_141E

    SUBQ.W  #1,D0
    BEQ.W   .LAB_1421

    SUBI.W  #$18,D0
    BEQ.W   .LAB_1422

    SUBI.W  #16,D0
    BEQ.W   .LAB_1423

    SUBQ.W  #1,D0
    BEQ.W   .LAB_1424

    SUBQ.W  #1,D0
    BEQ.W   .LAB_1425

    SUBQ.W  #1,D0
    BEQ.W   .LAB_1427

    SUBI.W  #15,D0
    BEQ.W   .LAB_1428

    BRA.W   .return

.LAB_1419:
    JSR     LAB_1453(PC)

    BRA.W   .return

.LAB_141A:
    MOVE.B  LAB_1BC1,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .LAB_141B

    BSR.W   LAB_142E

.LAB_141B:
    JSR     LAB_1466(PC)

    BRA.W   .return

.LAB_141C:
    JSR     LAB_145A(PC)

    BRA.W   .return

.LAB_141D:
    PEA     GLOB_STRUCT_TEXTATTR_H26F_FONT
    PEA     GLOB_HANDLE_H26F_FONT
    BSR.W   TEST_MEMORY_AND_OPEN_TOPAZ_FONT

    ADDQ.W  #8,A7
    TST.W   D0
    BEQ.W   .return

    TST.W   LAB_2263
    BEQ.W   .return

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEA.L GLOB_HANDLE_H26F_FONT,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    BRA.W   .return

.LAB_141E:
    PEA     GLOB_STRUCT_TEXTATTR_PREVUEC_FONT
    PEA     GLOB_HANDLE_PREVUEC_FONT
    BSR.W   TEST_MEMORY_AND_OPEN_TOPAZ_FONT

    ADDQ.W  #8,A7
    TST.W   D0
    BEQ.W   .return

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0

    MOVEA.L A0,A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVEA.L GLOB_REF_RASTPORT_2,A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_2,A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVEQ   #0,D6

.LAB_141F:
    MOVEQ   #4,D0
    CMP.L   D0,D6
    BGE.S   .LAB_1420

    MOVE.L  D6,D0
    MOVEQ   #80,D1
    ADD.L   D1,D1
    JSR     JMP_TBL_LAB_1A06_7(PC)

    LEA     LAB_22A6,A0
    ADDA.L  D0,A0
    LEA     60(A0),A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    ADDQ.L  #1,D6
    BRA.S   .LAB_141F

.LAB_1420:
    MOVE.L  GLOB_HANDLE_PREVUEC_FONT,-(A7)
    JSR     LAB_1858

    ADDQ.W  #4,A7
    BRA.W   .return

.LAB_1421:
    PEA     GLOB_STRUCT_TEXTATTR_PREVUE_FONT
    PEA     GLOB_HANDLE_PREVUE_FONT
    BSR.W   TEST_MEMORY_AND_OPEN_TOPAZ_FONT

    ADDQ.W  #8,A7
    TST.W   D0
    BRA.W   .return

.LAB_1422:
    JSR     LAB_1454(PC)

    BRA.W   .return

.LAB_1423:
    PEA     97.W
    JSR     LAB_1458(PC)

    ADDQ.W  #4,A7
    BRA.W   .return

.LAB_1424:
    PEA     GLOB_STR_DF0_GRADIENT_INI_3
    BSR.W   PARSE_INI

    ADDQ.W  #4,A7
    BRA.W   .return

.LAB_1425:
    PEA     GLOB_STR_DF0_BANNER_INI_2
    JSR     LAB_14C6(PC)

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.W   .return

.LAB_1426:
    TST.W   LAB_1B83
    BEQ.S   .LAB_1426

    CLR.L   -(A7)
    PEA     LAB_1B25
    JSR     LAB_145E(PC)

    PEA     LAB_1B23
    JSR     LAB_1459(PC)

    PEA     GLOB_STR_DF0_BANNER_INI_3

    BSR.W   PARSE_INI

    PEA     1.W
    JSR     LAB_1457(PC)

    LEA     20(A7),A7
    BRA.S   .return

.LAB_1427:
    PEA     GLOB_STR_DF0_DEFAULT_INI_2
    BSR.W   PARSE_INI

    ADDQ.W  #4,A7
    BRA.S   .return

.LAB_1428:
    PEA     GLOB_STR_DF0_SOURCECFG_INI_1
    BSR.W   PARSE_INI

    JSR     LAB_1670(PC)

    ADDQ.W  #4,A7

    BRA.S   .return

.LAB_1429:
    MOVE.B  (A3)+,D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    SUBI.W  #$30,D0
    BEQ.S   .LAB_142A

    SUBQ.W  #1,D0
    BEQ.S   .LAB_142B

    SUBQ.W  #1,D0
    BEQ.S   .LAB_142C

    BRA.S   .return

.LAB_142A:
    JSR     LAB_146C(PC)

    JSR     LAB_146A(PC)

    BRA.S   .return

.LAB_142B:
    JSR     LAB_146C(PC)

    JSR     LAB_145D(PC)

    BRA.S   .return

.LAB_142C:
    JSR     LAB_146C(PC)

    JSR     JMP_TBL_DRAW_ESC_MENU_VERSION_SCREEN(PC)

.return:
    MOVEM.L (A7)+,D2-D3/D6-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_ScanLogoDirectory   (Scan logo directory, build lists??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A2
; CALLS:
;   _LVOExecute, LAB_1456, LAB_1468, LAB_145B, GROUPD_JMP_TBL_MEMORY_AllocateMemory
; READS:
;   GLOB_STR_LIST_RAM_LOGODIR_TXT_DH2_LOGOS_NOHEAD_QUICK, LAB_2098/2099/209A/209B strings
; WRITES:
;   local temp buffers and allocated lists at -500/-900(A5)
; DESC:
;   Executes helper commands to list logo directories, reads entries into temp
;   buffers, allocates per-entry strings, and populates two arrays (probably names/paths).
; NOTES:
;   Iterates up to 100 entries per list, trimming CR/LF/commas from lines.
;------------------------------------------------------------------------------
PARSEINI_ScanLogoDirectory:
LAB_142E:
    LINK.W  A5,#-960
    MOVEM.L D2-D3/D5-D7/A2,-(A7)

    LEA     -88(A5),A0
    MOVEQ   #0,D6
    MOVE.L  A0,-100(A5)
    MOVE.L  A0,-96(A5)

.LAB_142F:
    MOVEQ   #100,D0
    CMP.L   D0,D6
    BGE.S   .LAB_1430

    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     -500(A5),A0
    ADDA.L  D0,A0
    SUBA.L  A1,A1
    MOVE.L  A1,(A0)
    LEA     -900(A5),A0
    ADDA.L  D0,A0
    MOVE.L  A1,(A0)
    ADDQ.L  #1,D6
    BRA.S   .LAB_142F

.LAB_1430:
    LEA     GLOB_STR_LIST_RAM_LOGODIR_TXT_DH2_LOGOS_NOHEAD_QUICK,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    PEA     LAB_2099
    PEA     LAB_2098
    JSR     LAB_1456(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    BNE.S   .LAB_1431

    CLR.L   -96(A5)

.LAB_1431:
    PEA     LAB_209B
    PEA     LAB_209A
    JSR     LAB_1456(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    BNE.S   .LAB_1432

    CLR.L   -100(A5)

.LAB_1432:
    MOVEQ   #0,D5

.LAB_1433:
    TST.L   -96(A5)
    BEQ.W   .LAB_143B

    MOVEQ   #100,D0
    CMP.L   D0,D5
    BGE.W   .LAB_143B

    MOVE.L  -4(A5),-(A7)
    PEA     99.W
    PEA     -88(A5)
    JSR     LAB_1468(PC)

    LEA     12(A7),A7
    LEA     -88(A5),A0
    MOVEA.L A0,A1

.LAB_1434:
    TST.B   (A1)+
    BNE.S   .LAB_1434

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D7
    MOVEQ   #0,D6
    MOVE.L  D0,-96(A5)

.LAB_1435:
    CMP.L   D7,D6
    BGE.S   .LAB_1438

    MOVEQ   #10,D0
    CMP.B   -88(A5,D6.L),D0
    BEQ.S   .LAB_1436

    MOVEQ   #13,D0
    CMP.B   -88(A5,D6.L),D0
    BEQ.S   .LAB_1436

    MOVEQ   #44,D0
    CMP.B   -88(A5,D6.L),D0
    BNE.S   .LAB_1437

.LAB_1436:
    CLR.B   -88(A5,D6.L)

.LAB_1437:
    ADDQ.L  #1,D6
    BRA.S   .LAB_1435

.LAB_1438:
    PEA     -88(A5)
    JSR     LAB_145B(PC)

    MOVE.L  D5,D1
    ASL.L   #2,D1
    LEA     -500(A5),A0
    ADDA.L  D1,A0
    MOVEA.L D0,A1

.LAB_1439:
    TST.B   (A1)+
    BNE.S   .LAB_1439

    SUBQ.L  #1,A1
    SUBA.L  D0,A1
    MOVE.L  A1,D1
    ADDQ.L  #1,D1
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    MOVE.L  D1,-(A7)
    PEA     1263.W
    PEA     GLOB_STR_PARSEINI_C_4
    MOVE.L  D0,-92(A5)
    MOVE.L  A0,40(A7)
    JSR     GROUPD_JMP_TBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L 24(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     -500(A5),A0
    ADDA.L  D0,A0
    MOVEA.L -92(A5),A1
    MOVEA.L (A0),A2

.LAB_143A:
    MOVE.B  (A1)+,(A2)+
    BNE.S   .LAB_143A

    ADDQ.L  #1,D5
    BRA.W   .LAB_1433

.LAB_143B:
    MOVEQ   #0,D5

.LAB_143C:
    TST.L   -100(A5)
    BEQ.W   .LAB_1444

    MOVEQ   #100,D0
    CMP.L   D0,D5
    BGE.W   .LAB_1444

    MOVE.L  -8(A5),-(A7)
    PEA     99.W
    PEA     -88(A5)
    JSR     LAB_1468(PC)

    LEA     12(A7),A7
    LEA     -88(A5),A0
    MOVEA.L A0,A1

.LAB_143D:
    TST.B   (A1)+
    BNE.S   .LAB_143D

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D7
    MOVEQ   #0,D6
    MOVE.L  D0,-100(A5)

.LAB_143E:
    CMP.L   D7,D6
    BGE.S   .LAB_1441

    MOVEQ   #10,D0
    CMP.B   -88(A5,D6.L),D0
    BEQ.S   .LAB_143F

    MOVEQ   #13,D0
    CMP.B   -88(A5,D6.L),D0
    BNE.S   .LAB_1440

.LAB_143F:
    CLR.B   -88(A5,D6.L)

.LAB_1440:
    ADDQ.L  #1,D6
    BRA.S   .LAB_143E

.LAB_1441:
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     -900(A5),A0
    ADDA.L  D0,A0
    LEA     -88(A5),A1
    MOVEA.L A1,A2

.LAB_1442:
    TST.B   (A2)+
    BNE.S   .LAB_1442

    SUBQ.L  #1,A2
    SUBA.L  A1,A2
    MOVE.L  A2,D0
    ADDQ.L  #1,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     1287.W
    PEA     GLOB_STR_PARSEINI_C_5
    MOVE.L  A0,40(A7)
    JSR     GROUPD_JMP_TBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L 24(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     -900(A5),A0
    ADDA.L  D0,A0
    LEA     -88(A5),A1
    MOVEA.L (A0),A2

.LAB_1443:
    MOVE.B  (A1)+,(A2)+
    BNE.S   .LAB_1443

    ADDQ.L  #1,D5
    BRA.W   .LAB_143C

.LAB_1444:
    MOVEQ   #0,D6

.LAB_1445:
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     -900(A5),A0
    ADDA.L  D0,A0
    TST.L   (A0)
    BEQ.W   .LAB_144C

    MOVEQ   #0,D5
    CLR.L   -916(A5)

.LAB_1446:
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     -500(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   (A1)
    BEQ.S   .LAB_1448

    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     -900(A5),A1
    ADDA.L  D0,A1
    MOVE.L  D5,D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    MOVE.L  (A1),-(A7)
    JSR     JMP_TBL_LAB_1968_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .LAB_1447

    MOVEQ   #1,D0
    MOVE.L  D0,-916(A5)

.LAB_1447:
    ADDQ.L  #1,D5
    BRA.S   .LAB_1446

.LAB_1448:
    TST.L   -916(A5)
    BNE.S   .LAB_144A

    LEA     GLOB_STR_DELETE_NIL_DH2_LOGOS,A0
    LEA     -956(A5),A1
    MOVEQ   #5,D0

.LAB_1449:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.LAB_1449

    CLR.B   (A1)
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     -900(A5),A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    PEA     -956(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_3(PC)

    ADDQ.W  #8,A7
    LEA     -956(A5),A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

.LAB_144A:
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     -900(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    ADDA.L  D0,A0
    MOVEA.L (A0),A2

.LAB_144B:
    TST.B   (A2)+
    BNE.S   .LAB_144B

    SUBQ.L  #1,A2
    SUBA.L  (A0),A2
    MOVE.L  A2,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  (A1),-(A7)
    PEA     1323.W
    PEA     GLOB_STR_PARSEINI_C_6
    JSR     GROUPD_JMP_TBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    ADDQ.L  #1,D6
    BRA.W   .LAB_1445

.LAB_144C:
    MOVEQ   #0,D5

.LAB_144D:
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     -500(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   (A1)
    BEQ.S   .LAB_144F

    MOVE.L  D5,D0
    ASL.L   #2,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    ADDA.L  D0,A0
    MOVEA.L (A0),A2

.LAB_144E:
    TST.B   (A2)+
    BNE.S   .LAB_144E

    SUBQ.L  #1,A2
    SUBA.L  (A0),A2
    MOVE.L  A2,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  (A1),-(A7)
    PEA     1329.W
    PEA     GLOB_STR_PARSEINI_C_7
    JSR     GROUPD_JMP_TBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    ADDQ.L  #1,D5
    BRA.S   .LAB_144D

.LAB_144F:
    TST.L   -4(A5)
    BEQ.S   .LAB_1450

    MOVE.L  -4(A5),-(A7)
    JSR     LAB_1461(PC)

    ADDQ.W  #4,A7

.LAB_1450:
    TST.L   -8(A5)
    BEQ.S   .return

    MOVE.L  -8(A5),-(A7)
    JSR     LAB_1461(PC)

    ADDQ.W  #4,A7

.return:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: JMP_TBL_LAB_1968_3   (JumpStub_LAB_1968)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   LAB_1968
; DESC:
;   Jump stub to LAB_1968 (string compare/parse helper).
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMP_TBL_LAB_1968_3:
    JMP     LAB_1968

LAB_1453:
    JMP     LAB_071B

LAB_1454:
    JMP     LAB_04F0

LAB_1455:
    JMP     LAB_1979

LAB_1456:
    JMP     LAB_1AB2

LAB_1457:
    JMP     LAB_09F9

LAB_1458:
    JMP     LAB_0A93

LAB_1459:
    JMP     BRUSH_FreeBrushResources

LAB_145A:
    JMP     LAB_09DB

LAB_145B:
    JMP     GCOMMAND_FindPathSeparator

LAB_145C:
    JMP     LAB_03B9

LAB_145D:
    JMP     LAB_0718

LAB_145E:
    JMP     BRUSH_FreeBrushList

LAB_145F:
    JMP     GCOMMAND_ValidatePresetTable

LAB_1460:
    JMP     BRUSH_AllocBrushNode

LAB_1461:
    JMP     LAB_1AB9

LAB_1462:
    JMP     GCOMMAND_InitPresetTableFromPalette

LAB_1463:
    JMP     LAB_194E

;------------------------------------------------------------------------------
; FUNC: JMP_TBL_APPEND_DATA_AT_NULL_3   (JumpStub_APPEND_DATA_AT_NULL)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   APPEND_DATA_AT_NULL
; DESC:
;   Jump stub to APPEND_DATA_AT_NULL.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMP_TBL_APPEND_DATA_AT_NULL_3:
    JMP     APPEND_DATA_AT_NULL

LAB_1465:
    JMP     LAB_03AC

LAB_1466:
    JMP     LAB_071A

;------------------------------------------------------------------------------
; FUNC: JMP_TBL_PRINTF_4   (JumpStub_WDISP_SPrintf)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   WDISP_SPrintf
; DESC:
;   Jump stub to WDISP_SPrintf.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMP_TBL_PRINTF_4:
    JMP     WDISP_SPrintf

LAB_1468:
    JMP     LAB_19DC

LAB_1469:
    JMP     LAB_1984

LAB_146A:
    JMP     LAB_0713

LAB_146B:
    JMP     LAB_0B44

LAB_146C:
    JMP     LAB_070E

;------------------------------------------------------------------------------
; FUNC: JMP_TBL_DRAW_ESC_MENU_VERSION_SCREEN   (JumpStub_DRAW_ESC_MENU_VERSION_SCREEN)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   DRAW_ESC_MENU_VERSION_SCREEN
; DESC:
;   Jump stub to DRAW_ESC_MENU_VERSION_SCREEN.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMP_TBL_DRAW_ESC_MENU_VERSION_SCREEN:
    JMP     DRAW_ESC_MENU_VERSION_SCREEN

    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

;EVEN
;    rsReset                          ; start struct scrTxtMem
;scrTxtMem_PtrTopBlank       rs.l 1   ; pointer to top blank
;scrTxtMem_PtrTopOpen        rs.l 1   ; pointer to top open/visible area
;scrTxtMem_PtrBottomBlank    rs.l 1   ; pointer to bottom blank
;scrTxtMem_SizeOf            rs.w     ; end/size of struct scrTxtMem



;------------------------------------------------------------------------------
; FUNC: PARSEINI_WriteRtcFromGlobals   (Write globals to RTC chip)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/D7/A0/A6
; CALLS:
;   ADJUST_HOURS_TO_24_HR_FMT, JMP_TBL_GET_LEGAL_OR_SECONDS_FROM_EPOCH,
;   JMP_TBL_GET_SECONDS_FROM_EPOCH, JMP_TBL_SET_CLOCK_CHIP_TIME
; READS:
;   LAB_223A-E, LAB_2243, GLOB_REF_UTILITY_LIBRARY, GLOB_REF_BATTCLOCK_RESOURCE,
;   GLOB_REF_CLOCKDATA_STRUCT
; WRITES:
;   RTC chip via SET_CLOCK_CHIP_TIME
; DESC:
;   Converts current global date/time fields to a legal struct and writes them
;   to the battery-backed clock if the RTC resources are available.
; NOTES:
;   Early-exits if utility library or battclock resource is unavailable.
;------------------------------------------------------------------------------
PARSEINI_WriteRtcFromGlobals:
LAB_146E:
    LINK.W  A5,#-20
    MOVE.L  D7,-(A7)

.clockDataStruct    = -18

    TST.L   GLOB_REF_UTILITY_LIBRARY
    BEQ.W   .return

    TST.L   GLOB_REF_BATTCLOCK_RESOURCE
    BEQ.S   .return

    MOVE.W  LAB_223A,D0
    MOVE.W  D0,-6(A5)
    MOVE.W  LAB_223B,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,-10(A5)
    MOVE.W  LAB_223C,D0
    MOVE.W  D0,-12(A5)
    MOVE.W  LAB_223D,D0
    MOVE.W  D0,-8(A5)
    MOVE.W  LAB_223E,D0
    EXT.L   D0
    MOVE.W  LAB_2243,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   ADJUST_HOURS_TO_24_HR_FMT

    MOVE.W  D0,-14(A5)
    MOVE.W  LAB_223F,D0
    MOVE.W  D0,-16(A5)
    MOVE.W  GLOB_REF_CLOCKDATA_STRUCT,D0
    MOVE.W  D0,.clockDataStruct(A5)
    PEA     .clockDataStruct(A5)
    JSR     JMP_TBL_GET_LEGAL_OR_SECONDS_FROM_EPOCH(PC)

    ; Clean the stack and test validity of clockdata struct seconds
    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .return

    PEA     .clockDataStruct(A5)
    JSR     JMP_TBL_GET_SECONDS_FROM_EPOCH(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,(A7)
    JSR     JMP_TBL_SET_CLOCK_CHIP_TIME(PC)

    ADDQ.W  #4,A7

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_UpdateClockFromRtc   (UpdateClockFromRtc??)
; ARGS:
;   (none)
; RET:
;   D0: none (status is implicit via globals)
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   JMP_TBL_GET_CLOCK_CHIP_TIME, JMP_TBL_POPULATE_CLOCKDATA_FROM_SECS,
;   JMP_TBL_GET_LEGAL_OR_SECONDS_FROM_EPOCH, LAB_1477
; READS:
;   GLOB_REF_UTILITY_LIBRARY, GLOB_REF_BATTCLOCK_RESOURCE
; WRITES:
;   LAB_223A (date/time fields via LAB_1477)
; DESC:
;   Reads the battery-backed clock, validates the resulting date/time fields,
;   and updates the global date/time structure used by the UI.
; NOTES:
;   If the clock data is invalid or unavailable, a fallback/default is written.
;------------------------------------------------------------------------------
PARSEINI_UpdateClockFromRtc:
LAB_1470:
    LINK.W  A5,#-40
    MOVEM.L D2-D7,-(A7)

.clockData  = -18
.localSec   = -28
.localMin   = -30
.localHour  = -32
.localYear  = -34
.localMDay  = -36
.localMonth = -38
.localWDay  = -40

    TST.L   GLOB_REF_UTILITY_LIBRARY
    BEQ.W   .return_status

    TST.L   GLOB_REF_BATTCLOCK_RESOURCE
    BEQ.W   .return_status

    JSR     JMP_TBL_GET_CLOCK_CHIP_TIME(PC)

    MOVE.L  D0,D7
    PEA     .clockData(A5)
    MOVE.L  D7,-(A7)
    JSR     JMP_TBL_POPULATE_CLOCKDATA_FROM_SECS(PC)

    PEA     .clockData(A5)
    JSR     JMP_TBL_GET_LEGAL_OR_SECONDS_FROM_EPOCH(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.W   .fallback_default_date

    MOVE.W  (.clockData+Struct_ClockData__WDay)(A5),D0
    MOVE.W  D0,.localWDay(A5)

    MOVE.W  (.clockData+Struct_ClockData__Month)(A5),D1
    MOVE.L  D1,D2
    SUBQ.W  #1,D2
    MOVE.W  D2,.localMonth(A5)  ; -1 because the index of the jump table.

    MOVE.W  (.clockData+Struct_ClockData__MDay)(A5),D2
    MOVE.L  D2,D3
    SUBQ.W  #1,D3
    MOVE.W  D3,.localMDay(A5)   ; -1 because the index of the jump table.

    MOVE.W  (.clockData+Struct_ClockData__Year)(A5),D3
    MOVE.W  D3,.localYear(A5)

    MOVE.W  (.clockData+Struct_ClockData__Hour)(A5),D4
    MOVE.W  D4,.localHour(A5)

    MOVE.W  (.clockData+Struct_ClockData__Min)(A5),D5
    MOVE.W  D5,.localMin(A5)

    MOVE.W  (.clockData+Struct_ClockData__Sec)(A5),D6
    MOVE.W  D6,.localSec(A5)

    MOVE.W  LAB_2241,-26(A5)

    MOVEQ   #0,D6
    CMP.W   D6,D0
    BCS.S   .invalid_date_data

    MOVEQ   #6,D5
    CMP.W   D5,D0
    BHI.S   .invalid_date_data

    CMP.W   D6,D1
    BCS.S   .invalid_date_data

    MOVEQ   #11,D0      ; Month?
    CMP.W   D0,D1
    BHI.S   .invalid_date_data

    CMP.W   D6,D2
    BCS.S   .invalid_date_data

    MOVEQ   #31,D0      ; Day number
    CMP.W   D0,D2
    BHI.S   .invalid_date_data

    CMP.W   D6,D3
    BCS.S   .invalid_date_data

    CMPI.W  #9999,D3    ; Year
    BHI.S   .invalid_date_data

    CMP.W   D6,D4
    BCS.S   .invalid_date_data

    MOVEQ   #23,D0      ; Hour
    CMP.W   D0,D4
    BHI.S   .invalid_date_data

    MOVE.W  -16(A5),D0
    CMP.W   D6,D0
    BCS.S   .invalid_date_data

    MOVEQ   #59,D1      ; Minutes
    CMP.W   D1,D0
    BHI.S   .invalid_date_data

    MOVE.W  -18(A5),D0
    CMP.W   D6,D0
    BCS.S   .invalid_date_data

    CMP.W   D1,D0

.invalid_date_data:
    PEA     -40(A5)
    PEA     LAB_223A
    BSR.W   LAB_1477

    ADDQ.W  #8,A7
    BRA.S   .return_status

.fallback_default_date:
    PEA     LAB_20A1
    PEA     LAB_223A
    BSR.W   LAB_1477

    ADDQ.W  #8,A7

.return_status:
    MOVEM.L (A7)+,D2-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ADJUST_HOURS_TO_24_HR_FMT   (12h→24h adjust helper)
; ARGS:
;   stack +14: D7 = hour (0-12?)
;   stack +18: D6 = AM/PM flag? (-1 for PM)
; RET:
;   D0: adjusted hour (long)
; CLOBBERS:
;   D0/D1/D6-D7
; CALLS:
;   none
; READS/WRITES:
;   none (pure)
; DESC:
;   Converts 12-hour clock fields to 24-hour format: returns 0 for 12 AM,
;   adds 12 when PM flag is set and hour < 12.
; NOTES:
;   Expects flag -1 to indicate PM; keeps hour unchanged otherwise.
;------------------------------------------------------------------------------
ADJUST_HOURS_TO_24_HR_FMT:
    MOVEM.L D6-D7,-(A7)
    MOVE.W  14(A7),D7
    MOVE.W  18(A7),D6

    ; If we're over 12 hours, jump.
    MOVEQ   #12,D0
    CMP.W   D0,D7
    BNE.S   .add12ToHour

    ; If D6 is not 0, jump.
    TST.W   D6
    BNE.S   .add12ToHour

    ; Return 0 if we're 12 AM.
    MOVEQ   #0,D7
    BRA.S   .return

.add12ToHour:
    CMP.W   D0,D7
    BGE.S   .return

    MOVEQ   #-1,D1
    CMP.W   D1,D6
    BNE.S   .return

    ADDI.W  #12,D7

.return:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_NormalizeClockData   (Normalize/validate clock data struct??)
; ARGS:
;   stack +8: A3 = clockdata dest struct
;   stack +12: A2 = source struct
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D2/A0-A3
; CALLS:
;   LAB_1484 (LAB_0660), LAB_1481 (ESQ_CalcDayOfYearFromMonthDay)
; READS:
;   A2 contents
; WRITES:
;   A3 contents (year/month/day/hour/min/sec, wday), LAB_20A4/20A5??
; DESC:
;   Copies clock fields, adjusts year (<1900), clamps/normalizes month/day/hour,
;   computes day-of-year, and sets validity flags.
; NOTES:
;   Adds 1 to day before validation; treats month/day indices as 0-based internally.
;------------------------------------------------------------------------------
PARSEINI_NormalizeClockData:
LAB_1477:
    MOVEM.L D2/A2-A3,-(A7)

.localYear  = 6
.localMonth = 8

    SetOffsetForStack 3

    MOVEA.L (.stackOffsetBytes+4)(A7),A3
    MOVEA.L (.stackOffsetBytes+8)(A7),A2

    MOVEA.L A2,A0
    MOVEA.L A3,A1
    MOVEQ   #4,D0

.loopWhileA0IsNotNull:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loopWhileA0IsNotNull

    MOVE.W  (A0),(A1)
    MOVE.W  .localYear(A3),D0
    CMPI.W  #1900,D0
    BGE.S   .yearGreaterThan1900

    ADDI.W  #1900,6(A3)

.yearGreaterThan1900:
    MOVE.W  .localMonth(A3),D0
    MOVEQ   #12,D1
    CMP.W   D1,D0
    BGE.S   .monthIsValid

    MOVEQ   #0,D2
    MOVE.W  D2,18(A3)
    BRA.S   .LAB_147B

.monthIsValid:
    MOVE.W  #(-1),18(A3)

.LAB_147B:
    TST.W   8(A3)
    BNE.S   .LAB_147C

    MOVE.W  D1,8(A3)

.LAB_147C:
    MOVE.W  8(A3),D0
    CMP.W   D1,D0
    BLE.S   .LAB_147D

    MOVEQ   #12,D1
    SUB.W   D1,8(A3)

.LAB_147D:
    ADDQ.W  #1,4(A3)
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_1484(PC)

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .LAB_147E

    MOVE.W  #(-1),20(A3)
    BRA.S   .return

.LAB_147E:
    CLR.W   20(A3)

.return:
    MOVE.L  A3,-(A7)
    JSR     LAB_1481(PC)

    ADDQ.W  #4,A7
    MOVEM.L (A7)+,D2/A2-A3
    RTS

;!======

JMP_TBL_POPULATE_CLOCKDATA_FROM_SECS:
    JMP     POPULATE_CLOCKDATA_FROM_SECS

LAB_1481:
    JMP     ESQ_CalcDayOfYearFromMonthDay

JMP_TBL_GET_LEGAL_OR_SECONDS_FROM_EPOCH:
    JMP     GET_LEGAL_OR_SECONDS_FROM_EPOCH

JMP_TBL_GET_CLOCK_CHIP_TIME:
    JMP     GET_CLOCK_CHIP_TIME

LAB_1484:
    JMP     LAB_0660

JMP_TBL_SET_CLOCK_CHIP_TIME:
    JMP     SET_CLOCK_CHIP_TIME

JMP_TBL_GET_SECONDS_FROM_EPOCH:
    JMP     GET_SECONDS_FROM_EPOCH

;!======

    ; Alignment
    MOVEQ   #97,D0

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_WriteErrorLogEntry   (Write error log entry??)
; ARGS:
;   (none)
; RET:
;   D0: -1 on failure, 0 on success
; CLOBBERS:
;   D0/D7
; CALLS:
;   JMP_TBL_DISKIO_OpenFileWithBuffer_2, LAB_14AB, LAB_14AC
; READS:
;   LAB_2049, LAB_233A, LAB_1B5E
; WRITES:
;   Err log file on disk
; DESC:
;   Opens df0:err.log (MODE_NEWFILE), writes two entries via LAB_14AB and closes.
; NOTES:
;   Returns -1 when logging is disabled or open fails.
;------------------------------------------------------------------------------
LAB_1487:
    MOVE.L  D7,-(A7)

    TST.L   LAB_2049
    BNE.S   .LAB_1488

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_1488:
    PEA     MODE_NEWFILE.W
    PEA     GLOB_STR_DF0_ERR_LOG
    JSR     JMP_TBL_DISKIO_OpenFileWithBuffer_2(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BNE.S   .LAB_1489

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_1489:
    MOVE.W  LAB_233A,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_2049,-(A7)
    MOVE.L  D7,-(A7)
    JSR     LAB_14AB(PC)

    PEA     1.W
    PEA     LAB_1B5E
    MOVE.L  D7,-(A7)
    JSR     LAB_14AB(PC)

    MOVE.L  D7,(A7)
    JSR     LAB_14AC(PC)

    LEA     24(A7),A7

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CALCULATE_H_T_C_MAX_VALUES   (Compute H/T delta max??)
; ARGS:
;   (none)
; RET:
;   D0: max delta (updated)
; CLOBBERS:
;   D0/D7
; CALLS:
;   none
; READS:
;   GLOB_WORD_H_VALUE, GLOB_WORD_T_VALUE, GLOB_WORD_MAX_VALUE
; WRITES:
;   GLOB_WORD_MAX_VALUE
; DESC:
;   Computes (H - T) modulo 64000, updating the stored max when larger.
; NOTES:
;   Wrap logic suggests a circular counter.
;------------------------------------------------------------------------------
CALCULATE_H_T_C_MAX_VALUES:
    MOVE.L  D7,-(A7)

    MOVEQ   #0,D0
    MOVE.W  GLOB_WORD_H_VALUE,D0
    MOVEQ   #0,D1
    MOVE.W  GLOB_WORD_T_VALUE,D1
    SUB.L   D1,D0
    MOVE.L  D0,D7
    TST.L   D7
    BPL.S   .replaceMaxValue

    ADDI.L  #64000,D7

.replaceMaxValue:
    MOVEQ   #0,D0
    MOVE.W  GLOB_WORD_MAX_VALUE,D0
    CMP.L   D7,D0
    BGE.S   .return

    MOVE.L  D7,D0
    MOVE.W  D0,GLOB_WORD_MAX_VALUE

.return:
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_MonitorClockChange   (Track clock delta / debounce??)
; ARGS:
;   (none)
; RET:
;   D0: status (0/1??)
; CLOBBERS:
;   D0-D2/D7
; CALLS:
;   LAB_1596
; READS:
;   GLOB_WORD_H_VALUE, GLOB_WORD_T_VALUE, GLOB_REF_CLOCKDATA_STRUCT,
;   LAB_20A3-20A8
; WRITES:
;   LAB_20A3-20A8
; DESC:
;   Detects changes between H and T values, compares to stored clockdata seconds,
;   and updates counters/flags, occasionally queuing an action via LAB_1596.
; NOTES:
;   Uses a 3-count threshold before clearing LAB_20A5.
;------------------------------------------------------------------------------
LAB_148E:
    MOVEM.L D2/D7,-(A7)

    MOVEQ   #0,D7       ; Prefill D7 with 0x00000000
    MOVE.W  GLOB_WORD_H_VALUE,D0     ; Not sure what these two bytes are but they're stored into D0 and D1
    MOVE.W  GLOB_WORD_T_VALUE,D1
    CMP.W   D1,D0       ; Compare D1 and D0 (D1 - D0)
    SNE     D2          ; If the zero flag is set (they're equal), D2 is 0xFF else 0x00
    NEG.B   D2          ; negate the above. now, zero flag is 0x00 else 0xFF
    EXT.W   D2          ; extend most significant byte D2 to a word... so now D2 is either 0x0000 or 0xFFFF
    EXT.L   D2          ; then again sign extend D2 to a longword (0x00000000 or 0xFFFFFFFF)
    MOVE.L  D2,D7       ; Move D2 into D7
    TST.W   D7          ; Test D7 against 0
    BEQ.S   .LAB_148F   ; If D7 is now 0, jump to .LAB_148F

    MOVE.W  GLOB_REF_CLOCKDATA_STRUCT,LAB_20A3  ; Get the first word of the clockdata struct, which is seconds
    MOVEQ   #1,D0               ; Move 1 into D0
    CMP.W   LAB_20A5,D0         ; Compare LAB_20A5 - D0 (1)
    BEQ.S   .return             ; If LAB_20A5 was 1, then return

    MOVEQ   #1,D1           ; Push 1 into D1
    MOVE.L  D1,-(A7)        ; Push D1 onto the stack
    MOVE.L  D1,-(A7)        ; Push it again onto the stack
    MOVE.W  D0,LAB_20A5     ; Push the least 2 sig bytes in D0 into LAB_20A5
    JSR     LAB_1596(PC)    ; JSR

    ADDQ.W  #8,A7           ; Add 8 to whatever value is in the stack (the stack pointer) clearing the last two values in the stack (D1 x2).
    BRA.S   .return

.LAB_148F:
    TST.W   LAB_20A5
    BEQ.S   .return

    MOVE.W  GLOB_REF_CLOCKDATA_STRUCT,D0
    MOVE.W  LAB_20A3,D1
    CMP.W   D0,D1
    BEQ.S   .return

    ADDQ.W  #1,LAB_20A4
    MOVE.W  D0,LAB_20A3
    CMPI.W  #3,LAB_20A4
    BLT.S   .return

    CLR.W   LAB_20A5
    CLR.L   -(A7)
    PEA     1.W
    JSR     LAB_1596(PC)

    ADDQ.W  #8,A7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D2/D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_UpdateCtrlHDeltaMax   (UpdateCtrlHDeltaMax??)
; ARGS:
;   (none)
; RET:
;   D0: current delta (non-negative, wrapped)
; CLOBBERS:
;   D0/D7
; CALLS:
;   (none)
; READS:
;   CTRL_H, LAB_2282, LAB_2283
; WRITES:
;   LAB_2283
; DESC:
;   Computes CTRL_H - LAB_2282 (wrapped by +500 if negative) and updates the
;   recorded max delta when the new value exceeds the previous max.
; NOTES:
;   Wrap size 500 suggests a ring buffer or modulo counter.
;------------------------------------------------------------------------------
PARSEINI_UpdateCtrlHDeltaMax:
LAB_1491:
    MOVE.L  D7,-(A7)

    MOVEQ   #0,D0
    MOVE.W  CTRL_H,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2282,D1
    SUB.L   D1,D0
    MOVE.L  D0,D7
    TST.L   D7
    BPL.S   .delta_ok

    ADDI.L  #500,D7

.delta_ok:
    MOVEQ   #0,D0
    MOVE.W  LAB_2283,D0
    CMP.L   D7,D0
    BGE.S   .return_status

    MOVE.L  D7,D0
    MOVE.W  D0,LAB_2283

.return_status:
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_CheckCtrlHChange   (Detect CTRL_H change and act??)
; ARGS:
;   (none)
; RET:
;   D0: boolean (nonzero when change detected and action taken)
; CLOBBERS:
;   D0-D2/D7
; CALLS:
;   LAB_1596
; READS:
;   CTRL_H, LAB_2282, LAB_2266, LAB_20A6-20A8, LAB_20A5
; WRITES:
;   LAB_20A6-20A8
; DESC:
;   Compares current CTRL_H to previous value, optionally triggers LAB_1596 when
;   changes are detected and control flags permit.
; NOTES:
;   Uses LAB_2266 as gate; resets LAB_20A5 when no change.
;------------------------------------------------------------------------------
LAB_1494:
    MOVEM.L D2/D7,-(A7)

    MOVEQ   #0,D7
    MOVE.W  CTRL_H,D0
    MOVE.W  LAB_2282,D1
    CMP.W   D1,D0
    SNE     D2
    NEG.B   D2
    EXT.W   D2
    EXT.L   D2
    MOVE.L  D2,D7
    TST.W   D7
    BEQ.S   .LAB_1495

    TST.W   LAB_2266
    BEQ.S   .LAB_1495

    MOVE.W  GLOB_REF_CLOCKDATA_STRUCT,LAB_20A6
    CLR.W   LAB_20A7
    MOVEQ   #1,D0
    CMP.W   LAB_20A8,D0
    BEQ.S   .return

    PEA     1.W
    PEA     16.W
    MOVE.W  D0,LAB_20A8
    JSR     LAB_1596(PC)

    ADDQ.W  #8,A7
    BRA.S   .return

.LAB_1495:
    TST.W   LAB_20A8
    BEQ.S   .return

    MOVE.W  GLOB_REF_CLOCKDATA_STRUCT,D0
    MOVE.W  LAB_20A6,D1
    CMP.W   D0,D1
    BEQ.S   .return

    MOVE.W  D0,LAB_20A6
    TST.W   LAB_2266
    BEQ.S   .LAB_1496

    ADDQ.W  #1,LAB_20A7
    CMPI.W  #3,LAB_20A7
    BLT.S   .return

.LAB_1496:
    CLR.W   LAB_20A8
    CLR.L   -(A7)
    PEA     16.W
    JSR     LAB_1596(PC)

    ADDQ.W  #8,A7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D2/D7
    RTS
