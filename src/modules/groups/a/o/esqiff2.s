; Rename this file to its proper purpose.

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ApplyIncomingStatusPacket   (Apply incoming status packet and refresh UI)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A7/D0/D1/D2/D6/D7
; CALLS:
;   ED_DrawDiagnosticModeText, ESQDISP_DrawStatusBanner, ESQPARS_JMPTBL_DST_RefreshBannerBuffer, ESQPARS_JMPTBL_DST_UpdateBannerQueue, ESQPARS_JMPTBL_ESQ_SeedMinuteEventThresholds
; READS:
;   ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED, DATA_ESQ_STR_B_1DC8, DATA_ESQ_CONST_BYTE_1DCF, DATA_ESQ_CONST_BYTE_1DD0, DATA_ESQ_STR_6_1DD1, ED_DiagVinModeChar, LOCAVAIL_FilterModeFlag, DST_BannerWindowPrimary, ED_SavedScrollSpeedIndex, ED_DiagnosticsScreenActive, SCRIPT_RuntimeMode
; WRITES:
;   DATA_ESQ_CONST_BYTE_1DCF, DATA_ESQ_CONST_BYTE_1DD0, DATA_ESQ_STR_6_1DD1, ESQPARS2_StateIndex, DATA_SCRIPT_BSS_LONG_2125
; DESC:
;   Copies status payload bytes into globals, refreshes banner/status UI paths,
;   reseeds minute-event thresholds, and updates scroll-speed state/index.
; NOTES:
;   Triggers diagnostics redraw when diagnostics screen is active.
;------------------------------------------------------------------------------
ESQIFF2_ApplyIncomingStatusPacket:
    MOVEM.L D2/D6-D7/A3,-(A7)
    MOVEA.L 20(A7),A3

    MOVE.B  ED_DiagVinModeChar,D6
    MOVEQ   #0,D7

.lab_0AB9:
    MOVEQ   #20,D0
    CMP.W   D0,D7
    BGE.S   .lab_0ABA

    LEA     DATA_ESQ_STR_B_1DC8,A0
    ADDA.W  D7,A0
    MOVE.B  0(A3,D7.W),(A0)
    ADDQ.W  #1,D7
    BRA.S   .lab_0AB9

.lab_0ABA:
    TST.L   LOCAVAIL_FilterModeFlag
    BNE.S   .branch

    MOVE.B  ED_DiagVinModeChar,D0
    CMP.B   D0,D6
    BEQ.S   .branch

    MOVE.W  SCRIPT_RuntimeMode,D0
    BEQ.S   .branch

    MOVEQ   #1,D0
    MOVE.L  D0,DATA_SCRIPT_BSS_LONG_2125

.branch:
    MOVE.B  DATA_ESQ_STR_6_1DD1,D0
    MOVEQ   #49,D1
    CMP.B   D1,D0
    BCS.S   .branch_1

    MOVEQ   #72,D1
    CMP.B   D1,D0
    BLS.S   .branch_2

.branch_1:
    MOVE.B  #$36,DATA_ESQ_STR_6_1DD1

.branch_2:
    PEA     DST_BannerWindowPrimary
    JSR     ESQPARS_JMPTBL_DST_UpdateBannerQueue(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BNE.S   .branch_3

    JSR     ESQPARS_JMPTBL_DST_RefreshBannerBuffer(PC)

.branch_3:
    PEA     1.W
    JSR     ESQDISP_DrawStatusBanner(PC)

    ADDQ.W  #4,A7
    MOVE.B  DATA_ESQ_CONST_BYTE_1DCF,D0
    MOVEQ   #9,D1
    CMP.B   D1,D0
    BHI.S   .branch_4

    MOVEQ   #0,D2
    CMP.B   D2,D0
    BHI.S   .branch_5

.branch_4:
    MOVEQ   #1,D2
    MOVE.B  D2,DATA_ESQ_CONST_BYTE_1DCF

.branch_5:
    MOVE.B  DATA_ESQ_CONST_BYTE_1DD0,D0
    CMP.B   D1,D0
    BHI.S   .branch_6

    MOVEQ   #0,D1
    CMP.B   D1,D0
    BHI.S   .branch_7

.branch_6:
    MOVEQ   #1,D1
    MOVE.B  D1,DATA_ESQ_CONST_BYTE_1DD0

.branch_7:
    MOVEQ   #0,D0
    MOVE.B  DATA_ESQ_CONST_BYTE_1DCF,D0
    MOVEQ   #0,D1
    MOVE.B  DATA_ESQ_CONST_BYTE_1DD0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_SeedMinuteEventThresholds(PC)

    ADDQ.W  #8,A7
    TST.W   ED_DiagnosticsScreenActive
    BEQ.S   .branch_8

    JSR     ED_DrawDiagnosticModeText(PC)

.branch_8:
    TST.L   ED_SavedScrollSpeedIndex
    BNE.S   ESQIFF2_ApplyIncomingStatusPacket_Return

    MOVEQ   #0,D0
    MOVE.B  ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,D7
    MOVEQ   #1,D0
    CMP.W   D0,D7
    BLT.S   .branch_9

    MOVEQ   #8,D1
    CMP.W   D1,D7
    BGT.S   .branch_9

    MOVE.W  D7,ESQPARS2_StateIndex
    BRA.S   ESQIFF2_ApplyIncomingStatusPacket_Return

.branch_9:
    MOVE.W  #4,ESQPARS2_StateIndex

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ApplyIncomingStatusPacket_Return   (Return tail for incoming-status packet handler)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   DATA_WDISP_BSS_WORD_2299
; DESC:
;   Marks banner/status dirty flag, restores registers, and returns.
; NOTES:
;   Shared tail for all post-update state/index clamp paths.
;------------------------------------------------------------------------------
ESQIFF2_ApplyIncomingStatusPacket_Return:
    MOVE.W  #1,DATA_WDISP_BSS_WORD_2299
    MOVEM.L (A7)+,D2/D6-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ValidateAsciiNumericByte   (Validate byte is ASCII '1'..'0' range used by parser)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Returns input byte when it lies in accepted ASCII range, otherwise leaves D0 as 1.
; NOTES:
;   Preserves D7 across call.
;------------------------------------------------------------------------------
ESQIFF2_ValidateAsciiNumericByte:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7

    MOVEQ   #1,D0
    CMP.B   D0,D7
    BLT.S   .return

    MOVEQ   #48,D1
    CMP.B   D1,D7
    BGT.S   .return

    MOVE.L  D7,D0

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ClearLineHeadTailByMode   (Clear primary/secondary line head+tail owned strings by mode)
; ARGS:
;   stack +4: mode (1=primary, 2=secondary)
; RET:
;   D0: replacement pointer from final ESQPARS_ReplaceOwnedString call
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   ESQPARS_ReplaceOwnedString
; READS:
;   ESQIFF_PrimaryLineHeadPtr, ESQIFF_PrimaryLineTailPtr, ESQIFF_SecondaryLineHeadPtr, ESQIFF_SecondaryLineTailPtr
; WRITES:
;   ESQIFF_PrimaryLineHeadPtr, ESQIFF_PrimaryLineTailPtr, ESQIFF_SecondaryLineHeadPtr, ESQIFF_SecondaryLineTailPtr
; DESC:
;   Releases and clears the selected line-head and line-tail owned strings for the
;   requested group mode.
; NOTES:
;   Uses ESQPARS_ReplaceOwnedString(new=NULL, old=current) for each pointer.
;------------------------------------------------------------------------------
ESQIFF2_ClearLineHeadTailByMode:
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7
    MOVEQ   #2,D0
    CMP.W   D0,D7
    BNE.S   .clear_primary_line_head_tail

    MOVE.L  ESQIFF_SecondaryLineHeadPtr,-(A7)
    CLR.L   -(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    MOVE.L  D0,ESQIFF_SecondaryLineHeadPtr
    MOVE.L  ESQIFF_SecondaryLineTailPtr,(A7)
    CLR.L   -(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    LEA     12(A7),A7
    MOVE.L  D0,ESQIFF_SecondaryLineTailPtr
    BRA.S   .return_clear_line_head_tail

.clear_primary_line_head_tail:
    MOVE.L  ESQIFF_PrimaryLineHeadPtr,-(A7)
    CLR.L   -(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    MOVE.L  D0,ESQIFF_PrimaryLineHeadPtr
    MOVE.L  ESQIFF_PrimaryLineTailPtr,(A7)
    CLR.L   -(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    LEA     12(A7),A7
    MOVE.L  D0,ESQIFF_PrimaryLineTailPtr

.return_clear_line_head_tail:
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ParseLineHeadTailRecord   (Parse line head/tail text record by group)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A7/D0/D1/D6/D7
; CALLS:
;   ESQIFF2_ClearLineHeadTailByMode, ESQPARS_ReplaceOwnedString
; READS:
;   ESQIFF_PrimaryLineHeadPtr, ESQIFF_PrimaryLineTailPtr, ESQIFF_SecondaryLineHeadPtr, ESQIFF_SecondaryLineTailPtr, TEXTDISP_SecondaryGroupCode, TEXTDISP_PrimaryGroupCode, ESQIFF_RecordLength
; WRITES:
;   ESQIFF_PrimaryLineHeadPtr, ESQIFF_PrimaryLineTailPtr, ESQIFF_SecondaryLineHeadPtr, ESQIFF_SecondaryLineTailPtr, DATA_WDISP_BSS_WORD_228F
; DESC:
;   Splits a line-head/tail record on delimiter 0x12 and updates primary or
;   secondary line-head/line-tail owned strings based on group code.
; NOTES:
;   Calls ESQIFF2_ClearLineHeadTailByMode before replacing owned strings.
;------------------------------------------------------------------------------
ESQIFF2_ParseLineHeadTailRecord:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVE.L  D0,D7
    MOVE.B  TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D0,D7
    BNE.W   .check_secondary_group

    PEA     1.W
    BSR.W   ESQIFF2_ClearLineHeadTailByMode

    ADDQ.W  #4,A7
    MOVEQ   #18,D0
    CMP.B   1(A3),D0
    BNE.S   .primary_split_or_head_only

    SUBA.L  A0,A0
    MOVE.L  A0,ESQIFF_PrimaryLineHeadPtr
    MOVEQ   #0,D1
    MOVE.W  ESQIFF_RecordLength,D1
    CMP.B   -1(A3,D1.L),D0
    BNE.S   .primary_tail_only_from_payload

    MOVE.L  A0,ESQIFF_PrimaryLineTailPtr
    BRA.W   ESQIFF2_ParseLineHeadTailRecord_Return

.primary_tail_only_from_payload:
    LEA     2(A3),A0
    MOVE.L  ESQIFF_PrimaryLineTailPtr,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    ADDQ.W  #8,A7
    MOVE.L  D0,ESQIFF_PrimaryLineTailPtr
    BRA.W   ESQIFF2_ParseLineHeadTailRecord_Return

.primary_split_or_head_only:
    MOVEQ   #0,D0
    MOVE.W  ESQIFF_RecordLength,D0
    MOVEQ   #18,D1
    CMP.B   -1(A3,D0.L),D1
    BNE.S   .primary_scan_internal_delimiter

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    CLR.B   -1(A3,D1.L)
    LEA     1(A3),A0
    MOVE.L  ESQIFF_PrimaryLineHeadPtr,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    ADDQ.W  #8,A7
    MOVE.L  D0,ESQIFF_PrimaryLineHeadPtr
    CLR.L   ESQIFF_PrimaryLineTailPtr
    BRA.W   ESQIFF2_ParseLineHeadTailRecord_Return

.primary_scan_internal_delimiter:
    MOVEQ   #3,D6

.loop_primary_find_delimiter:
    MOVEQ   #18,D0
    CMP.B   0(A3,D6.W),D0
    BEQ.S   .primary_split_at_found_delimiter

    MOVEQ   #103,D0
    CMP.W   D0,D6
    BGE.S   .primary_split_at_found_delimiter

    ADDQ.W  #1,D6
    BRA.S   .loop_primary_find_delimiter

.primary_split_at_found_delimiter:
    CLR.B   0(A3,D6.W)
    LEA     1(A3),A0
    MOVE.L  ESQIFF_PrimaryLineHeadPtr,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    MOVE.L  D0,ESQIFF_PrimaryLineHeadPtr
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     1(A0),A1
    MOVE.L  ESQIFF_PrimaryLineTailPtr,(A7)
    MOVE.L  A1,-(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    LEA     12(A7),A7
    MOVE.L  D0,ESQIFF_PrimaryLineTailPtr
    BRA.W   ESQIFF2_ParseLineHeadTailRecord_Return

.check_secondary_group:
    MOVE.B  TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D0,D7
    BNE.W   ESQIFF2_ParseLineHeadTailRecord_Return

    PEA     2.W
    BSR.W   ESQIFF2_ClearLineHeadTailByMode

    ADDQ.W  #4,A7
    MOVE.W  #1,DATA_WDISP_BSS_WORD_228F
    MOVEQ   #18,D0
    CMP.B   1(A3),D0
    BNE.S   .secondary_split_or_head_only

    SUBA.L  A0,A0
    MOVE.L  A0,ESQIFF_SecondaryLineHeadPtr
    MOVEQ   #0,D1
    MOVE.W  ESQIFF_RecordLength,D1
    CMP.B   -1(A3,D1.L),D0
    BNE.S   .secondary_tail_only_from_payload

    MOVE.L  A0,ESQIFF_SecondaryLineTailPtr
    BRA.W   ESQIFF2_ParseLineHeadTailRecord_Return

.secondary_tail_only_from_payload:
    LEA     2(A3),A0
    MOVE.L  ESQIFF_SecondaryLineTailPtr,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    ADDQ.W  #8,A7
    MOVE.L  D0,ESQIFF_SecondaryLineTailPtr
    BRA.W   ESQIFF2_ParseLineHeadTailRecord_Return

.secondary_split_or_head_only:
    MOVEQ   #0,D0
    MOVE.W  ESQIFF_RecordLength,D0
    MOVEQ   #18,D1
    CMP.B   -1(A3,D0.L),D1
    BNE.S   .secondary_scan_internal_delimiter

    LEA     1(A3),A0
    MOVE.L  ESQIFF_SecondaryLineHeadPtr,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    ADDQ.W  #8,A7
    MOVE.L  D0,ESQIFF_SecondaryLineHeadPtr
    CLR.L   ESQIFF_SecondaryLineTailPtr
    BRA.S   ESQIFF2_ParseLineHeadTailRecord_Return

.secondary_scan_internal_delimiter:
    MOVEQ   #3,D6

.loop_secondary_find_delimiter:
    MOVEQ   #18,D0
    CMP.B   0(A3,D6.W),D0
    BEQ.S   .secondary_split_at_found_delimiter

    MOVEQ   #103,D0
    CMP.W   D0,D6
    BGE.S   .secondary_split_at_found_delimiter

    ADDQ.W  #1,D6
    BRA.S   .loop_secondary_find_delimiter

.secondary_split_at_found_delimiter:
    CLR.B   0(A3,D6.W)
    LEA     1(A3),A0
    MOVE.L  ESQIFF_SecondaryLineHeadPtr,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    MOVE.L  D0,ESQIFF_SecondaryLineHeadPtr
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     1(A0),A1
    MOVE.L  ESQIFF_SecondaryLineTailPtr,(A7)
    MOVE.L  A1,-(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    LEA     12(A7),A7
    MOVE.L  D0,ESQIFF_SecondaryLineTailPtr

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ParseLineHeadTailRecord_Return   (Return tail for line head/tail parser)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D6
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Restores saved registers and returns from line-head/tail parse helper.
; NOTES:
;   Shared return for all parse paths and unsupported-group early exits.
;------------------------------------------------------------------------------
ESQIFF2_ParseLineHeadTailRecord_Return:
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ParseGroupRecordAndRefresh   (Parse group record and rebuild entry state)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +10: arg_3 (via 14(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache, ESQPARS_JMPTBL_TEXTDISP_ApplySourceConfigAllEntries, ESQIFF2_ValidateFieldIndexAndLength, ESQIFF2_PadEntriesToMaxTitleWidth, ESQPARS_RemoveGroupEntryAndReleaseStrings, ESQSHARED_CreateGroupEntryAndTitle
; READS:
;   TEXTDISP_SecondaryGroupCode, TEXTDISP_SecondaryGroupEntryCount, TEXTDISP_PrimaryGroupCode, TEXTDISP_PrimaryGroupEntryCount, ESQIFF_RecordLength, TEXTDISP_PrimaryGroupRecordChecksum, TEXTDISP_PrimaryGroupRecordLength, TEXTDISP_SecondaryGroupRecordChecksum, TEXTDISP_SecondaryGroupRecordLength, ESQIFF_RecordChecksumByte, ESQIFF_ParseField0Buffer, ESQIFF_ParseField1Buffer, ESQIFF_ParseField2Buffer, ESQIFF_ParseField3Buffer, ff
; WRITES:
;   TEXTDISP_PrimaryGroupRecordChecksum, TEXTDISP_PrimaryGroupRecordLength, TEXTDISP_MaxEntryTitleLength, TEXTDISP_SecondaryGroupRecordChecksum, TEXTDISP_SecondaryGroupRecordLength, NEWGRID_RefreshStateFlag, ESQIFF_ParseField0Buffer, ESQIFF_ParseField0TailBuffer, ESQIFF_ParseField1Buffer, ESQIFF_ParseField1TailByte, ESQIFF_ParseField3Buffer, ESQIFF_ParseField3TailBuffer
; DESC:
;   Parses incoming group record fields, refreshes entry/title structures when
;   checksum/length changed, pads titles, and triggers source-config/index rebuild.
; NOTES:
;   Distinguishes primary vs secondary group by leading group code byte.
;   Parser dispatch uses control tokens `0x01`, `0x11`, `0x12`, and `0x14`.
;------------------------------------------------------------------------------
ESQIFF2_ParseGroupRecordAndRefresh:
    LINK.W  A5,#-20
    MOVEM.L D2/D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D0
    MOVE.B  (A3)+,D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVE.L  D0,D7
    MOVE.B  TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   .check_secondary_group_record

    MOVE.W  TEXTDISP_PrimaryGroupRecordLength,D0
    MOVE.W  ESQIFF_RecordLength,D1
    CMP.W   D1,D0
    BNE.S   .primary_record_changed

    MOVE.B  TEXTDISP_PrimaryGroupRecordChecksum,D0
    MOVE.B  ESQIFF_RecordChecksumByte,D2
    CMP.B   D2,D0
    BEQ.S   .check_secondary_group_record

.primary_record_changed:
    MOVE.W  D1,TEXTDISP_PrimaryGroupRecordLength
    MOVE.B  ESQIFF_RecordChecksumByte,TEXTDISP_PrimaryGroupRecordChecksum
    MOVEQ   #0,D0
    MOVE.W  D0,TEXTDISP_MaxEntryTitleLength
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D1
    CMP.W   D0,D1
    BLS.S   .init_parse_state

    PEA     1.W
    BSR.W   ESQPARS_RemoveGroupEntryAndReleaseStrings

    ADDQ.W  #4,A7
    MOVEQ   #1,D0
    MOVE.L  D0,NEWGRID_RefreshStateFlag
    BRA.S   .init_parse_state

.check_secondary_group_record:
    MOVE.B  TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   .return_group_not_target

    MOVE.W  TEXTDISP_SecondaryGroupRecordLength,D0
    MOVE.W  ESQIFF_RecordLength,D1
    CMP.W   D1,D0
    BNE.S   .secondary_record_changed

    MOVE.B  TEXTDISP_SecondaryGroupRecordChecksum,D0
    MOVE.B  ESQIFF_RecordChecksumByte,D2
    CMP.B   D2,D0
    BEQ.S   .return_group_not_target

.secondary_record_changed:
    MOVE.W  D1,TEXTDISP_SecondaryGroupRecordLength
    MOVE.B  ESQIFF_RecordChecksumByte,TEXTDISP_SecondaryGroupRecordChecksum
    MOVEQ   #0,D0
    MOVE.W  D0,TEXTDISP_MaxEntryTitleLength
    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D1
    CMP.W   D0,D1
    BLS.S   .init_parse_state

    PEA     2.W
    BSR.W   ESQPARS_RemoveGroupEntryAndReleaseStrings

    ADDQ.W  #4,A7
    BRA.S   .init_parse_state

.return_group_not_target:
    MOVEQ   #0,D0
    BRA.W   ESQIFF2_ParseGroupRecordAndRefresh_Return

.init_parse_state:
    MOVEQ   #1,D6
    MOVEQ   #0,D0
    MOVE.B  D0,ESQIFF_ParseField0Buffer
    MOVE.B  D0,ESQIFF_ParseField1Buffer
    MOVEQ   #0,D5

.init_field2_defaults_loop:
    MOVEQ   #6,D0
    CMP.W   D0,D5
    BGE.S   .parse_next_byte_loop_entry

    LEA     ESQIFF_ParseField2Buffer,A0
    ADDA.W  D5,A0
    MOVE.B  #$ff,(A0)
    ADDQ.W  #1,D5
    BRA.S   .init_field2_defaults_loop

.parse_next_byte_loop_entry:
    CLR.B   ESQIFF_ParseField3Buffer
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
    BSR.W   ESQIFF2_ValidateFieldIndexAndLength

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .branch_1

    MOVEQ   #1,D0
    MOVE.L  D0,-12(A5)
    BRA.S   .parse_next_byte_loop

.branch_1:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     ESQIFF_ParseField0Buffer,A0
    ADDA.L  D0,A0
    ADDA.W  D5,A0
    CLR.B   (A0)
    TST.L   -8(A5)
    BNE.S   .branch_4

    TST.W   -14(A5)
    BNE.S   .branch_3

    LEA     ESQIFF_ParseField0Buffer,A0
    LEA     ESQIFF_ParseField3Buffer,A1

.branch_2:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .branch_2

.branch_3:
    MOVEQ   #0,D0
    MOVE.B  D0,ESQIFF_ParseField0TailBuffer
    MOVE.B  D0,ESQIFF_ParseField1TailByte
    MOVE.B  D0,ESQIFF_ParseField3TailBuffer
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    PEA     ESQIFF_ParseField3Buffer
    PEA     ESQIFF_ParseField2Buffer
    PEA     ESQIFF_ParseField1Buffer
    PEA     ESQIFF_ParseField0Buffer
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQSHARED_CreateGroupEntryAndTitle(PC)

    LEA     24(A7),A7
    MOVEQ   #0,D0
    MOVE.W  D0,-14(A5)
    BRA.S   .branch_5

.branch_4:
    CLR.L   -8(A5)

.branch_5:
    MOVEQ   #0,D0
    MOVE.B  D0,ESQIFF_ParseField0Buffer
    MOVE.B  D0,ESQIFF_ParseField1Buffer
    MOVEQ   #0,D5

.branch_6:
    MOVEQ   #6,D0
    CMP.W   D0,D5
    BGE.S   .branch_7

    LEA     ESQIFF_ParseField2Buffer,A0
    ADDA.W  D5,A0
    MOVE.B  #$ff,(A0)
    ADDQ.W  #1,D5
    BRA.S   .branch_6

.branch_7:
    CLR.B   ESQIFF_ParseField3Buffer
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
    BSR.W   ESQIFF2_ValidateFieldIndexAndLength

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .branch_8

    MOVEQ   #1,D0
    MOVE.L  D0,-12(A5)
    BRA.W   .parse_next_byte_loop

.branch_8:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     ESQIFF_ParseField0Buffer,A0
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
    BSR.W   ESQIFF2_ValidateFieldIndexAndLength

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .branch_9

    MOVEQ   #1,D0
    MOVE.L  D0,-12(A5)
    BRA.W   .parse_next_byte_loop

.branch_9:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     ESQIFF_ParseField0Buffer,A0
    ADDA.L  D0,A0
    ADDA.W  D5,A0
    CLR.B   (A0)
    MOVEQ   #0,D5

.branch_10:
    MOVEQ   #6,D0
    CMP.W   D0,D5
    BGE.W   .parse_next_byte_loop

    LEA     ESQIFF_ParseField2Buffer,A0
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
    BSR.W   ESQIFF2_ValidateFieldIndexAndLength

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
    LEA     ESQIFF_ParseField0Buffer,A0
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
    BSR.W   ESQIFF2_ValidateFieldIndexAndLength

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .branch_13

    MOVEQ   #1,D0
    MOVE.L  D0,-12(A5)
    BRA.W   .parse_next_byte_loop

.branch_13:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     ESQIFF_ParseField0Buffer,A0
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
    BSR.W   ESQIFF2_ValidateFieldIndexAndLength

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .branch_14

    MOVEQ   #0,D0
    BRA.S   ESQIFF2_ParseGroupRecordAndRefresh_Return

.branch_14:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     ESQIFF_ParseField0Buffer,A0
    ADDA.L  D0,A0
    ADDA.W  D5,A0
    MOVEQ   #0,D0
    MOVE.B  D0,(A0)
    MOVE.B  D0,ESQIFF_ParseField0TailBuffer
    MOVE.B  D0,ESQIFF_ParseField1TailByte
    MOVE.B  D0,ESQIFF_ParseField3TailBuffer
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    PEA     ESQIFF_ParseField3Buffer
    PEA     ESQIFF_ParseField2Buffer
    PEA     ESQIFF_ParseField1Buffer
    PEA     ESQIFF_ParseField0Buffer
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQSHARED_CreateGroupEntryAndTitle(PC)

    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,(A7)
    BSR.W   ESQIFF2_PadEntriesToMaxTitleWidth

    JSR     ESQPARS_JMPTBL_TEXTDISP_ApplySourceConfigAllEntries(PC)

    JSR     ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache(PC)

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
;   Restores frame/registers and returns from ESQIFF2_ParseGroupRecordAndRefresh.
; NOTES:
;   Shared tail for both no-op and full-refresh paths.
;------------------------------------------------------------------------------
ESQIFF2_ParseGroupRecordAndRefresh_Return:
    MOVEM.L -44(A5),D2/D4-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ValidateFieldIndexAndLength   (Validate group-record field index/length bounds)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D6/D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Validates parser field index (0..3) and per-field text length bounds.
; NOTES:
;   Field index 1 allows up to 10 chars; all other fields allow up to 7.
;------------------------------------------------------------------------------
ESQIFF2_ValidateFieldIndexAndLength:
    MOVEM.L D6-D7,-(A7)
    MOVE.W  14(A7),D7
    MOVE.W  18(A7),D6
    MOVEQ   #3,D0
    CMP.W   D0,D7
    BLE.S   .validate_field_length_bound

    MOVEQ   #0,D0
    BRA.S   ESQIFF2_ValidateFieldIndexAndLength_Return

.validate_field_length_bound:
    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   .validate_non_field1_length

    MOVEQ   #10,D0
    CMP.W   D0,D6
    BLE.S   .return_valid_field_bounds

    MOVEQ   #0,D0
    BRA.S   ESQIFF2_ValidateFieldIndexAndLength_Return

.validate_non_field1_length:
    MOVEQ   #7,D0
    CMP.W   D0,D6
    BLE.S   .return_valid_field_bounds

    MOVEQ   #0,D0
    BRA.S   ESQIFF2_ValidateFieldIndexAndLength_Return

.return_valid_field_bounds:
    MOVEQ   #1,D0

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ValidateFieldIndexAndLength_Return   (Return tail for field index/length validator)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D6
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Restores D6-D7 and returns validation result in D0.
; NOTES:
;   Shared tail for all bounds-check branches.
;------------------------------------------------------------------------------
ESQIFF2_ValidateFieldIndexAndLength_Return:
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_PadEntriesToMaxTitleWidth   (Pad entry labels to max title width for selected group)
; ARGS:
;   stack +7: arg_1 (via 11(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +20: arg_3 (via 24(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   GROUP_AR_JMPTBL_STRING_AppendAtNull
; READS:
;   TEXTDISP_SecondaryGroupCode, TEXTDISP_SecondaryGroupEntryCount, TEXTDISP_PrimaryGroupCode, TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryEntryPtrTable, TEXTDISP_SecondaryEntryPtrTable, TEXTDISP_MaxEntryTitleLength
; WRITES:
;   (none observed)
; DESC:
;   For each entry in the selected group, computes current title length and appends
;   spaces so titles reach TEXTDISP_MaxEntryTitleLength.
; NOTES:
;   Uses a stack-local space buffer and GROUP_AR_JMPTBL_STRING_AppendAtNull.
;------------------------------------------------------------------------------
ESQIFF2_PadEntriesToMaxTitleWidth:
    LINK.W  A5,#-24
    MOVEM.L D4-D7,-(A7)
    MOVE.B  11(A5),D7
    MOVE.B  TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D7,D0
    BNE.S   .check_primary_group_match

    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    MOVE.W  D0,-12(A5)
    BRA.S   .start_entry_padding_loop

.check_primary_group_match:
    MOVE.B  TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   .return_group_not_matched

    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.W  D0,-12(A5)
    BRA.S   .start_entry_padding_loop

.return_group_not_matched:
    MOVEQ   #0,D0
    BRA.W   ESQIFF2_PadEntriesToMaxTitleWidth_Return

.start_entry_padding_loop:
    MOVEQ   #0,D6

.loop_entries_for_padding:
    CMP.W   -12(A5),D6
    BGE.W   ESQIFF2_PadEntriesToMaxTitleWidth_Return

    MOVE.B  TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   .load_primary_entry_pointer

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    BRA.S   .measure_current_title_length

.load_primary_entry_pointer:
    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)

.measure_current_title_length:
    MOVEA.L -4(A5),A0
    ADDQ.L  #1,A0
    MOVEA.L A0,A1

.loop_find_title_nul:
    TST.B   (A1)+
    BNE.S   .loop_find_title_nul

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.W  TEXTDISP_MaxEntryTitleLength,D0
    EXT.L   D0
    MOVE.L  A1,D1
    SUB.L   D1,D0
    MOVE.L  D0,D4
    TST.W   D4
    BLE.S   .next_entry_after_padding

    MOVEQ   #0,D5

.loop_fill_space_buffer:
    MOVEQ   #10,D0
    CMP.W   D0,D5
    BGE.S   .append_space_buffer

    MOVE.B  #$20,-24(A5,D5.W)
    ADDQ.W  #1,D5
    BRA.S   .loop_fill_space_buffer

.append_space_buffer:
    CLR.B   -24(A5,D4.W)
    MOVEA.L -4(A5),A0
    ADDQ.L  #1,A0
    MOVE.L  A0,-(A7)
    PEA     -24(A5)
    JSR     GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    MOVEA.L -4(A5),A0
    ADDQ.L  #1,A0
    LEA     -24(A5),A1

.copy_padded_title_back:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .copy_padded_title_back

.next_entry_after_padding:
    ADDQ.W  #1,D6
    BRA.W   .loop_entries_for_padding

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_PadEntriesToMaxTitleWidth_Return   (Return tail for title-padding helper)
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
;   Restores D4-D7/frame and returns from title-padding helper.
; NOTES:
;   Shared return for unmatched-group and loop-complete paths.
;------------------------------------------------------------------------------
ESQIFF2_PadEntriesToMaxTitleWidth_Return:
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ReadSerialBytesToBuffer   (Read N serial bytes into buffer)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A3/A7/D6/D7
; CALLS:
;   ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte, ESQFUNC_WaitForClockChangeAndServiceUi
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Reads a fixed byte count from serial input (with UI service wait) and writes
;   bytes sequentially into the destination buffer.
; NOTES:
;   Returns end pointer (one past last written byte) in D0.
;------------------------------------------------------------------------------
ESQIFF2_ReadSerialBytesToBuffer:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.W  30(A7),D7
    MOVEQ   #0,D6

.loop_read_serial_byte_to_buffer:
    CMP.W   D7,D6
    BGE.S   ESQIFF2_ReadSerialBytesToBuffer_Return

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVEA.L A3,A0
    ADDQ.L  #1,A3
    MOVE.L  A0,12(A7)
    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVEA.L 12(A7),A0
    MOVE.B  D0,(A0)
    ADDQ.W  #1,D6
    BRA.S   .loop_read_serial_byte_to_buffer

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ReadSerialBytesToBuffer_Return   (Return tail for serial byte block reader)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D6
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Returns updated destination pointer in D0 and restores saved registers/frame.
; NOTES:
;   Shared return for loop-complete path.
;------------------------------------------------------------------------------
ESQIFF2_ReadSerialBytesToBuffer_Return:
    MOVE.L  A3,D0
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ReadSerialBytesWithXor   (Read serial bytes and fold XOR checksum)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A2/A3/A7/D6/D7
; CALLS:
;   ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte, ESQFUNC_WaitForClockChangeAndServiceUi
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Reads N serial bytes into a destination buffer and XOR-accumulates them into
;   the caller-provided checksum byte pointer.
; NOTES:
;   Waits for clock/UI service between each byte read.
;------------------------------------------------------------------------------
ESQIFF2_ReadSerialBytesWithXor:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVEA.L 28(A7),A2
    MOVEQ   #0,D6

.loop_read_serial_byte_with_xor:
    CMP.W   D7,D6
    BGE.S   ESQIFF2_ReadSerialBytesWithXor_Return

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,(A3)
    ADDQ.L  #1,A3
    EOR.B   D0,(A2)
    ADDQ.W  #1,D6
    BRA.S   .loop_read_serial_byte_with_xor

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ReadSerialBytesWithXor_Return   (Return tail for serial+xor reader)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D6
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Returns end pointer in D0 and restores registers after XOR-fold read loop.
; NOTES:
;   Shared return for read-count completion.
;------------------------------------------------------------------------------
ESQIFF2_ReadSerialBytesWithXor_Return:
    MOVE.L  A3,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ReadSerialRecordIntoBuffer   (Read serial record with delimiter handling)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +10: arg_2 (via 14(A5))
;   stack +14: arg_3 (via 18(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte, ESQFUNC_WaitForClockChangeAndServiceUi
; READS:
;   (none observed)
; WRITES:
;   ESQIFF_RecordChecksumByte
; DESC:
;   Reads a serial record into buffer until NUL or guard limits, with optional
;   handling of 0x14/0x12 escaped segments, then reads trailing checksum byte.
; NOTES:
;   Writes ESQIFF_RecordChecksumByte and returns payload length in D0.
;------------------------------------------------------------------------------
ESQIFF2_ReadSerialRecordIntoBuffer:
    LINK.W  A5,#-12
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.W  18(A5),D6
    MOVEQ   #0,D4
    MOVE.W  D4,-6(A5)

.loop_read_record_body:
    CMPI.W  #$2328,D4
    BCC.W   .read_and_store_trailing_checksum

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVE.L  D0,20(A7)
    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    TST.B   D0
    BNE.S   .check_escape_or_delimiter_bytes

    TST.W   D7
    BNE.S   .guard_short_record_terminator

    BRA.W   .read_and_store_trailing_checksum

.guard_short_record_terminator:
    MOVEQ   #1,D0
    CMP.W   D0,D4
    BHI.W   .read_and_store_trailing_checksum

.check_escape_or_delimiter_bytes:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVEQ   #20,D1
    CMP.B   0(A3,D0.L),D1
    BNE.S   .check_0x12_delimiter_case

    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   .check_0x12_delimiter_case

    ADDQ.W  #1,D4
    MOVEQ   #0,D5

.loop_copy_0x14_extension:
    CMP.W   D6,D5
    BCC.S   .loop_read_record_body

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVE.L  D4,D0
    ADDQ.W  #1,D4
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,20(A7)
    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    ADDQ.W  #1,D5
    BRA.S   .loop_copy_0x14_extension

.check_0x12_delimiter_case:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVEQ   #18,D1
    CMP.B   0(A3,D0.L),D1
    BNE.S   .advance_record_offset

    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   .advance_record_offset

    ADDQ.W  #1,D4
    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVE.L  D4,D0
    ADDQ.W  #1,D4
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,20(A7)
    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    ADDQ.W  #1,-6(A5)
    CMPI.W  #$12e,-6(A5)
    BCS.W   .loop_read_record_body

    MOVEQ   #0,D0
    BRA.S   ESQIFF2_ReadSerialRecordIntoBuffer_Return

.advance_record_offset:
    ADDQ.W  #1,D4
    BRA.W   .loop_read_record_body

.read_and_store_trailing_checksum:
    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,ESQIFF_RecordChecksumByte
    MOVE.L  D4,D0

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ReadSerialRecordIntoBuffer_Return   (Return tail for serial record reader)
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
;   Restores frame/registers and returns payload length/status in D0.
; NOTES:
;   Shared return after guard failures, normal terminator, or extension-limit hit.
;------------------------------------------------------------------------------
ESQIFF2_ReadSerialRecordIntoBuffer_Return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ReadSerialSizedTextRecord   (Read sized serial text record with trailer validation)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte, ESQFUNC_WaitForClockChangeAndServiceUi
; READS:
;   (none observed)
; WRITES:
;   ESQIFF_RecordChecksumByte
; DESC:
;   Reads an initial sized text payload, parses a following signed trailer length,
;   reads that many trailing bytes, then validates completion before consuming and
;   storing the trailing checksum byte.
; NOTES:
;   Returns 0 and clears destination when trailer validation fails.
;------------------------------------------------------------------------------
ESQIFF2_ReadSerialSizedTextRecord:
    LINK.W  A5,#-4
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 32(A7),A3
    MOVE.L  36(A7),D7
    TST.L   D7
    BLE.S   .reject_invalid_size

    CMPI.L  #$2328,D7
    BLT.S   .begin_initial_payload_read

.reject_invalid_size:
    MOVEQ   #0,D0
    BRA.W   ESQIFF2_ReadSerialSizedTextRecord_Return

.begin_initial_payload_read:
    MOVEQ   #0,D6
    MOVEQ   #0,D4

.loop_read_initial_payload:
    CMP.L   D7,D6
    BGE.S   .parse_trailer_length

    CMPI.L  #$2328,D6
    BGE.S   .parse_trailer_length

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVE.L  D0,20(A7)
    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    ADDQ.L  #1,D6
    ADDQ.W  #1,D4
    BRA.S   .loop_read_initial_payload

.parse_trailer_length:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    CLR.B   0(A3,D0.L)
    MOVE.L  A3,-(A7)
    JSR     ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVE.B  #$20,0(A3,D0.L)
    MOVEQ   #0,D6

.loop_read_trailer_bytes:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    TST.B   -1(A3,D0.L)
    BEQ.S   .validate_trailer_completion

    CMP.L   D5,D6
    BGE.S   .validate_trailer_completion

    CMPI.W  #$2328,D4
    BCC.S   .validate_trailer_completion

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVE.L  D0,20(A7)
    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    ADDQ.L  #1,D6
    ADDQ.W  #1,D4
    BRA.S   .loop_read_trailer_bytes

.validate_trailer_completion:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    TST.B   -1(A3,D0.L)
    BNE.S   .fail_trailer_validation

    CMP.L   D5,D6
    BEQ.S   .read_trailing_checksum

.fail_trailer_validation:
    MOVEQ   #0,D4
    CLR.B   (A3)
    BRA.S   .finish_sized_record_read

.read_trailing_checksum:
    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,ESQIFF_RecordChecksumByte

.finish_sized_record_read:
    MOVE.L  D4,D0

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ReadSerialSizedTextRecord_Return   (Return tail for sized text serial reader)
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
;   Restores frame/registers and returns final text length/status.
; NOTES:
;   Shared return for reject, success, and validation-failure paths.
;------------------------------------------------------------------------------
ESQIFF2_ReadSerialSizedTextRecord_Return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ShowVersionMismatchOverlay   (Validate version and draw mismatch overlay)
; ARGS:
;   stack +36: arg_1 (via 40(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D2/D3
; CALLS:
;   ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition, ESQSHARED_JMPTBL_ESQ_WildcardMatch, GCOMMAND_SeedBannerFromPrefs, GROUP_AM_JMPTBL_WDISP_SPrintf, GROUP_AR_JMPTBL_STRING_AppendAtNull, _LVODisable, _LVOEnable, _LVORectFill, _LVOSetAPen
; READS:
;   AbsExecBase, Global_LONG_PATCH_VERSION_NUMBER, Global_REF_696_400_BITMAP, Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, Global_STR_APOSTROPHE, Global_STR_MAJOR_MINOR_VERSION_1, Global_STR_MAJOR_MINOR_VERSION_2, ESQIFF2_ShowVersionMismatchOverlay_Return, DATA_ESQIFF_FMT_PCT_S_DOT_PCT_LD_1EFA, DATA_ESQIFF_STR_INCORRECT_VERSION_PLEASE_CORRECT_ASA_1EFC, DATA_ESQIFF_FMT_YOUR_VERSION_IS_PCT_S_DOT_PCT_LD_1EFD, DATA_ESQIFF_STR_CORRECT_VERSION_IS_1EFF, ED_DiagnosticsScreenActive, Global_UIBusyFlag, ESQIFF_RecordBufferPtr, lab_0B24
; WRITES:
;   ESQPARS2_ReadModeFlags, ED_DiagnosticsScreenActive
; DESC:
;   Compares incoming version text against the local major/minor string and, on
;   mismatch, draws a blocking correction overlay with current/correct versions.
; NOTES:
;   Skips drawing when UI is busy and diagnostics screen is inactive.
;------------------------------------------------------------------------------
ESQIFF2_ShowVersionMismatchOverlay:
    LINK.W  A5,#-40
    MOVEM.L D2-D3,-(A7)

    MOVEA.L ESQIFF_RecordBufferPtr,A0
    CLR.B   20(A0)
    MOVE.L  Global_LONG_PATCH_VERSION_NUMBER,-(A7)
    PEA     Global_STR_MAJOR_MINOR_VERSION_1
    PEA     DATA_ESQIFF_FMT_PCT_S_DOT_PCT_LD_1EFA
    PEA     -40(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L ESQIFF_RecordBufferPtr,A0
    ADDQ.L  #1,A0
    MOVE.L  A0,(A7)
    PEA     -40(A5)
    JSR     ESQSHARED_JMPTBL_ESQ_WildcardMatch(PC)

    LEA     20(A7),A7
    TST.B   D0
    BEQ.W   ESQIFF2_ShowVersionMismatchOverlay_Return

    TST.W   Global_UIBusyFlag
    BEQ.S   .lab_0B23

    TST.W   ED_DiagnosticsScreenActive
    BEQ.W   ESQIFF2_ShowVersionMismatchOverlay_Return

.lab_0B23:
    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVE.W  #$100,ESQPARS2_ReadModeFlags
    JSR     GCOMMAND_SeedBannerFromPrefs(PC)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

    MOVEA.L Global_REF_RASTPORT_1,A0
    MOVE.L  #Global_REF_696_400_BITMAP,4(A0)
    CLR.W   ED_DiagnosticsScreenActive
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEQ   #60,D1
    MOVE.L  #679,D2
    MOVEQ   #100,D3
    NOT.B   D3
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    PEA     DATA_ESQIFF_STR_INCORRECT_VERSION_PLEASE_CORRECT_ASA_1EFC
    PEA     90.W
    PEA     30.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  Global_LONG_PATCH_VERSION_NUMBER,(A7)
    PEA     Global_STR_MAJOR_MINOR_VERSION_2
    PEA     DATA_ESQIFF_FMT_YOUR_VERSION_IS_PCT_S_DOT_PCT_LD_1EFD
    PEA     -40(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -40(A5)
    PEA     120.W
    PEA     30.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     DATA_ESQIFF_STR_CORRECT_VERSION_IS_1EFF,A0
    LEA     -40(A5),A1
    MOVEQ   #4,D0

; Concatenate a string with an apostrophe before displaying
; the text at a 30,150
.lab_0B24:
    MOVE.L  (A0)+,(A1)+ ; Iterate copying A0 into A1 and...
    DBF     D0,.lab_0B24 ; incrementing both until A0 is null.

    CLR.B   (A1)
    MOVEA.L ESQIFF_RecordBufferPtr,A0
    ADDQ.L  #1,A0
    MOVE.L  A0,(A7)
    PEA     -40(A5)
    JSR     GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    PEA     Global_STR_APOSTROPHE
    PEA     -40(A5)
    JSR     GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    PEA     -40(A5)
    PEA     150.W
    PEA     30.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     72(A7),A7

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ShowVersionMismatchOverlay_Return   (Return tail for mismatch overlay)
; ARGS:
;   (none observed)
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
;   Shared return tail for ESQIFF2_ShowVersionMismatchOverlay.
; NOTES:
;   Restores D2-D3 and frame state before returning.
;------------------------------------------------------------------------------
ESQIFF2_ShowVersionMismatchOverlay_Return:
    MOVEM.L (A7)+,D2-D3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ShowAttentionOverlay   (Draw attention/error overlay by code)
; ARGS:
;   stack +7: arg_1 (via 11(A5))
;   stack +124: arg_2 (via 128(A5))
;   stack +134: arg_3 (via 138(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex, ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition, GCOMMAND_SeedBannerFromPrefs, GROUP_AM_JMPTBL_WDISP_SPrintf, _LVODisable, _LVOEnable, _LVORectFill, _LVOSetAPen, _LVOSetDrMd
; READS:
;   AbsExecBase, BRUSH_SnapshotDepth, BRUSH_SnapshotHeader, BRUSH_SnapshotWidth, Global_STR_PLEASE_STANDBY_2, Global_REF_696_400_BITMAP, Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, Global_STR_ATTENTION_SYSTEM_ENGINEER_2, Global_STR_FILE_PERCENT_S, Global_STR_FILE_WIDTH_COLORS_FORMATTED, Global_STR_PRESS_ESC_TWICE_TO_RESUME_SCROLL, Global_STR_REPORT_ERROR_CODE_FORMATTED, ESQIFF2_ShowAttentionOverlay_Return, ED_DiagnosticsScreenActive, Global_UIBusyFlag, lab_0B28, lab_0B29_0008, lab_0B29_000C, lab_0B29_0010, lab_0B29_0014, lab_0B29_0018
; WRITES:
;   DATA_COI_BSS_WORD_1B85, ESQPARS2_ReadModeFlags, ED_DiagnosticsScreenActive
; DESC:
;   Draws a modal attention overlay with an error code and file context, then
;   restores raster draw mode/bitmap state before returning.
; NOTES:
;   Maps incoming code 1..5 to report codes {1,2,8,9,10}; exits early otherwise.
;------------------------------------------------------------------------------
ESQIFF2_ShowAttentionOverlay:
    LINK.W  A5,#-140
    MOVEM.L D2-D3/D5-D7,-(A7)
    MOVE.B  11(A5),D7
    MOVEQ   #-1,D5
    TST.W   Global_UIBusyFlag
    BEQ.S   .lab_0B27

    TST.W   ED_DiagnosticsScreenActive
    BEQ.W   ESQIFF2_ShowAttentionOverlay_Return

.lab_0B27:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    SUBQ.W  #1,D0
    BLT.S   .lab_0B2A

    CMPI.W  #5,D0
    BGE.S   .lab_0B2A

    ADD.W   D0,D0
    MOVE.W  .lab_0B28(PC,D0.W),D0
    JMP     .lab_0B28+2(PC,D0.W)

; switch/jumptable
.lab_0B28:
    DC.W    .lab_0B29_0008-.lab_0B28-2
    DC.W    .lab_0B29_000C-.lab_0B28-2
    DC.W    .lab_0B29_0010-.lab_0B28-2
    DC.W    .lab_0B29_0014-.lab_0B28-2
    DC.W    .lab_0B29_0018-.lab_0B28-2

.lab_0B29_0008:
    MOVEQ   #1,D5
    BRA.S   .lab_0B2A

.lab_0B29_000C:
    MOVEQ   #2,D5
    BRA.S   .lab_0B2A

.lab_0B29_0010:
    MOVEQ   #8,D5
    BRA.S   .lab_0B2A

.lab_0B29_0014:
    MOVEQ   #9,D5
    BRA.S   .lab_0B2A

.lab_0B29_0018:
    MOVEQ   #10,D5

.lab_0B2A:
    TST.L   D5
    BLE.W   ESQIFF2_ShowAttentionOverlay_Return

    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVE.W  #$100,ESQPARS2_ReadModeFlags
    JSR     GCOMMAND_SeedBannerFromPrefs(PC)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

    MOVEA.L Global_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-138(A5)
    MOVE.L  #Global_REF_696_400_BITMAP,4(A0)
    CLR.W   ED_DiagnosticsScreenActive
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEQ   #65,D1
    MOVE.L  #$2ac,D2
    MOVEQ   #40,D3
    NOT.B   D3
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A0
    MOVE.B  28(A0),D6
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    PEA     Global_STR_PLEASE_STANDBY_2
    PEA     90.W
    PEA     35.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_ATTENTION_SYSTEM_ENGINEER_2
    PEA     120.W
    PEA     35.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  D5,(A7)
    PEA     Global_STR_REPORT_ERROR_CODE_FORMATTED
    PEA     -128(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -128(A5)
    PEA     150.W
    PEA     35.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     56(A7),A7
    MOVEQ   #9,D0
    CMP.L   D0,D5
    BEQ.S   .lab_0B2B

    MOVEQ   #10,D0
    CMP.L   D0,D5
    BNE.S   .lab_0B2C

.lab_0B2B:
    MOVE.L  BRUSH_SnapshotDepth,-(A7)   ; reuse cached brush dimensions in file dialog
    JSR     ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    MOVE.L  D0,(A7)
    MOVE.L  BRUSH_SnapshotWidth,-(A7)
    PEA     BRUSH_SnapshotHeader
    PEA     Global_STR_FILE_WIDTH_COLORS_FORMATTED
    PEA     -128(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     20(A7),A7
    MOVE.W  #1,DATA_COI_BSS_WORD_1B85
    BRA.S   .lab_0B2D

.lab_0B2C:
    PEA     BRUSH_SnapshotHeader
    PEA     Global_STR_FILE_PERCENT_S
    PEA     -128(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     12(A7),A7

.lab_0B2D:
    PEA     -128(A5)
    PEA     180.W
    PEA     35.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_PRESS_ESC_TWICE_TO_RESUME_SCROLL
    PEA     210.W
    PEA     35.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7
    MOVE.L  D6,D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L Global_REF_RASTPORT_1,A0
    MOVE.L  -138(A5),4(A0)

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ShowAttentionOverlay_Return   (Return tail for attention overlay)
; ARGS:
;   (none observed)
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
;   Shared return tail for ESQIFF2_ShowAttentionOverlay.
; NOTES:
;   Restores D2-D3/D5-D7 and frame state before returning.
;------------------------------------------------------------------------------
ESQIFF2_ShowAttentionOverlay_Return:
    MOVEM.L (A7)+,D2-D3/D5-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ClearPrimaryEntryFlags34To39   (Clear primary entry flag bytes 34..39)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A5/A7/D0/D6/D7
; CALLS:
;   (none)
; READS:
;   TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryEntryPtrTable
; WRITES:
;   (none observed)
; DESC:
;   Iterates primary entries and clears six contiguous per-entry flag bytes
;   at offsets 34 through 39.
; NOTES:
;   Inner loop runs 6 iterations per primary entry.
;------------------------------------------------------------------------------
ESQIFF2_ClearPrimaryEntryFlags34To39:
    LINK.W  A5,#-8
    MOVEM.L D6-D7,-(A7)
    MOVEQ   #0,D7

.lab_0B30:
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.W   D0,D7
    BGE.S   ESQIFF2_ClearPrimaryEntryFlags34To39_Return

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    MOVEQ   #0,D6

.lab_0B31:
    MOVEQ   #6,D0
    CMP.W   D0,D6
    BGE.S   .lab_0B32

    MOVEA.L -4(A5),A0
    CLR.B   34(A0,D6.W)
    ADDQ.W  #1,D6
    BRA.S   .lab_0B31

.lab_0B32:
    ADDQ.W  #1,D7
    BRA.S   .lab_0B30

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ClearPrimaryEntryFlags34To39_Return   (Return tail for primary flag-clear helper)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D6
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Restores D6-D7/frame and returns from flag-clear helper.
; NOTES:
;   Shared return after outer loop completes.
;------------------------------------------------------------------------------
ESQIFF2_ClearPrimaryEntryFlags34To39_Return:
    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS
