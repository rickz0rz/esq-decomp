;------------------------------------------------------------------------------
; FUNC: P_TYPE_AllocateEntry   (AllocateEntryuncertain)
; ARGS:
;   stack +8: typeByte (byte)
;   stack +12: length (long)
;   stack +16: dataPtr (byte *)
; RET:
;   D0: pointer to entry struct, or 0 on failure
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   SCRIPT_JMPTBL_MEMORY_AllocateMemory, SCRIPT_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   dataPtr
; WRITES:
;   allocated entry fields
; DESC:
;   Allocates an entry structure and optionally copies data into a payload buffer.
; NOTES:
;   Payload is only allocated when the input length matches the source string length.
;------------------------------------------------------------------------------
P_TYPE_AllocateEntry:
    LINK.W  A5,#-8
    MOVEM.L D5-D7/A3,-(A7)
    MOVE.B  11(A5),D7
    MOVE.L  12(A5),D6
    MOVEA.L 16(A5),A3

    CLR.L   -4(A5)
    TST.L   D6
    BLE.W   .branch_1361

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     10.W
    PEA     47.W
    PEA     Global_STR_P_TYPE_C_1
    JSR     SCRIPT_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   .branch_1361

    MOVEA.L D0,A0
    MOVE.B  D7,(A0)
    MOVE.L  D6,2(A0)
    MOVEA.L A3,A0

.if_ne_135C:
    TST.B   (A0)+
    BNE.S   .if_ne_135C

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    CMPA.L  D6,A0
    BNE.S   .if_ne_135D

    MOVE.L  D6,D1
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D1,-(A7)
    PEA     58.W
    PEA     Global_STR_P_TYPE_C_2
    JSR     SCRIPT_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L -4(A5),A0
    MOVE.L  D0,6(A0)
    BRA.S   .skip_135E

.if_ne_135D:
    SUBA.L  A0,A0
    MOVEA.L D0,A1
    MOVE.L  A0,6(A1)

.skip_135E:
    MOVEA.L -4(A5),A0
    TST.L   6(A0)
    BEQ.S   .if_eq_1360

    MOVEQ   #0,D5

.loop_135F:
    CMP.L   D6,D5
    BGE.S   .branch_1361

    MOVEA.L -4(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D5,A0
    MOVE.B  0(A3,D5.L),D0
    MOVE.B  D0,(A0)
    ADDQ.L  #1,D5
    BRA.S   .loop_135F

.if_eq_1360:
    PEA     10.W
    MOVE.L  -4(A5),-(A7)
    PEA     77.W
    PEA     Global_STR_P_TYPE_C_3
    JSR     SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    SUBA.L  A0,A0
    MOVE.L  A0,-4(A5)

.branch_1361:
    MOVE.L  -4(A5),D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: P_TYPE_FreeEntry   (Free entry struct and optional payload buffer)
; ARGS:
;   stack +8: entryPtr (struct PTypeEntry *)
; RET:
;   D0: none
; CLOBBERS:
;   A3/A7/D0
; CALLS:
;   SCRIPT_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   Global_STR_P_TYPE_C_4, Global_STR_P_TYPE_C_5
; WRITES:
;   (none observed)
; DESC:
;   Frees payload buffer at +6 (if non-null) and then frees the 10-byte entry.
; NOTES:
;   Safe to call with null entry pointer.
;------------------------------------------------------------------------------
P_TYPE_FreeEntry:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  A3,D0
    BEQ.S   .return_1364

    TST.L   6(A3)
    BEQ.S   .if_eq_1363

    MOVE.L  2(A3),D0
    MOVE.L  D0,-(A7)
    MOVE.L  6(A3),-(A7)
    PEA     92.W
    PEA     Global_STR_P_TYPE_C_4
    JSR     SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.if_eq_1363:
    PEA     10.W
    MOVE.L  A3,-(A7)
    PEA     95.W
    PEA     Global_STR_P_TYPE_C_5
    JSR     SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.return_1364:
    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: P_TYPE_ResetListsAndLoadPromoIds   (Clear list pointers and reload PROMOID.DAT)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0
; CALLS:
;   P_TYPE_LoadPromoIdDataFile
; READS:
;   (none observed)
; WRITES:
;   P_TYPE_PrimaryGroupListPtr, P_TYPE_SecondaryGroupListPtr
; DESC:
;   Clears primary/secondary list pointers and repopulates them from disk.
; NOTES:
;   Load is best-effort; return value is ignored.
;------------------------------------------------------------------------------
P_TYPE_ResetListsAndLoadPromoIds:
    SUBA.L  A0,A0
    MOVE.L  A0,P_TYPE_SecondaryGroupListPtr
    MOVE.L  A0,P_TYPE_PrimaryGroupListPtr
    BSR.W   P_TYPE_LoadPromoIdDataFile

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: P_TYPE_CloneEntry   (Deep-copy entry and payload)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +96: arg_3 (via 100(A5))
; CLOBBERS:
;   A0/A2/A3/A7/D0/D7
; CALLS:
;   P_TYPE_FreeEntry, P_TYPE_AllocateEntry
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Frees destination entry first, then deep-copies source payload into a newly
;   allocated destination entry.
; NOTES:
;   Uses a fixed local scratch buffer for payload copy before reallocation.
;------------------------------------------------------------------------------
P_TYPE_CloneEntry:
    LINK.W  A5,#-104
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2

    MOVE.L  A3,-(A7)
    BSR.S   P_TYPE_FreeEntry

    ADDQ.W  #4,A7
    SUBA.L  A3,A3
    MOVE.L  A2,D0
    BEQ.S   .if_eq_1369

    MOVEQ   #0,D7

.loop_1367:
    CMP.L   2(A2),D7
    BGE.S   .if_ge_1368

    MOVEA.L 6(A2),A0
    ADDA.L  D7,A0
    MOVE.B  (A0),D0
    MOVE.B  D0,-100(A5,D7.L)
    ADDQ.L  #1,D7
    BRA.S   .loop_1367

.if_ge_1368:
    CLR.B   -100(A5,D7.L)
    MOVEQ   #0,D0
    MOVE.B  (A2),D0
    PEA     -100(A5)
    MOVE.L  2(A2),-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   P_TYPE_AllocateEntry

    LEA     12(A7),A7
    MOVEA.L D0,A3

.if_eq_1369:
    MOVE.L  A3,D0
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: P_TYPE_EnsureSecondaryList   (Clone primary list into secondary list if missing)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A7
; CALLS:
;   P_TYPE_CloneEntry
; READS:
;   TEXTDISP_SecondaryGroupCode, P_TYPE_PrimaryGroupListPtr, P_TYPE_SecondaryGroupListPtr
; WRITES:
;   P_TYPE_SecondaryGroupListPtr
; DESC:
;   If primary list exists and secondary list is null, clones primary into
;   secondary and updates the cloned type byte to SecondaryGroupCode.
; NOTES:
;   No-op when primary is null or secondary already exists.
;------------------------------------------------------------------------------
P_TYPE_EnsureSecondaryList:
    TST.L   P_TYPE_PrimaryGroupListPtr
    BEQ.S   .return_136B

    TST.L   P_TYPE_SecondaryGroupListPtr
    BNE.S   .return_136B

    MOVE.L  P_TYPE_PrimaryGroupListPtr,-(A7)
    MOVE.L  P_TYPE_SecondaryGroupListPtr,-(A7)
    BSR.S   P_TYPE_CloneEntry

    ADDQ.W  #8,A7
    MOVE.L  D0,P_TYPE_SecondaryGroupListPtr
    MOVEA.L D0,A0
    MOVE.B  TEXTDISP_SecondaryGroupCode,(A0)

.return_136B:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: P_TYPE_PromoteSecondaryList   (Replace primary list with secondary list)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7
; CALLS:
;   P_TYPE_FreeEntry
; READS:
;   P_TYPE_PrimaryGroupListPtr, P_TYPE_SecondaryGroupListPtr
; WRITES:
;   P_TYPE_PrimaryGroupListPtr, P_TYPE_SecondaryGroupListPtr
; DESC:
;   Frees the current primary list, then promotes secondary list into primary.
; NOTES:
;   Secondary pointer is cleared after promotion.
;------------------------------------------------------------------------------
P_TYPE_PromoteSecondaryList:
    MOVE.L  P_TYPE_PrimaryGroupListPtr,-(A7)
    BSR.W   P_TYPE_FreeEntry

    ADDQ.W  #4,A7
    MOVE.L  P_TYPE_SecondaryGroupListPtr,P_TYPE_PrimaryGroupListPtr
    CLR.L   P_TYPE_SecondaryGroupListPtr
    RTS

;!======

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
;   P_TYPE_PrimaryGroupListPtr
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
    TST.L   P_TYPE_PrimaryGroupListPtr
    BEQ.S   .branch_1372

    MOVEA.L P_TYPE_PrimaryGroupListPtr,A0
    MOVE.L  2(A0),D0
    TST.L   D0
    BLE.S   .branch_1372

    MOVEQ   #0,D6

.loop_1370:
    TST.L   D7
    BNE.S   .branch_1372

    MOVEA.L P_TYPE_PrimaryGroupListPtr,A0
    CMP.L   2(A0),D6
    BGE.S   .branch_1372

    MOVEA.L P_TYPE_PrimaryGroupListPtr,A1
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
;   P_TYPE_FreeEntry, P_TYPE_AllocateEntry, SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, SCRIPT3_JMPTBL_STRING_CopyPadNul
; READS:
;   TEXTDISP_SecondaryGroupCode, TEXTDISP_PrimaryGroupCode, P_TYPE_PrimaryGroupListPtr
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
    MOVE.B  TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D7,D0
    BNE.S   .if_ne_1374

    MOVEQ   #0,D5
    BRA.S   .skip_1376

.if_ne_1374:
    MOVE.B  TEXTDISP_SecondaryGroupCode,D0
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
    LEA     P_TYPE_PrimaryGroupListPtr,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    BSR.W   P_TYPE_FreeEntry

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     P_TYPE_PrimaryGroupListPtr,A0
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
;   PARSEINI_JMPTBL_WDISP_SPrintf, SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer, SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush, SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes
; READS:
;   DATA_P_TYPE_PATH_DF0_COLON_PROMOID_DOT_DAT_204F, DATA_P_TYPE_STR_CURDAY_COLON_2050, DATA_P_TYPE_FMT_PCT_03D_PCT_02D_2051, DATA_P_TYPE_STR_NO_DATA_2052, DATA_P_TYPE_STR_NXTDAY_COLON_2053, P_TYPE_PrimaryGroupListPtr, branch_1380, if_eq_1385, loop_137A, return_1386
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
    PEA     DATA_P_TYPE_PATH_DF0_COLON_PROMOID_DOT_DAT_204F
    JSR     SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BEQ.W   .return_1386

    LEA     DATA_P_TYPE_STR_CURDAY_COLON_2050,A0
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
    LEA     P_TYPE_PrimaryGroupListPtr,A0
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
    JSR     SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(PC)

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
    PEA     DATA_P_TYPE_FMT_PCT_03D_PCT_02D_2051
    PEA     -109(A5)
    JSR     PARSEINI_JMPTBL_WDISP_SPrintf(PC)

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
    JSR     SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(PC)

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
    JSR     SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7
    BRA.S   .skip_1381

.branch_1380:
    PEA     9.W
    PEA     DATA_P_TYPE_STR_NO_DATA_2052
    MOVE.L  D7,-(A7)
    JSR     SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(PC)

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
    LEA     DATA_P_TYPE_STR_NXTDAY_COLON_2053,A0
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
    JSR     SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush(PC)

    ADDQ.W  #4,A7

.return_1386:
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: P_TYPE_LoadPromoIdDataFile   (Parse PROMOID.DAT into primary/secondary lists)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +12: arg_2 (via 16(A5))
;   stack +35: arg_3 (via 39(A5))
;   stack +44: arg_4 (via 48(A5))
;   stack +48: arg_5 (via 52(A5))
; CLOBBERS:
;   A0/A1/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   P_TYPE_FreeEntry, PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer, P_TYPE_AllocateEntry, P_TYPE_JMPTBL_STRING_FindSubstring, SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, SCRIPT_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   Global_REF_LONG_FILE_SCRATCH, Global_STR_P_TYPE_C_6, DATA_P_TYPE_PATH_DF0_COLON_PROMOID_DOT_DAT_2054, DATA_P_TYPE_STR_CURDAY_COLON_2055, DATA_P_TYPE_STR_TYPES_COLON_2056, DATA_P_TYPE_STR_NXTDAY_COLON_2057, WDISP_CharClassTable, Global_PTR_WORK_BUFFER, TEXTDISP_SecondaryGroupCode, TEXTDISP_PrimaryGroupCode, P_TYPE_PrimaryGroupListPtr, if_eq_1394, if_eq_1398, if_eq_1399, loop_1389
; WRITES:
;   (none observed)
; DESC:
;   Loads PROMOID.DAT into a work buffer, parses CURDAY/NXTDAY sections, and
;   rebuilds list entries keyed by primary/secondary group codes.
; NOTES:
;   Existing slot entries are freed before replacement.
;------------------------------------------------------------------------------
P_TYPE_LoadPromoIdDataFile:
    LINK.W  A5,#-52
    MOVEM.L D4-D7,-(A7)
    PEA     DATA_P_TYPE_PATH_DF0_COLON_PROMOID_DOT_DAT_2054
    JSR     PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.W   .if_eq_1399

    MOVE.L  Global_PTR_WORK_BUFFER,-4(A5)
    MOVE.L  Global_REF_LONG_FILE_SCRATCH,D7
    CLR.L   -48(A5)
    LEA     DATA_P_TYPE_STR_CURDAY_COLON_2055,A0
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
    LEA     WDISP_CharClassTable,A1
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
    MOVE.B  TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D6,D0
    BNE.S   .if_ne_138D

    MOVEQ   #0,D4
    BRA.S   .skip_138F

.if_ne_138D:
    MOVE.B  TEXTDISP_SecondaryGroupCode,D0
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
    LEA     WDISP_CharClassTable,A1
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
    LEA     WDISP_CharClassTable,A1
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

    PEA     DATA_P_TYPE_STR_TYPES_COLON_2056
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
    LEA     P_TYPE_PrimaryGroupListPtr,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    BSR.W   P_TYPE_FreeEntry

    ADDQ.W  #4,A7
    MOVE.L  D4,D0
    ASL.L   #2,D0
    LEA     P_TYPE_PrimaryGroupListPtr,A0
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
    LEA     DATA_P_TYPE_STR_NXTDAY_COLON_2057,A0
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
    JSR     SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

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
