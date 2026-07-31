    XDEF    _PARSEINI_ProcessWeatherBlocks


;------------------------------------------------------------------------------
; FUNC: _PARSEINI_ProcessWeatherBlocks   (Routine at _PARSEINI_ProcessWeatherBlocks)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D7
; CALLS:
;   _PARSEINI_JMPTBL_BRUSH_AllocBrushNode, _PARSEINI_JMPTBL_STRING_CompareNoCase, _SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, _SCRIPT3_JMPTBL_STRING_CopyPadNul, _SCRIPT_JMPTBL_MEMORY_AllocateMemory
; READS:
;   _Global_STR_PARSEINI_C_3, _PARSEINI_ParsedDescriptorListHead, _PARSEINI_CurrentWeatherBlockTempPtr, _PARSEINI_TAG_FILENAME_WeatherBlock, _PARSEINI_STR_LOADCOLOR, _PARSEINI_TAG_ALL, _PARSEINI_TAG_NONE, _PARSEINI_TAG_TEXT, _PARSEINI_TAG_XPOS, _PARSEINI_TAG_TYPE, _PARSEINI_TAG_DITHER, _PARSEINI_TAG_YPOS, _PARSEINI_TAG_XSOURCE, _PARSEINI_TAG_YSOURCE, _PARSEINI_TAG_SIZEX, _PARSEINI_TAG_SIZEY, _PARSEINI_TAG_SOURCE, _PARSEINI_TAG_PPV, _PARSEINI_STR_HORIZONTAL, _PARSEINI_TAG_RIGHT, _PARSEINI_TAG_CENTER_HorizontalAlign, _PARSEINI_TAG_VERTICAL, _PARSEINI_TAG_BOTTOM, _PARSEINI_TAG_CENTER_VerticalAlign, _PARSEINI_TAG_ID, _PARSEINI_CurrentWeatherBlockPtr, MEMF_CLEAR, MEMF_PUBLIC, check_key_2084, return
; WRITES:
;   _PARSEINI_ParsedDescriptorListHead, _PARSEINI_CurrentWeatherBlockTempPtr, _PARSEINI_CurrentWeatherBlockPtr
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_PARSEINI_ProcessWeatherBlocks:
    LINK.W  A5,#-8
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    SUBA.L  A0,A0
    MOVE.L  A0,-8(A5)
    TST.L   _PARSEINI_ParsedDescriptorListHead
    BNE.S   .after_init_state

    MOVE.L  A0,_PARSEINI_CurrentWeatherBlockTempPtr
    MOVE.L  A0,_PARSEINI_CurrentWeatherBlockPtr

.after_init_state:
    PEA     _PARSEINI_TAG_FILENAME_WeatherBlock
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_2075

    CLR.L   _PARSEINI_CurrentWeatherBlockTempPtr
    MOVE.L  _PARSEINI_CurrentWeatherBlockPtr,-(A7)
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_BRUSH_AllocBrushNode(PC)

    ADDQ.W  #8,A7
    MOVEA.L D0,A0
    MOVE.B  #$1,190(A0)
    MOVE.L  D0,_PARSEINI_CurrentWeatherBlockPtr
    TST.L   _PARSEINI_ParsedDescriptorListHead
    BNE.S   .check_key_2075

    MOVE.L  D0,_PARSEINI_ParsedDescriptorListHead

.check_key_2075:
    TST.L   _PARSEINI_CurrentWeatherBlockPtr
    BEQ.W   .return

    PEA     _PARSEINI_STR_LOADCOLOR
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_2079

    PEA     _PARSEINI_TAG_ALL
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_mode_2077

    MOVEA.L _PARSEINI_CurrentWeatherBlockPtr,A0
    CLR.L   194(A0)
    BRA.W   .return

.check_mode_2077:
    PEA     _PARSEINI_TAG_NONE
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_mode_2078

    MOVEQ   #2,D0
    MOVEA.L _PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D0,194(A0)
    BRA.W   .return

.check_mode_2078:
    PEA     _PARSEINI_TAG_TEXT
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .set_default_mode_194

    MOVEQ   #3,D0
    MOVEA.L _PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D0,194(A0)
    BRA.W   .return

.set_default_mode_194:
    MOVEQ   #1,D0
    MOVEA.L _PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D0,194(A0)
    BRA.W   .return

.check_key_2079:
    PEA     _PARSEINI_TAG_XPOS
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_207A

    MOVE.L  A2,-(A7)
    JSR     _SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    MOVEA.L _PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D7,198(A0)
    BRA.W   .return

.check_key_207A:
    PEA     _PARSEINI_TAG_TYPE
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_207C

    PEA     _PARSEINI_TAG_DITHER
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.W   .return

    MOVEA.L _PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.B  #$2,190(A0)
    BRA.W   .return

.check_key_207C:
    PEA     _PARSEINI_TAG_YPOS
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_207D

    MOVE.L  A2,-(A7)
    JSR     _SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    MOVEA.L _PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D7,202(A0)
    BRA.W   .return

.check_key_207D:
    PEA     _PARSEINI_TAG_XSOURCE
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_207E

    MOVE.L  A2,-(A7)
    JSR     _SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    MOVEA.L _PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D7,206(A0)
    BRA.W   .return

.check_key_207E:
    PEA     _PARSEINI_TAG_YSOURCE
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_207F

    MOVE.L  A2,-(A7)
    JSR     _SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    MOVEA.L _PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D7,210(A0)
    BRA.W   .return

.check_key_207F:
    PEA     _PARSEINI_TAG_SIZEX
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_2080

    MOVE.L  A2,-(A7)
    JSR     _SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    MOVEA.L _PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D7,214(A0)
    BRA.W   .return

.check_key_2080:
    PEA     _PARSEINI_TAG_SIZEY
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_2081

    MOVE.L  A2,-(A7)
    JSR     _SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D7
    MOVEA.L _PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D7,218(A0)
    BRA.W   .return

.check_key_2081:
    PEA     _PARSEINI_TAG_SOURCE
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

    PEA     _PARSEINI_TAG_PPV
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .alloc_weather_node

    MOVEA.L _PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.B  #$3,190(A0)
    BRA.W   .return

.alloc_weather_node:
    MOVE.L  _PARSEINI_CurrentWeatherBlockTempPtr,-8(A5)
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     12.W
    PEA     670.W
    PEA     _Global_STR_PARSEINI_C_3
    JSR     _SCRIPT_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,_PARSEINI_CurrentWeatherBlockTempPtr
    TST.L   D0
    BEQ.W   .return

    MOVEA.L D0,A0
    CLR.L   8(A0)
    MOVEA.L A2,A0
    MOVEA.L D0,A1

.copy_node_label:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_node_label

    MOVEA.L _PARSEINI_CurrentWeatherBlockPtr,A0
    TST.L   230(A0)
    BNE.S   .append_node_link

    MOVEA.L _PARSEINI_CurrentWeatherBlockTempPtr,A1
    MOVE.L  A1,230(A0)
    BRA.W   .return

.append_node_link:
    MOVEA.L -8(A5),A1
    MOVE.L  _PARSEINI_CurrentWeatherBlockTempPtr,8(A1)
    BRA.W   .return

.check_key_2084:
    PEA     _PARSEINI_STR_HORIZONTAL
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_2087

    PEA     _PARSEINI_TAG_RIGHT
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_mode_2086

    MOVEQ   #2,D0
    MOVEA.L _PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D0,222(A0)
    BRA.W   .return

.check_mode_2086:
    PEA     _PARSEINI_TAG_CENTER_HorizontalAlign
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .set_mode_222_default

    MOVEQ   #1,D0
    MOVEA.L _PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D0,222(A0)
    BRA.W   .return

.set_mode_222_default:
    MOVEA.L _PARSEINI_CurrentWeatherBlockPtr,A0
    CLR.L   222(A0)
    BRA.W   .return

.check_key_2087:
    PEA     _PARSEINI_TAG_VERTICAL
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_key_208A

    PEA     _PARSEINI_TAG_BOTTOM
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .check_mode_2089

    MOVEQ   #2,D0
    MOVEA.L _PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D0,226(A0)
    BRA.S   .return

.check_mode_2089:
    PEA     _PARSEINI_TAG_CENTER_VerticalAlign
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .set_mode_226_default

    MOVEQ   #1,D0
    MOVEA.L _PARSEINI_CurrentWeatherBlockPtr,A0
    MOVE.L  D0,226(A0)
    BRA.S   .return

.set_mode_226_default:
    MOVEA.L _PARSEINI_CurrentWeatherBlockPtr,A0
    CLR.L   226(A0)
    BRA.S   .return

.check_key_208A:
    PEA     _PARSEINI_TAG_ID
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .return

    MOVEA.L _PARSEINI_CurrentWeatherBlockPtr,A0
    ADDA.W  #191,A0
    PEA     2.W
    MOVE.L  A2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _SCRIPT3_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    MOVEA.L _PARSEINI_CurrentWeatherBlockPtr,A0
    CLR.B   193(A0)

.return:
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======