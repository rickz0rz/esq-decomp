;!======

LAB_135B:
    LINK.W  A5,#-8
    MOVEM.L D5-D7/A3,-(A7)
    MOVE.B  11(A5),D7
    MOVE.L  12(A5),D6
    MOVEA.L 16(A5),A3

    CLR.L   -4(A5)
    TST.L   D6
    BLE.W   LAB_1361

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     10.W
    PEA     47.W
    PEA     GLOB_STR_P_TYPE_C_1
    JSR     JMP_TBL_ALLOCATE_MEMORY_4(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   LAB_1361

    MOVEA.L D0,A0
    MOVE.B  D7,(A0)
    MOVE.L  D6,2(A0)
    MOVEA.L A3,A0

LAB_135C:
    TST.B   (A0)+
    BNE.S   LAB_135C

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    CMPA.L  D6,A0
    BNE.S   LAB_135D

    MOVE.L  D6,D1
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D1,-(A7)
    PEA     58.W
    PEA     GLOB_STR_P_TYPE_C_2
    JSR     JMP_TBL_ALLOCATE_MEMORY_4(PC)

    LEA     16(A7),A7
    MOVEA.L -4(A5),A0
    MOVE.L  D0,6(A0)
    BRA.S   LAB_135E

LAB_135D:
    SUBA.L  A0,A0
    MOVEA.L D0,A1
    MOVE.L  A0,6(A1)

LAB_135E:
    MOVEA.L -4(A5),A0
    TST.L   6(A0)
    BEQ.S   LAB_1360

    MOVEQ   #0,D5

LAB_135F:
    CMP.L   D6,D5
    BGE.S   LAB_1361

    MOVEA.L -4(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D5,A0
    MOVE.B  0(A3,D5.L),D0
    MOVE.B  D0,(A0)
    ADDQ.L  #1,D5
    BRA.S   LAB_135F

LAB_1360:
    PEA     10.W
    MOVE.L  -4(A5),-(A7)
    PEA     77.W
    PEA     GLOB_STR_P_TYPE_C_3
    JSR     JMP_TBL_DEALLOCATE_MEMORY_4(PC)

    LEA     16(A7),A7
    SUBA.L  A0,A0
    MOVE.L  A0,-4(A5)

LAB_1361:
    MOVE.L  -4(A5),D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

LAB_1362:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  A3,D0
    BEQ.S   LAB_1364

    TST.L   6(A3)
    BEQ.S   LAB_1363

    MOVE.L  2(A3),D0
    MOVE.L  D0,-(A7)
    MOVE.L  6(A3),-(A7)
    PEA     92.W
    PEA     GLOB_STR_P_TYPE_C_4
    JSR     JMP_TBL_DEALLOCATE_MEMORY_4(PC)

    LEA     16(A7),A7

LAB_1363:
    PEA     10.W
    MOVE.L  A3,-(A7)
    PEA     95.W
    PEA     GLOB_STR_P_TYPE_C_5
    JSR     JMP_TBL_DEALLOCATE_MEMORY_4(PC)

    LEA     16(A7),A7

LAB_1364:
    MOVEA.L (A7)+,A3
    RTS

;!======

LAB_1365:
    SUBA.L  A0,A0
    MOVE.L  A0,LAB_233C
    MOVE.L  A0,LAB_233B
    BSR.W   LAB_1387

    RTS

;!======

LAB_1366:
    LINK.W  A5,#-104
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2

    MOVE.L  A3,-(A7)
    BSR.S   LAB_1362

    ADDQ.W  #4,A7
    SUBA.L  A3,A3
    MOVE.L  A2,D0
    BEQ.S   LAB_1369

    MOVEQ   #0,D7

LAB_1367:
    CMP.L   2(A2),D7
    BGE.S   LAB_1368

    MOVEA.L 6(A2),A0
    ADDA.L  D7,A0
    MOVE.B  (A0),D0
    MOVE.B  D0,-100(A5,D7.L)
    ADDQ.L  #1,D7
    BRA.S   LAB_1367

LAB_1368:
    CLR.B   -100(A5,D7.L)
    MOVEQ   #0,D0
    MOVE.B  (A2),D0
    PEA     -100(A5)
    MOVE.L  2(A2),-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_135B

    LEA     12(A7),A7
    MOVEA.L D0,A3

LAB_1369:
    MOVE.L  A3,D0
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_136A:
    TST.L   LAB_233B
    BEQ.S   LAB_136B

    TST.L   LAB_233C
    BNE.S   LAB_136B

    MOVE.L  LAB_233B,-(A7)
    MOVE.L  LAB_233C,-(A7)
    BSR.S   LAB_1366

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_233C
    MOVEA.L D0,A0
    MOVE.B  LAB_222D,(A0)

LAB_136B:
    RTS

;!======

LAB_136C:
    MOVE.L  LAB_233B,-(A7)
    BSR.W   LAB_1362

    ADDQ.W  #4,A7
    MOVE.L  LAB_233C,LAB_233B
    CLR.L   LAB_233C
    RTS

;!======

LAB_136D:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7
    MOVE.L  A3,D0
    BEQ.S   LAB_136E

    MOVEQ   #20,D0
    CMP.B   (A3),D0
    BNE.S   LAB_136E

    TST.B   1(A3)
    BEQ.S   LAB_136E

    MOVE.B  1(A3),D7

LAB_136E:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

LAB_136F:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEQ   #0,D7
    TST.L   LAB_233B
    BEQ.S   LAB_1372

    MOVEA.L LAB_233B,A0
    MOVE.L  2(A0),D0
    TST.L   D0
    BLE.S   LAB_1372

    MOVEQ   #0,D6

LAB_1370:
    TST.L   D7
    BNE.S   LAB_1372

    MOVEA.L LAB_233B,A0
    CMP.L   2(A0),D6
    BGE.S   LAB_1372

    MOVEA.L LAB_233B,A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  (A3),D0
    CMP.B   (A0),D0
    BNE.S   LAB_1371

    MOVEQ   #1,D7

LAB_1371:
    ADDQ.L  #1,D6
    BRA.S   LAB_1370

LAB_1372:
    CLR.B   (A3)
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

LAB_1373:
    LINK.W  A5,#-24
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D4
    PEA     3.W
    MOVE.L  A3,-(A7)
    PEA     -16(A5)
    JSR     LAB_15A1(PC)

    CLR.B   -13(A5)
    PEA     -16(A5)
    JSR     LAB_159A(PC)

    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVE.L  D0,D7
    ADDQ.L  #3,A3
    PEA     2.W
    MOVE.L  A3,-(A7)
    PEA     -16(A5)
    JSR     LAB_15A1(PC)

    CLR.B   -14(A5)
    PEA     -16(A5)
    JSR     LAB_159A(PC)

    LEA     32(A7),A7
    MOVE.L  D0,D6
    ADDQ.L  #2,A3
    MOVE.B  LAB_2230,D0
    CMP.B   D7,D0
    BNE.S   LAB_1374

    MOVEQ   #0,D5
    BRA.S   LAB_1376

LAB_1374:
    MOVE.B  LAB_222D,D0
    CMP.B   D0,D7
    BNE.S   LAB_1375

    MOVEQ   #1,D5
    BRA.S   LAB_1376

LAB_1375:
    MOVEQ   #2,D5

LAB_1376:
    MOVEQ   #2,D0
    CMP.W   D0,D5
    BEQ.S   LAB_1377

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_233B,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    BSR.W   LAB_1362

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_233B,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  A3,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,32(A7)
    BSR.W   LAB_135B

    LEA     12(A7),A7
    MOVEA.L 20(A7),A0
    MOVE.L  D0,(A0)
    MOVEQ   #1,D4

LAB_1377:
    MOVE.L  D4,D0
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

LAB_1378:
    LINK.W  A5,#-120
    MOVEM.L D5-D7,-(A7)
    PEA     1006.W
    PEA     LAB_204F
    JSR     JMP_TBL_DISKIO_OpenFileWithBuffer_2(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BEQ.W   LAB_1386

    LEA     LAB_2050,A0
    LEA     -109(A5),A1

LAB_1379:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_1379

    MOVEQ   #0,D5

LAB_137A:
    MOVEQ   #2,D0
    CMP.L   D0,D5
    BEQ.W   LAB_1385

    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     LAB_233B,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    LEA     -109(A5),A0
    MOVEA.L A0,A1

LAB_137B:
    TST.B   (A1)+
    BNE.S   LAB_137B

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D7,-(A7)
    JSR     LAB_14AB(PC)

    LEA     12(A7),A7
    TST.L   -8(A5)
    BEQ.W   LAB_1380

    MOVEA.L -8(A5),A0
    MOVE.L  2(A0),D0
    TST.L   D0
    BLE.W   LAB_1380

    MOVEQ   #0,D1
    MOVE.B  (A0),D1
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    PEA     LAB_2051
    PEA     -109(A5)
    JSR     JMP_TBL_PRINTF_4(PC)

    LEA     -109(A5),A0
    MOVEA.L A0,A1

LAB_137C:
    TST.B   (A1)+
    BNE.S   LAB_137C

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D7,-(A7)
    JSR     LAB_14AB(PC)

    LEA     24(A7),A7
    MOVEQ   #0,D6

LAB_137D:
    MOVEA.L -8(A5),A0
    CMP.L   2(A0),D6
    BGE.S   LAB_137E

    MOVEA.L -8(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  (A0),D0
    MOVE.B  D0,-109(A5,D6.L)
    ADDQ.L  #1,D6
    BRA.S   LAB_137D

LAB_137E:
    MOVEA.L D6,A0
    ADDQ.L  #1,D6
    MOVE.L  A0,D0
    MOVE.B  #$a,-109(A5,D0.L)
    CLR.B   -109(A5,D6.L)
    LEA     -109(A5),A0
    MOVEA.L A0,A1

LAB_137F:
    TST.B   (A1)+
    BNE.S   LAB_137F

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D7,-(A7)
    JSR     LAB_14AB(PC)

    LEA     12(A7),A7
    BRA.S   LAB_1381

LAB_1380:
    PEA     9.W
    PEA     LAB_2052
    MOVE.L  D7,-(A7)
    JSR     LAB_14AB(PC)

    LEA     12(A7),A7

LAB_1381:
    MOVE.L  D5,D0
    TST.L   D0
    BEQ.S   LAB_1382

    SUBQ.L  #1,D0
    BEQ.S   LAB_1384

    BRA.S   LAB_1384

LAB_1382:
    MOVEQ   #1,D5
    LEA     LAB_2053,A0
    LEA     -109(A5),A1

LAB_1383:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_1383

    BRA.W   LAB_137A

LAB_1384:
    MOVEQ   #2,D5
    BRA.W   LAB_137A

LAB_1385:
    MOVE.L  D7,-(A7)
    JSR     LAB_14AC(PC)

    ADDQ.W  #4,A7

LAB_1386:
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======

LAB_1387:
    LINK.W  A5,#-52
    MOVEM.L D4-D7,-(A7)
    PEA     LAB_2054
    JSR     LAB_1465(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.W   LAB_1399

    MOVE.L  LAB_21BC,-4(A5)
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D7
    CLR.L   -48(A5)
    LEA     LAB_2055,A0
    LEA     -39(A5),A1

LAB_1388:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_1388

LAB_1389:
    MOVEQ   #2,D0
    CMP.L   -48(A5),D0
    BEQ.W   LAB_1398

    PEA     -39(A5)
    MOVE.L  -4(A5),-(A7)
    JSR     LAB_139A(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.W   LAB_1394

    LEA     -39(A5),A0
    MOVEA.L A0,A1

LAB_138A:
    TST.B   (A1)+
    BNE.S   LAB_138A

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADD.L   D0,-8(A5)

LAB_138B:
    MOVEA.L -8(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   LAB_138C

    ADDQ.L  #1,-8(A5)
    BRA.S   LAB_138B

LAB_138C:
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_159A(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D6
    MOVE.B  LAB_2230,D0
    CMP.B   D6,D0
    BNE.S   LAB_138D

    MOVEQ   #0,D4
    BRA.S   LAB_138F

LAB_138D:
    MOVE.B  LAB_222D,D0
    CMP.B   D0,D6
    BNE.S   LAB_138E

    MOVEQ   #1,D4
    BRA.S   LAB_138F

LAB_138E:
    MOVEQ   #2,D4

LAB_138F:
    MOVEQ   #2,D0
    CMP.L   D0,D4
    BEQ.W   LAB_1394

LAB_1390:
    MOVEA.L -8(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   LAB_1391

    ADDQ.L  #1,-8(A5)
    BRA.S   LAB_1390

LAB_1391:
    MOVEA.L -8(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   LAB_1392

    ADDQ.L  #1,-8(A5)
    BRA.S   LAB_1391

LAB_1392:
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_159A(PC)

    ADDQ.W  #4,A7
    CLR.L   -16(A5)
    MOVE.L  D0,-52(A5)
    BLE.S   LAB_1393

    PEA     LAB_2056
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_139A(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    BEQ.S   LAB_1393

    MOVEQ   #7,D0
    ADD.L   D0,-8(A5)
    MOVEA.L -8(A5),A0
    MOVE.L  -52(A5),D0
    MOVE.B  0(A0,D0.L),D5
    CLR.B   0(A0,D0.L)
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    BSR.W   LAB_135B

    LEA     12(A7),A7
    MOVEA.L -8(A5),A0
    MOVE.L  -52(A5),D1
    MOVE.B  D5,0(A0,D1.L)
    MOVE.L  D0,-16(A5)

LAB_1393:
    MOVE.L  D4,D0
    ASL.L   #2,D0
    LEA     LAB_233B,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    BSR.W   LAB_1362

    ADDQ.W  #4,A7
    MOVE.L  D4,D0
    ASL.L   #2,D0
    LEA     LAB_233B,A0
    ADDA.L  D0,A0
    MOVE.L  -16(A5),(A0)

LAB_1394:
    MOVE.L  -48(A5),D0
    TST.L   D0
    BEQ.S   LAB_1395

    SUBQ.L  #1,D0
    BEQ.S   LAB_1397

    BRA.S   LAB_1397

LAB_1395:
    MOVEQ   #1,D0
    MOVE.L  D0,-48(A5)
    LEA     LAB_2057,A0
    LEA     -39(A5),A1

LAB_1396:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_1396

    BRA.W   LAB_1389

LAB_1397:
    MOVEQ   #2,D0
    MOVE.L  D0,-48(A5)
    BRA.W   LAB_1389

LAB_1398:
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     406.W
    PEA     GLOB_STR_P_TYPE_C_6
    JSR     JMP_TBL_DEALLOCATE_MEMORY_4(PC)

    LEA     16(A7),A7

LAB_1399:
    MOVEQ   #1,D0
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======

LAB_139A:
    JMP     LAB_1A97

;!======

    ; Alignment
    MOVEQ   #97,D0
