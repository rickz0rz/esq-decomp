    XDEF    DISPTEXT_AppendToBuffer
    XDEF    DISPTEXT_BuildLayoutForSource
    XDEF    DISPTEXT_BuildLinePointerTable
    XDEF    DISPTEXT_BuildLineWithWidth
    XDEF    DISPTEXT_ComputeMarkerWidths
    XDEF    DISPTEXT_ComputeVisibleLineCount
    XDEF    DISPTEXT_FinalizeLineTable
    XDEF    DISPTEXT_FreeBuffers
    XDEF    DISPTEXT_GetTotalLineCount
    XDEF    DISPTEXT_HasMultipleLines
    XDEF    DISPTEXT_InitBuffers
    XDEF    DISPTEXT_IsCurrentLineLast
    XDEF    DISPTEXT_IsLastLineSelected
    XDEF    DISPTEXT_LayoutAndAppendToBuffer
    XDEF    DISPTEXT_LayoutSourceToLines
    XDEF    DISPTEXT_MeasureCurrentLineLength
    XDEF    DISPTEXT_RenderCurrentLine
    XDEF    DISPTEXT_SetCurrentLineIndex
    XDEF    DISPTEXT_SetLayoutParams

;------------------------------------------------------------------------------
; FUNC: DISPTEXT_AppendToBuffer   (Append to display text bufferuncertain)
; ARGS:
;   stack +8: A3 = string pointer
; RET:
;   D0: boolean success (0/-1)
; CLOBBERS:
;   A0/A1/A3/A5/A6/A7/D0/D1/D7
; CALLS:
;   _LVOAvailMem, GROUP_AG_JMPTBL_MEMORY_AllocateMemory, GROUP_AI_JMPTBL_STRING_AppendAtNull, GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   DISPTEXT_TextBufferPtr
; WRITES:
;   DISPTEXT_TextBufferPtr
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
    TST.L   DISPTEXT_TextBufferPtr
    BEQ.W   .alloc_new_buffer

    MOVEA.L DISPTEXT_TextBufferPtr,A0

.find_end_dst:
    TST.B   (A0)+
    BNE.S   .find_end_dst

    SUBQ.L  #1,A0
    SUBA.L  DISPTEXT_TextBufferPtr,A0
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
    PEA     Global_STR_DISPTEXT_C_1
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)

.realloc_buffer:
    TST.L   -8(A5)
    BEQ.S   .return_status

    MOVEA.L DISPTEXT_TextBufferPtr,A0
    MOVEA.L -8(A5),A1

.copy_old_buffer:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_old_buffer

    MOVE.L  A3,-(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    MOVE.L  DISPTEXT_TextBufferPtr,(A7)
    CLR.L   -(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     12(A7),A7
    MOVEA.L -8(A5),A0
    MOVE.L  A0,DISPTEXT_TextBufferPtr
    BRA.S   .return_status

.alloc_new_buffer:
    MOVE.L  DISPTEXT_TextBufferPtr,-(A7)
    MOVE.L  A3,-(A7)
    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,DISPTEXT_TextBufferPtr

.return_status:
    TST.L   DISPTEXT_TextBufferPtr
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
;   _LVOTextLength, GROUP_AI_JMPTBL_STRING_AppendAtNull, GROUP_AI_JMPTBL_STR_SkipClass3Chars, GROUP_AI_JMPTBL_STR_CopyUntilAnyDelimN
; READS:
;   DISPTEXT_STR_SINGLE_SPACE_MEASURE..DISPTEXT_STR_SINGLE_SPACE_DELIM, DISPTEXT_CurrentLineIndex/21D9/21DA/21DC
; WRITES:
;   output buffer, DISPTEXT_ControlMarkersEnabledFlag
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
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

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

    MOVE.W  DISPTEXT_CurrentLineIndex,D2
    MOVEQ   #2,D3
    CMP.W   D3,D2
    BCC.S   .set_separator_width

    MOVE.L  DATA_WDISP_BSS_LONG_21DA,D2
    BRA.S   .compute_remaining_width

.set_separator_width:
    MOVEQ   #0,D2

.compute_remaining_width:
    MOVE.L  DISPTEXT_LineWidthPx,D3
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
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

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
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    SUB.L   D5,D7
    MOVEQ   #19,D1
    MOVEA.L -20(A5),A0
    CMP.B   (A0),D1
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.W  DISPTEXT_ControlMarkersEnabledFlag,D1
    EXT.L   D1
    OR.L    D0,D1
    MOVE.W  D1,DISPTEXT_ControlMarkersEnabledFlag
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
; FUNC: DISPTEXT_BuildLinePointerTable   (Build display line pointer tableuncertain)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A7/D0/D1/D5/D6/D7
; CALLS:
;   none
; READS:
;   DISPTEXT_TextBufferPtr/21D4/21D6/21D7/21DB
; WRITES:
;   DISPTEXT_LinePtrTable, DISPTEXT_LineTableLockFlag
; DESC:
;   Builds per-line pointer table based on offsets when not locked.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISPTEXT_BuildLinePointerTable:
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVE.L  24(A7),D7
    TST.L   DISPTEXT_LineTableLockFlag
    BNE.S   .return

    MOVE.L  DISPTEXT_TextBufferPtr,DISPTEXT_LinePtrTable
    MOVEQ   #0,D0
    MOVE.W  DISPTEXT_CurrentLineIndex,D0
    ADD.L   D0,D0
    LEA     DISPTEXT_LineLengthTable,A0
    ADDA.L  D0,A0
    TST.W   (A0)
    BEQ.S   .has_header_line

    MOVEQ   #1,D0
    BRA.S   .init_line_count

.has_header_line:
    MOVEQ   #0,D0

.init_line_count:
    MOVEQ   #0,D1
    MOVE.W  DISPTEXT_CurrentLineIndex,D1
    ADD.L   D0,D1
    MOVE.L  D1,D5
    MOVEQ   #1,D6

.build_ptrs_loop:
    CMP.L   D5,D6
    BGE.S   .set_locked

    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     DISPTEXT_LinePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     DISPTEXT_TextBufferPtr,A1
    ADDA.L  D0,A1
    MOVE.L  D6,D0
    ADD.L   D0,D0
    LEA     DISPTEXT_CurrentLineIndex,A2
    ADDA.L  D0,A2
    MOVEA.L (A1),A3
    MOVEQ   #0,D0
    MOVE.W  (A2),D0
    ADDA.L  D0,A3
    MOVE.L  A3,(A0)
    ADDQ.L  #1,D6
    BRA.S   .build_ptrs_loop

.set_locked:
    MOVE.L  D7,DISPTEXT_LineTableLockFlag

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_FinalizeLineTable   (Finalize pending line tableuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0/D1
; CALLS:
;   DISPTEXT_BuildLinePointerTable
; READS:
;   DISPTEXT_LineTableLockFlag, DISPTEXT_CurrentLineIndex, DISPTEXT_LineLengthTable
; WRITES:
;   DISPTEXT_TargetLineIndex, DISPTEXT_CurrentLineIndex
; DESC:
;   Ensures line table state is current and clears DISPTEXT_CurrentLineIndex when needed.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISPTEXT_FinalizeLineTable:
    TST.L   DISPTEXT_LineTableLockFlag
    BNE.S   .return

    MOVE.W  DISPTEXT_CurrentLineIndex,D0
    MOVE.W  D0,DISPTEXT_TargetLineIndex
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADD.L   D1,D1
    LEA     DISPTEXT_LineLengthTable,A0
    ADDA.L  D1,A0
    TST.W   (A0)
    BEQ.S   .check_extra_line

    ADDQ.W  #1,D0
    MOVE.W  D0,DISPTEXT_TargetLineIndex

.check_extra_line:
    PEA     1.W
    BSR.W   DISPTEXT_BuildLinePointerTable

    ADDQ.W  #4,A7
    CLR.W   DISPTEXT_CurrentLineIndex

.return:
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_InitBuffers   (Initialize disptext buffers)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7
; CALLS:
;   DISPLIB_ResetLineTables, GROUP_AG_JMPTBL_MEMORY_AllocateMemory
; READS:
;   DISPTEXT_InitBuffersPending
; WRITES:
;   DISPTEXT_TextBufferPtr, DISPTEXT_InitBuffersPending, Global_REF_1000_BYTES_ALLOCATED_1/2
; DESC:
;   Allocates working buffers for display text if initialization flag set.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISPTEXT_InitBuffers:
    TST.L   DISPTEXT_InitBuffersPending
    BEQ.S   .return

    CLR.L   DISPTEXT_TextBufferPtr
    BSR.W   DISPLIB_ResetLineTables

    CLR.L   DISPTEXT_InitBuffersPending

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     1000.W
    PEA     320.W
    PEA     Global_STR_DISPTEXT_C_2
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    PEA     1000.W
    PEA     321.W
    PEA     Global_STR_DISPTEXT_C_3
    MOVE.L  D0,Global_REF_1000_BYTES_ALLOCATED_1
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     28(A7),A7
    MOVE.L  D0,Global_REF_1000_BYTES_ALLOCATED_2

.return:
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_FreeBuffers   (Free disptext buffers)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7
; CALLS:
;   DISPLIB_ResetTextBufferAndLineTables, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   Global_REF_1000_BYTES_ALLOCATED_1/2
; WRITES:
;   Global_REF_1000_BYTES_ALLOCATED_1/2
; DESC:
;   Releases the 1000-byte buffers used by display text.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISPTEXT_FreeBuffers:
    BSR.W   DISPLIB_ResetTextBufferAndLineTables

    TST.L   Global_REF_1000_BYTES_ALLOCATED_1
    BEQ.S   .freeSecondBlock

    PEA     1000.W
    MOVE.L  Global_REF_1000_BYTES_ALLOCATED_1,-(A7)
    PEA     338.W
    PEA     Global_STR_DISPTEXT_C_4
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    CLR.L   Global_REF_1000_BYTES_ALLOCATED_1

.freeSecondBlock:
    TST.L   Global_REF_1000_BYTES_ALLOCATED_2
    BEQ.S   .return

    PEA     1000.W
    MOVE.L  Global_REF_1000_BYTES_ALLOCATED_2,-(A7)
    PEA     343.W
    PEA     Global_STR_DISPTEXT_C_5
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    CLR.L   Global_REF_1000_BYTES_ALLOCATED_2

.return:
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_SetLayoutParams   (Set display layout paramsuncertain)
; ARGS:
;   (none observed)
; RET:
;   D0: 1 if applied, 0 if clamped/no change
; CLOBBERS:
;   A7/D0/D5/D6/D7
; CALLS:
;   DISPLIB_ResetTextBufferAndLineTables, DISPLIB_CommitCurrentLinePenAndAdvance
; READS:
;   DISPTEXT_LineWidthPx, DISPTEXT_TargetLineIndex
; WRITES:
;   DISPTEXT_LineWidthPx, DISPTEXT_TargetLineIndex
; DESC:
;   Updates layout parameters and returns whether the requested values matched.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISPTEXT_SetLayoutParams:
    MOVEM.L D5-D7,-(A7)
    MOVE.L  16(A7),D7
    MOVE.L  20(A7),D6
    MOVE.L  24(A7),D5
    BSR.W   DISPLIB_ResetTextBufferAndLineTables

    TST.L   D7
    BMI.S   .clamp_width

    CMPI.L  #624,D7
    BGT.S   .clamp_width

    MOVE.L  D7,DISPTEXT_LineWidthPx

.clamp_width:
    TST.L   D6
    BLE.S   .clamp_lines

    MOVEQ   #20,D0
    CMP.L   D0,D6
    BGT.S   .clamp_lines

    MOVE.L  D6,D0
    MOVE.W  D0,DISPTEXT_TargetLineIndex

.clamp_lines:
    MOVE.L  D5,-(A7)
    BSR.W   DISPLIB_CommitCurrentLinePenAndAdvance

    ADDQ.W  #4,A7
    MOVE.L  DISPTEXT_LineWidthPx,D0
    CMP.L   D7,D0
    BNE.S   .mismatch

    MOVEQ   #0,D0
    MOVE.W  DISPTEXT_TargetLineIndex,D0
    CMP.L   D6,D0
    BNE.S   .mismatch

    MOVEQ   #1,D0
    BRA.S   .done

.mismatch:
    MOVEQ   #0,D0

.done:
    MOVEM.L (A7)+,D5-D7
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_ComputeMarkerWidths   (Compute padding widthsuncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A6/A7/D0/D4/D5/D6/D7
; CALLS:
;   GROUP_AI_JMPTBL_NEWGRID_SetSelectionMarkers, _LVOTextLength
; READS:
;   DATA_WDISP_BSS_LONG_21DA
; WRITES:
;   DATA_WDISP_BSS_LONG_21DA
; DESC:
;   Computes combined text lengths for two optional markers and stores in DATA_WDISP_BSS_LONG_21DA.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISPTEXT_ComputeMarkerWidths:
    LINK.W  A5,#-12
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    PEA     -4(A5)
    PEA     -3(A5)
    PEA     -2(A5)
    PEA     -1(A5)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    JSR     GROUP_AI_JMPTBL_NEWGRID_SetSelectionMarkers(PC)

    LEA     24(A7),A7
    TST.B   -1(A5)
    BEQ.S   .no_prefix1

    MOVEA.L A3,A1
    LEA     -1(A5),A0
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    BRA.S   .check_prefix2

.no_prefix1:
    MOVEQ   #0,D0

.check_prefix2:
    MOVE.L  D0,D5
    TST.B   -3(A5)
    BEQ.S   .no_prefix2

    MOVEA.L A3,A1
    LEA     -3(A5),A0
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    BRA.S   .store_combined

.no_prefix2:
    MOVEQ   #0,D0

.store_combined:
    MOVE.L  D0,D4
    MOVE.L  D5,D0
    ADD.L   D4,D0
    MOVE.L  D0,DATA_WDISP_BSS_LONG_21DA
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_LayoutSourceToLines   (Layout source text into lines)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +264: arg_3 (via 268(A5))
; RET:
;   D0: boolean success (0/-1)
; CLOBBERS:
;   A0/A1/A2/A3/A6/A7/D0/D1/D2/D5/D6/D7
; CALLS:
;   DISPTEXT_BuildLineWithWidth, _LVOTextLength
; READS:
;   DISPTEXT_TextBufferPtr/21D4/21D5/21D6/21D7/21D9/21DA/21DB
; WRITES:
;   DISPTEXT_CurrentLineIndex
; DESC:
;   Iterates over lines, measuring and formatting text into the line buffer.
; NOTES:
;   Uses line offset tables DISPTEXT_LinePtrTable/DISPTEXT_LineLengthTable.
;------------------------------------------------------------------------------
DISPTEXT_LayoutSourceToLines:
    LINK.W  A5,#-276
    MOVEM.L D2/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEQ   #0,D7
    TST.L   DISPTEXT_LineTableLockFlag
    BNE.W   .return_status

    MOVE.W  DISPTEXT_CurrentLineIndex,D0
    MOVE.W  DISPTEXT_TargetLineIndex,D1
    CMP.W   D1,D0
    BCC.W   .return_status

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADD.L   D1,D1
    LEA     DISPTEXT_LineLengthTable,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    TST.W   (A1)
    BEQ.S   .no_prefix_line

    MOVEQ   #0,D2
    MOVE.W  D0,D2
    ASL.L   #2,D2
    LEA     DISPTEXT_LinePtrTable,A1
    ADDA.L  D2,A1
    ADDA.L  D1,A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    MOVE.L  A1,28(A7)
    MOVEA.L A3,A1
    MOVEA.L 28(A7),A0
    MOVEA.L (A0),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  DISPTEXT_LineWidthPx,D1
    MOVE.L  D1,D2
    SUB.L   D0,D2
    MOVE.L  D2,D6
    BRA.S   .adjust_for_prefix

.no_prefix_line:
    MOVE.L  DISPTEXT_LineWidthPx,D6

.adjust_for_prefix:
    MOVE.W  DISPTEXT_CurrentLineIndex,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCC.S   .maybe_subtract_markers

    SUB.L   DATA_WDISP_BSS_LONG_21DA,D6

.maybe_subtract_markers:
    MOVEQ   #0,D2
    MOVE.W  D0,D2
    ADD.L   D2,D2
    LEA     DISPTEXT_LineLengthTable,A0
    ADDA.L  D2,A0
    TST.W   (A0)
    BEQ.S   .try_build_line

    MOVEA.L A3,A1
    LEA     DISPTEXT_STR_SINGLE_SPACE_PREFIX_1,A0
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5
    CMP.L   D5,D6
    BLE.S   .reset_width_for_next

    SUB.L   D5,D6
    BRA.S   .try_build_line

.reset_width_for_next:
    ADDQ.L  #1,D7
    MOVEQ   #0,D0
    MOVE.W  DISPTEXT_CurrentLineIndex,D0
    ADD.L   D7,D0
    MOVEQ   #0,D1
    MOVE.W  DISPTEXT_TargetLineIndex,D1
    CMP.L   D1,D0
    BGE.S   .try_build_line

    MOVE.L  DISPTEXT_LineWidthPx,D6

.try_build_line:
    MOVE.L  A2,D0
    BEQ.S   .return_status

    TST.B   (A2)
    BEQ.S   .return_status

    MOVEQ   #0,D0
    MOVE.W  DISPTEXT_CurrentLineIndex,D0
    ADD.L   D7,D0
    MOVEQ   #0,D1
    MOVE.W  DISPTEXT_TargetLineIndex,D1
    CMP.L   D1,D0
    BGE.S   .return_status

    MOVE.L  D6,-(A7)
    PEA     -268(A5)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   DISPTEXT_BuildLineWithWidth

    LEA     16(A7),A7
    MOVEA.L D0,A2
    MOVE.L  DISPTEXT_LineWidthPx,D6
    MOVE.W  DISPTEXT_CurrentLineIndex,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCC.S   .after_build_line

    SUB.L   DATA_WDISP_BSS_LONG_21DA,D6

.after_build_line:
    MOVE.L  A2,D0
    BEQ.S   .try_build_line

    ADDQ.L  #1,D7
    BRA.S   .try_build_line

.return_status:
    MOVE.L  A2,D1
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVEM.L (A7)+,D2/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_LayoutAndAppendToBuffer   (Layout and append into output buffer)
; ARGS:
;   stack +4: A3 = target RastPort/context pointer
;   stack +8: A2 = source text pointer
;   stack +264: arg_3 ?? (frame-local forwarding)
; RET:
;   D0: boolean success (0/-1)
; CLOBBERS:
;   A0/A1/A2/A3/A6/A7/D0/D1/D2/D5/D6/D7
; CALLS:
;   DISPTEXT_BuildLineWithWidth, DISPLIB_CommitCurrentLinePenAndAdvance, GROUP_AI_JMPTBL_STRING_AppendAtNull, _LVOTextLength
; READS:
;   DISPTEXT_TextBufferPtr/21D4/21D5/21D6/21D7/21D8/21D9/21DA/21DB
; WRITES:
;   DISPTEXT_CurrentLineIndex, DISPTEXT_LineLengthTable, Global_REF_1000_BYTES_ALLOCATED_2
; DESC:
;   Builds line segments into the scratch buffer and appends to global text.
; NOTES:
;   Returns early if source text pointer is NULL or points at an empty string.
;------------------------------------------------------------------------------
DISPTEXT_LayoutAndAppendToBuffer:
    LINK.W  A5,#-276
    MOVEM.L D2/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    TST.L   DISPTEXT_LineTableLockFlag
    BNE.W   .return_status

    MOVE.W  DISPTEXT_CurrentLineIndex,D0
    MOVE.W  DISPTEXT_TargetLineIndex,D1
    CMP.W   D1,D0
    BCC.W   .return_status

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADD.L   D1,D1
    LEA     DISPTEXT_LineLengthTable,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    TST.W   (A1)
    BEQ.S   .no_prefix_line

    MOVEQ   #0,D2
    MOVE.W  D0,D2
    ASL.L   #2,D2
    LEA     DISPTEXT_LinePtrTable,A1
    ADDA.L  D2,A1
    ADDA.L  D1,A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    MOVE.L  A1,28(A7)
    MOVEA.L A3,A1
    MOVEA.L 28(A7),A0
    MOVEA.L (A0),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  DISPTEXT_LineWidthPx,D1
    MOVE.L  D1,D2
    SUB.L   D0,D2
    MOVE.L  D2,D7
    BRA.S   .adjust_for_prefix

.no_prefix_line:
    MOVE.L  DISPTEXT_LineWidthPx,D7

.adjust_for_prefix:
    MOVE.W  DISPTEXT_CurrentLineIndex,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCC.S   .init_scratch

    SUB.L   DATA_WDISP_BSS_LONG_21DA,D7

.init_scratch:
    MOVEA.L Global_REF_1000_BYTES_ALLOCATED_2,A0
    CLR.B   (A0)
    MOVEQ   #0,D0
    MOVE.W  DISPTEXT_CurrentLineIndex,D0
    ADD.L   D0,D0
    LEA     DISPTEXT_LineLengthTable,A1
    ADDA.L  D0,A1
    TST.W   (A1)
    BEQ.S   .line_loop

    MOVEA.L A3,A1
    LEA     DISPTEXT_STR_SINGLE_SPACE_PREFIX_2,A0
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D6
    CMP.L   D6,D7
    BLE.S   .fallback_layout

    LEA     DISPTEXT_STR_SINGLE_SPACE_COPY_PREFIX,A0
    MOVEA.L Global_REF_1000_BYTES_ALLOCATED_2,A1

.copy_prefix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_prefix

    SUB.L   D6,D7
    MOVEQ   #0,D0
    MOVE.W  DISPTEXT_CurrentLineIndex,D0
    ADD.L   D0,D0
    LEA     DISPTEXT_LineLengthTable,A0
    ADDA.L  D0,A0
    ADDQ.W  #1,(A0)
    BRA.S   .line_loop

.fallback_layout:
    MOVEQ   #0,D0
    MOVE.W  DISPTEXT_CurrentLineIndex,D0
    ASL.L   #2,D0
    LEA     DISPTEXT_LinePenTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    BSR.W   DISPLIB_CommitCurrentLinePenAndAdvance

    ADDQ.W  #4,A7
    MOVE.W  DISPTEXT_CurrentLineIndex,D0
    MOVE.W  DISPTEXT_TargetLineIndex,D1
    CMP.W   D1,D0
    BCC.S   .line_loop

    MOVE.L  DISPTEXT_LineWidthPx,D7

.line_loop:
    ; Guard source pointer before probing bytes.
    MOVE.L  A2,D0
    BEQ.W   .flush_remaining

    ; Empty string also exits through flush path.
    TST.B   (A2)
    BEQ.W   .flush_remaining

    MOVE.W  DISPTEXT_CurrentLineIndex,D0
    MOVE.W  DISPTEXT_TargetLineIndex,D1
    CMP.W   D1,D0
    BCC.W   .flush_remaining

    MOVE.L  D7,-(A7)
    PEA     -268(A5)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   DISPTEXT_BuildLineWithWidth

    MOVEA.L D0,A2
    LEA     -268(A5),A0
    MOVEA.L A0,A1

.append_scratch:
    TST.B   (A1)+
    BNE.S   .append_scratch

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D5
    MOVE.L  A0,(A7)
    MOVE.L  Global_REF_1000_BYTES_ALLOCATED_2,-(A7)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D0
    MOVE.W  DISPTEXT_CurrentLineIndex,D0
    ADD.L   D0,D0
    LEA     DISPTEXT_LineLengthTable,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    MOVE.L  D0,D1
    ADD.L   D5,D1
    MOVE.W  D1,(A0)
    MOVE.L  DISPTEXT_LineWidthPx,D7
    MOVE.W  DISPTEXT_CurrentLineIndex,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCC.S   .after_append

    SUB.L   DATA_WDISP_BSS_LONG_21DA,D7

.after_append:
    MOVE.L  A2,D1
    BEQ.W   .line_loop

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ASL.L   #2,D1
    LEA     DISPTEXT_LinePenTable,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-(A7)
    BSR.W   DISPLIB_CommitCurrentLinePenAndAdvance

    ADDQ.W  #4,A7
    BRA.W   .line_loop

.flush_remaining:
    MOVEA.L Global_REF_1000_BYTES_ALLOCATED_2,A0
    TST.B   (A0)
    BEQ.S   .return_status

    MOVE.L  A0,-(A7)
    BSR.W   DISPTEXT_AppendToBuffer

    CLR.L   (A7)
    BSR.W   DISPTEXT_BuildLinePointerTable

    ADDQ.W  #4,A7

.return_status:
    MOVE.L  A2,D1
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVEM.L (A7)+,D2/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_BuildLayoutForSource   (Build layout for a source string)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
; RET:
;   D0: boolean success
; CLOBBERS:
;   A0/A3/A5/A7/D0/D7
; CALLS:
;   GROUP_AI_JMPTBL_FORMAT_FormatToBuffer2, DISPTEXT_LayoutAndAppendToBuffer
; READS:
;   DISPTEXT_LineTableLockFlag, Global_REF_1000_BYTES_ALLOCATED_1
; WRITES:
;   Global_REF_1000_BYTES_ALLOCATED_1 (via GROUP_AI_JMPTBL_FORMAT_FormatToBuffer2)
; DESC:
;   Prepares output buffer and runs layout; returns success flag.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISPTEXT_BuildLayoutForSource:
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D7
    TST.L   DISPTEXT_LineTableLockFlag
    BNE.S   .return_status

    LEA     16(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  12(A5),-(A7)
    MOVE.L  Global_REF_1000_BYTES_ALLOCATED_1,-(A7)
    MOVE.L  A0,-8(A5)
    JSR     GROUP_AI_JMPTBL_FORMAT_FormatToBuffer2(PC)

    MOVE.L  Global_REF_1000_BYTES_ALLOCATED_1,(A7)
    MOVE.L  A3,-(A7)
    BSR.W   DISPTEXT_LayoutAndAppendToBuffer

    LEA     16(A7),A7
    MOVE.L  D0,D7

.return_status:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_SetCurrentLineIndex   (Set current line index)
; ARGS:
;   stack +8: D7 = line index (1..3)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   DISPLIB_CommitCurrentLinePenAndAdvance
; READS:
;   DISPTEXT_LineTableLockFlag
; WRITES:
;   (via DISPLIB_CommitCurrentLinePenAndAdvance)
; DESC:
;   Updates current line selection if valid and not locked.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISPTEXT_SetCurrentLineIndex:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    TST.L   DISPTEXT_LineTableLockFlag
    BNE.S   .return

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BLT.S   .return

    MOVEQ   #3,D0
    CMP.L   D0,D7
    BGT.S   .return

    MOVE.L  D7,-(A7)
    BSR.W   DISPLIB_CommitCurrentLinePenAndAdvance

    ADDQ.W  #4,A7

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_ComputeVisibleLineCount   (Compute visible line countuncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: line count or offset
; CLOBBERS:
;   A0/A1/A5/A7/D0/D1/D5/D6/D7
; CALLS:
;   DISPTEXT_FinalizeLineTable, GROUP_AG_JMPTBL_MATH_Mulu32, GROUP_AI_JMPTBL_STR_FindCharPtr
; READS:
;   DISPTEXT_TargetLineIndex/21D6/21DC/21D3, NEWGRID_RowHeightPx
; WRITES:
;   (none observed)
; DESC:
;   Computes a derived line count with optional prefix adjustments.
; NOTES:
;   Uses booleanize pattern on DISPTEXT_ControlMarkersEnabledFlag.
;------------------------------------------------------------------------------
DISPTEXT_ComputeVisibleLineCount:
    LINK.W  A5,#-12
    MOVEM.L D5-D7,-(A7)
    MOVE.L  8(A5),D7
    BSR.W   DISPTEXT_FinalizeLineTable

    MOVEQ   #0,D0
    MOVE.W  DISPTEXT_TargetLineIndex,D0
    CMP.L   D7,D0
    BGE.S   .line_index_ok

    MOVE.L  D7,D1
    BRA.S   .use_max_lines

.line_index_ok:
    MOVEQ   #0,D1
    MOVE.W  D0,D1

.use_max_lines:
    MOVE.L  D1,D6
    MOVEQ   #0,D1
    MOVE.W  NEWGRID_RowHeightPx,D1
    MOVE.L  D6,D0
    JSR     GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    TST.L   D0
    BPL.S   .add_leading

    ADDQ.L  #3,D0

.add_leading:
    ASR.L   #2,D0
    MOVE.L  D0,D5
    MOVEQ   #1,D0
    CMP.L   D0,D6
    BNE.S   .no_leading

    MOVEQ   #2,D0
    BRA.S   .apply_leading

.no_leading:
    MOVEQ   #0,D0

.apply_leading:
    ADD.L   D0,D5
    TST.W   DISPTEXT_ControlMarkersEnabledFlag
    BEQ.S   .return

    MOVE.W  DISPTEXT_TargetLineIndex,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ASL.L   #2,D1
    LEA     DISPTEXT_TextBufferPtr,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-12(A5)
    BEQ.S   .return

    PEA     19.W
    MOVE.L  A1,-(A7)
    JSR     GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .return

    PEA     20.W
    MOVE.L  -12(A5),-(A7)
    JSR     GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .return

    ADDQ.L  #2,D5

.return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_GetTotalLineCount   (Get total line count)
; ARGS:
;   (none)
; RET:
;   D0: DISPTEXT_TargetLineIndex
; CLOBBERS:
;   D0
; CALLS:
;   DISPTEXT_FinalizeLineTable
; READS:
;   DISPTEXT_TargetLineIndex
; WRITES:
;   (none observed)
; DESC:
;   Returns the total number of lines after ensuring state is current.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISPTEXT_GetTotalLineCount:
    BSR.W   DISPTEXT_FinalizeLineTable

    MOVEQ   #0,D0
    MOVE.W  DISPTEXT_TargetLineIndex,D0
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_HasMultipleLines   (Has multiple linesuncertain)
; ARGS:
;   (none)
; RET:
;   D0: boolean
; CLOBBERS:
;   D0/D1
; CALLS:
;   DISPTEXT_FinalizeLineTable
; READS:
;   DISPTEXT_TargetLineIndex/21D6
; WRITES:
;   (none observed)
; DESC:
;   Returns true when more than one line is available.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISPTEXT_HasMultipleLines:
    BSR.W   DISPTEXT_FinalizeLineTable

    MOVE.W  DISPTEXT_CurrentLineIndex,D0
    BNE.S   .return_false

    MOVE.W  DISPTEXT_TargetLineIndex,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .return_false

    MOVEQ   #1,D0
    BRA.S   .return

.return_false:
    MOVEQ   #0,D0

.return:
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_IsLastLineSelected   (Is last line selecteduncertain)
; ARGS:
;   (none)
; RET:
;   D0: boolean
; CLOBBERS:
;   A7/D0/D1/D2
; CALLS:
;   DISPTEXT_FinalizeLineTable
; READS:
;   DISPTEXT_TargetLineIndex/21D6
; WRITES:
;   (none observed)
; DESC:
;   Returns true if current line index is the last line.
; NOTES:
;   Booleanize pattern: SEQ/NEG/EXT.
;------------------------------------------------------------------------------
DISPTEXT_IsLastLineSelected:
    MOVE.L  D2,-(A7)
    BSR.W   DISPTEXT_FinalizeLineTable

    MOVEQ   #0,D0
    MOVE.W  DISPTEXT_TargetLineIndex,D0
    SUBQ.L  #1,D0
    MOVEQ   #0,D1
    MOVE.W  DISPTEXT_CurrentLineIndex,D1
    CMP.L   D0,D1
    SEQ     D2
    NEG.B   D2
    EXT.W   D2
    EXT.L   D2
    MOVE.L  D2,D0
    MOVE.L  (A7)+,D2
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_IsCurrentLineLast   (Is current line lastuncertain)
; ARGS:
;   (none)
; RET:
;   D0: boolean
; CLOBBERS:
;   A7/D0/D1/D2
; CALLS:
;   DISPTEXT_FinalizeLineTable
; READS:
;   DISPTEXT_TargetLineIndex/21D6
; WRITES:
;   (none observed)
; DESC:
;   Returns true if DISPTEXT_CurrentLineIndex equals DISPTEXT_TargetLineIndex.
; NOTES:
;   Booleanize pattern: SEQ/NEG/EXT.
;------------------------------------------------------------------------------
DISPTEXT_IsCurrentLineLast:
    MOVE.L  D2,-(A7)
    BSR.W   DISPTEXT_FinalizeLineTable

    MOVE.W  DISPTEXT_CurrentLineIndex,D0
    MOVE.W  DISPTEXT_TargetLineIndex,D1
    CMP.W   D1,D0
    SEQ     D2
    NEG.B   D2
    EXT.W   D2
    EXT.L   D2
    MOVE.L  D2,D0
    MOVE.L  (A7)+,D2
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_MeasureCurrentLineLength   (Measure current line text length)
; ARGS:
;   (none observed)
; RET:
;   D0: text length
; CLOBBERS:
;   A0/A1/A3/A6/A7/D0
; CALLS:
;   DISPTEXT_FinalizeLineTable, _LVOTextLength
; READS:
;   DISPTEXT_LinePtrTable/21D6/21D7
; WRITES:
;   (none observed)
; DESC:
;   Measures text length for the current line.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISPTEXT_MeasureCurrentLineLength:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    BSR.W   DISPTEXT_FinalizeLineTable

    MOVEQ   #0,D0
    MOVE.W  DISPTEXT_CurrentLineIndex,D0
    ASL.L   #2,D0
    LEA     DISPTEXT_LinePtrTable,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.W  DISPTEXT_CurrentLineIndex,D0
    ADD.L   D0,D0
    LEA     DISPTEXT_LineLengthTable,A1
    ADDA.L  D0,A1
    MOVEQ   #0,D0
    MOVE.W  (A1),D0
    MOVEA.L A3,A1
    MOVEA.L (A0),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVEA.L (A7)+,A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_RenderCurrentLine   (Render one line of display text)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: D7 = x
;   stack +16: D6 = y
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A6/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   DISPTEXT_FinalizeLineTable, _LVOSetAPen, _LVOSetDrMd, _LVOMove, _LVOText, GROUP_AI_JMPTBL_STR_FindCharPtr, GROUP_AI_JMPTBL_TLIBA1_DrawTextWithInsetSegments
; READS:
;   DISPTEXT_LinePtrTable/21D6/21D7/21D9/21DC/21B1/21B2/21D8
; WRITES:
;   DISPTEXT_CurrentLineIndex, DISPTEXT_ControlMarkerXOffsetPx
; DESC:
;   Draws the current line at the given position, honoring highlight markers.
; NOTES:
;   Uses 0x13/0x14 control markers when DISPTEXT_ControlMarkersEnabledFlag set.
;------------------------------------------------------------------------------
DISPTEXT_RenderCurrentLine:
    LINK.W  A5,#-12
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    BSR.W   DISPTEXT_FinalizeLineTable

    MOVEQ   #0,D0
    MOVE.L  D0,DISPTEXT_ControlMarkerXOffsetPx
    MOVE.L  DISPTEXT_LineWidthPx,D1
    TST.L   D1
    BLE.W   .return

    MOVE.W  DISPTEXT_CurrentLineIndex,D1
    MOVE.W  DISPTEXT_TargetLineIndex,D2
    CMP.W   D2,D1
    BCC.W   .return

    MOVEQ   #0,D2
    MOVE.W  D1,D2
    ASL.L   #2,D2
    LEA     DISPTEXT_LinePtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D2,A1
    TST.L   (A1)
    BEQ.W   .return

    MOVEQ   #0,D2
    MOVE.W  D1,D2
    ASL.L   #2,D2
    ADDA.L  D2,A0
    MOVE.L  (A0),-6(A5)
    MOVEQ   #0,D3
    MOVE.W  D1,D3
    ADD.L   D3,D3
    LEA     DISPTEXT_LineLengthTable,A0
    ADDA.L  D3,A0
    MOVEQ   #0,D4
    MOVE.W  (A0),D4
    TST.L   D4
    BLE.W   .return

    LEA     DISPTEXT_LinePenTable,A0
    ADDA.L  D2,A0
    MOVEA.L A3,A1
    MOVE.L  (A0),D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L -6(A5),A0
    MOVE.B  0(A0,D4.L),D5
    CLR.B   0(A0,D4.L)
    TST.W   DISPTEXT_ControlMarkersEnabledFlag
    BEQ.S   .draw_plain

    PEA     19.W
    MOVE.L  A0,-(A7)
    JSR     GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .draw_plain

    PEA     20.W
    MOVE.L  -6(A5),-(A7)
    JSR     GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .draw_plain

    MOVEQ   #0,D0
    MOVE.B  DATA_WDISP_BSS_BYTE_21B2,D0
    MOVEQ   #0,D1
    MOVE.B  DISPTEXT_InsetNibblePrimary,D1
    MOVE.L  -6(A5),-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    JSR     GROUP_AI_JMPTBL_TLIBA1_DrawTextWithInsetSegments(PC)

    LEA     24(A7),A7
    MOVEQ   #4,D0
    MOVE.L  D0,DISPTEXT_ControlMarkerXOffsetPx
    BRA.S   .restore_char

.draw_plain:
    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVE.L  D4,D0
    MOVEA.L -6(A5),A0
    JSR     _LVOText(A6)

.restore_char:
    MOVEA.L -6(A5),A0
    MOVE.B  D5,0(A0,D4.L)
    MOVE.W  DISPTEXT_CurrentLineIndex,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DISPTEXT_CurrentLineIndex

.return:
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS
