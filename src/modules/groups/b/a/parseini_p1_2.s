    XDEF    PARSEINI_ParseRangeKeyValue
    XDEF    PARSEINI_ProcessWeatherBlocks


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
;   _NEWGRID2_JMPTBL_STR_SkipClass3Chars, PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable, PARSEINI_JMPTBL_STRING_CompareNoCaseN, PARSEINI_JMPTBL_STR_FindAnyCharPtr, _PARSEINI_JMPTBL_STR_FindCharPtr, _PARSEINI_ParseHexValueFromString, SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt
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
    BSR.W   _PARSEINI_ParseHexValueFromString

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