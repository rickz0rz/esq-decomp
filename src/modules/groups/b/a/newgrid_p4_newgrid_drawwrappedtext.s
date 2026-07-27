    XDEF    _NEWGRID_DrawWrappedText


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_DrawWrappedText   (Draw and wrap text)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
;   stack +20: arg_5 (via 24(A5))
;   stack +24: arg_6 (via 28(A5))
;   stack +70: arg_7 (via 74(A5))
; RET:
;   D0: pointer to next word (or current)
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _NEWGRID2_JMPTBL_STR_SkipClass3Chars, _NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN, _LVOTextLength, _LVOMove, _LVOText
; READS:
;   _Global_STR_SINGLE_SPACE, _NEWGRID_WrapWordSpacer, _NEWGRID_WrapReturnSpacer
; WRITES:
;   local buffers -74(A5)
; DESC:
;   Draws words from a string with wrapping based on available width, returning
;   the next pointer to continue from.
; NOTES:
;   When draw flag is zero, calculates positions without drawing.
;------------------------------------------------------------------------------
_NEWGRID_DrawWrappedText:
    LINK.W  A5,#-80
    MOVEM.L D5-D7/A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    MOVE.L  20(A5),D5
    MOVEA.L 24(A5),A2

    MOVEQ   #0,D0
    MOVE.L  D0,-16(A5)
    MOVE.L  D0,-12(A5)
    MOVE.L  A2,D0
    BEQ.S   .init_empty_input

    MOVE.L  A2,-(A7)
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-20(A5)
    BRA.S   .begin_word_scan

.init_empty_input:
    SUBA.L  A0,A0
    MOVE.L  A0,-20(A5)

.begin_word_scan:
    MOVE.L  -20(A5),-24(A5)
    MOVEA.L A3,A1

    ; Get the width of a single space
    LEA     _Global_STR_SINGLE_SPACE,A0
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,-8(A5)
    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    JSR     _LVOMove(A6)

.process_words:
    TST.L   -20(A5)
    BEQ.W   .return_next_ptr_or_current

    PEA     _NEWGRID_WrapWordSpacer
    PEA     50.W
    PEA     -74(A5)
    MOVE.L  -20(A5),-(A7)
    JSR     _NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN(PC)

    MOVE.L  D0,(A7)
    MOVE.L  D0,-20(A5)
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    LEA     16(A7),A7
    MOVE.B  -74(A5),D1
    MOVE.L  D0,-20(A5)
    TST.B   D1
    BNE.S   .measure_current_word

    MOVEQ   #0,D0
    BRA.W   .return_next_ptr_or_current

.measure_current_word:
    LEA     -74(A5),A0
    MOVEA.L A0,A1

.measure_word:
    TST.B   (A1)+
    BNE.S   .measure_word

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,20(A7)
    MOVEA.L A3,A1
    MOVE.L  20(A7),D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D5,D1
    SUB.L   -12(A5),D1
    MOVE.L  D0,-4(A5)
    CMP.L   D1,D0
    BGT.S   .handle_word_overflow

    TST.L   28(A5)
    BEQ.S   .advance_after_word

    LEA     -74(A5),A0
    MOVEA.L A0,A1

.draw_word:
    TST.B   (A1)+
    BNE.S   .draw_word

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,20(A7)
    MOVEA.L A3,A1
    MOVE.L  20(A7),D0
    JSR     _LVOText(A6)

.advance_after_word:
    MOVE.L  -4(A5),D0
    ADD.L   D0,-12(A5)
    MOVE.L  -20(A5),-24(A5)
    BRA.S   .check_following_word

.handle_word_overflow:
    CMP.L   D5,D0
    BLE.S   .return_previous_word_ptr

    LEA     -74(A5),A0
    MOVEA.L A0,A1

.measure_word_trim:
    TST.B   (A1)+
    BNE.S   .measure_word_trim

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-16(A5)

.shrink_word:
    MOVE.L  -16(A5),D0
    TST.L   D0
    BLE.S   .draw_trimmed_fragment

    MOVEA.L A3,A1
    LEA     -74(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D5,D1
    SUB.L   -12(A5),D1
    CMP.L   D1,D0
    BLE.S   .draw_trimmed_fragment

    SUBQ.L  #1,-16(A5)
    BRA.S   .shrink_word

.draw_trimmed_fragment:
    MOVE.L  -16(A5),D0
    TST.L   D0
    BLE.S   .return_trimmed_ptr

    TST.L   28(A5)
    BEQ.S   .return_trimmed_ptr

    MOVEA.L A3,A1
    LEA     -74(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

.return_trimmed_ptr:
    MOVEA.L -24(A5),A0
    MOVEA.L A0,A1
    ADDA.L  -16(A5),A1
    MOVE.L  A1,D0
    BRA.S   .return_next_ptr_or_current

.return_previous_word_ptr:
    MOVE.L  -24(A5),D0
    BRA.S   .return_next_ptr_or_current

.check_following_word:
    MOVEA.L -20(A5),A0
    TST.B   (A0)
    BEQ.W   .process_words

    MOVE.L  -8(A5),D0
    ADD.L   -12(A5),D0
    CMP.L   D5,D0
    BGT.S   .return_word_boundary_ptr

    TST.L   28(A5)
    BEQ.S   .draw_space

    ; Draw a single space
    MOVEA.L A3,A1
    LEA     _NEWGRID_WrapReturnSpacer,A0
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

.draw_space:
    MOVE.L  -8(A5),D0
    ADD.L   D0,-12(A5)
    BRA.W   .process_words

.return_word_boundary_ptr:
    MOVE.L  -24(A5),D0

.return_next_ptr_or_current:
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======