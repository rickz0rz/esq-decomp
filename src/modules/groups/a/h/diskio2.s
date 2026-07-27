    XDEF    DISKIO2_DisplayStatusLine
    XDEF    _DISKIO2_LoadCurDayDataFile
    XDEF    _DISKIO2_LoadNxtDayDataFile
    XDEF    _DISKIO2_RunDiskSyncWorkflow
    XDEF    _DISKIO2_WriteCurDayDataFile
    XDEF    DISKIO2_WriteNxtDayDataFile



;!======

;------------------------------------------------------------------------------
; FUNC: _DISKIO2_WriteCurDayDataFile   (Write disk data file and table entries and metadata.)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +13: arg_3 (via 17(A5))
;   stack +18: arg_4 (via 22(A5))
;   stack +28: arg_5 (via 32(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A7/D0/D1/D6/D7
; CALLS:
;   _DISKIO_OpenFileWithBuffer, _DISKIO_WriteBufferedBytes, _DISKIO_WriteDecimalField, _DISKIO_CloseBufferedFileAndFlush, _DISKIO2_CopyAndSanitizeSlotString
; READS:
;   _TEXTDISP_PrimaryGroupCode/2231/2247/2248, _TEXTDISP_PrimaryEntryPtrTable/2236 tables, WDISP_WeatherStatusTextPtr
; WRITES:
;   DISKIO2_OutputFileHandle, DISKIO_SaveOperationReadyFlag
; DESC:
;   Allocates a staging buffer, opens the output file, and writes header fields
;   followed by per-entry records from the in-memory tables.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISKIO2_WriteCurDayDataFile:
    LINK.W  A5,#-24
    MOVEM.L D6-D7,-(A7)
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMPI.W  #$c8,D0
    BLS.S   .writecur_guard_save_ready

    MOVEQ   #0,D0
    BRA.W   .writecur_return

.writecur_guard_save_ready:
    TST.L   DISKIO_SaveOperationReadyFlag
    BNE.S   .writecur_begin_save

    MOVEQ   #0,D0
    BRA.W   .writecur_return

.writecur_begin_save:
    CLR.L   DISKIO_SaveOperationReadyFlag
    CLR.B   -17(A5)

    ; DISKIO2.C:152 - Allocate 1000 bytes
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     1000.W
    PEA     152.W
    PEA     Global_STR_DISKIO2_C_1
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-22(A5)
    BNE.S   .writecur_open_output_file

    MOVEQ   #1,D0
    MOVE.L  D0,DISKIO_SaveOperationReadyFlag
    MOVEQ   #-1,D0
    BRA.W   .writecur_return

.writecur_open_output_file:
    PEA     MODE_NEWFILE.W
    PEA     CTASKS_PATH_CURDAY_DAT
    JSR     _DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,DISKIO2_OutputFileHandle
    TST.L   D0
    BNE.S   .writecur_write_header

    PEA     1000.W
    MOVE.L  -22(A5),-(A7)
    PEA     176.W
    PEA     Global_STR_DISKIO2_C_2
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,DISKIO_SaveOperationReadyFlag
    MOVEQ   #-1,D0
    BRA.W   .writecur_return

.writecur_write_header:
    PEA     21.W
    PEA     _ESQ_STR_B
    MOVE.L  DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    MOVE.W  _DST_PrimaryCountdown,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    PEA     7.W
    PEA     Global_STR_DREV_5_1
    MOVE.L  DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     _WDISP_WeatherStatusLabelBuffer,A0
    MOVEA.L A0,A1

    ; Compute length of header string and write it.
.writecur_scan_primary_header_text:
    TST.B   (A1)+
    BNE.S   .writecur_scan_primary_header_text

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     36(A7),A7
    TST.L   WDISP_WeatherStatusTextPtr
    BNE.S   .writecur_use_weather_status_text

    LEA     -17(A5),A0
    MOVE.L  A0,-12(A5)
    BRA.S   .writecur_scan_optional_status_text

.writecur_use_weather_status_text:
    MOVEA.L WDISP_WeatherStatusTextPtr,A0
    MOVE.L  A0,-12(A5)

    ; Compute length of optional string (WDISP_WeatherStatusTextPtr or empty) and write it.
.writecur_scan_optional_status_text:
    TST.B   (A0)+
    BNE.S   .writecur_scan_optional_status_text

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    MOVE.L  D0,(A7)
    MOVE.L  DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.L  D0,(A7)
    MOVE.L  DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_PrimaryGroupRecordChecksum,D0
    MOVE.L  D0,(A7)
    MOVE.L  DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupRecordLength,D0
    MOVE.L  D0,(A7)
    MOVE.L  DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    LEA     28(A7),A7
    MOVEQ   #0,D7

    ; For each entry, write the per-record header and fields.
.writecur_entry_loop:
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.W   D0,D7
    BGE.W   .writecur_finalize_and_free

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    PEA     48.W
    MOVE.L  -4(A5),-(A7)
    MOVE.L  DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    MOVEA.L -8(A5),A0

.writecur_scan_title_length:
    TST.B   (A0)+
    BNE.S   .writecur_scan_title_length

    SUBQ.L  #1,A0
    SUBA.L  -8(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D6

    ; Iterate item slots within the entry.
.writecur_slot_loop:
    MOVEQ   #49,D0
    CMP.W   D0,D6
    BGE.W   .writecur_emit_slot_sentinel

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    TST.L   56(A0,D0.L)
    BEQ.W   .writecur_next_slot

    MOVEA.L -4(A5),A1
    ADDA.W  #$1c,A1
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     GROUP_AH_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   .writecur_next_slot

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.B  7(A0,D6.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D6,D1
    ADDI.W  #$fc,D1
    MOVE.B  0(A0,D1.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D6,D1
    ADDI.W  #$12d,D1
    MOVE.B  0(A0,D1.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D6,D1
    ADDI.W  #$15e,D1
    MOVE.B  0(A0,D1.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    LEA     24(A7),A7
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    MOVEQ   #100,D1
    CMP.W   D1,D0
    BLS.S   .writecur_use_existing_slot_ptr

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  -22(A5),-(A7)
    BSR.W   _DISKIO2_CopyAndSanitizeSlotString

    LEA     16(A7),A7
    MOVE.L  D0,-12(A5)
    BRA.S   .writecur_emit_slot_text

.writecur_use_existing_slot_ptr:
    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    MOVEA.L 56(A0,D0.L),A0
    MOVE.L  A0,-12(A5)

.writecur_emit_slot_text:
    MOVEA.L -12(A5),A0

    ; Emit variable-length string for this slot.
.writecur_scan_slot_text_length:
    TST.B   (A0)+
    BNE.S   .writecur_scan_slot_text_length

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.writecur_next_slot:
    ADDQ.W  #1,D6
    BRA.W   .writecur_slot_loop

.writecur_emit_slot_sentinel:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    ADDQ.W  #8,A7
    ADDQ.W  #1,D7
    BRA.W   .writecur_entry_loop

.writecur_finalize_and_free:
    MOVE.L  DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_CloseBufferedFileAndFlush(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,DISKIO_SaveOperationReadyFlag
    PEA     1000.W
    MOVE.L  -22(A5),-(A7)
    PEA     275.W
    PEA     Global_STR_DISKIO2_C_3
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #0,D0

.writecur_return:
    MOVEM.L -32(A5),D6-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO2_DisplayStatusLine   (Display status line at fixed position.)
; ARGS:
;   stack +4: A3 = message string
; RET:
;   D0: none
; CLOBBERS:
;   A1/A3/A6/A7/D0
; CALLS:
;   _DISPLIB_DisplayTextAtPosition
; READS:
;   _Global_REF_RASTPORT_1
; WRITES:
;   (none observed)
; DESC:
;   Clears a fixed area 38 characters wide, and renders the supplied text at (40,120).
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISKIO2_DisplayStatusLine:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    PEA     Global_STR_38_SPACES
    PEA     120.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  A3,(A7)
    PEA     120.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     28(A7),A7
    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _DISKIO2_RunDiskSyncWorkflow   (Disk I/O initialization sequence with optional UI.)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +96: arg_2 (via 100(A5))
;   stack +100: arg_3 (via 104(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0/D7
; CALLS:
;   GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh, DISKIO2_DisplayStatusLine, DISKIO2_FlushDataFilesIfNeeded, ED1_JMPTBL_LADFUNC_SaveTextAdsToFile, DISKIO_SaveConfigToFileHandle, GROUP_AH_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile, _DISKIO2_WriteQTableIniFile,
;   GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry, DATETIME_SavePairToFile, GROUP_AH_JMPTBL_P_TYPE_WritePromoIdDataFile, GROUP_AH_JMPTBL_GCOMMAND_LoadCommandFile, _GCOMMAND_LoadMplexFile,
;   _GCOMMAND_LoadPPVTemplate
; READS:
;   DISKIO2_STR_SAVING_PROGRAMMING_DATA_DOT..DISKIO2_STR_SAVING_DATA_VIEW_CONFIG text tables
; WRITES:
;   (none observed)
; DESC:
;   Runs a staged initialization sequence, optionally printing status strings.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISKIO2_RunDiskSyncWorkflow:
    LINK.W  A5,#-100
    MOVE.L  D7,-(A7)
    MOVE.L  8(A5),D7

    PEA     1.W
    PEA     256.W
    JSR     GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)

    ADDQ.W  #8,A7
    LEA     DISKIO2_STR_SAVING_PROGRAMMING_DATA_DOT,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

    ; Copy status string into stack buffer and optionally display it.
.loc_0485:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_0485
    TST.L   D7
    BEQ.S   .loc_0486

    PEA     -100(A5)
    BSR.W   DISKIO2_DisplayStatusLine

    ADDQ.W  #4,A7

.loc_0486:
    BSR.W   DISKIO2_FlushDataFilesIfNeeded

    LEA     DISKIO2_STR_SAVING_TEXT_ADS_DOT,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

.loc_0487:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_0487
    TST.L   D7
    BEQ.S   .loc_0488

    PEA     -100(A5)
    BSR.W   DISKIO2_DisplayStatusLine

    ADDQ.W  #4,A7

.loc_0488:
    JSR     ED1_JMPTBL_LADFUNC_SaveTextAdsToFile(PC)

    LEA     DISKIO2_STR_SAVING_CONFIGURATION_FILE_DOT,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

.loc_0489:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_0489
    TST.L   D7
    BEQ.S   .loc_048A

    PEA     -100(A5)
    BSR.W   DISKIO2_DisplayStatusLine

    ADDQ.W  #4,A7

.loc_048A:
    JSR     DISKIO_SaveConfigToFileHandle(PC)

    LEA     DISKIO2_STR_SAVING_LOCAL_AVAIL_CFG_DOT,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

.loc_048B:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_048B
    TST.L   D7
    BEQ.S   .loc_048C

    PEA     -100(A5)
    BSR.W   DISKIO2_DisplayStatusLine

    ADDQ.W  #4,A7

.loc_048C:
    PEA     _LOCAVAIL_SecondaryFilterState
    PEA     _LOCAVAIL_PrimaryFilterState
    JSR     GROUP_AH_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile(PC)

    ADDQ.W  #8,A7
    LEA     DISKIO2_STR_SAVING_QTABLE_DOT,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

.loc_048D:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_048D
    TST.L   D7
    BEQ.S   .loc_048E

    PEA     -100(A5)
    BSR.W   DISKIO2_DisplayStatusLine

    ADDQ.W  #4,A7

.loc_048E:
    BSR.W   _DISKIO2_WriteQTableIniFile

    LEA     DISKIO2_STR_SAVING_ERROR_LOG_DOT,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

.loc_048F:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_048F
    TST.L   D7
    BEQ.S   .loc_0490

    PEA     -100(A5)
    BSR.W   DISKIO2_DisplayStatusLine

    ADDQ.W  #4,A7

.loc_0490:
    JSR     GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry(PC)

    LEA     DISKIO2_STR_SAVING_DST_DATA_DOT,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

.loc_0491:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_0491
    TST.L   D7
    BEQ.S   .loc_0492

    PEA     -100(A5)
    BSR.W   DISKIO2_DisplayStatusLine

    ADDQ.W  #4,A7

.loc_0492:
    PEA     _DST_BannerWindowPrimary
    JSR     DATETIME_SavePairToFile(PC)

    ADDQ.W  #4,A7
    LEA     DISKIO2_STR_SAVING_PROMO_TYPES,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

.loc_0493:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_0493
    TST.L   D7
    BEQ.S   .loc_0494

    PEA     -100(A5)
    BSR.W   DISKIO2_DisplayStatusLine

    ADDQ.W  #4,A7

.loc_0494:
    JSR     GROUP_AH_JMPTBL_P_TYPE_WritePromoIdDataFile(PC)

    LEA     DISKIO2_STR_SAVING_DATA_VIEW_CONFIG,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

.loc_0495:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_0495
    TST.L   D7
    BEQ.S   .loc_0496

    PEA     -100(A5)
    BSR.W   DISKIO2_DisplayStatusLine

    ADDQ.W  #4,A7

.loc_0496:
    JSR     GROUP_AH_JMPTBL_GCOMMAND_LoadCommandFile(PC)

    JSR     GROUP_AH_JMPTBL_GCOMMAND_LoadMplexFile(PC)

    JSR     GROUP_AH_JMPTBL_GCOMMAND_LoadPPVTemplate(PC)

    CLR.L   -(A7)
    PEA     256.W
    JSR     GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)

    MOVE.L  -104(A5),D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _DISKIO2_LoadCurDayDataFile   (Load disk data file and populate entry tables.)
; ARGS:
;   stack +8: arg_1 (via 12(A5))
;   stack +12: arg_2 (via 16(A5))
;   stack +16: arg_3 (via 20(A5))
;   stack +24: arg_4 (via 28(A5))
;   stack +28: arg_5 (via 32(A5))
;   stack +32: arg_6 (via 36(A5))
;   stack +36: arg_7 (via 40(A5))
;   stack +37: arg_8 (via 41(A5))
;   stack +40: arg_9 (via 44(A5))
;   stack +61: arg_10 (via 65(A5))
;   stack +92: arg_11 (via 96(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D5/D6/D7
; CALLS:
;   _DISKIO_LoadFileToWorkBuffer/03B2/03B6, GROUP_AH_JMPTBL_ESQ_WildcardMatch,
;   _GROUP_AG_JMPTBL_MEMORY_AllocateMemory/DeallocateMemory, GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults,
;   _COI_EnsureAnimObjectAllocated, PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString, GROUP_AH_JMPTBL_ESQIFF2_ApplyIncomingStatusPacket, GROUP_AH_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters, _ESQPARS_ReplaceOwnedString
; READS:
;   CTASKS_PATH_CURDAY_DAT, _Global_PTR_WORK_BUFFER, DISKIO_CurrentDriveRevisionIndex, WDISP_WeatherStatusTextPtr, _TEXTDISP_PrimaryGroupCode, _TEXTDISP_PrimaryEntryPtrTable/2236
; WRITES:
;   _TEXTDISP_PrimaryGroupCode/2231/2238, _TEXTDISP_PrimaryGroupRecordChecksum/2248/224A-224C, _TEXTDISP_AliasPtrTable tables, WDISP_WeatherStatusTextPtr
; DESC:
;   Parses the on-disk data file, allocates per-entry structures, and fills
;   the in-memory tables with parsed records.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISKIO2_LoadCurDayDataFile:
    LINK.W  A5,#-76
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVE.W  #(-1),-28(A5)
    MOVEQ   #0,D7

.loc_0498:
    MOVEQ   #21,D0
    CMP.W   D0,D7
    BGE.S   .loc_0499

    LEA     _ESQ_STR_B,A0
    ADDA.W  D7,A0
    MOVE.B  (A0),-65(A5,D7.W)
    ADDQ.W  #1,D7
    BRA.S   .loc_0498

.loc_0499:
    PEA     CTASKS_PATH_CURDAY_DAT
    JSR     _DISKIO_LoadFileToWorkBuffer(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BNE.S   .loc_049A

    CLR.W   _DST_PrimaryCountdown
    PEA     -65(A5)
    JSR     GROUP_AH_JMPTBL_ESQIFF2_ApplyIncomingStatusPacket(PC)

    MOVEQ   #-1,D0
    BRA.W   .loc_04C0

.loc_049A:
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,-40(A5)
    MOVE.L  _Global_PTR_WORK_BUFFER,-16(A5)
    MOVEQ   #0,D7

    ; Consume header bytes into a local buffer.
.loc_049B:
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D0
    TST.L   D0
    BLE.S   .loc_049C

    MOVEQ   #21,D1
    CMP.W   D1,D7
    BGE.S   .loc_049C

    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    MOVE.B  (A0)+,-65(A5,D7.W)
    MOVE.L  A0,_Global_PTR_WORK_BUFFER
    SUBQ.L  #1,_Global_REF_LONG_FILE_SCRATCH
    ADDQ.W  #1,D7
    BRA.S   .loc_049B

.loc_049C:
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.W  D0,_DST_PrimaryCountdown
    PEA     -65(A5)
    JSR     GROUP_AH_JMPTBL_ESQIFF2_ApplyIncomingStatusPacket(PC)

    JSR     _DISKIO_ConsumeCStringFromWorkBuffer(PC)

    ADDQ.W  #4,A7
    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   .loc_049D

    MOVE.L  -40(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     520.W
    PEA     Global_STR_DISKIO2_C_4
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #-1,D0
    BRA.W   .loc_04C0

.loc_049D:
    MOVEA.L D0,A0
    LEA     _DISKIO_ErrorMessageScratch,A1

    ; Copy NUL-terminated identifier string.
.loc_049E:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .loc_049E

    PEA     DISKIO2_STR_DREV_1
    PEA     _DISKIO_ErrorMessageScratch
    JSR     GROUP_AH_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .loc_049F

    MOVE.W  #1,DISKIO_CurrentDriveRevisionIndex
    MOVEQ   #40,D0
    MOVE.L  D0,-32(A5)
    BRA.W   .loc_04A4

.loc_049F:
    PEA     DISKIO2_STR_DREV_2
    PEA     _DISKIO_ErrorMessageScratch
    JSR     GROUP_AH_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .loc_04A0

    MOVE.W  #2,DISKIO_CurrentDriveRevisionIndex
    MOVEQ   #41,D0
    MOVE.L  D0,-32(A5)
    BRA.W   .loc_04A4

.loc_04A0:
    PEA     DISKIO2_STR_DREV_3
    PEA     _DISKIO_ErrorMessageScratch
    JSR     GROUP_AH_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .loc_04A1

    MOVE.W  #3,DISKIO_CurrentDriveRevisionIndex
    MOVEQ   #46,D0
    MOVE.L  D0,-32(A5)
    BRA.S   .loc_04A4

.loc_04A1:
    PEA     DISKIO2_STR_DREV_4
    PEA     _DISKIO_ErrorMessageScratch
    JSR     GROUP_AH_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .loc_04A2

    MOVE.W  #4,DISKIO_CurrentDriveRevisionIndex
    MOVEQ   #48,D0
    MOVE.L  D0,-32(A5)
    BRA.S   .loc_04A4

.loc_04A2:
    PEA     DISKIO2_STR_DREV_5
    PEA     _DISKIO_ErrorMessageScratch
    JSR     GROUP_AH_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .loc_04A3

    MOVE.W  #5,DISKIO_CurrentDriveRevisionIndex
    MOVEQ   #48,D0
    MOVE.L  D0,-32(A5)
    BRA.S   .loc_04A4

.loc_04A3:
    MOVE.L  -40(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     561.W
    PEA     Global_STR_DISKIO2_C_5
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #-1,D0
    BRA.W   .loc_04C0

.loc_04A4:
    JSR     _DISKIO_ConsumeCStringFromWorkBuffer(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   .loc_04A5

    MOVE.L  -40(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     570.W
    PEA     Global_STR_DISKIO2_C_6
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #-1,D0
    BRA.W   .loc_04C0

.loc_04A5:
    MOVEA.L D0,A0
    LEA     _WDISP_WeatherStatusLabelBuffer,A1

.loc_04A6:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .loc_04A6

    MOVE.W  DISKIO_CurrentDriveRevisionIndex,D0
    TST.W   D0
    BLE.S   .loc_04A8

    JSR     _DISKIO_ConsumeCStringFromWorkBuffer(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   .loc_04A7

    MOVE.L  -40(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     588.W
    PEA     Global_STR_DISKIO2_C_7
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #-1,D0
    BRA.W   .loc_04C0

.loc_04A7:
    MOVE.L  WDISP_WeatherStatusTextPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,WDISP_WeatherStatusTextPtr

.loc_04A8:
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #0,D0
    NOT.B   D0
    AND.L   D0,D1
    MOVEQ   #0,D7
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    MOVE.B  D1,-41(A5)
    CMP.B   D0,D1
    BNE.W   .loc_04BC

    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.W  D0,-44(A5)
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.B  D0,_TEXTDISP_PrimaryGroupRecordChecksum
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.W  D0,_TEXTDISP_PrimaryGroupRecordLength
    MOVE.B  #$1,_TEXTDISP_PrimaryGroupPresentFlag
    MOVE.W  #1,_TEXTDISP_GroupMutationState
    MOVEQ   #0,D0
    MOVE.W  D0,_TEXTDISP_MaxEntryTitleLength
    CLR.L   -36(A5)
    MOVE.L  D0,D7

.loc_04A9:
    ; Allocate and populate each entry record.
    CMP.W   -44(A5),D7
    BGE.W   .loc_04BD

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     52.W
    PEA     634.W
    PEA     Global_STR_DISKIO2_C_8
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BNE.S   .loc_04AA

    MOVEQ   #-1,D0
    MOVE.L  D0,-36(A5)
    BRA.W   .loc_04BD

.loc_04AA:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     500.W
    PEA     640.W
    PEA     Global_STR_DISKIO2_C_9
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A2
    MOVE.L  A2,D0
    BNE.S   .loc_04AB

    MOVEQ   #-1,D0
    MOVE.L  D0,-36(A5)
    PEA     52.W
    MOVE.L  A3,-(A7)
    PEA     644.W
    PEA     Global_STR_DISKIO2_C_10
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    BRA.W   .loc_04BD

.loc_04AB:
    MOVE.L  A3,-(A7)
    JSR     GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults(PC)

    MOVE.L  A3,(A7)
    JSR     _COI_EnsureAnimObjectAllocated(PC)

    ADDQ.W  #4,A7
    MOVE.L  A3,-20(A5)
    MOVEQ   #0,D6

.loc_04AC:
    ; Copy fixed-length name field from file buffer.
    MOVE.L  D6,D0
    EXT.L   D0
    CMP.L   -32(A5),D0
    BGE.S   .loc_04AD

    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    MOVEA.L -20(A5),A1
    MOVE.B  (A0)+,(A1)+
    MOVE.L  A0,_Global_PTR_WORK_BUFFER
    SUBQ.L  #1,_Global_REF_LONG_FILE_SCRATCH
    MOVE.L  A1,-20(A5)
    ADDQ.W  #1,D6
    BRA.S   .loc_04AC

.loc_04AD:
    MOVEQ   #0,D0
    MOVE.B  40(A3),D0
    ANDI.W  #$ff7f,D0
    MOVE.B  D0,40(A3)
    LEA     1(A3),A0
    MOVEA.L A0,A1

.loc_04AE:
    TST.B   (A1)+
    BNE.S   .loc_04AE

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D5
    MOVE.W  _TEXTDISP_MaxEntryTitleLength,D0
    CMP.W   D0,D5
    BLE.S   .loc_04AF

    MOVE.W  D5,_TEXTDISP_MaxEntryTitleLength

.loc_04AF:
    JSR     _DISKIO_ConsumeCStringFromWorkBuffer(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   .loc_04B0

    MOVE.L  A0,-36(A5)
    BRA.W   .loc_04BD

.loc_04B0:
    MOVEA.L D0,A0
    MOVEA.L A2,A1

.loc_04B1:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .loc_04B1

    MOVE.W  #(-1),-28(A5)
    MOVEQ   #0,D5

.loc_04B2:
    MOVEQ   #49,D0
    CMP.W   D0,D5
    BGE.W   .loc_04B9

    MOVE.B  #$1,7(A2,D5.W)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    CLR.L   56(A2,D0.L)
    CMPI.W  #4,DISKIO_CurrentDriveRevisionIndex
    BLE.S   .loc_04B5

    MOVE.W  -28(A5),D0
    TST.W   D0
    BPL.S   .loc_04B3

    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.W  D0,-28(A5)

.loc_04B3:
    CMP.W   D0,D5
    BGE.S   .loc_04B4

    BRA.W   .loc_04B8

.loc_04B4:
    MOVE.W  #(-1),-28(A5)

.loc_04B5:
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.B  D0,7(A2,D5.W)
    CMPI.W  #1,DISKIO_CurrentDriveRevisionIndex
    BLE.S   .loc_04B6

    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.L  D5,D1
    ADDI.W  #$fc,D1
    MOVE.B  D0,0(A2,D1.W)
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.L  D5,D1
    ADDI.W  #$12d,D1
    MOVE.B  D0,0(A2,D1.W)
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.L  D5,D1
    ADDI.W  #$15e,D1
    MOVE.B  D0,0(A2,D1.W)

.loc_04B6:
    JSR     _DISKIO_ConsumeCStringFromWorkBuffer(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   .loc_04B7

    MOVE.L  A0,-36(A5)
    BRA.S   .loc_04B9

.loc_04B7:
    MOVEQ   #0,D1
    MOVE.B  27(A3),D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUP_AH_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(PC)

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVE.L  56(A2,D0.L),(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  D0,36(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     12(A7),A7
    MOVE.L  24(A7),D1
    MOVE.L  D0,56(A2,D1.L)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    TST.L   56(A2,D0.L)
    BEQ.S   .loc_04B8

    MOVEQ   #0,D0
    MOVE.B  40(A3),D0
    ORI.W   #$80,D0
    MOVE.B  D0,40(A3)

.loc_04B8:
    ADDQ.W  #1,D5
    BRA.W   .loc_04B2

.loc_04B9:
    CMPI.W  #4,DISKIO_CurrentDriveRevisionIndex
    BLE.S   .loc_04BA

    MOVEQ   #-1,D0
    CMP.W   -28(A5),D0
    BNE.S   .loc_04BA

    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.W  D0,-28(A5)

.loc_04BA:
    MOVEQ   #-1,D0
    CMP.L   -36(A5),D0
    BNE.S   .loc_04BB

    PEA     52.W
    MOVE.L  A3,-(A7)
    PEA     736.W
    PEA     Global_STR_DISKIO2_C_11
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    PEA     500.W
    MOVE.L  A2,-(A7)
    PEA     737.W
    PEA     Global_STR_DISKIO2_C_12
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     32(A7),A7
    BRA.S   .loc_04BD

.loc_04BB:
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  A3,(A0)
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  A2,(A0)
    ADDQ.W  #1,D7
    BRA.W   .loc_04A9

.loc_04BC:
    MOVEQ   #-1,D0
    MOVE.L  D0,-36(A5)

.loc_04BD:
    MOVE.B  -41(A5),_TEXTDISP_PrimaryGroupHeaderCode
    MOVE.L  D7,D0
    MOVE.W  D0,_TEXTDISP_PrimaryGroupEntryCount
    MOVE.L  -40(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     764.W
    PEA     Global_STR_DISKIO2_C_13
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #0,D0
    MOVE.B  -41(A5),D0
    MOVE.L  D0,(A7)
    JSR     COI_LoadOiDataFile(PC)

    LEA     16(A7),A7
    ADDQ.L  #1,D0
    BEQ.S   .loc_04BE

    MOVE.B  #$1,_CTASKS_PrimaryOiWritePendingFlag
    MOVE.B  -41(A5),_CTASKS_PendingPrimaryOiDiskId
    BRA.S   .loc_04BF

.loc_04BE:
    MOVEQ   #0,D0
    MOVE.B  D0,_CTASKS_PrimaryOiWritePendingFlag
    MOVE.B  D0,_CTASKS_PendingPrimaryOiDiskId

.loc_04BF:
    MOVE.L  -36(A5),D0

.loc_04C0:
    MOVEM.L -96(A5),D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO2_WriteNxtDayDataFile   (Write NXTDAY.DAT data file.)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +13: arg_3 (via 17(A5))
;   stack +18: arg_4 (via 22(A5))
;   stack +28: arg_5 (via 32(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A7/D0/D1/D6/D7
; CALLS:
;   _DISKIO_OpenFileWithBuffer, _DISKIO_WriteBufferedBytes, _DISKIO_WriteDecimalField, _DISKIO_CloseBufferedFileAndFlush, _DISKIO2_CopyAndSanitizeSlotString
; READS:
;   _TEXTDISP_SecondaryGroupCode/222F/224D/224E, _TEXTDISP_SecondaryEntryPtrTable/2237 tables
; WRITES:
;   DISKIO2_NxtDayFileHandle, DISKIO_SaveOperationReadyFlag
; DESC:
;   Opens NXTDAY.DAT and writes header fields plus per-entry records.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISKIO2_WriteNxtDayDataFile:
    LINK.W  A5,#-24
    MOVEM.L D6-D7,-(A7)

.offsetAllocatedMemory  = -22
.desiredMemory          = 1000

    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    CMPI.W  #200,D0
    BLS.S   .writenxt_guard_save_ready

    MOVEQ   #0,D0
    BRA.W   .writenxt_return

.writenxt_guard_save_ready:
    TST.L   DISKIO_SaveOperationReadyFlag
    BNE.S   .writenxt_begin_save

    MOVEQ   #0,D0
    BRA.W   .writenxt_return

.writenxt_begin_save:
    CLR.L   DISKIO_SaveOperationReadyFlag
    CLR.B   -17(A5)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     (.desiredMemory).W
    PEA     817.W
    PEA     Global_STR_DISKIO2_C_14
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,.offsetAllocatedMemory(A5)
    BNE.S   .writenxt_open_output_file

    MOVEQ   #1,D0
    MOVE.L  D0,DISKIO_SaveOperationReadyFlag
    MOVEQ   #-1,D0
    BRA.W   .writenxt_return

.writenxt_open_output_file:
    PEA     (MODE_NEWFILE).W
    PEA     Global_STR_DF0_NXTDAY_DAT
    JSR     _DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,DISKIO2_NxtDayFileHandle
    TST.L   D0
    BNE.S   .writenxt_write_header

    MOVEQ   #1,D0
    MOVE.L  D0,DISKIO_SaveOperationReadyFlag
    PEA     (.desiredMemory).W
    MOVE.L  .offsetAllocatedMemory(A5),-(A7)
    PEA     839.W
    PEA     Global_STR_DISKIO2_C_15
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #-1,D0
    BRA.W   .writenxt_return

.writenxt_write_header:
    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    MOVE.L  D0,-(A7)
    MOVE.L  DISKIO2_NxtDayFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    MOVE.L  D0,(A7)
    MOVE.L  DISKIO2_NxtDayFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_SecondaryGroupRecordChecksum,D0
    MOVE.L  D0,(A7)
    MOVE.L  DISKIO2_NxtDayFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_SecondaryGroupRecordLength,D0
    MOVE.L  D0,(A7)
    MOVE.L  DISKIO2_NxtDayFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D7

    ; For each entry, write the per-record header and fields.
.writenxt_entry_loop:
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.W   D0,D7
    BGE.W   .writenxt_finalize_and_free

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    PEA     48.W
    MOVE.L  -4(A5),-(A7)
    MOVE.L  DISKIO2_NxtDayFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    MOVEA.L -8(A5),A0

.writenxt_scan_title_length:
    TST.B   (A0)+
    BNE.S   .writenxt_scan_title_length

    SUBQ.L  #1,A0
    SUBA.L  -8(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  DISKIO2_NxtDayFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D6

    ; Iterate item slots within the entry.
.writenxt_slot_loop:
    MOVEQ   #49,D0
    CMP.W   D0,D6
    BGE.W   .writenxt_emit_slot_sentinel

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    TST.L   56(A0,D0.L)
    BEQ.W   .writenxt_next_slot

    MOVEA.L -4(A5),A1
    ADDA.W  #28,A1
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     GROUP_AH_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   .writenxt_next_slot

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  DISKIO2_NxtDayFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.B  7(A0,D6.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  DISKIO2_NxtDayFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D6,D1
    ADDI.W  #252,D1
    MOVE.B  0(A0,D1.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  DISKIO2_NxtDayFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D6,D1
    ADDI.W  #301,D1
    MOVE.B  0(A0,D1.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  DISKIO2_NxtDayFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D6,D1
    ADDI.W  #350,D1
    MOVE.B  0(A0,D1.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  DISKIO2_NxtDayFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    LEA     24(A7),A7
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    MOVEQ   #100,D1
    CMP.W   D1,D0
    BLS.S   .writenxt_use_existing_slot_ptr

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  -22(A5),-(A7)
    BSR.W   _DISKIO2_CopyAndSanitizeSlotString

    LEA     16(A7),A7
    MOVE.L  D0,-12(A5)
    BRA.S   .writenxt_emit_slot_text

.writenxt_use_existing_slot_ptr:
    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    MOVEA.L 56(A0,D0.L),A0
    MOVE.L  A0,-12(A5)

.writenxt_emit_slot_text:
    MOVEA.L -12(A5),A0

    ; Emit variable-length string for this slot.
.writenxt_scan_slot_text_length:
    TST.B   (A0)+
    BNE.S   .writenxt_scan_slot_text_length

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  DISKIO2_NxtDayFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.writenxt_next_slot:
    ADDQ.W  #1,D6
    BRA.W   .writenxt_slot_loop

.writenxt_emit_slot_sentinel:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  DISKIO2_NxtDayFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    ADDQ.W  #8,A7
    ADDQ.W  #1,D7
    BRA.W   .writenxt_entry_loop

.writenxt_finalize_and_free:
    MOVE.L  DISKIO2_NxtDayFileHandle,-(A7)
    JSR     _DISKIO_CloseBufferedFileAndFlush(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,DISKIO_SaveOperationReadyFlag
    PEA     (.desiredMemory).W
    MOVE.L  -22(A5),-(A7)
    PEA     901.W
    PEA     Global_STR_DISKIO2_C_16
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #0,D0

.writenxt_return:
    MOVEM.L -32(A5),D6-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _DISKIO2_LoadNxtDayDataFile   (Load NXTDAY.DAT and populate entry tables.)
; ARGS:
;   stack +8: arg_1 (via 12(A5))
;   stack +12: arg_2 (via 16(A5))
;   stack +16: arg_3 (via 20(A5))
;   stack +24: arg_4 (via 28(A5))
;   stack +28: arg_5 (via 32(A5))
;   stack +32: arg_6 (via 36(A5))
;   stack +33: arg_7 (via 37(A5))
;   stack +36: arg_8 (via 40(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D5/D6/D7
; CALLS:
;   _DISKIO_LoadFileToWorkBuffer/03B2/03B6, _GROUP_AG_JMPTBL_MEMORY_AllocateMemory/DeallocateMemory,
;   GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults, _COI_EnsureAnimObjectAllocated, GROUP_AH_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters, _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString, COI_LoadOiDataFile
; READS:
;   Global_STR_DF0_NXTDAY_DAT, _Global_PTR_WORK_BUFFER, DISKIO_CurrentDriveRevisionIndex, _TEXTDISP_SecondaryGroupCode
; WRITES:
;   _TEXTDISP_SecondaryGroupCode/222F/222E, _TEXTDISP_SecondaryGroupRecordChecksum/224E, _TEXTDISP_SecondaryEntryPtrTable/2237, _TEXTDISP_SecondaryGroupHeaderCode, _CTASKS_SecondaryOiWritePendingFlag/1B92
; DESC:
;   Parses NXTDAY.DAT, allocates per-entry records, and fills in-memory tables.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISKIO2_LoadNxtDayDataFile:
    LINK.W  A5,#-48
    MOVEM.L D5-D7/A2-A3,-(A7)

    PEA     Global_STR_DF0_NXTDAY_DAT
    JSR     _DISKIO_LoadFileToWorkBuffer(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BNE.S   .loc_04D1

    MOVEQ   #-1,D0
    BRA.W   .loc_04E5

.loc_04D1:
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,-36(A5)
    MOVE.L  _Global_PTR_WORK_BUFFER,-16(A5)
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #0,D0
    NOT.B   D0
    AND.L   D0,D1
    MOVEQ   #0,D7
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    MOVE.B  D1,-37(A5)
    CMP.B   D0,D1
    BNE.W   .loc_04E2

    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.W  D0,-40(A5)
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.B  D0,_TEXTDISP_SecondaryGroupRecordChecksum
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.W  D0,_TEXTDISP_SecondaryGroupRecordLength
    MOVE.B  #$1,_TEXTDISP_SecondaryGroupPresentFlag
    CLR.L   -32(A5)
    MOVEQ   #0,D7

    ; Allocate and populate each entry record.
.loc_04D2:
    CMP.W   -40(A5),D7
    BGE.W   .loc_04E2

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     52.W
    PEA     948.W
    PEA     Global_STR_DISKIO2_C_17
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BNE.S   .loc_04D3

    MOVEQ   #-1,D0
    MOVE.L  D0,-32(A5)
    BRA.W   .loc_04E2

.loc_04D3:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     500.W
    PEA     954.W
    PEA     Global_STR_DISKIO2_C_18
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A2
    MOVE.L  A2,D0
    BNE.S   .loc_04D4

    MOVEQ   #-1,D0
    MOVE.L  D0,-32(A5)
    PEA     52.W
    MOVE.L  A3,-(A7)
    PEA     958.W
    PEA     Global_STR_DISKIO2_C_19
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    BRA.W   .loc_04E2

.loc_04D4:
    MOVE.L  A3,-(A7)
    JSR     GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults(PC)

    MOVE.L  A3,(A7)
    JSR     _COI_EnsureAnimObjectAllocated(PC)

    ADDQ.W  #4,A7
    MOVE.L  A3,-20(A5)
    MOVEQ   #0,D6

.loc_04D5:
    ; Copy fixed-length name field from file buffer.
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEQ   #48,D1
    CMP.L   D1,D0
    BCC.S   .loc_04D6

    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    MOVEA.L -20(A5),A1
    MOVE.B  (A0)+,(A1)+
    MOVE.L  A0,_Global_PTR_WORK_BUFFER
    SUBQ.L  #1,_Global_REF_LONG_FILE_SCRATCH
    MOVE.L  A1,-20(A5)
    ADDQ.W  #1,D6
    BRA.S   .loc_04D5

.loc_04D6:
    MOVEQ   #0,D0
    MOVE.B  40(A3),D0
    ANDI.W  #$ff7f,D0
    MOVE.B  D0,40(A3)
    JSR     _DISKIO_ConsumeCStringFromWorkBuffer(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   .loc_04D7

    MOVE.L  A0,-32(A5)
    BRA.W   .loc_04E2

.loc_04D7:
    MOVEA.L D0,A0
    MOVEA.L A2,A1

.loc_04D8:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .loc_04D8

    MOVE.W  #(-1),-28(A5)
    MOVEQ   #0,D5

.loc_04D9:
    ; Per-slot parsing loop (flags + optional strings).
    MOVEQ   #49,D0
    CMP.W   D0,D5
    BGE.W   .loc_04DF

    MOVE.B  #$1,7(A2,D5.W)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    CLR.L   56(A2,D0.L)
    CMPI.W  #4,DISKIO_CurrentDriveRevisionIndex
    BLE.S   .loc_04DC

    MOVE.W  -28(A5),D0
    TST.W   D0
    BPL.S   .loc_04DA

    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.W  D0,-28(A5)

.loc_04DA:
    CMP.W   D0,D5
    BGE.S   .loc_04DB

    BRA.W   .loc_04DE

.loc_04DB:
    MOVE.W  #(-1),-28(A5)

.loc_04DC:
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.B  D0,7(A2,D5.W)
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.L  D5,D1
    ADDI.W  #$fc,D1
    MOVE.B  D0,0(A2,D1.W)
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.L  D5,D1
    ADDI.W  #$12d,D1
    MOVE.B  D0,0(A2,D1.W)
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.L  D5,D1
    ADDI.W  #$15e,D1
    MOVE.B  D0,0(A2,D1.W)
    JSR     _DISKIO_ConsumeCStringFromWorkBuffer(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   .loc_04DD

    MOVE.L  A0,-32(A5)
    BRA.S   .loc_04DF

.loc_04DD:
    MOVEQ   #0,D1
    MOVE.B  27(A3),D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUP_AH_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(PC)

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVE.L  56(A2,D0.L),(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  D0,36(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     12(A7),A7
    MOVE.L  24(A7),D1
    MOVE.L  D0,56(A2,D1.L)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    TST.L   56(A2,D0.L)
    BEQ.S   .loc_04DE

    MOVEQ   #0,D0
    MOVE.B  40(A3),D0
    ORI.W   #$80,D0
    MOVE.B  D0,40(A3)

.loc_04DE:
    ADDQ.W  #1,D5
    BRA.W   .loc_04D9

.loc_04DF:
    CMPI.W  #4,DISKIO_CurrentDriveRevisionIndex
    BLE.S   .loc_04E0

    MOVEQ   #-1,D0
    CMP.W   -28(A5),D0
    BNE.S   .loc_04E0

    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVE.W  D0,-28(A5)

.loc_04E0:
    MOVEQ   #-1,D0
    CMP.L   -32(A5),D0
    BNE.S   .loc_04E1

    PEA     52.W
    MOVE.L  A3,-(A7)
    PEA     1027.W
    PEA     Global_STR_DISKIO2_C_20
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    PEA     500.W
    MOVE.L  A2,-(A7)
    PEA     1028.W
    PEA     Global_STR_DISKIO2_C_21
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     32(A7),A7
    BRA.S   .loc_04E2

.loc_04E1:
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  A3,(A0)
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  A2,(A0)
    ADDQ.W  #1,D7
    BRA.W   .loc_04D2

.loc_04E2:
    MOVE.B  -37(A5),_TEXTDISP_SecondaryGroupHeaderCode
    MOVE.L  D7,D0
    MOVE.W  D0,_TEXTDISP_SecondaryGroupEntryCount
    MOVE.L  -36(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     1041.W
    PEA     Global_STR_DISKIO2_C_22
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #0,D0
    MOVE.B  -37(A5),D0
    MOVE.L  D0,(A7)
    JSR     COI_LoadOiDataFile(PC)

    LEA     16(A7),A7
    ADDQ.L  #1,D0
    BEQ.S   .loc_04E3

    MOVE.B  #$1,_CTASKS_SecondaryOiWritePendingFlag
    MOVE.B  -37(A5),_CTASKS_PendingSecondaryOiDiskId
    BRA.S   .loc_04E4

.loc_04E3:
    MOVEQ   #0,D0
    MOVE.B  D0,_CTASKS_SecondaryOiWritePendingFlag
    MOVE.B  D0,_CTASKS_PendingSecondaryOiDiskId

.loc_04E4:
    MOVE.L  -32(A5),D0

.loc_04E5:
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======