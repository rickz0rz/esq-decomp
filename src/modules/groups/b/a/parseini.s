;------------------------------------------------------------------------------
; FUNC: PARSEINI_ParseIniBufferAndDispatch   (Parse INI-like buffer; dispatch by section??)
; ARGS:
;   stack +8: A3 = pointer to buffer/string to parse
; RET:
;   D0: -1 on failure, 0/?? on success
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   JMPTBL_LAB_03AC, JMPTBL_LAB_03B9, JMPTBL_UNKNOWN7_FindCharWrapper, JMPTBL_GCOMMAND_InitPresetTableFromPalette, JMPTBL_STRING_CompareNoCase_3, TEXTDISP_ClearSourceConfig, JMPTBL_LAB_0B44,
;   JMPTBL_GCOMMAND_FindPathSeparator, JMPTBL_HANDLE_OpenWithMode, JMPTBL_LAB_09F9, JMPTBL_LAB_0A93, LAB_13E6/LAB_1400/LAB_1404/LAB_1408 helpers
; READS:
;   LAB_21BC, LAB_21A8 (char class table), many LAB_205* globals, LAB_1B1F, LAB_233D
; WRITES:
;   LAB_2059-2064/206A..., LAB_1DDA, LAB_2073, LAB_233D, LAB_206D, LAB_205A-C, etc.
; DESC:
;   Top-level INI parser: scans the buffer, skips whitespace/comment chars, detects
;   section headers and key/value pairs, and dispatches to per-section handlers.
; NOTES:
;   Uses BRACKETED sections '['...']', lower-level helpers validate/allocate strings.
;------------------------------------------------------------------------------
PARSEINI_ParseIniBufferAndDispatch:
PARSEINI_ParseConfigBuffer:
    LINK.W  A5,#-44
    MOVEM.L D5-D7/A2-A3,-(A7)

    MOVEA.L 8(A5),A3

    MOVEQ   #0,D7
    MOVEQ   #-1,D5
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_LAB_03AC(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BNE.S   .init_parser_state

    MOVEQ   #-1,D0
    BRA.W   .return

.init_parser_state:
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D6
    MOVE.L  LAB_21BC,-16(A5)

.next_line:
    JSR     JMPTBL_LAB_03B9(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-8(A5)
    CMP.L   A0,D0
    BEQ.W   .cleanup_and_free

.skip_leading_ws:
    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.B  (A0),D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .check_section_header

    ADDQ.L  #1,-8(A5)
    BRA.S   .skip_leading_ws

.check_section_header:
    MOVEQ   #91,D0
    MOVEA.L -8(A5),A0
    CMP.B   (A0),D0
    BNE.W   .dispatch_section_line

    LEA     1(A0),A1
    PEA     93.W
    MOVE.L  A1,-(A7)
    JSR     JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-28(A5)
    TST.L   D0
    BEQ.S   .next_line

    MOVEA.L D0,A0
    CLR.B   (A0)
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     LAB_205D
    MOVE.L  A0,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_section_2

    MOVEQ   #1,D7
    BRA.S   .next_line

.check_section_2:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     LAB_205E
    MOVE.L  A0,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_section_3

    MOVEQ   #2,D7
    BRA.W   .next_line

.check_section_3:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     LAB_205F
    MOVE.L  A0,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_section_4

    MOVEQ   #3,D7
    PEA     LAB_233F
    JSR     JMPTBL_GCOMMAND_InitPresetTableFromPalette(PC)

    ADDQ.W  #4,A7
    BRA.W   .next_line

.check_section_4:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     LAB_2060
    MOVE.L  A0,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_section_5

    MOVEQ   #4,D7
    BRA.W   .next_line

.check_section_5:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     LAB_2061
    MOVE.L  A0,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_section_6

    MOVEQ   #5,D7
    BRA.W   .next_line

.check_section_6:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     LAB_2062
    MOVE.L  A0,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_section_7

    MOVEQ   #6,D7
    CLR.L   LAB_2059
    BRA.W   .next_line

.check_section_7:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     LAB_2063
    MOVE.L  A0,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_section_8

    MOVEQ   #7,D7
    MOVE.L  LAB_205A,-(A7)
    MOVE.L  GLOB_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE,-(A7)
    JSR     JMPTBL_LAB_0B44(PC)

    MOVE.L  D0,LAB_205A
    MOVE.L  LAB_205B,(A7)
    MOVE.L  LAB_20B0,-(A7)
    JSR     JMPTBL_LAB_0B44(PC)

    MOVE.L  D0,LAB_205B
    MOVE.L  LAB_205C,(A7)
    MOVE.L  LAB_20B2,-(A7)
    JSR     JMPTBL_LAB_0B44(PC)

    LEA     16(A7),A7
    MOVE.L  D0,LAB_205C
    BRA.W   .next_line

.check_section_8:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     LAB_2064
    MOVE.L  A0,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .unknown_section

    JSR     TEXTDISP_ClearSourceConfig(PC)

    MOVEQ   #8,D7
    BRA.W   .next_line

.unknown_section:
    MOVEQ   #0,D7
    BRA.W   .next_line

.dispatch_section_line:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    BLT.W   .next_line

    CMPI.L  #$8,D0
    BGE.W   .next_line

    ADD.W   D0,D0
    MOVE.W  .dispatch_table(PC,D0.W),D0
    JMP     .dispatch_table+2(PC,D0.W)

; switch/jumptable
.dispatch_table:
    DC.W    .section1_parse_line-.dispatch_table-2
    DC.W    .section2_parse_line-.dispatch_table-2
    DC.W    .section3_parse_range-.dispatch_table-2
    DC.W    .section4_5_parse_line-.dispatch_table-2
    DC.W    .section4_5_parse_line-.dispatch_table-2
    DC.W    .section6_parse_line-.dispatch_table-2
	DC.W    .section7_parse_line-.dispatch_table-2
    DC.W    .section8_parse_line-.dispatch_table-2

.section1_parse_line:
    PEA     61.W
    MOVE.L  -8(A5),-(A7)
    JSR     JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-32(A5)
    BEQ.W   .section1_reset_count

    MOVEA.L D0,A0
    CLR.B   (A0)+
    MOVE.L  A0,-32(A5)

.section1_skip_value_ws:
    MOVEA.L -32(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section1_cut_marker

    ADDQ.L  #1,-32(A5)
    BRA.S   .section1_skip_value_ws

.section1_cut_marker:
    PEA     LAB_2065
    MOVE.L  -8(A5),-(A7)
    JSR     GROUP_BA_JMPTBL_UNKNOWN7_FindAnyCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-36(A5)
    TST.L   D0
    BEQ.S   .section1_after_marker

    MOVEA.L D0,A0
    CLR.B   (A0)

.section1_after_marker:
    MOVEA.L -32(A5),A0

.section1_find_value_end:
    TST.B   (A0)+
    BNE.S   .section1_find_value_end

    SUBQ.L  #1,A0
    SUBA.L  -32(A5),A0
    MOVE.L  A0,D0
    MOVEA.L -32(A5),A1
    ADDA.L  D0,A1
    SUBQ.L  #1,A1
    MOVE.L  A1,-36(A5)

.section1_trim_value_end:
    MOVEA.L -36(A5),A0
    CMPA.L  -32(A5),A0
    BLS.S   .section1_alloc_entry

    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section1_alloc_entry

    CLR.B   (A0)
    SUBQ.L  #1,-36(A5)
    BRA.S   .section1_trim_value_end

.section1_alloc_entry:
    ADDQ.L  #1,D5
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     LAB_224F,A0
    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     8.W
    PEA     219.W
    PEA     GLOB_STR_PARSEINI_C_1
    MOVE.L  A0,36(A7)
    JSR     GROUPD_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVEA.L 36(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     LAB_224F,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    SUBA.L  A0,A0
    MOVE.L  A0,(A2)
    MOVE.L  A0,4(A2)
    MOVE.L  (A2),(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     JMPTBL_LAB_0B44(PC)

    MOVE.L  D0,(A2)
    PEA     34.W
    MOVE.L  -32(A5),-(A7)
    JSR     JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    LEA     28(A7),A7
    MOVE.L  D0,-40(A5)
    TST.L   D0
    BNE.S   .section1_after_first_quote

    CLR.W   LAB_1DDA
    MOVEQ   #0,D0
    BRA.W   .return

.section1_after_first_quote:
    MOVEA.L D0,A0
    ADDQ.L  #1,A0
    MOVE.L  A0,-32(A5)
    PEA     34.W
    MOVE.L  -32(A5),-(A7)
    JSR     JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-40(A5)
    TST.L   D0
    BNE.S   .section1_store_second_string

    CLR.W   LAB_1DDA

    MOVEQ   #0,D0
    BRA.W   .return

.section1_store_second_string:
    MOVEA.L D0,A0
    CLR.B   (A0)
    MOVE.L  4(A2),-(A7)
    MOVE.L  -32(A5),-(A7)
    JSR     JMPTBL_LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,4(A2)
    MOVE.L  D5,D0
    ADDQ.L  #1,D0
    MOVE.W  D0,LAB_1DDA
    BRA.W   .next_line

.section1_reset_count:
    CLR.W   LAB_1DDA
    BRA.W   .next_line

.section2_parse_line:
    PEA     61.W
    MOVE.L  -8(A5),-(A7)
    JSR     JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-32(A5)
    BEQ.W   .next_line

    MOVEA.L D0,A0
    CLR.B   (A0)+
    MOVE.L  A0,-32(A5)

.section2_skip_value_ws:
    MOVEA.L -32(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section2_cut_marker

    ADDQ.L  #1,-32(A5)
    BRA.S   .section2_skip_value_ws

.section2_cut_marker:
    PEA     LAB_2067
    MOVE.L  -8(A5),-(A7)
    JSR     GROUP_BA_JMPTBL_UNKNOWN7_FindAnyCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-36(A5)
    TST.L   D0
    BEQ.S   .section2_after_marker

    MOVEA.L D0,A0
    CLR.B   (A0)

.section2_after_marker:
    MOVEA.L -32(A5),A0

.section2_find_value_end:
    TST.B   (A0)+
    BNE.S   .section2_find_value_end

    SUBQ.L  #1,A0
    SUBA.L  -32(A5),A0
    MOVE.L  A0,D0
    MOVEA.L -32(A5),A1
    ADDA.L  D0,A1
    SUBQ.L  #1,A1
    MOVE.L  A1,-36(A5)

.section2_trim_value_end:
    MOVEA.L -36(A5),A0
    CMPA.L  -32(A5),A0
    BLS.S   .section2_dispatch_keyvalue

    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section2_dispatch_keyvalue

    CLR.B   (A0)
    SUBQ.L  #1,-36(A5)
    BRA.S   .section2_trim_value_end

.section2_dispatch_keyvalue:
    MOVE.L  -32(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    BSR.W   LAB_13E6

    ADDQ.W  #8,A7
    BRA.W   .next_line

.section3_parse_range:
    PEA     LAB_233F
    MOVE.L  -8(A5),-(A7)
    BSR.W   LAB_13D7

    ADDQ.W  #8,A7
    BRA.W   .next_line

.section4_5_parse_line:
    PEA     61.W
    MOVE.L  -8(A5),-(A7)
    JSR     JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-32(A5)
    BEQ.W   .next_line

    MOVEA.L D0,A0
    CLR.B   (A0)+
    MOVE.L  A0,-32(A5)

.section4_5_skip_value_ws:
    MOVEA.L -32(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section4_5_cut_marker

    ADDQ.L  #1,-32(A5)
    BRA.S   .section4_5_skip_value_ws

.section4_5_cut_marker:
    PEA     LAB_2068
    MOVE.L  -8(A5),-(A7)
    JSR     GROUP_BA_JMPTBL_UNKNOWN7_FindAnyCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-36(A5)
    TST.L   D0
    BEQ.S   .section4_5_after_marker

    MOVEA.L D0,A0

    CLR.B   (A0)

.section4_5_after_marker:
    MOVEA.L -32(A5),A0

.section4_5_find_value_end:
    TST.B   (A0)+
    BNE.S   .section4_5_find_value_end

    SUBQ.L  #1,A0

    SUBA.L  -32(A5),A0
    MOVE.L  A0,D0
    MOVEA.L -32(A5),A1
    ADDA.L  D0,A1
    SUBQ.L  #1,A1
    MOVE.L  A1,-36(A5)

.section4_5_trim_value_end:
    MOVEA.L -36(A5),A0
    CMPA.L  -32(A5),A0
    BLS.S   .section4_5_dispatch

    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section4_5_dispatch

    CLR.B   (A0)
    SUBQ.L  #1,-36(A5)
    BRA.S   .section4_5_trim_value_end

.section4_5_dispatch:
    MOVE.L  D7,-(A7)
    MOVE.L  -32(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    BSR.W   LAB_1408

    LEA     12(A7),A7
    BRA.W   .next_line

.section6_parse_line:
    PEA     61.W
    MOVE.L  -8(A5),-(A7)
    JSR     JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-32(A5)
    BEQ.W   .next_line

    MOVEA.L D0,A0
    CLR.B   (A0)+
    MOVE.L  A0,-32(A5)

.section6_skip_value_ws:
    MOVEA.L -32(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section6_cut_marker

    ADDQ.L  #1,-32(A5)
    BRA.S   .section6_skip_value_ws

.section6_cut_marker:
    PEA     LAB_2069
    MOVE.L  -8(A5),-(A7)
    JSR     GROUP_BA_JMPTBL_UNKNOWN7_FindAnyCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-36(A5)
    TST.L   D0
    BEQ.S   .section6_after_marker

    MOVEA.L D0,A0
    CLR.B   (A0)

.section6_after_marker:
    MOVEA.L -32(A5),A0

.section6_find_value_end:
    TST.B   (A0)+
    BNE.S   .section6_find_value_end

    SUBQ.L  #1,A0
    SUBA.L  -32(A5),A0
    MOVE.L  A0,D0
    MOVEA.L -32(A5),A1
    ADDA.L  D0,A1
    SUBQ.L  #1,A1
    MOVE.L  A1,-36(A5)

.section6_trim_value_end:
    MOVEA.L -36(A5),A0
    CMPA.L  -32(A5),A0
    BLS.S   .section6_dispatch

    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section6_dispatch

    CLR.B   (A0)
    SUBQ.L  #1,-36(A5)
    BRA.S   .section6_trim_value_end

.section6_dispatch:
    MOVE.L  -32(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    BSR.W   LAB_1400

    ADDQ.W  #8,A7
    BRA.W   .next_line

.section7_parse_line:
    PEA     61.W
    MOVE.L  -8(A5),-(A7)
    JSR     JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-32(A5)
    BEQ.W   .next_line

    MOVEA.L D0,A0
    CLR.B   (A0)+
    MOVE.L  A0,-32(A5)

.section7_skip_value_ws:
    MOVEA.L -32(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section7_cut_marker

    ADDQ.L  #1,-32(A5)
    BRA.S   .section7_skip_value_ws

.section7_cut_marker:
    PEA     LAB_206A
    MOVE.L  -8(A5),-(A7)
    JSR     GROUP_BA_JMPTBL_UNKNOWN7_FindAnyCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-36(A5)
    TST.L   D0
    BEQ.S   .section7_after_marker

    MOVEA.L D0,A0
    CLR.B   (A0)

.section7_after_marker:
    MOVEA.L -32(A5),A0

.section7_find_value_end:
    TST.B   (A0)+
    BNE.S   .section7_find_value_end

    SUBQ.L  #1,A0
    SUBA.L  -32(A5),A0
    MOVE.L  A0,D0
    MOVEA.L -32(A5),A1
    ADDA.L  D0,A1
    SUBQ.L  #1,A1
    MOVE.L  A1,-36(A5)

.section7_trim_value_end:
    MOVEA.L -36(A5),A0
    CMPA.L  -32(A5),A0
    BLS.S   .section7_dispatch

    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section7_dispatch

    CLR.B   (A0)
    SUBQ.L  #1,-36(A5)
    BRA.S   .section7_trim_value_end

.section7_dispatch:
    MOVE.L  -32(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    BSR.W   LAB_1404

    ADDQ.W  #8,A7
    BRA.W   .next_line

.section8_parse_line:
    PEA     61.W
    MOVE.L  -8(A5),-(A7)
    JSR     JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-32(A5)
    BEQ.W   .next_line

    MOVEA.L D0,A0
    CLR.B   (A0)+
    MOVE.L  A0,-32(A5)

.section8_skip_value_ws:
    MOVEA.L -32(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section8_cut_marker

    ADDQ.L  #1,-32(A5)
    BRA.S   .section8_skip_value_ws

.section8_cut_marker:
    PEA     LAB_206B
    MOVE.L  -8(A5),-(A7)
    JSR     GROUP_BA_JMPTBL_UNKNOWN7_FindAnyCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-36(A5)
    TST.L   D0
    BEQ.S   .section8_after_marker

    MOVEA.L D0,A0
    CLR.B   (A0)

.section8_after_marker:
    MOVEA.L -32(A5),A0

.section8_find_value_end:
    TST.B   (A0)+
    BNE.S   .section8_find_value_end

    SUBQ.L  #1,A0
    SUBA.L  -32(A5),A0
    MOVE.L  A0,D0
    MOVEA.L -32(A5),A1
    ADDA.L  D0,A1
    SUBQ.L  #1,A1
    MOVE.L  A1,-36(A5)

.section8_trim_value_end:
    MOVEA.L -36(A5),A0
    CMPA.L  -32(A5),A0
    BLS.S   .section8_dispatch

    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section8_dispatch

    CLR.B   (A0)
    SUBQ.L  #1,-36(A5)
    BRA.S   .section8_trim_value_end

.section8_dispatch:
    MOVE.L  -32(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     TEXTDISP_AddSourceConfigEntry(PC)

    ADDQ.W  #8,A7
    BRA.W   .next_line

.cleanup_and_free:
    MOVE.L  D6,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     403.W
    PEA     GLOB_STR_PARSEINI_C_2
    JSR     GROUPD_JMPTBL_MEMORY_DeallocateMemory(PC)

.return:
    MOVEM.L -64(A5),D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_13D4:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7

LAB_13D5:
    MOVE.L  A3,D0
    BEQ.S   LAB_13D6

    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   LAB_13D6

    ASL.L   #4,D7
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_1598(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    ADD.L   D1,D7
    ADDQ.L  #1,A3
    BRA.S   LAB_13D5

LAB_13D6:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_ParseRangeKeyValue   (Parse range key/value??)
; ARGS:
;   stack +8: A3 = source string pointer
;   stack +12: A2 = output struct pointer
; RET:
;   D0: status (0 = ok, -1 on invalid)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   JMPTBL_UNKNOWN7_FindCharWrapper, LAB_134B, GROUP_BA_JMPTBL_UNKNOWN7_FindAnyCharWrapper, JMPTBL_STRING_CompareNoCaseN, JMPTBL_GCOMMAND_ValidatePresetTable, LAB_159A
; READS:
;   LAB_206D, LAB_206E/206F/2070-2072 lookup strings, LAB_223A-D fields
; WRITES:
;   LAB_206D, LAB_206D-indexed output in A2, LAB_206D sentinel when invalid
; DESC:
;   Parses a pair of bracketed numeric fields (two strings), validates them,
;   and writes results into a 16-entry table pointed to by A2.
; NOTES:
;   Uses 61 '=' delimiter; clamps/validates ranges 0..15 for index, 1..999 for value.
;------------------------------------------------------------------------------
PARSEINI_ParseRangeKeyValue:
LAB_13D7:
    LINK.W  A5,#-16
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEA.L A3,A0
    MOVE.L  A0,-4(A5)
    BEQ.S   LAB_13D8

    PEA     61.W
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVEA.L D0,A0
    BRA.S   LAB_13D9

LAB_13D8:
    SUBA.L  A0,A0

LAB_13D9:
    MOVE.L  A0,-8(A5)
    TST.L   -4(A5)
    BEQ.S   LAB_13DB

    MOVE.L  A0,D0
    BEQ.S   LAB_13DB

    MOVE.L  -4(A5),-(A7)
    JSR     LAB_134B(PC)

    PEA     LAB_206E
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     GROUP_BA_JMPTBL_UNKNOWN7_FindAnyCharWrapper(PC)

    LEA     12(A7),A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BEQ.S   LAB_13DA

    MOVEQ   #0,D0
    MOVE.B  D0,(A3)

LAB_13DA:
    MOVEA.L -8(A5),A0
    CLR.B   (A0)+
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-8(A5)
    JSR     LAB_134B(PC)

    PEA     LAB_206F
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-8(A5)
    JSR     GROUP_BA_JMPTBL_UNKNOWN7_FindAnyCharWrapper(PC)

    LEA     12(A7),A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BEQ.S   LAB_13DB

    CLR.B   (A3)

LAB_13DB:
    TST.L   -4(A5)
    BEQ.W   LAB_13E5

    TST.L   -8(A5)
    BEQ.W   LAB_13E5

    PEA     5.W
    PEA     LAB_2070
    MOVE.L  -4(A5),-(A7)
    JSR     JMPTBL_STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   LAB_13DC

    PEA     4.W
    PEA     LAB_2071
    MOVE.L  -8(A5),-(A7)
    JSR     JMPTBL_STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   LAB_13DC

    MOVE.L  A2,-(A7)
    JSR     JMPTBL_GCOMMAND_ValidatePresetTable(PC)

    ADDQ.W  #4,A7
    MOVEQ   #-1,D0
    MOVE.L  D0,LAB_206D
    BRA.W   LAB_13E5

LAB_13DC:
    PEA     5.W
    PEA     LAB_2072
    MOVE.L  -4(A5),-(A7)
    JSR     JMPTBL_STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.W   LAB_13E4

    MOVEA.L -4(A5),A0
    ADDQ.L  #5,A0
    MOVEQ   #0,D7
    MOVE.L  A0,-12(A5)
    MOVE.L  A0,D0
    BEQ.S   LAB_13DD

    TST.B   (A0)
    BEQ.S   LAB_13DD

    MOVE.L  A0,-(A7)
    JSR     LAB_159A(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7

LAB_13DD:
    TST.W   D7
    BMI.S   LAB_13DE

    MOVEQ   #16,D0
    CMP.W   D0,D7
    BLT.S   LAB_13DF

LAB_13DE:
    MOVEQ   #-1,D0
    MOVE.L  D0,LAB_206D
    BRA.S   LAB_13E0

LAB_13DF:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,LAB_206D
    ADD.L   D0,D0
    CLR.W   0(A2,D0.L)

LAB_13E0:
    MOVE.L  LAB_206D,D0
    TST.L   D0
    BMI.W   LAB_13E5

    MOVEQ   #16,D1
    CMP.L   D1,D0
    BGE.W   LAB_13E5

    MOVE.L  -8(A5),-(A7)
    JSR     LAB_159A(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D6
    MOVEQ   #1,D0
    CMP.W   D0,D6
    BLT.S   LAB_13E1

    MOVEQ   #63,D1
    CMP.W   D1,D6
    BLE.S   LAB_13E2

LAB_13E1:
    MOVEQ   #-1,D6
    BRA.S   LAB_13E3

LAB_13E2:
    ADDQ.W  #1,D6

LAB_13E3:
    MOVE.L  LAB_206D,D0
    MOVE.L  D0,D1
    ADD.L   D1,D1
    MOVE.W  D6,0(A2,D1.L)
    BRA.S   LAB_13E5

LAB_13E4:
    MOVE.L  LAB_206D,D0
    TST.L   D0
    BMI.S   LAB_13E5

    MOVEQ   #16,D1
    CMP.L   D1,D0
    BGE.S   LAB_13E5

    ADD.L   D0,D0
    MOVE.W  0(A2,D0.L),D1
    TST.W   D1
    BLE.S   LAB_13E5

    MOVE.L  -4(A5),-(A7)
    JSR     LAB_159A(PC)

    MOVE.L  D0,D7
    MOVE.L  -8(A5),(A7)
    BSR.W   LAB_13D4

    ADDQ.W  #4,A7
    MOVE.L  D0,D6
    TST.W   D7
    BLE.S   LAB_13E5

    MOVE.L  LAB_206D,D0
    MOVE.L  D0,D1
    ADD.L   D1,D1
    CMP.W   0(A2,D1.L),D7
    BGE.S   LAB_13E5

    TST.W   D6
    BMI.S   LAB_13E5

    CMPI.W  #$1000,D6
    BGE.S   LAB_13E5

    ASL.L   #7,D0
    MOVEA.L A2,A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    EXT.L   D0
    ADD.L   D0,D0
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    MOVE.W  D0,32(A0)

LAB_13E5:
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_ProcessWeatherBlocks   (Process weather-related INI blocks??)
; ARGS:
;   stack +8: A3 = current line pointer
;   stack +12: A2 = target struct pointer
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   JMPTBL_STRING_CompareNoCase_3, JMPTBL_BRUSH_AllocBrushNode, JMPTBL_STRING_CompareNoCaseN, LAB_159A, LAB_15A1
; READS:
;   LAB_1B1F, LAB_233D, LAB_2073, LAB_2059, LAB_206D
; WRITES:
;   LAB_233D, LAB_1B1F, LAB_2073, LAB_206D, fields at offsets 190+ in LAB_233D struct
; DESC:
;   Handles a collection of weather configuration keys (WX strings, codes, timing)
;   populating a weather/display struct and related globals.
; NOTES:
;   Many keys are matched via JMPTBL_STRING_CompareNoCase_3 against literal strings LAB_2074..208A.
;------------------------------------------------------------------------------
PARSEINI_ProcessWeatherBlocks:
LAB_13E6:
    LINK.W  A5,#-8
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    SUBA.L  A0,A0
    MOVE.L  A0,-8(A5)
    TST.L   LAB_1B1F
    BNE.S   LAB_13E7

    MOVE.L  A0,LAB_2073
    MOVE.L  A0,LAB_233D

LAB_13E7:
    PEA     LAB_2074
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13E8

    CLR.L   LAB_2073
    MOVE.L  LAB_233D,-(A7)
    MOVE.L  A2,-(A7)
    JSR     JMPTBL_BRUSH_AllocBrushNode(PC)

    ADDQ.W  #8,A7
    MOVEA.L D0,A0
    MOVE.B  #$1,190(A0)
    MOVE.L  D0,LAB_233D
    TST.L   LAB_1B1F
    BNE.S   LAB_13E8

    MOVE.L  D0,LAB_1B1F

LAB_13E8:
    TST.L   LAB_233D
    BEQ.W   LAB_13FF

    PEA     LAB_2075
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13EC

    PEA     LAB_2076
    MOVE.L  A2,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13E9

    MOVEA.L LAB_233D,A0
    CLR.L   194(A0)
    BRA.W   LAB_13FF

LAB_13E9:
    PEA     LAB_2077
    MOVE.L  A2,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13EA

    MOVEQ   #2,D0
    MOVEA.L LAB_233D,A0
    MOVE.L  D0,194(A0)
    BRA.W   LAB_13FF

LAB_13EA:
    PEA     LAB_2078
    MOVE.L  A2,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13EB

    MOVEQ   #3,D0
    MOVEA.L LAB_233D,A0
    MOVE.L  D0,194(A0)
    BRA.W   LAB_13FF

LAB_13EB:
    MOVEQ   #1,D0
    MOVEA.L LAB_233D,A0
    MOVE.L  D0,194(A0)
    BRA.W   LAB_13FF

LAB_13EC:
    PEA     LAB_2079
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13ED

    MOVE.L  A2,-(A7)
    JSR     LAB_159A(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    MOVEA.L LAB_233D,A0
    MOVE.L  D7,198(A0)
    BRA.W   LAB_13FF

LAB_13ED:
    PEA     LAB_207A
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13EE

    PEA     LAB_207B
    MOVE.L  A2,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.W   LAB_13FF

    MOVEA.L LAB_233D,A0
    MOVE.B  #$2,190(A0)
    BRA.W   LAB_13FF

LAB_13EE:
    PEA     LAB_207C
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13EF

    MOVE.L  A2,-(A7)
    JSR     LAB_159A(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    MOVEA.L LAB_233D,A0
    MOVE.L  D7,202(A0)
    BRA.W   LAB_13FF

LAB_13EF:
    PEA     LAB_207D
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13F0

    MOVE.L  A2,-(A7)
    JSR     LAB_159A(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    MOVEA.L LAB_233D,A0
    MOVE.L  D7,206(A0)
    BRA.W   LAB_13FF

LAB_13F0:
    PEA     LAB_207E
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13F1

    MOVE.L  A2,-(A7)
    JSR     LAB_159A(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    MOVEA.L LAB_233D,A0
    MOVE.L  D7,210(A0)
    BRA.W   LAB_13FF

LAB_13F1:
    PEA     LAB_207F
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13F2

    MOVE.L  A2,-(A7)
    JSR     LAB_159A(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    MOVEA.L LAB_233D,A0
    MOVE.L  D7,214(A0)
    BRA.W   LAB_13FF

LAB_13F2:
    PEA     LAB_2080
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13F3

    MOVE.L  A2,-(A7)
    JSR     LAB_159A(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    MOVEA.L LAB_233D,A0
    MOVE.L  D7,218(A0)
    BRA.W   LAB_13FF

LAB_13F3:
    PEA     LAB_2081
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.W   LAB_13F8

    MOVEA.L A2,A0

LAB_13F4:
    TST.B   (A0)+
    BNE.S   LAB_13F4

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,D0
    TST.L   D0
    BLE.W   LAB_13F8

    PEA     LAB_2082
    MOVE.L  A2,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13F5

    MOVEA.L LAB_233D,A0
    MOVE.B  #$3,190(A0)
    BRA.W   LAB_13FF

LAB_13F5:
    MOVE.L  LAB_2073,-8(A5)
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     12.W
    PEA     670.W
    PEA     GLOB_STR_PARSEINI_C_3
    JSR     GROUPD_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,LAB_2073
    TST.L   D0
    BEQ.W   LAB_13FF

    MOVEA.L D0,A0
    CLR.L   8(A0)
    MOVEA.L A2,A0
    MOVEA.L D0,A1

LAB_13F6:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_13F6

    MOVEA.L LAB_233D,A0
    TST.L   230(A0)
    BNE.S   LAB_13F7

    MOVEA.L LAB_2073,A1
    MOVE.L  A1,230(A0)
    BRA.W   LAB_13FF

LAB_13F7:
    MOVEA.L -8(A5),A1
    MOVE.L  LAB_2073,8(A1)
    BRA.W   LAB_13FF

LAB_13F8:
    PEA     LAB_2084
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13FB

    PEA     LAB_2085
    MOVE.L  A2,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13F9

    MOVEQ   #2,D0
    MOVEA.L LAB_233D,A0
    MOVE.L  D0,222(A0)
    BRA.W   LAB_13FF

LAB_13F9:
    PEA     LAB_2086
    MOVE.L  A2,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13FA

    MOVEQ   #1,D0
    MOVEA.L LAB_233D,A0
    MOVE.L  D0,222(A0)
    BRA.W   LAB_13FF

LAB_13FA:
    MOVEA.L LAB_233D,A0
    CLR.L   222(A0)
    BRA.W   LAB_13FF

LAB_13FB:
    PEA     LAB_2087
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13FE

    PEA     LAB_2088
    MOVE.L  A2,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13FC

    MOVEQ   #2,D0
    MOVEA.L LAB_233D,A0
    MOVE.L  D0,226(A0)
    BRA.S   LAB_13FF

LAB_13FC:
    PEA     LAB_2089
    MOVE.L  A2,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13FD

    MOVEQ   #1,D0
    MOVEA.L LAB_233D,A0
    MOVE.L  D0,226(A0)
    BRA.S   LAB_13FF

LAB_13FD:
    MOVEA.L LAB_233D,A0
    CLR.L   226(A0)
    BRA.S   LAB_13FF

LAB_13FE:
    PEA     LAB_208A
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_13FF

    MOVEA.L LAB_233D,A0
    ADDA.W  #191,A0
    PEA     2.W
    MOVE.L  A2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_15A1(PC)

    LEA     12(A7),A7
    MOVEA.L LAB_233D,A0
    CLR.B   193(A0)

LAB_13FF:
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_LoadWeatherStrings   (Load weather strings/locations??)
; ARGS:
;   stack +8: A3 = source string pointer
;   stack +12: A2 = destination buffer/struct
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   JMPTBL_STRING_CompareNoCase_3, JMPTBL_BRUSH_AllocBrushNode, GROUP_BA_JMPTBL_UNKNOWN7_FindAnyCharWrapper, JMPTBL_STRING_CompareNoCaseN, LAB_159A
; READS:
;   LAB_1B23, LAB_233E, LAB_2059
; WRITES:
;   LAB_233E, LAB_1B23, LAB_2059
; DESC:
;   Parses weather string keys, allocates/sets current weather display entries,
;   and handles default/fallback cases.
; NOTES:
;   Sets field 190(A0) to 0x0A when a new block is created.
;------------------------------------------------------------------------------
PARSEINI_LoadWeatherStrings:
LAB_1400:
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEA.L 16(A7),A2
    TST.L   LAB_1B23
    BNE.S   LAB_1401

    CLR.L   LAB_233E

LAB_1401:
    PEA     LAB_208B
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_1402

    MOVE.L  LAB_233E,-(A7)
    MOVE.L  A2,-(A7)
    JSR     JMPTBL_BRUSH_AllocBrushNode(PC)

    ADDQ.W  #8,A7
    MOVEA.L D0,A0
    MOVE.B  #$a,190(A0)
    MOVE.L  D0,LAB_233E
    TST.L   LAB_1B23
    BNE.S   LAB_1403

    MOVE.L  D0,LAB_1B23
    BRA.S   LAB_1403

LAB_1402:
    MOVEQ   #0,D0
    TST.L   D0
    BEQ.S   LAB_1403

    PEA     LAB_208C
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_1403

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_2059
    MOVE.L  LAB_233E,-(A7)
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_BRUSH_AllocBrushNode(PC)

    ADDQ.W  #8,A7
    MOVEA.L D0,A0
    MOVE.B  #10,190(A0)
    MOVE.L  D0,LAB_233E
    TST.L   LAB_1B23
    BNE.S   LAB_1403

    MOVE.L  D0,LAB_1B23

LAB_1403:
    MOVEM.L (A7)+,A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_LoadWeatherMessageStrings   (Load message strings??)
; ARGS:
;   stack +12: A3 = source string pointer
;   stack +16: A2 = destination buffer
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   JMPTBL_STRING_CompareNoCase_3, JMPTBL_LAB_0B44
; READS:
;   LAB_205A/B/C, LAB_2059
; WRITES:
;   LAB_205A/B/C
; DESC:
;   Parses three related message strings and stores them in LAB_205A/B/C.
; NOTES:
;   Uses sequential key matching LAB_208D/E/F.
;------------------------------------------------------------------------------
PARSEINI_LoadWeatherMessageStrings:
LAB_1404:
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEA.L 16(A7),A2
    PEA     LAB_208D
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_1405

    MOVE.L  LAB_205A,-(A7)
    MOVE.L  A2,-(A7)
    JSR     JMPTBL_LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_205A
    BRA.S   LAB_1407

LAB_1405:
    PEA     LAB_208E
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_1406

    MOVE.L  LAB_205B,-(A7)
    MOVE.L  A2,-(A7)
    JSR     JMPTBL_LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_205B
    BRA.S   LAB_1407

LAB_1406:
    PEA     LAB_208F
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   LAB_1407

    MOVE.L  LAB_205C,-(A7)
    MOVE.L  A2,-(A7)
    JSR     JMPTBL_LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_205C

LAB_1407:
    MOVEM.L (A7)+,A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_ParseColorTable   (Parse color table entries??)
; ARGS:
;   stack +8: A3 = source string pointer
;   stack +12: A2 = destination table ptr
;   stack +16: D7 = mode selector (0: rgb?, 1: palette??, 4 triggers checksum)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   JMPTBL_PRINTF_4, JMPTBL_STRING_CompareNoCase_3, LAB_1598, TEXTDISP_JMPTBL_LAB_0A48
; READS:
;   LAB_1ECC/LAB_1FB8 tables, GLOB_STR_COLOR_PERCENT_D
; WRITES:
;   color tables pointed by A2 (8x3 bytes)
; DESC:
;   Iterates through color percentages strings, converts them, and fills a table;
;   for mode 4 triggers TEXTDISP_JMPTBL_LAB_0A48 afterward.
; NOTES:
;   Converts using LAB_1598 (string→value) and stores into preset tables.
;------------------------------------------------------------------------------
PARSEINI_ParseColorTable:
LAB_1408:
    LINK.W  A5,#-120
    MOVEM.L D4-D7/A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7

    MOVE.L  D7,D0
    SUBQ.L  #4,D0
    BEQ.S   .mode4_select_table

    SUBQ.L  #1,D0
    BEQ.S   .mode5_select_table

    BRA.S   .init_color_index

.mode4_select_table:
    MOVE.L  #LAB_1FB8,-116(A5)
    MOVEQ   #8,D4
    BRA.S   .init_color_index

.mode5_select_table:
    MOVE.L  #LAB_1ECC,-116(A5)
    MOVEQ   #8,D4

.init_color_index:
    MOVEQ   #0,D6

.color_index_loop:
    CMP.L   D4,D6
    BGE.S   .maybe_finalize

    MOVE.L  D6,-(A7)
    PEA     GLOB_STR_COLOR_PERCENT_D
    PEA     -112(A5)
    JSR     JMPTBL_PRINTF_4(PC)

    PEA     -112(A5)
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    LEA     20(A7),A7
    TST.L   D0
    BNE.S   .next_color_index

    MOVEQ   #0,D5

.channel_loop:
    MOVEQ   #3,D0
    CMP.L   D0,D5
    BGE.S   .next_color_index

    MOVE.L  D6,D1
    LSL.L   #2,D1
    SUB.L   D6,D1
    ADD.L   D5,D1
    MOVE.B  0(A2,D5.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D1,28(A7)
    JSR     LAB_1598(PC)

    ADDQ.W  #4,A7
    MOVEA.L -116(A5),A0
    MOVE.L  24(A7),D1
    MOVE.B  D0,0(A0,D1.L)
    ADDQ.L  #1,D5
    BRA.S   .channel_loop

.next_color_index:
    ADDQ.L  #1,D6
    BRA.S   .color_index_loop

.maybe_finalize:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BNE.S   .return

    JSR     TEXTDISP_JMPTBL_LAB_0A48(PC)

.return:
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_TestMemoryAndOpenTopazFont   (Test memory then open Topaz)
; ARGS:
;   stack +8: A3 = pointer to font handle storage
;   stack +12: A2 = TextAttr for desired font
; RET:
;   D0: 0 on success, 1 on failure
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _LVOCloseFont, _LVOForbid/_LVOPermit, _LVOAllocMem/_LVOFreeMem, _LVOOpenDiskFont
; READS:
;   GLOB_HANDLE_TOPAZ_FONT
; WRITES:
;   (A3) font handle
; DESC:
;   Ensures a Topaz font is open, first probing for a small alloc; closes an
;   existing non-Topaz handle, tries to open the requested font, otherwise falls
;   back to the global Topaz handle.
; NOTES:
;   Sets D0=1 when it could not load the desired font.
;------------------------------------------------------------------------------
PARSEINI_TestMemoryAndOpenTopazFont:
TEST_MEMORY_AND_OPEN_TOPAZ_FONT:
    LINK.W  A5,#-8
    MOVEM.L D7/A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2

    MOVEQ   #0,D7
    TST.L   (A3)
    BEQ.S   .return

    MOVEA.L (A3),A0
    MOVEA.L GLOB_HANDLE_TOPAZ_FONT,A1
    CMPA.L  A0,A1
    BEQ.S   .testDesiredMemoryAvailability

    MOVEA.L A0,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOCloseFont(A6)

.testDesiredMemoryAvailability:
    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    MOVE.L  #DesiredMemoryAvailability,D0
    MOVEQ   #1,D1
    JSR     _LVOAllocMem(A6)

    MOVE.L  D0,-4(A5)
    BEQ.S   .openTopazFont

    MOVEA.L D0,A1
    MOVE.L  #DesiredMemoryAvailability,D0
    JSR     _LVOFreeMem(A6)

.openTopazFont:
    JSR     _LVOPermit(A6)

    MOVEA.L A2,A0
    MOVEA.L GLOB_REF_DISKFONT_LIBRARY,A6
    JSR     _LVOOpenDiskFont(A6)

    MOVE.L  D0,(A3)
    BNE.S   .couldNotLoadTopazFont

    MOVE.L  GLOB_HANDLE_TOPAZ_FONT,(A3)
    BRA.S   .return

.couldNotLoadTopazFont:
    MOVEQ   #1,D7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

; we're doing a bunch of font stuff in here!
;------------------------------------------------------------------------------
; FUNC: PARSEINI_HandleFontCommand   (Parse font command sequence??)
; ARGS:
;   stack +8: A3 = command string pointer
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   JMPTBL_PRINTF_4, _LVOExecute, PARSEINI_TestMemoryAndOpenTopazFont, LAB_1429
; READS:
;   GLOB_REF_DOS_LIBRARY_2, GLOB_HANDLE_TOPAZ_FONT
; WRITES:
;   (font handles via PARSEINI_TestMemoryAndOpenTopazFont)
; DESC:
;   Parses a command string starting with '3' '2' ... handling subcommands to
;   execute shell commands or open fonts depending on the trailing byte.
; NOTES:
;   Matches subcodes 0x34–0x38 etc.; returns early on non-matching prefixes.
;------------------------------------------------------------------------------
PARSEINI_HandleFontCommand:
LAB_1416:
    LINK.W  A5,#-88
    MOVEM.L D2-D3/D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.B  (A3)+,D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    SUBI.W  #$33,D0
    BNE.W   .return

    MOVE.B  (A3)+,D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    SUBI.W  #$32,D0
    BEQ.S   .handle_32_execute

    SUBQ.W  #1,D0
    BEQ.S   .handle_33_subcommands

    SUBQ.W  #1,D0
    BEQ.W   .handle_34_subcommands

    BRA.W   .return

.handle_32_execute:
    MOVE.L  A3,-(A7)
    PEA     GLOB_STR_PERCENT_S_2
    PEA     -80(A5)
    JSR     JMPTBL_PRINTF_4(PC)

    LEA     12(A7),A7
    LEA     -80(A5),A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    BRA.W   .return

.handle_33_subcommands:
    MOVE.B  (A3)+,D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    SUBI.W  #$34,D0
    BEQ.S   .cmd_wait_clear_flag0

    SUBQ.W  #1,D0
    BEQ.S   .cmd_scan_logos_and_clear_flag1

    SUBQ.W  #1,D0
    BEQ.S   .cmd_call_lab_09DB

    SUBQ.W  #1,D0
    BEQ.S   .cmd_set_h26f_font

    SUBQ.W  #1,D0
    BEQ.W   .cmd_set_prevuec_font

    SUBQ.W  #1,D0
    BEQ.W   .cmd_set_prevue_font

    SUBI.W  #$18,D0
    BEQ.W   .cmd_parse_ini_from_disk

    SUBI.W  #16,D0
    BEQ.W   .cmd_call_lab_0A93

    SUBQ.W  #1,D0
    BEQ.W   .cmd_parse_gradient_ini

    SUBQ.W  #1,D0
    BEQ.W   .cmd_parse_banner_ini

    SUBQ.W  #1,D0
    BEQ.W   .cmd_parse_default_ini

    SUBI.W  #15,D0
    BEQ.W   .cmd_parse_sourcecfg_ini

    BRA.W   .return

.cmd_wait_clear_flag0:
    JSR     JMPTBL_ED1_WaitForFlagAndClearBit0(PC)

    BRA.W   .return

.cmd_scan_logos_and_clear_flag1:
    MOVE.B  LAB_1BC1,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .after_optional_logo_scan

    BSR.W   LAB_142E

.after_optional_logo_scan:
    JSR     JMPTBL_ED1_WaitForFlagAndClearBit1(PC)

    BRA.W   .return

.cmd_call_lab_09DB:
    JSR     JMPTBL_LAB_09DB(PC)

    BRA.W   .return

.cmd_set_h26f_font:
    PEA     GLOB_STRUCT_TEXTATTR_H26F_FONT
    PEA     GLOB_HANDLE_H26F_FONT
    BSR.W   TEST_MEMORY_AND_OPEN_TOPAZ_FONT

    ADDQ.W  #8,A7
    TST.W   D0
    BEQ.W   .return

    TST.W   LAB_2263
    BEQ.W   .return

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEA.L GLOB_HANDLE_H26F_FONT,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    BRA.W   .return

.cmd_set_prevuec_font:
    PEA     GLOB_STRUCT_TEXTATTR_PREVUEC_FONT
    PEA     GLOB_HANDLE_PREVUEC_FONT
    BSR.W   TEST_MEMORY_AND_OPEN_TOPAZ_FONT

    ADDQ.W  #8,A7
    TST.W   D0
    BEQ.W   .return

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0

    MOVEA.L A0,A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVEA.L GLOB_REF_RASTPORT_2,A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_2,A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVEQ   #0,D6

.prevec_font_rastport_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D6
    BGE.S   .after_prevuec_font_loop

    MOVE.L  D6,D0
    MOVEQ   #80,D1
    ADD.L   D1,D1
    JSR     JMPTBL_MATH_Mulu32_7(PC)

    LEA     LAB_22A6,A0
    ADDA.L  D0,A0
    LEA     60(A0),A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    ADDQ.L  #1,D6
    BRA.S   .prevec_font_rastport_loop

.after_prevuec_font_loop:
    MOVE.L  GLOB_HANDLE_PREVUEC_FONT,-(A7)
    JSR     LAB_1858

    ADDQ.W  #4,A7
    BRA.W   .return

.cmd_set_prevue_font:
    PEA     GLOB_STRUCT_TEXTATTR_PREVUE_FONT
    PEA     GLOB_HANDLE_PREVUE_FONT
    BSR.W   TEST_MEMORY_AND_OPEN_TOPAZ_FONT

    ADDQ.W  #8,A7
    TST.W   D0
    BRA.W   .return

.cmd_parse_ini_from_disk:
    JSR     JMPTBL_DISKIO_ParseIniFileFromDisk(PC)

    BRA.W   .return

.cmd_call_lab_0A93:
    PEA     97.W
    JSR     JMPTBL_LAB_0A93(PC)

    ADDQ.W  #4,A7
    BRA.W   .return

.cmd_parse_gradient_ini:
    PEA     GLOB_STR_DF0_GRADIENT_INI_3
    BSR.W   PARSEINI_ParseIniBufferAndDispatch

    ADDQ.W  #4,A7
    BRA.W   .return

.cmd_parse_banner_ini:
    PEA     GLOB_STR_DF0_BANNER_INI_2
    JSR     LAB_14C6(PC)

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.W   .return

.wait_banner_ready:
    TST.W   LAB_1B83
    BEQ.S   .wait_banner_ready

    CLR.L   -(A7)
    PEA     LAB_1B25
    JSR     JMPTBL_BRUSH_FreeBrushList(PC)

    PEA     LAB_1B23
    JSR     JMPTBL_BRUSH_FreeBrushResources(PC)

    PEA     GLOB_STR_DF0_BANNER_INI_3

    BSR.W   PARSEINI_ParseIniBufferAndDispatch

    PEA     1.W
    JSR     JMPTBL_LAB_09F9(PC)

    LEA     20(A7),A7
    BRA.S   .return

.cmd_parse_default_ini:
    PEA     GLOB_STR_DF0_DEFAULT_INI_2
    BSR.W   PARSEINI_ParseIniBufferAndDispatch

    ADDQ.W  #4,A7
    BRA.S   .return

.cmd_parse_sourcecfg_ini:
    PEA     GLOB_STR_DF0_SOURCECFG_INI_1
    BSR.W   PARSEINI_ParseIniBufferAndDispatch

    JSR     TEXTDISP_ApplySourceConfigAllEntries(PC)

    ADDQ.W  #4,A7

    BRA.S   .return

.handle_34_subcommands:
    MOVE.B  (A3)+,D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    SUBI.W  #$30,D0
    BEQ.S   .cmd_show_then_exit_esc_menu

    SUBQ.W  #1,D0
    BEQ.S   .cmd_draw_diagnostics

    SUBQ.W  #1,D0
    BEQ.S   .cmd_draw_version

    BRA.S   .return

.cmd_show_then_exit_esc_menu:
    JSR     JMPTBL_ED1_EnterEscMenu(PC)

    JSR     JMPTBL_ED1_ExitEscMenu(PC)

    BRA.S   .return

.cmd_draw_diagnostics:
    JSR     JMPTBL_ED1_EnterEscMenu(PC)

    JSR     JMPTBL_ED1_DrawDiagnosticsScreen(PC)

    BRA.S   .return

.cmd_draw_version:
    JSR     JMPTBL_ED1_EnterEscMenu(PC)

    JSR     JMPTBL_ESQFUNC_DrawEscMenuVersion(PC)

.return:
    MOVEM.L (A7)+,D2-D3/D6-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_ScanLogoDirectory   (Scan logo directory, build lists??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A2
; CALLS:
;   _LVOExecute, JMPTBL_HANDLE_OpenWithMode, GROUP_BA_JMPTBL_STREAM_ReadLineWithLimit, JMPTBL_GCOMMAND_FindPathSeparator, GROUPD_JMPTBL_MEMORY_AllocateMemory
; READS:
;   GLOB_STR_LIST_RAM_LOGODIR_TXT_DH2_LOGOS_NOHEAD_QUICK, LAB_2098/2099/209A/209B strings
; WRITES:
;   local temp buffers and allocated lists at -500/-900(A5)
; DESC:
;   Executes helper commands to list logo directories, reads entries into temp
;   buffers, allocates per-entry strings, and populates two arrays (probably names/paths).
; NOTES:
;   Iterates up to 100 entries per list, trimming CR/LF/commas from lines.
;------------------------------------------------------------------------------
PARSEINI_ScanLogoDirectory:
LAB_142E:
    LINK.W  A5,#-960
    MOVEM.L D2-D3/D5-D7/A2,-(A7)

    LEA     -88(A5),A0
    MOVEQ   #0,D6
    MOVE.L  A0,-100(A5)
    MOVE.L  A0,-96(A5)

.clear_entry_tables_loop:
    MOVEQ   #100,D0
    CMP.L   D0,D6
    BGE.S   .exec_list_command

    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     -500(A5),A0
    ADDA.L  D0,A0
    SUBA.L  A1,A1
    MOVE.L  A1,(A0)
    LEA     -900(A5),A0
    ADDA.L  D0,A0
    MOVE.L  A1,(A0)
    ADDQ.L  #1,D6
    BRA.S   .clear_entry_tables_loop

.exec_list_command:
    LEA     GLOB_STR_LIST_RAM_LOGODIR_TXT_DH2_LOGOS_NOHEAD_QUICK,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    PEA     LAB_2099
    PEA     LAB_2098
    JSR     JMPTBL_HANDLE_OpenWithMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    BNE.S   .after_open_primary

    CLR.L   -96(A5)

.after_open_primary:
    PEA     LAB_209B
    PEA     LAB_209A
    JSR     JMPTBL_HANDLE_OpenWithMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    BNE.S   .after_open_secondary

    CLR.L   -100(A5)

.after_open_secondary:
    MOVEQ   #0,D5

.read_primary_list_loop:
    TST.L   -96(A5)
    BEQ.W   .read_secondary_list_loop

    MOVEQ   #100,D0
    CMP.L   D0,D5
    BGE.W   .read_secondary_list_loop

    MOVE.L  -4(A5),-(A7)
    PEA     99.W
    PEA     -88(A5)
    JSR     GROUP_BA_JMPTBL_STREAM_ReadLineWithLimit(PC)

    LEA     12(A7),A7
    LEA     -88(A5),A0
    MOVEA.L A0,A1

.primary_line_len_loop:
    TST.B   (A1)+
    BNE.S   .primary_line_len_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D7
    MOVEQ   #0,D6
    MOVE.L  D0,-96(A5)

.primary_sanitize_loop:
    CMP.L   D7,D6
    BGE.S   .primary_alloc_and_store

    MOVEQ   #10,D0
    CMP.B   -88(A5,D6.L),D0
    BEQ.S   .primary_clear_char

    MOVEQ   #13,D0
    CMP.B   -88(A5,D6.L),D0
    BEQ.S   .primary_clear_char

    MOVEQ   #44,D0
    CMP.B   -88(A5,D6.L),D0
    BNE.S   .primary_next_char

.primary_clear_char:
    CLR.B   -88(A5,D6.L)

.primary_next_char:
    ADDQ.L  #1,D6
    BRA.S   .primary_sanitize_loop

.primary_alloc_and_store:
    PEA     -88(A5)
    JSR     JMPTBL_GCOMMAND_FindPathSeparator(PC)

    MOVE.L  D5,D1
    ASL.L   #2,D1
    LEA     -500(A5),A0
    ADDA.L  D1,A0
    MOVEA.L D0,A1

.primary_strlen_loop:
    TST.B   (A1)+
    BNE.S   .primary_strlen_loop

    SUBQ.L  #1,A1
    SUBA.L  D0,A1
    MOVE.L  A1,D1
    ADDQ.L  #1,D1
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    MOVE.L  D1,-(A7)
    PEA     1263.W
    PEA     GLOB_STR_PARSEINI_C_4
    MOVE.L  D0,-92(A5)
    MOVE.L  A0,40(A7)
    JSR     GROUPD_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L 24(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     -500(A5),A0
    ADDA.L  D0,A0
    MOVEA.L -92(A5),A1
    MOVEA.L (A0),A2

.primary_copy_string_loop:
    MOVE.B  (A1)+,(A2)+
    BNE.S   .primary_copy_string_loop

    ADDQ.L  #1,D5
    BRA.W   .read_primary_list_loop

.read_secondary_list_loop:
    MOVEQ   #0,D5

.secondary_list_loop:
    TST.L   -100(A5)
    BEQ.W   .compare_lists_loop

    MOVEQ   #100,D0
    CMP.L   D0,D5
    BGE.W   .compare_lists_loop

    MOVE.L  -8(A5),-(A7)
    PEA     99.W
    PEA     -88(A5)
    JSR     GROUP_BA_JMPTBL_STREAM_ReadLineWithLimit(PC)

    LEA     12(A7),A7
    LEA     -88(A5),A0
    MOVEA.L A0,A1

.secondary_strlen_loop:
    TST.B   (A1)+
    BNE.S   .secondary_strlen_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D7
    MOVEQ   #0,D6
    MOVE.L  D0,-100(A5)

.secondary_sanitize_loop:
    CMP.L   D7,D6
    BGE.S   .secondary_alloc_and_store

    MOVEQ   #10,D0
    CMP.B   -88(A5,D6.L),D0
    BEQ.S   .secondary_clear_char

    MOVEQ   #13,D0
    CMP.B   -88(A5,D6.L),D0
    BNE.S   .secondary_next_char

.secondary_clear_char:
    CLR.B   -88(A5,D6.L)

.secondary_next_char:
    ADDQ.L  #1,D6
    BRA.S   .secondary_sanitize_loop

.secondary_alloc_and_store:
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     -900(A5),A0
    ADDA.L  D0,A0
    LEA     -88(A5),A1
    MOVEA.L A1,A2

.secondary_strlen_alloc_loop:
    TST.B   (A2)+
    BNE.S   .secondary_strlen_alloc_loop

    SUBQ.L  #1,A2
    SUBA.L  A1,A2
    MOVE.L  A2,D0
    ADDQ.L  #1,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     1287.W
    PEA     GLOB_STR_PARSEINI_C_5
    MOVE.L  A0,40(A7)
    JSR     GROUPD_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L 24(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     -900(A5),A0
    ADDA.L  D0,A0
    LEA     -88(A5),A1
    MOVEA.L (A0),A2

.secondary_copy_string_loop:
    MOVE.B  (A1)+,(A2)+
    BNE.S   .secondary_copy_string_loop

    ADDQ.L  #1,D5
    BRA.W   .secondary_list_loop

.compare_lists_loop:
    MOVEQ   #0,D6

.next_secondary_entry:
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     -900(A5),A0
    ADDA.L  D0,A0
    TST.L   (A0)
    BEQ.W   .free_primary_entries_loop

    MOVEQ   #0,D5
    CLR.L   -916(A5)

.scan_primary_for_match:
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     -500(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   (A1)
    BEQ.S   .if_no_match_delete

    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     -900(A5),A1
    ADDA.L  D0,A1
    MOVE.L  D5,D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    MOVE.L  (A1),-(A7)
    JSR     JMPTBL_STRING_CompareNoCase_3(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .primary_match_next

    MOVEQ   #1,D0
    MOVE.L  D0,-916(A5)

.primary_match_next:
    ADDQ.L  #1,D5
    BRA.S   .scan_primary_for_match

.if_no_match_delete:
    TST.L   -916(A5)
    BNE.S   .free_secondary_entry

    LEA     GLOB_STR_DELETE_NIL_DH2_LOGOS,A0
    LEA     -956(A5),A1
    MOVEQ   #5,D0

.build_delete_cmd_copy_loop:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.build_delete_cmd_copy_loop

    CLR.B   (A1)
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     -900(A5),A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    PEA     -956(A5)
    JSR     JMPTBL_STRING_AppendAtNull_3(PC)

    ADDQ.W  #8,A7
    LEA     -956(A5),A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

.free_secondary_entry:
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     -900(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    ADDA.L  D0,A0
    MOVEA.L (A0),A2

.secondary_strlen_for_free:
    TST.B   (A2)+
    BNE.S   .secondary_strlen_for_free

    SUBQ.L  #1,A2
    SUBA.L  (A0),A2
    MOVE.L  A2,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  (A1),-(A7)
    PEA     1323.W
    PEA     GLOB_STR_PARSEINI_C_6
    JSR     GROUPD_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    ADDQ.L  #1,D6
    BRA.W   .next_secondary_entry

.free_primary_entries_loop:
    MOVEQ   #0,D5

.next_primary_entry_free:
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     -500(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   (A1)
    BEQ.S   .close_primary_handle

    MOVE.L  D5,D0
    ASL.L   #2,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    ADDA.L  D0,A0
    MOVEA.L (A0),A2

.primary_strlen_for_free:
    TST.B   (A2)+
    BNE.S   .primary_strlen_for_free

    SUBQ.L  #1,A2
    SUBA.L  (A0),A2
    MOVE.L  A2,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  (A1),-(A7)
    PEA     1329.W
    PEA     GLOB_STR_PARSEINI_C_7
    JSR     GROUPD_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    ADDQ.L  #1,D5
    BRA.S   .next_primary_entry_free

.close_primary_handle:
    TST.L   -4(A5)
    BEQ.S   .close_secondary_handle

    MOVE.L  -4(A5),-(A7)
    JSR     JMPTBL_UNKNOWN36_FinalizeRequest(PC)

    ADDQ.W  #4,A7

.close_secondary_handle:
    TST.L   -8(A5)
    BEQ.S   .return

    MOVE.L  -8(A5),-(A7)
    JSR     JMPTBL_UNKNOWN36_FinalizeRequest(PC)

    ADDQ.W  #4,A7

.return:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: JMPTBL_STRING_CompareNoCase_3   (JumpStub_STRING_CompareNoCase)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   STRING_CompareNoCase
; DESC:
;   Jump stub to STRING_CompareNoCase (string compare/parse helper).
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_STRING_CompareNoCase_3:
    JMP     STRING_CompareNoCase

;------------------------------------------------------------------------------
; FUNC: JMPTBL_ED1_WaitForFlagAndClearBit0   (JumpStub_ED1_WaitForFlagAndClearBit0)
; ARGS:
;   ?? (see ED1_WaitForFlagAndClearBit0)
; RET:
;   ?? (see ED1_WaitForFlagAndClearBit0)
; CLOBBERS:
;   ?? (see ED1_WaitForFlagAndClearBit0)
; CALLS:
;   ED1_WaitForFlagAndClearBit0
; DESC:
;   Jump stub to ED1_WaitForFlagAndClearBit0.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_ED1_WaitForFlagAndClearBit0:
LAB_1453:
    JMP     ED1_WaitForFlagAndClearBit0

;------------------------------------------------------------------------------
; FUNC: JMPTBL_DISKIO_ParseIniFileFromDisk   (JumpStub_LAB_04F0)
; ARGS:
;   ?? (see LAB_04F0)
; RET:
;   ?? (see LAB_04F0)
; CLOBBERS:
;   ?? (see LAB_04F0)
; CALLS:
;   LAB_04F0
; DESC:
;   Jump stub to LAB_04F0 (Parse INI file from disk).
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_DISKIO_ParseIniFileFromDisk:
LAB_1454:
    JMP     LAB_04F0

;------------------------------------------------------------------------------
; FUNC: JMPTBL_UNKNOWN7_FindCharWrapper   (JumpStub_UNKNOWN7_FindCharWrapper)
; ARGS:
;   ?? (see UNKNOWN7_FindCharWrapper)
; RET:
;   ?? (see UNKNOWN7_FindCharWrapper)
; CLOBBERS:
;   ?? (see UNKNOWN7_FindCharWrapper)
; CALLS:
;   UNKNOWN7_FindCharWrapper
; DESC:
;   Jump stub to UNKNOWN7_FindCharWrapper.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_UNKNOWN7_FindCharWrapper:
LAB_1455:
    JMP     UNKNOWN7_FindCharWrapper

;------------------------------------------------------------------------------
; FUNC: JMPTBL_HANDLE_OpenWithMode   (JumpStub_HANDLE_OpenWithMode)
; ARGS:
;   ?? (see HANDLE_OpenWithMode)
; RET:
;   ?? (see HANDLE_OpenWithMode)
; CLOBBERS:
;   ?? (see HANDLE_OpenWithMode)
; CALLS:
;   HANDLE_OpenWithMode
; DESC:
;   Jump stub to HANDLE_OpenWithMode.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_HANDLE_OpenWithMode:
LAB_1456:
    JMP     HANDLE_OpenWithMode

;------------------------------------------------------------------------------
; FUNC: JMPTBL_LAB_09F9   (JumpStub_LAB_09F9)
; ARGS:
;   ?? (see LAB_09F9)
; RET:
;   ?? (see LAB_09F9)
; CLOBBERS:
;   ?? (see LAB_09F9)
; CALLS:
;   LAB_09F9
; DESC:
;   Jump stub to LAB_09F9.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_LAB_09F9:
LAB_1457:
    JMP     LAB_09F9

;------------------------------------------------------------------------------
; FUNC: JMPTBL_LAB_0A93   (JumpStub_LAB_0A93)
; ARGS:
;   ?? (see LAB_0A93)
; RET:
;   ?? (see LAB_0A93)
; CLOBBERS:
;   ?? (see LAB_0A93)
; CALLS:
;   LAB_0A93
; DESC:
;   Jump stub to LAB_0A93.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_LAB_0A93:
LAB_1458:
    JMP     LAB_0A93

;------------------------------------------------------------------------------
; FUNC: JMPTBL_BRUSH_FreeBrushResources   (JumpStub_BRUSH_FreeBrushResources)
; ARGS:
;   ?? (see BRUSH_FreeBrushResources)
; RET:
;   ?? (see BRUSH_FreeBrushResources)
; CLOBBERS:
;   ?? (see BRUSH_FreeBrushResources)
; CALLS:
;   BRUSH_FreeBrushResources
; DESC:
;   Jump stub to BRUSH_FreeBrushResources.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_BRUSH_FreeBrushResources:
LAB_1459:
    JMP     BRUSH_FreeBrushResources

;------------------------------------------------------------------------------
; FUNC: JMPTBL_LAB_09DB   (JumpStub_LAB_09DB)
; ARGS:
;   ?? (see LAB_09DB)
; RET:
;   ?? (see LAB_09DB)
; CLOBBERS:
;   ?? (see LAB_09DB)
; CALLS:
;   LAB_09DB
; DESC:
;   Jump stub to LAB_09DB.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_LAB_09DB:
LAB_145A:
    JMP     LAB_09DB

;------------------------------------------------------------------------------
; FUNC: JMPTBL_GCOMMAND_FindPathSeparator   (JumpStub_GCOMMAND_FindPathSeparator)
; ARGS:
;   ?? (see GCOMMAND_FindPathSeparator)
; RET:
;   ?? (see GCOMMAND_FindPathSeparator)
; CLOBBERS:
;   ?? (see GCOMMAND_FindPathSeparator)
; CALLS:
;   GCOMMAND_FindPathSeparator
; DESC:
;   Jump stub to GCOMMAND_FindPathSeparator.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_GCOMMAND_FindPathSeparator:
LAB_145B:
    JMP     GCOMMAND_FindPathSeparator

;------------------------------------------------------------------------------
; FUNC: JMPTBL_LAB_03B9   (JumpStub_LAB_03B9)
; ARGS:
;   ?? (see LAB_03B9)
; RET:
;   ?? (see LAB_03B9)
; CLOBBERS:
;   ?? (see LAB_03B9)
; CALLS:
;   LAB_03B9
; DESC:
;   Jump stub to LAB_03B9.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_LAB_03B9:
LAB_145C:
    JMP     LAB_03B9

;------------------------------------------------------------------------------
; FUNC: JMPTBL_ED1_DrawDiagnosticsScreen   (JumpStub_ED1_DrawDiagnosticsScreen)
; ARGS:
;   ?? (see ED1_DrawDiagnosticsScreen)
; RET:
;   ?? (see ED1_DrawDiagnosticsScreen)
; CLOBBERS:
;   ?? (see ED1_DrawDiagnosticsScreen)
; CALLS:
;   ED1_DrawDiagnosticsScreen
; DESC:
;   Jump stub to ED1_DrawDiagnosticsScreen.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_ED1_DrawDiagnosticsScreen:
LAB_145D:
    JMP     ED1_DrawDiagnosticsScreen

;------------------------------------------------------------------------------
; FUNC: JMPTBL_BRUSH_FreeBrushList   (JumpStub_BRUSH_FreeBrushList)
; ARGS:
;   ?? (see BRUSH_FreeBrushList)
; RET:
;   ?? (see BRUSH_FreeBrushList)
; CLOBBERS:
;   ?? (see BRUSH_FreeBrushList)
; CALLS:
;   BRUSH_FreeBrushList
; DESC:
;   Jump stub to BRUSH_FreeBrushList.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_BRUSH_FreeBrushList:
LAB_145E:
    JMP     BRUSH_FreeBrushList

;------------------------------------------------------------------------------
; FUNC: JMPTBL_GCOMMAND_ValidatePresetTable   (JumpStub_GCOMMAND_ValidatePresetTable)
; ARGS:
;   ?? (see GCOMMAND_ValidatePresetTable)
; RET:
;   ?? (see GCOMMAND_ValidatePresetTable)
; CLOBBERS:
;   ?? (see GCOMMAND_ValidatePresetTable)
; CALLS:
;   GCOMMAND_ValidatePresetTable
; DESC:
;   Jump stub to GCOMMAND_ValidatePresetTable.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_GCOMMAND_ValidatePresetTable:
LAB_145F:
    JMP     GCOMMAND_ValidatePresetTable

;------------------------------------------------------------------------------
; FUNC: JMPTBL_BRUSH_AllocBrushNode   (JumpStub_BRUSH_AllocBrushNode)
; ARGS:
;   ?? (see BRUSH_AllocBrushNode)
; RET:
;   ?? (see BRUSH_AllocBrushNode)
; CLOBBERS:
;   ?? (see BRUSH_AllocBrushNode)
; CALLS:
;   BRUSH_AllocBrushNode
; DESC:
;   Jump stub to BRUSH_AllocBrushNode.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_BRUSH_AllocBrushNode:
LAB_1460:
    JMP     BRUSH_AllocBrushNode

;------------------------------------------------------------------------------
; FUNC: JMPTBL_UNKNOWN36_FinalizeRequest   (JumpStub_UNKNOWN36_FinalizeRequest)
; ARGS:
;   ?? (see UNKNOWN36_FinalizeRequest)
; RET:
;   ?? (see UNKNOWN36_FinalizeRequest)
; CLOBBERS:
;   ?? (see UNKNOWN36_FinalizeRequest)
; CALLS:
;   UNKNOWN36_FinalizeRequest
; DESC:
;   Jump stub to UNKNOWN36_FinalizeRequest.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_UNKNOWN36_FinalizeRequest:
LAB_1461:
    JMP     UNKNOWN36_FinalizeRequest

;------------------------------------------------------------------------------
; FUNC: JMPTBL_GCOMMAND_InitPresetTableFromPalette   (JumpStub_GCOMMAND_InitPresetTableFromPalette)
; ARGS:
;   ?? (see GCOMMAND_InitPresetTableFromPalette)
; RET:
;   ?? (see GCOMMAND_InitPresetTableFromPalette)
; CLOBBERS:
;   ?? (see GCOMMAND_InitPresetTableFromPalette)
; CALLS:
;   GCOMMAND_InitPresetTableFromPalette
; DESC:
;   Jump stub to GCOMMAND_InitPresetTableFromPalette.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_GCOMMAND_InitPresetTableFromPalette:
LAB_1462:
    JMP     GCOMMAND_InitPresetTableFromPalette

;------------------------------------------------------------------------------
; FUNC: JMPTBL_STRING_CompareNoCaseN   (JumpStub_STRING_CompareNoCaseN)
; ARGS:
;   ?? (see STRING_CompareNoCaseN)
; RET:
;   ?? (see STRING_CompareNoCaseN)
; CLOBBERS:
;   ?? (see STRING_CompareNoCaseN)
; CALLS:
;   STRING_CompareNoCaseN
; DESC:
;   Jump stub to STRING_CompareNoCaseN.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_STRING_CompareNoCaseN:
LAB_1463:
    JMP     STRING_CompareNoCaseN

;------------------------------------------------------------------------------
; FUNC: JMPTBL_STRING_AppendAtNull_3   (JumpStub_STRING_AppendAtNull)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   STRING_AppendAtNull
; DESC:
;   Jump stub to STRING_AppendAtNull.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_STRING_AppendAtNull_3:
    JMP     STRING_AppendAtNull

;------------------------------------------------------------------------------
; FUNC: JMPTBL_LAB_03AC   (JumpStub_LAB_03AC)
; ARGS:
;   ?? (see LAB_03AC)
; RET:
;   ?? (see LAB_03AC)
; CLOBBERS:
;   ?? (see LAB_03AC)
; CALLS:
;   LAB_03AC
; DESC:
;   Jump stub to LAB_03AC.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_LAB_03AC:
LAB_1465:
    JMP     LAB_03AC

;------------------------------------------------------------------------------
; FUNC: JMPTBL_ED1_WaitForFlagAndClearBit1   (JumpStub_ED1_WaitForFlagAndClearBit1)
; ARGS:
;   ?? (see ED1_WaitForFlagAndClearBit1)
; RET:
;   ?? (see ED1_WaitForFlagAndClearBit1)
; CLOBBERS:
;   ?? (see ED1_WaitForFlagAndClearBit1)
; CALLS:
;   ED1_WaitForFlagAndClearBit1
; DESC:
;   Jump stub to ED1_WaitForFlagAndClearBit1.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_ED1_WaitForFlagAndClearBit1:
LAB_1466:
    JMP     ED1_WaitForFlagAndClearBit1

;------------------------------------------------------------------------------
; FUNC: JMPTBL_PRINTF_4   (JumpStub_WDISP_SPrintf)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   WDISP_SPrintf
; DESC:
;   Jump stub to WDISP_SPrintf.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_PRINTF_4:
    JMP     WDISP_SPrintf

;------------------------------------------------------------------------------
; FUNC: GROUP_BA_JMPTBL_STREAM_ReadLineWithLimit   (JumpStub_STREAM_ReadLineWithLimit)
; ARGS:
;   ?? (see STREAM_ReadLineWithLimit)
; RET:
;   ?? (see STREAM_ReadLineWithLimit)
; CLOBBERS:
;   ?? (see STREAM_ReadLineWithLimit)
; CALLS:
;   STREAM_ReadLineWithLimit
; DESC:
;   Jump stub to STREAM_ReadLineWithLimit.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_BA_JMPTBL_STREAM_ReadLineWithLimit:
    JMP     STREAM_ReadLineWithLimit

;------------------------------------------------------------------------------
; FUNC: GROUP_BA_JMPTBL_UNKNOWN7_FindAnyCharWrapper   (JumpStub_UNKNOWN7_FindAnyCharWrapper)
; ARGS:
;   ?? (see UNKNOWN7_FindAnyCharWrapper)
; RET:
;   ?? (see UNKNOWN7_FindAnyCharWrapper)
; CLOBBERS:
;   ?? (see UNKNOWN7_FindAnyCharWrapper)
; CALLS:
;   UNKNOWN7_FindAnyCharWrapper
; DESC:
;   Jump stub to UNKNOWN7_FindAnyCharWrapper.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_BA_JMPTBL_UNKNOWN7_FindAnyCharWrapper:
    JMP     UNKNOWN7_FindAnyCharWrapper

;------------------------------------------------------------------------------
; FUNC: JMPTBL_ED1_ExitEscMenu   (JumpStub_ED1_ExitEscMenu)
; ARGS:
;   ?? (see ED1_ExitEscMenu)
; RET:
;   ?? (see ED1_ExitEscMenu)
; CLOBBERS:
;   ?? (see ED1_ExitEscMenu)
; CALLS:
;   ED1_ExitEscMenu
; DESC:
;   Jump stub to ED1_ExitEscMenu.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_ED1_ExitEscMenu:
    JMP     ED1_ExitEscMenu

;------------------------------------------------------------------------------
; FUNC: JMPTBL_LAB_0B44   (JumpStub_LAB_0B44)
; ARGS:
;   ?? (see LAB_0B44)
; RET:
;   ?? (see LAB_0B44)
; CLOBBERS:
;   ?? (see LAB_0B44)
; CALLS:
;   LAB_0B44
; DESC:
;   Jump stub to LAB_0B44.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_LAB_0B44:
LAB_146B:
    JMP     LAB_0B44

;------------------------------------------------------------------------------
; FUNC: JMPTBL_ED1_EnterEscMenu   (JumpStub_ED1_EnterEscMenu)
; ARGS:
;   ?? (see ED1_EnterEscMenu)
; RET:
;   ?? (see ED1_EnterEscMenu)
; CLOBBERS:
;   ?? (see ED1_EnterEscMenu)
; CALLS:
;   ED1_EnterEscMenu
; DESC:
;   Jump stub to ED1_EnterEscMenu.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_ED1_EnterEscMenu:
LAB_146C:
    JMP     ED1_EnterEscMenu

;------------------------------------------------------------------------------
; FUNC: JMPTBL_ESQFUNC_DrawEscMenuVersion   (JumpStub_ESQFUNC_DrawEscMenuVersion)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   ESQFUNC_DrawEscMenuVersion
; DESC:
;   Jump stub to ESQFUNC_DrawEscMenuVersion.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_ESQFUNC_DrawEscMenuVersion:
    JMP     ESQFUNC_DrawEscMenuVersion

    RTS

;!======

    ; Alignment
    ALIGN_WORD
