    XDEF    _DISKIO2_WriteNxtDayDataFile


;------------------------------------------------------------------------------
; FUNC: _DISKIO2_WriteNxtDayDataFile   (Write NXTDAY.DAT data file.)
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
;   _DISKIO2_NxtDayFileHandle, _DISKIO_SaveOperationReadyFlag
; DESC:
;   Opens NXTDAY.DAT and writes header fields plus per-entry records.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISKIO2_WriteNxtDayDataFile:
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
    TST.L   _DISKIO_SaveOperationReadyFlag
    BNE.S   .writenxt_begin_save

    MOVEQ   #0,D0
    BRA.W   .writenxt_return

.writenxt_begin_save:
    CLR.L   _DISKIO_SaveOperationReadyFlag
    CLR.B   -17(A5)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     (.desiredMemory).W
    PEA     817.W
    PEA     _Global_STR_DISKIO2_C_14
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,.offsetAllocatedMemory(A5)
    BNE.S   .writenxt_open_output_file

    MOVEQ   #1,D0
    MOVE.L  D0,_DISKIO_SaveOperationReadyFlag
    MOVEQ   #-1,D0
    BRA.W   .writenxt_return

.writenxt_open_output_file:
    PEA     (MODE_NEWFILE).W
    PEA     _Global_STR_DF0_NXTDAY_DAT
    JSR     _DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_DISKIO2_NxtDayFileHandle
    TST.L   D0
    BNE.S   .writenxt_write_header

    MOVEQ   #1,D0
    MOVE.L  D0,_DISKIO_SaveOperationReadyFlag
    PEA     (.desiredMemory).W
    MOVE.L  .offsetAllocatedMemory(A5),-(A7)
    PEA     839.W
    PEA     _Global_STR_DISKIO2_C_15
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #-1,D0
    BRA.W   .writenxt_return

.writenxt_write_header:
    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    MOVE.L  D0,-(A7)
    MOVE.L  _DISKIO2_NxtDayFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    MOVE.L  D0,(A7)
    MOVE.L  _DISKIO2_NxtDayFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_SecondaryGroupRecordChecksum,D0
    MOVE.L  D0,(A7)
    MOVE.L  _DISKIO2_NxtDayFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_SecondaryGroupRecordLength,D0
    MOVE.L  D0,(A7)
    MOVE.L  _DISKIO2_NxtDayFileHandle,-(A7)
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
    MOVE.L  _DISKIO2_NxtDayFileHandle,-(A7)
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
    MOVE.L  _DISKIO2_NxtDayFileHandle,-(A7)
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
    JSR     _GROUP_AH_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   .writenxt_next_slot

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  _DISKIO2_NxtDayFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.B  7(A0,D6.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  _DISKIO2_NxtDayFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D6,D1
    ADDI.W  #252,D1
    MOVE.B  0(A0,D1.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  _DISKIO2_NxtDayFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D6,D1
    ADDI.W  #301,D1
    MOVE.B  0(A0,D1.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  _DISKIO2_NxtDayFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D6,D1
    ADDI.W  #350,D1
    MOVE.B  0(A0,D1.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  _DISKIO2_NxtDayFileHandle,-(A7)
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
    MOVE.L  _DISKIO2_NxtDayFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.writenxt_next_slot:
    ADDQ.W  #1,D6
    BRA.W   .writenxt_slot_loop

.writenxt_emit_slot_sentinel:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  _DISKIO2_NxtDayFileHandle,-(A7)
    JSR     _DISKIO_WriteDecimalField(PC)

    ADDQ.W  #8,A7
    ADDQ.W  #1,D7
    BRA.W   .writenxt_entry_loop

.writenxt_finalize_and_free:
    MOVE.L  _DISKIO2_NxtDayFileHandle,-(A7)
    JSR     _DISKIO_CloseBufferedFileAndFlush(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,_DISKIO_SaveOperationReadyFlag
    PEA     (.desiredMemory).W
    MOVE.L  -22(A5),-(A7)
    PEA     901.W
    PEA     _Global_STR_DISKIO2_C_16
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #0,D0

.writenxt_return:
    MOVEM.L -32(A5),D6-D7
    UNLK    A5
    RTS

;!======