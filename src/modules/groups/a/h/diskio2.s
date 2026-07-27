    XDEF    DISKIO2_CopyAndSanitizeSlotString
    XDEF    DISKIO2_DisplayStatusLine
    XDEF    DISKIO2_FlushDataFilesIfNeeded
    XDEF    DISKIO2_HandleInteractiveFileTransfer
    XDEF    _DISKIO2_LoadCurDayDataFile
    XDEF    _DISKIO2_LoadNxtDayDataFile
    XDEF    _DISKIO2_LoadOinfoDataFile
    XDEF    DISKIO2_ParseIniFileFromDisk
    XDEF    DISKIO2_ReceiveTransferBlocksToFile
    XDEF    _DISKIO2_RunDiskSyncWorkflow
    XDEF    _DISKIO2_WriteCurDayDataFile
    XDEF    DISKIO2_WriteNxtDayDataFile
    XDEF    DISKIO2_WriteOinfoDataFile
    XDEF    DISKIO2_WriteQTableIniFile


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
;   _DISKIO_OpenFileWithBuffer, _DISKIO_WriteBufferedBytes, _DISKIO_WriteDecimalField, _DISKIO_CloseBufferedFileAndFlush, DISKIO2_CopyAndSanitizeSlotString
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
    BSR.W   DISKIO2_CopyAndSanitizeSlotString

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
;   GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh, DISKIO2_DisplayStatusLine, DISKIO2_FlushDataFilesIfNeeded, ED1_JMPTBL_LADFUNC_SaveTextAdsToFile, DISKIO_SaveConfigToFileHandle, GROUP_AH_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile, DISKIO2_WriteQTableIniFile,
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
    PEA     LOCAVAIL_SecondaryFilterState
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
    BSR.W   DISKIO2_WriteQTableIniFile

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
;   COI_EnsureAnimObjectAllocated, PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString, GROUP_AH_JMPTBL_ESQIFF2_ApplyIncomingStatusPacket, GROUP_AH_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters, _ESQPARS_ReplaceOwnedString
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
    JSR     COI_EnsureAnimObjectAllocated(PC)

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
;   _DISKIO_OpenFileWithBuffer, _DISKIO_WriteBufferedBytes, _DISKIO_WriteDecimalField, _DISKIO_CloseBufferedFileAndFlush, DISKIO2_CopyAndSanitizeSlotString
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
    BSR.W   DISKIO2_CopyAndSanitizeSlotString

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
;   GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults, COI_EnsureAnimObjectAllocated, GROUP_AH_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters, _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString, COI_LoadOiDataFile
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
    JSR     COI_EnsureAnimObjectAllocated(PC)

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

;------------------------------------------------------------------------------
; FUNC: DISKIO2_WriteQTableIniFile   (Write INI-style banner list to disk.)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +12: arg_2 (via 16(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A7/D0/D1/D7
; CALLS:
;   _DISKIO_OpenFileWithBuffer, _DISKIO_WriteBufferedBytes, _DISKIO_CloseBufferedFileAndFlush
; READS:
;   _TEXTDISP_AliasCount, _TEXTDISP_AliasPtrTable tables
; WRITES:
;   _DISKIO2_QTableIniFileHandle
; DESC:
;   Writes a banner list file using the current _TEXTDISP_AliasPtrTable entries.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISKIO2_WriteQTableIniFile:
    LINK.W  A5,#-12
    MOVE.L  D7,-(A7)
    MOVE.L  #_DISKIO2_STR_QTABLE,-4(A5)
    MOVE.W  _TEXTDISP_AliasCount,D0
    MOVEQ   #1,D1
    CMP.W   D1,D0
    BGE.S   .writeqtable_open_file

    MOVEQ   #-1,D0
    BRA.W   .writeqtable_return

.writeqtable_open_file:
    PEA     MODE_NEWFILE.W
    PEA     _CTASKS_PATH_QTABLE_INI
    JSR     _DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_DISKIO2_QTableIniFileHandle
    TST.L   D0
    BEQ.S   .writeqtable_fail

    MOVE.W  _TEXTDISP_AliasCount,D0
    BNE.S   .writeqtable_write_header

.writeqtable_fail:
    MOVEQ   #-1,D0
    BRA.W   .writeqtable_return

.writeqtable_write_header:
    MOVEA.L -4(A5),A0

.writeqtable_scan_header_len:
    TST.B   (A0)+
    BNE.S   .writeqtable_scan_header_len

    SUBQ.L  #1,A0
    SUBA.L  -4(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  _DISKIO2_QTableIniFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    PEA     2.W
    PEA     _DISKIO2_STR_QTableLineBreakAfterHeader
    MOVE.L  _DISKIO2_QTableIniFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     24(A7),A7
    MOVEQ   #0,D7

    ; Emit each banner entry with separators.
.writeqtable_entry_loop:
    MOVE.W  _TEXTDISP_AliasCount,D0
    CMP.W   D0,D7
    BCC.W   .writeqtable_close_file

    MOVEQ   #0,D0
    MOVE.W  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_AliasPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    MOVEA.L -8(A5),A1
    MOVEA.L (A1),A0

.writeqtable_scan_key_len:
    ; Write first string field.
    TST.B   (A0)+
    BNE.S   .writeqtable_scan_key_len

    SUBQ.L  #1,A0
    SUBA.L  (A1),A0
    MOVE.L  A0,-(A7)
    MOVE.L  (A1),-(A7)
    MOVE.L  _DISKIO2_QTableIniFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    PEA     1.W
    PEA     _DISKIO2_STR_QTableEquals
    MOVE.L  _DISKIO2_QTableIniFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    PEA     1.W
    PEA     _DISKIO2_STR_QTableValueQuoteOpen
    MOVE.L  _DISKIO2_QTableIniFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    MOVEA.L -8(A5),A1
    MOVEA.L 4(A1),A0

.writeqtable_scan_value_len:
    ; Write second string field.
    TST.B   (A0)+
    BNE.S   .writeqtable_scan_value_len

    SUBQ.L  #1,A0
    SUBA.L  4(A1),A0
    MOVE.L  A0,(A7)
    MOVE.L  4(A1),-(A7)
    MOVE.L  _DISKIO2_QTableIniFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    PEA     1.W
    PEA     _DISKIO2_STR_QTableValueQuoteClose
    MOVE.L  _DISKIO2_QTableIniFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    PEA     2.W
    PEA     _DISKIO2_STR_QTableLineBreakAfterEntry
    MOVE.L  _DISKIO2_QTableIniFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     68(A7),A7
    ADDQ.W  #1,D7
    BRA.W   .writeqtable_entry_loop

.writeqtable_close_file:
    MOVE.L  _DISKIO2_QTableIniFileHandle,-(A7)
    JSR     _DISKIO_CloseBufferedFileAndFlush(PC)

.writeqtable_return:
    MOVE.L  -16(A5),D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO2_ParseIniFileFromDisk   (Parse INI file from disk.)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7
; CALLS:
;   _GROUP_AH_JMPTBL_ESQPARS_ClearAliasStringPointers, PARSEINI_ParseIniBufferAndDispatch
; READS:
;   _CTASKS_PATH_QTABLE_INI
; WRITES:
;   (none observed)
; DESC:
;   Invokes the INI parser for the _CTASKS_PATH_QTABLE_INI file.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISKIO2_ParseIniFileFromDisk:
    JSR     _GROUP_AH_JMPTBL_ESQPARS_ClearAliasStringPointers(PC)

    PEA     _CTASKS_PATH_QTABLE_INI
    JSR     _GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(PC)

    ADDQ.W  #4,A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO2_WriteOinfoDataFile   (Write small config file _CTASKS_PATH_OINFO_DAT.)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A7/D0
; CALLS:
;   _DISKIO_OpenFileWithBuffer, _DISKIO_WriteBufferedBytes, _DISKIO_WriteDecimalField, _DISKIO_CloseBufferedFileAndFlush
; READS:
;   _TEXTDISP_PrimaryGroupCode, _ESQIFF_PrimaryLineHeadPtr, _ESQIFF_PrimaryLineTailPtr
; WRITES:
;   _DISKIO2_OinfoFileHandle
; DESC:
;   Opens _CTASKS_PATH_OINFO_DAT and writes two optional strings plus a header byte.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISKIO2_WriteOinfoDataFile:
    LINK.W  A5,#-8
    PEA     MODE_NEWFILE.W
    PEA     _CTASKS_PATH_OINFO_DAT
    JSR     _DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_DISKIO2_OinfoFileHandle
    TST.L   D0
    BNE.S   .loc_04F2

    MOVEQ   #-1,D0
    BRA.W   .loc_04F9

.loc_04F2:
    CLR.B   -5(A5)
    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    MOVE.L  D0,-(A7)
    MOVE.L  _DISKIO2_OinfoFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    ADDQ.W  #8,A7
    TST.L   _ESQIFF_PrimaryLineHeadPtr
    BNE.S   .loc_04F3

    LEA     -5(A5),A0
    BRA.S   .loc_04F4

.loc_04F3:
    MOVEA.L _ESQIFF_PrimaryLineHeadPtr,A0

.loc_04F4:
    MOVEA.L A0,A1

    ; Write first optional string.
.loc_04F5:
    TST.B   (A1)+
    BNE.S   .loc_04F5

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  _DISKIO2_OinfoFileHandle,-(A7)
    MOVE.L  A0,-4(A5)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7
    TST.L   _ESQIFF_PrimaryLineTailPtr
    BNE.S   .loc_04F6

    LEA     -5(A5),A0
    BRA.S   .loc_04F7

.loc_04F6:
    MOVEA.L _ESQIFF_PrimaryLineTailPtr,A0

.loc_04F7:
    MOVEA.L A0,A1

    ; Write second optional string.
.loc_04F8:
    TST.B   (A1)+
    BNE.S   .loc_04F8

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  _DISKIO2_OinfoFileHandle,-(A7)
    MOVE.L  A0,-4(A5)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    MOVE.L  _DISKIO2_OinfoFileHandle,(A7)
    JSR     _DISKIO_CloseBufferedFileAndFlush(PC)

    MOVEQ   #0,D0

.loc_04F9:
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _DISKIO2_LoadOinfoDataFile   (Read config file _CTASKS_PATH_OINFO_DAT.)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +28: arg_3 (via 32(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A5/A7/D0/D1/D6/D7
; CALLS:
;   _DISKIO_LoadFileToWorkBuffer, _DISKIO_ConsumeCStringFromWorkBuffer, _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString, _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _CTASKS_PATH_OINFO_DAT, _TEXTDISP_PrimaryGroupCode
; WRITES:
;   _ESQIFF_PrimaryLineHeadPtr, _ESQIFF_PrimaryLineTailPtr
; DESC:
;   Parses two strings from _CTASKS_PATH_OINFO_DAT and stores them in globals.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISKIO2_LoadOinfoDataFile:
    LINK.W  A5,#-20
    MOVEM.L D6-D7/A2,-(A7)
    SUBA.L  A0,A0
    PEA     _CTASKS_PATH_OINFO_DAT
    MOVE.L  A0,-8(A5)
    MOVE.L  A0,-4(A5)
    JSR     _DISKIO_LoadFileToWorkBuffer(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BNE.S   .loc_04FB

    MOVEQ   #-1,D0
    BRA.W   .loc_04FE

.loc_04FB:
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D6
    MOVE.L  _Global_PTR_WORK_BUFFER,-12(A5)
    JSR     _DISKIO_ParseLongFromWorkBuffer(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #0,D0
    NOT.B   D0
    AND.L   D0,D1
    MOVE.L  D1,D7
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   .loc_04FC

    JSR     _DISKIO_ConsumeCStringFromWorkBuffer(PC)

    MOVE.L  D0,-4(A5)
    JSR     _DISKIO_ConsumeCStringFromWorkBuffer(PC)

    MOVE.L  D0,-8(A5)

.loc_04FC:
    MOVEA.W #$ffff,A0
    MOVEA.L -4(A5),A1
    CMPA.L  A1,A0
    BEQ.S   .loc_04FD

    MOVEA.L -8(A5),A2
    CMPA.L  A0,A2
    BEQ.S   .loc_04FD

    MOVE.L  _ESQIFF_PrimaryLineHeadPtr,-(A7)
    MOVE.L  A1,-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,_ESQIFF_PrimaryLineHeadPtr
    MOVE.L  _ESQIFF_PrimaryLineTailPtr,(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     12(A7),A7
    MOVE.L  D0,_ESQIFF_PrimaryLineTailPtr

.loc_04FD:
    MOVE.L  D6,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    PEA     1191.W
    PEA     _Global_STR_DISKIO2_C_23
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #0,D0

.loc_04FE:
    MOVEM.L -32(A5),D6-D7/A2
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO2_HandleInteractiveFileTransfer   (Interactive file receive/save workflow.)
; ARGS:
;   stack +7: arg_1 (via 11(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +13: arg_4 (via 17(A5))
;   stack +14: arg_5 (via 18(A5))
;   stack +54: arg_6 (via 58(A5))
;   stack +60: arg_7 (via 64(A5))
;   stack +64: arg_8 (via 68(A5))
;   stack +68: arg_9 (via 72(A5))
;   stack +72: arg_10 (via 76(A5))
;   stack +152: arg_11 (via 156(A5))
;   stack +176: arg_12 (via 180(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh, GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi, GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte, _DISPLIB_DisplayTextAtPosition, GROUP_AG_JMPTBL_STRING_CopyPadNul,
;   _LVOLock/_LVOUnLock/_LVOOpen/_LVOClose/_LVORead/_LVOWrite/_LVODeleteFile,
;   _GROUP_AM_JMPTBL_WDISP_SPrintf, GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay, GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults, _GROUP_AH_JMPTBL_STR_FindAnyCharPtr, DISKIO2_ReceiveTransferBlocksToFile
; READS:
;   DISKIO2_TransferFilenameBuffer..DISKIO_SavedReadModeFlags, _ED_DiagnosticsScreenActive, DISKIO2_TransferXorChecksumByte, CTASKS_EXT_GRF
; WRITES:
;   DISKIO2_TransferFilenameBuffer..DISKIO2_TransferCrcErrorCount, DISKIO2_InteractiveTransferArmedFlag/21CB, _ESQPARS2_ReadModeFlags
; DESC:
;   Reads a filename and payload, validates/locks the target, and writes the data.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISKIO2_HandleInteractiveFileTransfer:
    LINK.W  A5,#-160
    MOVEM.L D2-D3/D5-D7,-(A7)
    MOVE.B  11(A5),D7
    PEA     1.W
    PEA     4.W
    JSR     GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D5
    CLR.B   -17(A5)
    TST.B   D7
    BEQ.S   .xfer_set_checksum_default

    MOVE.B  #$c2,DISKIO2_TransferXorChecksumByte
    BRA.S   .xfer_wait_before_filename

.xfer_set_checksum_default:
    MOVE.B  #$b7,DISKIO2_TransferXorChecksumByte

.xfer_wait_before_filename:
    JSR     GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    ; Read filename into DISKIO2_TransferFilenameBuffer with checksum.
.xfer_read_filename_loop:
    CMPI.B  #$1f,-17(A5)
    BCC.S   .xfer_finalize_filename

    JSR     GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,-18(A5)
    TST.B   D0
    BEQ.S   .xfer_finalize_filename

    MOVE.B  -17(A5),D1
    ADDQ.B  #1,-17(A5)
    MOVEQ   #0,D2
    MOVE.B  D1,D2
    LEA     DISKIO2_TransferFilenameBuffer,A0
    ADDA.W  D2,A0
    MOVE.B  D0,(A0)
    MOVE.B  DISKIO2_TransferXorChecksumByte,D1
    EOR.B   D0,D1
    MOVE.B  D1,DISKIO2_TransferXorChecksumByte
    JSR     GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    BRA.S   .xfer_read_filename_loop

.xfer_finalize_filename:
    MOVEQ   #0,D0
    MOVE.B  -17(A5),D0
    LEA     DISKIO2_TransferFilenameBuffer,A0
    ADDA.W  D0,A0
    CLR.B   (A0)
    MOVEQ   #13,D1
    CMP.B   D1,D0
    BNE.S   .xfer_prepare_target_paths

    PEA     CTASKS_EXT_GRF
    PEA     DISKIO2_TransferFilenameExtPtr
    JSR     GROUP_AH_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .xfer_prepare_target_paths

    MOVEQ   #0,D5
    TST.W   _ED_DiagnosticsScreenActive
    BEQ.S   .xfer_prepare_target_paths

    PEA     Global_STR_SPECIAL_NGAD
    PEA     240.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7

.xfer_prepare_target_paths:
    LEA     DISKIO2_TransferFilenameBuffer,A0
    LEA     -58(A5),A1

.xfer_copy_filename_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .xfer_copy_filename_loop

    PEA     4.W
    PEA     Global_STR_RAM
    PEA     -58(A5)
    JSR     GROUP_AG_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    TST.W   _ED_DiagnosticsScreenActive
    BEQ.S   .xfer_optional_size_guard

    PEA     Global_STR_FILENAME
    PEA     180.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     DISKIO2_TransferFilenameBuffer
    PEA     180.W
    PEA     205.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7

.xfer_optional_size_guard:
    PEA     4.W
    PEA     DISKIO2_TransferFilenameBuffer
    PEA     -68(A5)
    JSR     GROUP_AG_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D0
    MOVE.B  D0,-64(A5)
    TST.B   D7
    BEQ.W   .xfer_verify_name_checksum_and_open

    MOVE.B  D0,-17(A5)
    JSR     GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    ; Read secondary token into DISKIO2_TransferSizeTokenBuffer with checksum.
.xfer_read_secondary_token_loop:
    CMPI.B  #$8,-17(A5)
    BCC.S   .xfer_finalize_secondary_token

    JSR     GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,-18(A5)
    TST.B   D0
    BEQ.S   .xfer_finalize_secondary_token

    MOVE.B  -17(A5),D1
    ADDQ.B  #1,-17(A5)
    MOVEQ   #0,D2
    MOVE.B  D1,D2
    LEA     DISKIO2_TransferSizeTokenBuffer,A0
    ADDA.W  D2,A0
    MOVE.B  D0,(A0)
    MOVE.B  DISKIO2_TransferXorChecksumByte,D1
    EOR.B   D0,D1
    MOVE.B  D1,DISKIO2_TransferXorChecksumByte
    JSR     GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    BRA.S   .xfer_read_secondary_token_loop

.xfer_finalize_secondary_token:
    MOVEQ   #0,D0
    MOVE.B  -17(A5),D0
    LEA     DISKIO2_TransferSizeTokenBuffer,A0
    ADDA.W  D0,A0
    CLR.B   (A0)
    LEA     -68(A5),A0
    MOVE.L  A0,D1
    MOVEQ   #-2,D2
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOLock(A6)

    MOVE.L  D0,-76(A5)
    TST.L   D0
    BEQ.S   .xfer_parse_requested_size

    MOVE.L  #(MEMF_CLEAR),-(A7)
    PEA     Struct_InfoData_Size.W
    PEA     1312.W
    PEA     Global_STR_DISKIO2_C_24
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-72(A5)
    TST.L   D0
    BEQ.S   .xfer_unlock_target_dir

    MOVE.L  D0,D2
    MOVE.L  -76(A5),D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOInfo(A6)

    TST.L   D0
    BEQ.S   .xfer_have_volume_info

    MOVE.L  #$6de,D0
    MOVEA.L D2,A0
    SUB.L   16(A0),D0
    ASL.L   #8,D0
    ADD.L   D0,D0
    SUBI.L  #$1000,D0
    MOVE.L  D0,-12(A5)

.xfer_have_volume_info:
    PEA     Struct_InfoData_Size.W
    MOVE.L  D2,-(A7)
    PEA     1318.W
    PEA     Global_STR_DISKIO2_C_25
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.xfer_unlock_target_dir:
    MOVE.L  -76(A5),D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOUnLock(A6)

.xfer_parse_requested_size:
    PEA     DISKIO2_TransferSizeTokenBuffer
    JSR     GROUP_AH_JMPTBL_PARSE_ReadSignedLongSkipClass3(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-16(A5)
    CMP.L   -12(A5),D0
    BLE.S   .xfer_verify_name_checksum_and_open

    LEA     DISKIO2_TransferFilenameBuffer,A0
    LEA     _BRUSH_SnapshotHeader,A1   ; refresh saved UI header with on-disk metadata

.xfer_copy_name_to_snapshot_header:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .xfer_copy_name_to_snapshot_header

    PEA     2.W
    JSR     GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay(PC)

    MOVEQ   #0,D0
    MOVE.L  D0,DISKIO2_InteractiveTransferArmedFlag
    MOVE.L  D0,(A7)
    PEA     4.W
    JSR     GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)

    MOVEQ   #-2,D0
    BRA.W   .xfer_return

.xfer_verify_name_checksum_and_open:
    JSR     GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,_ESQIFF_RecordChecksumByte
    MOVE.B  DISKIO2_TransferXorChecksumByte,D1
    CMP.B   D1,D0
    BNE.W   .xfer_clear_overlay_and_maybe_report_disk

    MOVEQ   #1,D0
    CMP.L   D0,D5
    BNE.W   .xfer_clear_overlay_and_maybe_report_disk

    PEA     (MODE_NEWFILE).W
    PEA     -58(A5)
    JSR     GROUP_AG_JMPTBL_DOS_OpenFileWithMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,DISKIO_WriteFileHandle
    TST.L   D0
    BNE.S   .xfer_setup_transfer_state

    PEA     5.W
    JSR     DISKIO_DrawTransferErrorMessageIfDiagnostics(PC)

    CLR.L   (A7)
    PEA     4.W
    JSR     GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)

    MOVEQ   #-1,D0
    BRA.W   .xfer_return

.xfer_setup_transfer_state:
    MOVE.W  _ESQPARS2_ReadModeFlags,DISKIO_SavedReadModeFlags
    MOVE.W  #$100,_ESQPARS2_ReadModeFlags
    CLR.L   DISKIO2_TransferCrcErrorCount
    CLR.B   DISKIO2_TransferBlockSequence
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     4352.W
    PEA     1389.W
    PEA     Global_STR_DISKIO2_C_26
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,DISKIO2_TransferBlockBufferPtr
    MOVE.W  DISKIO_SavedReadModeFlags,_ESQPARS2_ReadModeFlags
    CLR.W   DISKIO2_TransferBufferedByteCount

.xfer_wait_for_sync_markers:
    JSR     GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,-18(A5)
    MOVEQ   #85,D0
    CMP.B   -18(A5),D0
    BNE.S   .xfer_wait_for_sync_markers

    JSR     GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.B  D0,-18(A5)
    MOVEQ   #85,D0
    ADD.L   D0,D0
    CMP.L   D0,D1
    BNE.S   .xfer_wait_for_sync_markers

    JSR     GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,-18(A5)
    MOVEQ   #72,D1
    CMP.B   D1,D0
    BEQ.S   .xfer_handle_data_marker

    MOVEQ   #61,D1
    CMP.B   D1,D0
    BNE.S   .xfer_handle_delete_marker

.xfer_handle_data_marker:
    MOVEQ   #61,D1
    CMP.B   D1,D0
    BNE.S   .xfer_set_checksum_h_mode

    MOVE.B  #$c2,DISKIO2_TransferXorChecksumByte
    BRA.S   .xfer_dispatch_receive_blocks

.xfer_set_checksum_h_mode:
    MOVE.B  #$b7,DISKIO2_TransferXorChecksumByte

.xfer_dispatch_receive_blocks:
    CMP.B   D1,D0
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    BSR.W   DISKIO2_ReceiveTransferBlocksToFile

    ADDQ.W  #4,A7
    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   .xfer_wait_for_sync_markers

    BRA.S   .xfer_teardown_transfer_state

.xfer_handle_delete_marker:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #68,D0
    NOT.B   D0
    CMP.L   D0,D1
    BNE.W   .xfer_wait_for_sync_markers

    JSR     GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.B  D0,-18(A5)
    MOVEQ   #68,D0
    NOT.B   D0
    CMP.L   D0,D1
    BNE.W   .xfer_wait_for_sync_markers

    JSR     GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,-18(A5)
    BNE.W   .xfer_wait_for_sync_markers

    JSR     GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.B  D0,-18(A5)
    MOVEQ   #0,D0
    NOT.B   D0
    CMP.L   D0,D1
    BNE.W   .xfer_wait_for_sync_markers

    MOVEQ   #4,D6

.xfer_teardown_transfer_state:
    MOVE.W  _ESQPARS2_ReadModeFlags,DISKIO_SavedReadModeFlags
    MOVE.W  #$100,_ESQPARS2_ReadModeFlags
    MOVE.L  DISKIO_WriteFileHandle,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

    PEA     4352.W
    MOVE.L  DISKIO2_TransferBlockBufferPtr,-(A7)
    PEA     1499.W
    PEA     Global_STR_DISKIO2_C_27
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    TST.W   _ED_DiagnosticsScreenActive
    BEQ.S   .xfer_post_transfer_status

    PEA     DISKIO2_STR_DiagTransferStatusClearLine210
    PEA     210.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     DISKIO2_STR_DiagTransferStatusClearLine240
    PEA     240.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7

.xfer_post_transfer_status:
    MOVEQ   #-1,D0
    CMP.L   D0,D6

    BNE.W   .xfer_handle_transfer_error

    LEA     DISKIO2_TransferFilenameBuffer,A0
    MOVE.L  A0,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVODeleteFile(A6)

    JSR     DISKIO_ForceUiRefreshIfIdle(PC)

    LEA     Global_STR_COPY_NIL,A0
    LEA     -156(A5),A1
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    PEA     -58(A5)
    PEA     -156(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    PEA     DISKIO2_STR_ShellCommandArgSeparator
    PEA     -156(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    PEA     DISKIO2_TransferFilenameBuffer
    PEA     -156(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     -156(A5),A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    LEA     -58(A5),A0
    MOVE.L  A0,D1
    JSR     _LVODeleteFile(A6)

    JSR     DISKIO_ResetCtrlInputStateIfIdle(PC)

    LEA     24(A7),A7
    TST.W   _ED_DiagnosticsScreenActive
    BEQ.S   .xfer_restore_read_mode

    PEA     Global_STR_STORED
    PEA     180.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    BRA.S   .xfer_restore_read_mode

.xfer_handle_transfer_error:
    MOVE.L  D6,-(A7)
    JSR     DISKIO_DrawTransferErrorMessageIfDiagnostics(PC)

    ADDQ.W  #4,A7
    LEA     -58(A5),A0
    MOVE.L  A0,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVODeleteFile(A6)

.xfer_restore_read_mode:
    MOVE.W  DISKIO_SavedReadModeFlags,_ESQPARS2_ReadModeFlags

.xfer_clear_overlay_and_maybe_report_disk:
    MOVEQ   #0,D0
    MOVE.L  D0,DISKIO2_InteractiveTransferArmedFlag
    MOVE.L  D0,-(A7)
    PEA     4.W
    JSR     GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)

    ADDQ.W  #8,A7
    TST.W   _ED_DiagnosticsScreenActive
    BEQ.S   .xfer_return

    PEA     DISKIO2_DiagnosticsDiskUsagePercentBuffer
    JSR     _DISKIO_QueryDiskUsagePercentAndSetBufferSize(PC)

    PEA     DISKIO2_DiagnosticsSoftErrorCountBuffer
    MOVE.L  D0,28(A7)
    JSR     _DISKIO_QueryVolumeSoftErrorCount(PC)

    MOVE.L  D0,(A7)
    MOVE.L  28(A7),-(A7)
    PEA     Global_STR_DISK_0_IS_FULL_WITH_ERRORS_FORMATTED
    PEA     -58(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -58(A5)
    PEA     90.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     36(A7),A7

.xfer_return:
    MOVEM.L -180(A5),D2-D3/D5-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO2_ReceiveTransferBlocksToFile   (Receive data block and write to disk.)
; ARGS:
;   stack +6: arg_1 (via 10(A5))
;   stack +7: arg_2 (via 11(A5))
;   stack +10: arg_3 (via 14(A5))
;   stack +11: arg_4 (via 15(A5))
;   stack +12: arg_5 (via 16(A5))
;   stack +1036: arg_6 (via 1040(A5))
;   stack +1060: arg_7 (via 1064(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi, GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte, DISKIO_WriteBytesToOutputHandleGuarded, GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay, DISKIO_DrawTransferErrorMessageIfDiagnostics, _LVODeleteFile
; READS:
;   DISKIO2_TransferBlockLength..DISKIO2_TransferCrcErrorCount, _ESQIFF_ParseAttemptCount, DISKIO2_TransferXorChecksumByte
; WRITES:
;   DISKIO2_TransferBlockLength..DISKIO2_TransferCrcErrorCount, _ESQIFF_ParseAttemptCount
; DESC:
;   Reads a variable-length data stream with checksum tracking and writes it out.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISKIO2_ReceiveTransferBlocksToFile:
    LINK.W  A5,#-1040
    MOVEM.L D2-D7,-(A7)

    MOVE.B  11(A5),D7
    MOVEQ   #-1,D0
    MOVE.L  D0,-10(A5)
    CLR.L   -14(A5)
    CLR.B   -16(A5)
    LEA     DISKIO2_TransferCrc32Table,A0
    LEA     -1040(A5),A1
    MOVE.W  #$ff,D0

.blockrx_init_crc_table_copy_loop:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.blockrx_init_crc_table_copy_loop

    JSR     GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  D0,D4
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    MOVE.B  DISKIO2_TransferBlockSequence,D0
    CMP.B   D0,D4
    BNE.W   .blockrx_unexpected_sequence

    MOVE.B  DISKIO2_TransferXorChecksumByte,D1
    EOR.B   D0,D1
    MOVE.B  D1,DISKIO2_TransferXorChecksumByte
    JSR     GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,DISKIO2_TransferBlockLength
    TST.B   D0
    BEQ.W   .blockrx_handle_zero_length_block

    MOVE.B  DISKIO2_TransferXorChecksumByte,D1
    EOR.B   D0,D1
    MOVE.B  D1,DISKIO2_TransferXorChecksumByte
    MOVE.W  DISKIO2_TransferBufferedByteCount,D5
    MOVEQ   #0,D6

    ; Stream in payload bytes and fold into checksum.
.blockrx_payload_byte_loop:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  DISKIO2_TransferBlockLength,D1
    CMP.L   D1,D0
    BEQ.S   .blockrx_after_payload

    JSR     GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  D0,D4
    MOVE.B  DISKIO2_TransferXorChecksumByte,D0
    EOR.B   D4,D0
    MOVE.B  D0,DISKIO2_TransferXorChecksumByte
    MOVEQ   #0,D0
    MOVE.B  D4,D0
    MOVE.L  -10(A5),D1
    EOR.L   D1,D0
    MOVEQ   #0,D2
    NOT.B   D2
    AND.L   D2,D0
    ASL.L   #2,D0
    LEA     -1040(A5),A0
    ADDA.L  D0,A0
    LSR.L   #8,D1
    MOVE.L  (A0),D0
    EOR.L   D1,D0
    MOVE.L  D5,D1
    ADDQ.W  #1,D5
    MOVEA.L DISKIO2_TransferBlockBufferPtr,A0
    ADDA.W  D1,A0
    MOVE.B  D4,(A0)
    MOVE.L  D0,-10(A5)
    ADDQ.W  #1,D6
    BRA.S   .blockrx_payload_byte_loop

.blockrx_after_payload:
    TST.B   D7
    BEQ.S   .blockrx_verify_record_checksum

    CLR.L   -14(A5)
    MOVEQ   #0,D6

.blockrx_read_crc32_loop:
    MOVEQ   #4,D0
    CMP.W   D0,D6
    BGE.S   .blockrx_verify_crc32

    JSR     GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  DISKIO2_TransferXorChecksumByte,D1
    EOR.B   D0,D1
    MOVE.B  D1,DISKIO2_TransferXorChecksumByte
    MOVE.L  -14(A5),D1
    ASL.L   #8,D1
    MOVEQ   #0,D2
    MOVE.B  D0,D2
    MOVEQ   #0,D3
    NOT.B   D3
    AND.L   D3,D2
    OR.L    D2,D1
    MOVE.B  D0,-15(A5)
    MOVE.L  D1,-14(A5)
    ADDQ.W  #1,D6
    BRA.S   .blockrx_read_crc32_loop

.blockrx_verify_crc32:
    MOVE.L  -10(A5),D0
    CMP.L   -14(A5),D0
    BEQ.S   .blockrx_verify_record_checksum

    MOVEQ   #1,D0
    MOVE.B  D0,-16(A5)

.blockrx_verify_record_checksum:
    TST.B   -16(A5)
    BNE.S   .blockrx_mark_crc_error

    JSR     GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,_ESQIFF_RecordChecksumByte
    MOVE.B  DISKIO2_TransferXorChecksumByte,D1
    CMP.B   D1,D0
    BNE.W   .blockrx_continue_transfer

    MOVE.W  D5,DISKIO2_TransferBufferedByteCount
    CMPI.W  #$1000,D5
    BLT.S   .blockrx_advance_sequence

    MOVE.L  D5,D0
    MOVE.W  D0,DISKIO2_TransferBufferedByteCount
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  DISKIO2_TransferBlockBufferPtr,-(A7)
    JSR     DISKIO_WriteBytesToOutputHandleGuarded(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   .blockrx_flush_buffer_success

    MOVEQ   #2,D0
    BRA.W   .blockrx_return

.blockrx_flush_buffer_success:
    CLR.W   DISKIO2_TransferBufferedByteCount

.blockrx_advance_sequence:
    MOVE.B  DISKIO2_TransferBlockSequence,D0
    MOVE.L  D0,D1
    ADDQ.B  #1,D1
    MOVE.B  D1,DISKIO2_TransferBlockSequence
    MOVEQ   #0,D0
    MOVE.B  D1,D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVE.B  D0,DISKIO2_TransferBlockSequence
    MOVEQ   #0,D0
    MOVE.L  D0,DISKIO2_TransferCrcErrorCount
    BRA.S   .blockrx_continue_transfer

.blockrx_mark_crc_error:
    CLR.B   -16(A5)
    ADDQ.L  #1,DISKIO2_TransferCrcErrorCount
    BRA.S   .blockrx_continue_transfer

.blockrx_handle_zero_length_block:
    JSR     GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,_ESQIFF_RecordChecksumByte
    MOVE.B  DISKIO2_TransferXorChecksumByte,D1
    CMP.B   D1,D0
    BNE.S   .blockrx_checksum_mismatch_eof

    MOVE.W  DISKIO2_TransferBufferedByteCount,D0
    BLE.S   .blockrx_complete_transfer

    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  DISKIO2_TransferBlockBufferPtr,-(A7)
    JSR     DISKIO_WriteBytesToOutputHandleGuarded(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   .blockrx_flush_tail_success

    MOVEQ   #3,D0
    BRA.S   .blockrx_return

.blockrx_flush_tail_success:
    CLR.W   DISKIO2_TransferBufferedByteCount

.blockrx_complete_transfer:
    MOVEQ   #-1,D0
    BRA.S   .blockrx_return

.blockrx_checksum_mismatch_eof:
    MOVE.B  #$1,-16(A5)
    ADDQ.L  #1,DISKIO2_TransferCrcErrorCount

.blockrx_continue_transfer:
    MOVEQ   #0,D0
    BRA.S   .blockrx_return

.blockrx_unexpected_sequence:
    MOVEQ   #0,D0
    MOVE.B  D4,D0
    ADDQ.L  #1,D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVEQ   #0,D1
    MOVE.B  DISKIO2_TransferBlockSequence,D1
    CMP.L   D1,D0
    BNE.S   .blockrx_show_sequence_error_dialog

    MOVEQ   #0,D0
    BRA.S   .blockrx_return

.blockrx_show_sequence_error_dialog:
    LEA     DISKIO2_TransferFilenameBuffer,A0
    LEA     _BRUSH_SnapshotHeader,A1   ; keep error dialog text in sync with disk state

.blockrx_copy_name_to_snapshot_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .blockrx_copy_name_to_snapshot_loop

    PEA     1.W
    JSR     GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay(PC)

    MOVEQ   #1,D0

.blockrx_return:
    MOVEM.L -1064(A5),D2-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO2_CopyAndSanitizeSlotString   (Copy and sanitize slot string.)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +18: arg_4 (via 22(A5))
; RET:
;   D0: dest pointer (or 0 if not copied)
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D7
; CALLS:
;   _GROUP_AI_JMPTBL_STR_FindCharPtr, _GROUP_AH_JMPTBL_STR_FindAnyCharPtr
; READS:
;   7(A0,D7), 27(A2)
; WRITES:
;   dest buffer
; DESC:
;   Copies a slot string to the destination, trims/normalizes, and terminates it.
; NOTES:
;   Skips copy when flags indicate the slot should be hidden.
;------------------------------------------------------------------------------
DISKIO2_CopyAndSanitizeSlotString:
    LINK.W  A5,#-12
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  22(A5),D7
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L 16(A5),A0
    MOVEA.L 56(A0,D0.L),A0
    MOVE.L  A0,-12(A5)
    MOVE.L  A2,D0
    BEQ.W   .sanitize_return

    TST.L   16(A5)
    BEQ.W   .sanitize_return

    TST.W   D7
    BLE.W   .sanitize_return

    MOVEQ   #49,D0
    CMP.W   D0,D7
    BGE.W   .sanitize_return

    MOVE.L  A0,D0
    BEQ.W   .sanitize_return

    TST.B   (A0)
    BEQ.W   .sanitize_return

    MOVEA.L 16(A5),A0
    BTST    #1,7(A0,D7.W)
    BNE.S   .sanitize_copy_if_slot_visible

    BTST    #4,27(A2)
    BEQ.S   .sanitize_return

.sanitize_copy_if_slot_visible:
    MOVEA.L -12(A5),A0
    MOVEA.L A3,A1

    ; Copy source string into destination buffer.
.sanitize_copy_source_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .sanitize_copy_source_loop

    PEA     34.W
    MOVE.L  A3,-(A7)
    JSR     _GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    BEQ.S   .sanitize_trim_after_quote

    ADDQ.L  #1,-4(A5)
    PEA     34.W
    MOVE.L  -4(A5),-(A7)
    JSR     _GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)

.sanitize_trim_after_quote:
    TST.L   D0
    BEQ.S   .sanitize_set_return_ptr

    PEA     _NEWGRID_EntrySplitDelimiterMask
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AH_JMPTBL_STR_FindAnyCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    BEQ.S   .sanitize_scan_trim_point

    MOVE.L  D0,-4(A5)

.sanitize_scan_trim_point:
    ; Skip leading spaces after expansion.
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   .sanitize_terminate_string

    MOVEQ   #32,D0
    CMP.B   (A0),D0
    BEQ.S   .sanitize_terminate_string

    ADDQ.L  #1,-4(A5)
    BRA.S   .sanitize_scan_trim_point

.sanitize_terminate_string:
    MOVEA.L -4(A5),A0
    CLR.B   (A0)

.sanitize_set_return_ptr:
    MOVEA.L A3,A0
    MOVE.L  A0,-12(A5)

.sanitize_return:
    MOVE.L  -12(A5),D0
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO2_FlushDataFilesIfNeeded   (Flush disk data files if needed.)
; ARGS:
;   (none observed)
; RET:
;   D0: none
; CLOBBERS:
;   A7/D0
; CALLS:
;   _DISKIO2_WriteCurDayDataFile, DISKIO2_WriteNxtDayDataFile, DISKIO2_WriteOinfoDataFile, COI_WriteOiDataFile
; READS:
;   DISKIO2_FlushDataFilesGuardFlag, _TEXTDISP_PrimaryGroupEntryCount, _CTASKS_PrimaryOiWritePendingFlag/1B90
; WRITES:
;   DISKIO2_FlushDataFilesGuardFlag
; DESC:
;   Guards against reentry and writes disk-related data files when eligible.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISKIO2_FlushDataFilesIfNeeded:
    TST.W   DISKIO2_FlushDataFilesGuardFlag
    BNE.S   .loc_0538

    MOVE.W  #1,DISKIO2_FlushDataFilesGuardFlag
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMPI.W  #$c9,D0
    BCC.S   .loc_0537

    BSR.W   _DISKIO2_WriteCurDayDataFile

    BSR.W   DISKIO2_WriteNxtDayDataFile

    BSR.W   DISKIO2_WriteOinfoDataFile

    TST.B   _CTASKS_PrimaryOiWritePendingFlag
    BEQ.S   .loc_0536

    MOVEQ   #0,D0
    MOVE.B  _CTASKS_PendingPrimaryOiDiskId,D0
    MOVE.L  D0,-(A7)
    JSR     COI_WriteOiDataFile(PC)

    ADDQ.W  #4,A7

.loc_0536:
    TST.B   _CTASKS_SecondaryOiWritePendingFlag
    BEQ.S   .loc_0537

    MOVEQ   #0,D0
    MOVE.B  _CTASKS_PendingSecondaryOiDiskId,D0
    MOVE.L  D0,-(A7)
    JSR     COI_WriteOiDataFile(PC)

    ADDQ.W  #4,A7

.loc_0537:
    CLR.W   DISKIO2_FlushDataFilesGuardFlag

.loc_0538:
    RTS

;!======
