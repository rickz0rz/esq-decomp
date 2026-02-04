;------------------------------------------------------------------------------
; FUNC: DISPTEXT_AppendToBuffer   (Append to display text buffer??)
; ARGS:
;   stack +8: A3 = string pointer
; RET:
;   D0: boolean success (0/-1)
; CLOBBERS:
;   D0-D1/D7/A0-A1/A6 ??
; CALLS:
;   _LVOAvailMem, GROUP_AG_JMPTBL_MEMORY_AllocateMemory, GROUP_AI_JMPTBL_STRING_AppendAtNull, GROUP_AE_JMPTBL_LAB_0B44
; READS:
;   LAB_21D3
; WRITES:
;   LAB_21D3
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
    TST.L   LAB_21D3
    BEQ.W   .alloc_new_buffer

    MOVEA.L LAB_21D3,A0

.find_end_dst:
    TST.B   (A0)+
    BNE.S   .find_end_dst

    SUBQ.L  #1,A0
    SUBA.L  LAB_21D3,A0
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
    PEA     GLOB_STR_DISPTEXT_C_1
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)

.realloc_buffer:
    TST.L   -8(A5)
    BEQ.S   .return_status

    MOVEA.L LAB_21D3,A0
    MOVEA.L -8(A5),A1

.copy_old_buffer:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_old_buffer

    MOVE.L  A3,-(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    MOVE.L  LAB_21D3,(A7)
    CLR.L   -(A7)
    JSR     GROUP_AE_JMPTBL_LAB_0B44(PC)

    LEA     12(A7),A7
    MOVEA.L -8(A5),A0
    MOVE.L  A0,LAB_21D3
    BRA.S   .return_status

.alloc_new_buffer:
    MOVE.L  LAB_21D3,-(A7)
    MOVE.L  A3,-(A7)
    JSR     GROUP_AE_JMPTBL_LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_21D3

.return_status:
    TST.L   LAB_21D3
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_BuildLineWithWidth   (Format text into line buffer with width constraint??)
; ARGS:
;   stack +8: A3 = font/rastport??
;   stack +12: A2 = source string
;   stack +16: A0 = output buffer
;   stack +20: D7 = max width
; RET:
;   D0: updated A2 (next source position)
; CLOBBERS:
;   D0-D7/A0-A3/A6 ??
; CALLS:
;   _LVOTextLength, GROUP_AI_JMPTBL_STRING_AppendAtNull, JMPTBL_UNKNOWN7_SkipCharClass3_2, JMPTBL_UNKNOWN7_CopyUntilDelimiter_2
; READS:
;   LAB_1CEA..LAB_1CEC, LAB_21D6/21D9/21DA/21DC
; WRITES:
;   output buffer, LAB_21DC
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
    LEA     LAB_1CEA,A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
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

    PEA     LAB_1CEB
    MOVE.L  A0,-(A7)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    SUB.L   -16(A5),D7

.append_separator:
    MOVE.L  A2,-(A7)
    JSR     JMPTBL_UNKNOWN7_SkipCharClass3_2(PC)

    MOVEA.L D0,A2
    MOVE.L  A2,-20(A5)
    PEA     LAB_1CEC
    PEA     50.W
    PEA     -73(A5)
    MOVE.L  A2,-(A7)
    JSR     JMPTBL_UNKNOWN7_CopyUntilDelimiter_2(PC)

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
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
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

    MOVE.W  LAB_21D6,D2
    MOVEQ   #2,D3
    CMP.W   D3,D2
    BCC.S   .set_separator_width

    MOVE.L  LAB_21DA,D2
    BRA.S   .compute_remaining_width

.set_separator_width:
    MOVEQ   #0,D2

.compute_remaining_width:
    MOVE.L  LAB_21D9,D3
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
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
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
    MOVE.W  LAB_21DC,D1
    EXT.L   D1
    OR.L    D0,D1
    MOVE.W  D1,LAB_21DC
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
; FUNC: DISPTEXT_BuildLinePointerTable   (Build display line pointer table??)
; ARGS:
;   stack +8: D7 = ?? (nonzero enables table build)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   none
; READS:
;   LAB_21D3/21D4/21D6/21D7/21DB
; WRITES:
;   LAB_21D4, LAB_21DB
; DESC:
;   Builds per-line pointer table based on offsets when not locked.
; NOTES:
;   ??
;------------------------------------------------------------------------------
DISPTEXT_BuildLinePointerTable:
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVE.L  24(A7),D7
    TST.L   LAB_21DB
    BNE.S   .return

    MOVE.L  LAB_21D3,LAB_21D4
    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ADD.L   D0,D0
    LEA     LAB_21D7,A0
    ADDA.L  D0,A0
    TST.W   (A0)
    BEQ.S   .has_header_line

    MOVEQ   #1,D0
    BRA.S   .init_line_count

.has_header_line:
    MOVEQ   #0,D0

.init_line_count:
    MOVEQ   #0,D1
    MOVE.W  LAB_21D6,D1
    ADD.L   D0,D1
    MOVE.L  D1,D5
    MOVEQ   #1,D6

.build_ptrs_loop:
    CMP.L   D5,D6
    BGE.S   .set_locked

    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     LAB_21D4,A0
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     LAB_21D3,A1
    ADDA.L  D0,A1
    MOVE.L  D6,D0
    ADD.L   D0,D0
    LEA     LAB_21D6,A2
    ADDA.L  D0,A2
    MOVEA.L (A1),A3
    MOVEQ   #0,D0
    MOVE.W  (A2),D0
    ADDA.L  D0,A3
    MOVE.L  A3,(A0)
    ADDQ.L  #1,D6
    BRA.S   .build_ptrs_loop

.set_locked:
    MOVE.L  D7,LAB_21DB

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_FinalizeLineTable   (Finalize pending line table??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D1/A0 ??
; CALLS:
;   DISPTEXT_BuildLinePointerTable
; READS:
;   LAB_21DB, LAB_21D6, LAB_21D7
; WRITES:
;   LAB_21D5, LAB_21D6
; DESC:
;   Ensures line table state is current and clears LAB_21D6 when needed.
; NOTES:
;   ??
;------------------------------------------------------------------------------
DISPTEXT_FinalizeLineTable:
    TST.L   LAB_21DB
    BNE.S   .return

    MOVE.W  LAB_21D6,D0
    MOVE.W  D0,LAB_21D5
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADD.L   D1,D1
    LEA     LAB_21D7,A0
    ADDA.L  D1,A0
    TST.W   (A0)
    BEQ.S   .check_extra_line

    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_21D5

.check_extra_line:
    PEA     1.W
    BSR.W   DISPTEXT_BuildLinePointerTable

    ADDQ.W  #4,A7
    CLR.W   LAB_21D6

.return:
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_InitBuffers   (Initialize disptext buffers)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0/A7 ??
; CALLS:
;   LAB_0563, GROUP_AG_JMPTBL_MEMORY_AllocateMemory
; READS:
;   LAB_1CED
; WRITES:
;   LAB_21D3, LAB_1CED, GLOB_REF_1000_BYTES_ALLOCATED_1/2
; DESC:
;   Allocates working buffers for display text if initialization flag set.
; NOTES:
;   ??
;------------------------------------------------------------------------------
DISPTEXT_InitBuffers:
    TST.L   LAB_1CED
    BEQ.S   .return

    CLR.L   LAB_21D3
    BSR.W   LAB_0563

    CLR.L   LAB_1CED

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     1000.W
    PEA     320.W
    PEA     GLOB_STR_DISPTEXT_C_2
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    PEA     1000.W
    PEA     321.W
    PEA     GLOB_STR_DISPTEXT_C_3
    MOVE.L  D0,GLOB_REF_1000_BYTES_ALLOCATED_1
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     28(A7),A7
    MOVE.L  D0,GLOB_REF_1000_BYTES_ALLOCATED_2

.return:
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_FreeBuffers   (Free disptext buffers)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0/A7 ??
; CALLS:
;   LAB_0566, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   GLOB_REF_1000_BYTES_ALLOCATED_1/2
; WRITES:
;   GLOB_REF_1000_BYTES_ALLOCATED_1/2
; DESC:
;   Releases the 1000-byte buffers used by display text.
; NOTES:
;   ??
;------------------------------------------------------------------------------
DISPTEXT_FreeBuffers:
    BSR.W   LAB_0566

    TST.L   GLOB_REF_1000_BYTES_ALLOCATED_1
    BEQ.S   .freeSecondBlock

    PEA     1000.W
    MOVE.L  GLOB_REF_1000_BYTES_ALLOCATED_1,-(A7)
    PEA     338.W
    PEA     GLOB_STR_DISPTEXT_C_4
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    CLR.L   GLOB_REF_1000_BYTES_ALLOCATED_1

.freeSecondBlock:
    TST.L   GLOB_REF_1000_BYTES_ALLOCATED_2
    BEQ.S   .return

    PEA     1000.W
    MOVE.L  GLOB_REF_1000_BYTES_ALLOCATED_2,-(A7)
    PEA     343.W
    PEA     GLOB_STR_DISPTEXT_C_5
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    CLR.L   GLOB_REF_1000_BYTES_ALLOCATED_2

.return:
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_SetLayoutParams   (Set display layout params??)
; ARGS:
;   stack +8: D7 = width?? (1..624)
;   stack +12: D6 = line count?? (1..20)
;   stack +16: D5 = ?? (passed to LAB_0567)
; RET:
;   D0: 1 if applied, 0 if clamped/no change
; CLOBBERS:
;   D0-D7 ??
; CALLS:
;   LAB_0566, LAB_0567
; READS:
;   LAB_21D9, LAB_21D5
; WRITES:
;   LAB_21D9, LAB_21D5
; DESC:
;   Updates layout parameters and returns whether the requested values matched.
; NOTES:
;   ??
;------------------------------------------------------------------------------
DISPTEXT_SetLayoutParams:
    MOVEM.L D5-D7,-(A7)
    MOVE.L  16(A7),D7
    MOVE.L  20(A7),D6
    MOVE.L  24(A7),D5
    BSR.W   LAB_0566

    TST.L   D7
    BMI.S   .clamp_width

    CMPI.L  #624,D7
    BGT.S   .clamp_width

    MOVE.L  D7,LAB_21D9

.clamp_width:
    TST.L   D6
    BLE.S   .clamp_lines

    MOVEQ   #20,D0
    CMP.L   D0,D6
    BGT.S   .clamp_lines

    MOVE.L  D6,D0
    MOVE.W  D0,LAB_21D5

.clamp_lines:
    MOVE.L  D5,-(A7)
    BSR.W   LAB_0567

    ADDQ.W  #4,A7
    MOVE.L  LAB_21D9,D0
    CMP.L   D7,D0
    BNE.S   .mismatch

    MOVEQ   #0,D0
    MOVE.W  LAB_21D5,D0
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
; FUNC: DISPTEXT_ComputeMarkerWidths   (Compute padding widths??)
; ARGS:
;   stack +8: A3 = font/rastport??
;   stack +12: D7 = ?? (width)
;   stack +16: D6 = ?? (width)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A3/A6 ??
; CALLS:
;   JMPTBL_LAB_10BE_2, _LVOTextLength
; READS:
;   LAB_21DA
; WRITES:
;   LAB_21DA
; DESC:
;   Computes combined text lengths for two optional markers and stores in LAB_21DA.
; NOTES:
;   ??
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
    JSR     JMPTBL_LAB_10BE_2(PC)

    LEA     24(A7),A7
    TST.B   -1(A5)
    BEQ.S   .no_prefix1

    MOVEA.L A3,A1
    LEA     -1(A5),A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
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
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    BRA.S   .store_combined

.no_prefix2:
    MOVEQ   #0,D0

.store_combined:
    MOVE.L  D0,D4
    MOVE.L  D5,D0
    ADD.L   D4,D0
    MOVE.L  D0,LAB_21DA
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_LayoutSourceToLines   (Layout source text into lines)
; ARGS:
;   stack +8: A3 = font/rastport??
;   stack +12: A2 = source string
; RET:
;   D0: boolean success (0/-1)
; CLOBBERS:
;   D0-D7/A0-A3/A6 ??
; CALLS:
;   DISPTEXT_BuildLineWithWidth, _LVOTextLength
; READS:
;   LAB_21D3/21D4/21D5/21D6/21D7/21D9/21DA/21DB
; WRITES:
;   LAB_21D6
; DESC:
;   Iterates over lines, measuring and formatting text into the line buffer.
; NOTES:
;   Uses line offset tables LAB_21D4/LAB_21D7.
;------------------------------------------------------------------------------
DISPTEXT_LayoutSourceToLines:
    LINK.W  A5,#-276
    MOVEM.L D2/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEQ   #0,D7
    TST.L   LAB_21DB
    BNE.W   .return_status

    MOVE.W  LAB_21D6,D0
    MOVE.W  LAB_21D5,D1
    CMP.W   D1,D0
    BCC.W   .return_status

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADD.L   D1,D1
    LEA     LAB_21D7,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    TST.W   (A1)
    BEQ.S   .no_prefix_line

    MOVEQ   #0,D2
    MOVE.W  D0,D2
    ASL.L   #2,D2
    LEA     LAB_21D4,A1
    ADDA.L  D2,A1
    ADDA.L  D1,A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    MOVE.L  A1,28(A7)
    MOVEA.L A3,A1
    MOVEA.L 28(A7),A0
    MOVEA.L (A0),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  LAB_21D9,D1
    MOVE.L  D1,D2
    SUB.L   D0,D2
    MOVE.L  D2,D6
    BRA.S   .adjust_for_prefix

.no_prefix_line:
    MOVE.L  LAB_21D9,D6

.adjust_for_prefix:
    MOVE.W  LAB_21D6,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCC.S   .maybe_subtract_markers

    SUB.L   LAB_21DA,D6

.maybe_subtract_markers:
    MOVEQ   #0,D2
    MOVE.W  D0,D2
    ADD.L   D2,D2
    LEA     LAB_21D7,A0
    ADDA.L  D2,A0
    TST.W   (A0)
    BEQ.S   .try_build_line

    MOVEA.L A3,A1
    LEA     LAB_1CF2,A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5
    CMP.L   D5,D6
    BLE.S   .reset_width_for_next

    SUB.L   D5,D6
    BRA.S   .try_build_line

.reset_width_for_next:
    ADDQ.L  #1,D7
    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ADD.L   D7,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_21D5,D1
    CMP.L   D1,D0
    BGE.S   .try_build_line

    MOVE.L  LAB_21D9,D6

.try_build_line:
    MOVE.L  A2,D0
    BEQ.S   .return_status

    TST.B   (A2)
    BEQ.S   .return_status

    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ADD.L   D7,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_21D5,D1
    CMP.L   D1,D0
    BGE.S   .return_status

    MOVE.L  D6,-(A7)
    PEA     -268(A5)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   DISPTEXT_BuildLineWithWidth

    LEA     16(A7),A7
    MOVEA.L D0,A2
    MOVE.L  LAB_21D9,D6
    MOVE.W  LAB_21D6,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCC.S   .after_build_line

    SUB.L   LAB_21DA,D6

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
;   stack +8: A3 = font/rastport??
;   stack +12: A2 = source string
; RET:
;   D0: boolean success (0/-1)
; CLOBBERS:
;   D0-D7/A0-A3/A6 ??
; CALLS:
;   DISPTEXT_BuildLineWithWidth, LAB_0567, GROUP_AI_JMPTBL_STRING_AppendAtNull, _LVOTextLength
; READS:
;   LAB_21D3/21D4/21D5/21D6/21D7/21D8/21D9/21DA/21DB
; WRITES:
;   LAB_21D6, LAB_21D7, GLOB_REF_1000_BYTES_ALLOCATED_2
; DESC:
;   Builds line segments into the scratch buffer and appends to global text.
; NOTES:
;   ??
;------------------------------------------------------------------------------
DISPTEXT_LayoutAndAppendToBuffer:
    LINK.W  A5,#-276
    MOVEM.L D2/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    TST.L   LAB_21DB
    BNE.W   .return_status

    MOVE.W  LAB_21D6,D0
    MOVE.W  LAB_21D5,D1
    CMP.W   D1,D0
    BCC.W   .return_status

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADD.L   D1,D1
    LEA     LAB_21D7,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    TST.W   (A1)
    BEQ.S   .no_prefix_line

    MOVEQ   #0,D2
    MOVE.W  D0,D2
    ASL.L   #2,D2
    LEA     LAB_21D4,A1
    ADDA.L  D2,A1
    ADDA.L  D1,A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    MOVE.L  A1,28(A7)
    MOVEA.L A3,A1
    MOVEA.L 28(A7),A0
    MOVEA.L (A0),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  LAB_21D9,D1
    MOVE.L  D1,D2
    SUB.L   D0,D2
    MOVE.L  D2,D7
    BRA.S   .adjust_for_prefix

.no_prefix_line:
    MOVE.L  LAB_21D9,D7

.adjust_for_prefix:
    MOVE.W  LAB_21D6,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCC.S   .init_scratch

    SUB.L   LAB_21DA,D7

.init_scratch:
    MOVEA.L GLOB_REF_1000_BYTES_ALLOCATED_2,A0
    CLR.B   (A0)
    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ADD.L   D0,D0
    LEA     LAB_21D7,A1
    ADDA.L  D0,A1
    TST.W   (A1)
    BEQ.S   .line_loop

    MOVEA.L A3,A1
    LEA     LAB_1CF3,A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D6
    CMP.L   D6,D7
    BLE.S   .fallback_layout

    LEA     LAB_1CF4,A0
    MOVEA.L GLOB_REF_1000_BYTES_ALLOCATED_2,A1

.copy_prefix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_prefix

    SUB.L   D6,D7
    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ADD.L   D0,D0
    LEA     LAB_21D7,A0
    ADDA.L  D0,A0
    ADDQ.W  #1,(A0)
    BRA.S   .line_loop

.fallback_layout:
    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ASL.L   #2,D0
    LEA     LAB_21D8,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    BSR.W   LAB_0567

    ADDQ.W  #4,A7
    MOVE.W  LAB_21D6,D0
    MOVE.W  LAB_21D5,D1
    CMP.W   D1,D0
    BCC.S   .line_loop

    MOVE.L  LAB_21D9,D7

.line_loop:
    MOVE.L  A2,D0
    BEQ.W   .flush_remaining

    TST.B   (A2)
    BEQ.W   .flush_remaining

    MOVE.W  LAB_21D6,D0
    MOVE.W  LAB_21D5,D1
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
    MOVE.L  GLOB_REF_1000_BYTES_ALLOCATED_2,-(A7)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ADD.L   D0,D0
    LEA     LAB_21D7,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    MOVE.L  D0,D1
    ADD.L   D5,D1
    MOVE.W  D1,(A0)
    MOVE.L  LAB_21D9,D7
    MOVE.W  LAB_21D6,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCC.S   .after_append

    SUB.L   LAB_21DA,D7

.after_append:
    MOVE.L  A2,D1
    BEQ.W   .line_loop

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ASL.L   #2,D1
    LEA     LAB_21D8,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-(A7)
    BSR.W   LAB_0567

    ADDQ.W  #4,A7
    BRA.W   .line_loop

.flush_remaining:
    MOVEA.L GLOB_REF_1000_BYTES_ALLOCATED_2,A0
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
;   stack +8: A3 = font/rastport??
;   stack +12: ?? (source string)
; RET:
;   D0: boolean success
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   JMPTBL_FORMAT_FormatToBuffer2_2, DISPTEXT_LayoutAndAppendToBuffer
; READS:
;   LAB_21DB, GLOB_REF_1000_BYTES_ALLOCATED_1
; WRITES:
;   GLOB_REF_1000_BYTES_ALLOCATED_1 (via JMPTBL_FORMAT_FormatToBuffer2_2)
; DESC:
;   Prepares output buffer and runs layout; returns success flag.
; NOTES:
;   ??
;------------------------------------------------------------------------------
DISPTEXT_BuildLayoutForSource:
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D7
    TST.L   LAB_21DB
    BNE.S   .return_status

    LEA     16(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  12(A5),-(A7)
    MOVE.L  GLOB_REF_1000_BYTES_ALLOCATED_1,-(A7)
    MOVE.L  A0,-8(A5)
    JSR     JMPTBL_FORMAT_FormatToBuffer2_2(PC)

    MOVE.L  GLOB_REF_1000_BYTES_ALLOCATED_1,(A7)
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
;   D0: ??
; CLOBBERS:
;   D0/D7 ??
; CALLS:
;   LAB_0567
; READS:
;   LAB_21DB
; WRITES:
;   (via LAB_0567)
; DESC:
;   Updates current line selection if valid and not locked.
; NOTES:
;   ??
;------------------------------------------------------------------------------
DISPTEXT_SetCurrentLineIndex:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    TST.L   LAB_21DB
    BNE.S   .return

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BLT.S   .return

    MOVEQ   #3,D0
    CMP.L   D0,D7
    BGT.S   .return

    MOVE.L  D7,-(A7)
    BSR.W   LAB_0567

    ADDQ.W  #4,A7

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_ComputeVisibleLineCount   (Compute visible line count??)
; ARGS:
;   stack +8: D7 = ?? (line index)
; RET:
;   D0: line count or offset
; CLOBBERS:
;   D0-D7 ??
; CALLS:
;   DISPTEXT_FinalizeLineTable, GROUP_AG_JMPTBL_MATH_Mulu32, JMPTBL_UNKNOWN7_FindCharWrapper_2
; READS:
;   LAB_21D5/21D6/21DC/21D3, LAB_2328
; WRITES:
;   ??
; DESC:
;   Computes a derived line count with optional prefix adjustments.
; NOTES:
;   Uses booleanize pattern on LAB_21DC.
;------------------------------------------------------------------------------
DISPTEXT_ComputeVisibleLineCount:
    LINK.W  A5,#-12
    MOVEM.L D5-D7,-(A7)
    MOVE.L  8(A5),D7
    BSR.W   DISPTEXT_FinalizeLineTable

    MOVEQ   #0,D0
    MOVE.W  LAB_21D5,D0
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
    MOVE.W  LAB_2328,D1
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
    TST.W   LAB_21DC
    BEQ.S   .return

    MOVE.W  LAB_21D5,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ASL.L   #2,D1
    LEA     LAB_21D3,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-12(A5)
    BEQ.S   .return

    PEA     19.W
    MOVE.L  A1,-(A7)
    JSR     JMPTBL_UNKNOWN7_FindCharWrapper_2(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .return

    PEA     20.W
    MOVE.L  -12(A5),-(A7)
    JSR     JMPTBL_UNKNOWN7_FindCharWrapper_2(PC)

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
;   D0: LAB_21D5
; CLOBBERS:
;   D0 ??
; CALLS:
;   DISPTEXT_FinalizeLineTable
; READS:
;   LAB_21D5
; WRITES:
;   ??
; DESC:
;   Returns the total number of lines after ensuring state is current.
; NOTES:
;   ??
;------------------------------------------------------------------------------
DISPTEXT_GetTotalLineCount:
    BSR.W   DISPTEXT_FinalizeLineTable

    MOVEQ   #0,D0
    MOVE.W  LAB_21D5,D0
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_HasMultipleLines   (Has multiple lines??)
; ARGS:
;   (none)
; RET:
;   D0: boolean
; CLOBBERS:
;   D0-D1 ??
; CALLS:
;   DISPTEXT_FinalizeLineTable
; READS:
;   LAB_21D5/21D6
; WRITES:
;   ??
; DESC:
;   Returns true when more than one line is available.
; NOTES:
;   ??
;------------------------------------------------------------------------------
DISPTEXT_HasMultipleLines:
    BSR.W   DISPTEXT_FinalizeLineTable

    MOVE.W  LAB_21D6,D0
    BNE.S   .return_false

    MOVE.W  LAB_21D5,D0
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
; FUNC: DISPTEXT_IsLastLineSelected   (Is last line selected??)
; ARGS:
;   (none)
; RET:
;   D0: boolean
; CLOBBERS:
;   D0-D2 ??
; CALLS:
;   DISPTEXT_FinalizeLineTable
; READS:
;   LAB_21D5/21D6
; WRITES:
;   ??
; DESC:
;   Returns true if current line index is the last line.
; NOTES:
;   Booleanize pattern: SEQ/NEG/EXT.
;------------------------------------------------------------------------------
DISPTEXT_IsLastLineSelected:
    MOVE.L  D2,-(A7)
    BSR.W   DISPTEXT_FinalizeLineTable

    MOVEQ   #0,D0
    MOVE.W  LAB_21D5,D0
    SUBQ.L  #1,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_21D6,D1
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
; FUNC: DISPTEXT_IsCurrentLineLast   (Is current line last??)
; ARGS:
;   (none)
; RET:
;   D0: boolean
; CLOBBERS:
;   D0-D2 ??
; CALLS:
;   DISPTEXT_FinalizeLineTable
; READS:
;   LAB_21D5/21D6
; WRITES:
;   ??
; DESC:
;   Returns true if LAB_21D6 equals LAB_21D5.
; NOTES:
;   Booleanize pattern: SEQ/NEG/EXT.
;------------------------------------------------------------------------------
DISPTEXT_IsCurrentLineLast:
    MOVE.L  D2,-(A7)
    BSR.W   DISPTEXT_FinalizeLineTable

    MOVE.W  LAB_21D6,D0
    MOVE.W  LAB_21D5,D1
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
;   stack +8: A3 = font/rastport??
; RET:
;   D0: text length
; CLOBBERS:
;   D0-D1/A0-A1/A6 ??
; CALLS:
;   DISPTEXT_FinalizeLineTable, _LVOTextLength
; READS:
;   LAB_21D4/21D6/21D7
; WRITES:
;   ??
; DESC:
;   Measures text length for the current line.
; NOTES:
;   ??
;------------------------------------------------------------------------------
DISPTEXT_MeasureCurrentLineLength:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    BSR.W   DISPTEXT_FinalizeLineTable

    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ASL.L   #2,D0
    LEA     LAB_21D4,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ADD.L   D0,D0
    LEA     LAB_21D7,A1
    ADDA.L  D0,A1
    MOVEQ   #0,D0
    MOVE.W  (A1),D0
    MOVEA.L A3,A1
    MOVEA.L (A0),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
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
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A3/A6 ??
; CALLS:
;   DISPTEXT_FinalizeLineTable, _LVOSetAPen, _LVOSetDrMd, _LVOMove, _LVOText, JMPTBL_UNKNOWN7_FindCharWrapper_2, JMPTBL_LAB_175F_2
; READS:
;   LAB_21D4/21D6/21D7/21D9/21DC/21B1/21B2/21D8
; WRITES:
;   LAB_21D6, LAB_1CE8
; DESC:
;   Draws the current line at the given position, honoring highlight markers.
; NOTES:
;   Uses 0x13/0x14 control markers when LAB_21DC set.
;------------------------------------------------------------------------------
DISPTEXT_RenderCurrentLine:
    LINK.W  A5,#-12
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    BSR.W   DISPTEXT_FinalizeLineTable

    MOVEQ   #0,D0
    MOVE.L  D0,LAB_1CE8
    MOVE.L  LAB_21D9,D1
    TST.L   D1
    BLE.W   .return

    MOVE.W  LAB_21D6,D1
    MOVE.W  LAB_21D5,D2
    CMP.W   D2,D1
    BCC.W   .return

    MOVEQ   #0,D2
    MOVE.W  D1,D2
    ASL.L   #2,D2
    LEA     LAB_21D4,A0
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
    LEA     LAB_21D7,A0
    ADDA.L  D3,A0
    MOVEQ   #0,D4
    MOVE.W  (A0),D4
    TST.L   D4
    BLE.W   .return

    LEA     LAB_21D8,A0
    ADDA.L  D2,A0
    MOVEA.L A3,A1
    MOVE.L  (A0),D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L -6(A5),A0
    MOVE.B  0(A0,D4.L),D5
    CLR.B   0(A0,D4.L)
    TST.W   LAB_21DC
    BEQ.S   .draw_plain

    PEA     19.W
    MOVE.L  A0,-(A7)
    JSR     JMPTBL_UNKNOWN7_FindCharWrapper_2(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .draw_plain

    PEA     20.W
    MOVE.L  -6(A5),-(A7)
    JSR     JMPTBL_UNKNOWN7_FindCharWrapper_2(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .draw_plain

    MOVEQ   #0,D0
    MOVE.B  LAB_21B2,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_21B1,D1
    MOVE.L  -6(A5),-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_LAB_175F_2(PC)

    LEA     24(A7),A7
    MOVEQ   #4,D0
    MOVE.L  D0,LAB_1CE8
    BRA.S   .restore_char

.draw_plain:
    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVE.L  D4,D0
    MOVEA.L -6(A5),A0
    JSR     _LVOText(A6)

.restore_char:
    MOVEA.L -6(A5),A0
    MOVE.B  D5,0(A0,D4.L)
    MOVE.W  LAB_21D6,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_21D6

.return:
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS
