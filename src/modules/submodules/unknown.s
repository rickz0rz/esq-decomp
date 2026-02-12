;------------------------------------------------------------------------------
; FUNC: UNKNOWN_ParseRecordAndUpdateDisplay   (Parse record, update globals, and display.)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +12: arg_2 (via 16(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   UNKNOWN_JMPTBL_ESQ_WildcardMatch, UNKNOWN_JMPTBL_ESQPARS_ReplaceOwnedString, UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition
; READS:
;   ED_DiagnosticsScreenActive, WDISP_WeatherStatusLabelBuffer, WDISP_WeatherStatusOverlayTextPtr, Global_REF_RASTPORT_1
; WRITES:
;   WDISP_WeatherStatusOverlayTextPtr, WDISP_WeatherStatusCountdown, DATA_WDISP_BSS_BYTE_229B, WDISP_WeatherStatusBrushIndex
; DESC:
;   Parses a small record from the input buffer, validates via wildcard match,
;   updates globals, and optionally redraws text.
; NOTES:
;   Uses 0x12 sentinel and max length 10 for local buffer.
;------------------------------------------------------------------------------
UNKNOWN_ParseRecordAndUpdateDisplay:
    LINK.W  A5,#-16
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3

    MOVE.B  (A3)+,D6
    MOVE.B  (A3)+,D5
    MOVE.B  (A3)+,D4
    ADDQ.L  #1,A3
    MOVEQ   #2,D0
    CMP.B   D0,D4
    BCS.S   .set_default_type

    MOVEQ   #6,D0
    CMP.B   D0,D4
    BLS.S   .start_copy

.set_default_type:
    MOVEQ   #1,D4

.start_copy:
    MOVEQ   #0,D7

.copy_loop:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-16(A5,D7.W)
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BEQ.S   .copy_done

    MOVEQ   #10,D0
    CMP.W   D0,D7
    BGE.S   .copy_done

    ADDQ.W  #1,D7
    BRA.S   .copy_loop

.copy_done:
    MOVEQ   #0,D0
    MOVE.B  D0,-16(A5,D7.W)
    MOVE.B  -16(A5),D1
    TST.B   D1
    BEQ.S   .return

    PEA     -16(A5)
    PEA     WDISP_WeatherStatusLabelBuffer
    JSR     UNKNOWN_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .return

    MOVE.L  WDISP_WeatherStatusOverlayTextPtr,-(A7)
    MOVE.L  A3,-(A7)
    JSR     UNKNOWN_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,WDISP_WeatherStatusOverlayTextPtr
    MOVE.B  D6,WDISP_WeatherStatusCountdown
    MOVE.B  D5,DATA_WDISP_BSS_BYTE_229B
    MOVE.B  D4,WDISP_WeatherStatusBrushIndex
    TST.W   ED_DiagnosticsScreenActive
    BEQ.S   .return

    MOVE.L  WDISP_WeatherStatusOverlayTextPtr,-(A7)
    PEA     172.W
    CLR.L   -(A7)
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7

.return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: UNKNOWN_ParseListAndUpdateEntries   (Parse list and update WDISP_StatusDayEntry0 entries.)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +11: arg_2 (via 15(A5))
;   stack +18: arg_3 (via 22(A5))
;   stack +20: arg_4 (via 24(A5))
;   stack +21: arg_5 (via 25(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   UNKNOWN_JMPTBL_ESQ_WildcardMatch, UNKNOWN_JMPTBL_DST_NormalizeDayOfYear, STRING_CopyPadNul, PARSE_ReadSignedLongSkipClass3_Alt, MATH_Mulu32
; READS:
;   WDISP_StatusListMatchPattern, DATA_WDISP_BSS_WORD_227C, CLOCK_CurrentYearValue, WDISP_StatusDayEntry0
; WRITES:
;   DATA_TLIBA1_BSS_WORD_2196
; DESC:
;   Parses a list of records from the input buffer and updates WDISP_StatusDayEntry0
;   table entries, including optional numeric fields and flags.
; NOTES:
;   Uses 0x12 sentinel and max length 10 for local buffer.
;------------------------------------------------------------------------------
UNKNOWN_ParseListAndUpdateEntries:
    LINK.W  A5,#-36
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3

    MOVEQ   #0,D7

.copy_list_name:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-15(A5,D7.W)
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BEQ.S   .copy_list_done

    MOVEQ   #10,D0
    CMP.W   D0,D7
    BGE.S   .copy_list_done

    ADDQ.W  #1,D7
    BRA.S   .copy_list_name

.copy_list_done:
    MOVEQ   #0,D0
    MOVE.B  D0,-15(A5,D7.W)
    MOVE.B  -15(A5),D1
    TST.B   D1
    BEQ.W   .return

    PEA     -15(A5)
    PEA     WDISP_StatusListMatchPattern
    JSR     UNKNOWN_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.W   .return

    MOVEQ   #0,D7

.init_entries_loop:
    MOVEQ   #4,D0
    CMP.W   D0,D7
    BGE.S   .after_init_entries

    MOVE.L  D7,D0
    MULS    #20,D0
    LEA     WDISP_StatusDayEntry0,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #1,D1
    MOVE.L  D1,16(A1)
    MOVE.W  DATA_WDISP_BSS_WORD_227C,D1
    ADD.W   D7,D1
    MOVE.L  D1,D6
    ADDQ.W  #1,D6
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.W  CLOCK_CurrentYearValue,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,28(A7)
    JSR     UNKNOWN_JMPTBL_DST_NormalizeDayOfYear(PC)

    ADDQ.W  #8,A7
    EXT.L   D0
    MOVEA.L 20(A7),A0
    MOVE.L  D0,(A0)
    ADDQ.W  #1,D7
    BRA.S   .init_entries_loop

.after_init_entries:
    MOVE.B  (A3)+,DATA_TLIBA1_BSS_WORD_2196
    MOVE.B  (A3)+,D5

.parse_entries_loop:
    MOVEQ   #43,D0
    CMP.B   D0,D5
    BNE.W   .return

    PEA     3.W
    MOVE.L  A3,-(A7)
    PEA     -25(A5)
    JSR     STRING_CopyPadNul(PC)

    CLR.B   -22(A5)
    PEA     -25(A5)
    JSR     PARSE_ReadSignedLongSkipClass3_Alt(PC)

    LEA     16(A7),A7
    MOVE.L  D0,D6
    ADDQ.L  #3,A3
    MOVEQ   #0,D4

.find_entry_loop:
    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     MATH_Mulu32(PC)

    LEA     WDISP_StatusDayEntry0,A0
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    EXT.L   D0
    CMP.L   (A0),D0
    BEQ.S   .entry_found

    MOVEQ   #4,D0
    CMP.L   D0,D4
    BGE.S   .entry_found

    ADDQ.L  #1,D4
    BRA.S   .find_entry_loop

.entry_found:
    TST.L   D4
    BMI.S   .entry_not_found

    MOVEQ   #3,D0
    CMP.L   D0,D4
    BLE.S   .check_entry_marker

.entry_not_found:
    MOVEQ   #0,D5

.check_entry_marker:
    MOVEQ   #43,D0
    CMP.B   D0,D5
    BNE.W   .skip_entry

    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     MATH_Mulu32(PC)

    LEA     WDISP_StatusDayEntry0,A0
    ADDA.L  D0,A0
    CLR.L   16(A0)
    PEA     1.W
    MOVE.L  A3,-(A7)
    PEA     -25(A5)
    JSR     STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    CLR.B   -24(A5)
    MOVE.B  -25(A5),D0
    MOVEQ   #63,D1
    CMP.B   D1,D0
    BNE.S   .parse_field1

    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     MATH_Mulu32(PC)

    LEA     WDISP_StatusDayEntry0,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #1,D0
    MOVE.L  D0,4(A1)
    BRA.S   .parse_field2

.parse_field1:
    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     MATH_Mulu32(PC)

    LEA     WDISP_StatusDayEntry0,A0
    ADDA.L  D0,A0
    PEA     -25(A5)
    MOVE.L  A0,24(A7)
    JSR     PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVEA.L 20(A7),A0
    MOVE.L  D0,4(A0)

.parse_field2:
    ADDQ.L  #1,A3
    PEA     3.W
    MOVE.L  A3,-(A7)
    PEA     -25(A5)
    JSR     STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    CLR.B   -22(A5)
    MOVE.B  -25(A5),D0
    MOVEQ   #63,D1
    CMP.B   D1,D0
    BNE.S   .parse_field2_value

    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     MATH_Mulu32(PC)

    LEA     WDISP_StatusDayEntry0,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  #(-999),8(A1)
    BRA.S   .parse_field3

.parse_field2_value:
    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     MATH_Mulu32(PC)

    LEA     WDISP_StatusDayEntry0,A0
    ADDA.L  D0,A0
    PEA     -25(A5)
    MOVE.L  A0,24(A7)
    JSR     PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVEA.L 20(A7),A0
    MOVE.L  D0,8(A0)

.parse_field3:
    ADDQ.L  #3,A3
    PEA     3.W
    MOVE.L  A3,-(A7)
    PEA     -25(A5)
    JSR     STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    CLR.B   -22(A5)
    MOVE.B  -25(A5),D0
    MOVEQ   #63,D1
    CMP.B   D1,D0
    BNE.S   .parse_field3_value

    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     MATH_Mulu32(PC)

    LEA     WDISP_StatusDayEntry0,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  #(-999),12(A1)
    BRA.S   .advance_entry

.parse_field3_value:
    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     MATH_Mulu32(PC)

    LEA     WDISP_StatusDayEntry0,A0
    ADDA.L  D0,A0
    PEA     -25(A5)
    MOVE.L  A0,24(A7)
    JSR     PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVEA.L 20(A7),A0
    MOVE.L  D0,12(A0)

.advance_entry:
    ADDQ.L  #3,A3
    MOVE.B  (A3)+,D5
    BRA.W   .parse_entries_loop

.skip_entry:
    ADDQ.L  #7,A3
    MOVE.B  (A3)+,D5
    BRA.W   .parse_entries_loop

.return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: UNKNOWN_VerifyChecksumAndParseRecord   (Validate checksum and dispatch to record parser.)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D7
; CALLS:
;   UNKNOWN_JMPTBL_ESQIFF2_ReadSerialRecordIntoBuffer, UNKNOWN_JMPTBL_ESQ_GenerateXorChecksumByte, UNKNOWN_ParseRecordAndUpdateDisplay
; READS:
;   ESQIFF_RecordBufferPtr, ESQIFF_RecordChecksumByte, DATACErrs
; WRITES:
;   ESQIFF_ParseAttemptCount, ESQIFF_RecordLength, DATACErrs
; DESC:
;   Computes a checksum and, on success, invokes UNKNOWN_ParseRecordAndUpdateDisplay; otherwise bumps error count.
; NOTES:
;   Uses stack param byte at 11(A7).
;------------------------------------------------------------------------------
UNKNOWN_VerifyChecksumAndParseRecord:
    MOVE.L  D7,-(A7)

    MOVE.B  11(A7),D7
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    JSR     UNKNOWN_JMPTBL_ESQIFF2_ReadSerialRecordIntoBuffer(PC)

    MOVE.W  D0,ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #0,D1
    MOVE.W  ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     UNKNOWN_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .checksum_mismatch

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   UNKNOWN_ParseRecordAndUpdateDisplay

    ADDQ.W  #4,A7
    BRA.S   .return

.checksum_mismatch:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: UNKNOWN_VerifyChecksumAndParseList   (Validate checksum and dispatch to list parser.)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D7
; CALLS:
;   UNKNOWN_JMPTBL_ESQIFF2_ReadSerialRecordIntoBuffer, UNKNOWN_JMPTBL_ESQ_GenerateXorChecksumByte, UNKNOWN_ParseListAndUpdateEntries
; READS:
;   ESQIFF_RecordBufferPtr, ESQIFF_RecordChecksumByte, DATACErrs
; WRITES:
;   ESQIFF_ParseAttemptCount, ESQIFF_RecordLength, DATACErrs
; DESC:
;   Computes a checksum and, on success, invokes UNKNOWN_ParseListAndUpdateEntries; otherwise bumps error count.
; NOTES:
;   Uses stack param byte at 11(A7).
;------------------------------------------------------------------------------
UNKNOWN_VerifyChecksumAndParseList:
    MOVE.L  D7,-(A7)

    MOVE.B  11(A7),D7
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    JSR     UNKNOWN_JMPTBL_ESQIFF2_ReadSerialRecordIntoBuffer(PC)

    MOVE.W  D0,ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #0,D1
    MOVE.W  ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     UNKNOWN_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .checksum_mismatch

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   UNKNOWN_ParseListAndUpdateEntries

    ADDQ.W  #4,A7
    BRA.S   .return

.checksum_mismatch:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: UNKNOWN_ParseDigitLabelAndDisplay   (Parse digit + label, update globals, and display.)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +9: arg_2 (via 13(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A7/D0/D1/D2/D7
; CALLS:
;   UNKNOWN_JMPTBL_ESQPARS_ReplaceOwnedString, UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition
; READS:
;   WDISP_WeatherStatusTextPtr, ED_DiagnosticsScreenActive, Global_REF_RASTPORT_1
; WRITES:
;   WDISP_WeatherStatusDigitChar, WDISP_WeatherStatusTextPtr, WDISP_WeatherStatusLabelBuffer
; DESC:
;   Parses a digit plus a short label string, stores it, and optionally redraws text.
; NOTES:
;   Clamps digit to '0'..'9'; uses 0x12 sentinel and max length 10 for label.
;------------------------------------------------------------------------------
UNKNOWN_ParseDigitLabelAndDisplay:
    LINK.W  A5,#-16
    MOVEM.L D2/D7/A3,-(A7)
    MOVEA.L 8(A5),A3

    MOVEQ   #0,D0
    MOVE.B  (A3)+,D0
    MOVE.W  D0,WDISP_WeatherStatusDigitChar
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BLT.S   .clamp_digit

    MOVEQ   #57,D2
    CMP.W   D2,D0
    BLE.S   .start_copy

.clamp_digit:
    MOVE.W  D1,WDISP_WeatherStatusDigitChar

.start_copy:
    MOVEQ   #0,D7

.copy_loop:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-13(A5,D7.W)
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BEQ.S   .copy_done

    MOVEQ   #10,D0
    CMP.W   D0,D7
    BGE.S   .copy_done

    ADDQ.W  #1,D7
    BRA.S   .copy_loop

.copy_done:
    CLR.B   -13(A5,D7.W)
    LEA     -13(A5),A0
    LEA     WDISP_WeatherStatusLabelBuffer,A1

.copy_label:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_label

    MOVE.L  WDISP_WeatherStatusTextPtr,-(A7)
    MOVE.L  A3,-(A7)
    JSR     UNKNOWN_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,WDISP_WeatherStatusTextPtr
    TST.W   ED_DiagnosticsScreenActive
    BEQ.S   .return

    MOVE.L  D0,-(A7)
    PEA     172.W
    CLR.L   -(A7)
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7

.return:
    MOVEM.L (A7)+,D2/D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: UNKNOWN_CopyLabelToGlobal   (Copy short label into WDISP_StatusListMatchPattern.)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +9: arg_2 (via 13(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A7/D0/D1/D7
; CALLS:
;   none
; READS:
;   (none)
; WRITES:
;   WDISP_StatusListMatchPattern
; DESC:
;   Copies a short label string from the input buffer into WDISP_StatusListMatchPattern.
; NOTES:
;   Uses 0x12 sentinel and max length 10 for label.
;------------------------------------------------------------------------------
UNKNOWN_CopyLabelToGlobal:
    LINK.W  A5,#-16
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D7

.copy_loop:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-13(A5,D7.W)
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BEQ.S   .copy_done

    MOVEQ   #10,D0
    CMP.W   D0,D7
    BGE.S   .copy_done

    ADDQ.W  #1,D7
    BRA.S   .copy_loop

.copy_done:
    CLR.B   -13(A5,D7.W)
    LEA     -13(A5),A0
    LEA     WDISP_StatusListMatchPattern,A1

.copy_label:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_label

    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: UNKNOWN_JMPTBL_ESQIFF2_ReadSerialRecordIntoBuffer   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQIFF2_ReadSerialRecordIntoBuffer
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to ESQIFF2_ReadSerialRecordIntoBuffer.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
UNKNOWN_JMPTBL_ESQIFF2_ReadSerialRecordIntoBuffer:
    JMP     ESQIFF2_ReadSerialRecordIntoBuffer

;------------------------------------------------------------------------------
; FUNC: UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition   (JumpStub_DISPLIB_DisplayTextAtPosition)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DISPLIB_DisplayTextAtPosition
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to DISPLIB_DisplayTextAtPosition.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition:
    JMP     DISPLIB_DisplayTextAtPosition

;------------------------------------------------------------------------------
; FUNC: UNKNOWN_JMPTBL_ESQ_WildcardMatch   (JumpStub_ESQ_WildcardMatch)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_WildcardMatch
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to ESQ_WildcardMatch.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
UNKNOWN_JMPTBL_ESQ_WildcardMatch:
    JMP     ESQ_WildcardMatch

;------------------------------------------------------------------------------
; FUNC: UNKNOWN_JMPTBL_DST_NormalizeDayOfYear   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DST_NormalizeDayOfYear
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to DST_NormalizeDayOfYear.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
UNKNOWN_JMPTBL_DST_NormalizeDayOfYear:
    JMP     DST_NormalizeDayOfYear

;------------------------------------------------------------------------------
; FUNC: UNKNOWN_JMPTBL_ESQ_GenerateXorChecksumByte   (JumpStub_ESQ_GenerateXorChecksumByte)
; ARGS:
;   (none observed)
; RET:
;   D0: checksum byte
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_GenerateXorChecksumByte
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to ESQ_GenerateXorChecksumByte.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
UNKNOWN_JMPTBL_ESQ_GenerateXorChecksumByte:
    JMP     ESQ_GenerateXorChecksumByte

;------------------------------------------------------------------------------
; FUNC: UNKNOWN_JMPTBL_ESQPARS_ReplaceOwnedString   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQPARS_ReplaceOwnedString
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to ESQPARS_ReplaceOwnedString.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
UNKNOWN_JMPTBL_ESQPARS_ReplaceOwnedString:
    JMP     ESQPARS_ReplaceOwnedString

;!======

    ; Alignment
    RTS
    DC.W    $0000
