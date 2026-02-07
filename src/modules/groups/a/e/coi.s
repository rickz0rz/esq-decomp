;!======

;------------------------------------------------------------------------------
; FUNC: COI_FreeEntryResources   (Routine at COI_FreeEntryResources)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A2/A3/A7/D0
; CALLS:
;   GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, COI_ClearAnimObjectStrings, COI_FreeSubEntryTableEntries
; READS:
;   Global_STR_COI_C_3
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
COI_FreeEntryResources:
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.L  A3,D0
    BEQ.S   COI_FreeEntryResources_Return

    MOVEA.L 48(A3),A2
    MOVE.L  A3,-(A7)
    BSR.W   COI_FreeSubEntryTableEntries

    MOVE.L  A3,(A7)
    BSR.W   COI_ClearAnimObjectStrings

    ADDQ.W  #4,A7
    MOVE.L  A2,D0
    BEQ.S   .lab_02CF

    PEA     42.W
    MOVE.L  A2,-(A7)
    PEA     815.W
    PEA     Global_STR_COI_C_3
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.lab_02CF:
    CLR.L   48(A3)

;------------------------------------------------------------------------------
; FUNC: COI_FreeEntryResources_Return   (Routine at COI_FreeEntryResources_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
COI_FreeEntryResources_Return:
    MOVEM.L (A7)+,A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: COI_ClearAnimObjectStrings   (Routine at COI_ClearAnimObjectStrings)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A3/A7/D0
; CALLS:
;   GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
COI_ClearAnimObjectStrings:
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.L  A3,D0
    BEQ.S   .lab_02D2

    MOVEA.L 48(A3),A0
    BRA.S   .lab_02D3

.lab_02D2:
    SUBA.L  A0,A0

.lab_02D3:
    MOVEA.L A0,A2
    MOVE.L  A2,D0
    BEQ.S   COI_ClearAnimObjectStrings_Return

    MOVEQ   #0,D0
    MOVE.B  D0,(A2)
    MOVE.B  D0,1(A2)
    MOVE.B  D0,2(A2)
    MOVE.B  D0,3(A2)
    MOVE.L  4(A2),-(A7)
    CLR.L   -(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,4(A2)
    MOVE.L  8(A2),(A7)
    CLR.L   -(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,8(A2)
    MOVE.L  12(A2),(A7)
    CLR.L   -(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,12(A2)
    MOVE.L  16(A2),(A7)
    CLR.L   -(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,16(A2)
    MOVE.L  20(A2),(A7)
    CLR.L   -(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,20(A2)
    MOVE.L  24(A2),(A7)
    CLR.L   -(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,24(A2)
    MOVE.L  28(A2),(A7)
    CLR.L   -(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     32(A7),A7
    MOVE.L  D0,28(A2)
    CLR.L   32(A2)

;------------------------------------------------------------------------------
; FUNC: COI_ClearAnimObjectStrings_Return   (Routine at COI_ClearAnimObjectStrings_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
COI_ClearAnimObjectStrings_Return:
    MOVEM.L (A7)+,A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: COI_FreeSubEntryTableEntries   (Routine at COI_FreeSubEntryTableEntries)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A7/D0/D7
; CALLS:
;   GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString, GROUP_AE_JMPTBL_SCRIPT_DeallocateBufferArray, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   Global_STR_COI_C_4, COI_FreeSubEntryTableEntries_Return
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
COI_FreeSubEntryTableEntries:
    LINK.W  A5,#-12
    MOVEM.L D7/A2-A3,-(A7)
    TST.L   8(A5)
    BEQ.S   .lab_02D6

    MOVEA.L 8(A5),A1
    MOVEA.L 48(A1),A0
    BRA.S   .lab_02D7

.lab_02D6:
    SUBA.L  A0,A0

.lab_02D7:
    MOVEA.L A0,A3
    MOVE.L  A3,D0
    BEQ.W   COI_FreeSubEntryTableEntries_Return

    MOVEQ   #0,D7

.lab_02D8:
    CMP.W   36(A3),D7
    BGE.S   .lab_02D9

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L 38(A3),A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    CLR.W   (A2)
    MOVE.L  2(A2),-(A7)
    CLR.L   -(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,2(A2)
    MOVE.L  6(A2),(A7)
    CLR.L   -(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,6(A2)
    MOVE.L  10(A2),(A7)
    CLR.L   -(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,10(A2)
    MOVE.L  14(A2),(A7)
    CLR.L   -(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,14(A2)
    MOVE.L  18(A2),(A7)
    CLR.L   -(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,18(A2)
    MOVE.L  22(A2),(A7)
    CLR.L   -(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     28(A7),A7
    MOVE.L  D0,22(A2)
    CLR.L   26(A2)
    ADDQ.W  #1,D7
    BRA.S   .lab_02D8

.lab_02D9:
    TST.W   36(A3)
    BEQ.S   .lab_02DA

    MOVE.W  36(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     30.W
    MOVE.L  38(A3),-(A7)
    JSR     GROUP_AE_JMPTBL_SCRIPT_DeallocateBufferArray(PC)

    MOVE.W  36(A3),D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVE.L  D0,(A7)
    MOVE.L  38(A3),-(A7)
    PEA     876.W
    PEA     Global_STR_COI_C_4
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     24(A7),A7

.lab_02DA:
    CLR.W   36(A3)
    CLR.L   38(A3)

;------------------------------------------------------------------------------
; FUNC: COI_FreeSubEntryTableEntries_Return   (Routine at COI_FreeSubEntryTableEntries_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
COI_FreeSubEntryTableEntries_Return:
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: COI_CountEscape14BeforeNull   (CountEscape14BeforeNulluncertain)
; ARGS:
;   stack +4: bufPtr (A3)
;   stack +8: maxLen (D7)
; RET:
;   D0: count of $14 bytes before NUL/limit
; CLOBBERS:
;   D0/D4-D7/A3
; CALLS:
;   (none)
; READS:
;   A3 buffer bytes
; WRITES:
;   (none)
; DESC:
;   Scans a byte buffer until NUL or maxLen, counting $14 bytes and skipping the
;   following byte each time a $14 is seen.
; NOTES:
;   Stops when a 0 byte is encountered or when index reaches maxLen.
;------------------------------------------------------------------------------
COI_CountEscape14BeforeNull:
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.L  28(A7),D7
    MOVEQ   #0,D5
    MOVEQ   #0,D6
    MOVE.L  D6,D4

.scan_loop:
    TST.W   D5
    BNE.S   .done

    MOVE.L  D6,D0
    EXT.L   D0
    CMP.L   D7,D0
    BGE.S   .done

    MOVEQ   #0,D0
    MOVE.B  0(A3,D6.W),D0
    TST.W   D0
    BEQ.S   .found_null

    SUBI.W  #20,D0
    BEQ.S   .found_escape

    BRA.S   .advance

.found_null:
    MOVEQ   #1,D5
    BRA.S   .advance

.found_escape:
    ADDQ.W  #1,D4
    ADDQ.W  #1,D6

.advance:
    ADDQ.W  #1,D6
    BRA.S   .scan_loop

.done:
    MOVE.L  D4,D0
    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: COI_WriteOiDataFile   (WriteOiDataFileuncertain)
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
;   GROUP_AG_JMPTBL_MATH_DivS32, GROUP_AE_JMPTBL_WDISP_SPrintf, DISKIO_OpenFileWithBuffer,
;   DISKIO_WriteBufferedBytes, ESQ_WildcardMatch, DISKIO_CloseBufferedFileAndFlush
; READS:
;   TEXTDISP_SecondaryGroupCode/TEXTDISP_SecondaryGroupPresentFlag/TEXTDISP_SecondaryGroupEntryCount/TEXTDISP_PrimaryGroupCode/TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryEntryPtrTable/TEXTDISP_SecondaryEntryPtrTable
; WRITES:
;   DATA_CTASKS_BSS_BYTE_1B8F/DATA_CTASKS_BSS_BYTE_1B90/DATA_CTASKS_BSS_BYTE_1B91/DATA_CTASKS_BSS_BYTE_1B92 (flags), output file contents
; DESC:
;   Writes `df0:OI_%02lx.dat` for the selected diskId, emitting a tab-delimited
;   header plus per-entry and per-subentry records with CR/LF separators.
; NOTES:
;   Uses wildcard name matching to skip duplicate entries, and writes $1A as an
;   EOF marker at the end of the file.
;------------------------------------------------------------------------------
COI_WriteOiDataFile:
    LINK.W  A5,#-152
    MOVEM.L D5-D7/A2-A3/A6,-(A7)
    MOVE.B  11(A5),D7
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    CMPI.W  #$c8,D0
    BLS.S   .check_primary_header

    MOVEQ   #1,D0
    BRA.W   .return_status

.check_primary_header:
    MOVE.B  TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D7,D0
    BNE.S   .check_secondary_header

    MOVE.B  TEXTDISP_SecondaryGroupPresentFlag,D0
    SUBQ.B  #1,D0
    BNE.S   .check_secondary_header

    MOVEQ   #1,D0
    MOVE.B  D0,DATA_CTASKS_BSS_BYTE_1B90
    MOVE.B  D7,DATA_CTASKS_BSS_BYTE_1B92
    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D1
    MOVE.W  D1,-32(A5)
    BRA.S   .format_filename

.check_secondary_header:
    MOVE.B  TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D7,D0
    BNE.S   .invalid_disk_id

    MOVE.B  #$1,DATA_CTASKS_BSS_BYTE_1B8F
    MOVE.B  D7,DATA_CTASKS_BSS_BYTE_1B91
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.W  D0,-32(A5)
    BRA.S   .format_filename

.invalid_disk_id:
    MOVEQ   #1,D0
    BRA.W   .return_status

.format_filename:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #2,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.W  D1,-30(A5)
    EXT.L   D1
    MOVE.L  D1,-(A7)
    PEA     Global_STR_DF0_OI_PERCENT_2_LX_DAT_1
    PEA     -112(A5)
    JSR     GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    PEA     MODE_NEWFILE.W
    PEA     -112(A5)
    JSR     DISKIO_OpenFileWithBuffer(PC)

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
    PEA     COI_FMT_LONG_DEC_A
    PEA     -152(A5)
    JSR     GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

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
    JSR     DISKIO_WriteBufferedBytes(PC)

    PEA     1.W
    PEA     COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     DISKIO_WriteBufferedBytes(PC)

    PEA     2.W
    PEA     COI_FMT_DEC_A
    PEA     -152(A5)
    JSR     GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

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
    JSR     DISKIO_WriteBufferedBytes(PC)

    PEA     2.W
    PEA     DATA_CLOCK_CONST_BYTE_1B60
    MOVE.L  D5,-(A7)
    JSR     DISKIO_WriteBufferedBytes(PC)

    LEA     64(A7),A7
    CLR.W   -26(A5)

.entry_loop:
    MOVE.W  -26(A5),D0
    CMP.W   -32(A5),D0
    BGE.W   .write_eof

    MOVE.B  TEXTDISP_SecondaryGroupCode,D1
    CMP.B   D1,D7
    BNE.S   .select_default_table

    MOVE.B  TEXTDISP_SecondaryGroupPresentFlag,D1
    SUBQ.B  #1,D1
    BNE.S   .select_default_table

    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A3
    BRA.S   .entry_selected

.select_default_table:
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
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

    MOVE.B  TEXTDISP_SecondaryGroupCode,D1
    CMP.B   D1,D7
    BNE.S   .select_compare_table

    MOVE.B  TEXTDISP_SecondaryGroupPresentFlag,D1
    SUBQ.B  #1,D1
    BNE.S   .select_compare_table

    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    BRA.S   .compare_entry_names

.select_compare_table:
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1

.compare_entry_names:
    LEA     12(A3),A0
    LEA     12(A1),A6
    MOVE.L  A6,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-16(A5)
    JSR     ESQ_WildcardMatch(PC)

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
    JSR     DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_field24:
    PEA     1.W
    PEA     COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     DISKIO_WriteBufferedBytes(PC)

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
    JSR     DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_field28:
    PEA     1.W
    PEA     COI_STR_COLON_A
    MOVE.L  D5,-(A7)
    JSR     DISKIO_WriteBufferedBytes(PC)

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
    JSR     DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_field32:
    PEA     1.W
    PEA     COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     DISKIO_WriteBufferedBytes(PC)

    MOVE.L  32(A2),(A7)
    PEA     COI_FMT_LONG_DEC_B
    PEA     -152(A5)
    JSR     GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

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
    JSR     DISKIO_WriteBufferedBytes(PC)

    PEA     1.W
    PEA     COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     DISKIO_WriteBufferedBytes(PC)

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
    JSR     DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_field0:
    PEA     1.W
    PEA     COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     DISKIO_WriteBufferedBytes(PC)

    MOVEA.L A2,A0

.measure_field0:
    TST.B   (A0)+
    BNE.S   .measure_field0

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  D5,-(A7)
    JSR     DISKIO_WriteBufferedBytes(PC)

    PEA     1.W
    PEA     COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     DISKIO_WriteBufferedBytes(PC)

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
    JSR     DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_field16:
    PEA     1.W
    PEA     COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     DISKIO_WriteBufferedBytes(PC)

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
    JSR     DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_field20:
    PEA     1.W
    PEA     COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     DISKIO_WriteBufferedBytes(PC)

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
    JSR     DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_field8:
    PEA     1.W
    PEA     COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     DISKIO_WriteBufferedBytes(PC)

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
    JSR     DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_entry_count:
    PEA     1.W
    PEA     COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     DISKIO_WriteBufferedBytes(PC)

    MOVE.W  36(A2),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     COI_FMT_LONG_DEC_C
    PEA     -152(A5)
    JSR     GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

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
    JSR     DISKIO_WriteBufferedBytes(PC)

    PEA     2.W
    PEA     DATA_CLOCK_CONST_BYTE_1B60
    MOVE.L  D5,-(A7)
    JSR     DISKIO_WriteBufferedBytes(PC)

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
    PEA     COI_FMT_LONG_DEC_PAD2
    PEA     -152(A5)
    JSR     GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

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
    JSR     DISKIO_WriteBufferedBytes(PC)

    PEA     1.W
    PEA     COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     DISKIO_WriteBufferedBytes(PC)

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
    JSR     DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_subentry_field22:
    PEA     1.W
    PEA     COI_STR_COLON_B
    MOVE.L  D5,-(A7)
    JSR     DISKIO_WriteBufferedBytes(PC)

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
    JSR     DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_subentry_field26:
    PEA     1.W
    PEA     COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     DISKIO_WriteBufferedBytes(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  26(A0),(A7)
    PEA     COI_FMT_DEC_B
    PEA     -152(A5)
    JSR     GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

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
    JSR     DISKIO_WriteBufferedBytes(PC)

    PEA     1.W
    PEA     COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     DISKIO_WriteBufferedBytes(PC)

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
    JSR     DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_subentry_field10:
    PEA     1.W
    PEA     COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     DISKIO_WriteBufferedBytes(PC)

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
    JSR     DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_subentry_field14:
    PEA     1.W
    PEA     COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     DISKIO_WriteBufferedBytes(PC)

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
    JSR     DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.write_subentry_field2:
    PEA     1.W
    PEA     COI_FieldDelimiterTab
    MOVE.L  D5,-(A7)
    JSR     DISKIO_WriteBufferedBytes(PC)

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
    JSR     DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7

.next_subentry:
    PEA     2.W
    PEA     DATA_CLOCK_CONST_BYTE_1B60
    MOVE.L  D5,-(A7)
    JSR     DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7
    ADDQ.W  #1,-28(A5)
    BRA.W   .subentry_loop

.next_entry_group:
    ADDQ.W  #1,-26(A5)
    BRA.W   .entry_loop

.write_eof:
    PEA     1.W
    PEA     DATA_CLOCK_CONST_BYTE_1B5E
    MOVE.L  D5,-(A7)
    JSR     DISKIO_WriteBufferedBytes(PC)

    MOVE.L  D5,(A7)
    JSR     DISKIO_CloseBufferedFileAndFlush(PC)

    MOVEQ   #0,D0

.return_status:
    MOVEM.L -176(A5),D5-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: COI_AllocSubEntryTable   (AllocSubEntryTableuncertain)
; ARGS:
;   stack +8: entryPtr (A3)
; RET:
;   D0: subentry table pointer (or 0 if none/failed)
; CLOBBERS:
;   D0-D1/A0-A3
; CALLS:
;   GROUP_AG_JMPTBL_MEMORY_AllocateMemory, GROUP_AE_JMPTBL_SCRIPT_AllocateBufferArray
; READS:
;   Global_STR_COI_C_5, MEMF_CLEAR, MEMF_PUBLIC
; WRITES:
;   A0+38 (subentry table pointer)
; DESC:
;   Allocates and initializes a cleared longword table for subentries when the
;   entry's count field is positive.
; NOTES:
;   Table size is `count * 4` bytes; GROUP_AE_JMPTBL_SCRIPT_AllocateBufferArray initializes the table entries.
;------------------------------------------------------------------------------
COI_AllocSubEntryTable:
    LINK.W  A5,#-4
    MOVE.L  A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.L  A3,D0
    BEQ.S   .null_parent

    MOVEA.L 48(A3),A0
    BRA.S   .have_anim_ptr

.null_parent:
    SUBA.L  A0,A0

.have_anim_ptr:
    MOVE.L  A0,-4(A5)
    MOVE.L  A0,D0
    BEQ.S   .return_status

    MOVE.W  36(A0),D0
    TST.W   D0
    BLE.S   .return_status

    EXT.L   D0
    ASL.L   #2,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     1123.W
    PEA     Global_STR_COI_C_5
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVEA.L -4(A5),A0
    MOVE.L  D0,38(A0)
    MOVE.W  36(A0),D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    PEA     30.W
    MOVE.L  D0,-(A7)
    JSR     GROUP_AE_JMPTBL_SCRIPT_AllocateBufferArray(PC)

    LEA     24(A7),A7

.return_status:
    MOVEA.L (A7)+,A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: COI_LoadOiDataFile   (LoadOiDataFileuncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +7: arg_2 (via 11(A5))
;   stack +8: arg_3 (via 12(A5))
;   stack +12: arg_4 (via 16(A5))
;   stack +16: arg_5 (via 20(A5))
;   stack +20: arg_6 (via 24(A5))
;   stack +322: arg_7 (via 326(A5))
;   stack +328: arg_8 (via 332(A5))
;   stack +330: arg_9 (via 334(A5))
;   stack +332: arg_10 (via 336(A5))
;   stack +482: arg_11 (via 486(A5))
;   stack +562: arg_12 (via 566(A5))
;   stack +566: arg_13 (via 570(A5))
;   stack +570: arg_14 (via 574(A5))
;   stack +574: arg_15 (via 578(A5))
;   stack +578: arg_16 (via 582(A5))
;   stack +580: arg_17 (via 584(A5))
;   stack +584: arg_18 (via 588(A5))
;   stack +586: arg_19 (via 590(A5))
;   stack +588: arg_20 (via 592(A5))
;   stack +590: arg_21 (via 594(A5))
;   stack +592: arg_22 (via 596(A5))
;   stack +594: arg_23 (via 598(A5))
;   stack +596: arg_24 (via 600(A5))
;   stack +598: arg_25 (via 602(A5))
;   stack +600: arg_26 (via 604(A5))
;   stack +601: arg_27 (via 605(A5))
;   stack +602: arg_28 (via 606(A5))
;   stack +603: arg_29 (via 607(A5))
;   stack +604: arg_30 (via 608(A5))
;   stack +605: arg_31 (via 609(A5))
;   stack +606: arg_32 (via 610(A5))
;   stack +607: arg_33 (via 611(A5))
;   stack +608: arg_34 (via 612(A5))
;   stack +609: arg_35 (via 613(A5))
;   stack +610: arg_36 (via 614(A5))
;   stack +611: arg_37 (via 615(A5))
;   stack +614: arg_38 (via 618(A5))
;   stack +618: arg_39 (via 622(A5))
;   stack +620: arg_40 (via 624(A5))
;   stack +622: arg_41 (via 626(A5))
;   stack +624: arg_42 (via 628(A5))
;   stack +626: arg_43 (via 630(A5))
;   stack +628: arg_44 (via 632(A5))
;   stack +629: arg_45 (via 633(A5))
;   stack +630: arg_46 (via 634(A5))
;   stack +631: arg_47 (via 635(A5))
;   stack +632: arg_48 (via 636(A5))
;   stack +633: arg_49 (via 637(A5))
;   stack +634: arg_50 (via 638(A5))
;   stack +635: arg_51 (via 639(A5))
;   stack +636: arg_52 (via 640(A5))
;   stack +640: arg_53 (via 644(A5))
;   stack +644: arg_54 (via 648(A5))
;   stack +672: arg_55 (via 676(A5))
; RET:
;   D0: 0 on success, -1 on failure
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   GROUP_AG_JMPTBL_MATH_DivS32, GROUP_AE_JMPTBL_WDISP_SPrintf, DISKIO_LoadFileToWorkBuffer, GROUP_AI_JMPTBL_UNKNOWN7_FindCharWrapper, GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt,
;   GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap, GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString, CLEANUP_FormatEntryStringTokens, ESQ_WildcardMatch, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory,
;   COI_AllocSubEntryTable
; READS:
;   TEXTDISP_SecondaryGroupCode/TEXTDISP_SecondaryGroupPresentFlag/TEXTDISP_SecondaryGroupEntryCount/TEXTDISP_PrimaryGroupCode/TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryEntryPtrTable/TEXTDISP_SecondaryEntryPtrTable,
;   Global_PTR_WORK_BUFFER, Global_REF_LONG_FILE_SCRATCH
; WRITES:
;   Global_PTR_WORK_BUFFER, Global_REF_LONG_FILE_SCRATCH, structures referenced by TEXTDISP_PrimaryEntryPtrTable/
;   TEXTDISP_SecondaryEntryPtrTable (fields +0..+36), local scratch buffers/flags
; DESC:
;   Builds `df0:OI_%02lx.dat` from diskId parity, loads the file into memory,
;   validates header fields, then parses CR/LF-delimited records to populate
;   object info structures and sub-entries using wildcard name matches.
; NOTES:
;   - File variant is inferred from a header field (format 2 vs default).
;   - Replaces CR/LF bytes in the loaded buffer with NUL terminators.
;   - Uses tab separators and parses numeric fields via GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt.
;   - DBF loops run (Dn+1) iterations when clearing scratch buffers.
;------------------------------------------------------------------------------
COI_LoadOiDataFile:
    LINK.W  A5,#-648
    MOVEM.L D2-D3/D5-D7/A2-A3,-(A7)
    MOVE.B  11(A5),D7
    MOVEQ   #0,D0
    MOVEQ   #9,D1
    MOVE.B  D1,-615(A5)
    MOVE.B  D1,-614(A5)
    MOVE.B  D1,-613(A5)
    MOVE.B  D1,-612(A5)
    MOVE.B  D1,-611(A5)
    MOVE.B  D1,-610(A5)
    MOVE.B  D1,-609(A5)
    MOVE.B  D1,-608(A5)
    MOVE.B  D1,-607(A5)
    MOVEQ   #13,D2
    MOVE.B  D2,-606(A5)
    MOVEQ   #10,D3
    MOVE.B  D3,-605(A5)
    MOVE.B  D1,-640(A5)
    MOVE.B  D1,-639(A5)
    MOVE.B  D1,-638(A5)
    MOVE.B  D1,-637(A5)
    MOVE.B  D1,-636(A5)
    MOVE.B  D1,-635(A5)
    MOVE.B  D2,-634(A5)
    MOVE.B  D3,-633(A5)
    MOVEQ   #0,D1
    MOVE.B  D7,D1
    MOVE.L  D0,-582(A5)
    MOVE.L  D0,-578(A5)
    MOVE.L  D1,D0
    MOVEQ   #2,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.W  D1,-334(A5)
    EXT.L   D1
    MOVE.L  D1,-(A7)
    PEA     Global_STR_DF0_OI_PERCENT_2_LX_DAT_2
    PEA     -566(A5)
    JSR     GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    PEA     -566(A5)
    JSR     DISKIO_LoadFileToWorkBuffer(PC)

    LEA     16(A7),A7
    ADDQ.L  #1,D0
    BNE.S   .file_loaded

    MOVEQ   #-1,D0
    BRA.W   .return_status

.file_loaded:
    MOVE.L  Global_REF_LONG_FILE_SCRATCH,D0
    MOVEA.L Global_PTR_WORK_BUFFER,A0
    MOVE.B  TEXTDISP_SecondaryGroupCode,D1
    MOVE.L  D0,-574(A5)
    MOVE.L  A0,-570(A5)
    CMP.B   D7,D1
    BNE.S   .check_alt_header

    MOVE.B  TEXTDISP_SecondaryGroupPresentFlag,D0
    SUBQ.B  #1,D0
    BNE.S   .check_alt_header

    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    MOVE.W  D0,-336(A5)
    BRA.S   .init_parse_state

.check_alt_header:
    MOVE.B  TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   .invalid_header

    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.W  D0,-336(A5)
    BRA.S   .init_parse_state

.invalid_header:
    MOVE.L  -574(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    PEA     1198.W
    PEA     Global_STR_COI_C_6
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #-1,D0
    BRA.W   .return_status

.init_parse_state:
    MOVEQ   #0,D0
    MOVE.L  D0,-578(A5)
    MOVE.L  D0,-582(A5)

.copy_header_line:
    MOVEA.L Global_PTR_WORK_BUFFER,A0
    ADDA.L  -578(A5),A0
    ADDA.L  -582(A5),A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    PEA     COI_STR_LINEFEED_CR_1
    JSR     GROUP_AI_JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .finish_header_line

    LEA     -486(A5),A0
    MOVE.L  -582(A5),D0
    ADDA.L  D0,A0
    MOVEA.L Global_PTR_WORK_BUFFER,A1
    ADDA.L  -578(A5),A1
    ADDA.L  D0,A1
    MOVE.B  (A1),(A0)
    ADDQ.L  #1,-582(A5)
    BRA.S   .copy_header_line

.finish_header_line:
    LEA     -486(A5),A0
    MOVEA.L A0,A1
    ADDA.L  -582(A5),A1
    CLR.B   (A1)
    PEA     9.W
    MOVE.L  A0,-(A7)
    JSR     GROUP_AI_JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-648(A5)
    TST.L   D0
    BEQ.S   .no_header_tab

    MOVEA.L D0,A0
    CLR.B   (A0)+
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-648(A5)
    JSR     GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-644(A5)
    BRA.S   .validate_disk_id

.no_header_tab:
    CLR.L   -644(A5)

.validate_disk_id:
    PEA     -486(A5)
    JSR     GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D7,D1
    CMP.L   D0,D1
    BEQ.S   .strip_line_terminators

    MOVEQ   #-1,D0
    BRA.W   .return_status

.strip_line_terminators:
    MOVEA.L Global_PTR_WORK_BUFFER,A0
    ADDA.L  -578(A5),A0
    ADDA.L  -582(A5),A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    PEA     COI_STR_LINEFEED_CR_2
    JSR     GROUP_AI_JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .clear_seen_flags

    MOVEA.L Global_PTR_WORK_BUFFER,A0
    ADDA.L  -578(A5),A0
    MOVE.L  -582(A5),D0
    ADDA.L  D0,A0
    CLR.B   (A0)
    ADDQ.L  #1,-582(A5)
    BRA.S   .strip_line_terminators

.clear_seen_flags:
    MOVE.W  #$12d,D0
    MOVEQ   #0,D1
    LEA     -326(A5),A0

.zero_seen_flags:
    MOVE.B  D1,(A0)+
    DBF     D0,.zero_seen_flags
    MOVEQ   #0,D6

.record_loop:
    CMP.W   -336(A5),D6
    BGE.W   .cleanup_and_return

    MOVE.L  -582(A5),D0
    ADD.L   D0,-578(A5)
    MOVEQ   #2,D0
    CMP.L   -644(A5),D0
    BNE.S   .parse_record_legacy

    MOVEA.L Global_PTR_WORK_BUFFER,A0
    ADDA.L  -578(A5),A0
    MOVE.L  -574(A5),D0
    EXT.L   D0
    PEA     1.W
    PEA     26.W
    MOVE.L  D0,-(A7)
    PEA     -615(A5)
    PEA     11.W
    PEA     -604(A5)
    MOVE.L  A0,-(A7)
    JSR     GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(PC)

    LEA     28(A7),A7
    BRA.S   .init_entry_loop

.parse_record_legacy:
    MOVEQ   #21,D0
    MOVEQ   #0,D1
    LEA     -604(A5),A0

.clear_record_fields:
    MOVE.B  D1,(A0)+
    DBF     D0,.clear_record_fields
    MOVEA.L Global_PTR_WORK_BUFFER,A0
    ADDA.L  -578(A5),A0
    MOVE.L  -574(A5),D0
    EXT.L   D0
    PEA     1.W
    PEA     26.W
    MOVE.L  D0,-(A7)
    PEA     -613(A5)
    PEA     11.W
    PEA     -600(A5)
    MOVE.L  A0,-(A7)
    JSR     GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(PC)

    LEA     28(A7),A7

.init_entry_loop:
    MOVE.W  -584(A5),D0
    EXT.L   D0
    MOVEQ   #0,D5
    MOVE.L  D0,-582(A5)

.entry_loop:
    CMP.W   -336(A5),D5
    BGE.W   .advance_entry

    MOVE.B  TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   .select_default_table

    MOVE.B  TEXTDISP_SecondaryGroupPresentFlag,D0
    SUBQ.B  #1,D0
    BNE.S   .select_default_table

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    BRA.S   .match_entry_pattern

.select_default_table:
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1

.match_entry_pattern:
    LEA     12(A1),A0
    MOVEA.L Global_PTR_WORK_BUFFER,A2
    ADDA.L  -578(A5),A2
    MOVE.L  A2,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-4(A5)
    JSR     ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.W   .next_entry

    LEA     -326(A5),A0
    ADDA.W  D5,A0
    TST.B   (A0)
    BNE.W   .alloc_subentries

    MOVEA.L -4(A5),A0
    MOVE.L  48(A0),-8(A5)
    MOVEA.L Global_PTR_WORK_BUFFER,A0
    ADDA.L  -578(A5),A0
    ADDA.W  -600(A5),A0
    MOVEA.L -8(A5),A1
    MOVE.L  4(A1),-(A7)
    MOVE.L  A0,-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -8(A5),A0
    MOVE.L  D0,4(A0)
    MOVEA.L Global_PTR_WORK_BUFFER,A1
    ADDA.L  -578(A5),A1
    MOVEA.W -598(A5),A2
    MOVE.L  A2,D0
    MOVE.B  0(A1,D0.W),(A0)
    MOVE.B  1(A1,D0.W),1(A0)
    MOVE.B  2(A1,D0.W),2(A0)
    CLR.B   3(A0)
    ADDA.W  -596(A5),A1
    MOVE.L  12(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -8(A5),A0
    MOVE.L  D0,12(A0)
    MOVEA.L Global_PTR_WORK_BUFFER,A1
    ADDA.L  -578(A5),A1
    ADDA.W  -594(A5),A1
    MOVE.L  16(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -8(A5),A0
    MOVE.L  D0,16(A0)
    MOVEA.L Global_PTR_WORK_BUFFER,A1
    ADDA.L  -578(A5),A1
    ADDA.W  -592(A5),A1
    MOVE.L  20(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -8(A5),A0
    MOVE.L  D0,20(A0)
    MOVEA.L Global_PTR_WORK_BUFFER,A1
    ADDA.L  -578(A5),A1
    ADDA.W  -590(A5),A1
    MOVE.L  8(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     24(A7),A7
    MOVEA.L -8(A5),A0
    MOVE.L  D0,8(A0)
    MOVE.W  -604(A5),D0
    BLE.S   .default_field24

    MOVE.L  -578(A5),D1
    MOVEA.L Global_PTR_WORK_BUFFER,A1
    MOVEA.L A1,A2
    ADDA.L  D1,A2
    ADDA.W  D0,A2
    MOVE.L  A2,D2
    BEQ.S   .default_field24

    LEA     24(A0),A2
    LEA     28(A0),A3
    ADDA.L  D1,A1
    ADDA.W  D0,A1
    MOVE.L  A1,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A2,-(A7)
    BSR.W   CLEANUP_FormatEntryStringTokens

    LEA     12(A7),A7
    BRA.S   .after_field24

.default_field24:
    MOVE.L  24(A0),-(A7)
    CLR.L   -(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -8(A5),A0
    MOVE.L  D0,24(A0)
    MOVE.L  28(A0),(A7)
    PEA     COI_STR_DEFAULT_TOKEN_TEMPLATE_A
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     12(A7),A7
    MOVEA.L -8(A5),A0
    MOVE.L  D0,28(A0)

.after_field24:
    MOVE.W  -602(A5),D0
    BEQ.S   .missing_field32

    MOVE.L  -578(A5),D1
    MOVEA.L Global_PTR_WORK_BUFFER,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    ADDA.W  D0,A1
    MOVE.L  A1,D2
    BEQ.S   .missing_field32

    ADDA.L  D1,A0
    ADDA.W  D0,A0
    MOVE.L  A0,-(A7)
    JSR     GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVEA.L -8(A5),A0
    MOVE.L  D0,32(A0)
    BRA.S   .store_field36

.missing_field32:
    MOVEQ   #-1,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D0,32(A0)

.store_field36:
    MOVEA.L Global_PTR_WORK_BUFFER,A0
    ADDA.L  -578(A5),A0
    ADDA.W  -588(A5),A0
    MOVE.L  A0,-(A7)
    PEA     Global_STR_PERCENT_S_1
    PEA     -486(A5)
    JSR     GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    PEA     -486(A5)
    JSR     GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    LEA     16(A7),A7
    MOVEA.L -8(A5),A0
    MOVE.W  D0,36(A0)

.alloc_subentries:
    MOVE.L  -4(A5),-(A7)
    BSR.W   COI_AllocSubEntryTable

    ADDQ.W  #4,A7
    CLR.W   -332(A5)

.subentry_loop:
    MOVE.W  -332(A5),D0
    MOVEA.L -8(A5),A0
    CMP.W   36(A0),D0
    BGE.W   .mark_entry_seen

    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEA.L -8(A5),A1
    MOVEA.L 38(A1),A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-12(A5)
    MOVE.L  -582(A5),D0
    ADD.L   D0,-578(A5)
    MOVEQ   #2,D0
    CMP.L   -644(A5),D0
    BNE.S   .parse_subentry_legacy

    MOVEA.L Global_PTR_WORK_BUFFER,A0
    ADDA.L  -578(A5),A0
    MOVE.L  -574(A5),D0
    EXT.L   D0
    PEA     1.W
    PEA     26.W
    MOVE.L  D0,-(A7)
    PEA     -640(A5)
    PEA     8.W
    PEA     -632(A5)
    MOVE.L  A0,-(A7)
    JSR     GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(PC)

    LEA     28(A7),A7
    BRA.S   .process_subentry

.parse_subentry_legacy:
    MOVEQ   #15,D0
    MOVEQ   #0,D1
    LEA     -632(A5),A0

.clear_subentry_fields:
    MOVE.B  D1,(A0)+
    DBF     D0,.clear_subentry_fields
    MOVEA.L Global_PTR_WORK_BUFFER,A0
    ADDA.L  -578(A5),A0
    MOVE.L  -574(A5),D0
    EXT.L   D0
    PEA     1.W
    PEA     26.W
    MOVE.L  D0,-(A7)
    PEA     -638(A5)
    PEA     6.W
    PEA     -628(A5)
    MOVE.L  A0,-(A7)
    JSR     GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(PC)

    LEA     28(A7),A7

.process_subentry:
    LEA     -326(A5),A0
    ADDA.W  D5,A0
    TST.B   (A0)
    BNE.W   .advance_subentry

    MOVEA.L Global_PTR_WORK_BUFFER,A0
    ADDA.L  -578(A5),A0
    MOVE.L  A0,-(A7)
    JSR     GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    MOVEA.L -12(A5),A0
    MOVE.W  D0,(A0)
    MOVEA.L Global_PTR_WORK_BUFFER,A1
    ADDA.L  -578(A5),A1
    ADDA.W  -628(A5),A1
    MOVE.L  6(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,6(A0)
    MOVEA.L Global_PTR_WORK_BUFFER,A1
    ADDA.L  -578(A5),A1
    ADDA.W  -626(A5),A1
    MOVE.L  10(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,10(A0)
    MOVEA.L Global_PTR_WORK_BUFFER,A1
    ADDA.L  -578(A5),A1
    ADDA.W  -624(A5),A1
    MOVE.L  14(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,14(A0)
    MOVEA.L Global_PTR_WORK_BUFFER,A1
    ADDA.L  -578(A5),A1
    ADDA.W  -622(A5),A1
    MOVE.L  2(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     20(A7),A7
    MOVEA.L -12(A5),A0
    MOVE.L  D0,2(A0)
    MOVE.W  -632(A5),D0
    BLE.S   .default_subentry_field18

    MOVE.L  -578(A5),D1
    MOVEA.L Global_PTR_WORK_BUFFER,A1
    MOVEA.L A1,A2
    ADDA.L  D1,A2
    ADDA.W  D0,A2
    MOVE.L  A2,D2
    BEQ.S   .default_subentry_field18

    LEA     18(A0),A2
    LEA     22(A0),A3
    ADDA.L  D1,A1
    ADDA.W  D0,A1
    MOVE.L  A1,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A2,-(A7)
    BSR.W   CLEANUP_FormatEntryStringTokens

    LEA     12(A7),A7
    BRA.S   .after_subentry_field18

.default_subentry_field18:
    MOVE.L  18(A0),-(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  24(A0),-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,18(A0)
    MOVE.L  22(A0),(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  28(A0),-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     12(A7),A7
    MOVEA.L -12(A5),A0
    MOVE.L  D0,22(A0)

.after_subentry_field18:
    MOVE.W  -630(A5),D0
    BLE.S   .inherit_subentry_field26

    MOVE.L  -578(A5),D1
    MOVEA.L Global_PTR_WORK_BUFFER,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    ADDA.W  D0,A1
    MOVE.L  A1,D2
    BEQ.S   .inherit_subentry_field26

    ADDA.L  D1,A0
    ADDA.W  D0,A0
    MOVE.L  A0,-(A7)
    JSR     GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVEA.L -12(A5),A0
    MOVE.L  D0,26(A0)
    BRA.S   .advance_subentry

.inherit_subentry_field26:
    MOVEA.L -8(A5),A0
    MOVEA.L -12(A5),A1
    MOVE.L  32(A0),26(A1)

.advance_subentry:
    MOVE.W  -618(A5),D0
    EXT.L   D0
    MOVE.L  D0,-582(A5)
    ADDQ.W  #1,-332(A5)
    BRA.W   .subentry_loop

.mark_entry_seen:
    LEA     -326(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D5,A1
    TST.B   (A1)
    BNE.S   .advance_entry

    ADDA.W  D5,A0
    MOVE.B  #$1,(A0)
    BRA.S   .advance_entry

.next_entry:
    ADDQ.W  #1,D5
    BRA.W   .entry_loop

.advance_entry:
    ADDQ.W  #1,D5

.second_pass_loop:
    CMP.W   -336(A5),D5
    BGE.W   .next_record

    MOVE.B  TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   .select_table_second_pass

    MOVE.B  TEXTDISP_SecondaryGroupPresentFlag,D0
    SUBQ.B  #1,D0
    BNE.S   .select_table_second_pass

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    BRA.S   .match_entry_second_pass

.select_table_second_pass:
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1

.match_entry_second_pass:
    MOVEA.L -4(A5),A0
    ADDA.W  #12,A0
    LEA     12(A1),A2
    MOVE.L  A2,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-16(A5)
    JSR     ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.W   .next_second_pass_entry

    LEA     -326(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D5,A1
    TST.B   (A1)
    BNE.W   .next_second_pass_entry

    ADDA.W  D5,A0
    MOVE.B  #$1,(A0)
    MOVEA.L -16(A5),A0
    MOVE.L  48(A0),-20(A5)
    MOVEA.L -20(A5),A0
    MOVE.L  4(A0),-(A7)
    MOVEA.L -8(A5),A1
    MOVE.L  4(A1),-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -20(A5),A0
    MOVE.L  D0,4(A0)
    MOVEA.L -8(A5),A0
    MOVEA.L -20(A5),A1
    MOVE.B  (A0),(A1)
    MOVE.B  1(A0),1(A1)
    MOVE.B  2(A0),2(A1)
    MOVE.B  3(A0),3(A1)
    MOVE.L  12(A1),(A7)
    MOVE.L  12(A0),-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -20(A5),A0
    MOVE.L  D0,12(A0)
    MOVE.L  16(A0),(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  16(A0),-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -20(A5),A0
    MOVE.L  D0,16(A0)
    MOVE.L  20(A0),(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  20(A0),-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -20(A5),A0
    MOVE.L  D0,20(A0)
    MOVE.L  8(A0),(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  8(A0),-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -20(A5),A0
    MOVE.L  D0,8(A0)
    MOVE.L  24(A0),(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  24(A0),-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -20(A5),A0
    MOVE.L  D0,24(A0)
    MOVE.L  28(A0),(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  28(A0),-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -20(A5),A0
    MOVE.L  D0,28(A0)
    MOVEA.L -8(A5),A0
    MOVEA.L -20(A5),A1
    MOVE.L  32(A0),32(A1)
    MOVE.W  36(A0),36(A1)
    MOVE.L  -16(A5),(A7)
    BSR.W   COI_AllocSubEntryTable

    LEA     32(A7),A7
    CLR.W   -332(A5)

.copy_subentries:
    MOVE.W  -332(A5),D0
    MOVEA.L -20(A5),A0
    CMP.W   36(A0),D0
    BGE.W   .next_second_pass_entry

    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEA.L -20(A5),A1
    MOVEA.L 38(A1),A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-24(A5)
    MOVEA.L -8(A5),A1
    MOVEA.L 38(A1),A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-12(A5)
    MOVEA.L -12(A5),A0
    MOVEA.L -24(A5),A1
    MOVE.W  (A0),(A1)
    MOVE.L  6(A1),-(A7)
    MOVE.L  6(A0),-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,6(A0)
    MOVE.L  10(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  10(A0),-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,10(A0)
    MOVE.L  14(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  14(A0),-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,14(A0)
    MOVE.L  2(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  2(A0),-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,2(A0)
    MOVE.L  18(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  18(A0),-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,18(A0)
    MOVE.L  22(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  22(A0),-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     28(A7),A7
    MOVEA.L -24(A5),A0
    MOVE.L  D0,22(A0)
    MOVEA.L -12(A5),A0
    MOVEA.L -24(A5),A1
    MOVE.L  26(A0),26(A1)
    ADDQ.W  #1,-332(A5)
    BRA.W   .copy_subentries

.next_second_pass_entry:
    ADDQ.W  #1,D5
    BRA.W   .second_pass_loop

.next_record:
    ADDQ.W  #1,D6
    BRA.W   .record_loop

.cleanup_and_return:
    MOVE.L  -574(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -570(A5),-(A7)
    PEA     1443.W
    PEA     Global_STR_COI_C_1
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #0,D0

.return_status:
    MOVEM.L -676(A5),D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: COI_EnsureAnimObjectAllocated   (Routine at COI_EnsureAnimObjectAllocated)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A5/A7/D0
; CALLS:
;   GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString, GROUP_AG_JMPTBL_MEMORY_AllocateMemory
; READS:
;   Global_STR_COI_C_2, COI_STR_DEFAULT_TOKEN_TEMPLATE_B, MEMF_CLEAR, MEMF_PUBLIC, Struct_AnimOb_Size
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
COI_EnsureAnimObjectAllocated:
    LINK.W  A5,#-8
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  A3,D0
    BEQ.S   .return

    MOVEA.L 48(A3),A0
    MOVE.L  A0,-4(A5)
    BNE.S   .return

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     Struct_AnimOb_Size.W
    PEA     1458.W
    PEA     Global_STR_COI_C_2
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVE.L  D0,48(A3)
    MOVEA.L D0,A0
    MOVE.L  28(A0),(A7)
    PEA     COI_STR_DEFAULT_TOKEN_TEMPLATE_B
    MOVE.L  D0,24(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     20(A7),A7
    MOVEA.L 4(A7),A0
    MOVE.L  D0,28(A0)
    MOVEA.L 48(A3),A0
    MOVEQ   #-1,D0
    MOVE.L  D0,32(A0)

.return:
    MOVEA.L (A7)+,A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: COI_SelectAnimFieldPointer   (Select animation field pointer by key/mode)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;------------------------------------------------------------------------------
COI_SelectAnimFieldPointer:
;------------------------------------------------------------------------------
; FUNC: COI_GetAnimFieldPointerByMode   (Routine at COI_GetAnimFieldPointerByMode)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +10: arg_3 (via 14(A5))
;   stack +12: arg_4 (via 16(A5))
;   stack +14: arg_5 (via 18(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A7/D0/D4/D5/D6/D7
; CALLS:
;   (none)
; READS:
;   COI_GetAnimFieldPointerByMode_Return, lab_034D, lab_034D_000E, lab_034D_0018, lab_034D_0026, lab_034D_0046, lab_034D_0064, lab_034D_0080, lab_034D_009C, lab_034D_00B8, lab_0355, lab_0356
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
COI_GetAnimFieldPointerByMode:
    LINK.W  A5,#-20
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.W  18(A5),D6
    SUBA.L  A0,A0
    MOVEQ   #0,D4
    MOVE.L  A0,-12(A5)
    MOVE.L  A3,D0
    BEQ.S   .lab_0348

    TST.L   48(A3)
    BNE.S   .lab_0349

.lab_0348:
    MOVE.L  A0,D0
    BRA.W   COI_GetAnimFieldPointerByMode_Return

.lab_0349:
    MOVE.L  48(A3),-4(A5)
    MOVEQ   #0,D5

.lab_034A:
    MOVEA.L -4(A5),A0
    CMP.W   36(A0),D5
    BGE.S   .lab_034C

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -4(A5),A1
    MOVEA.L 38(A1),A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-8(A5)
    MOVE.W  (A1),D0
    CMP.W   D7,D0
    BNE.S   .lab_034B

    MOVEQ   #1,D4
    MOVE.L  A1,-12(A5)
    BRA.S   .lab_034C

.lab_034B:
    ADDQ.W  #1,D5
    BRA.S   .lab_034A

.lab_034C:
    MOVE.L  D6,D0
    CMPI.W  #8,D0
    BCC.W   .lab_0355

    ADD.W   D0,D0
    MOVE.W  .lab_034D(PC,D0.W),D0
    JMP     .lab_034D+2(PC,D0.W)

; switch/jumptable
.lab_034D:
	DC.W    .lab_034D_0018-.lab_034D-2
    DC.W    .lab_034D_0026-.lab_034D-2
	DC.W    .lab_034D_0046-.lab_034D-2
    DC.W    .lab_034D_0064-.lab_034D-2
	DC.W    .lab_034D_0080-.lab_034D-2
    DC.W    .lab_034D_000E-.lab_034D-2
    DC.W    .lab_034D_009C-.lab_034D-2
	DC.W    .lab_034D_00B8-.lab_034D-2

.lab_034D_000E:
    MOVE.L  -4(A5),-16(A5)
    BRA.W   .lab_0356

.lab_034D_0018:
    MOVEA.L -4(A5),A0
    MOVE.L  4(A0),-16(A5)
    BRA.W   .lab_0356

.lab_034D_0026:
    TST.W   D4
    BEQ.S   .lab_034F

    MOVEA.L -12(A5),A0
    MOVE.L  2(A0),-16(A5)
    BRA.W   .lab_0356

.lab_034F:
    MOVEA.L -4(A5),A0
    MOVE.L  8(A0),-16(A5)
    BRA.W   .lab_0356

.lab_034D_0046:
    TST.W   D4
    BEQ.S   .lab_0350

    MOVEA.L -12(A5),A0
    MOVE.L  6(A0),-16(A5)
    BRA.W   .lab_0356

.lab_0350:
    MOVEA.L -4(A5),A0
    MOVE.L  12(A0),-16(A5)
    BRA.S   .lab_0356

.lab_034D_0064:
    TST.W   D4
    BEQ.S   .lab_0351

    MOVEA.L -12(A5),A0
    MOVE.L  10(A0),-16(A5)
    BRA.S   .lab_0356

.lab_0351:
    MOVEA.L -4(A5),A0
    MOVE.L  16(A0),-16(A5)
    BRA.S   .lab_0356

.lab_034D_0080:
    TST.W   D4
    BEQ.S   .lab_0352

    MOVEA.L -12(A5),A0
    MOVE.L  14(A0),-16(A5)
    BRA.S   .lab_0356

.lab_0352:
    MOVEA.L -4(A5),A0
    MOVE.L  20(A0),-16(A5)
    BRA.S   .lab_0356

.lab_034D_009C:
    TST.W   D4
    BEQ.S   .lab_0353

    MOVEA.L -12(A5),A0
    MOVE.L  18(A0),-16(A5)
    BRA.S   .lab_0356

.lab_0353:
    MOVEA.L -4(A5),A0
    MOVE.L  24(A0),-16(A5)
    BRA.S   .lab_0356

.lab_034D_00B8:
    TST.W   D4
    BEQ.S   .lab_0354

    MOVEA.L -12(A5),A0
    MOVE.L  22(A0),-16(A5)
    BRA.S   .lab_0356

.lab_0354:
    MOVEA.L -4(A5),A0
    MOVE.L  28(A0),-16(A5)
    BRA.S   .lab_0356

.lab_0355:
    CLR.L   -16(A5)

.lab_0356:
    MOVE.L  -16(A5),D0

;------------------------------------------------------------------------------
; FUNC: COI_GetAnimFieldPointerByMode_Return   (Routine at COI_GetAnimFieldPointerByMode_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D4
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
COI_GetAnimFieldPointerByMode_Return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: COI_RenderClockFormatEntryVariant   (Render clock-format entry variant)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;------------------------------------------------------------------------------
COI_RenderClockFormatEntryVariant:
;------------------------------------------------------------------------------
; FUNC: COI_FormatEntryDisplayText   (Routine at COI_FormatEntryDisplayText)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
;   stack +20: arg_5 (via 24(A5))
;   stack +24: arg_6 (via 28(A5))
;   stack +28: arg_7 (via 32(A5))
;   stack +32: arg_8 (via 36(A5))
;   stack +40: arg_9 (via 44(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A3/A5/A7/D0/D1/D2/D5/D6/D7
; CALLS:
;   CLEANUP_TestEntryFlagYAndBit1, CLEANUP_UpdateEntryFlagBytes, GROUP_AE_JMPTBL_WDISP_SPrintf, GROUP_AI_JMPTBL_STRING_AppendAtNull, COI_GetAnimFieldPointerByMode, COI_TestEntryWithinTimeWindow
; READS:
;   COI_FormatEntryDisplayText_Return, COI_FMT_WRAP_CHAR_STRING_CHAR, COI_STR_SINGLE_SPACE, CONFIG_TimeWindowMinutes, GCOMMAND_PpvSelectionWindowMinutes, GCOMMAND_PpvSelectionToleranceMinutes
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
COI_FormatEntryDisplayText:
    LINK.W  A5,#-44
    MOVEM.L D2/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7
    MOVE.L  24(A5),D6
    MOVEQ   #-1,D0
    CMP.L   D0,D6
    BNE.S   .lab_0359

    MOVE.L  GCOMMAND_PpvSelectionWindowMinutes,D1
    BRA.S   .lab_035A

.lab_0359:
    MOVE.L  #1440,D1

.lab_035A:
    MOVE.L  D1,-28(A5)
    CMP.L   D0,D6
    BNE.S   .lab_035B

    MOVE.L  GCOMMAND_PpvSelectionToleranceMinutes,D0
    BRA.S   .lab_035C

.lab_035B:
    MOVE.L  CONFIG_TimeWindowMinutes,D0

.lab_035C:
    MOVE.L  D7,D2
    EXT.L   D2
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-32(A5)
    BSR.W   COI_TestEntryWithinTimeWindow

    LEA     20(A7),A7
    TST.L   D0
    BEQ.W   COI_FormatEntryDisplayText_Return

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   COI_GetAnimFieldPointerByMode

    LEA     12(A7),A7
    MOVE.L  D0,-20(A5)
    MOVEQ   #-1,D0
    CMP.L   D0,D6
    BNE.S   .lab_035D

    SUBA.L  A0,A0
    MOVE.L  A0,-16(A5)
    MOVE.L  A0,-12(A5)
    MOVE.L  A0,-8(A5)
    MOVEQ   #3,D6
    BRA.S   .lab_035E

.lab_035D:
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     3.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   COI_GetAnimFieldPointerByMode

    MOVE.L  D0,-16(A5)
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     4.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   COI_GetAnimFieldPointerByMode

    MOVE.L  D0,-12(A5)
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   COI_GetAnimFieldPointerByMode

    LEA     36(A7),A7
    MOVE.L  D0,-8(A5)

.lab_035E:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   CLEANUP_TestEntryFlagYAndBit1

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .lab_035F

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     6.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   COI_GetAnimFieldPointerByMode

    PEA     20.W
    MOVE.L  D0,-(A7)
    PEA     19.W
    PEA     COI_FMT_WRAP_CHAR_STRING_CHAR
    PEA     -44(A5)
    MOVE.L  D0,-36(A5)
    JSR     GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     -44(A5),A0
    MOVE.L  A0,-4(A5)
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  A3,-(A7)
    BSR.W   CLEANUP_UpdateEntryFlagBytes

    LEA     36(A7),A7
    BRA.S   .lab_0360

.lab_035F:
    CLR.L   -4(A5)

.lab_0360:
    MOVEQ   #0,D5

.lab_0361:
    MOVEQ   #5,D0
    CMP.L   D0,D5
    BGE.S   COI_FormatEntryDisplayText_Return

    MOVE.L  D5,D0
    ASL.L   #2,D0
    TST.L   -20(A5,D0.L)
    BEQ.S   .lab_0362

    MOVEA.L -20(A5,D0.L),A0
    TST.B   (A0)
    BEQ.S   .lab_0362

    PEA     COI_STR_SINGLE_SPACE
    MOVE.L  20(A5),-(A7)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    MOVE.L  D5,D0
    ASL.L   #2,D0
    MOVE.L  -20(A5,D0.L),(A7)
    MOVE.L  20(A5),-(A7)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     12(A7),A7

.lab_0362:
    ADDQ.L  #1,D5
    BRA.S   .lab_0361

;------------------------------------------------------------------------------
; FUNC: COI_FormatEntryDisplayText_Return   (Routine at COI_FormatEntryDisplayText_Return)
; ARGS:
;   stack +16: arg_1 (via 20(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
COI_FormatEntryDisplayText_Return:
    MOVE.L  20(A5),D0
    MOVEM.L (A7)+,D2/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: COI_ComputeEntryTimeDeltaMinutes   (Routine at COI_ComputeEntryTimeDeltaMinutes)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D1/D5/D6/D7
; CALLS:
;   GROUP_AE_JMPTBL_ESQDISP_GetEntryAuxPointerByMode, GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset, GROUP_AE_JMPTBL_TLIBA_FindFirstWildcardMatchIndex
; READS:
;   COI_ComputeEntryTimeDeltaMinutes_Return, TEXTDISP_PrimaryGroupCode, CLOCK_HalfHourSlotIndex
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
COI_ComputeEntryTimeDeltaMinutes:
    MOVEM.L D5-D7/A3,-(A7)

    SetOffsetForStack 4
    UseStackLong    MOVEA.L,1,A3
    UseStackWord    MOVE.W,5,D7

    MOVEQ   #49,D6
    MOVEQ   #-1,D5
    TST.W   D7
    BLE.W   COI_ComputeEntryTimeDeltaMinutes_Return

    MOVEQ   #49,D0
    CMP.W   D0,D7
    BGE.W   COI_ComputeEntryTimeDeltaMinutes_Return

    MOVE.L  D7,D6
    ADDQ.W  #1,D6

.lab_0365:
    MOVEQ   #49,D0
    CMP.W   D0,D6
    BGE.S   .lab_0366

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    TST.L   56(A3,D0.L)
    BNE.S   .lab_0366

    ADDQ.W  #1,D6
    BRA.S   .lab_0365

.lab_0366:
    MOVEQ   #48,D0
    CMP.W   D0,D6
    BLE.S   .lab_0369

    MOVE.B  TEXTDISP_PrimaryGroupCode,D0
    MOVE.B  498(A3),D1
    CMP.B   D0,D1
    BNE.S   .lab_0369

    MOVE.L  A3,-(A7)
    JSR     GROUP_AE_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(PC)

    MOVE.L  D0,D6
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    JSR     GROUP_AE_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     12(A7),A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BEQ.S   .lab_0368

    MOVEQ   #1,D6

.lab_0367:
    MOVEQ   #49,D0
    CMP.W   D0,D6
    BGE.S   .lab_0369

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    TST.L   56(A3,D0.L)
    BNE.S   .lab_0369

    ADDQ.W  #1,D6
    BRA.S   .lab_0367

.lab_0368:
    MOVEQ   #49,D6

.lab_0369:
    MOVEQ   #48,D0
    CMP.W   D0,D6
    BLE.S   .lab_036A

    MOVE.W  CLOCK_HalfHourSlotIndex,D0
    MULU    #30,D0
    MOVE.L  #2880,D1
    SUB.L   D0,D1
    MOVE.L  D1,D5
    BRA.S   COI_ComputeEntryTimeDeltaMinutes_Return

.lab_036A:
    MOVEQ   #0,D0
    MOVE.B  498(A3),D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5

;------------------------------------------------------------------------------
; FUNC: COI_ComputeEntryTimeDeltaMinutes_Return   (Routine at COI_ComputeEntryTimeDeltaMinutes_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D5
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
COI_ComputeEntryTimeDeltaMinutes_Return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: COI_ProcessEntrySelectionState   (Process entry-selection state)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;------------------------------------------------------------------------------
COI_ProcessEntrySelectionState:
;------------------------------------------------------------------------------
; FUNC: COI_TestEntryWithinTimeWindow   (Routine at COI_TestEntryWithinTimeWindow)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +14: arg_4 (via 18(A5))
;   stack +16: arg_5 (via 20(A5))
;   stack +20: arg_6 (via 24(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D5/D6/D7
; CALLS:
;   GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset, GROUP_AG_JMPTBL_MATH_Mulu32, COI_ComputeEntryTimeDeltaMinutes
; READS:
;   CLOCK_HalfHourSlotIndex, lab_0378
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
COI_TestEntryWithinTimeWindow:
    LINK.W  A5,#-24
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  18(A5),D7
    MOVE.L  20(A5),D6
    MOVE.L  24(A5),D5
    MOVEQ   #1,D0
    MOVE.L  D0,-4(A5)
    MOVEQ   #0,D0
    SUBA.L  A0,A0
    MOVE.L  D0,-12(A5)
    MOVE.L  D0,-8(A5)
    MOVE.L  A0,-20(A5)
    MOVE.L  A0,-16(A5)
    MOVE.L  A3,D0
    BEQ.W   .lab_0378

    MOVE.L  A2,D0
    BEQ.W   .lab_0378

    TST.W   D7
    BLE.W   .lab_0378

    TST.W   D7
    BLE.S   .lab_036D

    MOVEQ   #49,D0
    CMP.W   D0,D7
    BGE.S   .lab_036D

    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    EXT.L   D0
    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset(PC)

    LEA     12(A7),A7
    MOVE.L  D0,-8(A5)
    BRA.S   .lab_036E

.lab_036D:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.W  CLOCK_HalfHourSlotIndex,D1
    SUB.L   D1,D0
    MOVEQ   #30,D1
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,-8(A5)

.lab_036E:
    BTST    #4,27(A3)
    BEQ.S   .lab_0375

    MOVEA.L 48(A3),A0
    MOVE.L  A0,-16(A5)
    BEQ.S   .lab_0374

    CLR.L   -24(A5)

.lab_036F:
    MOVEA.L -16(A5),A0
    MOVE.W  36(A0),D0
    EXT.L   D0
    MOVE.L  -24(A5),D1
    CMP.L   D0,D1
    BGE.S   .lab_0371

    ASL.L   #2,D1
    MOVEA.L -16(A5),A1
    MOVEA.L 38(A1),A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-20(A5)
    MOVEA.L -20(A5),A0
    MOVE.W  (A0),D0
    CMP.W   D7,D0
    BNE.S   .lab_0370

    BRA.S   .lab_0371

.lab_0370:
    CLR.L   -20(A5)
    ADDQ.L  #1,-24(A5)
    BRA.S   .lab_036F

.lab_0371:
    TST.L   -20(A5)
    BEQ.S   .lab_0372

    MOVEA.L -20(A5),A0
    MOVE.L  26(A0),-12(A5)
    BRA.S   .lab_0373

.lab_0372:
    MOVEA.L -16(A5),A0
    MOVE.L  32(A0),D0
    MOVE.L  D0,-12(A5)

.lab_0373:
    MOVEQ   #-1,D0
    CMP.L   -12(A5),D0
    BNE.S   .lab_0376

    MOVE.L  D5,-12(A5)
    BRA.S   .lab_0376

.lab_0374:
    MOVE.L  D5,-12(A5)
    BRA.S   .lab_0376

.lab_0375:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    BSR.W   COI_ComputeEntryTimeDeltaMinutes

    ADDQ.W  #8,A7
    MOVE.L  -8(A5),D1
    SUB.L   D1,D0
    MOVE.L  D0,-12(A5)

.lab_0376:
    MOVE.L  -12(A5),D0
    TST.L   D0
    BMI.S   .lab_0377

    MOVE.L  -8(A5),D1
    CMP.L   D6,D1
    BGT.S   .lab_0377

    NEG.L   D0
    CMP.L   D0,D1
    BGE.S   COI_TestEntryWithinTimeWindow_Return

.lab_0377:
    MOVEQ   #0,D0
    MOVE.L  D0,-4(A5)
    BRA.S   COI_TestEntryWithinTimeWindow_Return

.lab_0378:
    MOVEQ   #0,D0
    MOVE.L  D0,-4(A5)

;------------------------------------------------------------------------------
; FUNC: COI_TestEntryWithinTimeWindow_Return   (Routine at COI_TestEntryWithinTimeWindow_Return)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D5/D7
; CALLS:
;   GROUP_AE_JMPTBL_WDISP_SPrintf, COI_GetAnimFieldPointerByMode
; READS:
;   COI_FMT_WIDE_STR_WITH_TRAILING_SPACE
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
COI_TestEntryWithinTimeWindow_Return:
    MOVE.L  -4(A5),D0
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

    LINK.W  A5,#-4
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVEA.L 16(A5),A2
    MOVE.L  D7,D0
    EXT.L   D0
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   COI_GetAnimFieldPointerByMode

    LEA     12(A7),A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   COI_AppendAnimFieldWithTrailingSpace_Return

    MOVEA.L A2,A0

.lab_037A:
    TST.B   (A0)+
    BNE.S   .lab_037A

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,D0
    MOVEA.L A2,A1
    ADDA.L  D0,A1
    MOVE.L  -4(A5),-(A7)
    PEA     COI_FMT_WIDE_STR_WITH_TRAILING_SPACE
    MOVE.L  A1,-(A7)
    JSR     GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     12(A7),A7

;------------------------------------------------------------------------------
; FUNC: COI_AppendAnimFieldWithTrailingSpace_Return   (Routine at COI_AppendAnimFieldWithTrailingSpace_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
COI_AppendAnimFieldWithTrailingSpace_Return:
    MOVE.L  A2,D0
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS
