;------------------------------------------------------------------------------
; FUNC: UNKNOWN_ParseRecordAndUpdateDisplay   (Parse record, update globals, and display.)
; ARGS:
;   stack +8: A3 = input buffer pointer??
; RET:
;   D0: ?? (pass/fail via side effects)
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   JMPTBL_ESQ_WildcardMatch_2, JMPTBL_LAB_0B44_2, JMPTBL_DISPLIB_DisplayTextAtPosition_2
; READS:
;   LAB_2252, LAB_2245, LAB_1DEC, GLOB_REF_RASTPORT_1
; WRITES:
;   LAB_1DEC, LAB_227F, LAB_229B, LAB_229C
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
    PEA     LAB_2245
    JSR     JMPTBL_ESQ_WildcardMatch_2(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .return

    MOVE.L  LAB_1DEC,-(A7)
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_LAB_0B44_2(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_1DEC
    MOVE.B  D6,LAB_227F
    MOVE.B  D5,LAB_229B
    MOVE.B  D4,LAB_229C
    TST.W   LAB_2252
    BEQ.S   .return

    MOVE.L  LAB_1DEC,-(A7)
    PEA     172.W
    CLR.L   -(A7)
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMPTBL_DISPLIB_DisplayTextAtPosition_2(PC)

    LEA     16(A7),A7

.return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: UNKNOWN_ParseListAndUpdateEntries   (Parse list and update LAB_2197 entries.)
; ARGS:
;   stack +8: A3 = input buffer pointer??
; RET:
;   D0: ?? (pass/fail via side effects)
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   JMPTBL_ESQ_WildcardMatch_2, JMPTBL_DST_NormalizeDayOfYear_2, STRING_CopyPadNul, PARSE_ReadSignedLongSkipClass3_Alt, MATH_Mulu32
; READS:
;   LAB_2246, LAB_227C, LAB_2277, LAB_2197
; WRITES:
;   LAB_2196, LAB_2197 entries, LAB_229C?? (indirect)
; DESC:
;   Parses a list of records from the input buffer and updates LAB_2197
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
    PEA     LAB_2246
    JSR     JMPTBL_ESQ_WildcardMatch_2(PC)

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
    LEA     LAB_2197,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #1,D1
    MOVE.L  D1,16(A1)
    MOVE.W  LAB_227C,D1
    ADD.W   D7,D1
    MOVE.L  D1,D6
    ADDQ.W  #1,D6
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.W  LAB_2277,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,28(A7)
    JSR     JMPTBL_DST_NormalizeDayOfYear_2(PC)

    ADDQ.W  #8,A7
    EXT.L   D0
    MOVEA.L 20(A7),A0
    MOVE.L  D0,(A0)
    ADDQ.W  #1,D7
    BRA.S   .init_entries_loop

.after_init_entries:
    MOVE.B  (A3)+,LAB_2196
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

    LEA     LAB_2197,A0
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

    LEA     LAB_2197,A0
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

    LEA     LAB_2197,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #1,D0
    MOVE.L  D0,4(A1)
    BRA.S   .parse_field2

.parse_field1:
    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     MATH_Mulu32(PC)

    LEA     LAB_2197,A0
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

    LEA     LAB_2197,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  #(-999),8(A1)
    BRA.S   .parse_field3

.parse_field2_value:
    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     MATH_Mulu32(PC)

    LEA     LAB_2197,A0
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

    LEA     LAB_2197,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  #(-999),12(A1)
    BRA.S   .advance_entry

.parse_field3_value:
    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     MATH_Mulu32(PC)

    LEA     LAB_2197,A0
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
;   stack +8: D7 = ?? (byte parameter)
; RET:
;   D0: ?? (pass/fail via side effects)
; CLOBBERS:
;   D0-D7 ??
; CALLS:
;   JMPTBL_LAB_0B0E_2, JMPTBL_ESQ_GenerateXorChecksumByte_2, UNKNOWN_ParseRecordAndUpdateDisplay
; READS:
;   LAB_229A, LAB_2253, DATACErrs
; WRITES:
;   LAB_2285, LAB_2232, DATACErrs
; DESC:
;   Computes a checksum and, on success, invokes UNKNOWN_ParseRecordAndUpdateDisplay; otherwise bumps error count.
; NOTES:
;   Uses stack param byte at 11(A7).
;------------------------------------------------------------------------------
UNKNOWN_VerifyChecksumAndParseRecord:
    MOVE.L  D7,-(A7)

    MOVE.B  11(A7),D7
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_229A,-(A7)
    JSR     JMPTBL_LAB_0B0E_2(PC)

    MOVE.W  D0,LAB_2232
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMPTBL_ESQ_GenerateXorChecksumByte_2(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .checksum_mismatch

    MOVE.L  LAB_229A,-(A7)
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
;   stack +8: D7 = ?? (byte parameter)
; RET:
;   D0: ?? (pass/fail via side effects)
; CLOBBERS:
;   D0-D7 ??
; CALLS:
;   JMPTBL_LAB_0B0E_2, JMPTBL_ESQ_GenerateXorChecksumByte_2, UNKNOWN_ParseListAndUpdateEntries
; READS:
;   LAB_229A, LAB_2253, DATACErrs
; WRITES:
;   LAB_2285, LAB_2232, DATACErrs
; DESC:
;   Computes a checksum and, on success, invokes UNKNOWN_ParseListAndUpdateEntries; otherwise bumps error count.
; NOTES:
;   Uses stack param byte at 11(A7).
;------------------------------------------------------------------------------
UNKNOWN_VerifyChecksumAndParseList:
    MOVE.L  D7,-(A7)

    MOVE.B  11(A7),D7
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_229A,-(A7)
    JSR     JMPTBL_LAB_0B0E_2(PC)

    MOVE.W  D0,LAB_2232
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMPTBL_ESQ_GenerateXorChecksumByte_2(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .checksum_mismatch

    MOVE.L  LAB_229A,-(A7)
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
;   stack +8: A3 = input buffer pointer??
; RET:
;   D0: ?? (pass/fail via side effects)
; CLOBBERS:
;   D0-D2/D7/A0-A3 ??
; CALLS:
;   JMPTBL_LAB_0B44_2, JMPTBL_DISPLIB_DisplayTextAtPosition_2
; READS:
;   LAB_1DD9, LAB_2252, GLOB_REF_RASTPORT_1
; WRITES:
;   LAB_229D, LAB_1DD9, LAB_2245
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
    MOVE.W  D0,LAB_229D
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BLT.S   .clamp_digit

    MOVEQ   #57,D2
    CMP.W   D2,D0
    BLE.S   .start_copy

.clamp_digit:
    MOVE.W  D1,LAB_229D

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
    LEA     LAB_2245,A1

.copy_label:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_label

    MOVE.L  LAB_1DD9,-(A7)
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_LAB_0B44_2(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_1DD9
    TST.W   LAB_2252
    BEQ.S   .return

    MOVE.L  D0,-(A7)
    PEA     172.W
    CLR.L   -(A7)
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMPTBL_DISPLIB_DisplayTextAtPosition_2(PC)

    LEA     16(A7),A7

.return:
    MOVEM.L (A7)+,D2/D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: UNKNOWN_CopyLabelToGlobal   (Copy short label into LAB_2246.)
; ARGS:
;   stack +8: A3 = input buffer pointer??
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   none
; READS:
;   (none)
; WRITES:
;   LAB_2246
; DESC:
;   Copies a short label string from the input buffer into LAB_2246.
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
    LEA     LAB_2246,A1

.copy_label:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_label

    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: JMPTBL_LAB_0B0E_2   (JumpStub_LAB_0B0E)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   LAB_0B0E
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Jump stub to LAB_0B0E.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_LAB_0B0E_2:
    JMP     LAB_0B0E

;------------------------------------------------------------------------------
; FUNC: JMPTBL_DISPLIB_DisplayTextAtPosition_2   (JumpStub_DISPLIB_DisplayTextAtPosition)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   DISPLIB_DisplayTextAtPosition
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Jump stub to DISPLIB_DisplayTextAtPosition.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_DISPLIB_DisplayTextAtPosition_2:
    JMP     DISPLIB_DisplayTextAtPosition

;------------------------------------------------------------------------------
; FUNC: JMPTBL_ESQ_WildcardMatch_2   (JumpStub_ESQ_WildcardMatch)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   ESQ_WildcardMatch
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Jump stub to ESQ_WildcardMatch.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_ESQ_WildcardMatch_2:
    JMP     ESQ_WildcardMatch

;------------------------------------------------------------------------------
; FUNC: JMPTBL_DST_NormalizeDayOfYear_2   (JumpStub_LAB_0631)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   DST_NormalizeDayOfYear
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Jump stub to DST_NormalizeDayOfYear.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_DST_NormalizeDayOfYear_2:
    JMP     DST_NormalizeDayOfYear

;------------------------------------------------------------------------------
; FUNC: JMPTBL_ESQ_GenerateXorChecksumByte_2   (JumpStub_ESQ_GenerateXorChecksumByte)
; ARGS:
;   ??
; RET:
;   D0: checksum byte
; CLOBBERS:
;   ??
; CALLS:
;   ESQ_GenerateXorChecksumByte
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Jump stub to ESQ_GenerateXorChecksumByte.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_ESQ_GenerateXorChecksumByte_2:
    JMP     ESQ_GenerateXorChecksumByte

;------------------------------------------------------------------------------
; FUNC: JMPTBL_LAB_0B44_2   (JumpStub_LAB_0B44)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   LAB_0B44
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Jump stub to LAB_0B44.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_LAB_0B44_2:
    JMP     LAB_0B44

;!======

    ; Alignment
    RTS
    DC.W    $0000
