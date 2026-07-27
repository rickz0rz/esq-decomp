    XDEF    PARSEINI_ParseHexValueFromString
    XDEF    PARSEINI_ParseIniBufferAndDispatch
    XDEF    PARSEINI_ParseRangeKeyValue
    XDEF    PARSEINI_ProcessWeatherBlocks


;------------------------------------------------------------------------------
; FUNC: PARSEINI_ParseIniBufferAndDispatch   (Parse INI-like buffer; dispatch by sectionuncertain)
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
;   _P_TYPE_WeatherBrushRefreshPendingFlag-2064/206A..., _TEXTDISP_AliasCount, PARSEINI_CurrentWeatherBlockTempPtr, PARSEINI_CurrentWeatherBlockPtr, PARSEINI_CurrentRangeTableIndex, P_TYPE_WeatherCurrentMsgPtr-C, etc.
; DESC:
;   Top-level INI parser: scans the buffer, skips whitespace/comment chars, detects
;   section headers and key/value pairs, and dispatches to per-section handlers.
; NOTES:
;   Uses BRACKETED sections '['...']', lower-level helpers validate/allocate strings.
;------------------------------------------------------------------------------
PARSEINI_ParseIniBufferAndDispatch:
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
    MOVE.L  P_TYPE_WeatherCurrentMsgPtr,-(A7)
    MOVE.L  Global_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE,-(A7)
    JSR     PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,P_TYPE_WeatherCurrentMsgPtr
    MOVE.L  P_TYPE_WeatherForecastMsgPtr,(A7)
    MOVE.L  SCRIPT_PtrNoForecastWeatherData,-(A7)
    JSR     PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,P_TYPE_WeatherForecastMsgPtr
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
    JSR     PARSEINI_JMPTBL_STR_FindAnyCharPtr(PC)

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
    JSR     PARSEINI_JMPTBL_STR_FindAnyCharPtr(PC)

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
    BSR.W   PARSEINI_ParseRangeKeyValue

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
    JSR     PARSEINI_JMPTBL_STR_FindAnyCharPtr(PC)

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
    JSR     PARSEINI_JMPTBL_STR_FindAnyCharPtr(PC)

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
    JSR     PARSEINI_JMPTBL_STR_FindAnyCharPtr(PC)

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
    JSR     PARSEINI_JMPTBL_STR_FindAnyCharPtr(PC)

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

;------------------------------------------------------------------------------
; FUNC: PARSEINI_ParseHexValueFromString   (ParseHexValueFromStringuncertain)
; ARGS:
;   stack +8: A3 = pointer to hex string
; RET:
;   D0: parsed value
; CLOBBERS:
;   D0-D1/D7/A0/A3
; CALLS:
;   _SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit
; READS:
;   _WDISP_CharClassTable (char class table)
; WRITES:
;   (none)
; DESC:
;   Parses consecutive hex characters into a 32-bit value until a non-hex.
; NOTES:
;   Treats each nibble as upper-case hex via _LADFUNC_ParseHexDigit.
;------------------------------------------------------------------------------
PARSEINI_ParseHexValueFromString:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7

.loop_13D5:
    MOVE.L  A3,D0
    BEQ.S   .return_13D6

    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    LEA     _WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .return_13D6

    ASL.L   #4,D7
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     _SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    ADD.L   D1,D7
    ADDQ.L  #1,A3
    BRA.S   .loop_13D5

.return_13D6:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_ParseRangeKeyValue   (Routine at PARSEINI_ParseRangeKeyValue)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A3/A5/A7/D0/D1/D6/D7
; CALLS:
;   _NEWGRID2_JMPTBL_STR_SkipClass3Chars, PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable, PARSEINI_JMPTBL_STRING_CompareNoCaseN, PARSEINI_JMPTBL_STR_FindAnyCharPtr, _PARSEINI_JMPTBL_STR_FindCharPtr, PARSEINI_ParseHexValueFromString, SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt
; READS:
;   PARSEINI_CurrentRangeTableIndex, PARSEINI_DelimSpaceTab_RangeKey, PARSEINI_DelimSpaceSemicolonTab_RangeValue, PARSEINI_TAG_TABLE, PARSEINI_TAG_DONE, PARSEINI_TAG_COLOR, handle_range_assign, return
; WRITES:
;   PARSEINI_CurrentRangeTableIndex
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
PARSEINI_ParseRangeKeyValue:
    LINK.W  A5,#-16
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEA.L A3,A0
    MOVE.L  A0,-4(A5)
    BEQ.S   .no_source_ptr

    PEA     61.W
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVEA.L D0,A0
    BRA.S   .after_find_equals

.no_source_ptr:
    SUBA.L  A0,A0

.after_find_equals:
    MOVE.L  A0,-8(A5)
    TST.L   -4(A5)
    BEQ.S   .term_value_token

    MOVE.L  A0,D0
    BEQ.S   .term_value_token

    MOVE.L  -4(A5),-(A7)
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    PEA     PARSEINI_DelimSpaceTab_RangeKey
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     PARSEINI_JMPTBL_STR_FindAnyCharPtr(PC)

    LEA     12(A7),A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BEQ.S   .term_key_token

    MOVEQ   #0,D0
    MOVE.B  D0,(A3)

.term_key_token:
    MOVEA.L -8(A5),A0
    CLR.B   (A0)+
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-8(A5)
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    PEA     PARSEINI_DelimSpaceSemicolonTab_RangeValue
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-8(A5)
    JSR     PARSEINI_JMPTBL_STR_FindAnyCharPtr(PC)

    LEA     12(A7),A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BEQ.S   .term_value_token

    CLR.B   (A3)

.term_value_token:
    TST.L   -4(A5)
    BEQ.W   .return

    TST.L   -8(A5)
    BEQ.W   .return

    PEA     5.W
    PEA     PARSEINI_TAG_TABLE
    MOVE.L  -4(A5),-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .handle_non_preset_keys

    PEA     4.W
    PEA     PARSEINI_TAG_DONE
    MOVE.L  -8(A5),-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .handle_non_preset_keys

    MOVE.L  A2,-(A7)
    JSR     PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable(PC)

    ADDQ.W  #4,A7
    MOVEQ   #-1,D0
    MOVE.L  D0,PARSEINI_CurrentRangeTableIndex
    BRA.W   .return

.handle_non_preset_keys:
    PEA     5.W
    PEA     PARSEINI_TAG_COLOR
    MOVE.L  -4(A5),-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.W   .handle_range_assign

    MOVEA.L -4(A5),A0
    ADDQ.L  #5,A0
    MOVEQ   #0,D7
    MOVE.L  A0,-12(A5)
    MOVE.L  A0,D0
    BEQ.S   .parse_index_optional_done

    TST.B   (A0)
    BEQ.S   .parse_index_optional_done

    MOVE.L  A0,-(A7)
    JSR     SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7

.parse_index_optional_done:
    TST.W   D7
    BMI.S   .invalid_index

    MOVEQ   #16,D0
    CMP.W   D0,D7
    BLT.S   .store_index

.invalid_index:
    MOVEQ   #-1,D0
    MOVE.L  D0,PARSEINI_CurrentRangeTableIndex
    BRA.S   .after_index_store

.store_index:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,PARSEINI_CurrentRangeTableIndex
    ADD.L   D0,D0
    CLR.W   0(A2,D0.L)

.after_index_store:
    MOVE.L  PARSEINI_CurrentRangeTableIndex,D0
    TST.L   D0
    BMI.W   .return

    MOVEQ   #16,D1
    CMP.L   D1,D0
    BGE.W   .return

    MOVE.L  -8(A5),-(A7)
    JSR     SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D6
    MOVEQ   #1,D0
    CMP.W   D0,D6
    BLT.S   .value_too_small

    MOVEQ   #63,D1
    CMP.W   D1,D6
    BLE.S   .value_in_range

.value_too_small:
    MOVEQ   #-1,D6
    BRA.S   .after_value_adjust

.value_in_range:
    ADDQ.W  #1,D6

.after_value_adjust:
    MOVE.L  PARSEINI_CurrentRangeTableIndex,D0
    MOVE.L  D0,D1
    ADD.L   D1,D1
    MOVE.W  D6,0(A2,D1.L)
    BRA.S   .return

.handle_range_assign:
    MOVE.L  PARSEINI_CurrentRangeTableIndex,D0
    TST.L   D0
    BMI.S   .return

    MOVEQ   #16,D1
    CMP.L   D1,D0
    BGE.S   .return

    ADD.L   D0,D0
    MOVE.W  0(A2,D0.L),D1
    TST.W   D1
    BLE.S   .return

    MOVE.L  -4(A5),-(A7)
    JSR     SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    MOVE.L  D0,D7
    MOVE.L  -8(A5),(A7)
    BSR.W   PARSEINI_ParseHexValueFromString

    ADDQ.W  #4,A7
    MOVE.L  D0,D6
    TST.W   D7
    BLE.S   .return

    MOVE.L  PARSEINI_CurrentRangeTableIndex,D0
    MOVE.L  D0,D1
    ADD.L   D1,D1
    CMP.W   0(A2,D1.L),D7
    BGE.S   .return

    TST.W   D6
    BMI.S   .return

    CMPI.W  #$1000,D6
    BGE.S   .return

    ASL.L   #7,D0
    MOVEA.L A2,A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    EXT.L   D0
    ADD.L   D0,D0
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    MOVE.W  D0,32(A0)

.return:
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_ProcessWeatherBlocks   (Routine at PARSEINI_ProcessWeatherBlocks)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D7
; CALLS:
;   _PARSEINI_JMPTBL_BRUSH_AllocBrushNode, _PARSEINI_JMPTBL_STRING_CompareNoCase, SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, SCRIPT3_JMPTBL_STRING_CopyPadNul, _SCRIPT_JMPTBL_MEMORY_AllocateMemory
; READS:
;   Global_STR_PARSEINI_C_3, _PARSEINI_ParsedDescriptorListHead, PARSEINI_CurrentWeatherBlockTempPtr, PARSEINI_TAG_FILENAME_WeatherBlock, PARSEINI_STR_LOADCOLOR, PARSEINI_TAG_ALL, PARSEINI_TAG_NONE, PARSEINI_TAG_TEXT, PARSEINI_TAG_XPOS, PARSEINI_TAG_TYPE, PARSEINI_TAG_DITHER, PARSEINI_TAG_YPOS, PARSEINI_TAG_XSOURCE, PARSEINI_TAG_YSOURCE, PARSEINI_TAG_SIZEX, PARSEINI_TAG_SIZEY, PARSEINI_TAG_SOURCE, PARSEINI_TAG_PPV, PARSEINI_STR_HORIZONTAL, PARSEINI_TAG_RIGHT, PARSEINI_TAG_CENTER_HorizontalAlign, PARSEINI_TAG_VERTICAL, PARSEINI_TAG_BOTTOM, PARSEINI_TAG_CENTER_VerticalAlign, PARSEINI_TAG_ID, PARSEINI_CurrentWeatherBlockPtr, MEMF_CLEAR, MEMF_PUBLIC, check_key_2084, return
; WRITES:
;   _PARSEINI_ParsedDescriptorListHead, PARSEINI_CurrentWeatherBlockTempPtr, PARSEINI_CurrentWeatherBlockPtr
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
PARSEINI_ProcessWeatherBlocks:
    LINK.W  A5,#-8
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    SUBA.L  A0,A0
    MOVE.L  A0,-8(A5)
    TST.L   _PARSEINI_ParsedDescriptorListHead
    BNE.S   .after_init_state

    MOVE.L  A0,PARSEINI_CurrentWeatherBlockTempPtr
    MOVE.L  A0,PARSEINI_CurrentWeatherBlockPtr

.after_init_state:
    PEA     PARSEINI_TAG_FILENAME_WeatherBlock
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_2075

    CLR.L   PARSEINI_CurrentWeatherBlockTempPtr
    MOVE.L  PARSEINI_CurrentWeatherBlockPtr,-(A7)
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_BRUSH_AllocBrushNode(PC)

    ADDQ.W  #8,A7
    MOVEA.L D0,A0
    MOVE.B  #$1,190(A0)
    MOVE.L  D0,PARSEINI_CurrentWeatherBlockPtr
    TST.L   _PARSEINI_ParsedDescriptorListHead
    BNE.S   .check_key_2075

    MOVE.L  D0,_PARSEINI_ParsedDescriptorListHead

.check_key_2075:
    TST.L   PARSEINI_CurrentWeatherBlockPtr
    BEQ.W   .return

    PEA     PARSEINI_STR_LOADCOLOR
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_2079

    PEA     PARSEINI_TAG_ALL
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_mode_2077

    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    CLR.L   194(A0)
    BRA.W   .return

.check_mode_2077:
    PEA     PARSEINI_TAG_NONE
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_mode_2078

    MOVEQ   #2,D0
    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D0,194(A0)
    BRA.W   .return

.check_mode_2078:
    PEA     PARSEINI_TAG_TEXT
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .set_default_mode_194

    MOVEQ   #3,D0
    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D0,194(A0)
    BRA.W   .return

.set_default_mode_194:
    MOVEQ   #1,D0
    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D0,194(A0)
    BRA.W   .return

.check_key_2079:
    PEA     PARSEINI_TAG_XPOS
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_207A

    MOVE.L  A2,-(A7)
    JSR     SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D7,198(A0)
    BRA.W   .return

.check_key_207A:
    PEA     PARSEINI_TAG_TYPE
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_207C

    PEA     PARSEINI_TAG_DITHER
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.W   .return

    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.B  #$2,190(A0)
    BRA.W   .return

.check_key_207C:
    PEA     PARSEINI_TAG_YPOS
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_207D

    MOVE.L  A2,-(A7)
    JSR     SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D7,202(A0)
    BRA.W   .return

.check_key_207D:
    PEA     PARSEINI_TAG_XSOURCE
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_207E

    MOVE.L  A2,-(A7)
    JSR     SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D7,206(A0)
    BRA.W   .return

.check_key_207E:
    PEA     PARSEINI_TAG_YSOURCE
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_207F

    MOVE.L  A2,-(A7)
    JSR     SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D7,210(A0)
    BRA.W   .return

.check_key_207F:
    PEA     PARSEINI_TAG_SIZEX
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_2080

    MOVE.L  A2,-(A7)
    JSR     SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D7,214(A0)
    BRA.W   .return

.check_key_2080:
    PEA     PARSEINI_TAG_SIZEY
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_2081

    MOVE.L  A2,-(A7)
    JSR     SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D7,218(A0)
    BRA.W   .return

.check_key_2081:
    PEA     PARSEINI_TAG_SOURCE
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.W   .check_key_2084

    MOVEA.L A2,A0

.scan_key_length:
    TST.B   (A0)+
    BNE.S   .scan_key_length

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,D0
    TST.L   D0
    BLE.W   .check_key_2084

    PEA     PARSEINI_TAG_PPV
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .alloc_weather_node

    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.B  #$3,190(A0)
    BRA.W   .return

.alloc_weather_node:
    MOVE.L  PARSEINI_CurrentWeatherBlockTempPtr,-8(A5)
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     12.W
    PEA     670.W
    PEA     Global_STR_PARSEINI_C_3
    JSR     _SCRIPT_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,PARSEINI_CurrentWeatherBlockTempPtr
    TST.L   D0
    BEQ.W   .return

    MOVEA.L D0,A0
    CLR.L   8(A0)
    MOVEA.L A2,A0
    MOVEA.L D0,A1

.copy_node_label:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_node_label

    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    TST.L   230(A0)
    BNE.S   .append_node_link

    MOVEA.L PARSEINI_CurrentWeatherBlockTempPtr,A1
    MOVE.L  A1,230(A0)
    BRA.W   .return

.append_node_link:
    MOVEA.L -8(A5),A1
    MOVE.L  PARSEINI_CurrentWeatherBlockTempPtr,8(A1)
    BRA.W   .return

.check_key_2084:
    PEA     PARSEINI_STR_HORIZONTAL
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_2087

    PEA     PARSEINI_TAG_RIGHT
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_mode_2086

    MOVEQ   #2,D0
    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D0,222(A0)
    BRA.W   .return

.check_mode_2086:
    PEA     PARSEINI_TAG_CENTER_HorizontalAlign
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .set_mode_222_default

    MOVEQ   #1,D0
    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D0,222(A0)
    BRA.W   .return

.set_mode_222_default:
    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    CLR.L   222(A0)
    BRA.W   .return

.check_key_2087:
    PEA     PARSEINI_TAG_VERTICAL
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_208A

    PEA     PARSEINI_TAG_BOTTOM
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_mode_2089

    MOVEQ   #2,D0
    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D0,226(A0)
    BRA.S   .return

.check_mode_2089:
    PEA     PARSEINI_TAG_CENTER_VerticalAlign
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .set_mode_226_default

    MOVEQ   #1,D0
    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D0,226(A0)
    BRA.S   .return

.set_mode_226_default:
    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    CLR.L   226(A0)
    BRA.S   .return

.check_key_208A:
    PEA     PARSEINI_TAG_ID
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .return

    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    ADDA.W  #191,A0
    PEA     2.W
    MOVE.L  A2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     SCRIPT3_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    CLR.B   193(A0)

.return:
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======