    XDEF    PARSEINI_HandleFontCommand
    XDEF    PARSEINI_LoadWeatherMessageStrings
    XDEF    PARSEINI_LoadWeatherStrings
    XDEF    PARSEINI_ParseColorTable
    XDEF    PARSEINI_ParseHexValueFromString
    XDEF    PARSEINI_ParseIniBufferAndDispatch
    XDEF    PARSEINI_ParseRangeKeyValue
    XDEF    PARSEINI_ProcessWeatherBlocks
    XDEF    PARSEINI_ScanLogoDirectory
    XDEF    PARSEINI_TestMemoryAndOpenTopazFont
    XDEF    PARSEINI_JMPTBL_BRUSH_AllocBrushNode
    XDEF    PARSEINI_JMPTBL_BRUSH_FreeBrushList
    XDEF    PARSEINI_JMPTBL_BRUSH_FreeBrushResources
    XDEF    PARSEINI_JMPTBL_DISKIO2_ParseIniFileFromDisk
    XDEF    PARSEINI_JMPTBL_DISKIO_ConsumeLineFromWorkBuffer
    XDEF    PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer
    XDEF    PARSEINI_JMPTBL_ED1_DrawDiagnosticsScreen
    XDEF    PARSEINI_JMPTBL_ED1_EnterEscMenu
    XDEF    PARSEINI_JMPTBL_ED1_ExitEscMenu
    XDEF    PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit0
    XDEF    PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit1
    XDEF    PARSEINI_JMPTBL_ESQFUNC_DrawEscMenuVersion
    XDEF    PARSEINI_JMPTBL_ESQFUNC_RebuildPwBrushListFromTagTableFromTagTable
    XDEF    PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey
    XDEF    PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad
    XDEF    PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString
    XDEF    PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator
    XDEF    PARSEINI_JMPTBL_GCOMMAND_InitPresetTableFromPalette
    XDEF    PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable
    XDEF    PARSEINI_JMPTBL_HANDLE_OpenWithMode
    XDEF    PARSEINI_JMPTBL_STREAM_ReadLineWithLimit
    XDEF    PARSEINI_JMPTBL_STRING_AppendAtNull
    XDEF    PARSEINI_JMPTBL_STRING_CompareNoCase
    XDEF    PARSEINI_JMPTBL_STRING_CompareNoCaseN
    XDEF    PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest
    XDEF    PARSEINI_JMPTBL_STR_FindAnyCharPtr
    XDEF    PARSEINI_JMPTBL_STR_FindCharPtr
    XDEF    PARSEINI_JMPTBL_WDISP_SPrintf

;------------------------------------------------------------------------------
; FUNC: PARSEINI_ParseIniBufferAndDispatch   (Parse INI-like buffer; dispatch by sectionuncertain)
; ARGS:
;   stack +8: A3 = pointer to buffer/string to parse
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer, PARSEINI_JMPTBL_DISKIO_ConsumeLineFromWorkBuffer, PARSEINI_JMPTBL_STR_FindCharPtr, PARSEINI_JMPTBL_GCOMMAND_InitPresetTableFromPalette, PARSEINI_JMPTBL_STRING_CompareNoCase, TEXTDISP_ClearSourceConfig, PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString,
;   PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator, PARSEINI_JMPTBL_HANDLE_OpenWithMode, PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad, PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey, PARSEINI_ProcessWeatherBlocks/PARSEINI_LoadWeatherStrings/PARSEINI_LoadWeatherMessageStrings/PARSEINI_ParseColorTable helpers
; READS:
;   Global_PTR_WORK_BUFFER, WDISP_CharClassTable (char class table), many LAB_205* globals, PARSEINI_ParsedDescriptorListHead, PARSEINI_CurrentWeatherBlockPtr
; WRITES:
;   DATA_P_TYPE_BSS_LONG_2059-2064/206A..., TEXTDISP_AliasCount, DATA_PARSEINI_BSS_LONG_2073, PARSEINI_CurrentWeatherBlockPtr, PARSEINI_CurrentRangeTableIndex, DATA_P_TYPE_BSS_LONG_205A-C, etc.
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
    MOVE.L  Global_REF_LONG_FILE_SCRATCH,D6
    MOVE.L  Global_PTR_WORK_BUFFER,-16(A5)

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
    LEA     WDISP_CharClassTable,A1
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
    JSR     PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-28(A5)
    TST.L   D0
    BEQ.S   .next_line

    MOVEA.L D0,A0
    CLR.B   (A0)
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     DATA_P_TYPE_STR_QTABLE_205D
    MOVE.L  A0,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_section_2

    MOVEQ   #1,D7
    BRA.S   .next_line

.check_section_2:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     DATA_P_TYPE_TAG_BACKDROP_205E
    MOVE.L  A0,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_section_3

    MOVEQ   #2,D7
    BRA.W   .next_line

.check_section_3:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     DATA_P_TYPE_TAG_GRADIENT_205F
    MOVE.L  A0,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_section_4

    MOVEQ   #3,D7
    PEA     GCOMMAND_GradientPresetTable
    JSR     PARSEINI_JMPTBL_GCOMMAND_InitPresetTableFromPalette(PC)

    ADDQ.W  #4,A7
    BRA.W   .next_line

.check_section_4:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     DATA_P_TYPE_TAG_TEXTADS_2060
    MOVE.L  A0,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_section_5

    MOVEQ   #4,D7
    BRA.W   .next_line

.check_section_5:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     DATA_P_TYPE_TAG_BRUSH_2061
    MOVE.L  A0,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_section_6

    MOVEQ   #5,D7
    BRA.W   .next_line

.check_section_6:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     DATA_P_TYPE_TAG_BANNER_2062
    MOVE.L  A0,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_section_7

    MOVEQ   #6,D7
    CLR.L   DATA_P_TYPE_BSS_LONG_2059
    BRA.W   .next_line

.check_section_7:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     DATA_P_TYPE_STR_DEFAULT_TEXT_2063
    MOVE.L  A0,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_section_8

    MOVEQ   #7,D7
    MOVE.L  DATA_P_TYPE_BSS_LONG_205A,-(A7)
    MOVE.L  Global_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE,-(A7)
    JSR     PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,DATA_P_TYPE_BSS_LONG_205A
    MOVE.L  DATA_P_TYPE_BSS_LONG_205B,(A7)
    MOVE.L  DATA_SCRIPT_CONST_LONG_20B0,-(A7)
    JSR     PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,DATA_P_TYPE_BSS_LONG_205B
    MOVE.L  DATA_P_TYPE_BSS_LONG_205C,(A7)
    MOVE.L  DATA_SCRIPT_CONST_LONG_20B2,-(A7)
    JSR     PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     16(A7),A7
    MOVE.L  D0,DATA_P_TYPE_BSS_LONG_205C
    BRA.W   .next_line

.check_section_8:
    MOVEA.L -8(A5),A0
    ADDQ.L  #1,A0
    PEA     DATA_P_TYPE_STR_SOURCE_CONFIG_2064
    MOVE.L  A0,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

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
    JSR     PARSEINI_JMPTBL_STR_FindCharPtr(PC)

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
    LEA     WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section1_cut_marker

    ADDQ.L  #1,-32(A5)
    BRA.S   .section1_skip_value_ws

.section1_cut_marker:
    PEA     DATA_P_TYPE_SPACE_VALUE_2065
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
    LEA     WDISP_CharClassTable,A1
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
    LEA     TEXTDISP_AliasPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     8.W
    PEA     219.W
    PEA     Global_STR_PARSEINI_C_1
    MOVE.L  A0,36(A7)
    JSR     SCRIPT_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVEA.L 36(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_AliasPtrTable,A0
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
    JSR     PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    LEA     28(A7),A7
    MOVE.L  D0,-40(A5)
    TST.L   D0
    BNE.S   .section1_after_first_quote

    CLR.W   TEXTDISP_AliasCount
    MOVEQ   #0,D0
    BRA.W   .return

.section1_after_first_quote:
    MOVEA.L D0,A0
    ADDQ.L  #1,A0
    MOVE.L  A0,-32(A5)
    PEA     34.W
    MOVE.L  -32(A5),-(A7)
    JSR     PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-40(A5)
    TST.L   D0
    BNE.S   .section1_store_second_string

    CLR.W   TEXTDISP_AliasCount

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
    MOVE.W  D0,TEXTDISP_AliasCount
    BRA.W   .next_line

.section1_reset_count:
    CLR.W   TEXTDISP_AliasCount
    BRA.W   .next_line

.section2_parse_line:
    PEA     61.W
    MOVE.L  -8(A5),-(A7)
    JSR     PARSEINI_JMPTBL_STR_FindCharPtr(PC)

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
    LEA     WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section2_cut_marker

    ADDQ.L  #1,-32(A5)
    BRA.S   .section2_skip_value_ws

.section2_cut_marker:
    PEA     DATA_PARSEINI_SPACE_VALUE_2067
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
    LEA     WDISP_CharClassTable,A1
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
    PEA     GCOMMAND_GradientPresetTable
    MOVE.L  -8(A5),-(A7)
    BSR.W   PARSEINI_ParseRangeKeyValue

    ADDQ.W  #8,A7
    BRA.W   .next_line

.section4_5_parse_line:
    PEA     61.W
    MOVE.L  -8(A5),-(A7)
    JSR     PARSEINI_JMPTBL_STR_FindCharPtr(PC)

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
    LEA     WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section4_5_cut_marker

    ADDQ.L  #1,-32(A5)
    BRA.S   .section4_5_skip_value_ws

.section4_5_cut_marker:
    PEA     DATA_PARSEINI_SPACE_VALUE_2068
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
    LEA     WDISP_CharClassTable,A1
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
    BSR.W   PARSEINI_ParseColorTable

    LEA     12(A7),A7
    BRA.W   .next_line

.section6_parse_line:
    PEA     61.W
    MOVE.L  -8(A5),-(A7)
    JSR     PARSEINI_JMPTBL_STR_FindCharPtr(PC)

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
    LEA     WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section6_cut_marker

    ADDQ.L  #1,-32(A5)
    BRA.S   .section6_skip_value_ws

.section6_cut_marker:
    PEA     DATA_PARSEINI_SPACE_VALUE_2069
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
    LEA     WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section6_dispatch

    CLR.B   (A0)
    SUBQ.L  #1,-36(A5)
    BRA.S   .section6_trim_value_end

.section6_dispatch:
    MOVE.L  -32(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    BSR.W   PARSEINI_LoadWeatherStrings

    ADDQ.W  #8,A7
    BRA.W   .next_line

.section7_parse_line:
    PEA     61.W
    MOVE.L  -8(A5),-(A7)
    JSR     PARSEINI_JMPTBL_STR_FindCharPtr(PC)

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
    LEA     WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section7_cut_marker

    ADDQ.L  #1,-32(A5)
    BRA.S   .section7_skip_value_ws

.section7_cut_marker:
    PEA     DATA_PARSEINI_SPACE_VALUE_206A
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
    LEA     WDISP_CharClassTable,A1
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
    JSR     PARSEINI_JMPTBL_STR_FindCharPtr(PC)

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
    LEA     WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .section8_cut_marker

    ADDQ.L  #1,-32(A5)
    BRA.S   .section8_skip_value_ws

.section8_cut_marker:
    PEA     DATA_PARSEINI_SPACE_VALUE_206B
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
    LEA     WDISP_CharClassTable,A1
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
    PEA     Global_STR_PARSEINI_C_2
    JSR     SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

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
;   SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit
; READS:
;   WDISP_CharClassTable (char class table)
; WRITES:
;   (none)
; DESC:
;   Parses consecutive hex characters into a 32-bit value until a non-hex.
; NOTES:
;   Treats each nibble as upper-case hex via LADFUNC_ParseHexDigit.
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
    LEA     WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .return_13D6

    ASL.L   #4,D7
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit(PC)

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
;   NEWGRID2_JMPTBL_STR_SkipClass3Chars, PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable, PARSEINI_JMPTBL_STRING_CompareNoCaseN, PARSEINI_JMPTBL_STR_FindAnyCharPtr, PARSEINI_JMPTBL_STR_FindCharPtr, PARSEINI_ParseHexValueFromString, SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt
; READS:
;   PARSEINI_CurrentRangeTableIndex, DATA_PARSEINI_SPACE_VALUE_206E, DATA_PARSEINI_STR_VALUE_206F, DATA_PARSEINI_TAG_TABLE_2070, DATA_PARSEINI_TAG_DONE_2071, DATA_PARSEINI_TAG_COLOR_2072, handle_range_assign, return
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
    JSR     PARSEINI_JMPTBL_STR_FindCharPtr(PC)

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
    JSR     NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    PEA     DATA_PARSEINI_SPACE_VALUE_206E
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
    JSR     NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    PEA     DATA_PARSEINI_STR_VALUE_206F
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
    PEA     DATA_PARSEINI_TAG_TABLE_2070
    MOVE.L  -4(A5),-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .handle_non_preset_keys

    PEA     4.W
    PEA     DATA_PARSEINI_TAG_DONE_2071
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
    PEA     DATA_PARSEINI_TAG_COLOR_2072
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
;   PARSEINI_JMPTBL_BRUSH_AllocBrushNode, PARSEINI_JMPTBL_STRING_CompareNoCase, SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, SCRIPT3_JMPTBL_STRING_CopyPadNul, SCRIPT_JMPTBL_MEMORY_AllocateMemory
; READS:
;   Global_STR_PARSEINI_C_3, PARSEINI_ParsedDescriptorListHead, DATA_PARSEINI_BSS_LONG_2073, DATA_PARSEINI_TAG_FILENAME_2074, DATA_PARSEINI_STR_LOADCOLOR_2075, DATA_PARSEINI_TAG_ALL_2076, DATA_PARSEINI_TAG_NONE_2077, DATA_PARSEINI_TAG_TEXT_2078, DATA_PARSEINI_TAG_XPOS_2079, DATA_PARSEINI_TAG_TYPE_207A, DATA_PARSEINI_TAG_DITHER_207B, DATA_PARSEINI_TAG_YPOS_207C, DATA_PARSEINI_TAG_XSOURCE_207D, DATA_PARSEINI_TAG_YSOURCE_207E, DATA_PARSEINI_TAG_SIZEX_207F, DATA_PARSEINI_TAG_SIZEY_2080, DATA_PARSEINI_TAG_SOURCE_2081, DATA_PARSEINI_TAG_PPV_2082, DATA_PARSEINI_STR_HORIZONTAL_2084, DATA_PARSEINI_TAG_RIGHT_2085, DATA_PARSEINI_TAG_CENTER_2086, DATA_PARSEINI_TAG_VERTICAL_2087, DATA_PARSEINI_TAG_BOTTOM_2088, DATA_PARSEINI_TAG_CENTER_2089, DATA_PARSEINI_TAG_ID_208A, PARSEINI_CurrentWeatherBlockPtr, MEMF_CLEAR, MEMF_PUBLIC, check_key_2084, return
; WRITES:
;   PARSEINI_ParsedDescriptorListHead, DATA_PARSEINI_BSS_LONG_2073, PARSEINI_CurrentWeatherBlockPtr
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
    TST.L   PARSEINI_ParsedDescriptorListHead
    BNE.S   .after_init_state

    MOVE.L  A0,DATA_PARSEINI_BSS_LONG_2073
    MOVE.L  A0,PARSEINI_CurrentWeatherBlockPtr

.after_init_state:
    PEA     DATA_PARSEINI_TAG_FILENAME_2074
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_2075

    CLR.L   DATA_PARSEINI_BSS_LONG_2073
    MOVE.L  PARSEINI_CurrentWeatherBlockPtr,-(A7)
    MOVE.L  A2,-(A7)
    JSR     PARSEINI_JMPTBL_BRUSH_AllocBrushNode(PC)

    ADDQ.W  #8,A7
    MOVEA.L D0,A0
    MOVE.B  #$1,190(A0)
    MOVE.L  D0,PARSEINI_CurrentWeatherBlockPtr
    TST.L   PARSEINI_ParsedDescriptorListHead
    BNE.S   .check_key_2075

    MOVE.L  D0,PARSEINI_ParsedDescriptorListHead

.check_key_2075:
    TST.L   PARSEINI_CurrentWeatherBlockPtr
    BEQ.W   .return

    PEA     DATA_PARSEINI_STR_LOADCOLOR_2075
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_2079

    PEA     DATA_PARSEINI_TAG_ALL_2076
    MOVE.L  A2,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_mode_2077

    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    CLR.L   194(A0)
    BRA.W   .return

.check_mode_2077:
    PEA     DATA_PARSEINI_TAG_NONE_2077
    MOVE.L  A2,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_mode_2078

    MOVEQ   #2,D0
    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D0,194(A0)
    BRA.W   .return

.check_mode_2078:
    PEA     DATA_PARSEINI_TAG_TEXT_2078
    MOVE.L  A2,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

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
    PEA     DATA_PARSEINI_TAG_XPOS_2079
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

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
    PEA     DATA_PARSEINI_TAG_TYPE_207A
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_207C

    PEA     DATA_PARSEINI_TAG_DITHER_207B
    MOVE.L  A2,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.W   .return

    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.B  #$2,190(A0)
    BRA.W   .return

.check_key_207C:
    PEA     DATA_PARSEINI_TAG_YPOS_207C
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

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
    PEA     DATA_PARSEINI_TAG_XSOURCE_207D
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

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
    PEA     DATA_PARSEINI_TAG_YSOURCE_207E
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

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
    PEA     DATA_PARSEINI_TAG_SIZEX_207F
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

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
    PEA     DATA_PARSEINI_TAG_SIZEY_2080
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

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
    PEA     DATA_PARSEINI_TAG_SOURCE_2081
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

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

    PEA     DATA_PARSEINI_TAG_PPV_2082
    MOVE.L  A2,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .alloc_weather_node

    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.B  #$3,190(A0)
    BRA.W   .return

.alloc_weather_node:
    MOVE.L  DATA_PARSEINI_BSS_LONG_2073,-8(A5)
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     12.W
    PEA     670.W
    PEA     Global_STR_PARSEINI_C_3
    JSR     SCRIPT_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,DATA_PARSEINI_BSS_LONG_2073
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

    MOVEA.L DATA_PARSEINI_BSS_LONG_2073,A1
    MOVE.L  A1,230(A0)
    BRA.W   .return

.append_node_link:
    MOVEA.L -8(A5),A1
    MOVE.L  DATA_PARSEINI_BSS_LONG_2073,8(A1)
    BRA.W   .return

.check_key_2084:
    PEA     DATA_PARSEINI_STR_HORIZONTAL_2084
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_2087

    PEA     DATA_PARSEINI_TAG_RIGHT_2085
    MOVE.L  A2,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_mode_2086

    MOVEQ   #2,D0
    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D0,222(A0)
    BRA.W   .return

.check_mode_2086:
    PEA     DATA_PARSEINI_TAG_CENTER_2086
    MOVE.L  A2,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

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
    PEA     DATA_PARSEINI_TAG_VERTICAL_2087
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_208A

    PEA     DATA_PARSEINI_TAG_BOTTOM_2088
    MOVE.L  A2,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_mode_2089

    MOVEQ   #2,D0
    MOVEA.L PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D0,226(A0)
    BRA.S   .return

.check_mode_2089:
    PEA     DATA_PARSEINI_TAG_CENTER_2089
    MOVE.L  A2,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

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
    PEA     DATA_PARSEINI_TAG_ID_208A
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

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

;------------------------------------------------------------------------------
; FUNC: PARSEINI_LoadWeatherStrings   (Routine at PARSEINI_LoadWeatherStrings)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A3/A7/D0
; CALLS:
;   PARSEINI_JMPTBL_BRUSH_AllocBrushNode, PARSEINI_JMPTBL_STRING_CompareNoCase
; READS:
;   PARSEINI_BannerBrushResourceHead, DATA_PARSEINI_TAG_FILENAME_208B, DATA_PARSEINI_TAG_WEATHER_208C, PARSEINI_WeatherBrushNodePtr, a
; WRITES:
;   PARSEINI_BannerBrushResourceHead, DATA_P_TYPE_BSS_LONG_2059, PARSEINI_WeatherBrushNodePtr
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
PARSEINI_LoadWeatherStrings:
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEA.L 16(A7),A2
    TST.L   PARSEINI_BannerBrushResourceHead
    BNE.S   .if_ne_1401

    CLR.L   PARSEINI_WeatherBrushNodePtr

.if_ne_1401:
    PEA     DATA_PARSEINI_TAG_FILENAME_208B
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .if_ne_1402

    MOVE.L  PARSEINI_WeatherBrushNodePtr,-(A7)
    MOVE.L  A2,-(A7)
    JSR     PARSEINI_JMPTBL_BRUSH_AllocBrushNode(PC)

    ADDQ.W  #8,A7
    MOVEA.L D0,A0
    MOVE.B  #$a,190(A0)
    MOVE.L  D0,PARSEINI_WeatherBrushNodePtr
    TST.L   PARSEINI_BannerBrushResourceHead
    BNE.S   .return_1403

    MOVE.L  D0,PARSEINI_BannerBrushResourceHead
    BRA.S   .return_1403

.if_ne_1402:
    MOVEQ   #0,D0
    TST.L   D0
    BEQ.S   .return_1403

    PEA     DATA_PARSEINI_TAG_WEATHER_208C
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .return_1403

    MOVEQ   #1,D0
    MOVE.L  D0,DATA_P_TYPE_BSS_LONG_2059
    MOVE.L  PARSEINI_WeatherBrushNodePtr,-(A7)
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_BRUSH_AllocBrushNode(PC)

    ADDQ.W  #8,A7
    MOVEA.L D0,A0
    MOVE.B  #10,190(A0)
    MOVE.L  D0,PARSEINI_WeatherBrushNodePtr
    TST.L   PARSEINI_BannerBrushResourceHead
    BNE.S   .return_1403

    MOVE.L  D0,PARSEINI_BannerBrushResourceHead

.return_1403:
    MOVEM.L (A7)+,A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_LoadWeatherMessageStrings   (Routine at PARSEINI_LoadWeatherMessageStrings)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A2/A3/A7
; CALLS:
;   PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString, PARSEINI_JMPTBL_STRING_CompareNoCase
; READS:
;   DATA_P_TYPE_BSS_LONG_205A, DATA_P_TYPE_BSS_LONG_205B, DATA_P_TYPE_BSS_LONG_205C, DATA_PARSEINI_STR_WEATHERCURRENT_208D, DATA_PARSEINI_STR_WEATHERFORECAST_208E, DATA_PARSEINI_STR_BOTTOMLINETAG_208F
; WRITES:
;   DATA_P_TYPE_BSS_LONG_205A, DATA_P_TYPE_BSS_LONG_205B, DATA_P_TYPE_BSS_LONG_205C
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
PARSEINI_LoadWeatherMessageStrings:
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEA.L 16(A7),A2
    PEA     DATA_PARSEINI_STR_WEATHERCURRENT_208D
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .if_ne_1405

    MOVE.L  DATA_P_TYPE_BSS_LONG_205A,-(A7)
    MOVE.L  A2,-(A7)
    JSR     PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,DATA_P_TYPE_BSS_LONG_205A
    BRA.S   .return_1407

.if_ne_1405:
    PEA     DATA_PARSEINI_STR_WEATHERFORECAST_208E
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .if_ne_1406

    MOVE.L  DATA_P_TYPE_BSS_LONG_205B,-(A7)
    MOVE.L  A2,-(A7)
    JSR     PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,DATA_P_TYPE_BSS_LONG_205B
    BRA.S   .return_1407

.if_ne_1406:
    PEA     DATA_PARSEINI_STR_BOTTOMLINETAG_208F
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .return_1407

    MOVE.L  DATA_P_TYPE_BSS_LONG_205C,-(A7)
    MOVE.L  A2,-(A7)
    JSR     PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,DATA_P_TYPE_BSS_LONG_205C

.return_1407:
    MOVEM.L (A7)+,A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_ParseColorTable   (Routine at PARSEINI_ParseColorTable)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +108: arg_4 (via 112(A5))
;   stack +112: arg_5 (via 116(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A3/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   PARSEINI_JMPTBL_STRING_CompareNoCase, PARSEINI_JMPTBL_WDISP_SPrintf, SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit, TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition
; READS:
;   Global_STR_COLOR_PERCENT_D, ESQFUNC_BasePaletteRgbTriples, DATA_KYBD_BSS_BYTE_1FB8
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
PARSEINI_ParseColorTable:
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
    MOVE.L  #DATA_KYBD_BSS_BYTE_1FB8,-116(A5)
    MOVEQ   #8,D4
    BRA.S   .init_color_index

.mode5_select_table:
    MOVE.L  #ESQFUNC_BasePaletteRgbTriples,-116(A5)
    MOVEQ   #8,D4

.init_color_index:
    MOVEQ   #0,D6

.color_index_loop:
    CMP.L   D4,D6
    BGE.S   .maybe_finalize

    MOVE.L  D6,-(A7)
    PEA     Global_STR_COLOR_PERCENT_D
    PEA     -112(A5)
    JSR     PARSEINI_JMPTBL_WDISP_SPrintf(PC)

    PEA     -112(A5)
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

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
    JSR     SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit(PC)

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

    JSR     TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition(PC)

.return:
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEST_MEMORY_AND_OPEN_TOPAZ_FONT   (Test memory then open Topaz)
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
;   Global_HANDLE_TOPAZ_FONT
; WRITES:
;   (A3) font handle
; DESC:
;   Ensures a Topaz font is open, first probing for a small alloc; closes an
;   existing non-Topaz handle, tries to open the requested font, otherwise falls
;   back to the global Topaz handle.
; NOTES:
;   Sets D0=1 when it could not load the desired font.
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
; FUNC: PARSEINI_TestMemoryAndOpenTopazFont   (Routine at PARSEINI_TestMemoryAndOpenTopazFont)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D7
; CALLS:
;   _LVOAllocMem, _LVOCloseFont, _LVOForbid, _LVOFreeMem, _LVOOpenDiskFont, _LVOPermit
; READS:
;   AbsExecBase, DesiredMemoryAvailability, Global_HANDLE_TOPAZ_FONT, Global_REF_DISKFONT_LIBRARY, Global_REF_GRAPHICS_LIBRARY
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
PARSEINI_TestMemoryAndOpenTopazFont:
    LINK.W  A5,#-8
    MOVEM.L D7/A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2

    MOVEQ   #0,D7
    TST.L   (A3)
    BEQ.S   .return

    MOVEA.L (A3),A0
    MOVEA.L Global_HANDLE_TOPAZ_FONT,A1
    CMPA.L  A0,A1
    BEQ.S   .testDesiredMemoryAvailability

    MOVEA.L A0,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
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
    MOVEA.L Global_REF_DISKFONT_LIBRARY,A6
    JSR     _LVOOpenDiskFont(A6)

    MOVE.L  D0,(A3)
    BNE.S   .couldNotLoadTopazFont

    MOVE.L  Global_HANDLE_TOPAZ_FONT,(A3)
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
; FUNC: PARSEINI_HandleFontCommand   (Parse font/control command dispatcher)
; ARGS:
;   stack +8: A3 = command string pointer
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   PARSEINI_JMPTBL_WDISP_SPrintf, _LVOExecute, TEST_MEMORY_AND_OPEN_TOPAZ_FONT, LAB_1429
; READS:
;   Global_REF_DOS_LIBRARY_2, Global_HANDLE_TOPAZ_FONT
; WRITES:
;   (font handles via TEST_MEMORY_AND_OPEN_TOPAZ_FONT)
; DESC:
;   Parses a command string starting with '3' '2' ... handling subcommands to
;   execute shell commands or open fonts depending on the trailing byte.
; NOTES:
;   Matches subcodes 0x34–0x38 etc.; returns early on non-matching prefixes.
;------------------------------------------------------------------------------
PARSEINI_HandleFontCommand:
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
    PEA     Global_STR_PERCENT_S_2
    PEA     -80(A5)
    JSR     PARSEINI_JMPTBL_WDISP_SPrintf(PC)

    LEA     12(A7),A7
    LEA     -80(A5),A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
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
    JSR     PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit0(PC)

    BRA.W   .return

.cmd_scan_logos_and_clear_flag1:
    MOVE.B  DATA_CTASKS_STR_Y_1BC1,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .after_optional_logo_scan

    BSR.W   PARSEINI_ScanLogoDirectory

.after_optional_logo_scan:
    JSR     PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit1(PC)

    BRA.W   .return

.cmd_call_lab_09DB:
    JSR     PARSEINI_JMPTBL_ESQFUNC_RebuildPwBrushListFromTagTableFromTagTable(PC)

    BRA.W   .return

.cmd_set_h26f_font:
    PEA     Global_STRUCT_TEXTATTR_H26F_FONT
    PEA     Global_HANDLE_H26F_FONT
    BSR.W   PARSEINI_TestMemoryAndOpenTopazFont

    ADDQ.W  #8,A7
    TST.W   D0
    BEQ.W   .return

    TST.W   Global_UIBusyFlag
    BEQ.W   .return

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEA.L Global_HANDLE_H26F_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    BRA.W   .return

.cmd_set_prevuec_font:
    PEA     Global_STRUCT_TEXTATTR_PREVUEC_FONT
    PEA     Global_HANDLE_PREVUEC_FONT
    BSR.W   PARSEINI_TestMemoryAndOpenTopazFont

    ADDQ.W  #8,A7
    TST.W   D0
    BEQ.W   .return

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0

    MOVEA.L A0,A1
    MOVEA.L Global_HANDLE_PREVUEC_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEA.L Global_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVEA.L Global_REF_RASTPORT_2,A1
    MOVEA.L Global_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVEA.L Global_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEA.L Global_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVEA.L Global_REF_GRID_RASTPORT_MAYBE_2,A1
    MOVEA.L Global_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVEQ   #0,D6

.prevec_font_rastport_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D6
    BGE.S   .after_prevuec_font_loop

    MOVE.L  D6,D0
    MOVEQ   #80,D1
    ADD.L   D1,D1
    JSR     SCRIPT3_JMPTBL_MATH_Mulu32(PC)

    LEA     DATA_WDISP_BSS_LONG_22A6,A0
    ADDA.L  D0,A0
    LEA     60(A0),A1
    MOVEA.L Global_HANDLE_PREVUEC_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    ADDQ.L  #1,D6
    BRA.S   .prevec_font_rastport_loop

.after_prevuec_font_loop:
    MOVE.L  Global_HANDLE_PREVUEC_FONT,-(A7)
    JSR     TLIBA3_SetFontForAllViewModes

    ADDQ.W  #4,A7
    BRA.W   .return

.cmd_set_prevue_font:
    PEA     Global_STRUCT_TEXTATTR_PREVUE_FONT
    PEA     Global_HANDLE_PREVUE_FONT
    BSR.W   PARSEINI_TestMemoryAndOpenTopazFont

    ADDQ.W  #8,A7
    TST.W   D0
    BRA.W   .return

.cmd_parse_ini_from_disk:
    JSR     PARSEINI_JMPTBL_DISKIO2_ParseIniFileFromDisk(PC)

    BRA.W   .return

.cmd_call_lab_0A93:
    PEA     97.W
    JSR     PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey(PC)

    ADDQ.W  #4,A7
    BRA.W   .return

.cmd_parse_gradient_ini:
    PEA     Global_STR_DF0_GRADIENT_INI_3
    BSR.W   PARSEINI_ParseIniBufferAndDispatch

    ADDQ.W  #4,A7
    BRA.W   .return

.cmd_parse_banner_ini:
    PEA     Global_STR_DF0_BANNER_INI_2
    JSR     SCRIPT_CheckPathExists(PC)

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.W   .return

.wait_banner_ready:
    TST.W   CTASKS_IffTaskDoneFlag
    BEQ.S   .wait_banner_ready

    CLR.L   -(A7)
    PEA     WDISP_WeatherStatusBrushListHead
    JSR     PARSEINI_JMPTBL_BRUSH_FreeBrushList(PC)

    PEA     PARSEINI_BannerBrushResourceHead
    JSR     PARSEINI_JMPTBL_BRUSH_FreeBrushResources(PC)

    PEA     Global_STR_DF0_BANNER_INI_3

    BSR.W   PARSEINI_ParseIniBufferAndDispatch

    PEA     1.W
    JSR     PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad(PC)

    LEA     20(A7),A7
    BRA.S   .return

.cmd_parse_default_ini:
    PEA     Global_STR_DF0_DEFAULT_INI_2
    BSR.W   PARSEINI_ParseIniBufferAndDispatch

    ADDQ.W  #4,A7
    BRA.S   .return

.cmd_parse_sourcecfg_ini:
    PEA     Global_STR_DF0_SOURCECFG_INI_1
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
    JSR     PARSEINI_JMPTBL_ED1_EnterEscMenu(PC)

    JSR     PARSEINI_JMPTBL_ED1_ExitEscMenu(PC)

    BRA.S   .return

.cmd_draw_diagnostics:
    JSR     PARSEINI_JMPTBL_ED1_EnterEscMenu(PC)

    JSR     PARSEINI_JMPTBL_ED1_DrawDiagnosticsScreen(PC)

    BRA.S   .return

.cmd_draw_version:
    JSR     PARSEINI_JMPTBL_ED1_EnterEscMenu(PC)

    JSR     PARSEINI_JMPTBL_ESQFUNC_DrawEscMenuVersion(PC)

.return:
    MOVEM.L (A7)+,D2-D3/D6-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_ScanLogoDirectory   (Scan logo directory and build name/path lists)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D7/A0-A2
; CALLS:
;   _LVOExecute, PARSEINI_JMPTBL_HANDLE_OpenWithMode, PARSEINI_JMPTBL_STREAM_ReadLineWithLimit, PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator, SCRIPT_JMPTBL_MEMORY_AllocateMemory
; READS:
;   Global_STR_LIST_RAM_LOGODIR_TXT_DH2_LOGOS_NOHEAD_QUICK, DATA_PARSEINI_PATH_DF0_COLON_LOGO_DOT_LST_2098/2099/209A/209B strings
; WRITES:
;   local temp buffers and allocated lists at -500/-900(A5)
; DESC:
;   Executes helper commands to list logo directories, reads entries into temp
;   buffers, allocates per-entry strings, and populates two arrays (probably names/paths).
; NOTES:
;   Iterates up to 100 entries per list, trimming CR/LF/commas from lines.
;------------------------------------------------------------------------------
PARSEINI_ScanLogoDirectory:
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
    LEA     Global_STR_LIST_RAM_LOGODIR_TXT_DH2_LOGOS_NOHEAD_QUICK,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    PEA     DATA_PARSEINI_STR_RB_2099
    PEA     DATA_PARSEINI_PATH_DF0_COLON_LOGO_DOT_LST_2098
    JSR     PARSEINI_JMPTBL_HANDLE_OpenWithMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    BNE.S   .after_open_primary

    CLR.L   -96(A5)

.after_open_primary:
    PEA     DATA_PARSEINI_STR_RB_209B
    PEA     DATA_PARSEINI_PATH_RAM_COLON_LOGODIR_DOT_TXT_209A
    JSR     PARSEINI_JMPTBL_HANDLE_OpenWithMode(PC)

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
    JSR     PARSEINI_JMPTBL_STREAM_ReadLineWithLimit(PC)

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
    JSR     PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator(PC)

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
    PEA     Global_STR_PARSEINI_C_4
    MOVE.L  D0,-92(A5)
    MOVE.L  A0,40(A7)
    JSR     SCRIPT_JMPTBL_MEMORY_AllocateMemory(PC)

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
    JSR     PARSEINI_JMPTBL_STREAM_ReadLineWithLimit(PC)

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
    PEA     Global_STR_PARSEINI_C_5
    MOVE.L  A0,40(A7)
    JSR     SCRIPT_JMPTBL_MEMORY_AllocateMemory(PC)

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
    JSR     PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

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

    LEA     Global_STR_DELETE_NIL_DH2_LOGOS,A0
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
    JSR     PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    LEA     -956(A5),A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
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
    PEA     Global_STR_PARSEINI_C_6
    JSR     SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

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
    PEA     Global_STR_PARSEINI_C_7
    JSR     SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    ADDQ.L  #1,D5
    BRA.S   .next_primary_entry_free

.close_primary_handle:
    TST.L   -4(A5)
    BEQ.S   .close_secondary_handle

    MOVE.L  -4(A5),-(A7)
    JSR     PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest(PC)

    ADDQ.W  #4,A7

.close_secondary_handle:
    TST.L   -8(A5)
    BEQ.S   .return

    MOVE.L  -8(A5),-(A7)
    JSR     PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest(PC)

    ADDQ.W  #4,A7

.return:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_STRING_CompareNoCase   (JumpStub_STRING_CompareNoCase)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STRING_CompareNoCase
; DESC:
;   Jump stub to STRING_CompareNoCase (string compare/parse helper).
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_STRING_CompareNoCase:
    JMP     STRING_CompareNoCase

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit0   (JumpStub_ED1_WaitForFlagAndClearBit0)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ED1_WaitForFlagAndClearBit0
; DESC:
;   Jump stub to ED1_WaitForFlagAndClearBit0.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit0:
    JMP     ED1_WaitForFlagAndClearBit0

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_DISKIO2_ParseIniFileFromDisk   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DISKIO2_ParseIniFileFromDisk
; DESC:
;   Jump stub to DISKIO2_ParseIniFileFromDisk (Parse INI file from disk).
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_DISKIO2_ParseIniFileFromDisk:
    JMP     DISKIO2_ParseIniFileFromDisk

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_STR_FindCharPtr   (JumpStub_STR_FindCharPtr)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STR_FindCharPtr
; DESC:
;   Jump stub to STR_FindCharPtr.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_STR_FindCharPtr:
    JMP     STR_FindCharPtr

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_HANDLE_OpenWithMode   (JumpStub_HANDLE_OpenWithMode)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   HANDLE_OpenWithMode
; DESC:
;   Jump stub to HANDLE_OpenWithMode.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_HANDLE_OpenWithMode:
    JMP     HANDLE_OpenWithMode

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQIFF_QueueIffBrushLoad
; DESC:
;   Jump stub to ESQIFF_QueueIffBrushLoad.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad:
    JMP     ESQIFF_QueueIffBrushLoad

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQIFF_HandleBrushIniReloadHotkey
; DESC:
;   Jump stub to ESQIFF_HandleBrushIniReloadHotkey.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey:
    JMP     ESQIFF_HandleBrushIniReloadHotkey

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_BRUSH_FreeBrushResources   (JumpStub_BRUSH_FreeBrushResources)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_FreeBrushResources
; DESC:
;   Jump stub to BRUSH_FreeBrushResources.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_BRUSH_FreeBrushResources:
    JMP     BRUSH_FreeBrushResources

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_ESQFUNC_RebuildPwBrushListFromTagTableFromTagTable   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQFUNC_RebuildPwBrushListFromTagTable
; DESC:
;   Jump stub to ESQFUNC_RebuildPwBrushListFromTagTable.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_ESQFUNC_RebuildPwBrushListFromTagTableFromTagTable:
    JMP     ESQFUNC_RebuildPwBrushListFromTagTable

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator   (JumpStub_GCOMMAND_FindPathSeparator)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   GCOMMAND_FindPathSeparator
; DESC:
;   Jump stub to GCOMMAND_FindPathSeparator.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator:
    JMP     GCOMMAND_FindPathSeparator

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_DISKIO_ConsumeLineFromWorkBuffer   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DISKIO_ConsumeLineFromWorkBuffer
; DESC:
;   Jump stub to DISKIO_ConsumeLineFromWorkBuffer.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_DISKIO_ConsumeLineFromWorkBuffer:
    JMP     DISKIO_ConsumeLineFromWorkBuffer

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_ED1_DrawDiagnosticsScreen   (JumpStub_ED1_DrawDiagnosticsScreen)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ED1_DrawDiagnosticsScreen
; DESC:
;   Jump stub to ED1_DrawDiagnosticsScreen.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_ED1_DrawDiagnosticsScreen:
    JMP     ED1_DrawDiagnosticsScreen

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_BRUSH_FreeBrushList   (JumpStub_BRUSH_FreeBrushList)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_FreeBrushList
; DESC:
;   Jump stub to BRUSH_FreeBrushList.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_BRUSH_FreeBrushList:
    JMP     BRUSH_FreeBrushList

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable   (JumpStub_GCOMMAND_ValidatePresetTable)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   GCOMMAND_ValidatePresetTable
; DESC:
;   Jump stub to GCOMMAND_ValidatePresetTable.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable:
    JMP     GCOMMAND_ValidatePresetTable

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_BRUSH_AllocBrushNode   (JumpStub_BRUSH_AllocBrushNode)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_AllocBrushNode
; DESC:
;   Jump stub to BRUSH_AllocBrushNode.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_BRUSH_AllocBrushNode:
    JMP     BRUSH_AllocBrushNode

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest   (JumpStub_UNKNOWN36_FinalizeRequest)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   UNKNOWN36_FinalizeRequest
; DESC:
;   Jump stub to UNKNOWN36_FinalizeRequest.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest:
    JMP     UNKNOWN36_FinalizeRequest

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_GCOMMAND_InitPresetTableFromPalette   (JumpStub_GCOMMAND_InitPresetTableFromPalette)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   GCOMMAND_InitPresetTableFromPalette
; DESC:
;   Jump stub to GCOMMAND_InitPresetTableFromPalette.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_GCOMMAND_InitPresetTableFromPalette:
    JMP     GCOMMAND_InitPresetTableFromPalette

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_STRING_CompareNoCaseN   (JumpStub_STRING_CompareNoCaseN)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STRING_CompareNoCaseN
; DESC:
;   Jump stub to STRING_CompareNoCaseN.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_STRING_CompareNoCaseN:
    JMP     STRING_CompareNoCaseN

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_STRING_AppendAtNull   (JumpStub_STRING_AppendAtNull)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STRING_AppendAtNull
; DESC:
;   Jump stub to STRING_AppendAtNull.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_STRING_AppendAtNull:
    JMP     STRING_AppendAtNull

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DISKIO_LoadFileToWorkBuffer
; DESC:
;   Jump stub to DISKIO_LoadFileToWorkBuffer.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer:
    JMP     DISKIO_LoadFileToWorkBuffer

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit1   (JumpStub_ED1_WaitForFlagAndClearBit1)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ED1_WaitForFlagAndClearBit1
; DESC:
;   Jump stub to ED1_WaitForFlagAndClearBit1.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit1:
    JMP     ED1_WaitForFlagAndClearBit1

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_WDISP_SPrintf   (JumpStub_WDISP_SPrintf)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   WDISP_SPrintf
; DESC:
;   Jump stub to WDISP_SPrintf.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_WDISP_SPrintf:
    JMP     WDISP_SPrintf

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_STREAM_ReadLineWithLimit   (JumpStub_STREAM_ReadLineWithLimit)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STREAM_ReadLineWithLimit
; DESC:
;   Jump stub to STREAM_ReadLineWithLimit.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_STREAM_ReadLineWithLimit:
    JMP     STREAM_ReadLineWithLimit

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_STR_FindAnyCharPtr   (JumpStub_STR_FindAnyCharPtr)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STR_FindAnyCharPtr
; DESC:
;   Jump stub to STR_FindAnyCharPtr.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_STR_FindAnyCharPtr:
    JMP     STR_FindAnyCharPtr

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_ED1_ExitEscMenu   (JumpStub_ED1_ExitEscMenu)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ED1_ExitEscMenu
; DESC:
;   Jump stub to ED1_ExitEscMenu.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_ED1_ExitEscMenu:
    JMP     ED1_ExitEscMenu

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQPARS_ReplaceOwnedString
; DESC:
;   Jump stub to ESQPARS_ReplaceOwnedString.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString:
    JMP     ESQPARS_ReplaceOwnedString

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_ED1_EnterEscMenu   (JumpStub_ED1_EnterEscMenu)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ED1_EnterEscMenu
; DESC:
;   Jump stub to ED1_EnterEscMenu.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_ED1_EnterEscMenu:
    JMP     ED1_EnterEscMenu

;------------------------------------------------------------------------------
; FUNC: PARSEINI_JMPTBL_ESQFUNC_DrawEscMenuVersion   (JumpStub_ESQFUNC_DrawEscMenuVersion)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQFUNC_DrawEscMenuVersion
; DESC:
;   Jump stub to ESQFUNC_DrawEscMenuVersion.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
PARSEINI_JMPTBL_ESQFUNC_DrawEscMenuVersion:
    JMP     ESQFUNC_DrawEscMenuVersion

    RTS

;!======

    ; Alignment
    ALIGN_WORD
