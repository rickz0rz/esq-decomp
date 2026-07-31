    XDEF    _P_TYPE_WritePromoIdDataFile


;------------------------------------------------------------------------------
; FUNC: _P_TYPE_WritePromoIdDataFile   (Serialize current lists to PROMOID.DAT)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +105: arg_2 (via 109(A5))
; CLOBBERS:
;   A0/A1/A5/A7/D0/D1/D5/D6/D7
; CALLS:
;   _PARSEINI_JMPTBL_WDISP_SPrintf, _SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer, _SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush, _SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes
; READS:
;   _P_TYPE_PATH_DF0_COLON_PROMOID_DOT_DAT_Write, _P_TYPE_STR_CURDAY_COLON_WriteSection, _P_TYPE_FMT_PCT_03D_PCT_02D, _P_TYPE_STR_NO_DATA, _P_TYPE_STR_NXTDAY_COLON_WriteSection, _P_TYPE_PrimaryGroupListPtr, branch_1380, if_eq_1385, loop_137A, return_1386
; WRITES:
;   (none observed)
; DESC:
;   Opens PROMOID.DAT and writes CURDAY/NXTDAY list sections, emitting either
;   formatted list entries or "NO DATA" placeholders.
; NOTES:
;   Writes two sections by iterating list selectors 0 then 1.
;------------------------------------------------------------------------------
_P_TYPE_WritePromoIdDataFile:
    LINK.W  A5,#-120
    MOVEM.L D5-D7,-(A7)
    PEA     1006.W
    PEA     _P_TYPE_PATH_DF0_COLON_PROMOID_DOT_DAT_Write
    JSR     _SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BEQ.W   .return_1386

    LEA     _P_TYPE_STR_CURDAY_COLON_WriteSection,A0
    LEA     -109(A5),A1

.if_ne_1379:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .if_ne_1379

    MOVEQ   #0,D5

.loop_137A:
    MOVEQ   #2,D0
    CMP.L   D0,D5
    BEQ.W   .if_eq_1385

    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     _P_TYPE_PrimaryGroupListPtr,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    LEA     -109(A5),A0
    MOVEA.L A0,A1

.if_ne_137B:
    TST.B   (A1)+
    BNE.S   .if_ne_137B

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D7,-(A7)
    JSR     _SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7
    TST.L   -8(A5)
    BEQ.W   .branch_1380

    MOVEA.L -8(A5),A0
    MOVE.L  2(A0),D0
    TST.L   D0
    BLE.W   .branch_1380

    MOVEQ   #0,D1
    MOVE.B  (A0),D1
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    PEA     _P_TYPE_FMT_PCT_03D_PCT_02D
    PEA     -109(A5)
    JSR     _PARSEINI_JMPTBL_WDISP_SPrintf(PC)

    LEA     -109(A5),A0
    MOVEA.L A0,A1

.if_ne_137C:
    TST.B   (A1)+
    BNE.S   .if_ne_137C

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D7,-(A7)
    JSR     _SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    LEA     24(A7),A7
    MOVEQ   #0,D6

.loop_137D:
    MOVEA.L -8(A5),A0
    CMP.L   2(A0),D6
    BGE.S   .if_ge_137E

    MOVEA.L -8(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  (A0),D0
    MOVE.B  D0,-109(A5,D6.L)
    ADDQ.L  #1,D6
    BRA.S   .loop_137D

.if_ge_137E:
    MOVEA.L D6,A0
    ADDQ.L  #1,D6
    MOVE.L  A0,D0
    MOVE.B  #$a,-109(A5,D0.L)
    CLR.B   -109(A5,D6.L)
    LEA     -109(A5),A0
    MOVEA.L A0,A1

.if_ne_137F:
    TST.B   (A1)+
    BNE.S   .if_ne_137F

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D7,-(A7)
    JSR     _SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7
    BRA.S   .skip_1381

.branch_1380:
    PEA     9.W
    PEA     _P_TYPE_STR_NO_DATA
    MOVE.L  D7,-(A7)
    JSR     _SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.skip_1381:
    MOVE.L  D5,D0
    TST.L   D0
    BEQ.S   .if_eq_1382

    SUBQ.L  #1,D0
    BEQ.S   .skip_1384

    BRA.S   .skip_1384

.if_eq_1382:
    MOVEQ   #1,D5
    LEA     _P_TYPE_STR_NXTDAY_COLON_WriteSection,A0
    LEA     -109(A5),A1

.if_ne_1383:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .if_ne_1383

    BRA.W   .loop_137A

.skip_1384:
    MOVEQ   #2,D5
    BRA.W   .loop_137A

.if_eq_1385:
    MOVE.L  D7,-(A7)
    JSR     _SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush(PC)

    ADDQ.W  #4,A7

.return_1386:
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======