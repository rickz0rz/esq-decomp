;!======

LAB_1311:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7
    SUBA.L  A0,A0
    MOVE.L  A0,-6(A5)
    MOVE.L  A3,D0
    BNE.S   LAB_1312

    MOVEQ   #4,D0
    MOVE.L  D0,LAB_203D
    BRA.W   LAB_131E

LAB_1312:
    MOVE.L  LAB_203D,D0
    SUBQ.L  #4,D0
    BEQ.S   LAB_1313

    SUBQ.L  #1,D0
    BEQ.W   LAB_131A

    BRA.W   LAB_131D

LAB_1313:
    TST.L   (A2)
    BEQ.W   LAB_131E

    TST.L   4(A2)
    BEQ.W   LAB_131E

    PEA     1.W
    PEA     20.W
    PEA     612.W
    JSR     LAB_1358(PC)

    LEA     12(A7),A7
    MOVE.W  20(A2),D6
    MOVEQ   #48,D0
    CMP.W   D0,D6
    BLE.S   LAB_1314

    SUBI.W  #$30,D6

LAB_1314:
    TST.W   LAB_2016
    BEQ.S   LAB_1315

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  (A2),-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_130C

    ADDQ.W  #8,A7
    TST.W   D0
    BNE.S   LAB_1315

    LEA     60(A3),A0
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     3.W
    MOVEQ   #1,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  4(A2),-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_107F

    LEA     28(A7),A7
    BRA.S   LAB_1316

LAB_1315:
    LEA     60(A3),A0
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEQ   #3,D1
    MOVE.L  D1,-(A7)
    PEA     1.W
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  4(A2),-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_107F

    LEA     28(A7),A7

LAB_1316:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     2000.W
    PEA     3947.W
    PEA     GLOB_STR_NEWGRID2_C_1
    JSR     JMP_TBL_ALLOCATE_MEMORY_4(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-6(A5)
    BEQ.S   LAB_1317

    PEA     3.W
    JSR     LAB_1338(PC)

    MOVE.L  D7,(A7)
    MOVE.L  -6(A5),-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_12D0

    LEA     60(A3),A0
    MOVE.L  -6(A5),(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1339(PC)

    PEA     2000.W
    MOVE.L  -6(A5),-(A7)
    PEA     3953.W
    PEA     GLOB_STR_NEWGRID2_C_2
    JSR     JMP_TBL_DEALLOCATE_MEMORY_4(PC)

    LEA     36(A7),A7

LAB_1317:
    MOVE.L  A3,-(A7)
    BSR.W   LAB_12FD

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   LAB_1318

    MOVEQ   #4,D0
    BRA.S   LAB_1319

LAB_1318:
    MOVEQ   #5,D0

LAB_1319:
    PEA     2.W
    MOVE.L  D0,LAB_203D
    JSR     LAB_1344(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,32(A3)
    BRA.S   LAB_131E

LAB_131A:
    MOVE.L  A3,-(A7)
    BSR.W   LAB_12FD

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   LAB_131B

    MOVEQ   #4,D0
    BRA.S   LAB_131C

LAB_131B:
    MOVEQ   #5,D0

LAB_131C:
    MOVEQ   #-1,D1
    MOVE.L  D1,32(A3)
    MOVE.L  D0,LAB_203D
    BRA.S   LAB_131E

LAB_131D:
    MOVEQ   #4,D0
    MOVE.L  D0,LAB_203D

LAB_131E:
    MOVE.L  LAB_203D,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_131F:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVE.L  28(A7),D6
    MOVEQ   #0,D5
    MOVE.L  A3,D0
    BNE.S   LAB_1321

    MOVEQ   #5,D0
    CMP.L   LAB_2041,D0
    BNE.S   LAB_1320

    MOVE.L  D6,-(A7)
    PEA     LAB_2332
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1311

    LEA     12(A7),A7

LAB_1320:
    MOVEQ   #0,D0
    MOVE.L  D0,LAB_2041
    BRA.W   LAB_1328

LAB_1321:
    MOVE.L  LAB_2041,D0
    CMPI.L  #$6,D0
    BCC.W   LAB_1327

    ADD.W   D0,D0
    MOVE.W  LAB_1322(PC,D0.W),D0
    JMP     LAB_1323(PC,D0.W)

LAB_1322:
    DC.W    $000a

LAB_1323:
    ORI.B   #$f2,-(A0)
    ORI.W   #$6a,136(A2)
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_2332
    BSR.W   LAB_12B4

    LEA     12(A7),A7
    MOVE.L  D6,-(A7)
    PEA     LAB_2332
    MOVE.L  LAB_2041,-(A7)
    BSR.W   LAB_12BB

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   LAB_1324

    MOVE.L  D6,-(A7)
    MOVE.L  LAB_2332,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_12EF

    LEA     12(A7),A7
    MOVEQ   #0,D0
    MOVEQ   #3,D1
    MOVE.L  D1,LAB_2041
    MOVE.L  D0,LAB_2040
    BRA.W   LAB_1328

LAB_1324:
    CLR.L   LAB_2041
    BRA.W   LAB_1328

    MOVE.L  D6,-(A7)
    PEA     LAB_2332
    MOVE.L  LAB_2041,-(A7)
    BSR.W   LAB_12BB

    MOVE.L  D6,(A7)
    BSR.W   LAB_129F

    LEA     12(A7),A7
    MOVE.L  D0,D5
    TST.L   LAB_2332
    BEQ.S   LAB_1326

    MOVE.L  D6,-(A7)
    PEA     LAB_2332
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1311

    MOVE.L  D6,(A7)
    MOVE.L  D0,LAB_2041
    BSR.W   LAB_129F

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   LAB_1328

    TST.L   D5
    BEQ.S   LAB_1325

    CMPI.L  #$1,LAB_2040
    BGE.S   LAB_1325

    PEA     50.W
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1038

    BSR.W   LAB_106E

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_2040

LAB_1325:
    MOVE.L  A3,-(A7)
    BSR.W   LAB_106B

    ADDQ.W  #4,A7
    SUB.L   D0,LAB_2040
    BRA.S   LAB_1328

LAB_1326:
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_2041
    BRA.S   LAB_1328

LAB_1327:
    CLR.L   LAB_2041

LAB_1328:
    TST.L   LAB_2041
    BNE.S   LAB_1329

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    BSR.W   LAB_12AB

    ADDQ.W  #8,A7

LAB_1329:
    MOVE.L  LAB_2041,D0
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

LAB_132A:
    MOVEM.L D5-D7/A3,-(A7)
    MOVE.L  20(A7),D7
    MOVEA.L 24(A7),A3
    MOVE.W  30(A7),D6
    MOVE.W  34(A7),D5
    TST.L   D7
    BNE.S   LAB_132B

    SUBA.L  A3,A3
    MOVE.L  LAB_2042,D7
    CLR.L   LAB_2042
    BRA.S   LAB_132C

LAB_132B:
    MOVE.L  D7,LAB_2042

LAB_132C:
    TST.W   LAB_1E86
    BEQ.S   LAB_132D

    CLR.W   LAB_1E86
    SUBA.L  A3,A3

LAB_132D:
    MOVE.L  D7,LAB_2014
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    BLT.W   LAB_1330

    CMPI.L  #$7,D0
    BGE.W   LAB_1330

    ADD.W   D0,D0
    MOVE.W  LAB_132E(PC,D0.W),D0
    JMP     LAB_132F(PC,D0.W)

LAB_132E:
    DC.W    $000c

LAB_132F:
    ORI.B   #$44,-(A4)
    ORI.W   #$7a,(A6)+
    ORI.L   #$ae2006,(A0)
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1149

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_2043
    BRA.W   LAB_1331

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_11AD

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2043
    BRA.W   LAB_1331

    MOVE.L  D6,D0
    EXT.L   D0
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_131F

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2043
    BRA.S   LAB_1331

    MOVE.L  D6,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_131F

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2043
    BRA.S   LAB_1331

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1168

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_2043
    BRA.S   LAB_1331

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_11DF

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2043
    BRA.S   LAB_1331

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_128A

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2043
    BRA.S   LAB_1331

LAB_1330:
    CLR.L   LAB_2014

LAB_1331:
    TST.L   LAB_2043
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

LAB_1332:
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_132A

    LEA     16(A7),A7
    RTS

;!======

LAB_1333:
    TST.L   LAB_2044
    BEQ.S   LAB_1334

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     1208.W
    PEA     4153.W
    PEA     GLOB_STR_NEWGRID2_C_3
    JSR     JMP_TBL_ALLOCATE_MEMORY_4(PC)

    MOVE.L  D0,LAB_2013
    BSR.W   LAB_1070

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    PEA     1000.W
    PEA     4156.W
    PEA     GLOB_STR_NEWGRID2_C_4
    JSR     JMP_TBL_ALLOCATE_MEMORY_4(PC)

    LEA     28(A7),A7
    CLR.L   LAB_2044
    MOVE.L  D0,LAB_2335

LAB_1334:
    RTS

;!======

LAB_1335:
    TST.L   LAB_2335
    BEQ.S   LAB_1336

    PEA     1000.W
    MOVE.L  LAB_2335,-(A7)
    PEA     4164.W
    PEA     GLOB_STR_NEWGRID2_C_5
    JSR     JMP_TBL_DEALLOCATE_MEMORY_4(PC)

    CLR.L   LAB_2335
    PEA     1208.W
    MOVE.L  LAB_2013,-(A7)
    PEA     4167.W
    PEA     GLOB_STR_NEWGRID2_C_6
    JSR     JMP_TBL_DEALLOCATE_MEMORY_4(PC)

    LEA     32(A7),A7
    CLR.L   LAB_2013

LAB_1336:
    RTS

;!======

LAB_1337:
    JMP     LAB_0347

LAB_1338:
    JMP     LAB_05AC

LAB_1339:
    JMP     LAB_059F

LAB_133A:
    JMP     LAB_05B5

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

LAB_133B:
    JMP     LAB_17E6

LAB_133C:
    JMP     LAB_05AA

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

LAB_133D:
    JMP     LAB_00ED

LAB_133E:
    JMP     LAB_0926

LAB_133F:
    JMP     LAB_00E8

LAB_1340:
    JMP     LAB_0597

LAB_1341:
    JMP     LAB_027A

LAB_1342:
    JMP     LAB_0358

LAB_1343:
    JMP     LAB_091F

LAB_1344:
    JMP     LAB_05AE

LAB_1345:
    JMP     LAB_0923

LAB_1346:
    JMP     LAB_05BC

LAB_1347:
    JMP     LAB_036C

LAB_1348:
    JMP     LAB_01E9

LAB_1349:
    JMP     LAB_00EC

LAB_134A:
    JMP     LAB_0095

LAB_134B:
    JMP     LAB_1985

LAB_134C:
    JMP     LAB_1962

LAB_134D:
    JMP     LAB_08DF

LAB_134E:
    JMP     LAB_1A23

LAB_134F:
    JMP     LAB_0277

LAB_1350:
    JMP     LAB_05BA

LAB_1351:
    JMP     LAB_05B9

LAB_1352:
    JMP     LAB_00EB

LAB_1353:
    JMP     LAB_054C

LAB_1354:
    JMP     LAB_0592

LAB_1355:
    JMP     LAB_00B1

LAB_1356:
    JMP     LAB_00E9

LAB_1357:
    JMP     LAB_05BB

LAB_1358:
    JMP     LAB_058D

LAB_1359:
    JMP     LAB_05B6

LAB_135A:
    JMP     LAB_00EA

    RTS

;!======

    ; Alignment
    ALIGN_WORD
