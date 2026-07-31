    XDEF    ESQPARS_ApplyRtcBytesAndPersist
    XDEF    _ESQPARS_ConsumeRbfByteAndDispatchCommand



;------------------------------------------------------------------------------
; FUNC: ESQPARS_ApplyRtcBytesAndPersist   (Apply incoming RTC bytes and persist globals)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +8: arg_3 (via 12(A5))
;   stack +10: arg_4 (via 14(A5))
;   stack +12: arg_5 (via 16(A5))
;   stack +14: arg_6 (via 18(A5))
;   stack +16: arg_7 (via 20(A5))
;   stack +18: arg_8 (via 22(A5))
;   stack +20: arg_9 (via 24(A5))
;   stack +28: arg_10 (via 32(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A5/A7/D0/D7
; CALLS:
;   ESQPARS_JMPTBL_PARSEINI_WriteRtcFromGlobals, ESQDISP_NormalizeClockAndRedrawBanner
; READS:
;   _ESQPARS2_ReadModeFlags
; WRITES:
;   _ESQPARS2_ReadModeFlags
; DESC:
;   Loads RTC bytes from the incoming command payload into stack temporaries,
;   persists them through PARSEINI, then normalizes/redraws clock display state.
; NOTES:
;   year byte is converted to full year by adding 1900 before persisting.
;------------------------------------------------------------------------------
ESQPARS_ApplyRtcBytesAndPersist:
    LINK.W  A5,#-24
    MOVEM.L D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.B  (A3),D0
    EXT.W   D0
    MOVE.W  D0,-24(A5)
    MOVE.B  1(A3),D0
    EXT.W   D0
    MOVE.W  D0,-22(A5)
    MOVE.B  2(A3),D0
    EXT.W   D0
    MOVE.W  D0,-20(A5)
    MOVE.B  3(A3),D0
    EXT.W   D0
    EXT.L   D0
    ADDI.L  #1900,D0
    MOVE.W  D0,-18(A5)
    MOVE.B  4(A3),D0
    EXT.W   D0
    MOVE.W  D0,-16(A5)
    MOVE.B  5(A3),D0
    EXT.W   D0
    MOVE.W  D0,-14(A5)
    MOVE.B  6(A3),D0
    EXT.W   D0
    MOVE.W  D0,-12(A5)
    MOVE.B  7(A3),D0
    EXT.W   D0
    MOVE.W  D0,-10(A5)
    PEA     -24(A5)
    JSR     ESQDISP_NormalizeClockAndRedrawBanner(PC)

    MOVE.W  _ESQPARS2_ReadModeFlags,D7
    MOVE.W  #256,_ESQPARS2_ReadModeFlags
    JSR     ESQPARS_JMPTBL_PARSEINI_WriteRtcFromGlobals(PC)

    MOVE.W  D7,_ESQPARS2_ReadModeFlags

    MOVEM.L -32(A5),D7/A3
    UNLK    A5
    RTS

;!======

; This whole sub-routine appears to be for processing control data
;------------------------------------------------------------------------------
; Protocol Path Map (handshake/control -> serial byte stream -> command decode)
; 1) Startup serial init/config:
;      ESQ startup opens serial.device, sets baud, and enables RBF/AUD1 IRQ paths
;      (src/modules/groups/a/m/esq.s: .select_baud_rate/.after_baud_rate).
; 2) Handshake/control sideband handling:
;      SCRIPT_Assert/DeassertCtrlLine* and SCRIPT_ReadCiaBBit{3,5}* manage
;      CTRL/handshake state via SERDAT shadow + CIAB reads
;      (src/modules/groups/b/a/script2.s).
; 3) Byte ingress source:
;      Incoming serial bytes are consumed through _SCRIPT_ReadNextRbfByte
;      (RBF-backed producer/consumer path).
; 4) Command framing:
;      _ESQPARS_ConsumeRbfByteAndDispatchCommand applies 0x55/0xAA preamble sync and
;      command-byte dispatch.
; 5) Payload readers:
;      ESQIFF2_ReadRbfBytesToBuffer / ESQIFF2_ReadRbfBytesWithXor /
;      _ESQIFF2_ReadSerialRecordIntoBuffer read payload blocks from the same byte
;      stream and feed command handlers.
; 6) Custom-build hook guidance:
;      To reuse the standard 2400 protocol decode path, keep steps 4/5 intact and
;      adapt only step 2/3 so equivalent byte sequences reach _SCRIPT_ReadNextRbfByte.
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
; FUNC: _ESQPARS_ConsumeRbfByteAndDispatchCommand   (Parse one serial command byte stream)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +5: arg_2 (via 9(A5))
;   stack +6: arg_3 (via 10(A5))
;   stack +10: arg_4 (via 14(A5))
;   stack +14: arg_5 (via 18(A5))
;   stack +18: arg_6 (via 22(A5))
;   stack +22: arg_7 (via 26(A5))
;   stack +26: arg_8 (via 30(A5))
;   stack +27: arg_9 (via 31(A5))
;   stack +32: arg_10 (via 36(A5))
;   stack +37: arg_11 (via 41(A5))
;   stack +38: arg_12 (via 42(A5))
;   stack +57: arg_13 (via 61(A5))
;   stack +58: arg_14 (via 62(A5))
;   stack +62: arg_15 (via 66(A5))
;   stack +66: arg_16 (via 70(A5))
;   stack +67: arg_17 (via 71(A5))
;   stack +68: arg_18 (via 72(A5))
;   stack +206: arg_19 (via 210(A5))
;   stack +207: arg_20 (via 211(A5))
;   stack +208: arg_21 (via 212(A5))
;   stack +209: arg_22 (via 213(A5))
;   stack +214: arg_23 (via 218(A5))
;   stack +218: arg_24 (via 222(A5))
;   stack +219: arg_25 (via 223(A5))
;   stack +220: arg_26 (via 224(A5))
;   stack +221: arg_27 (via 225(A5))
;   stack +222: arg_28 (via 226(A5))
;   stack +223: arg_29 (via 227(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_MATH_Mulu32, ESQPARS_JMPTBL_CLEANUP_ParseAlignedListingBlock, _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition, ESQPARS_JMPTBL_DST_HandleBannerCommand32_33, ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte, ESQPARS_JMPTBL_DISKIO_ParseConfigBuffer, ESQPARS_JMPTBL_DISKIO_SaveConfigToFileHandle, ESQPARS_JMPTBL_DISKIO2_HandleInteractiveFileTransfer, ESQPARS_JMPTBL_P_TYPE_ParseAndStoreTypeRecord, ESQPARS_JMPTBL_PARSEINI_HandleFontCommand, _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte, ESQPARS_JMPTBL_ESQPROTO_CopyLabelToGlobal, ESQPARS_JMPTBL_ESQPROTO_ParseDigitLabelAndDisplay, ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseList, ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseRecord, ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes, ESQSHARED_JMPTBL_ESQ_TestBit1Based, _ESQ_PollCtrlInput, GCOMMAND_ParseCommandOptions, GCOMMAND_ParseCommandString, GCOMMAND_ParsePPVCommand, _GROUP_AM_JMPTBL_WDISP_SPrintf, _GROUP_AS_JMPTBL_STR_FindCharPtr, GROUP_AW_JMPTBL_DISPLIB_DisplayTextAtPosition, _ESQDISP_UpdateStatusMaskAndRefresh, ESQDISP_ParseProgramInfoCommandRecord, _ESQDISP_GetEntryPointerByMode, _ESQDISP_GetEntryAuxPointerByMode, _ESQFUNC_WaitForClockChangeAndServiceUi, ESQIFF2_ApplyIncomingStatusPacket, ESQIFF2_ParseLineHeadTailRecord, ESQIFF2_ParseGroupRecordAndRefresh, ESQIFF2_ReadRbfBytesToBuffer, ESQIFF2_ReadRbfBytesWithXor, _ESQIFF2_ReadSerialRecordIntoBuffer, _ESQIFF2_ReadSerialSizedTextRecord, ESQIFF2_ShowVersionMismatchOverlay, ESQIFF2_ClearPrimaryEntryFlags34To39, _ESQPARS_ReplaceOwnedString, ESQPARS_ApplyRtcBytesAndPersist, _ESQPARS_ReadLengthWordWithChecksumXor, _ESQPARS_PersistStateDataAfterCommand, ESQSHARED_ParseCompactEntryRecord, _ESQSHARED_MatchSelectionCodeWithOptionalSuffix, LOCAVAIL_ParseFilterStateFromBuffer, LADFUNC_ParseBannerEntryData
; READS:
;   _CTRL_BUFFER, _CTRL_H, _DATACErrs, _Global_REF_696_400_BITMAP, _Global_REF_RASTPORT_1, ESQPARS_BannerSubcommandSet, Global_STR_RESET_COMMAND_RECEIVED, _CTASKS_STR_1, ESQPARS_PersistOnNextBoxOffFlag, _DISKIO2_InteractiveTransferArmedFlag, _ESQPARS_SelectionSuffixBuffer, _ESQIFF_StatusPacketReadyFlag, _ESQPARS_SelectionMatchCode, _ED_DiagnosticsViewMode, _ESQIFF_RecordBufferPtr, _ESQIFF_RecordChecksumByte, _ESQIFF_RecordLength, _ESQIFF_ParseAttemptCount, _ESQIFF_LineErrorCount, _ESQPARS_Preamble55SeenFlag, _ESQPARS_CommandPreambleArmedFlag, _ESQPARS_ResetArmedFlag, _LOCAVAIL_PrimaryFilterState, _LOCAVAIL_SecondaryFilterState, _SCRIPT_CTRL_CHECKSUM, _SCRIPT_CTRL_READ_INDEX, SCRIPT_CTRL_STATE, _TEXTDISP_PrimaryGroupCode, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryEntryPtrTable, _TEXTDISP_PrimaryTitlePtrTable, _TEXTDISP_SecondaryGroupCode, _TEXTDISP_SecondaryGroupPresentFlag, _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_SecondaryEntryPtrTable, _TEXTDISP_SecondaryTitlePtrTable
; WRITES:
;   _DATACErrs, ESQPARS_PersistOnNextBoxOffFlag, _DISKIO2_InteractiveTransferArmedFlag, _ESQIFF_RecordLength, _ESQIFF_RecordChecksumByte, _ESQIFF_ParseAttemptCount, _ESQIFF_LineErrorCount, _ESQPARS_Preamble55SeenFlag, _ESQPARS_CommandPreambleArmedFlag, _ESQPARS_SelectionMatchCode, _ESQPARS_ResetArmedFlag, _ESQ_GlobalTickCounter
; DESC:
;   Consumes one RBF byte, advances preamble state, and when armed dispatches
;   command handlers for listing, status, config, banner/filter, and control paths.
; NOTES:
;   Uses 0x55/0xAA preamble sync and clears preamble flags on command completion.
;   This is the shared command/data ingest path for serial bytes once they are in
;   the RBF-backed stream. Custom transports/handshakes can reuse this by feeding
;   equivalent byte sequences to _SCRIPT_ReadNextRbfByte / _CTRL_BUFFER producers.
;------------------------------------------------------------------------------
_ESQPARS_ConsumeRbfByteAndDispatchCommand:
    LINK.W  A5,#-232
    MOVEM.L D2/D5-D7/A2,-(A7)

    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.W  _ESQPARS_CommandPreambleArmedFlag,D1
    MOVE.B  D0,-5(A5)
    TST.W   D1
    BNE.S   .preamble_dispatch_command_byte

    MOVEQ   #$55,D1         ; Copy 0x55 ('U') into D1
    CMP.B   D1,D0           ; Compare that byte to D0
    BNE.S   .preamble_check_double_sync       ; and jump to .preamble_check_double_sync if it's not equa.

    MOVEQ   #1,D1           ; Copy 1 into D1...
    MOVE.W  D1,_ESQPARS_Preamble55SeenFlag     ; and then 0x0001 into _ESQPARS_Preamble55SeenFlag
    MOVEQ   #0,D2           ; Copy 0 into D2...
    MOVE.W  D2,_ESQPARS_CommandPreambleArmedFlag     ; and then 0x0000 into _ESQPARS_CommandPreambleArmedFlag
    BRA.W   .cmdbyte_return       ; and branch to .cmdbyte_return

.preamble_check_double_sync:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #$55,D2
    ADD.L   D2,D2
    CMP.L   D2,D1
    BNE.S   .preamble_reset_state

    MOVE.W  _ESQPARS_Preamble55SeenFlag,D1
    SUBQ.W  #1,D1
    BNE.S   .preamble_reset_state

    MOVEQ   #0,D1
    MOVE.W  D1,_ESQPARS_Preamble55SeenFlag
    MOVEQ   #1,D2
    MOVE.W  D2,_ESQPARS_CommandPreambleArmedFlag
    BRA.W   .cmdbyte_return

.preamble_reset_state:
    MOVEQ   #0,D1
    MOVE.W  D1,_ESQPARS_Preamble55SeenFlag
    MOVE.W  D1,_ESQPARS_CommandPreambleArmedFlag
    BRA.W   .cmdbyte_return

.preamble_dispatch_command_byte:
    SUBQ.W  #1,D1
    BNE.W   .cmdTableDATA

    MOVE.W  _ESQPARS_SelectionMatchCode,D1
    BNE.W   .cmdTableDATA

    MOVEQ   #65,D1
    CMP.B   D1,D0
    BNE.W   .cmd_initial_w_upper

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   _ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,_ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  _ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  _ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .cmd_a_checksum_error

    MOVE.W  _ESQIFF_RecordLength,D0
    MOVEQ   #16,D1
    CMP.W   D1,D0
    BHI.S   .cmd_a_record_too_long

    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    JSR     _ESQSHARED_MatchSelectionCodeWithOptionalSuffix(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.W  D1,_ESQPARS_SelectionMatchCode
    SUBQ.W  #1,D1
    BNE.S   .clearValues

    MOVE.W  #1,_ESQPARS_ResetArmedFlag
    PEA     1.W
    PEA     2.W
    JSR     _ESQDISP_UpdateStatusMaskAndRefresh(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D0
    MOVE.L  D0,_DISKIO2_InteractiveTransferArmedFlag
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    BRA.S   .clearValues

.cmd_a_record_too_long:
    MOVE.W  _ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_LineErrorCount
    BRA.S   .clearValues

;!======

; Increment the number of _DATACErrs encountered
.cmd_a_checksum_error:
    MOVE.W  _DATACErrs,D0    ; Move _DATACErrs to D0
    ADDQ.W  #1,D0           ; Add 1 to D0
    MOVE.W  D0,_DATACErrs    ; Move D0 back to _DATACErrs
    BRA.S   .clearValues    ; Clear the values

.cmd_initial_w_upper:
    MOVEQ   #87,D1
    CMP.B   D1,D0
    BNE.S   .cmd_initial_w_lower

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    JSR     ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseRecord(PC)

    ADDQ.W  #4,A7
    BRA.S   .clearValues

.cmd_initial_w_lower:
    MOVEQ   #119,D1         ; Copy 119 ('w') into D1
    CMP.B   D1,D0           ; Compare 'w' in D1 to D0
    BNE.S   .clearValues    ; If they're not equal, jump to clear values

    MOVEQ   #0,D1           ; Move 0 into D1 to clear out all the bits
    MOVE.B  D0,D1           ; Then move a byte from D0 into D1
    MOVE.L  D1,-(A7)        ; Push D1 to the stack
    JSR     ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseList(PC)    ; Jump to ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseList(PC)

    ADDQ.W  #4,A7           ; Add 4 to the stack (nuking the last value in it)

.clearValues:               ; Clear out _ESQPARS_Preamble55SeenFlag and _ESQPARS_CommandPreambleArmedFlag
    MOVEQ   #0,D0           ; Copy 0 into D0
    MOVE.W  D0,_ESQPARS_Preamble55SeenFlag     ; Copy D0 (0) into _ESQPARS_Preamble55SeenFlag
    MOVE.W  D0,_ESQPARS_CommandPreambleArmedFlag     ; Copy D0 (0) into _ESQPARS_CommandPreambleArmedFlag
    BRA.W   .cmdbyte_return

.cmdTableDATA:
    ; https://prevueguide.com/Documentation/D2400.pdf
    MOVE.W  _ESQPARS_CommandPreambleArmedFlag,D0
    SUBQ.W  #1,D0
    BNE.W   .cmdbyte_return

    MOVE.W  _ESQPARS_SelectionMatchCode,D0
    SUBQ.W  #1,D0
    BNE.W   .cmdbyte_return

    MOVEQ   #0,D0       ; Move 0 into D0 to clear it out
    MOVE.B  -5(A5),D0   ; Copy the byte at -5(A5) which is the byte from serial to D0

    SUBI.W  #$21,D0   ; Subtract x21/33 from D0
    BEQ.W   .cmd_bang_begin   ; Does D0 equal zero (exactly)? Means D0 was 33 or '!'

    SUBQ.W  #4,D0       ; Subtract 4 more so x25/37
    BEQ.W   .cmd_percent_begin   ; Does D0 equal zero now? This is mode '%'

    SUBI.W  #$18,D0   ; Subtract x18/24 so x3D/61
    BEQ.W   .cmdDATABinaryDL ; Does D0 equal zero now? This is mode '='

    SUBQ.W  #6,D0       ; Subtract x6/6 so 67
    BEQ.W   .cmd_c_group_record   ; Same as above... this time mode 'C'

    SUBQ.W  #1,D0       ; Subtract 1 so 68
    BEQ.W   .processCommand_D_Diagnostics   ; Mode 'D' (diagnostic command)

    SUBQ.W  #1,D0
    BEQ.W   .cmd_e_copy_string   ; 'E'

    SUBQ.W  #1,D0
    BEQ.W   .cmd_f_status_packet   ; 'F'

    SUBQ.W  #2,D0
    BEQ.W   .cmdDATABinaryDL ; 'H'

    SUBQ.W  #1,D0
    BEQ.W   .cmd_i_parse_digit_label ; 'I'

    SUBQ.W  #2,D0
    BEQ.W   .processCommand_K_Clock ; 'K'

    SUBQ.W  #1,D0
    BEQ.W   .cmd_l_or_t_banner_entry ; 'L'

    SUBQ.W  #1,D0
    BEQ.W   .cmd_m_ack ; 'M'

    SUBQ.W  #2,D0
    BEQ.W   .cmd_o_clear_primary_flags ; 'O'

    SUBQ.W  #1,D0
    BEQ.W   .cmd_p_compact_entry ; 'P'

    SUBQ.W  #2,D0
    BEQ.W   .processCommand_R_Reset ; 'R'

    SUBQ.W  #4,D0
    BEQ.W   .processCommand_V_Version ; 'V'

    SUBQ.W  #1,D0
    BEQ.W   .cmd_upper_w_verify_record ; 'W'

    SUBI.W  #12,D0
    BEQ.W   .cmd_c_lower_program_info ; 'c'

    SUBQ.W  #3,D0
    BEQ.W   .cmd_f_lower_config_record ; 'f'

    SUBQ.W  #1,D0
    BEQ.W   .cmd_g_filter_or_banner ; 'g'

    SUBQ.W  #1,D0
    BEQ.W   .cmdDATABinaryDL ; 'h'

    SUBQ.W  #1,D0
    BEQ.W   .cmd_i_lower_copy_label ; 'i'

    SUBQ.W  #1,D0
    BEQ.W   .cmd_j_line_head_tail ; 'j'

    SUBQ.W  #6,D0
    BEQ.W   .cmd_p_lower_begin ; 'p'

    SUBQ.W  #4,D0
    BEQ.W   .cmd_l_or_t_banner_entry ; 't'

    SUBQ.W  #2,D0
    BEQ.W   .cmd_v_lower_aligned_listing ; 'v'

    SUBQ.W  #1,D0
    BEQ.W   .cmd_lower_w_verify_list ; 'w'

    SUBQ.W  #1,D0
    BEQ.W   .cmd_x_font_command ; 'x'

    SUBI.W  #$43,D0
    BEQ.W   .processCommand_xBB_BoxOff ; xBB (Box off)

    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_bang_begin:
    CLR.B   -62(A5)
    MOVE.B  #$de,-71(A5)
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    PEA     -71(A5)
    PEA     1.W
    PEA     -61(A5)
    BSR.W   ESQIFF2_ReadRbfBytesWithXor

    MOVEQ   #0,D0
    MOVE.B  -61(A5),D0
    PEA     -71(A5)
    PEA     1.W
    PEA     -61(A5)
    MOVE.L  D0,-14(A5)
    BSR.W   ESQIFF2_ReadRbfBytesWithXor

    MOVE.B  -61(A5),-7(A5)
    PEA     -71(A5)
    PEA     1.W
    PEA     -61(A5)
    BSR.W   ESQIFF2_ReadRbfBytesWithXor

    LEA     36(A7),A7
    MOVE.B  -61(A5),D0
    MOVE.B  D0,-8(A5)
    MOVE.B  -7(A5),D0
    MOVEQ   #1,D1
    CMP.B   D1,D0
    BCS.S   .cmd_bang_reject

    MOVE.B  -8(A5),D1
    MOVEQ   #48,D2
    CMP.B   D2,D1
    BHI.S   .cmd_bang_reject

    CMP.B   D0,D1
    BCS.S   .cmd_bang_reject

    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    MOVE.L  -14(A5),D1
    CMP.L   D1,D0
    BEQ.S   .cmd_bang_read_title_key

    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0

    CMP.L   D0,D1
    BEQ.S   .cmd_bang_read_title_key

.cmd_bang_reject:
    CLR.B   -62(A5)
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_bang_read_title_key:
    CLR.L   -22(A5)
    PEA     -71(A5)
    PEA     1.W
    PEA     -61(A5)
    BSR.W   ESQIFF2_ReadRbfBytesWithXor

    LEA     12(A7),A7

.cmd_bang_collect_title_loop:
    TST.B   -61(A5)
    BEQ.S   .cmd_bang_terminate_title

    MOVE.B  -61(A5),D0
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BEQ.S   .cmd_bang_terminate_title

    MOVEQ   #32,D1
    CMP.B   D1,D0
    BEQ.S   .cmd_bang_terminate_title

    MOVE.L  -22(A5),D1
    MOVEQ   #6,D2
    CMP.L   D2,D1
    BGE.S   .cmd_bang_terminate_title

    ADDQ.L  #1,-22(A5)
    MOVE.B  D0,-41(A5,D1.L)
    PEA     -71(A5)
    PEA     1.W
    PEA     -61(A5)
    BSR.W   ESQIFF2_ReadRbfBytesWithXor

    LEA     12(A7),A7
    BRA.S   .cmd_bang_collect_title_loop

.cmd_bang_terminate_title:
    MOVE.L  -22(A5),D0
    CLR.B   -41(A5,D0.L)

.cmd_bang_skip_to_nul_loop:
    TST.B   -61(A5)
    BEQ.S   .cmd_bang_verify_xor

    PEA     -71(A5)
    PEA     1.W
    PEA     -61(A5)
    BSR.W   ESQIFF2_ReadRbfBytesWithXor

    LEA     12(A7),A7
    BRA.S   .cmd_bang_skip_to_nul_loop

.cmd_bang_verify_xor:
    PEA     1.W
    PEA     -31(A5)
    BSR.W   ESQIFF2_ReadRbfBytesToBuffer

    ADDQ.W  #8,A7
    MOVE.B  -71(A5),D0
    MOVE.B  -31(A5),D1
    CMP.B   D1,D0
    BEQ.S   .cmd_bang_verify_xor_ok

    MOVEQ   #0,D0
    MOVE.B  D0,-62(A5)
    BRA.S   .cmd_bang_after_verify

.cmd_bang_verify_xor_ok:
    MOVEQ   #1,D0
    MOVE.B  D0,-62(A5)

.cmd_bang_after_verify:
    SUBQ.B  #1,D0
    BNE.W   .cmdbyte_clear_preamble_and_finish

    CLR.B   -62(A5)
    MOVEQ   #89,D0
    CMP.B   -7(A5),D0
    BNE.S   .cmd_bang_normalize_y_group

    MOVEQ   #1,D0
    MOVE.B  #$30,-8(A5)
    MOVE.B  D0,-7(A5)

.cmd_bang_normalize_y_group:
    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    MOVE.L  -14(A5),D1
    CMP.L   D1,D0
    BNE.S   .cmd_bang_try_primary_group

    MOVE.B  _TEXTDISP_SecondaryGroupPresentFlag,D0
    SUBQ.B  #1,D0
    BNE.S   .cmd_bang_try_primary_group

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    MOVEQ   #2,D2
    MOVE.L  D2,-30(A5)
    MOVE.L  D0,-18(A5)
    BRA.S   .cmd_bang_prepare_entry_scan

.cmd_bang_try_primary_group:
    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    CMP.L   D0,D1
    BNE.W   .cmdbyte_clear_preamble_and_finish

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    MOVEQ   #1,D1
    MOVE.L  D1,-30(A5)
    MOVE.L  D0,-18(A5)

.cmd_bang_prepare_entry_scan:
    CLR.L   -26(A5)

.cmd_bang_find_entry_loop:
    MOVE.L  -26(A5),D0
    CMP.L   -18(A5),D0
    BGE.S   .cmd_bang_entry_scan_done

    MOVE.L  -30(A5),-(A7)
    MOVE.L  D0,-(A7)
    JSR     _ESQDISP_GetEntryPointerByMode(PC)

    MOVE.L  -30(A5),(A7)
    MOVE.L  -26(A5),-(A7)
    MOVE.L  D0,-66(A5)
    JSR     _ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     12(A7),A7
    LEA     -41(A5),A0
    MOVEA.L D0,A1
    MOVE.L  D0,-70(A5)

.cmd_bang_compare_title_loop:
    MOVE.B  (A0)+,D1
    CMP.B   (A1)+,D1
    BNE.S   .cmd_bang_next_entry

    TST.B   D1
    BNE.S   .cmd_bang_compare_title_loop

    BNE.S   .cmd_bang_next_entry

    MOVE.B  #$1,-62(A5)
    BRA.S   .cmd_bang_entry_scan_done

.cmd_bang_next_entry:
    ADDQ.L  #1,-26(A5)
    BRA.S   .cmd_bang_find_entry_loop

.cmd_bang_entry_scan_done:
    MOVEQ   #1,D0
    CMP.B   -62(A5),D0
    BNE.W   .cmdbyte_clear_preamble_and_finish

    MOVE.B  -7(A5),D0
    MOVEQ   #1,D1
    CMP.B   D1,D0
    BNE.S   .cmd_bang_after_optional_flag_clear

    MOVEQ   #48,D1
    CMP.B   -8(A5),D1
    BNE.S   .cmd_bang_after_optional_flag_clear

    MOVEQ   #0,D1
    MOVEA.L -66(A5),A0
    MOVE.B  40(A0),D1
    ANDI.W  #$ff7f,D1
    MOVE.B  D1,40(A0)

.cmd_bang_after_optional_flag_clear:
    MOVE.B  D0,-9(A5)

.cmd_bang_apply_slot_range_loop:
    MOVE.B  -9(A5),D0
    CMP.B   -8(A5),D0
    BHI.W   .cmdbyte_clear_preamble_and_finish

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D2
    EXT.L   D2
    ASL.L   #2,D2
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -70(A5),A0
    MOVE.L  56(A0,D0.L),-(A7)
    CLR.L   -(A7)
    MOVE.L  D2,28(A7)
    BSR.W   _ESQPARS_ReplaceOwnedString

    ADDQ.W  #8,A7
    MOVEA.L -70(A5),A0
    MOVE.L  20(A7),D1
    MOVE.L  D0,56(A0,D1.L)
    MOVEQ   #0,D0
    MOVE.B  -9(A5),D0
    MOVE.B  #$1,7(A0,D0.W)
    ADDQ.B  #1,-9(A5)
    BRA.S   .cmd_bang_apply_slot_range_loop

.cmd_p_compact_entry:
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    CLR.L   -(A7)
    PEA     2.W
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   _ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,_ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  _ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  _ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .cmd_p_checksum_error

    MOVE.W  _ESQIFF_RecordLength,D0
    CMPI.W  #$1ff,D0
    BHI.S   .cmd_p_record_too_long

    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    JSR     ESQSHARED_ParseCompactEntryRecord(PC)

    ADDQ.W  #4,A7
    BRA.S   .cmd_p_finish

.cmd_p_record_too_long:
    MOVE.W  _ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_LineErrorCount
    BRA.S   .cmd_p_finish

.cmd_p_checksum_error:
    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs

.cmd_p_finish:
    CLR.W   _ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_p_lower_begin:
    CLR.B   -213(A5)
    MOVE.B  #$1,-224(A5)
    MOVE.B  #$8f,-227(A5)
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    PEA     -227(A5)
    PEA     1.W
    PEA     -62(A5)
    BSR.W   ESQIFF2_ReadRbfBytesWithXor

    MOVEQ   #0,D0
    MOVE.B  -62(A5),D0
    PEA     -227(A5)
    PEA     1.W
    PEA     -62(A5)
    MOVE.L  D0,-10(A5)
    BSR.W   ESQIFF2_ReadRbfBytesWithXor

    LEA     24(A7),A7
    CLR.L   -18(A5)

.cmd_p_lower_read_key_loop:
    MOVE.B  -62(A5),D0
    MOVE.L  -18(A5),D1
    MOVE.B  D0,-36(A5,D1.L)
    MOVEQ   #18,D2
    CMP.B   D2,D0
    BEQ.S   .cmd_p_lower_key_ready

    MOVEQ   #8,D0
    CMP.L   D0,D1
    BGE.S   .cmd_p_lower_key_ready

    PEA     -227(A5)
    PEA     1.W
    PEA     -62(A5)
    BSR.W   ESQIFF2_ReadRbfBytesWithXor

    LEA     12(A7),A7
    ADDQ.L  #1,-18(A5)
    BRA.S   .cmd_p_lower_read_key_loop

.cmd_p_lower_key_ready:
    MOVE.L  -18(A5),D0
    CLR.B   -36(A5,D0.L)
    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    MOVE.L  -10(A5),D1
    CMP.L   D1,D0
    BNE.S   .cmd_p_lower_try_primary_group

    MOVE.B  _TEXTDISP_SecondaryGroupPresentFlag,D0
    SUBQ.B  #1,D0
    BNE.S   .cmd_p_lower_try_primary_group

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    MOVE.L  D0,-14(A5)
    BRA.S   .cmd_p_lower_read_bitmap6

.cmd_p_lower_try_primary_group:
    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    CMP.L   D0,D1
    BNE.W   .cmdbyte_clear_preamble_and_finish

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.L  D0,-14(A5)

.cmd_p_lower_read_bitmap6:
    PEA     -227(A5)
    PEA     6.W
    PEA     -62(A5)
    BSR.W   ESQIFF2_ReadRbfBytesWithXor

    LEA     12(A7),A7
    CLR.L   -18(A5)

.cmd_p_lower_validate_bitmap_loop:
    MOVE.L  -18(A5),D0
    MOVEQ   #6,D1
    CMP.L   D1,D0
    BGE.S   .cmd_p_lower_after_bitmap_validation

    TST.B   -62(A5,D0.L)
    BEQ.S   .cmd_p_lower_next_bitmap_byte

    CLR.B   -224(A5)

.cmd_p_lower_next_bitmap_byte:
    ADDQ.L  #1,-18(A5)
    BRA.S   .cmd_p_lower_validate_bitmap_loop

.cmd_p_lower_after_bitmap_validation:
    PEA     -62(A5)
    PEA     -42(A5)
    JSR     ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes(PC)

    ADDQ.W  #8,A7
    CLR.L   -26(A5)

.cmd_p_lower_find_title_loop:
    MOVE.L  -26(A5),D0
    CMP.L   -14(A5),D0
    BGE.S   .cmd_p_lower_read_payload_width

    MOVEQ   #0,D1
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D1
    MOVE.L  -10(A5),D2
    CMP.L   D1,D2
    BNE.S   .cmd_p_lower_use_primary_tables

    MOVE.B  _TEXTDISP_SecondaryGroupPresentFlag,D1
    SUBQ.B  #1,D1
    BNE.S   .cmd_p_lower_use_primary_tables

    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-218(A5)
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-222(A5)
    BRA.S   .cmd_p_lower_compare_title_start

.cmd_p_lower_use_primary_tables:
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-218(A5)
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-222(A5)

.cmd_p_lower_compare_title_start:
    LEA     -36(A5),A0
    MOVEA.L -222(A5),A1

.cmd_p_lower_compare_title_loop:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   .cmd_p_lower_next_title

    TST.B   D0
    BNE.S   .cmd_p_lower_compare_title_loop

    BNE.S   .cmd_p_lower_next_title

    MOVE.B  #$1,-213(A5)
    BRA.S   .cmd_p_lower_read_payload_width

.cmd_p_lower_next_title:
    ADDQ.L  #1,-26(A5)
    BRA.S   .cmd_p_lower_find_title_loop

.cmd_p_lower_read_payload_width:
    PEA     -227(A5)
    PEA     1.W
    PEA     -223(A5)
    BSR.W   ESQIFF2_ReadRbfBytesWithXor

    LEA     12(A7),A7
    MOVE.B  -223(A5),D0
    MOVEQ   #1,D1
    CMP.B   D1,D0
    BCS.S   .cmd_p_lower_invalid_payload_width

    MOVEQ   #3,D1
    CMP.B   D1,D0
    BLS.S   .cmd_p_lower_apply_payload_mode

.cmd_p_lower_invalid_payload_width:
    MOVEQ   #0,D1
    MOVE.B  D1,-213(A5)

.cmd_p_lower_apply_payload_mode:
    TST.B   -224(A5)
    BEQ.W   .cmd_p_lower_sparse_path

    TST.B   -213(A5)
    BEQ.W   .cmd_p_lower_sparse_path

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    EXT.L   D1
    PEA     -227(A5)
    MOVE.L  D1,-(A7)
    PEA     -212(A5)
    BSR.W   ESQIFF2_ReadRbfBytesWithXor

    PEA     -227(A5)
    PEA     1.W
    PEA     -226(A5)
    BSR.W   ESQIFF2_ReadRbfBytesWithXor

    LEA     24(A7),A7
    MOVE.B  -226(A5),D0
    TST.B   D0
    BEQ.S   .cmd_p_lower_after_payload_trailer

    CLR.B   -213(A5)

.cmd_p_lower_after_payload_trailer:
    PEA     1.W
    PEA     -225(A5)
    BSR.W   ESQIFF2_ReadRbfBytesToBuffer

    ADDQ.W  #8,A7
    MOVE.B  -227(A5),D0
    MOVE.B  -225(A5),D1
    CMP.B   D1,D0
    BEQ.S   .cmd_p_lower_after_checksum_byte

    MOVEQ   #0,D0
    MOVE.B  D0,-213(A5)

.cmd_p_lower_after_checksum_byte:
    TST.B   -213(A5)
    BEQ.W   .cmd_p_lower_finish

    MOVE.B  -223(A5),D0
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.S   .cmd_p_lower_after_optional_highlight_flag

    MOVE.B  -212(A5),D0
    MOVEQ   #5,D1
    CMP.B   D1,D0
    BCS.S   .cmd_p_lower_after_optional_highlight_flag

    MOVEQ   #10,D1
    CMP.B   D1,D0
    BHI.S   .cmd_p_lower_after_optional_highlight_flag

    MOVEA.L -218(A5),A0
    BSET    #0,40(A0)

.cmd_p_lower_after_optional_highlight_flag:
    CLR.L   -18(A5)

.cmd_p_lower_fill_all_rows_loop:
    MOVE.L  -18(A5),D0
    MOVEQ   #49,D1
    CMP.L   D1,D0
    BGE.W   .cmd_p_lower_finish

    MOVE.B  -223(A5),D1
    MOVEQ   #0,D2
    CMP.B   D2,D1
    BLS.S   .cmd_p_lower_after_col0

    MOVEA.L -222(A5),A0
    MOVE.L  D0,D2
    ADDI.L  #$fc,D2
    MOVE.B  -212(A5),0(A0,D2.L)

.cmd_p_lower_after_col0:
    MOVE.B  -223(A5),D1
    MOVEQ   #1,D2
    CMP.B   D2,D1
    BLS.S   .cmd_p_lower_after_col1

    MOVEA.L -222(A5),A0
    MOVE.L  D0,D2
    ADDI.L  #$12d,D2
    MOVE.B  -211(A5),0(A0,D2.L)

.cmd_p_lower_after_col1:
    MOVE.B  -223(A5),D1
    MOVEQ   #2,D2
    CMP.B   D2,D1
    BLS.S   .cmd_p_lower_next_row_all

    MOVEA.L -222(A5),A0
    MOVE.L  D0,D0
    ADDI.L  #$15e,D0
    MOVE.B  -210(A5),0(A0,D0.L)

.cmd_p_lower_next_row_all:
    ADDQ.L  #1,-18(A5)
    BRA.S   .cmd_p_lower_fill_all_rows_loop

.cmd_p_lower_sparse_path:
    TST.B   -213(A5)
    BEQ.W   .cmd_p_lower_finish

    CLR.L   -26(A5)
    MOVEQ   #1,D0
    MOVE.L  D0,-18(A5)

.cmd_p_lower_count_marked_rows_loop:
    MOVE.L  -18(A5),D0
    MOVEQ   #49,D1
    CMP.L   D1,D0
    BGE.S   .cmd_p_lower_read_sparse_payload

    MOVE.L  D0,-(A7)
    PEA     -42(A5)
    JSR     ESQSHARED_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-22(A5)
    ADDQ.L  #1,D0
    BNE.S   .cmd_p_lower_next_bit_index

    ADDQ.L  #1,-26(A5)

.cmd_p_lower_next_bit_index:
    ADDQ.L  #1,-18(A5)
    BRA.S   .cmd_p_lower_count_marked_rows_loop

.cmd_p_lower_read_sparse_payload:
    MOVEQ   #0,D0
    MOVE.B  -223(A5),D0
    MOVE.L  -26(A5),D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    EXT.L   D0
    PEA     -227(A5)
    MOVE.L  D0,-(A7)
    PEA     -212(A5)
    BSR.W   ESQIFF2_ReadRbfBytesWithXor

    PEA     -227(A5)
    PEA     1.W
    PEA     -226(A5)
    BSR.W   ESQIFF2_ReadRbfBytesWithXor

    LEA     24(A7),A7
    MOVE.B  -226(A5),D0
    TST.B   D0
    BEQ.S   .cmd_p_lower_after_sparse_trailer

    CLR.B   -213(A5)

.cmd_p_lower_after_sparse_trailer:
    PEA     1.W
    PEA     -225(A5)
    BSR.W   ESQIFF2_ReadRbfBytesToBuffer

    ADDQ.W  #8,A7
    MOVE.B  -227(A5),D0
    MOVE.B  -225(A5),D1
    CMP.B   D1,D0
    BEQ.S   .cmd_p_lower_after_sparse_checksum_byte

    MOVEQ   #0,D0
    MOVE.B  D0,-213(A5)

.cmd_p_lower_after_sparse_checksum_byte:
    TST.B   -213(A5)
    BEQ.W   .cmd_p_lower_finish

    CLR.L   -26(A5)
    MOVEQ   #1,D0
    MOVE.L  D0,-18(A5)

.cmd_p_lower_apply_sparse_rows_loop:
    MOVE.L  -18(A5),D0
    MOVEQ   #49,D1
    CMP.L   D1,D0
    BGE.W   .cmd_p_lower_finish

    MOVE.L  D0,-(A7)
    PEA     -42(A5)
    JSR     ESQSHARED_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-22(A5)
    ADDQ.L  #1,D0
    BNE.W   .cmd_p_lower_next_sparse_row

    MOVE.B  -223(A5),D0
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.S   .cmd_p_lower_after_sparse_col0

    LEA     -212(A5),A0
    MOVE.L  -26(A5),D1
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVEA.L -222(A5),A2
    MOVE.L  -18(A5),D2
    ADDI.L  #$fc,D2
    MOVE.B  (A1),0(A2,D2.L)
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    CMPI.B  #$5,(A1)
    BCS.S   .cmd_p_lower_after_sparse_col0

    MOVEA.L A0,A1
    ADDA.L  D1,A1
    CMPI.B  #$a,(A1)
    BHI.S   .cmd_p_lower_after_sparse_col0

    MOVEA.L -218(A5),A1
    BSET    #0,40(A1)

.cmd_p_lower_after_sparse_col0:
    ADDQ.L  #1,-26(A5)
    MOVE.B  -223(A5),D0
    MOVEQ   #1,D1
    CMP.B   D1,D0
    BLS.S   .cmd_p_lower_after_sparse_col1

    LEA     -212(A5),A0
    MOVEA.L A0,A1
    ADDA.L  -26(A5),A1
    ADDQ.L  #1,-26(A5)
    MOVEA.L -222(A5),A2
    MOVE.L  -18(A5),D1
    ADDI.L  #301,D1
    MOVE.B  (A1),0(A2,D1.L)

.cmd_p_lower_after_sparse_col1:
    MOVE.B  -223(A5),D0
    MOVEQ   #2,D1
    CMP.B   D1,D0
    BLS.S   .cmd_p_lower_next_sparse_row

    LEA     -212(A5),A0
    ADDA.L  -26(A5),A0
    ADDQ.L  #1,-26(A5)
    MOVEA.L -222(A5),A1
    MOVE.L  -18(A5),D0
    ADDI.L  #$15e,D0
    MOVE.B  (A0),0(A1,D0.L)

.cmd_p_lower_next_sparse_row:
    ADDQ.L  #1,-18(A5)
    BRA.W   .cmd_p_lower_apply_sparse_rows_loop

.cmd_p_lower_finish:
    CLR.W   _ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_l_or_t_banner_entry:
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   _ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,_ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  _ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  _ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .cmd_l_or_t_checksum_error

    MOVE.W  _ESQIFF_RecordLength,D0
    CMPI.W  #$130,D0
    BHI.S   .cmd_l_or_t_record_too_long

    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LADFUNC_ParseBannerEntryData(PC)

    ADDQ.W  #8,A7
    BRA.S   .cmd_l_or_t_finish

.cmd_l_or_t_record_too_long:
    MOVE.W  _ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_LineErrorCount
    BRA.S   .cmd_l_or_t_finish

.cmd_l_or_t_checksum_error:
    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs

.cmd_l_or_t_finish:
    CLR.W   _ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.processCommand_xBB_BoxOff:
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,-5(A5)
    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,_ESQIFF_RecordChecksumByte
    MOVEQ   #0,D1
    MOVE.B  -5(A5),D1
    MOVEQ   #68,D2
    NOT.B   D2
    CMP.L   D2,D1
    BNE.S   .cmd_boxoff_checksum_error

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #0,D0
    NOT.B   D0
    CMP.L   D0,D1
    BNE.S   .cmd_boxoff_checksum_error

    TST.W   ESQPARS_PersistOnNextBoxOffFlag
    BEQ.S   .cmd_boxoff_apply

    BSR.W   _ESQPARS_PersistStateDataAfterCommand

    MOVEQ   #0,D0
    MOVE.W  D0,ESQPARS_PersistOnNextBoxOffFlag

.cmd_boxoff_apply:
    CLR.W   _ESQPARS_SelectionMatchCode
    CLR.L   -(A7)
    PEA     2.W
    JSR     _ESQDISP_UpdateStatusMaskAndRefresh(PC)

    ADDQ.W  #8,A7
    BRA.S   .cmd_boxoff_finish

.cmd_boxoff_checksum_error:
    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs

.cmd_boxoff_finish:
    CLR.W   _ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_c_group_record:
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    PEA     6.W
    PEA     1.W
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   _ESQIFF2_ReadSerialRecordIntoBuffer

    LEA     12(A7),A7
    MOVE.W  D0,_ESQIFF_RecordLength
    TST.W   D0
    BEQ.W   .cmdbyte_clear_preamble_and_finish

    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  _ESQIFF_RecordLength,D1
    MOVE.L  D1,-(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D1
    MOVE.B  _ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .cmd_c_checksum_error

    MOVE.W  _ESQIFF_StatusPacketReadyFlag,D0
    SUBQ.W  #1,D0
    BNE.S   .cmd_c_finish

    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ParseGroupRecordAndRefresh

    ADDQ.W  #4,A7
    BRA.S   .cmd_c_finish

.cmd_c_checksum_error:
    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs

.cmd_c_finish:
    CLR.W   _ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_c_lower_program_info:
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    CLR.L   -(A7)
    PEA     1.W
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   _ESQIFF2_ReadSerialRecordIntoBuffer

    LEA     12(A7),A7
    MOVE.W  D0,_ESQIFF_RecordLength
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .cmd_c_lower_invalid_record

    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  _ESQIFF_RecordLength,D1
    MOVE.L  D1,-(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D1
    MOVE.B  _ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .cmd_c_lower_invalid_record

    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    JSR     ESQDISP_ParseProgramInfoCommandRecord(PC)

    ADDQ.W  #4,A7
    BRA.S   .cmd_c_lower_finish

.cmd_c_lower_invalid_record:
    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs

.cmd_c_lower_finish:
    CLR.W   _ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_v_lower_aligned_listing:
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    CLR.L   -(A7)
    PEA     1.W
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   _ESQIFF2_ReadSerialRecordIntoBuffer

    LEA     12(A7),A7
    MOVE.W  D0,_ESQIFF_RecordLength
    TST.W   D0
    BEQ.W   .cmdbyte_clear_preamble_and_finish

    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  _ESQIFF_RecordLength,D1
    MOVE.L  D1,-(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D1
    MOVE.B  _ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .cmd_v_lower_checksum_error

    MOVEA.L _ESQIFF_RecordBufferPtr,A0
    MOVE.B  1(A0),D0
    MOVEQ   #49,D1
    CMP.B   D1,D0
    BNE.S   .cmd_v_lower_finish

    MOVE.L  A0,-(A7)
    JSR     ESQPARS_JMPTBL_CLEANUP_ParseAlignedListingBlock(PC)

    ADDQ.W  #4,A7
    BRA.S   .cmd_v_lower_finish

.cmd_v_lower_checksum_error:
    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs

.cmd_v_lower_finish:
    CLR.W   _ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_e_copy_string:
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   _ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,_ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  _ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  _ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .cmd_e_checksum_error

    MOVEA.L _ESQIFF_RecordBufferPtr,A0
    LEA     _ESQPARS_SelectionSuffixBuffer,A1

.cmd_e_copy_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .cmd_e_copy_loop

    BRA.S   .cmd_e_finish

.cmd_e_checksum_error:
    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs

.cmd_e_finish:
    CLR.W   _ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

    if includeCustomAriAssembly

.cmd_e_debug_status_dump:
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    JSR     _ESQ_PollCtrlInput

    MOVEQ   #0,D0
    LEA     76(A7),A7
    MOVE.W  SCRIPT_CTRL_STATE,D4
    MOVEQ   #0,D0
    MOVE.W  _CTRL_H,D0
    MOVEQ   #0,D3
    MOVE.W  _SCRIPT_CTRL_CHECKSUM,D3
    MOVEQ   #0,D1
    MOVE.W  _SCRIPT_CTRL_READ_INDEX,D1
    MOVEQ   #0,D2
    LEA     _CTRL_BUFFER,A3
    ADDA    D0,A3
    SUBA    #1,A3
    MOVEQ   #0,D2
    MOVE.B (A3),D2
    MOVE.L  D2,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     WDISP_FMT_CTRLH_STATUS_MAX
    PEA     -72(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)
    PEA     -72(A5)
    PEA     262.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    CLR.W   _ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish
    endif

.cmd_f_status_packet:
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    PEA     21.W
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadRbfBytesToBuffer

    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,_ESQIFF_RecordChecksumByte
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    PEA     20.W
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  _ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .cmd_f_invalid_packet

    MOVEA.L _ESQIFF_RecordBufferPtr,A0
    MOVE.B  (A0),D0
    MOVEQ   #65,D1
    CMP.B   D1,D0
    BEQ.S   .cmd_f_validate_packet_header

    MOVEQ   #66,D2
    CMP.B   D2,D0
    BNE.S   .cmd_f_invalid_packet

.cmd_f_validate_packet_header:
    MOVE.B  1(A0),D0
    CMP.B   D1,D0
    BCS.S   .cmd_f_invalid_packet

    MOVEQ   #74,D1
    CMP.B   D1,D0
    BCC.S   .cmd_f_invalid_packet

    MOVE.L  A0,-(A7)
    BSR.W   ESQIFF2_ApplyIncomingStatusPacket

    ADDQ.W  #4,A7
    BRA.S   .cmd_f_finish

.cmd_f_invalid_packet:
    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs

.cmd_f_finish:
    CLR.W   _ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.processCommand_K_Clock:
    MOVE.W  _ED_DiagnosticsViewMode,D0
    SUBQ.W  #1,D0
    BEQ.W   .cmdbyte_clear_preamble_and_finish

    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    PEA     8.W
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadRbfBytesToBuffer

    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,_ESQIFF_RecordChecksumByte
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    PEA     8.W
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  _ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .command_K_Increment_Data_CErrs

    ; At this point A0 is a pointer to a struct or array that
    ; matches the data received from the request.
    ; See: https://prevueguide.com/Documentation/D2400.pdf
    ; (Byte 4 and onward)

    ; Small sanity checks: check day (not over 7)
    MOVEA.L _ESQIFF_RecordBufferPtr,A0 ; Pointer to all the data received.
    MOVE.B  (A0),D0     ; Byte 0: Day
    MOVEQ   #7,D1
    CMP.B   D1,D0
    BCC.S   .command_K_Increment_Data_CErrs

    ; Small sanity checks: check month (not over 12)
    MOVE.B  1(A0),D0    ; Byte 1: Month
    MOVEQ   #12,D1
    CMP.B   D1,D0
    BCC.S   .command_K_Increment_Data_CErrs

    MOVE.B  6(A0),D0    ; Byte 6: Second
    MOVEQ   #60,D1
    CMP.B   D1,D0
    BCC.S   .command_K_Increment_Data_CErrs

    MOVE.B  _CTASKS_STR_1,D0
    MOVEQ   #50,D1
    CMP.B   D1,D0
    BNE.S   .command_K_Increment_Data_CErrs

    MOVE.L  A0,-(A7)    ; Push the address of the data to the stack
    BSR.W   ESQPARS_ApplyRtcBytesAndPersist

    ADDQ.W  #4,A7
    BRA.S   .cmd_k_finish

.command_K_Increment_Data_CErrs:
    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs

.cmd_k_finish:
    CLR.W   _ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_j_line_head_tail:
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    CLR.L   -(A7)
    PEA     2.W
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   _ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,_ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  _ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  _ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .cmd_j_checksum_error

    MOVE.W  _ESQIFF_RecordLength,D0
    CMPI.W  #$1f4,D0
    BHI.S   .cmd_j_record_too_long

    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ParseLineHeadTailRecord

    ADDQ.W  #4,A7
    BRA.S   .cmd_j_finish

.cmd_j_record_too_long:
    MOVE.W  _ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_LineErrorCount
    BRA.S   .cmd_j_finish

.cmd_j_checksum_error:
    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs

.cmd_j_finish:
    CLR.W   _ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_i_parse_digit_label:
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   _ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,_ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  _ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  _ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .cmd_i_checksum_error

    MOVE.W  _ESQIFF_RecordLength,D0
    MOVEQ   #39,D1
    CMP.W   D1,D0
    BHI.S   .cmd_i_record_too_long

    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    JSR     ESQPARS_JMPTBL_ESQPROTO_ParseDigitLabelAndDisplay(PC)

    ADDQ.W  #4,A7
    BRA.S   .cmd_i_finish

.cmd_i_record_too_long:
    MOVE.W  _ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_LineErrorCount
    BRA.S   .cmd_i_finish

.cmd_i_checksum_error:
    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs

.cmd_i_finish:
    CLR.W   _ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_i_lower_copy_label:
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   _ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,_ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  _ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  _ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .cmd_i_lower_checksum_error

    MOVE.W  _ESQIFF_RecordLength,D0
    MOVEQ   #39,D1
    CMP.W   D1,D0
    BHI.S   .cmd_i_lower_record_too_long

    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    JSR     ESQPARS_JMPTBL_ESQPROTO_CopyLabelToGlobal(PC)

    ADDQ.W  #4,A7
    BRA.S   .cmd_i_lower_finish

.cmd_i_lower_record_too_long:
    MOVE.W  _ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_LineErrorCount
    BRA.S   .cmd_i_lower_finish

.cmd_i_lower_checksum_error:
    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs

.cmd_i_lower_finish:
    CLR.W   _ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_percent_begin:
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,_ESQIFF_RecordChecksumByte
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #109,D0
    ADD.L   D0,D0
    CMP.L   D0,D1
    BNE.S   .cmd_percent_checksum_error

    MOVEQ   #1,D0
    MOVE.W  D0,ESQPARS_PersistOnNextBoxOffFlag
    BRA.S   .cmd_percent_finish

.cmd_percent_checksum_error:
    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs

.cmd_percent_finish:
    CLR.W   _ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.processCommand_R_Reset:
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #82,D0
    NOT.B   D0
    CMP.L   D0,D1
    BNE.S   .cmd_r_checksum_error

    MOVE.W  _ESQPARS_ResetArmedFlag,D0
    SUBQ.W  #1,D0
    BNE.S   .cmd_r_finish

    MOVE.W  #21000,_ESQ_GlobalTickCounter
    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  #_Global_REF_696_400_BITMAP,4(A0)

.cmd_r_reset_overlay_loop:
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    MOVEQ   #34,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .cmd_r_reset_overlay_center_adjust

    ADDQ.L  #1,D1

.cmd_r_reset_overlay_center_adjust:
    ASR.L   #1,D1
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D1
    MOVEQ   #29,D0
    ADD.L   D0,D1
    PEA     Global_STR_RESET_COMMAND_RECEIVED
    MOVE.L  D1,-(A7)
    PEA     40.W
    MOVE.L  A1,-(A7)
    JSR     GROUP_AW_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    BRA.S   .cmd_r_reset_overlay_loop

.cmd_r_checksum_error:
    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs

.cmd_r_finish:
    CLR.W   _ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_m_ack:
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    CLR.W   _ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_o_clear_primary_flags:
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #88,D0
    ADD.L   D0,D0
    CMP.L   D0,D1
    BNE.S   .cmd_o_checksum_error

    BSR.W   ESQIFF2_ClearPrimaryEntryFlags34To39

    BRA.S   .cmd_o_finish

.cmd_o_checksum_error:
    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs

.cmd_o_finish:
    CLR.W   _ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmdDATABinaryDL:
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    MOVEQ   #0,D0
    MOVE.W  D0,_ESQPARS_ResetArmedFlag
    MOVE.L  D0,D5
    MOVEQ   #1,D0
    CMP.L   _DISKIO2_InteractiveTransferArmedFlag,D0
    BNE.W   .cmdbyte_clear_preamble_and_finish

    MOVEQ   #61,D1
    CMP.B   -5(A5),D1
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    JSR     ESQPARS_JMPTBL_DISKIO2_HandleInteractiveFileTransfer(PC)

    ADDQ.W  #4,A7
    BRA.W   .cmdbyte_clear_preamble_and_finish

.processCommand_D_Diagnostics:
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    PEA     256.W
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadRbfBytesToBuffer

    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,_ESQIFF_RecordChecksumByte
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    PEA     256.W
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  _ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BEQ.S   .cmd_d_finish

    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs

.cmd_d_finish:
    CLR.W   _ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_upper_w_verify_record:
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseRecord(PC)

    ADDQ.W  #4,A7
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_lower_w_verify_list:
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseList(PC)

    ADDQ.W  #4,A7
    BRA.W   .cmdbyte_clear_preamble_and_finish

.processCommand_V_Version:
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   _ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,_ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  _ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  _ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .cmd_v_checksum_error

    MOVE.W  _ESQIFF_RecordLength,D0
    CMPI.W  #$8b,D0
    BHI.S   .cmd_v_record_too_long

    BSR.W   ESQIFF2_ShowVersionMismatchOverlay

    BRA.S   .cmd_v_finish

.cmd_v_record_too_long:
    MOVE.W  _ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_LineErrorCount
    BRA.S   .cmd_v_finish

.cmd_v_checksum_error:
    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs

.cmd_v_finish:
    CLR.W   _ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_x_font_command:
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   _ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,_ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  _ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  _ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .cmd_x_invalid_record

    MOVE.W  _ESQIFF_RecordLength,D0
    MOVEQ   #80,D1
    CMP.W   D1,D0
    BHI.S   .cmd_x_invalid_record

    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    JSR     ESQPARS_JMPTBL_PARSEINI_HandleFontCommand(PC)

    ADDQ.W  #4,A7
    BRA.S   .cmd_x_finish

.cmd_x_invalid_record:
    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs

.cmd_x_finish:
    CLR.W   _ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_f_lower_config_record:
    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  D0,D6
    MOVE.B  -5(A5),D0
    MOVE.B  D0,-6(A5)
    EOR.B   D6,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    MOVE.B  D0,-6(A5)
    BSR.W   _ESQPARS_ReadLengthWordWithChecksumXor

    ADDQ.W  #4,A7
    MOVE.W  _ESQIFF_RecordLength,D1
    MOVE.B  D0,-6(A5)
    CMPI.W  #$2328,D1
    BCS.S   .cmd_f_lower_read_config_payload

    MOVE.W  _ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_LineErrorCount
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_f_lower_read_config_payload:
    MOVE.W  _ESQIFF_RecordLength,D0
    MOVE.L  D0,D1
    SUBQ.W  #1,D1
    MOVE.W  D1,_ESQIFF_RecordLength
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadRbfBytesToBuffer

    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,_ESQIFF_RecordChecksumByte
    MOVEQ   #0,D0
    MOVE.B  -6(A5),D0
    MOVEQ   #0,D1
    MOVE.W  _ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     16(A7),A7
    MOVE.L  D0,D7
    MOVE.B  _ESQIFF_RecordChecksumByte,D0
    CMP.B   D0,D7
    BNE.S   .cmd_f_lower_checksum_error

    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    MOVEQ   #0,D0
    MOVE.W  _ESQIFF_RecordLength,D0
    MOVE.L  D0,-(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    JSR     ESQPARS_JMPTBL_DISKIO_ParseConfigBuffer(PC)

    JSR     ESQPARS_JMPTBL_DISKIO_SaveConfigToFileHandle(PC)

    ADDQ.W  #8,A7
    BRA.S   .cmd_f_lower_finish

.cmd_f_lower_checksum_error:
    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs

.cmd_f_lower_finish:
    CLR.W   _ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_g_filter_or_banner:
    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  D0,D6
    MOVE.B  -5(A5),D0
    MOVE.B  D0,-6(A5)
    EOR.B   D6,D0
    MOVE.B  D0,-6(A5)
    MOVEQ   #49,D0
    CMP.B   D0,D6
    BNE.W   .cmd_g_dispatch_banner_subcommand

    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVEA.L _ESQIFF_RecordBufferPtr,A0
    MOVE.B  D0,(A0)
    LEA     1(A0),A1
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    BSR.W   _ESQIFF2_ReadSerialRecordIntoBuffer

    LEA     12(A7),A7
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_RecordLength
    MOVEQ   #0,D1
    MOVE.B  -6(A5),D1
    MOVEQ   #0,D2
    MOVE.W  D0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D1,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D1
    MOVE.B  _ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .cmd_g_type1_checksum_error

    MOVEA.L _ESQIFF_RecordBufferPtr,A0
    MOVE.B  (A0),D0
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D1
    CMP.B   D1,D0
    BNE.S   .cmd_g_apply_secondary_filter

    PEA     _LOCAVAIL_PrimaryFilterState
    MOVE.L  A0,-(A7)
    JSR     LOCAVAIL_ParseFilterStateFromBuffer(PC)

    ADDQ.W  #8,A7
    BRA.S   .cmd_g_filter_finish

.cmd_g_apply_secondary_filter:
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D1
    CMP.B   D1,D0
    BNE.S   .cmd_g_filter_finish

    PEA     _LOCAVAIL_SecondaryFilterState
    MOVE.L  A0,-(A7)
    JSR     LOCAVAIL_ParseFilterStateFromBuffer(PC)

    ADDQ.W  #8,A7

.cmd_g_filter_finish:
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_g_type1_checksum_error:
    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_g_dispatch_banner_subcommand:
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,-(A7)
    PEA     ESQPARS_BannerSubcommandSet
    ; strchr-style membership test: command byte must be in "23".
    JSR     _GROUP_AS_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.W   .cmd_g_maybe_type_or_options

    PEA     2.W
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   _ESQIFF2_ReadSerialSizedTextRecord

    ADDQ.W  #8,A7
    MOVE.W  D0,_ESQIFF_RecordLength
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .cmd_g_banner_line_error

    MOVEQ   #0,D1
    MOVE.B  -6(A5),D1
    MOVEQ   #0,D2
    MOVE.W  D0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D1,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D1
    MOVE.B  _ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .cmd_g_banner_checksum_error

    MOVE.L  D6,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_DST_HandleBannerCommand32_33(PC)

    ADDQ.W  #8,A7
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_g_banner_checksum_error:
    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_g_banner_line_error:
    MOVE.W  _ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_LineErrorCount
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_g_maybe_type_or_options:
    MOVEQ   #53,D0
    CMP.B   D0,D6
    BNE.S   .cmd_g_maybe_cmd_options

    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   _ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,_ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -6(A5),D0
    MOVEQ   #0,D1
    MOVE.W  _ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  _ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .cmd_g_type5_checksum_error

    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    JSR     ESQPARS_JMPTBL_P_TYPE_ParseAndStoreTypeRecord(PC)

    ADDQ.W  #4,A7
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_g_type5_checksum_error:
    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_g_maybe_cmd_options:
    MOVEQ   #54,D0
    CMP.B   D0,D6
    BNE.S   .cmd_g_maybe_cmd_string

    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   _ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,_ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -6(A5),D0
    MOVEQ   #0,D1
    MOVE.W  _ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  _ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .cmd_g_type6_checksum_error

    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    JSR     GCOMMAND_ParseCommandOptions(PC)

    ADDQ.W  #4,A7
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_g_type6_checksum_error:
    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_g_maybe_cmd_string:
    MOVEQ   #55,D0
    CMP.B   D0,D6
    BNE.S   .cmd_g_maybe_ppv

    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   _ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,_ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -6(A5),D0
    MOVEQ   #0,D1
    MOVE.W  _ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  _ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .cmd_g_type7_checksum_error

    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    JSR     GCOMMAND_ParseCommandString(PC)

    ADDQ.W  #4,A7
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_g_type7_checksum_error:
    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs
    BRA.S   .cmdbyte_clear_preamble_and_finish

.cmd_g_maybe_ppv:
    MOVEQ   #56,D0
    CMP.B   D0,D6
    BNE.S   .cmdbyte_clear_preamble_and_finish

    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   _ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,_ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -6(A5),D0
    MOVEQ   #0,D1
    MOVE.W  _ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  _ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .cmd_g_type8_checksum_error

    MOVE.L  _ESQIFF_RecordBufferPtr,-(A7)
    JSR     GCOMMAND_ParsePPVCommand(PC)

    ADDQ.W  #4,A7
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    BRA.S   .cmdbyte_clear_preamble_and_finish

.cmd_g_type8_checksum_error:
    MOVE.W  _DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DATACErrs

.cmdbyte_clear_preamble_and_finish:
    MOVEQ   #0,D0
    MOVE.W  D0,_ESQPARS_Preamble55SeenFlag
    MOVE.W  D0,_ESQPARS_CommandPreambleArmedFlag

.cmdbyte_return:
    MOVEM.L (A7)+,D2/D5-D7/A2
    UNLK    A5
    RTS

;!======