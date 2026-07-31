    XDEF    _LADFUNC_ParseBannerEntryData



;------------------------------------------------------------------------------
; FUNC: _LADFUNC_ParseBannerEntryData   (Parse banner entry datauncertain)
; ARGS:
;   stack +7: arg_1 (via 11(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +403: arg_3 (via 407(A5))
;   stack +408: arg_4 (via 412(A5))
;   stack +409: arg_5 (via 413(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   _LADFUNC_ParseHexDigit, _LADFUNC_ComposePackedPenByte, _LADFUNC_SetPackedPenHighNibble, _LADFUNC_SetPackedPenLowNibble, _ESQIFF2_ValidateAsciiNumericByte, _ESQPARS_ReplaceOwnedString,
;   _NEWGRID_JMPTBL_MEMORY_AllocateMemory, _NEWGRID_JMPTBL_MEMORY_DeallocateMemory,
;   _GROUP_AS_JMPTBL_STR_FindCharPtr, _LADFUNC_UpdateHighlightState
; READS:
;   _ED_DiagTextModeChar, _LADFUNC_TAG_RS_ResetTriggerSet, _LADFUNC_TAG_RS_ParseAllowedSet, _LADFUNC_EntryPtrTable, _LADFUNC_ParsedEntryCount, _ESQIFF_StatusPacketReadyFlag
; WRITES:
;   _LADFUNC_ParsedEntryCount, _LADFUNC_EntryPtrTable entry buffers, _WDISP_HighlightActive
; DESC:
;   Parses an encoded entry record and updates entry buffers and metadata.
; NOTES:
;   Control code 3 appears to change attributes via hex nibbles.
;------------------------------------------------------------------------------
_LADFUNC_ParseBannerEntryData:
    LINK.W  A5,#-416
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVE.B  11(A5),D7
    MOVEA.L 12(A5),A3
    PEA     1.W
    PEA     2.W
    BSR.W   _LADFUNC_ComposePackedPenByte

    ADDQ.W  #8,A7
    MOVE.B  (A3)+,D5
    MOVEQ   #0,D1
    MOVE.B  D5,D1
    MOVE.B  D0,-413(A5)
    MOVEQ   #73,D0
    ADD.L   D0,D0
    CMP.L   D0,D1
    BNE.S   .check_entry_prefix

    MOVEQ   #76,D0
    CMP.B   D0,D7
    BEQ.S   .maybe_refresh

    MOVEQ   #116,D0
    CMP.B   D0,D7
    BNE.S   .return_zero

.maybe_refresh:
    MOVE.W  _ESQIFF_StatusPacketReadyFlag,D0
    SUBQ.W  #1,D0
    BNE.S   .return_zero

    MOVE.B  _ED_DiagTextModeChar,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     _LADFUNC_TAG_RS_ResetTriggerSet
    JSR     _GROUP_AS_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .return_zero

    BSR.W   _LADFUNC_ResetEntryTextBuffers

.return_zero:
    MOVEQ   #0,D0
    BRA.W   .return

.check_entry_prefix:
    MOVEQ   #76,D0
    CMP.B   D0,D7
    BEQ.S   .check_allowed_entry

    MOVEQ   #116,D0
    CMP.B   D0,D7
    BNE.S   .return_zero_local2

.check_allowed_entry:
    MOVE.B  _ED_DiagTextModeChar,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     _LADFUNC_TAG_RS_ParseAllowedSet
    JSR     _GROUP_AS_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .return_zero_local

    MOVEQ   #46,D0
    CMP.B   D0,D5
    BCC.S   .return_zero_local

    MOVE.W  _LADFUNC_ParsedEntryCount,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,_LADFUNC_ParsedEntryCount
    MOVEQ   #46,D0
    CMP.W   D0,D1
    BLT.S   .setup_entry

.return_zero_local:
    MOVEQ   #0,D0
    BRA.W   .return

.setup_entry:
    SUBQ.B  #1,D5
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     _LADFUNC_EntryPtrTable,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A2
    BRA.S   .init_entry_buffers

.return_zero_local2:
    MOVEQ   #0,D0
    BRA.W   .return

.init_entry_buffers:
    MOVE.W  #1,(A2)
    MOVE.W  #$30,2(A2)
    MOVEQ   #0,D6
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     304.W
    PEA     367.W
    PEA     _Global_STR_LADFUNC_C_5
    JSR     _NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-412(A5)
    BEQ.W   .return_zero_local3

.parse_loop:
    MOVE.B  (A3)+,D4
    TST.B   D4
    BEQ.W   .finish_parse

    CMPI.W  #$190,D6
    BGE.W   .finish_parse

    MOVEQ   #3,D0
    CMP.B   D0,D4
    BNE.S   .check_set_fields

    MOVE.B  (A3)+,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   _LADFUNC_ParseHexDigit

    ADDQ.W  #4,A7
    MOVE.L  D0,D4
    MOVEQ   #0,D0
    CMP.B   D0,D4
    BCS.S   .parse_second_nibble

    MOVEQ   #7,D0
    CMP.B   D0,D4
    BHI.S   .parse_second_nibble

    MOVEQ   #0,D0
    MOVE.B  D4,D0
    MOVEQ   #0,D1
    MOVE.B  -413(A5),D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _LADFUNC_SetPackedPenHighNibble

    ADDQ.W  #8,A7
    MOVE.B  D0,-413(A5)

.parse_second_nibble:
    MOVE.B  (A3)+,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   _LADFUNC_ParseHexDigit

    ADDQ.W  #4,A7
    MOVE.L  D0,D4
    MOVEQ   #0,D0
    CMP.B   D0,D4
    BCS.S   .parse_loop

    MOVEQ   #7,D0
    CMP.B   D0,D4
    BHI.S   .parse_loop

    MOVEQ   #0,D0
    MOVE.B  -413(A5),D0
    MOVEQ   #0,D1
    MOVE.B  D4,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _LADFUNC_SetPackedPenLowNibble

    ADDQ.W  #8,A7
    MOVE.B  D0,-413(A5)
    BRA.S   .parse_loop

.check_set_fields:
    MOVEQ   #20,D0
    CMP.B   D0,D4
    BNE.S   .emit_char

    MOVEQ   #0,D0
    MOVE.B  (A3)+,D0
    MOVE.W  D0,(A2)
    MOVEQ   #0,D1
    MOVE.B  (A3)+,D1
    MOVE.W  D1,2(A2)
    MOVE.W  (A2),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     _ESQIFF2_ValidateAsciiNumericByte(PC)

    MOVE.B  D0,D1
    EXT.W   D1
    MOVE.W  D1,(A2)
    MOVE.W  2(A2),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    JSR     _ESQIFF2_ValidateAsciiNumericByte(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,D1
    EXT.W   D1
    MOVE.W  D1,2(A2)
    BRA.W   .parse_loop

.emit_char:
    MOVEA.L -412(A5),A0
    MOVE.B  -413(A5),0(A0,D6.W)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    LEA     -407(A5),A0
    ADDA.W  D0,A0
    MOVE.B  D4,(A0)
    BRA.W   .parse_loop

.finish_parse:
    LEA     -407(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D6,A1
    CLR.B   (A1)
    MOVE.L  6(A2),-(A7)
    MOVE.L  A0,-(A7)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,6(A2)
    TST.L   10(A2)
    BEQ.S   .alloc_attr_buffer

    PEA     304.W
    MOVE.L  10(A2),-(A7)
    PEA     412.W
    PEA     _Global_STR_LADFUNC_C_6
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.alloc_attr_buffer:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     413.W
    PEA     _Global_STR_LADFUNC_C_7
    JSR     _NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,10(A2)
    TST.L   D0
    BEQ.S   .free_temp

    MOVE.L  D6,D1
    EXT.L   D1
    MOVEA.L -412(A5),A0
    MOVEA.L D0,A1
    BRA.S   .copy_attr_next

.copy_attr_loop:
    MOVE.B  (A0)+,(A1)+

.copy_attr_next:
    SUBQ.L  #1,D1
    BCC.S   .copy_attr_loop

.free_temp:
    PEA     304.W
    MOVE.L  -412(A5),-(A7)
    PEA     416.W
    PEA     _Global_STR_LADFUNC_C_8
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    BSR.W   _LADFUNC_UpdateHighlightState

    LEA     16(A7),A7
    BRA.S   .return_one

.return_zero_local3:
    MOVEQ   #0,D0
    BRA.S   .return

.return_one:
    MOVEQ   #1,D0

.return:
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======