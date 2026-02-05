;------------------------------------------------------------------------------
; FUNC: TEXTDISP_FindEntryIndexByWildcard   (Find entry index by pattern)
; ARGS:
;   stack +8: patternPtr
; RET:
;   D0: 1 if found, 0 if not
; CLOBBERS:
;   D0/D7/A2-A3
; CALLS:
;   JMPTBL_ESQ_WildcardMatch_2
; READS:
;   LAB_2233, LAB_2236, LAB_2364
; WRITES:
;   LAB_2364
; DESC:
;   Scans entries and updates LAB_2364 with the first match index.
; NOTES:
;   Skips entries with flag bit 3 set.
;------------------------------------------------------------------------------
TEXTDISP_FindEntryIndexByWildcard:
    LINK.W  A5,#-12
    MOVEM.L D7/A2-A3,-(A7)
    MOVE.W  LAB_2364,LAB_236E
    MOVEQ   #0,D7

.loop_entries:
    MOVE.W  LAB_2231,D0
    CMP.W   D0,D7
    BGE.S   .not_found

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2236,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A3
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    BTST    #3,27(A2)
    BNE.S   .next_entry

    MOVE.L  8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_ESQ_WildcardMatch_2(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .next_entry

    MOVE.W  D7,LAB_2364
    MOVEQ   #1,D0
    BRA.S   .return

.next_entry:
    ADDQ.W  #1,D7
    BRA.S   .loop_entries

.not_found:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_FindAliasIndexByName   (Find alias index for entry name)
; ARGS:
;   stack +8: entryPtr (A3)
; RET:
;   D0: alias index (0..LAB_1DDA-1) or -1 if not found
; CLOBBERS:
;   D0/D7/A0-A3
; CALLS:
;   STRING_CompareNoCaseN
; READS:
;   LAB_1DDA, LAB_224F
; DESC:
;   Compares entry name (offset +12) against alias table entries.
; NOTES:
;   Copies the entry name to a stack buffer before comparison.
;------------------------------------------------------------------------------
TEXTDISP_FindAliasIndexByName:
    LINK.W  A5,#-24
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    LEA     12(A3),A0
    LEA     -21(A5),A1

.copy_name:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_name

    MOVEQ   #0,D7

.loop_aliases:
    MOVE.W  LAB_1DDA,D0
    CMP.W   D0,D7
    BGE.S   .not_found

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_224F,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    MOVEA.L (A2),A0

.measure_alias:
    TST.B   (A0)+
    BNE.S   .measure_alias

    SUBQ.L  #1,A0
    SUBA.L  (A2),A0
    MOVE.L  A0,-(A7)
    MOVE.L  (A2),-(A7)
    PEA     -21(A5)
    JSR     STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .next_alias

    MOVE.L  D7,D0
    BRA.S   .return

.next_alias:
    ADDQ.W  #1,D7
    BRA.S   .loop_aliases

.not_found:
    MOVEQ   #-1,D0

.return:
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_FindControlToken   (Find control token in text)
; ARGS:
;   stack +8: textPtr (A3)
; RET:
;   D0: pointer to control token, or 0 if none
; CLOBBERS:
;   D0/A3
; DESC:
;   Scans for 0x80+ control tokens in a known opcode set.
; NOTES:
;   Returns the first matching token byte.
;   Control tokens: 0x84, 0x85, 0x86, 0x87, 0x8C, 0x8D, 0x8F, 0x90, 0x93, 0x99, 0x9A, 0x9B, 0xA3
;------------------------------------------------------------------------------
TEXTDISP_FindControlToken:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3

.scan_loop:
    TST.B   (A3)
    BEQ.S   .not_found

    BTST    #7,(A3)
    BEQ.S   .skip_byte

    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    SUBI.W  #$84,D0
    BEQ.S   .found_token

    SUBQ.W  #1,D0
    BEQ.S   .found_token

    SUBQ.W  #1,D0
    BEQ.S   .found_token

    SUBQ.W  #1,D0
    BEQ.S   .found_token

    SUBQ.W  #5,D0
    BEQ.S   .found_token

    SUBQ.W  #1,D0
    BEQ.S   .found_token

    SUBQ.W  #2,D0
    BEQ.S   .found_token

    SUBQ.W  #1,D0
    BEQ.S   .found_token

    SUBQ.W  #3,D0
    BEQ.S   .found_token

    SUBQ.W  #6,D0
    BEQ.S   .found_token

    SUBQ.W  #1,D0
    BEQ.S   .found_token

    SUBQ.W  #1,D0
    BEQ.S   .found_token

    SUBQ.W  #8,D0
    BNE.S   .skip_byte

.found_token:
    MOVE.L  A3,D0
    BRA.S   .return

.skip_byte:
    ADDQ.L  #1,A3
    BRA.S   .scan_loop

.not_found:
    MOVEQ   #0,D0

.return:
    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_FindQuotedSpan   (Find quoted span in text)
; ARGS:
;   stack +8: textPtr (A3)
;   stack +12: outStartPtr (A2)
;   stack +16: endPtr (optional)
;   stack +20: outHasQuotes (ptr)
; RET:
;   D0: span length (bytes)
; CLOBBERS:
;   D0/D7/A0-A3
; CALLS:
;   UNKNOWN7_FindCharWrapper
; READS:
;   LAB_21A8
; WRITES:
;   (outStartPtr), (outHasQuotes)
; DESC:
;   Finds a quoted segment or falls back to the full string/end pointer,
;   then trims leading/trailing control bytes.
; NOTES:
;   Uses 0x22 (\") as the delimiter.
;------------------------------------------------------------------------------
TEXTDISP_FindQuotedSpan:
    LINK.W  A5,#-12
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    CLR.L   -8(A5)
    MOVEA.L 20(A5),A0
    CLR.L   (A0)
    PEA     34.W
    MOVE.L  A3,-(A7)
    JSR     UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   .check_second_quote

    MOVEA.L D0,A0
    ADDQ.L  #1,A0
    PEA     34.W
    MOVE.L  A0,-(A7)
    JSR     UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)

.check_second_quote:
    TST.L   -8(A5)
    BNE.S   .mark_has_quotes

    TST.L   -4(A5)
    BNE.S   .maybe_skip_prefix

    MOVEA.L A3,A0
    MOVE.L  A0,-4(A5)

.maybe_skip_prefix:
    MOVEQ   #40,D0
    MOVEA.L -4(A5),A0
    CMP.B   (A0),D0
    BNE.S   .select_end_ptr

    ADDQ.L  #8,-4(A5)

.select_end_ptr:
    MOVEA.L 16(A5),A0
    MOVE.L  A0,-8(A5)
    BEQ.S   .scan_to_end

    SUBQ.L  #1,-8(A5)
    BRA.S   .trim_leading_ctrl

.scan_to_end:
    MOVEA.L A3,A0

.scan_to_end_loop:
    TST.B   (A0)+
    BNE.S   .scan_to_end_loop

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D0
    MOVEA.L A3,A1
    ADDA.L  D0,A1
    SUBQ.L  #1,A1
    MOVE.L  A1,-8(A5)
    BRA.S   .trim_leading_ctrl

.mark_has_quotes:
    MOVEQ   #1,D0
    MOVEA.L 20(A5),A0
    MOVE.L  D0,(A0)

.trim_leading_ctrl:
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .trim_trailing_ctrl

    ADDQ.L  #1,-4(A5)
    BRA.S   .trim_leading_ctrl

.trim_trailing_ctrl:
    MOVEA.L -8(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .return

    SUBQ.L  #1,-8(A5)
    BRA.S   .trim_trailing_ctrl

.return:
    MOVEA.L -4(A5),A0
    MOVE.L  A0,(A2)
    MOVE.L  -8(A5),D0
    SUB.L   -4(A5),D0
    MOVE.L  D0,D7
    ADDQ.L  #1,D7
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_FindEntryMatchIndex   (Find entry index by text match)
; ARGS:
;   stack +8: textPtr
;   stack +14: mode (word, 1/2/3)
;   stack +19: requiredFlagsMask (byte)
; RET:
;   D0: entry index (0..48) or 49 if not found
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   TEXTDISP_FindControlToken, TEXTDISP_FindQuotedSpan,
;   GROUPD_JMPTBL_LAB_054C, GROUPD_JMPTBL_LAB_0923/0926,
;   GROUPD_JMPTBL_ESQ_TestBit1Based, STRING_CompareNoCase,
;   GROUPD_JMPTBL_ESQ_FindSubstringCaseFold
; READS:
;   LAB_2153, LAB_2364, LAB_2233/2235/2236/2237, LAB_21A8
; DESC:
;   Scans entries for a name match using optional control tokens and
;   case-insensitive comparisons. Supports forward/backward modes.
; NOTES:
;   Returns 49 when input is empty or no match is found.
;------------------------------------------------------------------------------
TEXTDISP_FindEntryMatchIndex:
    LINK.W  A5,#-56
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVE.W  14(A5),D7
    MOVE.B  19(A5),D6
    MOVEQ   #0,D0
    SUBA.L  A0,A0
    MOVE.L  A0,-34(A5)
    MOVE.L  A0,-38(A5)
    MOVE.L  D0,-22(A5)
    MOVE.L  D0,-18(A5)
    MOVEA.L 8(A5),A0
    TST.B   (A0)
    BNE.S   .have_input

    MOVEQ   #49,D0
    BRA.W   .return

.have_input:
    MOVE.W  LAB_2153,D0
    SUBQ.W  #1,D0
    BNE.S   .select_group_default

    MOVEQ   #0,D0
    MOVE.W  LAB_2270,D0
    BRA.S   .store_group_count

.select_group_default:
    MOVEQ   #1,D0

.store_group_count:
    MOVE.L  D0,D5
    MOVE.W  LAB_2153,D0
    SUBQ.W  #1,D0
    BNE.S   .load_group2_tables

    MOVE.W  LAB_2364,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0926(PC)

    MOVEA.L D0,A3
    MOVE.W  LAB_2364,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0923(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A2
    BRA.S   .dispatch_mode

.load_group2_tables:
    MOVE.W  LAB_2364,D0
    EXT.L   D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0926(PC)

    MOVEA.L D0,A3
    MOVE.W  LAB_2364,D0
    EXT.L   D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0923(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A2

.dispatch_mode:
    MOVEQ   #2,D0
    CMP.W   D0,D7
    BNE.S   .mode_forward

    MOVE.W  LAB_2153,D0
    SUBQ.W  #1,D0
    BNE.S   .group1_count

    MOVEQ   #0,D0
    MOVE.W  LAB_2270,D0
    ADDQ.L  #1,D0
    BRA.S   .store_group1_count

.group1_count:
    MOVEQ   #1,D0

.store_group1_count:
    MOVE.L  D0,D5
    BRA.W   .begin_scan

.mode_forward:
    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   .mode_backward

    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A2,-(A7)
    JSR     GROUPD_JMPTBL_LAB_054C(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5
    TST.W   D5
    BEQ.S   .mode_forward_fallback

    BTST    #7,7(A3,D5.W)
    BEQ.S   .begin_scan

.mode_forward_fallback:
    MOVE.W  LAB_2153,D0
    SUBQ.W  #1,D0
    BNE.S   .mode_forward_group2_count

    MOVEQ   #0,D0
    MOVE.W  LAB_2270,D0
    BRA.S   .mode_forward_store_default

.mode_forward_group2_count:
    MOVEQ   #1,D0

.mode_forward_store_default:
    MOVE.L  D0,D5
    BRA.S   .begin_scan

.mode_backward:
    MOVEQ   #3,D0
    CMP.W   D0,D7
    BNE.S   .mode_default

    MOVE.L  D5,D0
    EXT.L   D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A2,-(A7)
    JSR     GROUPD_JMPTBL_LAB_054C(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5
    TST.W   D5
    BEQ.S   .mode_backward_fallback

    BTST    #7,7(A3,D5.W)
    BEQ.S   .begin_scan

.mode_backward_fallback:
    MOVE.W  LAB_2153,D0
    SUBQ.W  #1,D0
    BNE.S   .mode_backward_group2_count

    MOVEQ   #0,D0
    MOVE.W  LAB_2270,D0
    BRA.S   .mode_backward_store_default

.mode_backward_group2_count:
    MOVEQ   #1,D0

.mode_backward_store_default:
    MOVE.L  D0,D5
    BRA.S   .begin_scan

.mode_default:
    MOVEQ   #1,D5

.begin_scan:
    MOVE.L  8(A5),-(A7)
    BSR.W   TEXTDISP_FindControlToken

    PEA     -26(A5)
    MOVE.L  D0,-(A7)
    PEA     -34(A5)
    MOVE.L  8(A5),-(A7)
    MOVE.L  D0,-52(A5)
    BSR.W   TEXTDISP_FindQuotedSpan

    LEA     20(A7),A7
    MOVEA.L -34(A5),A0
    ADDA.L  D0,A0
    MOVE.B  (A0),D1
    CLR.B   (A0)
    MOVE.L  D0,-44(A5)
    MOVE.B  D1,-39(A5)

.scan_loop:
    MOVEQ   #49,D0
    CMP.W   D0,D5
    BGE.W   .restore_input_char

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    TST.L   56(A3,D0.L)
    BEQ.W   .next_entry

    MOVE.B  7(A3,D5.W),D0
    AND.B   D6,D0
    CMP.B   D6,D0
    BNE.W   .next_entry

    LEA     28(A2),A0
    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     GROUPD_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   .next_entry

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L 56(A3,D0.L),A0
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-14(A5)
    BSR.W   TEXTDISP_FindControlToken

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.L  D0,-56(A5)
    MOVE.L  D1,-18(A5)
    MOVE.L  D1,-22(A5)
    TST.L   -52(A5)
    BNE.S   .compare_control_token

    MOVEQ   #1,D1
    MOVE.L  D1,-22(A5)
    BRA.S   .compare_entry_text

.compare_control_token:
    TST.L   D0
    BEQ.S   .compare_entry_text

    MOVEA.L -52(A5),A0
    MOVE.B  (A0),D1
    MOVEA.L D0,A0
    CMP.B   (A0),D1
    BNE.S   .compare_entry_text

    MOVEQ   #1,D1
    MOVE.L  D1,-22(A5)

.compare_entry_text:
    MOVEQ   #1,D1
    CMP.L   -22(A5),D1
    BNE.W   .check_match

    PEA     -30(A5)
    MOVE.L  D0,-(A7)
    PEA     -38(A5)
    MOVE.L  -14(A5),-(A7)
    BSR.W   TEXTDISP_FindQuotedSpan

    LEA     16(A7),A7
    MOVEA.L -38(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  (A1),D1
    CLR.B   (A1)
    MOVE.L  D0,-48(A5)
    MOVE.B  D1,-40(A5)
    TST.L   -26(A5)
    BEQ.S   .substring_match

    TST.L   -30(A5)
    BEQ.S   .restore_entry_char

    MOVE.L  -44(A5),D1
    CMP.L   D0,D1
    BNE.S   .restore_entry_char

    MOVE.L  -38(A5),-(A7)
    MOVE.L  -34(A5),-(A7)
    JSR     STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    SEQ     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,-18(A5)
    BRA.S   .restore_entry_char

.substring_match:
    MOVE.L  -44(A5),D1
    CMP.L   D0,D1
    BGT.S   .restore_entry_char

    MOVE.L  -34(A5),-(A7)
    MOVE.L  -38(A5),-(A7)
    JSR     GROUPD_JMPTBL_ESQ_FindSubstringCaseFold(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    SNE     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,-18(A5)

.restore_entry_char:
    MOVEA.L -38(A5),A0
    ADDA.L  -48(A5),A0
    MOVE.B  -40(A5),D0
    MOVE.B  D0,(A0)

.check_match:
    TST.L   -18(A5)
    BEQ.S   .next_entry

    TST.L   -22(A5)
    BNE.S   .restore_input_char

.next_entry:
    ADDQ.W  #1,D5
    BRA.W   .scan_loop

.restore_input_char:
    MOVEA.L -34(A5),A0
    ADDA.L  -44(A5),A0
    MOVE.B  -39(A5),D0
    MOVE.B  D0,(A0)
    MOVE.L  D5,D0

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_DrawInsetRectFrame   (Draw inset rectangle)
; ARGS:
;   stack +8: rectPtr
;   stack +14: mode (word)
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   LAB_1789
; READS:
;   LAB_2216
; DESC:
;   Computes a rectangle from LAB_2216 metrics and draws it via LAB_1789.
; NOTES:
;   Mode 2 adjusts half-width; mode 3 uses rastport defaults.
;------------------------------------------------------------------------------
TEXTDISP_DrawInsetRectFrame:
LAB_16CE:
    LINK.W  A5,#-8
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVEQ   #0,D6
    MOVEA.L LAB_2216,A0
    MOVE.W  2(A0),D0
    MOVE.L  D0,D4
    SUBQ.W  #1,D4
    MOVEQ   #0,D5
    MOVE.W  4(A0),D0
    SUBQ.W  #1,D0
    MOVEM.W D0,-8(A5)
    MOVEQ   #2,D1
    CMP.W   D1,D7
    BNE.S   .check_mode_3

    MOVE.L  D4,D1
    TST.W   D1
    BPL.S   .calc_half_width

    ADDQ.W  #1,D1

.calc_half_width:
    ASR.W   #1,D1
    MOVE.L  D1,D6
    ADDQ.W  #1,D6

.check_mode_3:
    MOVEQ   #3,D1
    CMP.W   D1,D7
    BNE.S   .draw_in_entry_rast

    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    MOVE.L  D4,D3
    EXT.L   D3
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  GLOB_REF_RASTPORT_2,-(A7)
    BSR.W   LAB_1789

    LEA     24(A7),A7
    BRA.S   .return

.draw_in_entry_rast:
    LEA     10(A0),A1
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D4,D2
    EXT.L   D2
    MOVE.W  -8(A5),D3
    EXT.L   D3
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A1,-(A7)
    BSR.W   LAB_1789

    LEA     24(A7),A7

.return:
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_BuildEntryShortName   (Build entry display name)
; ARGS:
;   stack +8: entryPtr (A3)
;   stack +12: outPtr (A2)
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   TEXTDISP_FindAliasIndexByName, STRING_AppendAtNull
; READS:
;   LAB_224F, LAB_2157
; DESC:
;   Writes a short display name to outPtr, using alias table when available.
; NOTES:
;   Falls back to entry+19 and prefixes a center-align token when short.
;------------------------------------------------------------------------------
TEXTDISP_BuildEntryShortName:
    LINK.W  A5,#-12
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    CLR.B   (A2)
    MOVE.L  A3,D0
    BEQ.S   .return

    MOVE.L  A3,-(A7)
    BSR.W   TEXTDISP_FindAliasIndexByName

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    EXT.L   D7
    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BEQ.S   .fallback_entry_name

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_224F,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    MOVEA.L -4(A5),A1
    MOVEA.L 4(A1),A0
    MOVEA.L A2,A1

.copy_alias:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_alias

    BRA.S   .return

.fallback_entry_name:
    LEA     19(A3),A0
    MOVEA.L A0,A1

.measure_fallback:
    TST.B   (A1)+
    BNE.S   .measure_fallback

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D6
    MOVEQ   #8,D0
    CMP.L   D0,D6
    BGE.S   .return

    TST.L   D6
    BEQ.S   .return

    LEA     LAB_2157,A0
    MOVEA.L A2,A1

.prepend_align:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .prepend_align

    LEA     19(A3),A0
    MOVE.L  A0,-(A7)
    MOVE.L  A2,-(A7)
    JSR     STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.return:
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_BuildChannelLabel   (Build \"On Channel\" label)
; ARGS:
;   stack +10: includeOnPrefix (word)
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   GROUPD_JMPTBL_LAB_0923, STRING_AppendAtNull
; READS:
;   LAB_2364, LAB_2153
; WRITES:
;   LAB_2258, LAB_2259, LAB_237A
; DESC:
;   Builds LAB_2259 as \"On Channel <name>\" and sets LAB_237A when valid.
; NOTES:
;   Uses group 1/2 based on LAB_2153.
;------------------------------------------------------------------------------
TEXTDISP_BuildChannelLabel:
    LINK.W  A5,#-20
    MOVEM.L D6-D7/A3,-(A7)
    MOVE.W  10(A5),D7
    MOVE.W  LAB_2364,D0
    EXT.L   D0
    TST.W   LAB_2153
    BEQ.S   .select_group

    MOVEQ   #1,D1
    BRA.S   .dispatch_group

.select_group:
    MOVEQ   #2,D1

.dispatch_group:
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0923(PC)

    ADDQ.W  #8,A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BEQ.S   .clear_name

    LEA     1(A3),A0
    LEA     -17(A5),A1

.copy_entry_name:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_entry_name

    BRA.S   .measure_name

.clear_name:
    CLR.B   -17(A5)

.measure_name:
    LEA     -17(A5),A0
    MOVEA.L A0,A1

.measure_loop:
    TST.B   (A1)+
    BNE.S   .measure_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D6
    CLR.L   LAB_237A
    MOVEQ   #1,D0
    CMP.W   D0,D6
    BLE.S   .return

    MOVE.L  D6,D0
    EXT.L   D0
    MOVEQ   #32,D1
    CMP.B   -19(A5,D0.L),D1
    BEQ.S   .return

    TST.W   D7
    BEQ.S   .append_channel_prefix

    PEA     GLOB_STR_ALIGNED_ON
    PEA     LAB_2259
    JSR     STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.append_channel_prefix:
    PEA     GLOB_STR_ALIGNED_CHANNEL_1
    PEA     LAB_2259
    JSR     STRING_AppendAtNull(PC)

    LEA     1(A3),A0
    MOVE.L  A0,(A7)
    PEA     LAB_2259
    JSR     STRING_AppendAtNull(PC)

    LEA     12(A7),A7
    LEA     LAB_2259,A0
    MOVEA.L A0,A1

.finalize_label:
    TST.B   (A1)+
    BNE.S   .finalize_label

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    LEA     LAB_2258,A0
    ADDA.L  D0,A0
    CLR.B   (A0)
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_237A

.return:
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_DrawChannelBanner   (Draw banner with channel label)
; ARGS:
;   stack +10: mode (word)
;   stack +14: drawMode (word)
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   GROUPD_JMPTBL_LAB_0923, TEXTDISP_BuildEntryShortName,
;   TEXTDISP_BuildChannelLabel, _LVOSetDrMd, LAB_1789, TEXTDISP_DrawInsetRectFrame
; READS:
;   LAB_2364, LAB_2153, LAB_2216
; WRITES:
;   LAB_236B, LAB_236C, LAB_236D
; DESC:
;   Builds banner text and draws it in the selected rastport.
; NOTES:
;   Uses LAB_2153 to switch between group 1/2 layouts.
;------------------------------------------------------------------------------
TEXTDISP_DrawChannelBanner:
    LINK.W  A5,#-8
    MOVEM.L D5-D7,-(A7)
    MOVE.W  10(A5),D7
    MOVE.W  14(A5),D6
    MOVE.W  LAB_2364,D0
    EXT.L   D0
    TST.W   LAB_2153
    BEQ.S   .select_group2

    MOVEQ   #1,D1
    BRA.S   .dispatch_group

.select_group2:
    MOVEQ   #2,D1

.dispatch_group:
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUPD_JMPTBL_LAB_0923(PC)

    PEA     LAB_236B
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-4(A5)
    BSR.W   TEXTDISP_BuildEntryShortName

    LEA     LAB_236B,A0
    LEA     LAB_2259,A1

.copy_short_name:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_short_name

    PEA     1.W
    BSR.W   TEXTDISP_BuildChannelLabel

    LEA     20(A7),A7
    CLR.W   LAB_236D
    MOVEQ   #3,D0
    CMP.W   D0,D6
    BNE.S   .select_rast

    MOVEA.L GLOB_REF_RASTPORT_2,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    BRA.S   .init_rect

.select_rast:
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

.init_rect:
    MOVE.W  #1,LAB_236C
    MOVEQ   #0,D5
    MOVEA.L LAB_2216,A0
    MOVE.W  2(A0),D5
    MOVEQ   #2,D0
    CMP.W   D0,D7
    BNE.S   .trim_and_draw

    TST.L   D5
    BPL.S   .adjust_half_width

    ADDQ.L  #1,D5

.adjust_half_width:
    ASR.L   #1,D5

.trim_and_draw:
    MOVE.L  D5,-(A7)
    PEA     LAB_2259
    BSR.W   TEXTDISP_TrimTextToPixelWidth

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     LAB_2259
    BSR.W   TEXTDISP_DrawInsetRectFrame

    LEA     12(A7),A7
    MOVEQ   #3,D0
    CMP.W   D0,D6
    BNE.S   .set_drawmode_normal

    MOVEA.L GLOB_REF_RASTPORT_2,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    BRA.S   .return

.set_drawmode_normal:
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

.return:
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_FormatEntryTime   (Format time for entry)
; ARGS:
;   stack +8: outPtr (A3)
;   stack +14: entryIndex (word)
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   GROUPD_JMPTBL_LAB_08DF, MATH_DivS32, MATH_Mulu32, LAB_17CE
; READS:
;   LAB_2236/2237, LAB_2364, LAB_1DD8, GLOB_REF_STR_CLOCK_FORMAT
; DESC:
;   Formats a time string for the current entry index into outPtr.
; NOTES:
;   Handles either numeric minutes or HH:MM text fields.
;------------------------------------------------------------------------------
TEXTDISP_FormatEntryTime:
    LINK.W  A5,#-16
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    TST.W   LAB_2153
    BEQ.S   .select_group2

    MOVE.W  LAB_2364,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2236,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    MOVE.L  D7,D1
    EXT.L   D1
    ASL.L   #2,D1
    ADDA.L  D1,A2
    MOVE.L  56(A2),-4(A5)
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.B  498(A1),D6
    BRA.S   .have_entry

.select_group2:
    MOVE.W  LAB_2364,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2237,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    MOVE.L  D7,D1
    EXT.L   D1
    ASL.L   #2,D1
    ADDA.L  D1,A2
    MOVE.L  56(A2),-4(A5)
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.B  498(A1),D6

.have_entry:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUPD_JMPTBL_LAB_08DF(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D5
    TST.L   -4(A5)
    BEQ.W   .clear_output

    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.W   .clear_output

    MOVEQ   #40,D0
    CMP.B   (A0),D0
    BNE.S   .format_minutes

    MOVEQ   #58,D0
    CMP.B   3(A0),D0
    BEQ.S   .parse_hhmm

.format_minutes:
    MOVEQ   #0,D0
    MOVE.B  LAB_1DD8,D0
    MOVEQ   #30,D1
    JSR     MATH_DivS32(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.L  D1,D5
    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_17CE(PC)

    ADDQ.W  #8,A7
    BRA.W   .return

.parse_hhmm:
    MOVEQ   #0,D0
    MOVE.B  4(A0),D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     MATH_Mulu32(PC)

    MOVEQ   #0,D1
    MOVE.B  5(A0),D1
    ADD.L   D1,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,D4
    MOVEQ   #0,D0
    MOVE.B  LAB_1DD8,D0
    MOVEQ   #30,D1
    JSR     MATH_DivS32(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.L  D1,D5
    MOVE.L  D4,D0
    EXT.L   D0
    MOVEQ   #30,D1
    JSR     MATH_DivS32(PC)

    MOVEQ   #0,D0
    MOVE.B  LAB_1DD8,D0
    MOVE.L  D1,24(A7)
    MOVEQ   #30,D1
    JSR     MATH_DivS32(PC)

    MOVE.L  24(A7),D0
    CMP.L   D1,D0
    BGE.S   .round_hour

    ADDQ.W  #1,D5

.round_hour:
    MOVE.L  D4,D0
    EXT.L   D0
    DIVS    #$1e,D0
    SWAP    D0
    MOVE.L  D0,D4
    MOVEQ   #48,D0
    CMP.W   D0,D5
    BLE.S   .wrap_hour

    SUBI.W  #$30,D5

.wrap_hour:
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L GLOB_REF_STR_CLOCK_FORMAT,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEA.L A3,A2

.copy_clock_format:
    MOVE.B  (A1)+,(A2)+
    BNE.S   .copy_clock_format

    MOVEQ   #0,D0
    MOVE.B  3(A3),D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     MATH_Mulu32(PC)

    MOVE.L  D4,D1
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.L  D1,D4
    MOVE.L  D4,D0
    EXT.L   D0
    MOVEQ   #10,D1
    JSR     MATH_DivS32(PC)

    MOVEQ   #48,D1
    ADD.L   D1,D0
    MOVE.B  D0,3(A3)
    MOVE.L  D4,D0
    EXT.L   D0
    MOVEQ   #10,D1
    JSR     MATH_DivS32(PC)

    MOVEQ   #48,D0
    ADD.L   D0,D1
    MOVE.B  D1,4(A3)
    BRA.S   .return

.clear_output:
    CLR.B   (A3)

.return:
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_FormatEntryTimeForIndex   (Format time using entry table)
; ARGS:
;   stack +8: outPtr (A3)
;   stack +14: entryIndex (word)
;   stack +16: entryTablePtr (A2)
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   GROUPD_JMPTBL_LAB_08DF, MATH_DivS32, MATH_Mulu32, LAB_17CE
; READS:
;   entryTable+56, entryTable+498, LAB_1DD8, GLOB_REF_STR_CLOCK_FORMAT
; DESC:
;   Formats a time string for a given entry index using the provided table.
; NOTES:
;   Falls back to numeric minutes when no HH:MM text exists.
;------------------------------------------------------------------------------
TEXTDISP_FormatEntryTimeForIndex:
    LINK.W  A5,#-12
    MOVEM.L D5-D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVEA.L 16(A5),A2
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVE.L  56(A2,D0.L),-4(A5)
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  498(A2),D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUPD_JMPTBL_LAB_08DF(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D5
    TST.L   -4(A5)
    BEQ.W   .clear_output

    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.W   .clear_output

    MOVEQ   #40,D0
    CMP.B   (A0),D0
    BNE.S   .format_minutes

    MOVEQ   #58,D0
    CMP.B   3(A0),D0
    BEQ.S   .parse_hhmm

.format_minutes:
    MOVEQ   #0,D0
    MOVE.B  LAB_1DD8,D0
    MOVEQ   #30,D1
    JSR     MATH_DivS32(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.L  D1,D5
    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_17CE(PC)

    ADDQ.W  #8,A7
    BRA.W   .return

.parse_hhmm:
    MOVEQ   #0,D0
    MOVE.B  4(A0),D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     MATH_Mulu32(PC)

    MOVEQ   #0,D1
    MOVE.B  5(A0),D1
    ADD.L   D1,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,D6
    MOVEQ   #0,D0
    MOVE.B  LAB_1DD8,D0
    MOVEQ   #30,D1
    JSR     MATH_DivS32(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.L  D1,D5
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEQ   #30,D1
    JSR     MATH_DivS32(PC)

    MOVEQ   #0,D0
    MOVE.B  LAB_1DD8,D0
    MOVE.L  D1,24(A7)
    MOVEQ   #30,D1
    JSR     MATH_DivS32(PC)

    MOVE.L  24(A7),D0
    CMP.L   D1,D0
    BGE.S   .round_hour

    ADDQ.W  #1,D5

.round_hour:
    MOVE.L  D6,D0
    EXT.L   D0
    DIVS    #$1e,D0
    SWAP    D0
    MOVE.L  D0,D6
    MOVEQ   #48,D0
    CMP.W   D0,D5
    BLE.S   .wrap_hour

    SUBI.W  #$30,D5

.wrap_hour:
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L GLOB_REF_STR_CLOCK_FORMAT,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEA.L A3,A6

.copy_clock_format:
    MOVE.B  (A1)+,(A6)+
    BNE.S   .copy_clock_format

    MOVEQ   #0,D0
    MOVE.B  3(A3),D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     MATH_Mulu32(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.L  D1,D6
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEQ   #10,D1
    JSR     MATH_DivS32(PC)

    MOVEQ   #48,D1
    ADD.L   D1,D0
    MOVE.B  D0,3(A3)
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEQ   #10,D1
    JSR     MATH_DivS32(PC)

    MOVEQ   #48,D0
    ADD.L   D0,D1
    MOVE.B  D1,4(A3)
    BRA.S   .return

.clear_output:
    CLR.B   (A3)

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_ComputeTimeOffset   (Compute time offset in minutes)
; ARGS:
;   stack +10: index (word)
;   stack +12: entryPtr (A3)
;   stack +18: value (word)
; RET:
;   D0: offsetMinutes
; CLOBBERS:
;   D0-D7/A3
; CALLS:
;   GROUPD_JMPTBL_LAB_08DF, LAB_17F1, MATH_DivS32, MATH_Mulu32
; READS:
;   LAB_2275/2276/2277
; DESC:
;   Computes a time offset (minutes) based on entry data and current time.
;------------------------------------------------------------------------------
TEXTDISP_ComputeTimeOffset:
    LINK.W  A5,#-36
    MOVEM.L D2-D7/A3,-(A7)
    MOVE.W  10(A5),D7
    MOVEA.L 12(A5),A3
    MOVE.W  18(A5),D6
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D6,D2
    EXT.L   D2
    MOVEQ   #0,D3
    MOVE.B  498(A3),D3
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D0,36(A7)
    MOVE.L  D1,40(A7)
    JSR     GROUPD_JMPTBL_LAB_08DF(PC)

    EXT.L   D0
    PEA     -8(A5)
    PEA     -20(A5)
    MOVE.L  D0,-(A7)
    MOVE.L  52(A7),-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  56(A7),-(A7)
    JSR     LAB_17F1(PC)

    LEA     32(A7),A7
    MOVE.W  LAB_2277,D0
    EXT.L   D0
    MOVE.L  -20(A5),D1
    SUB.L   D0,D1
    MOVE.L  D1,D4
    TST.L   D4
    BNE.S   .fallback_offset_1

    MOVE.W  LAB_2275,D0
    EXT.L   D0
    MOVE.L  -16(A5),D1
    SUB.L   D0,D1
    MOVE.L  D1,D4

.fallback_offset_1:
    TST.L   D4
    BNE.S   .fallback_offset_2

    MOVE.W  LAB_2276,D0
    EXT.L   D0
    MOVE.L  -12(A5),D1
    SUB.L   D0,D1
    MOVE.L  D1,D4

.fallback_offset_2:
    MOVE.L  -8(A5),D0
    MOVEQ   #60,D1
    JSR     MATH_Mulu32(PC)

    ADD.L   -4(A5),D0
    MOVE.L  D0,D5
    MOVE.W  GLOB_WORD_CURRENT_HOUR,D0
    EXT.L   D0
    MOVEQ   #12,D1
    JSR     MATH_DivS32(PC)

    TST.W   GLOB_WORD_USE_24_HR_FMT
    BEQ.S   .use_zero_bias

    MOVEQ   #12,D0
    BRA.S   .apply_hour_bias

.use_zero_bias:
    MOVEQ   #0,D0

.apply_hour_bias:
    ADD.L   D0,D1
    MOVEQ   #60,D0
    JSR     MATH_Mulu32(PC)

    MOVE.W  GLOB_WORD_CURRENT_MINUTE,D1
    EXT.L   D1
    ADD.L   D1,D0
    SUB.L   D0,D5
    MOVE.L  D4,D0
    MOVE.L  #$5a0,D1
    JSR     MATH_Mulu32(PC)

    ADD.L   D0,D5
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_SelectGroupAndEntry   (Resolve selection from filter)
; ARGS:
;   stack +24: filterStrPtr (A3)
;   stack +28: outPtr (A2)
;   stack +34: entryIndex (word)
; RET:
;   D0: 1 if selection found, 0 otherwise
; CLOBBERS:
;   D0-D7/A2-A3
; CALLS:
;   TEXTDISP_BuildMatchIndexList, TEXTDISP_SelectBestMatchFromList
; READS:
;   LAB_224E, LAB_2371/2376/2377/2372
; WRITES:
;   LAB_2360, LAB_2361, LAB_2364, LAB_236F, LAB_2153
; DESC:
;   Attempts to resolve a filter across groups and updates selection globals.
; NOTES:
;   Uses LAB_2153 to switch between group 1/2.
;------------------------------------------------------------------------------
TEXTDISP_SelectGroupAndEntry:
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVEA.L 28(A7),A2
    MOVE.W  34(A7),D7
    MOVEQ   #-1,D0
    MOVE.W  D0,LAB_2360
    MOVE.W  D0,LAB_2361
    CLR.W   LAB_236F
    MOVE.W  #1,LAB_2153
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   TEXTDISP_BuildMatchIndexList

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    TST.W   D6
    BEQ.S   .check_group1_result

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  A3,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    BSR.W   TEXTDISP_SelectBestMatchFromList

    LEA     16(A7),A7
    MOVE.L  D0,D5
    MOVEQ   #0,D0
    MOVE.B  LAB_2371,D0
    MOVE.W  D0,LAB_2360

.check_group1_result:
    TST.W   D6
    BEQ.S   .try_group2

    TST.W   D5
    BNE.S   .after_group2

.try_group2:
    MOVE.W  LAB_224E,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .after_group2

    MOVE.W  D1,LAB_2153
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   TEXTDISP_BuildMatchIndexList

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    TST.W   D6
    BEQ.S   .after_group2

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  A3,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    BSR.W   TEXTDISP_SelectBestMatchFromList

    LEA     16(A7),A7
    MOVE.L  D0,D5
    MOVEQ   #0,D0
    MOVE.B  LAB_2371,D0
    MOVE.W  D0,LAB_2361

.after_group2:
    TST.W   D6
    BEQ.S   .no_match

    TST.W   D5
    BNE.S   .select_index

.no_match:
    MOVEQ   #1,D0
    MOVE.W  D0,LAB_2153
    MOVEQ   #0,D0
    BRA.S   .return

.select_index:
    MOVEQ   #2,D0
    CMP.W   D0,D5
    BNE.S   .use_primary_index

    MOVE.B  LAB_2377,D0
    MOVEQ   #100,D1
    CMP.B   D1,D0
    BNE.S   .use_alt_index

    MOVEQ   #0,D0
    MOVE.B  LAB_2372,D0
    BRA.S   .store_selected_index

.use_alt_index:
    MOVEQ   #0,D0
    MOVE.B  LAB_2376,D0

.store_selected_index:
    MOVE.W  D0,LAB_2364
    BRA.S   .return_success

.use_primary_index:
    MOVEQ   #0,D0
    MOVE.B  LAB_2371,D0
    MOVE.W  D0,LAB_2364

.return_success:
    MOVEQ   #1,D0

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_BuildMatchIndexList   (Build list of matching entries)
; ARGS:
;   stack +8: patternPtr
;   stack +14: cmdChar (word)
; RET:
;   D0: match count
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   JMPTBL_ESQ_WildcardMatch_2, TEXTDISP_ShouldOpenEditorForEntry
; READS:
;   LAB_2153, LAB_2231/222F, LAB_2233/2235/2236/2237, LAB_2159/215A/215B/215C
; WRITES:
;   LAB_236F, LAB_2370, LAB_2371
; DESC:
;   Filters entries by wildcard pattern and flags, storing matches in LAB_2371.
; NOTES:
;   If pattern starts with FIND1, switches to a \"find\" mode.
;------------------------------------------------------------------------------
TEXTDISP_BuildMatchIndexList:
    LINK.W  A5,#-20
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVE.W  14(A5),D7
    MOVEQ   #0,D5
    TST.L   8(A5)
    BEQ.W   .return

    MOVE.L  8(A5),-(A7)
    PEA     LAB_2159
    JSR     JMPTBL_ESQ_WildcardMatch_2(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .check_sbe_pattern

    MOVEQ   #1,D4
    BRA.S   .check_sports_pattern

.check_sbe_pattern:
    MOVE.L  8(A5),-(A7)
    PEA     LAB_215A
    JSR     JMPTBL_ESQ_WildcardMatch_2(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .set_pattern_flag

    MOVEQ   #1,D0
    MOVE.W  D0,LAB_236F
    MOVE.L  D0,D4
    BRA.S   .check_sports_pattern

.set_pattern_flag:
    MOVEQ   #0,D4

.check_sports_pattern:
    MOVE.L  8(A5),-(A7)
    PEA     LAB_215B
    JSR     JMPTBL_ESQ_WildcardMatch_2(PC)

    TST.B   D0
    SEQ     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  8(A5),(A7)
    PEA     LAB_215C
    MOVE.W  D1,-16(A5)
    JSR     JMPTBL_ESQ_WildcardMatch_2(PC)

    LEA     12(A7),A7
    TST.B   D0
    BNE.S   .ensure_filter_pattern

    LEA     GLOB_STR_ASTERISK_2,A0
    MOVE.L  A0,8(A5)

.ensure_filter_pattern:
    LEA     LAB_215E,A0
    MOVEA.L 8(A5),A1

.compare_find_prefix:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   .set_find_mode_flag

    TST.B   D0
    BNE.S   .compare_find_prefix

    BNE.S   .set_find_mode_flag

    MOVEQ   #1,D0
    MOVE.W  D0,LAB_2370
    MOVE.L  #GLOB_STR_ASTERISK_3,8(A5)
    BRA.S   .init_scan

.set_find_mode_flag:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_2370

.init_scan:
    MOVEQ   #0,D5
    MOVE.W  LAB_2153,D0
    SUBQ.W  #1,D0
    BNE.S   .set_group2_count

    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    MOVE.L  D0,-20(A5)
    BRA.S   .init_index

.set_group2_count:
    MOVEQ   #0,D0
    MOVE.W  LAB_222F,D0
    MOVE.L  D0,-20(A5)

.init_index:
    MOVEQ   #0,D6

.entry_loop:
    MOVE.L  D6,D0
    EXT.L   D0
    CMP.L   -20(A5),D0
    BGE.W   .return

    MOVE.W  LAB_2153,D0
    SUBQ.W  #1,D0
    BNE.S   .load_group2_entry

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2236,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A3
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    BRA.S   .check_entry_filters

.load_group2_entry:
    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2237,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A3
    LEA     LAB_2235,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2

.check_entry_filters:
    BTST    #3,27(A2)
    BNE.S   .next_entry

    MOVEQ   #69,D0
    CMP.W   D0,D7
    BNE.S   .check_cmd_E

    BTST    #7,40(A2)
    BEQ.S   .next_entry

.check_cmd_E:
    TST.W   D4
    BEQ.S   .check_editor_flag

    BTST    #4,27(A2)
    BNE.S   .record_match

.check_editor_flag:
    TST.W   -16(A5)
    BEQ.S   .match_wildcard

    MOVE.L  A2,-(A7)
    JSR     TEXTDISP_ShouldOpenEditorForEntry(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BNE.S   .record_match

.match_wildcard:
    MOVE.L  8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_ESQ_WildcardMatch_2(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .next_entry

.record_match:
    LEA     LAB_2371,A0
    ADDA.W  D5,A0
    MOVE.L  D6,D0
    MOVE.B  D0,(A0)
    ADDQ.W  #1,D5

.next_entry:
    ADDQ.W  #1,D6
    BRA.W   .entry_loop

.return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_SelectBestMatchFromList   (Evaluate candidate list)
; ARGS:
;   stack +8: filterPtr (A3)
;   stack +14: matchCount (word)
;   stack +18: channelCode (word)
;   stack +20: tagPtr (A2)
; RET:
;   D0: status code (0/1/2)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   TEXTDISP_FindEntryMatchIndex, TEXTDISP_ComputeTimeOffset
; READS:
;   LAB_2153, LAB_2236/2237, LAB_2230/222D, LAB_2270, LAB_2364, LAB_2371
; WRITES:
;   LAB_2372-2379, LAB_2373, LAB_2375, LAB_2377
; DESC:
;   Walks candidate indices, evaluates timing/channel constraints, and updates
;   global selection state for text display.
; NOTES:
;   Uses tagPtr to detect \"SPT\" and adjusts selection rules accordingly.
;------------------------------------------------------------------------------
TEXTDISP_SelectBestMatchFromList:
    LINK.W  A5,#-24
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.W  18(A5),D6
    MOVEA.L 20(A5),A2
    MOVE.W  #$fffa,-12(A5)
    MOVE.W  #$5a1,-20(A5)
    MOVE.W  #$fa5f,-22(A5)
    MOVEQ   #0,D0
    MOVE.B  D0,LAB_2375
    MOVE.B  D0,LAB_2379
    MOVE.B  #$64,LAB_2377
    LEA     LAB_2160,A0
    MOVEA.L A2,A1
    MOVE.B  D0,-23(A5)

.compare_spt_prefix:
    MOVE.B  (A0)+,D1
    CMP.B   (A1)+,D1
    BNE.S   .set_spt_flag

    TST.B   D1
    BNE.S   .compare_spt_prefix

    BNE.S   .set_spt_flag

    MOVE.B  #$8,-13(A5)
    BRA.S   .init_channel_range

.set_spt_flag:
    MOVE.B  D0,-13(A5)

.init_channel_range:
    MOVE.W  #$31,-6(A5)
    MOVE.W  -6(A5),D0
    MOVE.B  D0,LAB_2373
    TST.W   D6
    BNE.S   .ensure_channel_default

    MOVEQ   #48,D6

.ensure_channel_default:
    MOVEQ   #48,D0
    CMP.W   D0,D6
    BLT.S   .check_channel_range_alt

    MOVEQ   #67,D0
    CMP.W   D0,D6
    BLE.S   .channel_enabled

.check_channel_range_alt:
    MOVEQ   #72,D0
    CMP.W   D0,D6
    BLT.W   .return_error

    MOVEQ   #77,D0
    CMP.W   D0,D6
    BGT.W   .return_error

.channel_enabled:
    MOVE.L  D6,D0
    EXT.L   D0
    LEA     GLOB_STR_TEXTDISP_C_3,A0
    ADDA.L  D0,A0
    MOVE.W  LAB_2274,D0
    EXT.L   D0
    MOVEQ   #1,D1
    ASL.L   D0,D1
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    AND.L   D1,D0
    TST.L   D0
    BEQ.W   .return_error

    MOVEQ   #0,D5

.candidate_loop:
    CMP.W   D7,D5
    BGE.W   .finalize_candidates

    LEA     LAB_2371,A0
    ADDA.W  D5,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.W  D0,LAB_2364
    MOVEQ   #0,D0
    MOVE.B  -13(A5),D0
    MOVE.L  D0,-(A7)
    PEA     1.W
    MOVE.L  A3,-(A7)
    BSR.W   TEXTDISP_FindEntryMatchIndex

    LEA     12(A7),A7
    MOVE.W  D0,-4(A5)
    MOVEQ   #49,D1
    CMP.W   D1,D0
    BGE.W   .ensure_entry_index

    TST.W   LAB_2153
    BEQ.S   .compute_time_group2

    MOVEQ   #0,D1
    MOVE.B  LAB_2230,D1
    EXT.L   D1
    MOVE.W  LAB_2364,D2
    EXT.L   D2
    ASL.L   #2,D2
    LEA     LAB_2236,A0
    ADDA.L  D2,A0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  (A0),-(A7)
    MOVE.L  D1,-(A7)
    BSR.W   TEXTDISP_ComputeTimeOffset

    LEA     12(A7),A7
    MOVE.W  D0,-18(A5)
    BRA.S   .after_time_offset

.compute_time_group2:
    MOVEQ   #0,D0
    MOVE.B  LAB_222D,D0
    EXT.L   D0
    MOVE.W  LAB_2364,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     LAB_2237,A0
    ADDA.L  D1,A0
    MOVE.W  -4(A5),D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  (A0),-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   TEXTDISP_ComputeTimeOffset

    LEA     12(A7),A7
    MOVE.W  D0,-18(A5)

.after_time_offset:
    TST.W   LAB_2153
    BNE.S   .compute_special_flag

    CLR.B   -23(A5)
    BRA.S   .compute_entry_index

.compute_special_flag:
    MOVE.W  LAB_2270,D1
    MOVE.W  -4(A5),D2
    CMP.W   D1,D2
    BLT.S   .set_special_true

    CMP.W   D2,D1
    BNE.S   .set_special_false

    TST.W   D0
    BGT.S   .set_special_false

.set_special_true:
    MOVEQ   #1,D0
    BRA.S   .store_special_flag

.set_special_false:
    MOVEQ   #0,D0

.store_special_flag:
    MOVE.B  D0,-23(A5)

.compute_entry_index:
    TST.W   LAB_2153
    BEQ.S   .set_group2_min

    MOVEQ   #0,D0
    MOVE.W  LAB_2270,D0
    BRA.S   .compare_min_index

.set_group2_min:
    MOVEQ   #1,D0

.compare_min_index:
    MOVE.W  -4(A5),D1
    EXT.L   D1
    CMP.L   D0,D1
    BGT.S   .use_current_index

    MOVEQ   #0,D0
    MOVE.B  -13(A5),D0
    MOVE.L  D0,-(A7)
    PEA     2.W
    MOVE.L  A3,-(A7)
    BSR.W   TEXTDISP_FindEntryMatchIndex

    LEA     12(A7),A7
    MOVE.W  D0,-16(A5)
    MOVEQ   #49,D1
    CMP.W   D1,D0
    BGE.S   .mark_found_primary

    MOVE.B  #$1,LAB_2375
    BRA.S   .compute_time_secondary

.mark_found_primary:
    MOVE.W  -4(A5),D0
    MOVE.W  D0,-16(A5)
    BRA.S   .compute_time_secondary

.use_current_index:
    MOVE.W  -4(A5),D0
    MOVE.W  D0,-16(A5)

.compute_time_secondary:
    TST.W   LAB_2153
    BEQ.S   .compute_time_secondary_group2

    MOVEQ   #0,D1
    MOVE.B  LAB_2230,D1
    EXT.L   D1
    MOVE.W  LAB_2364,D2
    EXT.L   D2
    ASL.L   #2,D2
    LEA     LAB_2236,A0
    ADDA.L  D2,A0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  (A0),-(A7)
    MOVE.L  D1,-(A7)
    BSR.W   TEXTDISP_ComputeTimeOffset

    LEA     12(A7),A7
    MOVE.W  D0,-18(A5)
    BRA.S   .after_secondary_time

.compute_time_secondary_group2:
    MOVEQ   #0,D0
    MOVE.B  LAB_222D,D0
    EXT.L   D0
    MOVE.W  LAB_2364,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     LAB_2237,A0
    ADDA.L  D1,A0
    MOVE.W  -16(A5),D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  (A0),-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   TEXTDISP_ComputeTimeOffset

    LEA     12(A7),A7
    MOVE.W  D0,-18(A5)

.after_secondary_time:
    TST.W   LAB_2153
    BEQ.S   .select_entry_table

    MOVE.W  LAB_2270,D1
    MOVE.W  -4(A5),D2
    CMP.W   D1,D2
    BNE.S   .select_entry_table

    TST.W   D0
    BLE.S   .select_entry_table

    MOVEQ   #0,D0
    MOVE.B  -13(A5),D0
    MOVE.L  D0,-(A7)
    PEA     3.W
    MOVE.L  A3,-(A7)
    BSR.W   TEXTDISP_FindEntryMatchIndex

    LEA     12(A7),A7
    MOVE.W  D0,-4(A5)

.select_entry_table:
    TST.W   LAB_2153
    BEQ.S   .select_group2_table

    MOVE.W  LAB_2364,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2236,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-10(A5)
    BRA.S   .after_entry_table

.select_group2_table:
    MOVE.W  LAB_2364,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2237,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-10(A5)

.after_entry_table:
    MOVE.W  -18(A5),D0
    TST.W   D0
    BLE.S   .check_best_match

    MOVE.W  -16(A5),D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVE.W  -12(A5),D2
    MOVEA.L -10(A5),A0
    MOVE.L  D1,D3
    ADDI.L  #400,D3
    CMP.W   0(A0,D3.L),D2
    BLS.S   .check_best_match

    MOVEQ   #1,D1
    MOVE.B  D1,LAB_2379
    MOVE.W  -16(A5),D3
    MOVE.B  D3,LAB_2377
    MOVE.W  LAB_2364,D4
    MOVE.B  D4,LAB_2376
    MOVE.B  -23(A5),D2
    MOVE.B  D2,LAB_2378

.check_best_match:
    TST.W   D0
    BLE.S   .check_alt_match

    CMP.W   -20(A5),D0
    BGE.S   .check_alt_match

    MOVEQ   #1,D1
    MOVE.B  D1,LAB_2375
    MOVE.W  -16(A5),D1
    MOVE.B  D1,LAB_2373
    MOVE.W  LAB_2364,D2
    MOVE.B  D2,LAB_2372
    MOVE.B  -23(A5),D3
    MOVE.B  D3,LAB_2374
    MOVE.W  D0,-20(A5)
    BRA.W   .update_last_seen

.check_alt_match:
    TST.B   LAB_2379
    BNE.S   .check_fallback_match

    TST.W   D0
    BGT.S   .check_fallback_match

    MOVE.W  -22(A5),D1
    CMP.W   D1,D0
    BLE.S   .check_fallback_match

    MOVE.W  -16(A5),D2
    EXT.L   D2
    ADD.L   D2,D2
    MOVE.W  -12(A5),D3
    MOVEA.L -10(A5),A0
    MOVE.L  D2,D4
    ADDI.L  #400,D4
    CMP.W   0(A0,D4.L),D3
    BLS.S   .check_fallback_match

    MOVE.W  -16(A5),D2
    MOVE.B  D2,LAB_2377
    MOVE.W  LAB_2364,D3
    MOVE.B  D3,LAB_2376
    MOVE.B  -23(A5),D4
    MOVE.B  D4,LAB_2378

.check_fallback_match:
    TST.B   LAB_2375
    BNE.S   .update_last_seen

    TST.W   D0
    BGT.S   .update_last_seen

    CMP.W   -22(A5),D0
    BLE.S   .update_last_seen

    MOVE.W  -16(A5),D1
    MOVE.B  D1,LAB_2373
    MOVE.W  LAB_2364,D2
    MOVE.B  D2,LAB_2372
    MOVE.B  -23(A5),LAB_2374
    MOVE.W  D0,-22(A5)

.update_last_seen:
    MOVE.W  -16(A5),D0
    EXT.L   D0
    ADD.L   D0,D0
    MOVEA.L -10(A5),A0
    MOVE.L  D0,D1
    ADDI.L  #400,D1
    MOVE.W  0(A0,D1.L),-12(A5)
    MOVE.W  -4(A5),D0
    MOVE.W  LAB_2370,D1
    MOVE.W  D0,-6(A5)
    SUBQ.W  #1,D1
    BNE.S   .ensure_entry_index

    MOVEQ   #2,D0
    BRA.W   .return

.ensure_entry_index:
    MOVEQ   #49,D0
    CMP.W   -6(A5),D0
    BNE.S   .next_candidate

    TST.W   LAB_236F
    BNE.S   .next_candidate

    MOVEQ   #0,D0
    MOVE.B  -13(A5),D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    BSR.W   TEXTDISP_FindEntryMatchIndex

    LEA     12(A7),A7
    MOVE.W  LAB_2364,D1
    MOVE.B  D1,LAB_2372
    MOVE.W  D0,-6(A5)

.next_candidate:
    ADDQ.W  #1,D5
    BRA.W   .candidate_loop

.finalize_candidates:
    CMPI.W  #$31,-6(A5)
    BGE.S   .normalize_channel_code

    CMPI.W  #$3d,-20(A5)
    BGE.S   .bump_usage_count

    MOVEQ   #100,D0
    MOVE.B  D0,LAB_2377

.bump_usage_count:
    MOVE.B  LAB_2377,D0
    MOVEQ   #100,D1
    CMP.B   D1,D0
    BEQ.S   .return_ok

    TST.W   LAB_2153
    BEQ.S   .load_group2_table_for_usage

    MOVEQ   #0,D1
    MOVE.B  LAB_2376,D1
    MOVE.L  D1,D2
    EXT.L   D2
    ASL.L   #2,D2
    LEA     LAB_2236,A0
    ADDA.L  D2,A0
    MOVE.L  (A0),-10(A5)
    BRA.S   .after_usage_table

.load_group2_table_for_usage:
    MOVEQ   #0,D1
    MOVE.B  LAB_2376,D1
    MOVE.L  D1,D2
    EXT.L   D2
    ASL.L   #2,D2
    LEA     LAB_2237,A0
    ADDA.L  D2,A0
    MOVE.L  (A0),-10(A5)

.after_usage_table:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D0
    EXT.L   D0
    ADD.L   D0,D0
    MOVEA.L -10(A5),A0
    MOVE.L  D0,D1
    ADDI.L  #400,D1
    ADDQ.W  #1,0(A0,D1.L)

.return_ok:
    MOVEQ   #2,D0
    BRA.S   .return

.normalize_channel_code:
    MOVEQ   #48,D0
    CMP.W   D0,D6
    BLE.S   .check_channel_range_1

    MOVEQ   #58,D0
    CMP.W   D0,D6
    BLT.S   .set_default_channel

.check_channel_range_1:
    MOVEQ   #62,D0
    CMP.W   D0,D6
    BLE.S   .check_channel_range_2

    MOVEQ   #68,D0
    CMP.W   D0,D6
    BLT.S   .set_default_channel

.check_channel_range_2:
    MOVEQ   #71,D0
    CMP.W   D0,D6
    BLE.S   .channel_ok

    MOVEQ   #78,D0
    CMP.W   D0,D6
    BGE.S   .channel_ok

.set_default_channel:
    MOVEQ   #68,D6
    MOVEQ   #1,D0
    BRA.S   .return

.channel_ok:
    MOVEQ   #0,D0
    BRA.S   .return

.return_error:
    MOVEQ   #1,D0

.return:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_UpdateChannelRangeFlags   (Update channel range flags)
; ARGS:
;   none
; RET:
;   none
; CLOBBERS:
;   D0-D7
; CALLS:
;   TEXTDISP_FindEntryMatchIndex
; READS:
;   LAB_2365, LAB_234D/234E, LAB_2274
; WRITES:
;   LAB_2373, LAB_2377
; DESC:
;   Validates current channel and updates flags used by text display.
; NOTES:
;   Falls back to defaults when channel is out of range.
;------------------------------------------------------------------------------
TEXTDISP_UpdateChannelRangeFlags:
    LINK.W  A5,#-8
    MOVEM.L D2/D7,-(A7)
    MOVE.W  LAB_2365,D0
    SUBQ.W  #1,D0
    BNE.S   .use_alt_channel_source

    MOVE.L  #LAB_234B,-4(A5)
    MOVE.W  LAB_234D,D7
    BRA.S   .ensure_channel_default

.use_alt_channel_source:
    LEA     LAB_234C,A0
    MOVE.W  LAB_234E,D7
    MOVE.L  A0,-4(A5)

.ensure_channel_default:
    TST.W   D7
    BNE.S   .check_channel_range_primary

    MOVEQ   #48,D7

.check_channel_range_primary:
    MOVEQ   #48,D0
    CMP.W   D0,D7
    BLT.S   .check_channel_range_alt

    MOVEQ   #67,D0
    CMP.W   D0,D7
    BLE.S   .channel_enabled

.check_channel_range_alt:
    MOVEQ   #72,D0
    CMP.W   D0,D7
    BLT.S   .fallback_defaults

    MOVEQ   #77,D0
    CMP.W   D0,D7
    BGT.S   .fallback_defaults

.channel_enabled:
    MOVE.L  D7,D0
    EXT.L   D0
    LEA     GLOB_STR_TEXTDISP_C_3,A0
    ADDA.L  D0,A0
    MOVE.W  LAB_2274,D0
    EXT.L   D0
    MOVEQ   #1,D1
    MOVE.L  D1,D2
    ASL.L   D0,D2
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    AND.L   D2,D0
    TST.L   D0
    BEQ.S   .fallback_defaults

    CLR.L   -(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   TEXTDISP_FindEntryMatchIndex

    LEA     12(A7),A7
    MOVE.B  D0,LAB_2373
    BRA.S   .return

.fallback_defaults:
    MOVE.B  #$64,LAB_2377
    MOVE.B  #$31,LAB_2373

.return:
    MOVEM.L (A7)+,D2/D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_TrimTextToPixelWidth   (Trim text to pixel width)
; ARGS:
;   stack +8: textPtr (A3)
;   stack +12: maxWidth (long)
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _LVOTextLength
; READS:
;   LAB_2216
; DESC:
;   Trims text to fit maxWidth, skipping control bytes 0x18/0x19.
; NOTES:
;   Uses the rastport stored in LAB_2216 for font metrics.
;------------------------------------------------------------------------------
TEXTDISP_TrimTextToPixelWidth:
    LINK.W  A5,#-28
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVEQ   #25,D4
    MOVEA.L A3,A0
    CLR.L   -8(A5)
    MOVEQ   #0,D6
    MOVEA.L LAB_2216,A1
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A1
    MOVEA.L A0,A2

.measure_text_len:
    TST.B   (A2)+
    BNE.S   .measure_text_len

    SUBQ.L  #1,A2
    SUBA.L  A0,A2
    MOVE.L  A0,-4(A5)
    MOVE.L  A2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5

.trim_loop:
    CMP.L   D7,D5
    BLE.W   .return

    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.W   .return

    MOVE.B  (A0),D0
    MOVEQ   #24,D1
    CMP.B   D1,D0
    BEQ.S   .handle_control_prefix

    MOVEQ   #25,D1
    CMP.B   D1,D0
    BNE.S   .measure_char

.handle_control_prefix:
    MOVE.L  D0,D4
    ADDQ.L  #1,-4(A5)
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L -4(A5),A1

.measure_after_control:
    TST.B   (A1)+
    BNE.S   .measure_after_control

    SUBQ.L  #1,A1
    SUBA.L  -4(A5),A1
    MOVE.L  A1,28(A7)
    MOVEA.L A0,A1
    MOVEA.L -4(A5),A0
    MOVE.L  28(A7),D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5
    MOVEQ   #0,D6
    CLR.L   -8(A5)
    BRA.S   .trim_loop

.measure_char:
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVEA.L -4(A5),A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    ADD.L   D0,D6
    CMP.L   D7,D6
    BLE.S   .track_last_space

    TST.L   -8(A5)
    BEQ.S   .return

    MOVEA.L -8(A5),A0
    MOVE.B  D4,(A0)
    LEA     1(A0),A1
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A1,A2

.measure_after_insert:
    TST.B   (A2)+
    BNE.S   .measure_after_insert

    SUBQ.L  #1,A2
    SUBA.L  A1,A2
    MOVE.L  A1,-4(A5)
    MOVEA.L A0,A1
    MOVE.L  A2,D0
    MOVEA.L -4(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5
    MOVEQ   #0,D6
    CLR.L   -8(A5)
    BRA.W   .trim_loop

.track_last_space:
    MOVEQ   #32,D0
    MOVEA.L -4(A5),A0
    CMP.B   (A0),D0
    BNE.S   .advance_char

    MOVE.L  A0,-8(A5)

.advance_char:
    ADDQ.L  #1,-4(A5)
    BRA.W   .trim_loop

.return:
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS
