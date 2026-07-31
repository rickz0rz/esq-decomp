    XDEF    _ESQIFF2_ParseGroupRecordAndRefresh
    XDEF    ESQIFF2_ParseGroupRecordAndRefresh_Return


;------------------------------------------------------------------------------
; FUNC: _ESQIFF2_ParseGroupRecordAndRefresh   (Parse group record and rebuild entry state)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +10: arg_3 (via 14(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   _ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache, _ESQPARS_JMPTBL_TEXTDISP_ApplySourceConfigAllEntries, _ESQIFF2_ValidateFieldIndexAndLength, _ESQIFF2_PadEntriesToMaxTitleWidth, _ESQPARS_RemoveGroupEntryAndReleaseStrings, _ESQSHARED_CreateGroupEntryAndTitle
; READS:
;   _TEXTDISP_SecondaryGroupCode, _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryGroupCode, _TEXTDISP_PrimaryGroupEntryCount, _ESQIFF_RecordLength, _TEXTDISP_PrimaryGroupRecordChecksum, _TEXTDISP_PrimaryGroupRecordLength, _TEXTDISP_SecondaryGroupRecordChecksum, _TEXTDISP_SecondaryGroupRecordLength, _ESQIFF_RecordChecksumByte, _ESQIFF_ParseField0Buffer, _ESQIFF_ParseField1Buffer, _ESQIFF_ParseField2Buffer, _ESQIFF_ParseField3Buffer, ff
; WRITES:
;   _TEXTDISP_PrimaryGroupRecordChecksum, _TEXTDISP_PrimaryGroupRecordLength, _TEXTDISP_MaxEntryTitleLength, _TEXTDISP_SecondaryGroupRecordChecksum, _TEXTDISP_SecondaryGroupRecordLength, _NEWGRID_RefreshStateFlag, _ESQIFF_ParseField0Buffer, _ESQIFF_ParseField0TailBuffer, _ESQIFF_ParseField1Buffer, _ESQIFF_ParseField1TailByte, _ESQIFF_ParseField3Buffer, _ESQIFF_ParseField3TailBuffer
; DESC:
;   Parses incoming group record fields, refreshes entry/title structures when
;   checksum/length changed, pads titles, and triggers source-config/index rebuild.
; NOTES:
;   Distinguishes primary vs secondary group by leading group code byte.
;   Parser dispatch uses control tokens `0x01`, `0x11`, `0x12`, and `0x14`.
;------------------------------------------------------------------------------
_ESQIFF2_ParseGroupRecordAndRefresh:
    LINK.W  A5,#-20
    MOVEM.L D2/D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D0
    MOVE.B  (A3)+,D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVE.L  D0,D7
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   .check_secondary_group_record

    MOVE.W  _TEXTDISP_PrimaryGroupRecordLength,D0
    MOVE.W  _ESQIFF_RecordLength,D1
    CMP.W   D1,D0
    BNE.S   .primary_record_changed

    MOVE.B  _TEXTDISP_PrimaryGroupRecordChecksum,D0
    MOVE.B  _ESQIFF_RecordChecksumByte,D2
    CMP.B   D2,D0
    BEQ.S   .check_secondary_group_record

.primary_record_changed:
    MOVE.W  D1,_TEXTDISP_PrimaryGroupRecordLength
    MOVE.B  _ESQIFF_RecordChecksumByte,_TEXTDISP_PrimaryGroupRecordChecksum
    MOVEQ   #0,D0
    MOVE.W  D0,_TEXTDISP_MaxEntryTitleLength
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D1
    CMP.W   D0,D1
    BLS.S   .init_parse_state

    PEA     1.W
    BSR.W   _ESQPARS_RemoveGroupEntryAndReleaseStrings

    ADDQ.W  #4,A7
    MOVEQ   #1,D0
    MOVE.L  D0,_NEWGRID_RefreshStateFlag
    BRA.S   .init_parse_state

.check_secondary_group_record:
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   .return_group_not_target

    MOVE.W  _TEXTDISP_SecondaryGroupRecordLength,D0
    MOVE.W  _ESQIFF_RecordLength,D1
    CMP.W   D1,D0
    BNE.S   .secondary_record_changed

    MOVE.B  _TEXTDISP_SecondaryGroupRecordChecksum,D0
    MOVE.B  _ESQIFF_RecordChecksumByte,D2
    CMP.B   D2,D0
    BEQ.S   .return_group_not_target

.secondary_record_changed:
    MOVE.W  D1,_TEXTDISP_SecondaryGroupRecordLength
    MOVE.B  _ESQIFF_RecordChecksumByte,_TEXTDISP_SecondaryGroupRecordChecksum
    MOVEQ   #0,D0
    MOVE.W  D0,_TEXTDISP_MaxEntryTitleLength
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D1
    CMP.W   D0,D1
    BLS.S   .init_parse_state

    PEA     2.W
    BSR.W   _ESQPARS_RemoveGroupEntryAndReleaseStrings

    ADDQ.W  #4,A7
    BRA.S   .init_parse_state

.return_group_not_target:
    MOVEQ   #0,D0
    BRA.W   ESQIFF2_ParseGroupRecordAndRefresh_Return

.init_parse_state:
    MOVEQ   #1,D6
    MOVEQ   #0,D0
    MOVE.B  D0,_ESQIFF_ParseField0Buffer
    MOVE.B  D0,_ESQIFF_ParseField1Buffer
    MOVEQ   #0,D5

.init_field2_defaults_loop:
    MOVEQ   #6,D0
    CMP.W   D0,D5
    BGE.S   .parse_next_byte_loop_entry

    LEA     _ESQIFF_ParseField2Buffer,A0
    ADDA.W  D5,A0
    MOVE.B  #$ff,(A0)
    ADDQ.W  #1,D5
    BRA.S   .init_field2_defaults_loop

.parse_next_byte_loop_entry:
    CLR.B   _ESQIFF_ParseField3Buffer
    MOVEQ   #0,D4
    MOVEQ   #0,D5
    MOVEQ   #1,D0
    MOVE.L  D0,-8(A5)
    CLR.L   -12(A5)
    CLR.W   -14(A5)

.parse_next_byte_loop:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-3(A5)
    TST.B   D0
    BEQ.W   .flush_pending_entry_and_return

    TST.L   -12(A5)
    BNE.W   .flush_pending_entry_and_return

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    SUBQ.W  #1,D1
    BEQ.W   .handle_token_0x01

    SUBI.W  #16,D1
    BEQ.W   .handle_token_0x11

    SUBQ.W  #1,D1
    BEQ.S   .handle_token_0x12

    SUBQ.W  #2,D1
    BEQ.W   .handle_token_0x14

    BRA.W   .handle_default_data_byte

.handle_token_0x12:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _ESQIFF2_ValidateFieldIndexAndLength

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .branch_1

    MOVEQ   #1,D0
    MOVE.L  D0,-12(A5)
    BRA.S   .parse_next_byte_loop

.branch_1:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     _ESQIFF_ParseField0Buffer,A0
    ADDA.L  D0,A0
    ADDA.W  D5,A0
    CLR.B   (A0)
    TST.L   -8(A5)
    BNE.S   .branch_4

    TST.W   -14(A5)
    BNE.S   .branch_3

    LEA     _ESQIFF_ParseField0Buffer,A0
    LEA     _ESQIFF_ParseField3Buffer,A1

.branch_2:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .branch_2

.branch_3:
    MOVEQ   #0,D0
    MOVE.B  D0,_ESQIFF_ParseField0TailBuffer
    MOVE.B  D0,_ESQIFF_ParseField1TailByte
    MOVE.B  D0,_ESQIFF_ParseField3TailBuffer
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    PEA     _ESQIFF_ParseField3Buffer
    PEA     _ESQIFF_ParseField2Buffer
    PEA     _ESQIFF_ParseField1Buffer
    PEA     _ESQIFF_ParseField0Buffer
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _ESQSHARED_CreateGroupEntryAndTitle(PC)

    LEA     24(A7),A7
    MOVEQ   #0,D0
    MOVE.W  D0,-14(A5)
    BRA.S   .branch_5

.branch_4:
    CLR.L   -8(A5)

.branch_5:
    MOVEQ   #0,D0
    MOVE.B  D0,_ESQIFF_ParseField0Buffer
    MOVE.B  D0,_ESQIFF_ParseField1Buffer
    MOVEQ   #0,D5

.branch_6:
    MOVEQ   #6,D0
    CMP.W   D0,D5
    BGE.S   .branch_7

    LEA     _ESQIFF_ParseField2Buffer,A0
    ADDA.W  D5,A0
    MOVE.B  #$ff,(A0)
    ADDQ.W  #1,D5
    BRA.S   .branch_6

.branch_7:
    CLR.B   _ESQIFF_ParseField3Buffer
    MOVEQ   #0,D4
    MOVEQ   #0,D5
    MOVE.B  (A3)+,D6
    BRA.W   .parse_next_byte_loop

.handle_token_0x11:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _ESQIFF2_ValidateFieldIndexAndLength

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .branch_8

    MOVEQ   #1,D0
    MOVE.L  D0,-12(A5)
    BRA.W   .parse_next_byte_loop

.branch_8:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     _ESQIFF_ParseField0Buffer,A0
    ADDA.L  D0,A0
    ADDA.W  D5,A0
    CLR.B   (A0)
    MOVEQ   #1,D4
    MOVEQ   #0,D5
    BRA.W   .parse_next_byte_loop

.handle_token_0x14:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _ESQIFF2_ValidateFieldIndexAndLength

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .branch_9

    MOVEQ   #1,D0
    MOVE.L  D0,-12(A5)
    BRA.W   .parse_next_byte_loop

.branch_9:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     _ESQIFF_ParseField0Buffer,A0
    ADDA.L  D0,A0
    ADDA.W  D5,A0
    CLR.B   (A0)
    MOVEQ   #0,D5

.branch_10:
    MOVEQ   #6,D0
    CMP.W   D0,D5
    BGE.W   .parse_next_byte_loop

    LEA     _ESQIFF_ParseField2Buffer,A0
    ADDA.W  D5,A0
    MOVE.B  (A3)+,(A0)
    ADDQ.W  #1,D5
    BRA.S   .branch_10

.handle_token_0x01:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _ESQIFF2_ValidateFieldIndexAndLength

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .branch_11

    MOVEQ   #1,D0
    MOVE.L  D0,-12(A5)
    BRA.W   .parse_next_byte_loop

.branch_11:
    MOVEQ   #2,D0
    CMP.W   D0,D4
    BEQ.S   .branch_12

    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     _ESQIFF_ParseField0Buffer,A0
    ADDA.L  D0,A0
    ADDA.W  D5,A0
    CLR.B   (A0)

.branch_12:
    MOVEQ   #3,D4
    MOVEQ   #0,D5
    MOVE.W  #1,-14(A5)
    BRA.W   .parse_next_byte_loop

.handle_default_data_byte:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _ESQIFF2_ValidateFieldIndexAndLength

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .branch_13

    MOVEQ   #1,D0
    MOVE.L  D0,-12(A5)
    BRA.W   .parse_next_byte_loop

.branch_13:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     _ESQIFF_ParseField0Buffer,A0
    ADDA.L  D0,A0
    MOVE.L  D5,D0
    ADDQ.W  #1,D5
    ADDA.W  D0,A0
    MOVE.B  -3(A5),(A0)
    BRA.W   .parse_next_byte_loop

.flush_pending_entry_and_return:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _ESQIFF2_ValidateFieldIndexAndLength

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .branch_14

    MOVEQ   #0,D0
    BRA.S   ESQIFF2_ParseGroupRecordAndRefresh_Return

.branch_14:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     _ESQIFF_ParseField0Buffer,A0
    ADDA.L  D0,A0
    ADDA.W  D5,A0
    MOVEQ   #0,D0
    MOVE.B  D0,(A0)
    MOVE.B  D0,_ESQIFF_ParseField0TailBuffer
    MOVE.B  D0,_ESQIFF_ParseField1TailByte
    MOVE.B  D0,_ESQIFF_ParseField3TailBuffer
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    PEA     _ESQIFF_ParseField3Buffer
    PEA     _ESQIFF_ParseField2Buffer
    PEA     _ESQIFF_ParseField1Buffer
    PEA     _ESQIFF_ParseField0Buffer
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _ESQSHARED_CreateGroupEntryAndTitle(PC)

    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,(A7)
    BSR.W   _ESQIFF2_PadEntriesToMaxTitleWidth

    JSR     _ESQPARS_JMPTBL_TEXTDISP_ApplySourceConfigAllEntries(PC)

    JSR     _ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache(PC)

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ParseGroupRecordAndRefresh_Return   (Return tail for group-record parser)
; ARGS:
;   stack +40: arg_1 (via 44(A5))
; RET:
;   D0: none observed
; CLOBBERS:
;   D2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Restores frame/registers and returns from _ESQIFF2_ParseGroupRecordAndRefresh.
; NOTES:
;   Shared tail for both no-op and full-refresh paths.
;------------------------------------------------------------------------------
ESQIFF2_ParseGroupRecordAndRefresh_Return:
    MOVEM.L -44(A5),D2/D4-D7/A3
    UNLK    A5
    RTS

;!======