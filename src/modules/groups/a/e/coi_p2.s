    XDEF    _COI_LoadOiDataFile


;------------------------------------------------------------------------------
; FUNC: _COI_LoadOiDataFile   (LoadOiDataFileuncertain)
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
;   _GROUP_AG_JMPTBL_MATH_DivS32, _GROUP_AE_JMPTBL_WDISP_SPrintf, _DISKIO_LoadFileToWorkBuffer, _GROUP_AI_JMPTBL_STR_FindCharPtr, _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt,
;   _GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap, _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString, _CLEANUP_FormatEntryStringTokens, _ESQ_WildcardMatch, _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory,
;   _COI_AllocSubEntryTable
; READS:
;   _TEXTDISP_SecondaryGroupCode/_TEXTDISP_SecondaryGroupPresentFlag/_TEXTDISP_SecondaryGroupEntryCount/_TEXTDISP_PrimaryGroupCode/_TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryEntryPtrTable/_TEXTDISP_SecondaryEntryPtrTable,
;   _Global_PTR_WORK_BUFFER, _Global_REF_LONG_FILE_SCRATCH
; WRITES:
;   _Global_PTR_WORK_BUFFER, _Global_REF_LONG_FILE_SCRATCH, structures referenced by _TEXTDISP_PrimaryEntryPtrTable/
;   _TEXTDISP_SecondaryEntryPtrTable (fields +0..+36), local scratch buffers/flags
; DESC:
;   Builds `df0:OI_%02lx.dat` from diskId parity, loads the file into memory,
;   validates header fields, then parses CR/LF-delimited records to populate
;   object info structures and sub-entries using wildcard name matches.
; NOTES:
;   - File variant is inferred from a header field (format 2 vs default).
;   - Replaces CR/LF bytes in the loaded buffer with NUL terminators.
;   - Uses tab separators and parses numeric fields via _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt.
;   - DBF loops run (Dn+1) iterations when clearing scratch buffers.
;------------------------------------------------------------------------------
_COI_LoadOiDataFile:
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
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.W  D1,-334(A5)
    EXT.L   D1
    MOVE.L  D1,-(A7)
    PEA     _Global_STR_DF0_OI_PERCENT_2_LX_DAT_2
    PEA     -566(A5)
    JSR     _GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    PEA     -566(A5)
    JSR     _DISKIO_LoadFileToWorkBuffer(PC)

    LEA     16(A7),A7
    ADDQ.L  #1,D0
    BNE.S   .file_loaded

    MOVEQ   #-1,D0
    BRA.W   .return_status

.file_loaded:
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D0
    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D1
    MOVE.L  D0,-574(A5)
    MOVE.L  A0,-570(A5)
    CMP.B   D7,D1
    BNE.S   .check_alt_header

    MOVE.B  _TEXTDISP_SecondaryGroupPresentFlag,D0
    SUBQ.B  #1,D0
    BNE.S   .check_alt_header

    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    MOVE.W  D0,-336(A5)
    BRA.S   .init_parse_state

.check_alt_header:
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   .invalid_header

    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.W  D0,-336(A5)
    BRA.S   .init_parse_state

.invalid_header:
    MOVE.L  -574(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    PEA     1198.W
    PEA     _Global_STR_COI_C_6
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #-1,D0
    BRA.W   .return_status

.init_parse_state:
    MOVEQ   #0,D0
    MOVE.L  D0,-578(A5)
    MOVE.L  D0,-582(A5)

.copy_header_line:
    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    ADDA.L  -578(A5),A0
    ADDA.L  -582(A5),A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    PEA     _COI_STR_LINEFEED_CR_1
    JSR     _GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .finish_header_line

    LEA     -486(A5),A0
    MOVE.L  -582(A5),D0
    ADDA.L  D0,A0
    MOVEA.L _Global_PTR_WORK_BUFFER,A1
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
    JSR     _GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-648(A5)
    TST.L   D0
    BEQ.S   .no_header_tab

    MOVEA.L D0,A0
    CLR.B   (A0)+
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-648(A5)
    JSR     _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-644(A5)
    BRA.S   .validate_disk_id

.no_header_tab:
    CLR.L   -644(A5)

.validate_disk_id:
    PEA     -486(A5)
    JSR     _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D7,D1
    CMP.L   D0,D1
    BEQ.S   .strip_line_terminators

    MOVEQ   #-1,D0
    BRA.W   .return_status

.strip_line_terminators:
    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    ADDA.L  -578(A5),A0
    ADDA.L  -582(A5),A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    PEA     _COI_STR_LINEFEED_CR_2
    JSR     _GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .clear_seen_flags

    MOVEA.L _Global_PTR_WORK_BUFFER,A0
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

    MOVEA.L _Global_PTR_WORK_BUFFER,A0
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
    JSR     _GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(PC)

    LEA     28(A7),A7
    BRA.S   .init_entry_loop

.parse_record_legacy:
    MOVEQ   #21,D0
    MOVEQ   #0,D1
    LEA     -604(A5),A0

.clear_record_fields:
    MOVE.B  D1,(A0)+
    DBF     D0,.clear_record_fields
    MOVEA.L _Global_PTR_WORK_BUFFER,A0
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
    JSR     _GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(PC)

    LEA     28(A7),A7

.init_entry_loop:
    MOVE.W  -584(A5),D0
    EXT.L   D0
    MOVEQ   #0,D5
    MOVE.L  D0,-582(A5)

.entry_loop:
    CMP.W   -336(A5),D5
    BGE.W   .advance_entry

    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   .select_default_table

    MOVE.B  _TEXTDISP_SecondaryGroupPresentFlag,D0
    SUBQ.B  #1,D0
    BNE.S   .select_default_table

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    BRA.S   .match_entry_pattern

.select_default_table:
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1

.match_entry_pattern:
    LEA     12(A1),A0
    MOVEA.L _Global_PTR_WORK_BUFFER,A2
    ADDA.L  -578(A5),A2
    MOVE.L  A2,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-4(A5)
    JSR     _ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.W   .next_entry

    LEA     -326(A5),A0
    ADDA.W  D5,A0
    TST.B   (A0)
    BNE.W   .alloc_subentries

    MOVEA.L -4(A5),A0
    MOVE.L  48(A0),-8(A5)
    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    ADDA.L  -578(A5),A0
    ADDA.W  -600(A5),A0
    MOVEA.L -8(A5),A1
    MOVE.L  4(A1),-(A7)
    MOVE.L  A0,-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -8(A5),A0
    MOVE.L  D0,4(A0)
    MOVEA.L _Global_PTR_WORK_BUFFER,A1
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
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -8(A5),A0
    MOVE.L  D0,12(A0)
    MOVEA.L _Global_PTR_WORK_BUFFER,A1
    ADDA.L  -578(A5),A1
    ADDA.W  -594(A5),A1
    MOVE.L  16(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -8(A5),A0
    MOVE.L  D0,16(A0)
    MOVEA.L _Global_PTR_WORK_BUFFER,A1
    ADDA.L  -578(A5),A1
    ADDA.W  -592(A5),A1
    MOVE.L  20(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -8(A5),A0
    MOVE.L  D0,20(A0)
    MOVEA.L _Global_PTR_WORK_BUFFER,A1
    ADDA.L  -578(A5),A1
    ADDA.W  -590(A5),A1
    MOVE.L  8(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     24(A7),A7
    MOVEA.L -8(A5),A0
    MOVE.L  D0,8(A0)
    MOVE.W  -604(A5),D0
    BLE.S   .default_field24

    MOVE.L  -578(A5),D1
    MOVEA.L _Global_PTR_WORK_BUFFER,A1
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
    BSR.W   _CLEANUP_FormatEntryStringTokens

    LEA     12(A7),A7
    BRA.S   .after_field24

.default_field24:
    MOVE.L  24(A0),-(A7)
    CLR.L   -(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -8(A5),A0
    MOVE.L  D0,24(A0)
    MOVE.L  28(A0),(A7)
    PEA     _COI_STR_DEFAULT_TOKEN_TEMPLATE_A
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     12(A7),A7
    MOVEA.L -8(A5),A0
    MOVE.L  D0,28(A0)

.after_field24:
    MOVE.W  -602(A5),D0
    BEQ.S   .missing_field32

    MOVE.L  -578(A5),D1
    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    ADDA.W  D0,A1
    MOVE.L  A1,D2
    BEQ.S   .missing_field32

    ADDA.L  D1,A0
    ADDA.W  D0,A0
    MOVE.L  A0,-(A7)
    JSR     _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVEA.L -8(A5),A0
    MOVE.L  D0,32(A0)
    BRA.S   .store_field36

.missing_field32:
    MOVEQ   #-1,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D0,32(A0)

.store_field36:
    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    ADDA.L  -578(A5),A0
    ADDA.W  -588(A5),A0
    MOVE.L  A0,-(A7)
    PEA     _Global_STR_PERCENT_S_1
    PEA     -486(A5)
    JSR     _GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    PEA     -486(A5)
    JSR     _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    LEA     16(A7),A7
    MOVEA.L -8(A5),A0
    MOVE.W  D0,36(A0)

.alloc_subentries:
    MOVE.L  -4(A5),-(A7)
    BSR.W   _COI_AllocSubEntryTable

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

    MOVEA.L _Global_PTR_WORK_BUFFER,A0
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
    JSR     _GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(PC)

    LEA     28(A7),A7
    BRA.S   .process_subentry

.parse_subentry_legacy:
    MOVEQ   #15,D0
    MOVEQ   #0,D1
    LEA     -632(A5),A0

.clear_subentry_fields:
    MOVE.B  D1,(A0)+
    DBF     D0,.clear_subentry_fields
    MOVEA.L _Global_PTR_WORK_BUFFER,A0
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
    JSR     _GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(PC)

    LEA     28(A7),A7

.process_subentry:
    LEA     -326(A5),A0
    ADDA.W  D5,A0
    TST.B   (A0)
    BNE.W   .advance_subentry

    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    ADDA.L  -578(A5),A0
    MOVE.L  A0,-(A7)
    JSR     _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    MOVEA.L -12(A5),A0
    MOVE.W  D0,(A0)
    MOVEA.L _Global_PTR_WORK_BUFFER,A1
    ADDA.L  -578(A5),A1
    ADDA.W  -628(A5),A1
    MOVE.L  6(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,6(A0)
    MOVEA.L _Global_PTR_WORK_BUFFER,A1
    ADDA.L  -578(A5),A1
    ADDA.W  -626(A5),A1
    MOVE.L  10(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,10(A0)
    MOVEA.L _Global_PTR_WORK_BUFFER,A1
    ADDA.L  -578(A5),A1
    ADDA.W  -624(A5),A1
    MOVE.L  14(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,14(A0)
    MOVEA.L _Global_PTR_WORK_BUFFER,A1
    ADDA.L  -578(A5),A1
    ADDA.W  -622(A5),A1
    MOVE.L  2(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     20(A7),A7
    MOVEA.L -12(A5),A0
    MOVE.L  D0,2(A0)
    MOVE.W  -632(A5),D0
    BLE.S   .default_subentry_field18

    MOVE.L  -578(A5),D1
    MOVEA.L _Global_PTR_WORK_BUFFER,A1
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
    BSR.W   _CLEANUP_FormatEntryStringTokens

    LEA     12(A7),A7
    BRA.S   .after_subentry_field18

.default_subentry_field18:
    MOVE.L  18(A0),-(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  24(A0),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,18(A0)
    MOVE.L  22(A0),(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  28(A0),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     12(A7),A7
    MOVEA.L -12(A5),A0
    MOVE.L  D0,22(A0)

.after_subentry_field18:
    MOVE.W  -630(A5),D0
    BLE.S   .inherit_subentry_field26

    MOVE.L  -578(A5),D1
    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    ADDA.W  D0,A1
    MOVE.L  A1,D2
    BEQ.S   .inherit_subentry_field26

    ADDA.L  D1,A0
    ADDA.W  D0,A0
    MOVE.L  A0,-(A7)
    JSR     _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

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

    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   .select_table_second_pass

    MOVE.B  _TEXTDISP_SecondaryGroupPresentFlag,D0
    SUBQ.B  #1,D0
    BNE.S   .select_table_second_pass

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    BRA.S   .match_entry_second_pass

.select_table_second_pass:
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1

.match_entry_second_pass:
    MOVEA.L -4(A5),A0
    ADDA.W  #12,A0
    LEA     12(A1),A2
    MOVE.L  A2,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A1,-16(A5)
    JSR     _ESQ_WildcardMatch(PC)

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
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

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
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -20(A5),A0
    MOVE.L  D0,12(A0)
    MOVE.L  16(A0),(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  16(A0),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -20(A5),A0
    MOVE.L  D0,16(A0)
    MOVE.L  20(A0),(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  20(A0),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -20(A5),A0
    MOVE.L  D0,20(A0)
    MOVE.L  8(A0),(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  8(A0),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -20(A5),A0
    MOVE.L  D0,8(A0)
    MOVE.L  24(A0),(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  24(A0),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -20(A5),A0
    MOVE.L  D0,24(A0)
    MOVE.L  28(A0),(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  28(A0),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -20(A5),A0
    MOVE.L  D0,28(A0)
    MOVEA.L -8(A5),A0
    MOVEA.L -20(A5),A1
    MOVE.L  32(A0),32(A1)
    MOVE.W  36(A0),36(A1)
    MOVE.L  -16(A5),(A7)
    BSR.W   _COI_AllocSubEntryTable

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
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,6(A0)
    MOVE.L  10(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  10(A0),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,10(A0)
    MOVE.L  14(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  14(A0),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,14(A0)
    MOVE.L  2(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  2(A0),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,2(A0)
    MOVE.L  18(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  18(A0),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,18(A0)
    MOVE.L  22(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  22(A0),-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

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
    PEA     _Global_STR_COI_C_1
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #0,D0

.return_status:
    MOVEM.L -676(A5),D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======