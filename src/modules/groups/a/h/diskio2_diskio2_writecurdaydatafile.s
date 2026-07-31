    XDEF    _DISKIO2_WriteCurDayDataFile


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
;   _TEXTDISP_PrimaryGroupCode/2231/2247/2248, _TEXTDISP_PrimaryEntryPtrTable/2236 tables, _WDISP_WeatherStatusTextPtr
; WRITES:
;   _DISKIO2_OutputFileHandle, _DISKIO_SaveOperationReadyFlag
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
    TST.L   _DISKIO_SaveOperationReadyFlag
    BNE.S   .writecur_begin_save

    MOVEQ   #0,D0
    BRA.W   .writecur_return

.writecur_begin_save:
    CLR.L   _DISKIO_SaveOperationReadyFlag
    CLR.B   -17(A5)

    ; DISKIO2.C:152 - Allocate 1000 bytes
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     1000.W
    PEA     152.W
    PEA     _Global_STR_DISKIO2_C_1
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-22(A5)
    BNE.S   .writecur_open_output_file

    MOVEQ   #1,D0
    MOVE.L  D0,_DISKIO_SaveOperationReadyFlag
    MOVEQ   #-1,D0
    BRA.W   .writecur_return

.writecur_open_output_file:
    PEA     MODE_NEWFILE.W
    PEA     _CTASKS_PATH_CURDAY_DAT
    JSR     _DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_DISKIO2_OutputFileHandle
    TST.L   D0
    BNE.S   .writecur_write_header

    PEA     1000.W
    MOVE.L  -22(A5),-(A7)
    PEA     176.W
    PEA     _Global_STR_DISKIO2_C_2
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,_DISKIO_SaveOperationReadyFlag
    MOVEQ   #-1,D0
    BRA.W   .writecur_return

.writecur_write_header:
    PEA     21.W
    PEA     _ESQ_STR_B
    MOVE.L  _DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    MOVE.W  _DST_PrimaryCountdown,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  _DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    PEA     7.W
    PEA     _Global_STR_DREV_5_1
    MOVE.L  _DISKIO2_OutputFileHandle,-(A7)
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
    MOVE.L  _DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     36(A7),A7
    TST.L   _WDISP_WeatherStatusTextPtr
    BNE.S   .writecur_use_weather_status_text

    LEA     -17(A5),A0
    MOVE.L  A0,-12(A5)
    BRA.S   .writecur_scan_optional_status_text

.writecur_use_weather_status_text:
    MOVEA.L _WDISP_WeatherStatusTextPtr,A0
    MOVE.L  A0,-12(A5)

    ; Compute length of optional string (_WDISP_WeatherStatusTextPtr or empty) and write it.
.writecur_scan_optional_status_text:
    TST.B   (A0)+
    BNE.S   .writecur_scan_optional_status_text

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  _DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    MOVE.L  D0,(A7)
    MOVE.L  _DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.L  D0,(A7)
    MOVE.L  _DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_PrimaryGroupRecordChecksum,D0
    MOVE.L  D0,(A7)
    MOVE.L  _DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupRecordLength,D0
    MOVE.L  D0,(A7)
    MOVE.L  _DISKIO2_OutputFileHandle,-(A7)
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
    MOVE.L  _DISKIO2_OutputFileHandle,-(A7)
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
    MOVE.L  _DISKIO2_OutputFileHandle,-(A7)
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
    JSR     _GROUP_AH_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   .writecur_next_slot

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  _DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.B  7(A0,D6.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  _DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D6,D1
    ADDI.W  #$fc,D1
    MOVE.B  0(A0,D1.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  _DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D6,D1
    ADDI.W  #$12d,D1
    MOVE.B  0(A0,D1.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  _DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D6,D1
    ADDI.W  #$15e,D1
    MOVE.B  0(A0,D1.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  _DISKIO2_OutputFileHandle,-(A7)
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
    MOVE.L  _DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.writecur_next_slot:
    ADDQ.W  #1,D6
    BRA.W   .writecur_slot_loop

.writecur_emit_slot_sentinel:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  _DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    ADDQ.W  #8,A7
    ADDQ.W  #1,D7
    BRA.W   .writecur_entry_loop

.writecur_finalize_and_free:
    MOVE.L  _DISKIO2_OutputFileHandle,-(A7)
    JSR     _DISKIO_CloseBufferedFileAndFlush(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,_DISKIO_SaveOperationReadyFlag
    PEA     1000.W
    MOVE.L  -22(A5),-(A7)
    PEA     275.W
    PEA     _Global_STR_DISKIO2_C_3
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #0,D0

.writecur_return:
    MOVEM.L -32(A5),D6-D7
    UNLK    A5
    RTS

;!======