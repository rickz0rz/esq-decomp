    XDEF    _PARSEINI_ParseRangeKeyValue



;------------------------------------------------------------------------------
; FUNC: _PARSEINI_ParseRangeKeyValue   (Routine at _PARSEINI_ParseRangeKeyValue)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A3/A5/A7/D0/D1/D6/D7
; CALLS:
;   _NEWGRID2_JMPTBL_STR_SkipClass3Chars, _PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable, _PARSEINI_JMPTBL_STRING_CompareNoCaseN, _PARSEINI_JMPTBL_STR_FindAnyCharPtr, _PARSEINI_JMPTBL_STR_FindCharPtr, _PARSEINI_ParseHexValueFromString, _SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt
; READS:
;   _PARSEINI_CurrentRangeTableIndex, _PARSEINI_DelimSpaceTab_RangeKey, _PARSEINI_DelimSpaceSemicolonTab_RangeValue, _PARSEINI_TAG_TABLE, _PARSEINI_TAG_DONE, _PARSEINI_TAG_COLOR, handle_range_assign, return
; WRITES:
;   _PARSEINI_CurrentRangeTableIndex
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_PARSEINI_ParseRangeKeyValue:
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

    PEA     _PARSEINI_DelimSpaceTab_RangeKey
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     _PARSEINI_JMPTBL_STR_FindAnyCharPtr(PC)

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

    PEA     _PARSEINI_DelimSpaceSemicolonTab_RangeValue
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-8(A5)
    JSR     _PARSEINI_JMPTBL_STR_FindAnyCharPtr(PC)

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
    PEA     _PARSEINI_TAG_TABLE
    MOVE.L  -4(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .handle_non_preset_keys

    PEA     4.W
    PEA     _PARSEINI_TAG_DONE
    MOVE.L  -8(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .handle_non_preset_keys

    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable(PC)

    ADDQ.W  #4,A7
    MOVEQ   #-1,D0
    MOVE.L  D0,_PARSEINI_CurrentRangeTableIndex
    BRA.W   .return

.handle_non_preset_keys:
    PEA     5.W
    PEA     _PARSEINI_TAG_COLOR
    MOVE.L  -4(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCaseN(PC)

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
    JSR     _SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

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
    MOVE.L  D0,_PARSEINI_CurrentRangeTableIndex
    BRA.S   .after_index_store

.store_index:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,_PARSEINI_CurrentRangeTableIndex
    ADD.L   D0,D0
    CLR.W   0(A2,D0.L)

.after_index_store:
    MOVE.L  _PARSEINI_CurrentRangeTableIndex,D0
    TST.L   D0
    BMI.W   .return

    MOVEQ   #16,D1
    CMP.L   D1,D0
    BGE.W   .return

    MOVE.L  -8(A5),-(A7)
    JSR     _SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

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
    MOVE.L  _PARSEINI_CurrentRangeTableIndex,D0
    MOVE.L  D0,D1
    ADD.L   D1,D1
    MOVE.W  D6,0(A2,D1.L)
    BRA.S   .return

.handle_range_assign:
    MOVE.L  _PARSEINI_CurrentRangeTableIndex,D0
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
    JSR     _SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    MOVE.L  D0,D7
    MOVE.L  -8(A5),(A7)
    BSR.W   _PARSEINI_ParseHexValueFromString

    ADDQ.W  #4,A7
    MOVE.L  D0,D6
    TST.W   D7
    BLE.S   .return

    MOVE.L  _PARSEINI_CurrentRangeTableIndex,D0
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