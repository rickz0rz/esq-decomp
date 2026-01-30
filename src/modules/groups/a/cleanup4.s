;------------------------------------------------------------------------------
; FUNC: CLEANUP_TestEntryFlagYAndBit1   (TestEntryFlagYAndBit1??)
; ARGS:
;   stack +4: entryPtr (struct??)
;   stack +8: entryIndex (word)
;   stack +12: fieldOffset (long)
; RET:
;   D0: 0/1 result
; CLOBBERS:
;   D0-D1/D5-D7/A0-A3
; CALLS:
;   LAB_0347
; READS:
;   entryPtr+40 (bit 1), entry data at fieldOffset
; WRITES:
;   (none)
; DESC:
;   Looks up entry data for entryIndex and returns 1 if the selected byte
;   equals 'Y' and a flag bit is set in the entry.
; NOTES:
;   - Uses LAB_0347 to resolve the entry record.
;------------------------------------------------------------------------------
CLEANUP_TestEntryFlagYAndBit1:
LAB_0277:
    LINK.W  A5,#-8
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.L  16(A5),D6
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     7.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0347

    LEA     12(A7),A7
    MOVE.L  D0,-4(A5)
    BEQ.S   .return_false

    TST.L   D6
    BMI.S   .return_false

    MOVEQ   #5,D1
    CMP.L   D1,D6
    BGT.S   .return_false

    MOVEQ   #89,D0
    MOVEA.L -4(A5),A0
    CMP.B   0(A0,D6.L),D0
    BNE.S   .return_false

    BTST    #1,40(A3)
    BEQ.S   .return_false

    MOVEQ   #1,D0
    BRA.S   .done

.return_false:
    MOVEQ   #0,D0

.done:
    MOVE.L  D0,D5
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_UpdateEntryFlagBytes   (UpdateEntryFlagBytes??)
; ARGS:
;   stack +4: entryPtr (struct??)
;   stack +8: entryIndex (word)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/D7/A0-A3
; CALLS:
;   LAB_0347, LAB_0380
; READS:
;   LAB_21A8, LAB_1B61
; WRITES:
;   LAB_21B1, LAB_21B2
; DESC:
;   Loads two flag bytes from the entry data and writes derived values into
;   LAB_21B1/LAB_21B2 using LAB_21A8 attribute bits.
; NOTES:
;   - Falls back to LAB_1B61 when the entry record is missing.
;------------------------------------------------------------------------------
CLEANUP_UpdateEntryFlagBytes:
LAB_027A:
    LINK.W  A5,#-16
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     7.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0347

    LEA     12(A7),A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BNE.S   .entry_ok

    LEA     LAB_1B61,A0
    LEA     -15(A5),A1

.copy_default_entry_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_default_entry_loop

    LEA     -15(A5),A0
    MOVE.L  A0,-4(A5)

.entry_ok:
    MOVEA.L -4(A5),A0
    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   .entry_flag6_not_set

    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0380(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .store_flag6

.entry_flag6_not_set:
    MOVEQ   #0,D1
    NOT.B   D1

.store_flag6:
    MOVE.B  D1,LAB_21B1
    MOVEA.L -4(A5),A0
    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   .entry_flag7_not_set

    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0380(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .store_flag7

.entry_flag7_not_set:
    MOVEQ   #0,D1
    NOT.B   D1

.store_flag7:
    MOVE.B  D1,LAB_21B2
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_BuildAlignedStatusLine   (BuildAlignedStatusLine??)
; ARGS:
;   stack +4: outText (char*)
;   stack +8: modeFlag (word)
;   stack +12: entryIndex (word)
;   stack +16: entrySubIndex (word)
;   stack +20: entryPtr (struct??)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   LAB_037F, CLEANUP_TestEntryFlagYAndBit1, LAB_0347,
;   JMP_TBL_PRINTF_1, JMP_TBL_APPEND_DATA_AT_NULL_1, LAB_0380
; READS:
;   LAB_1B62, LAB_1B63, LAB_1B64, LAB_21A8, LAB_2157
; WRITES:
;   LAB_21B3, LAB_21B4, LAB_1B5D
; DESC:
;   Builds an aligned status string into outText, optionally using entry data
;   and setting flag bytes for later rendering.
; NOTES:
;   - Uses LAB_0347 to resolve entry records and LAB_21A8 for attribute bits.
;------------------------------------------------------------------------------
CLEANUP_BuildAlignedStatusLine:
LAB_0281:
    LINK.W  A5,#-32
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.W  18(A5),D6
    MOVE.W  22(A5),D5
    CLR.L   -28(A5)
    MOVE.L  D6,D0
    EXT.L   D0
    TST.W   D7
    BEQ.S   .use_format_b

    MOVEQ   #1,D1
    BRA.S   .format_selected

.use_format_b:
    MOVEQ   #2,D1

.format_selected:
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_037F(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  24(A5),(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-4(A5)
    BSR.W   CLEANUP_TestEntryFlagYAndBit1

    LEA     16(A7),A7
    TST.L   D0
    BEQ.S   .skip_entry_text

    MOVE.L  D5,D0
    EXT.L   D0
    PEA     6.W
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   LAB_0347

    LEA     12(A7),A7
    MOVE.L  D0,-28(A5)

.skip_entry_text:
    TST.L   -28(A5)
    BEQ.W   .clear_status_flag

    PEA     20.W
    MOVE.L  -28(A5),-(A7)
    PEA     19.W
    PEA     LAB_1B62
    PEA     -12(A5)
    JSR     JMP_TBL_PRINTF_1(PC)

    LEA     20(A7),A7
    TST.L   28(A5)
    BEQ.S   .append_default_prefix

    PEA     LAB_2157
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    ADDQ.W  #8,A7
    BRA.S   .append_entry_text

.append_default_prefix:
    PEA     LAB_1B63
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    ADDQ.W  #8,A7

.append_entry_text:
    PEA     -12(A5)
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_1(PC)

    MOVE.L  D5,D0
    EXT.L   D0
    PEA     7.W
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   LAB_0347

    LEA     20(A7),A7
    MOVE.L  D0,-32(A5)
    TST.L   D0
    BNE.S   .entry2_ok

    LEA     LAB_1B64,A0
    LEA     -23(A5),A1

.copy_default_entry2_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_default_entry2_loop

    LEA     -23(A5),A0
    MOVE.L  A0,-32(A5)

.entry2_ok:
    MOVEA.L -32(A5),A0
    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   .entry2_flag6_not_set

    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0380(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .store_entry2_flag6

.entry2_flag6_not_set:
    MOVEQ   #0,D1
    NOT.B   D1

.store_entry2_flag6:
    MOVE.B  D1,LAB_21B3
    MOVEA.L -32(A5),A0
    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   .entry2_flag7_not_set

    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0380(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .store_entry2_flag7

.entry2_flag7_not_set:
    MOVEQ   #0,D1
    NOT.B   D1

.store_entry2_flag7:
    MOVE.B  D1,LAB_21B4
    MOVE.B  #$1,LAB_1B5D
    BRA.S   .done

.clear_status_flag:
    CLR.B   LAB_1B5D

.done:
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_DrawInsetRectFrame   (DrawInsetRectFrame??)
; ARGS:
;   stack +4: rastPort (struct RastPort*)
;   stack +8: pen (byte)
;   stack +12: width (word)
;   stack +16: height (word)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1/A3/A6
; CALLS:
;   _LVOSetAPen, _LVORectFill, _LVOMove, _LVODraw
; READS:
;   rastPort fields (25/36/38/62 offsets)
; WRITES:
;   rastPort drawing
; DESC:
;   Draws a filled rectangle and multiple inset outline strokes.
; NOTES:
;   - Uses pen 1 and 2 to draw the inset border layers.
;------------------------------------------------------------------------------
CLEANUP_DrawInsetRectFrame:
LAB_028F:
    LINK.W  A5,#-24
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.B  15(A5),D7
    MOVE.W  18(A5),D6
    MOVE.W  22(A5),D5
    MOVE.B  25(A3),D4
    EXT.W   D4
    EXT.L   D4
    MOVE.W  36(A3),D0
    MOVE.W  38(A3),D1
    ADDQ.W  #2,D1
    MOVE.W  D0,-6(A5)
    SUBQ.W  #2,D0
    MOVE.W  D1,-8(A5)
    SUB.W   62(A3),D1
    SUBQ.W  #1,D1
    ADDQ.W  #2,D6
    MOVE.L  D7,D2
    EXT.W   D2
    EXT.L   D2
    MOVE.W  D0,-10(A5)
    MOVE.W  D1,-12(A5)

    MOVEA.L A3,A1
    MOVE.L  D2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    MOVE.W  -10(A5),D2
    EXT.L   D2
    MOVE.L  D6,D3
    EXT.L   D3
    ADD.L   D3,D2
    MOVE.W  -12(A5),D3
    EXT.L   D3
    MOVE.L  D2,36(A7)
    MOVE.L  D5,D2
    EXT.L   D2
    ADD.L   D2,D3
    MOVEA.L A3,A1
    MOVE.L  36(A7),D2
    JSR     _LVORectFill(A6)

    MOVEA.L A3,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    SUBQ.L  #2,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    ADD.L   D2,D1
    ADDQ.L  #2,D1
    MOVEA.L A3,A1
    JSR     _LVOMove(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    SUBQ.L  #2,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    SUBQ.L  #2,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D1,D0
    ADDQ.L  #2,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    SUBQ.L  #2,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    SUBQ.L  #1,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    ADD.L   D2,D1
    ADDQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVOMove(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    SUBQ.L  #1,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    SUBQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D1,D0
    ADDQ.L  #1,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    SUBQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVEA.L A3,A1
    MOVEQ   #2,D0
    JSR     _LVOSetAPen(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D1,D0
    ADDQ.L  #2,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    SUBQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVOMove(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D1,D0
    ADDQ.L  #2,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    ADD.L   D2,D1
    ADDQ.L  #2,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    SUBQ.L  #1,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    ADD.L   D2,D1
    ADDQ.L  #2,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D1,D0
    ADDQ.L  #1,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    MOVEA.L A3,A1
    JSR     _LVOMove(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D1,D0
    ADDQ.L  #1,D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    ADD.L   D2,D1
    ADDQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  -10(A5),D0
    EXT.L   D0
    MOVE.W  -12(A5),D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    ADD.L   D2,D1
    ADDQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  -6(A5),D0
    EXT.L   D0
    MOVE.W  -8(A5),D1
    EXT.L   D1
    MOVEA.L A3,A1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVE.L  D4,D0
    JSR     _LVOSetAPen(A6)

    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_FormatEntryStringTokens   (FormatEntryStringTokens??)
; ARGS:
;   stack +4: outPtr1 (char**)
;   stack +8: outPtr2 (char**)
;   stack +12: inText (char*)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   LAB_05C1, LAB_0385
; READS:
;   LAB_1B65, LAB_1B66, LAB_1B67, LAB_21A8
; WRITES:
;   outPtr1/outPtr2 contents
; DESC:
;   Formats an input text string, applying a small token/jumptable filter,
;   and stores the results into two output buffers.
; NOTES:
;   - Uses a switch/jumptable to handle special token bytes.
;------------------------------------------------------------------------------
CLEANUP_FormatEntryStringTokens:
LAB_0290:
    LINK.W  A5,#-32
    MOVEM.L D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    TST.L   16(A5)
    BEQ.W   .empty_input

    MOVEA.L 16(A5),A0
    TST.B   (A0)
    BEQ.W   .empty_input

    PEA     58.W
    MOVE.L  A0,-(A7)
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-26(A5)
    TST.L   D0
    BEQ.W   .empty_input

    LEA     LAB_1B65,A0
    LEA     -22(A5),A1
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.W  (A0),(A1)+
    CLR.B   (A1)
    LEA     LAB_1B66,A0
    LEA     -11(A5),A1

.copy_prefix_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_prefix_loop

    MOVEQ   #0,D7

.scan_input_loop:
    MOVEQ   #5,D0
    CMP.L   D0,D7
    BGE.S   .after_scan

    MOVEQ   #58,D0
    MOVEA.L 16(A5),A0
    CMP.B   0(A0,D7.L),D0
    BEQ.S   .after_scan

    MOVE.B  0(A0,D7.L),-11(A5,D7.L)
    ADDQ.L  #1,D7
    BRA.S   .scan_input_loop

.after_scan:
    CLR.B   -11(A5,D7.L)
    MOVE.L  (A3),-(A7)
    PEA     -11(A5)
    JSR     LAB_0385(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,(A3)
    LEA     LAB_1B67,A0
    LEA     -11(A5),A1

.copy_suffix_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_suffix_loop

    ADDQ.L  #1,-26(A5)
    MOVEQ   #0,D7

.token_loop:
    MOVEQ   #10,D0
    CMP.L   D0,D7
    BGE.W   .commit_output

    MOVEA.L -26(A5),A0
    TST.B   0(A0,D7.L)
    BEQ.W   .commit_output

    MOVE.L  D7,D0
    CMPI.L  #$9,D0
    BCC.W   .next_token

    ADD.W   D0,D0
    MOVE.W  .token_table(PC,D0.W),D0
    JMP     .token_table+2(PC,D0.W)

; switch/jumptable
.token_table:
	DC.W    .case_alpha_or_copy-.token_table-2
    DC.W    .case_alpha_or_copy-.token_table-2
	DC.W    .case_alpha_or_copy-.token_table-2
    DC.W    .case_alpha_or_copy-.token_table-2
	DC.W    .case_alpha_or_copy-.token_table-2
    DC.W    .case_alpha_or_copy-.token_table-2
	DC.W    .case_flag7_check-.token_table-2
    DC.W    .case_flag7_check-.token_table-2
    DC.W    .case_pair_check-.token_table-2

.case_alpha_or_copy:
    MOVEA.L -26(A5),A0
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1B68
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .use_default_char

    MOVEA.L -26(A5),A0
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    ADDA.L  D0,A1
    BTST    #1,(A1)
    BEQ.S   .copy_raw_char

    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .store_token_char

.copy_raw_char:
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0

.store_token_char:
    MOVE.B  D0,-11(A5,D7.L)
    BRA.W   .next_token

.use_default_char:
    MOVE.B  -22(A5,D7.L),-11(A5,D7.L)
    BRA.W   .next_token

.case_flag7_check:
    MOVEA.L -26(A5),A0
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .use_default_char_flag7

    MOVEA.L -26(A5),A0
    MOVE.B  0(A0,D7.L),-11(A5,D7.L)
    BRA.W   .next_token

.use_default_char_flag7:
    MOVE.B  -22(A5,D7.L),-11(A5,D7.L)
    BRA.W   .next_token

.case_pair_check:
    MOVEA.L -26(A5),A0
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A1
    MOVEA.L A1,A6
    ADDA.L  D0,A6
    MOVEQ   #7,D0
    AND.B   (A6),D0
    TST.B   D0
    BEQ.S   .copy_default_pair

    MOVE.B  1(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A1,A6
    ADDA.L  D0,A6
    MOVEQ   #7,D0
    AND.B   (A6),D0
    TST.B   D0
    BEQ.S   .copy_default_pair

    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A1,A6
    ADDA.L  D0,A6
    BTST    #1,(A6)
    BEQ.S   .copy_pair_char1

    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .store_pair_char1

.copy_pair_char1:
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0

.store_pair_char1:
    MOVE.B  D0,-11(A5,D7.L)
    ADDQ.L  #1,D7
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    ADDA.L  D0,A1
    BTST    #1,(A1)
    BEQ.S   .copy_pair_char2

    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .store_pair_char2

.copy_pair_char2:
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0

.store_pair_char2:
    MOVE.B  D0,-11(A5,D7.L)
    BRA.S   .next_token

.copy_default_pair:
    LEA     -11(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D7,A1
    MOVEA.L D7,A6
    ADDQ.L  #1,D7
    MOVE.L  A6,D0
    MOVE.B  -22(A5,D0.L),(A1)
    MOVE.B  -22(A5,D7.L),-11(A5,D7.L)

.next_token:
    ADDQ.L  #1,D7
    BRA.W   .token_loop

.commit_output:
    MOVE.L  (A2),-(A7)
    PEA     -11(A5)
    JSR     LAB_0385(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,(A2)
    BRA.S   .done

.empty_input:
    MOVE.L  (A3),-(A7)
    CLR.L   -(A7)
    JSR     LAB_0385(PC)

    MOVE.L  D0,(A3)
    MOVE.L  (A2),(A7)
    PEA     LAB_1B69
    JSR     LAB_0385(PC)

    LEA     12(A7),A7
    MOVE.L  D0,(A2)

.done:
    MOVEM.L (A7)+,D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_ParseAlignedListingBlock   (ParseAlignedListingBlock??)
; ARGS:
;   stack +4: dataPtr (char*)
; RET:
;   D0: status (0=ok, nonzero=error??)
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   COI_CountEscape14BeforeNull, LAB_037D, ESQ_WildcardMatch, LAB_0468, LAB_0385,
;   CLEANUP_FormatEntryStringTokens, COI_AllocSubEntryTable, LAB_02D1, LAB_02D5
; READS:
;   LAB_222D-LAB_2235, LAB_2232, LAB_1B8F-LAB_1B92,
;   LAB_2233, LAB_2235, LAB_2236, LAB_20ED
; WRITES:
;   LAB_1B8F-LAB_1B92
; DESC:
;   Parses an aligned listing block from dataPtr, selecting candidate entries,
;   building entry structs, and allocating subentry tables.
; NOTES:
;   - Uses COI_CountEscape14BeforeNull to locate delimiter fields.
;------------------------------------------------------------------------------
CLEANUP_ParseAlignedListingBlock:
LAB_02A5:
    LINK.W  A5,#-128
    MOVEM.L D2-D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    CLR.B   -57(A5)
    MOVEQ   #0,D0
    MOVEQ   #22,D1
    MOVE.B  D1,-97(A5)
    MOVEQ   #23,D2
    MOVE.B  D2,-96(A5)
    MOVE.B  #$3,-95(A5)
    MOVE.B  #$4,-94(A5)
    MOVEQ   #16,D3
    MOVE.B  D3,-93(A5)
    MOVEQ   #5,D4
    MOVE.B  D4,-92(A5)
    MOVE.L  D0,-70(A5)
    MOVE.L  D0,-66(A5)
    MOVE.L  D0,-62(A5)
    MOVEQ   #15,D0
    MOVE.B  D0,-91(A5)
    MOVEQ   #6,D0
    MOVE.B  D0,-90(A5)
    MOVEQ   #20,D0
    MOVE.B  D0,-89(A5)
    MOVE.B  D1,-125(A5)
    MOVE.B  D2,-124(A5)
    MOVE.B  D3,-123(A5)
    MOVE.B  D4,-122(A5)
    MOVE.B  #$f,-121(A5)
    MOVE.B  #$6,-120(A5)
    MOVE.B  D0,-119(A5)
    CLR.W   -32(A5)

.init_slot_table_loop:
    MOVE.W  -32(A5),D0
    MOVEQ   #10,D1
    CMP.W   D1,D0
    BGE.S   .after_slot_init

    MOVE.L  D0,D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVE.W  #(-1),-52(A5,D1.L)
    ADDQ.W  #1,-32(A5)
    BRA.S   .init_slot_table_loop

.after_slot_init:
    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    ADDQ.L  #1,-66(A5)
    MOVE.B  LAB_222D,D1
    MOVE.B  D0,-57(A5)
    CMP.B   D0,D1
    BNE.S   .check_service_type_b

    MOVE.B  LAB_222E,D1
    SUBQ.B  #1,D1
    BNE.S   .check_service_type_b

    MOVE.W  LAB_222F,D5
    MOVE.B  D0,LAB_1B92
    MOVEQ   #1,D1
    MOVE.B  D1,LAB_1B90
    BRA.S   .skip_separator

.check_service_type_b:
    MOVE.B  LAB_2230,D1
    CMP.B   D0,D1
    BNE.S   .invalid_service_type

    MOVE.W  LAB_2231,D5
    MOVE.B  D0,LAB_1B91
    MOVE.B  #$1,LAB_1B8F
    BRA.S   .skip_separator

.invalid_service_type:
    MOVEQ   #1,D0
    BRA.W   .return_status

.skip_separator:
    MOVEQ   #49,D0
    MOVE.L  -66(A5),D1
    CMP.B   0(A3,D1.L),D0
    BNE.S   .parse_field_offsets

    ADDQ.L  #1,-66(A5)

.parse_field_offsets:
    MOVEA.L A3,A0
    MOVE.L  -66(A5),D0
    ADDA.L  D0,A0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    SUB.L   D0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   COI_CountEscape14BeforeNull

    EXT.L   D0
    MOVEA.L A3,A0
    MOVE.L  -66(A5),D1
    ADDA.L  D1,A0
    MOVEQ   #0,D2
    MOVE.W  LAB_2232,D2
    SUB.L   D1,D2
    EXT.L   D2
    PEA     1.W
    CLR.L   -(A7)
    MOVE.L  D2,-(A7)
    PEA     -97(A5)
    PEA     9.W
    PEA     -88(A5)
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-62(A5)
    JSR     LAB_037D(PC)

    LEA     36(A7),A7
    EXT.L   D0
    MOVEQ   #0,D7
    CLR.W   -32(A5)
    MOVE.L  D0,-70(A5)

.scan_candidate_loop:
    CMP.W   D5,D7
    BGE.S   .after_candidate_scan

    CMPI.W  #10,-32(A5)
    BGE.S   .after_candidate_scan

    MOVE.B  LAB_222D,D0
    MOVE.B  -57(A5),D1
    CMP.B   D0,D1
    BNE.S   .use_alt_entry_table

    MOVE.B  LAB_222E,D0
    SUBQ.B  #1,D0
    BNE.S   .use_alt_entry_table

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2235,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    BRA.S   .compare_candidate_entry

.use_alt_entry_table:
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)

.compare_candidate_entry:
    MOVEA.L -4(A5),A0
    ADDA.W  #12,A0
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .store_candidate_slot

    MOVE.W  -32(A5),D0
    EXT.L   D0
    ADD.L   D0,D0
    MOVE.W  D7,-52(A5,D0.L)
    ADDQ.W  #1,-32(A5)

.store_candidate_slot:
    ADDQ.W  #1,D7
    BRA.S   .scan_candidate_loop

.after_candidate_scan:
    MOVE.W  -52(A5),D0
    ADDQ.W  #1,D0
    BNE.S   .select_first_entry

    MOVEQ   #2,D0
    BRA.W   .return_status

.select_first_entry:
    MOVE.B  LAB_222D,D0
    MOVE.B  -57(A5),D1
    CMP.B   D0,D1
    BNE.S   .select_alt_entry

    MOVE.B  LAB_222E,D0
    SUBQ.B  #1,D0
    BNE.S   .select_alt_entry

    MOVE.W  -52(A5),D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2235,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    BRA.S   .populate_entry_fields

.select_alt_entry:
    MOVE.W  -52(A5),D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)

.populate_entry_fields:
    MOVE.L  -4(A5),-(A7)
    BSR.W   LAB_02D1

    MOVE.L  -4(A5),(A7)
    BSR.W   LAB_02D5

    MOVEA.L -4(A5),A0
    MOVE.L  48(A0),-12(A5)
    MOVEA.L A3,A0
    ADDA.L  -66(A5),A0
    ADDA.W  -84(A5),A0
    MOVEA.L -12(A5),A1
    MOVE.L  4(A1),(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,4(A0)
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    MOVEA.W -82(A5),A2
    MOVE.L  A2,D0
    MOVE.B  0(A1,D0.W),(A0)
    MOVE.B  1(A1,D0.W),1(A0)
    MOVE.B  2(A1,D0.W),2(A0)
    CLR.B   3(A0)
    ADDA.W  -80(A5),A1
    MOVE.L  12(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,12(A0)
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    ADDA.W  -78(A5),A1
    MOVE.L  20(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,20(A0)
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    ADDA.W  -76(A5),A1
    MOVE.L  8(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,8(A0)
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    ADDA.W  -74(A5),A1
    MOVE.L  16(A0),(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_0385(PC)

    LEA     24(A7),A7
    MOVEA.L -12(A5),A0
    MOVE.L  D0,16(A0)
    MOVE.L  -62(A5),D0
    MOVE.W  D0,36(A0)
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    ADDA.W  -88(A5),A1
    TST.B   (A1)
    BEQ.S   .build_title_from_field

    LEA     24(A0),A2
    LEA     28(A0),A6
    MOVE.L  A1,-(A7)
    MOVE.L  A6,-(A7)
    MOVE.L  A2,-(A7)
    BSR.W   CLEANUP_FormatEntryStringTokens

    LEA     12(A7),A7
    BRA.S   .after_title_format

.build_title_from_field:
    MOVE.L  24(A0),-(A7)
    CLR.L   -(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -12(A5),A0
    MOVE.L  D0,24(A0)
    MOVE.L  28(A0),(A7)
    PEA     LAB_1B6A
    JSR     LAB_0385(PC)

    LEA     12(A7),A7
    MOVEA.L -12(A5),A0
    MOVE.L  D0,28(A0)

.after_title_format:
    MOVEA.L A3,A0
    ADDA.L  -66(A5),A0
    ADDA.W  -86(A5),A0
    TST.B   (A0)
    BEQ.S   .set_missing_extra

    MOVE.L  A0,-(A7)
    JSR     LAB_0468(PC)

    ADDQ.W  #4,A7
    MOVEA.L -12(A5),A0
    MOVE.L  D0,32(A0)
    BRA.S   .advance_entry_offset

.set_missing_extra:
    MOVEQ   #-1,D0
    MOVEA.L -12(A5),A0
    MOVE.L  D0,32(A0)

.advance_entry_offset:
    MOVE.W  -74(A5),D0
    EXT.L   D0
    ADD.L   D0,-66(A5)
    TST.L   16(A0)
    BEQ.S   .alloc_subentry_table

    MOVEA.L -12(A5),A1
    MOVEA.L 16(A1),A0

.count_entry_text_loop:
    TST.B   (A0)+
    BNE.S   .count_entry_text_loop

    SUBQ.L  #1,A0
    SUBA.L  16(A1),A0
    MOVE.L  A0,D0
    ADD.L   D0,-66(A5)

.alloc_subentry_table:
    ADDQ.L  #1,-66(A5)
    MOVE.L  -4(A5),-(A7)
    BSR.W   COI_AllocSubEntryTable

    ADDQ.W  #4,A7
    MOVEQ   #0,D6

.subentry_loop:
    MOVEA.L -12(A5),A0
    CMP.W   36(A0),D6
    BGE.W   .begin_merge

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -12(A5),A1
    MOVEA.L 38(A1),A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-20(A5)
    MOVEQ   #0,D0
    MOVE.L  -66(A5),D1
    MOVE.B  0(A3,D1.L),D0
    MOVEA.L -20(A5),A0
    MOVE.W  D0,(A0)
    ADDQ.L  #1,-66(A5)
    MOVEA.L A3,A1
    MOVE.L  -66(A5),D0
    ADDA.L  D0,A1
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    SUB.L   D0,D1
    EXT.L   D1
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    PEA     -125(A5)
    PEA     7.W
    PEA     -116(A5)
    MOVE.L  A1,-(A7)
    JSR     LAB_037D(PC)

    LEA     28(A7),A7
    MOVE.W  -112(A5),D0
    ADDQ.W  #1,D0
    BNE.S   .select_subentry_title

    MOVEA.L -12(A5),A1
    MOVEA.L 12(A1),A0
    BRA.S   .store_subentry_title

.select_subentry_title:
    MOVEA.L A3,A0
    ADDA.L  -66(A5),A0
    ADDA.W  -112(A5),A0

.store_subentry_title:
    MOVEA.L -20(A5),A1
    MOVE.L  6(A1),-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-56(A5)
    JSR     LAB_0385(PC)

    ADDQ.W  #8,A7
    MOVEA.L -20(A5),A0
    MOVE.L  D0,6(A0)
    MOVE.W  -110(A5),D0
    ADDQ.W  #1,D0
    BNE.S   .select_subentry_desc

    MOVEA.L -12(A5),A2
    MOVEA.L 20(A2),A1
    BRA.S   .store_subentry_desc

.select_subentry_desc:
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    ADDA.W  -110(A5),A1

.store_subentry_desc:
    MOVE.L  14(A0),-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A1,-56(A5)
    JSR     LAB_0385(PC)

    ADDQ.W  #8,A7
    MOVEA.L -20(A5),A0
    MOVE.L  D0,14(A0)
    MOVE.W  -108(A5),D0
    ADDQ.W  #1,D0
    BNE.S   .select_subentry_alt

    MOVEA.L -12(A5),A2
    MOVEA.L 8(A2),A1
    BRA.S   .store_subentry_alt

.select_subentry_alt:
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    ADDA.W  -108(A5),A1

.store_subentry_alt:
    MOVE.L  2(A0),-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A1,-56(A5)
    JSR     LAB_0385(PC)

    ADDQ.W  #8,A7
    MOVEA.L -20(A5),A0
    MOVE.L  D0,2(A0)
    MOVE.W  -106(A5),D0
    ADDQ.W  #1,D0
    BNE.S   .select_subentry_more

    MOVEA.L -12(A5),A2
    MOVEA.L 16(A2),A1
    BRA.S   .store_subentry_more

.select_subentry_more:
    MOVEA.L A3,A1
    ADDA.L  -66(A5),A1
    ADDA.W  -106(A5),A1

.store_subentry_more:
    MOVE.L  10(A0),-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A1,-56(A5)
    JSR     LAB_0385(PC)

    ADDQ.W  #8,A7
    MOVEA.L -20(A5),A0
    MOVE.L  D0,10(A0)
    MOVE.W  -116(A5),D0
    ADDQ.W  #1,D0
    BNE.S   .format_subentry_extra

    MOVE.L  18(A0),-(A7)
    MOVEA.L -12(A5),A1
    MOVE.L  24(A1),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -20(A5),A0
    MOVE.L  D0,18(A0)
    MOVE.L  22(A0),(A7)
    MOVEA.L -12(A5),A1
    MOVE.L  28(A1),-(A7)
    JSR     LAB_0385(PC)

    LEA     12(A7),A7
    MOVEA.L -20(A5),A0
    MOVE.L  D0,22(A0)
    BRA.S   .store_subentry_extra

.format_subentry_extra:
    LEA     18(A0),A1
    LEA     22(A0),A2
    MOVEA.L A3,A0
    ADDA.L  -66(A5),A0
    ADDA.W  -116(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A1,-(A7)
    BSR.W   CLEANUP_FormatEntryStringTokens

    LEA     12(A7),A7

.store_subentry_extra:
    MOVE.W  -114(A5),D0
    ADDQ.W  #1,D0
    BNE.S   .load_subentry_icon

    MOVEA.L -12(A5),A0
    MOVEA.L -20(A5),A1
    MOVE.L  32(A0),26(A1)
    BRA.S   .advance_subentry_offset

.load_subentry_icon:
    MOVEA.L A3,A0
    ADDA.L  -66(A5),A0
    ADDA.W  -114(A5),A0
    MOVE.L  A0,-(A7)
    JSR     LAB_0468(PC)

    ADDQ.W  #4,A7
    MOVEA.L -20(A5),A0
    MOVE.L  D0,26(A0)

.advance_subentry_offset:
    MOVE.W  -104(A5),D0
    EXT.L   D0
    ADD.L   D0,-66(A5)
    ADDQ.W  #1,D6
    BRA.W   .subentry_loop

.begin_merge:
    MOVE.W  #1,-32(A5)

.merge_candidate_loop:
    MOVE.W  -32(A5),D0
    EXT.L   D0
    ADD.L   D0,D0
    MOVEQ   #-1,D1
    CMP.W   -52(A5,D0.L),D1
    BEQ.W   .return_success

    MOVE.W  -32(A5),D0
    MOVEQ   #10,D1
    CMP.W   D1,D0
    BGE.W   .return_success

    MOVE.B  LAB_222D,D1
    MOVE.B  -57(A5),D2
    CMP.B   D1,D2
    BNE.S   .select_merge_table

    MOVE.B  LAB_222E,D1
    SUBQ.B  #1,D1
    BNE.S   .select_merge_table

    MOVE.L  D0,D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVE.W  -52(A5,D1.L),D2
    EXT.L   D2
    ASL.L   #2,D2
    LEA     LAB_2235,A0
    ADDA.L  D2,A0
    MOVE.L  (A0),-8(A5)
    BRA.S   .merge_entry_copy

.select_merge_table:
    MOVE.L  D0,D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVE.W  -52(A5,D1.L),D2
    EXT.L   D2
    ASL.L   #2,D2
    LEA     LAB_2233,A0
    ADDA.L  D2,A0
    MOVE.L  (A0),-8(A5)

.merge_entry_copy:
    MOVEA.L -4(A5),A0
    MOVE.L  48(A0),-12(A5)
    MOVEA.L -8(A5),A0
    MOVE.L  48(A0),-16(A5)
    ADDQ.W  #1,-32(A5)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_02D1

    MOVE.L  -8(A5),(A7)
    BSR.W   LAB_02D5

    MOVEA.L -16(A5),A0
    MOVE.L  4(A0),(A7)
    MOVEA.L -12(A5),A1
    MOVE.L  4(A1),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -16(A5),A0
    MOVE.L  D0,4(A0)
    MOVEA.L -12(A5),A0
    MOVEA.L -16(A5),A1
    MOVE.B  (A0),(A1)
    MOVE.B  1(A0),1(A1)
    MOVE.B  2(A0),2(A1)
    MOVE.B  3(A0),3(A1)
    MOVE.L  12(A1),(A7)
    MOVE.L  12(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -16(A5),A0
    MOVE.L  D0,12(A0)
    MOVE.L  20(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  20(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -16(A5),A0
    MOVE.L  D0,20(A0)
    MOVE.L  8(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  8(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -16(A5),A0
    MOVE.L  D0,8(A0)
    MOVE.L  16(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  16(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -16(A5),A0
    MOVE.L  D0,16(A0)
    MOVEA.L -12(A5),A0
    MOVEA.L -16(A5),A1
    MOVE.W  36(A0),36(A1)
    MOVE.L  24(A1),(A7)
    MOVE.L  24(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -16(A5),A0
    MOVE.L  D0,24(A0)
    MOVE.L  28(A0),(A7)
    MOVEA.L -12(A5),A0
    MOVE.L  28(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -16(A5),A0
    MOVE.L  D0,28(A0)
    MOVEA.L -12(A5),A0
    MOVEA.L -16(A5),A1
    MOVE.L  32(A0),32(A1)
    MOVE.L  -8(A5),(A7)
    BSR.W   COI_AllocSubEntryTable

    LEA     32(A7),A7
    MOVEQ   #0,D7

.merge_subentry_loop:
    MOVEA.L -12(A5),A0
    CMP.W   36(A0),D7
    BGE.W   .merge_candidate_loop

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -12(A5),A1
    MOVEA.L 38(A1),A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-20(A5)
    MOVEA.L -16(A5),A1
    MOVEA.L 38(A1),A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-24(A5)
    MOVEA.L -20(A5),A0
    MOVEA.L -24(A5),A1
    MOVE.W  (A0),(A1)
    MOVE.L  6(A1),-(A7)
    MOVE.L  6(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,6(A0)
    MOVE.L  14(A0),(A7)
    MOVEA.L -20(A5),A0
    MOVE.L  14(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,14(A0)
    MOVE.L  2(A0),(A7)
    MOVEA.L -20(A5),A0
    MOVE.L  2(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,2(A0)
    MOVE.L  10(A0),(A7)
    MOVEA.L -20(A5),A0
    MOVE.L  10(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,10(A0)
    MOVE.L  18(A0),(A7)
    MOVEA.L -20(A5),A0
    MOVE.L  18(A0),-(A7)
    JSR     LAB_0385(PC)

    MOVEA.L -24(A5),A0
    MOVE.L  D0,18(A0)
    MOVE.L  22(A0),(A7)
    MOVEA.L -20(A5),A0
    MOVE.L  22(A0),-(A7)
    JSR     LAB_0385(PC)

    LEA     28(A7),A7
    MOVEA.L -24(A5),A0
    MOVE.L  D0,22(A0)
    MOVEA.L -20(A5),A0
    MOVEA.L -24(A5),A1
    MOVE.L  26(A0),26(A1)
    ADDQ.W  #1,D7
    BRA.W   .merge_subentry_loop

.return_success:
    MOVEQ   #0,D0

.return_status:
    MOVEM.L (A7)+,D2-D7/A2-A3/A6
    UNLK    A5
    RTS
