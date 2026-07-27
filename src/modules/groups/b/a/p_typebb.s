    XDEF    P_TYPE_ConsumePrimaryTypeIfPresent
    XDEF    P_TYPE_GetSubtypeIfType20
    XDEF    _P_TYPE_LoadPromoIdDataFile
    XDEF    P_TYPE_ParseAndStoreTypeRecord
    XDEF    P_TYPE_WritePromoIdDataFile
    XDEF    P_TYPE_JMPTBL_STRING_FindSubstring

;------------------------------------------------------------------------------
; FUNC: P_TYPE_GetSubtypeIfType20   (Return subtype byte for type-20 entries)
; ARGS:
;   stack +8: entryPtr (struct PTypeEntry *)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D7
; CALLS:
;   (none)
; READS:
;   entry type byte at +0, subtype byte at +1
; WRITES:
;   (none observed)
; DESC:
;   Returns entry[1] only when entry exists, entry[0]==20, and entry[1]!=0.
; NOTES:
;   Returns 0 for non-type-20 entries or missing subtype.
;------------------------------------------------------------------------------
P_TYPE_GetSubtypeIfType20:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7
    MOVE.L  A3,D0
    BEQ.S   .return_136E

    MOVEQ   #20,D0
    CMP.B   (A3),D0
    BNE.S   .return_136E

    TST.B   1(A3)
    BEQ.S   .return_136E

    MOVE.B  1(A3),D7

.return_136E:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: P_TYPE_ConsumePrimaryTypeIfPresent   (Test first byte against primary list and clear it)
; ARGS:
;   stack +8: inOutBytePtr (u8 *)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A7/D0/D6/D7
; CALLS:
;   (none)
; READS:
;   _P_TYPE_PrimaryGroupListPtr
; WRITES:
;   *inOutBytePtr
; DESC:
;   Searches primary list payload for the input byte, returns 1 if found, and
;   clears the input byte in all cases.
; NOTES:
;   Returns 0 when list is missing/empty or no byte match is present.
;------------------------------------------------------------------------------
P_TYPE_ConsumePrimaryTypeIfPresent:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEQ   #0,D7
    TST.L   _P_TYPE_PrimaryGroupListPtr
    BEQ.S   .branch_1372

    MOVEA.L _P_TYPE_PrimaryGroupListPtr,A0
    MOVE.L  2(A0),D0
    TST.L   D0
    BLE.S   .branch_1372

    MOVEQ   #0,D6

.loop_1370:
    TST.L   D7
    BNE.S   .branch_1372

    MOVEA.L _P_TYPE_PrimaryGroupListPtr,A0
    CMP.L   2(A0),D6
    BGE.S   .branch_1372

    MOVEA.L _P_TYPE_PrimaryGroupListPtr,A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  (A3),D0
    CMP.B   (A0),D0
    BNE.S   .if_ne_1371

    MOVEQ   #1,D7

.if_ne_1371:
    ADDQ.L  #1,D6
    BRA.S   .loop_1370

.branch_1372:
    CLR.B   (A3)
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: P_TYPE_ParseAndStoreTypeRecord   (Parse one type line and update selected list)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +9: arg_2 (via 13(A5))
;   stack +10: arg_3 (via 14(A5))
;   stack +12: arg_4 (via 16(A5))
; CLOBBERS:
;   A0/A3/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   _P_TYPE_FreeEntry, P_TYPE_AllocateEntry, SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, SCRIPT3_JMPTBL_STRING_CopyPadNul
; READS:
;   _TEXTDISP_SecondaryGroupCode, _TEXTDISP_PrimaryGroupCode, _P_TYPE_PrimaryGroupListPtr
; WRITES:
;   (none observed)
; DESC:
;   Parses group code + payload length from text, selects primary/secondary slot,
;   then replaces that slot with a newly allocated entry.
; NOTES:
;   Returns 1 when a slot is updated, 0 when parsed group code is unsupported.
;------------------------------------------------------------------------------
P_TYPE_ParseAndStoreTypeRecord:
    LINK.W  A5,#-24
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D4
    PEA     3.W
    MOVE.L  A3,-(A7)
    PEA     -16(A5)
    JSR     SCRIPT3_JMPTBL_STRING_CopyPadNul(PC)

    CLR.B   -13(A5)
    PEA     -16(A5)
    JSR     SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVE.L  D0,D7
    ADDQ.L  #3,A3
    PEA     2.W
    MOVE.L  A3,-(A7)
    PEA     -16(A5)
    JSR     SCRIPT3_JMPTBL_STRING_CopyPadNul(PC)

    CLR.B   -14(A5)
    PEA     -16(A5)
    JSR     SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    LEA     32(A7),A7
    MOVE.L  D0,D6
    ADDQ.L  #2,A3
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D7,D0
    BNE.S   .if_ne_1374

    MOVEQ   #0,D5
    BRA.S   .skip_1376

.if_ne_1374:
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   .if_ne_1375

    MOVEQ   #1,D5
    BRA.S   .skip_1376

.if_ne_1375:
    MOVEQ   #2,D5

.skip_1376:
    MOVEQ   #2,D0
    CMP.W   D0,D5
    BEQ.S   .if_eq_1377

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _P_TYPE_PrimaryGroupListPtr,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    BSR.W   _P_TYPE_FreeEntry

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _P_TYPE_PrimaryGroupListPtr,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  A3,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,32(A7)
    BSR.W   P_TYPE_AllocateEntry

    LEA     12(A7),A7
    MOVEA.L 20(A7),A0
    MOVE.L  D0,(A0)
    MOVEQ   #1,D4

.if_eq_1377:
    MOVE.L  D4,D0
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: P_TYPE_WritePromoIdDataFile   (Serialize current lists to PROMOID.DAT)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +105: arg_2 (via 109(A5))
; CLOBBERS:
;   A0/A1/A5/A7/D0/D1/D5/D6/D7
; CALLS:
;   _PARSEINI_JMPTBL_WDISP_SPrintf, _SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer, _SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush, _SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes
; READS:
;   P_TYPE_PATH_DF0_COLON_PROMOID_DOT_DAT_Write, P_TYPE_STR_CURDAY_COLON_WriteSection, P_TYPE_FMT_PCT_03D_PCT_02D, P_TYPE_STR_NO_DATA, P_TYPE_STR_NXTDAY_COLON_WriteSection, _P_TYPE_PrimaryGroupListPtr, branch_1380, if_eq_1385, loop_137A, return_1386
; WRITES:
;   (none observed)
; DESC:
;   Opens PROMOID.DAT and writes CURDAY/NXTDAY list sections, emitting either
;   formatted list entries or "NO DATA" placeholders.
; NOTES:
;   Writes two sections by iterating list selectors 0 then 1.
;------------------------------------------------------------------------------
P_TYPE_WritePromoIdDataFile:
    LINK.W  A5,#-120
    MOVEM.L D5-D7,-(A7)
    PEA     1006.W
    PEA     P_TYPE_PATH_DF0_COLON_PROMOID_DOT_DAT_Write
    JSR     _SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BEQ.W   .return_1386

    LEA     P_TYPE_STR_CURDAY_COLON_WriteSection,A0
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
    PEA     P_TYPE_FMT_PCT_03D_PCT_02D
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
    PEA     P_TYPE_STR_NO_DATA
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
    LEA     P_TYPE_STR_NXTDAY_COLON_WriteSection,A0
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
;   _P_TYPE_FreeEntry, PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer, P_TYPE_AllocateEntry, P_TYPE_JMPTBL_STRING_FindSubstring, SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, _SCRIPT_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _Global_REF_LONG_FILE_SCRATCH, Global_STR_P_TYPE_C_6, P_TYPE_PATH_DF0_COLON_PROMOID_DOT_DAT_Load, P_TYPE_STR_CURDAY_COLON_LoadSection, P_TYPE_STR_TYPES_COLON, P_TYPE_STR_NXTDAY_COLON_LoadSection, _WDISP_CharClassTable, _Global_PTR_WORK_BUFFER, _TEXTDISP_SecondaryGroupCode, _TEXTDISP_PrimaryGroupCode, _P_TYPE_PrimaryGroupListPtr, if_eq_1394, if_eq_1398, if_eq_1399, loop_1389
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
    PEA     P_TYPE_PATH_DF0_COLON_PROMOID_DOT_DAT_Load
    JSR     PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.W   .if_eq_1399

    MOVE.L  _Global_PTR_WORK_BUFFER,-4(A5)
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D7
    CLR.L   -48(A5)
    LEA     P_TYPE_STR_CURDAY_COLON_LoadSection,A0
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
    JSR     P_TYPE_JMPTBL_STRING_FindSubstring(PC)

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
    JSR     SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

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
    JSR     SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    CLR.L   -16(A5)
    MOVE.L  D0,-52(A5)
    BLE.S   .branch_1393

    PEA     P_TYPE_STR_TYPES_COLON
    MOVE.L  -8(A5),-(A7)
    JSR     P_TYPE_JMPTBL_STRING_FindSubstring(PC)

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
    BSR.W   P_TYPE_AllocateEntry

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
    LEA     P_TYPE_STR_NXTDAY_COLON_LoadSection,A0
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
    PEA     Global_STR_P_TYPE_C_6
    JSR     _SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.if_eq_1399:
    MOVEQ   #1,D0
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: P_TYPE_JMPTBL_STRING_FindSubstring   (Routine at P_TYPE_JMPTBL_STRING_FindSubstring)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   STRING_FindSubstring
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
P_TYPE_JMPTBL_STRING_FindSubstring:
    JMP     STRING_FindSubstring

;!======

    ; Alignment
    MOVEQ   #97,D0
