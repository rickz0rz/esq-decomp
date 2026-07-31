    XDEF    _COI_WriteOiDataFile


;------------------------------------------------------------------------------
; FUNC: _COI_WriteOiDataFile   (WriteOiDataFileuncertain)
; ARGS:
;   stack +7: arg_1 (via 11(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +22: arg_4 (via 26(A5))
;   stack +24: arg_5 (via 28(A5))
;   stack +26: arg_6 (via 30(A5))
;   stack +28: arg_7 (via 32(A5))
;   stack +108: arg_8 (via 112(A5))
;   stack +148: arg_9 (via 152(A5))
;   stack +172: arg_10 (via 176(A5))
; RET:
;   D0: 0 on success, 1 on invalid header, -3 on file open failure
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _GROUP_AG_JMPTBL_MATH_DivS32, _GROUP_AE_JMPTBL_WDISP_SPrintf, _DISKIO_OpenFileWithBuffer,
;   _DISKIO_WriteBufferedBytes, _ESQ_WildcardMatch, _DISKIO_CloseBufferedFileAndFlush
; READS:
;   _TEXTDISP_SecondaryGroupCode/_TEXTDISP_SecondaryGroupPresentFlag/_TEXTDISP_SecondaryGroupEntryCount/_TEXTDISP_PrimaryGroupCode/_TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryEntryPtrTable/_TEXTDISP_SecondaryEntryPtrTable
; WRITES:
;   _CTASKS_PrimaryOiWritePendingFlag/_CTASKS_SecondaryOiWritePendingFlag/_CTASKS_PendingPrimaryOiDiskId/_CTASKS_PendingSecondaryOiDiskId (flags), output file contents
; DESC:
;   Writes `df0:OI_%02lx.dat` for the selected diskId, emitting a tab-delimited
;   header plus per-entry and per-subentry records with CR/LF separators.
; NOTES:
;   Uses wildcard name matching to skip duplicate entries, and writes $1A as an
;   EOF marker at the end of the file.
;------------------------------------------------------------------------------
_COI_WriteOiDataFile:
    LINK.W  A5,#-152
    MOVEM.L D5-D7/A2-A3/A6,-(A7)
    MOVE.B  11(A5),D7
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMPI.W  #$c8,D0
    BLS.S   .check_primary_header

    MOVEQ   #1,D0
    BRA.W   .return_status

.check_primary_header:
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D7,D0
    BNE.S   .check_secondary_header

    MOVE.B  _TEXTDISP_SecondaryGroupPresentFlag,D0
    SUBQ.B  #1,D0
    BNE.S   .check_secondary_header

    MOVEQ   #1,D0
    MOVE.B  D0,_CTASKS_SecondaryOiWritePendingFlag
    MOVE.B  D7,_CTASKS_PendingSecondaryOiDiskId
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D1
    MOVE.W  D1,-32(A5)
    BRA.S   .format_filename

.check_secondary_header:
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D7,D0
    BNE.S   .invalid_disk_id

    MOVE.B  #$1,_CTASKS_PrimaryOiWritePendingFlag
    MOVE.B  D7,_CTASKS_PendingPrimaryOiDiskId
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.W  D0,-32(A5)
    BRA.S   .format_filename

.invalid_disk_id:
    MOVEQ   #1,D0
    BRA.W   .return_status

.format_filename:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #2,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.W  D1,-30(A5)
    EXT.L   D1
    MOVE.L  D1,-(A7)
    PEA     _Global_STR_DF0_OI_PERCENT_2_LX_DAT_1
    PEA     -112(A5)
    JSR     _GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    PEA     MODE_NEWFILE.W
    PEA     -112(A5)
    JSR     _DISKIO_OpenFileWithBuffer(PC)

    LEA     20(A7),A7
    MOVE.L  D0,D5
    TST.L   D5
    BNE.S   .write_header_disk_id

    MOVEQ   #-3,D0
    BRA.W   .return_status

.write_header_disk_id:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    PEA     _COI_FMT_LONG_DEC_A
    PEA     -152(A5)
    JSR     _GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     -152(A5),A0
    MOVEA.L A0,A1

.measure_header_disk_id:
    TST.B   (A1)+
    BNE.S   .measure_header_disk_id

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    PEA     1.W
    PEA     _COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    PEA     2.W
    PEA     _COI_FMT_DEC_A
    PEA     -152(A5)
    JSR     _GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     -152(A5),A0
    MOVEA.L A0,A1

.measure_header_second_field:
    TST.B   (A1)+
    BNE.S   .measure_header_second_field

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    PEA     2.W
    PEA     _COI_RecordTerminatorCrLf
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     64(A7),A7
    CLR.W   -26(A5)

.entry_loop:
    MOVE.W  -26(A5),D0
    CMP.W   -32(A5),D0
    BGE.W   .write_eof

    MOVE.B  _TEXTDISP_SecondaryGroupCode,D1
    CMP.B   D1,D7
    BNE.S   .select_default_table

    MOVE.B  _TEXTDISP_SecondaryGroupPresentFlag,D1
    SUBQ.B  #1,D1
    BNE.S   .select_default_table

    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A3
    BRA.S   .entry_selected

.select_default_table:
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A3

.entry_selected:
    CLR.W   -28(A5)
    MOVE.W  -28(A5),D6
    EXT.L   D6

.find_duplicate_entry:
    MOVE.W  -28(A5),D0
    CMP.W   -26(A5),D0
    BGE.S   .entry_ready

    TST.L   D6
    BNE.S   .entry_ready

    MOVE.B  _TEXTDISP_SecondaryGroupCode,D1
    CMP.B   D1,D7
    BNE.S   .select_compare_table

    MOVE.B  _TEXTDISP_SecondaryGroupPresentFlag,D1
    SUBQ.B  #1,D1
    BNE.S   .select_compare_table

    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    BRA.S   .compare_entry_names

.select_compare_table:
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1

.compare_entry_names:
    LEA     12(A3),A0
    LEA     12(A1),A6
    MOVE.L  A6,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-16(A5)
    JSR     _ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    SEQ     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,D6
    ADDQ.W  #1,-28(A5)
    BRA.S   .find_duplicate_entry

.entry_ready:
    TST.L   D6
    BNE.W   .next_entry_group

    MOVEA.L 48(A3),A2
    LEA     12(A3),A0
    MOVE.L  A0,D0
    BEQ.S   .write_field24

    LEA     12(A3),A0
    LEA     12(A3),A1
    MOVEA.L A1,A6

.measure_entry_name:
    TST.B   (A6)+
    BNE.S   .measure_entry_name

    SUBQ.L  #1,A6
    SUBA.L  A1,A6
    MOVE.L  A6,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_field24:
    PEA     1.W
    PEA     _COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7
    TST.L   24(A2)
    BEQ.S   .write_field28

    MOVEA.L 24(A2),A0

.measure_field24:
    TST.B   (A0)+
    BNE.S   .measure_field24

    SUBQ.L  #1,A0
    SUBA.L  24(A2),A0
    MOVE.L  A0,-(A7)
    MOVE.L  24(A2),-(A7)
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_field28:
    PEA     1.W
    PEA     _COI_STR_COLON_A
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7
    TST.L   28(A2)
    BEQ.S   .write_field32

    MOVEA.L 28(A2),A0

.measure_field28:
    TST.B   (A0)+
    BNE.S   .measure_field28

    SUBQ.L  #1,A0
    SUBA.L  28(A2),A0
    MOVE.L  A0,-(A7)
    MOVE.L  28(A2),-(A7)
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_field32:
    PEA     1.W
    PEA     _COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    MOVE.L  32(A2),(A7)
    PEA     _COI_FMT_LONG_DEC_B
    PEA     -152(A5)
    JSR     _GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     -152(A5),A0
    MOVEA.L A0,A1

.measure_field32:
    TST.B   (A1)+
    BNE.S   .measure_field32

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    PEA     1.W
    PEA     _COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     40(A7),A7
    TST.L   4(A2)
    BEQ.S   .write_field0

    MOVEA.L 4(A2),A0

.measure_field4:
    TST.B   (A0)+
    BNE.S   .measure_field4

    SUBQ.L  #1,A0
    SUBA.L  4(A2),A0
    MOVE.L  A0,-(A7)
    MOVE.L  4(A2),-(A7)
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_field0:
    PEA     1.W
    PEA     _COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    MOVEA.L A2,A0

.measure_field0:
    TST.B   (A0)+
    BNE.S   .measure_field0

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    PEA     1.W
    PEA     _COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     32(A7),A7
    TST.L   12(A2)
    BEQ.S   .write_field16

    MOVEA.L 12(A2),A0

.measure_field12:
    TST.B   (A0)+
    BNE.S   .measure_field12

    SUBQ.L  #1,A0
    SUBA.L  12(A2),A0
    MOVE.L  A0,-(A7)
    MOVE.L  12(A2),-(A7)
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_field16:
    PEA     1.W
    PEA     _COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7
    TST.L   16(A2)
    BEQ.S   .write_field20

    MOVEA.L 16(A2),A0

.measure_field16:
    TST.B   (A0)+
    BNE.S   .measure_field16

    SUBQ.L  #1,A0
    SUBA.L  16(A2),A0
    MOVE.L  A0,-(A7)
    MOVE.L  16(A2),-(A7)
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_field20:
    PEA     1.W
    PEA     _COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7
    TST.L   20(A2)
    BEQ.S   .write_field8

    MOVEA.L 20(A2),A0

.measure_field20:
    TST.B   (A0)+
    BNE.S   .measure_field20

    SUBQ.L  #1,A0
    SUBA.L  20(A2),A0
    MOVE.L  A0,-(A7)
    MOVE.L  20(A2),-(A7)
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_field8:
    PEA     1.W
    PEA     _COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7
    TST.L   8(A2)
    BEQ.S   .write_entry_count

    MOVEA.L 8(A2),A0

.measure_field8:
    TST.B   (A0)+
    BNE.S   .measure_field8

    SUBQ.L  #1,A0
    SUBA.L  8(A2),A0
    MOVE.L  A0,-(A7)
    MOVE.L  8(A2),-(A7)
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_entry_count:
    PEA     1.W
    PEA     _COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    MOVE.W  36(A2),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     _COI_FMT_LONG_DEC_C
    PEA     -152(A5)
    JSR     _GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     -152(A5),A0
    MOVEA.L A0,A1

.measure_entry_count:
    TST.B   (A1)+
    BNE.S   .measure_entry_count

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    PEA     2.W
    PEA     _COI_RecordTerminatorCrLf
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     40(A7),A7
    CLR.W   -28(A5)

.subentry_loop:
    MOVE.W  -28(A5),D0
    CMP.W   36(A2),D0
    BGE.W   .next_entry_group

    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEA.L 38(A2),A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-12(A5)
    MOVEA.L -12(A5),A0
    MOVE.W  (A0),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     _COI_FMT_LONG_DEC_PAD2
    PEA     -152(A5)
    JSR     _GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     -152(A5),A0
    MOVEA.L A0,A1

.measure_subentry_id:
    TST.B   (A1)+
    BNE.S   .measure_subentry_id

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    PEA     1.W
    PEA     _COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     32(A7),A7
    MOVEA.L -12(A5),A0
    TST.L   18(A0)
    BEQ.S   .write_subentry_field22

    MOVEA.L 18(A0),A1

.measure_subentry_field18:
    TST.B   (A1)+
    BNE.S   .measure_subentry_field18

    SUBQ.L  #1,A1
    SUBA.L  18(A0),A1
    MOVE.L  A1,-(A7)
    MOVE.L  18(A0),-(A7)
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_subentry_field22:
    PEA     1.W
    PEA     _COI_STR_COLON_B
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7
    MOVEA.L -12(A5),A0
    TST.L   22(A0)
    BEQ.S   .write_subentry_field26

    MOVEA.L -12(A5),A1
    MOVEA.L 22(A1),A0

.measure_subentry_field22:
    TST.B   (A0)+
    BNE.S   .measure_subentry_field22

    SUBQ.L  #1,A0
    SUBA.L  22(A1),A0
    MOVE.L  A0,-(A7)
    MOVE.L  22(A1),-(A7)
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_subentry_field26:
    PEA     1.W
    PEA     _COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  26(A0),(A7)
    PEA     _COI_FMT_DEC_B
    PEA     -152(A5)
    JSR     _GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     -152(A5),A0
    MOVEA.L A0,A1

.measure_subentry_field26:
    TST.B   (A1)+
    BNE.S   .measure_subentry_field26

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    PEA     1.W
    PEA     _COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     40(A7),A7
    MOVEA.L -12(A5),A0
    TST.L   6(A0)
    BEQ.S   .write_subentry_field10

    MOVEA.L -12(A5),A1
    MOVEA.L 6(A1),A0

.measure_subentry_field6:
    TST.B   (A0)+
    BNE.S   .measure_subentry_field6

    SUBQ.L  #1,A0
    SUBA.L  6(A1),A0
    MOVE.L  A0,-(A7)
    MOVE.L  6(A1),-(A7)
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_subentry_field10:
    PEA     1.W
    PEA     _COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7
    MOVEA.L -12(A5),A0
    TST.L   10(A0)
    BEQ.S   .write_subentry_field14

    MOVEA.L -12(A5),A1
    MOVEA.L 10(A1),A0

.measure_subentry_field10:
    TST.B   (A0)+
    BNE.S   .measure_subentry_field10

    SUBQ.L  #1,A0
    SUBA.L  10(A1),A0
    MOVE.L  A0,-(A7)
    MOVE.L  10(A1),-(A7)
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_subentry_field14:
    PEA     1.W
    PEA     _COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7
    MOVEA.L -12(A5),A0
    TST.L   14(A0)
    BEQ.S   .write_subentry_field2

    MOVEA.L -12(A5),A1
    MOVEA.L 14(A1),A0

.measure_subentry_field14:
    TST.B   (A0)+
    BNE.S   .measure_subentry_field14

    SUBQ.L  #1,A0
    SUBA.L  14(A1),A0
    MOVE.L  A0,-(A7)
    MOVE.L  14(A1),-(A7)
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_subentry_field2:
    PEA     1.W
    PEA     _COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7
    MOVEA.L -12(A5),A0
    TST.L   2(A0)
    BEQ.S   .next_subentry

    MOVEA.L -12(A5),A1
    MOVEA.L 2(A1),A0

.measure_subentry_field2:
    TST.B   (A0)+
    BNE.S   .measure_subentry_field2

    SUBQ.L  #1,A0
    SUBA.L  2(A1),A0
    MOVE.L  A0,-(A7)
    MOVE.L  2(A1),-(A7)
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.next_subentry:
    PEA     2.W
    PEA     _COI_RecordTerminatorCrLf
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7
    ADDQ.W  #1,-28(A5)
    BRA.W   .subentry_loop

.next_entry_group:
    ADDQ.W  #1,-26(A5)
    BRA.W   .entry_loop

.write_eof:
    PEA     1.W
    PEA     _CLOCK_FileEofMarkerCtrlZ
    MOVE.L  D5,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    MOVE.L  D5,(A7)
    JSR     _DISKIO_CloseBufferedFileAndFlush(PC)

    MOVEQ   #0,D0

.return_status:
    MOVEM.L -176(A5),D5-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======