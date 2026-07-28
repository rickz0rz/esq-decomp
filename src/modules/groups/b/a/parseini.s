    XDEF    _PARSEINI_ParseIniBufferAndDispatch



;------------------------------------------------------------------------------
; FUNC: _PARSEINI_ParseIniBufferAndDispatch   (Parse INI-like buffer; dispatch by sectionuncertain)
; ARGS:
;   stack +8: A3 = pointer to buffer/string to parse
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer, PARSEINI_JMPTBL_DISKIO_ConsumeLineFromWorkBuffer, _PARSEINI_JMPTBL_STR_FindCharPtr, PARSEINI_JMPTBL_GCOMMAND_InitPresetTableFromPalette, _PARSEINI_JMPTBL_STRING_CompareNoCase, TEXTDISP_ClearSourceConfig, PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString,
;   PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator, PARSEINI_JMPTBL_HANDLE_OpenWithMode, PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad, PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey, PARSEINI_ProcessWeatherBlocks/_PARSEINI_LoadWeatherStrings/PARSEINI_LoadWeatherMessageStrings/_PARSEINI_ParseColorTable helpers
; READS:
;   _Global_PTR_WORK_BUFFER, _WDISP_CharClassTable (char class table), many LAB_205* globals, _PARSEINI_ParsedDescriptorListHead, PARSEINI_CurrentWeatherBlockPtr
; WRITES:
;   _P_TYPE_WeatherBrushRefreshPendingFlag-2064/206A..., _TEXTDISP_AliasCount, PARSEINI_CurrentWeatherBlockTempPtr, PARSEINI_CurrentWeatherBlockPtr, _PARSEINI_CurrentRangeTableIndex, _P_TYPE_WeatherCurrentMsgPtr-C, etc.
; DESC:
;   Top-level INI parser: scans the buffer, skips whitespace/comment chars, detects
;   section headers and key/value pairs, and dispatches to per-section handlers.
; NOTES:
;   Uses BRACKETED sections '['...']', lower-level helpers validate/allocate strings.
;------------------------------------------------------------------------------
_PARSEINI_ParseIniBufferAndDispatch:
    LINK.W  A5,#-44
    MOVEM.L D5-D7/A2-A3,-(A7)

    MOVEA.L 8(A5),A3

    MOVEQ   #0,D7
    MOVEQ   #-1,D5
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BNE.S   .init_parser_state

    MOVEQ   #-1,D0
    BRA.W   .return

.init_parser_state:
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D6
    MOVE.L  _Global_PTR_WORK_BUFFER,-16(A5)

.next_line:
    JSR     PARSEINI_JMPTBL_DISKIO_ConsumeLineFromWorkBuffer(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-8(A5)
    CMP.L   A0,D0
    BEQ.W   .cleanup_and_free

.skip_leading_ws:
    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.B  (A0),D0
    LEA     _WDISP_CharClassTable,A1
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
    JSR     _PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-28(A5)
    TST.L   D0
    BEQ.S   .next_line

    MOVEA.L D0,A0
    CLR.B   (A0)
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     P_TYPE_STR_QTABLE
    MOVE.L  A0,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_section_2

    MOVEQ   #1,D7
    BRA.S   .next_line

.check_section_2:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     P_TYPE_TAG_BACKDROP
    MOVE.L  A0,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_section_3

    MOVEQ   #2,D7
    BRA.W   .next_line

.check_section_3:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     P_TYPE_TAG_GRADIENT
    MOVE.L  A0,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_section_4

    MOVEQ   #3,D7
    ; [gradient] seeds/edits the dedicated gradient staging table.
    ; This path does not directly target GCOMMAND_PresetValueTable.
    PEA     GCOMMAND_GradientPresetTable
    JSR     PARSEINI_JMPTBL_GCOMMAND_InitPresetTableFromPalette(PC)

    ADDQ.W  #4,A7
    BRA.W   .next_line

.check_section_4:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     P_TYPE_TAG_TEXTADS
    MOVE.L  A0,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_section_5

    MOVEQ   #4,D7
    BRA.W   .next_line

.check_section_5:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     P_TYPE_TAG_BRUSH
    MOVE.L  A0,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_section_6

    MOVEQ   #5,D7
    BRA.W   .next_line

.check_section_6:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     P_TYPE_TAG_BANNER
    MOVE.L  A0,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_section_7

    MOVEQ   #6,D7
    CLR.L   _P_TYPE_WeatherBrushRefreshPendingFlag
    BRA.W   .next_line

.check_section_7:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     P_TYPE_STR_DEFAULT_TEXT
    MOVE.L  A0,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_section_8

    MOVEQ   #7,D7
    MOVE.L  _P_TYPE_WeatherCurrentMsgPtr,-(A7)
    MOVE.L  _Global_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE,-(A7)
    JSR     PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,_P_TYPE_WeatherCurrentMsgPtr
    MOVE.L  _P_TYPE_WeatherForecastMsgPtr,(A7)
    MOVE.L  SCRIPT_PtrNoForecastWeatherData,-(A7)
    JSR     PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,_P_TYPE_WeatherForecastMsgPtr
    MOVE.L  P_TYPE_WeatherBottomLineMsgPtr,(A7)
    MOVE.L  SCRIPT_PtrWeatherDataAvailabilityDisclaimer,-(A7)
    JSR     PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     16(A7),A7
    MOVE.L  D0,P_TYPE_WeatherBottomLineMsgPtr
    BRA.W   .next_line

.check_section_8:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     P_TYPE_STR_SOURCE_CONFIG
    MOVE.L  A0,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

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
    JSR     _PARSEINI_JMPTBL_STR_FindCharPtr(PC)

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
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section1_cut_marker

    ADDQ.L  #1,-32(A5)
    BRA.S   .section1_skip_value_ws

.section1_cut_marker:
    PEA     PARSEINI_DelimSpaceTab_Section1
    MOVE.L  -8(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindAnyCharPtr(PC)

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
    LEA     _WDISP_CharClassTable,A1
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
    LEA     _TEXTDISP_AliasPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     8.W
    PEA     219.W
    PEA     Global_STR_PARSEINI_C_1
    MOVE.L  A0,36(A7)
    JSR     _SCRIPT_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVEA.L 36(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_AliasPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    SUBA.L  A0,A0
    MOVE.L  A0,(A2)
    MOVE.L  A0,4(A2)
    MOVE.L  (A2),(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,(A2)
    PEA     34.W
    MOVE.L  -32(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    LEA     28(A7),A7
    MOVE.L  D0,-40(A5)
    TST.L   D0
    BNE.S   .section1_after_first_quote

    CLR.W   _TEXTDISP_AliasCount
    MOVEQ   #0,D0
    BRA.W   .return

.section1_after_first_quote:
    MOVEA.L D0,A0
    ADDQ.L  #1,A0
    MOVE.L  A0,-32(A5)
    PEA     34.W
    MOVE.L  -32(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-40(A5)
    TST.L   D0
    BNE.S   .section1_store_second_string

    CLR.W   _TEXTDISP_AliasCount

    MOVEQ   #0,D0
    BRA.W   .return

.section1_store_second_string:
    MOVEA.L D0,A0
    CLR.B   (A0)
    MOVE.L  4(A2),-(A7)
    MOVE.L  -32(A5),-(A7)
    JSR     PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,4(A2)
    MOVE.L  D5,D0
    ADDQ.L  #1,D0
    MOVE.W  D0,_TEXTDISP_AliasCount
    BRA.W   .next_line

.section1_reset_count:
    CLR.W   _TEXTDISP_AliasCount
    BRA.W   .next_line

.section2_parse_line:
    PEA     61.W
    MOVE.L  -8(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindCharPtr(PC)

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
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section2_cut_marker

    ADDQ.L  #1,-32(A5)
    BRA.S   .section2_skip_value_ws

.section2_cut_marker:
    PEA     PARSEINI_DelimSpaceTab_Section2
    MOVE.L  -8(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindAnyCharPtr(PC)

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
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section2_dispatch_keyvalue

    CLR.B   (A0)
    SUBQ.L  #1,-36(A5)
    BRA.S   .section2_trim_value_end

.section2_dispatch_keyvalue:
    MOVE.L  -32(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    BSR.W   PARSEINI_ProcessWeatherBlocks

    ADDQ.W  #8,A7
    BRA.W   .next_line

.section3_parse_range:
    ; Parse "COLORx"/"TABLE"/range assignments into GCOMMAND_GradientPresetTable.
    PEA     GCOMMAND_GradientPresetTable
    MOVE.L  -8(A5),-(A7)
    BSR.W   _PARSEINI_ParseRangeKeyValue

    ADDQ.W  #8,A7
    BRA.W   .next_line

.section4_5_parse_line:
    PEA     61.W
    MOVE.L  -8(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindCharPtr(PC)

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
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section4_5_cut_marker

    ADDQ.L  #1,-32(A5)
    BRA.S   .section4_5_skip_value_ws

.section4_5_cut_marker:
    PEA     PARSEINI_DelimSpaceTab_Section4_5
    MOVE.L  -8(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindAnyCharPtr(PC)

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
    LEA     _WDISP_CharClassTable,A1
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
    BSR.W   _PARSEINI_ParseColorTable

    LEA     12(A7),A7
    BRA.W   .next_line

.section6_parse_line:
    PEA     61.W
    MOVE.L  -8(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindCharPtr(PC)

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
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section6_cut_marker

    ADDQ.L  #1,-32(A5)
    BRA.S   .section6_skip_value_ws

.section6_cut_marker:
    PEA     PARSEINI_DelimSpaceTab_Section6
    MOVE.L  -8(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindAnyCharPtr(PC)

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
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section6_dispatch

    CLR.B   (A0)
    SUBQ.L  #1,-36(A5)
    BRA.S   .section6_trim_value_end

.section6_dispatch:
    MOVE.L  -32(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    BSR.W   _PARSEINI_LoadWeatherStrings

    ADDQ.W  #8,A7
    BRA.W   .next_line

.section7_parse_line:
    PEA     61.W
    MOVE.L  -8(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindCharPtr(PC)

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
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section7_cut_marker

    ADDQ.L  #1,-32(A5)
    BRA.S   .section7_skip_value_ws

.section7_cut_marker:
    PEA     PARSEINI_DelimSpaceTab_Section7
    MOVE.L  -8(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindAnyCharPtr(PC)

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
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section7_dispatch

    CLR.B   (A0)
    SUBQ.L  #1,-36(A5)
    BRA.S   .section7_trim_value_end

.section7_dispatch:
    MOVE.L  -32(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    BSR.W   PARSEINI_LoadWeatherMessageStrings

    ADDQ.W  #8,A7
    BRA.W   .next_line

.section8_parse_line:
    PEA     61.W
    MOVE.L  -8(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindCharPtr(PC)

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
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section8_cut_marker

    ADDQ.L  #1,-32(A5)
    BRA.S   .section8_skip_value_ws

.section8_cut_marker:
    PEA     PARSEINI_DelimSpaceTab_Section8
    MOVE.L  -8(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindAnyCharPtr(PC)

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
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section8_dispatch

    CLR.B   (A0)
    SUBQ.L  #1,-36(A5)
    BRA.S   .section8_trim_value_end

.section8_dispatch:
    MOVE.L  -32(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     _TEXTDISP_AddSourceConfigEntry(PC)

    ADDQ.W  #8,A7
    BRA.W   .next_line

.cleanup_and_free:
    MOVE.L  D6,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     403.W
    PEA     Global_STR_PARSEINI_C_2
    JSR     _SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

.return:
    MOVEM.L -64(A5),D5-D7/A2-A3
    UNLK    A5
    RTS

;!======