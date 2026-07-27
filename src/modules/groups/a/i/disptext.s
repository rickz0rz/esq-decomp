    XDEF    DISPTEXT_AppendToBuffer
    XDEF    _DISPTEXT_BuildLinePointerTable
    XDEF    DISPTEXT_BuildLineWithWidth



;------------------------------------------------------------------------------
; FUNC: DISPTEXT_AppendToBuffer   (Append to display text bufferuncertain)
; ARGS:
;   stack +8: A3 = string pointer
; RET:
;   D0: boolean success (0/-1)
; CLOBBERS:
;   A0/A1/A3/A5/A6/A7/D0/D1/D7
; CALLS:
;   _LVOAvailMem, _GROUP_AG_JMPTBL_MEMORY_AllocateMemory, _GROUP_AI_JMPTBL_STRING_AppendAtNull, _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   _DISPTEXT_TextBufferPtr
; WRITES:
;   _DISPTEXT_TextBufferPtr
; DESC:
;   Appends a string to the global display-text buffer, reallocating if needed.
; NOTES:
;   Booleanize pattern: SNE/NEG/EXT.
;------------------------------------------------------------------------------
DISPTEXT_AppendToBuffer:
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    CLR.L   -8(A5)
    TST.L   _DISPTEXT_TextBufferPtr
    BEQ.W   .alloc_new_buffer

    MOVEA.L _DISPTEXT_TextBufferPtr,A0

.find_end_dst:
    TST.B   (A0)+
    BNE.S   .find_end_dst

    SUBQ.L  #1,A0
    SUBA.L  _DISPTEXT_TextBufferPtr,A0
    MOVEA.L A3,A1

.find_end_src:
    TST.B   (A1)+
    BNE.S   .find_end_src

    SUBQ.L  #1,A1
    SUBA.L  A3,A1
    MOVE.L  A0,D0
    MOVE.L  A1,D1
    ADD.L   D1,D0
    MOVE.L  D0,D7
    ADDQ.L  #1,D7
    MOVEQ   #1,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAvailMem(A6)

    CMPI.L  #$2710,D0
    BLE.S   .realloc_buffer

    PEA     (MEMF_PUBLIC).W
    MOVE.L  D7,-(A7)
    PEA     127.W
    PEA     _Global_STR_DISPTEXT_C_1
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)

.realloc_buffer:
    TST.L   -8(A5)
    BEQ.S   .return_status

    MOVEA.L _DISPTEXT_TextBufferPtr,A0
    MOVEA.L -8(A5),A1

.copy_old_buffer:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_old_buffer

    MOVE.L  A3,-(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    MOVE.L  _DISPTEXT_TextBufferPtr,(A7)
    CLR.L   -(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     12(A7),A7
    MOVEA.L -8(A5),A0
    MOVE.L  A0,_DISPTEXT_TextBufferPtr
    BRA.S   .return_status

.alloc_new_buffer:
    MOVE.L  _DISPTEXT_TextBufferPtr,-(A7)
    MOVE.L  A3,-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_DISPTEXT_TextBufferPtr

.return_status:
    TST.L   _DISPTEXT_TextBufferPtr
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_BuildLineWithWidth   (Format text into line buffer with width constraintuncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
;   stack +69: arg_5 (via 73(A5))
; RET:
;   D0: updated A2 (next source position)
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   _LVOTextLength, _GROUP_AI_JMPTBL_STRING_AppendAtNull, GROUP_AI_JMPTBL_STR_SkipClass3Chars, GROUP_AI_JMPTBL_STR_CopyUntilAnyDelimN
; READS:
;   DISPTEXT_STR_SINGLE_SPACE_MEASURE..DISPTEXT_STR_SINGLE_SPACE_DELIM, _DISPTEXT_CurrentLineIndex/21D9/21DA/21DC
; WRITES:
;   output buffer, _DISPTEXT_ControlMarkersEnabledFlag
; DESC:
;   Builds a line from the source string, inserting separators and trimming to fit.
; NOTES:
;   Uses 0x13/0x12 separators (see data tables).
;------------------------------------------------------------------------------
DISPTEXT_BuildLineWithWidth:
    LINK.W  A5,#-76
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  20(A5),D7
    MOVEA.L A3,A1
    LEA     DISPTEXT_STR_SINGLE_SPACE_MEASURE,A0
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVEA.L 16(A5),A0
    CLR.B   (A0)
    MOVE.L  D0,-16(A5)

.line_loop:
    MOVE.L  A2,D0
    BEQ.W   .done

    TST.B   (A2)
    BEQ.W   .done

    CMP.L   -16(A5),D7
    BLE.W   .done

    MOVEA.L 16(A5),A0
    TST.B   (A0)
    BEQ.S   .append_separator

    PEA     DISPTEXT_STR_SINGLE_SPACE_APPEND
    MOVE.L  A0,-(A7)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    SUB.L   -16(A5),D7

.append_separator:
    MOVE.L  A2,-(A7)
    JSR     GROUP_AI_JMPTBL_STR_SkipClass3Chars(PC)

    MOVEA.L D0,A2
    MOVE.L  A2,-20(A5)
    PEA     DISPTEXT_STR_SINGLE_SPACE_DELIM
    PEA     50.W
    PEA     -73(A5)
    MOVE.L  A2,-(A7)
    JSR     GROUP_AI_JMPTBL_STR_CopyUntilAnyDelimN(PC)

    LEA     20(A7),A7
    MOVEA.L D0,A2
    LEA     -73(A5),A0
    MOVEA.L A0,A1

.measure_word:
    TST.B   (A1)+
    BNE.S   .measure_word

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D6
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5
    MOVEA.L -20(A5),A0
    MOVE.B  (A0),D0
    MOVEQ   #19,D1
    CMP.B   D1,D0
    BNE.S   .measure_adjust

    ADDQ.L  #8,D5

.measure_adjust:
    CMP.L   D7,D5
    BLE.S   .append_word

    MOVE.W  _DISPTEXT_CurrentLineIndex,D2
    MOVEQ   #2,D3
    CMP.W   D3,D2
    BCC.S   .set_separator_width

    MOVE.L  _DISPTEXT_ControlMarkerWidthPx,D2
    BRA.S   .compute_remaining_width

.set_separator_width:
    MOVEQ   #0,D2

.compute_remaining_width:
    MOVE.L  _DISPTEXT_LineWidthPx,D3
    SUB.L   D2,D3
    MOVE.L  D3,D4
    CMP.L   D4,D5
    BLE.S   .skip_word

    CMP.B   D1,D0
    BEQ.W   .line_loop

.shrink_word:
    CMP.L   D7,D5
    BLE.S   .emit_word

    TST.L   D6
    BLE.S   .emit_word

    SUBQ.L  #1,D6
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    LEA     -73(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5
    BRA.S   .shrink_word

.emit_word:
    TST.L   D6
    BLE.S   .advance_source

    CLR.B   -73(A5,D6.L)
    PEA     -73(A5)
    MOVE.L  16(A5),-(A7)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.advance_source:
    MOVEA.L -20(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D6,A1
    MOVEA.L A1,A2
    MOVEQ   #0,D7
    BRA.W   .line_loop

.skip_word:
    MOVEA.L -20(A5),A2
    MOVEQ   #0,D7
    BRA.W   .line_loop

.append_word:
    PEA     -73(A5)
    MOVE.L  16(A5),-(A7)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    SUB.L   D5,D7
    MOVEQ   #19,D1
    MOVEA.L -20(A5),A0
    CMP.B   (A0),D1
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.W  _DISPTEXT_ControlMarkersEnabledFlag,D1
    EXT.L   D1
    OR.L    D0,D1
    MOVE.W  D1,_DISPTEXT_ControlMarkersEnabledFlag
    BRA.W   .line_loop

.done:
    TST.B   (A2)
    BNE.S   .null_out

    SUBA.L  A2,A2

.null_out:
    MOVE.L  A2,D0
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: _DISPTEXT_BuildLinePointerTable   (Build display line pointer tableuncertain)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A7/D0/D1/D5/D6/D7
; CALLS:
;   none
; READS:
;   _DISPTEXT_TextBufferPtr/21D4/21D6/21D7/21DB
; WRITES:
;   _DISPTEXT_LinePtrTable, _DISPTEXT_LineTableLockFlag
; DESC:
;   Builds per-line pointer table based on offsets when not locked.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISPTEXT_BuildLinePointerTable:
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVE.L  24(A7),D7
    TST.L   _DISPTEXT_LineTableLockFlag
    BNE.S   .return

    MOVE.L  _DISPTEXT_TextBufferPtr,_DISPTEXT_LinePtrTable
    MOVEQ   #0,D0
    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    ADD.L   D0,D0
    LEA     _DISPTEXT_LineLengthTable,A0
    ADDA.L  D0,A0
    TST.W   (A0)
    BEQ.S   .has_header_line

    MOVEQ   #1,D0
    BRA.S   .init_line_count

.has_header_line:
    MOVEQ   #0,D0

.init_line_count:
    MOVEQ   #0,D1
    MOVE.W  _DISPTEXT_CurrentLineIndex,D1
    ADD.L   D0,D1
    MOVE.L  D1,D5
    MOVEQ   #1,D6

.build_ptrs_loop:
    CMP.L   D5,D6
    BGE.S   .set_locked

    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     _DISPTEXT_LinePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     _DISPTEXT_TextBufferPtr,A1
    ADDA.L  D0,A1
    MOVE.L  D6,D0
    ADD.L   D0,D0
    LEA     _DISPTEXT_CurrentLineIndex,A2
    ADDA.L  D0,A2
    MOVEA.L (A1),A3
    MOVEQ   #0,D0
    MOVE.W  (A2),D0
    ADDA.L  D0,A3
    MOVE.L  A3,(A0)
    ADDQ.L  #1,D6
    BRA.S   .build_ptrs_loop

.set_locked:
    MOVE.L  D7,_DISPTEXT_LineTableLockFlag

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3
    RTS

;!======