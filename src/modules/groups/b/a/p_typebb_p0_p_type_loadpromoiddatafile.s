    XDEF    _P_TYPE_LoadPromoIdDataFile


;------------------------------------------------------------------------------
; FUNC: _P_TYPE_LoadPromoIdDataFile   (Parse PROMOID.DAT into primary/secondary lists)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +12: arg_2 (via 16(A5))
;   stack +35: arg_3 (via 39(A5))
;   stack +44: arg_4 (via 48(A5))
;   stack +48: arg_5 (via 52(A5))
; CLOBBERS:
;   A0/A1/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   _P_TYPE_FreeEntry, _PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer, _P_TYPE_AllocateEntry, _P_TYPE_JMPTBL_STRING_FindSubstring, _SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, _SCRIPT_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _Global_REF_LONG_FILE_SCRATCH, _Global_STR_P_TYPE_C_6, _P_TYPE_PATH_DF0_COLON_PROMOID_DOT_DAT_Load, _P_TYPE_STR_CURDAY_COLON_LoadSection, _P_TYPE_STR_TYPES_COLON, _P_TYPE_STR_NXTDAY_COLON_LoadSection, _WDISP_CharClassTable, _Global_PTR_WORK_BUFFER, _TEXTDISP_SecondaryGroupCode, _TEXTDISP_PrimaryGroupCode, _P_TYPE_PrimaryGroupListPtr, if_eq_1394, if_eq_1398, if_eq_1399, loop_1389
; WRITES:
;   (none observed)
; DESC:
;   Loads PROMOID.DAT into a work buffer, parses CURDAY/NXTDAY sections, and
;   rebuilds list entries keyed by primary/secondary group codes.
; NOTES:
;   Existing slot entries are freed before replacement.
;------------------------------------------------------------------------------
_P_TYPE_LoadPromoIdDataFile:
    LINK.W  A5,#-52
    MOVEM.L D4-D7,-(A7)
    PEA     _P_TYPE_PATH_DF0_COLON_PROMOID_DOT_DAT_Load
    JSR     _PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.W   .if_eq_1399

    MOVE.L  _Global_PTR_WORK_BUFFER,-4(A5)
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D7
    CLR.L   -48(A5)
    LEA     _P_TYPE_STR_CURDAY_COLON_LoadSection,A0
    LEA     -39(A5),A1

.if_ne_1388:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .if_ne_1388

.loop_1389:
    MOVEQ   #2,D0
    CMP.L   -48(A5),D0
    BEQ.W   .if_eq_1398

    PEA     -39(A5)
    MOVE.L  -4(A5),-(A7)
    JSR     _P_TYPE_JMPTBL_STRING_FindSubstring(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.W   .if_eq_1394

    LEA     -39(A5),A0
    MOVEA.L A0,A1

.if_ne_138A:
    TST.B   (A1)+
    BNE.S   .if_ne_138A

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADD.L   D0,-8(A5)

.loop_138B:
    MOVEA.L -8(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .if_eq_138C

    ADDQ.L  #1,-8(A5)
    BRA.S   .loop_138B

.if_eq_138C:
    MOVE.L  -8(A5),-(A7)
    JSR     _SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D6
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D6,D0
    BNE.S   .if_ne_138D

    MOVEQ   #0,D4
    BRA.S   .skip_138F

.if_ne_138D:
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D0,D6
    BNE.S   .if_ne_138E

    MOVEQ   #1,D4
    BRA.S   .skip_138F

.if_ne_138E:
    MOVEQ   #2,D4

.skip_138F:
    MOVEQ   #2,D0
    CMP.L   D0,D4
    BEQ.W   .if_eq_1394

.loop_1390:
    MOVEA.L -8(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   .loop_1391

    ADDQ.L  #1,-8(A5)
    BRA.S   .loop_1390

.loop_1391:
    MOVEA.L -8(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .if_eq_1392

    ADDQ.L  #1,-8(A5)
    BRA.S   .loop_1391

.if_eq_1392:
    MOVE.L  -8(A5),-(A7)
    JSR     _SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    CLR.L   -16(A5)
    MOVE.L  D0,-52(A5)
    BLE.S   .branch_1393

    PEA     _P_TYPE_STR_TYPES_COLON
    MOVE.L  -8(A5),-(A7)
    JSR     _P_TYPE_JMPTBL_STRING_FindSubstring(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    BEQ.S   .branch_1393

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
    BSR.W   _P_TYPE_AllocateEntry

    LEA     12(A7),A7
    MOVEA.L -8(A5),A0
    MOVE.L  -52(A5),D1
    MOVE.B  D5,0(A0,D1.L)
    MOVE.L  D0,-16(A5)

.branch_1393:
    MOVE.L  D4,D0
    ASL.L   #2,D0
    LEA     _P_TYPE_PrimaryGroupListPtr,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    BSR.W   _P_TYPE_FreeEntry

    ADDQ.W  #4,A7
    MOVE.L  D4,D0
    ASL.L   #2,D0
    LEA     _P_TYPE_PrimaryGroupListPtr,A0
    ADDA.L  D0,A0
    MOVE.L  -16(A5),(A0)

.if_eq_1394:
    MOVE.L  -48(A5),D0
    TST.L   D0
    BEQ.S   .if_eq_1395

    SUBQ.L  #1,D0
    BEQ.S   .skip_1397

    BRA.S   .skip_1397

.if_eq_1395:
    MOVEQ   #1,D0
    MOVE.L  D0,-48(A5)
    LEA     _P_TYPE_STR_NXTDAY_COLON_LoadSection,A0
    LEA     -39(A5),A1

.if_ne_1396:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .if_ne_1396

    BRA.W   .loop_1389

.skip_1397:
    MOVEQ   #2,D0
    MOVE.L  D0,-48(A5)
    BRA.W   .loop_1389

.if_eq_1398:
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     406.W
    PEA     _Global_STR_P_TYPE_C_6
    JSR     _SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.if_eq_1399:
    MOVEQ   #1,D0
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======