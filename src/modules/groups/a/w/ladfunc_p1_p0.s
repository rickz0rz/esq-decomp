    XDEF    _LADFUNC_DisplayTextPackedPens
    XDEF    _LADFUNC_DrawEntryLineWithAttrs


;------------------------------------------------------------------------------
; FUNC: _LADFUNC_DisplayTextPackedPens   (Display text with packed pensuncertain)
; ARGS:
;   (none observed)
; RET:
;   (none)
; CLOBBERS:
;   A1/A2/A3/A6/A7/D0/D1/D5/D6/D7
; CALLS:
;   _LADFUNC_GetPackedPenLowNibble, _LADFUNC_GetPackedPenHighNibble, _LVOSetAPen, _LVOSetBPen, _GROUP_AW_JMPTBL_DISPLIB_DisplayTextAtPosition
; READS:
;   _Global_REF_GRAPHICS_LIBRARY
; WRITES:
;   (none)
; DESC:
;   Sets APen/BPen from packed nibble and draws text at position.
; NOTES:
;   Packed pen byte uses low nibble for APen and high nibble for BPen.
;------------------------------------------------------------------------------
_LADFUNC_DisplayTextPackedPens:
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.L  28(A7),D7
    MOVE.L  32(A7),D6
    MOVE.B  39(A7),D5
    MOVEA.L 40(A7),A2
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVE.L  D0,-(A7)
    BSR.W   _LADFUNC_GetPackedPenLowNibble

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEA.L A3,A1
    MOVE.L  D1,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVE.L  D0,(A7)
    BSR.W   _LADFUNC_GetPackedPenHighNibble

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEA.L A3,A1
    MOVE.L  D1,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetBPen(A6)

    MOVE.L  A2,(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    JSR     _GROUP_AW_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVEM.L (A7)+,D5-D7/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _LADFUNC_DrawEntryLineWithAttrs   (Draw entry line with attributesuncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +8: arg_3 (via 12(A5))
;   stack +10: arg_4 (via 14(A5))
;   stack +12: arg_5 (via 16(A5))
;   stack +14: arg_6 (via 18(A5))
;   stack +16: arg_7 (via 20(A5))
;   stack +18: arg_8 (via 22(A5))
;   stack +22: arg_9 (via 26(A5))
;   stack +26: arg_10 (via 30(A5))
;   stack +30: arg_11 (via 34(A5))
;   stack +34: arg_12 (via 38(A5))
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   _LVOTextLength, _NEWGRID_JMPTBL_MATH_Mulu32, _NEWGRID_JMPTBL_MATH_DivS32,
;   _NEWGRID_JMPTBL_MEMORY_AllocateMemory, _NEWGRID_JMPTBL_MEMORY_DeallocateMemory,
;   _LADFUNC_DisplayTextPackedPens
; READS:
;   _Global_STR_SINGLE_SPACE_1, _ED_TextLimit
; WRITES:
;   (none)
; DESC:
;   Splits a line into attribute runs and renders them centered within bounds.
; NOTES:
;   Control codes 24/25/26 affect leading alignment/attributes.
;------------------------------------------------------------------------------
_LADFUNC_DrawEntryLineWithAttrs:
    LINK.W  A5,#-44
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVEA.L 16(A5),A2
    MOVEQ   #0,D6
    MOVEA.L A3,A1
    LEA     _Global_STR_SINGLE_SPACE_1,A0
    MOVEQ   #1,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,-26(A5)
    MOVE.L  #624,D0
    MOVE.L  -26(A5),D1
    JSR     _NEWGRID_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D0,-22(A5)
    MOVEQ   #40,D1
    CMP.L   D1,D0
    BLE.S   .cap_columns

    MOVE.L  D1,-22(A5)

.cap_columns:
    MOVE.L  -22(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     712.W
    PEA     _Global_STR_LADFUNC_C_14
    JSR     _NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   .return

    MOVE.B  (A2),D1
    MOVEQ   #24,D2
    CMP.B   D2,D1
    BEQ.S   .control_prefix

    MOVEQ   #25,D2
    CMP.B   D2,D1
    BEQ.S   .control_prefix

    MOVEQ   #26,D2
    CMP.B   D2,D1
    BNE.S   .text_ptr_ready

.control_prefix:
    MOVE.L  D1,D6
    MOVEA.L 20(A5),A0
    MOVE.B  (A0)+,D5
    ADDQ.L  #1,A2
    MOVE.L  A0,20(A5)

.text_ptr_ready:
    MOVEA.L A2,A0

.scan_text_end:
    TST.B   (A0)+
    BNE.S   .scan_text_end

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,-10(A5)
    MOVE.L  -22(A5),D1
    CMPA.L  D1,A0
    BLE.S   .length_ready

    MOVE.L  D1,-10(A5)

.length_ready:
    MOVE.L  -10(A5),D2
    MOVE.L  D1,D3
    SUB.L   D2,D3
    MOVEM.L D3,-30(A5)
    BLE.S   .prepare_offsets

    TST.B   D6
    BNE.S   .prepare_offsets

    MOVEA.L 20(A5),A0
    MOVE.B  0(A0,D2.L),D5

.prepare_offsets:
    MOVEA.L 4(A3),A0
    MOVEQ   #0,D2
    MOVE.W  (A0),D2
    ASL.L   #3,D2
    MOVE.L  -26(A5),D0
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    SUB.L   D0,D2
    TST.L   D2
    BPL.S   .x_offset_ready

    ADDQ.L  #1,D2

.x_offset_ready:
    ASR.L   #1,D2
    MOVEA.L 52(A3),A1
    MOVEQ   #0,D0
    MOVE.W  20(A1),D0
    MOVE.L  _ED_TextLimit,D1
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #0,D1
    MOVE.W  2(A0),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .y_offset_ready

    ADDQ.L  #1,D1

.y_offset_ready:
    ASR.L   #1,D1
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVEQ   #0,D4
    MOVE.W  20(A1),D4
    MOVE.L  D1,-38(A5)
    MOVE.L  D4,D1
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D0,-38(A5)
    MOVE.L  D2,-34(A5)
    BGE.S   .clamp_x

    MOVEQ   #0,D0
    MOVE.L  D0,-34(A5)

.clamp_x:
    MOVE.L  -38(A5),D0
    TST.L   D0
    BPL.S   .clamp_y

    MOVEQ   #0,D0
    MOVE.L  D0,-38(A5)

.clamp_y:
    MOVEQ   #24,D0
    CMP.B   D0,D6
    BNE.S   .indent_for_26

    MOVEQ   #2,D0
    MOVE.L  D0,-14(A5)
    BRA.S   .indent_ready

.indent_for_26:
    MOVEQ   #26,D0
    CMP.B   D0,D6
    BNE.S   .indent_default

    MOVEQ   #1,D0
    MOVE.L  D0,-14(A5)
    BRA.S   .indent_ready

.indent_default:
    MOVEQ   #0,D0
    MOVE.L  D0,-14(A5)

.indent_ready:
    TST.L   -14(A5)
    BEQ.S   .after_indent_draw

    TST.L   D3
    BEQ.S   .after_indent_draw

    MOVE.L  D3,D0
    MOVE.L  -14(A5),D1
    JSR     _NEWGRID_JMPTBL_MATH_DivS32(PC)

    MOVEQ   #32,D1
    MOVEA.L -4(A5),A0
    BRA.S   .indent_fill_next

.indent_fill_loop:
    MOVE.B  D1,(A0)+

.indent_fill_next:
    SUBQ.L  #1,D0
    BCC.S   .indent_fill_loop

    MOVE.L  -30(A5),D0
    MOVE.L  -14(A5),D1
    JSR     _NEWGRID_JMPTBL_MATH_DivS32(PC)

    MOVEA.L -4(A5),A0
    CLR.B   0(A0,D0.L)
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -38(A5),-(A7)
    MOVE.L  -34(A5),-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _LADFUNC_DisplayTextPackedPens

    LEA     20(A7),A7
    MOVE.L  -30(A5),D0
    MOVE.L  -14(A5),D1
    JSR     _NEWGRID_JMPTBL_MATH_DivS32(PC)

    MOVE.L  -26(A5),D1
    MOVE.L  D0,32(A7)
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D0,-34(A5)
    MOVE.L  32(A7),D0
    SUB.L   D0,-30(A5)

.after_indent_draw:
    CLR.L   -14(A5)

.segment_loop:
    MOVE.L  -14(A5),D0
    CMP.L   -10(A5),D0
    BGE.W   .tail_spaces

    CLR.L   -18(A5)

.segment_scan:
    MOVE.L  -14(A5),D0
    MOVE.L  -18(A5),D1
    MOVE.L  D1,D2
    ADD.L   D0,D2
    CMP.L   -10(A5),D2
    BGE.S   .emit_segment

    MOVEA.L 20(A5),A0
    MOVE.B  0(A0,D0.L),D3
    CMP.B   0(A0,D2.L),D3
    BNE.S   .emit_segment

    ADD.L   D1,D0
    MOVEA.L -4(A5),A0
    MOVE.B  0(A2,D0.L),0(A0,D1.L)
    ADDQ.L  #1,-18(A5)
    BRA.S   .segment_scan

.emit_segment:
    MOVEA.L -4(A5),A0
    MOVE.L  -18(A5),D0
    CLR.B   0(A0,D0.L)
    MOVEQ   #0,D0
    MOVEA.L 20(A5),A1
    MOVE.L  -14(A5),D1
    MOVE.B  0(A1,D1.L),D0
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -38(A5),-(A7)
    MOVE.L  -34(A5),-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _LADFUNC_DisplayTextPackedPens

    LEA     20(A7),A7
    MOVE.L  -26(A5),D0
    MOVE.L  -18(A5),D1
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D0,-34(A5)
    MOVE.L  -18(A5),D0
    ADD.L   D0,-14(A5)
    BRA.W   .segment_loop

.tail_spaces:
    TST.L   -30(A5)
    BEQ.S   .free_buffer

    MOVE.L  -30(A5),D0
    MOVEQ   #32,D1
    MOVEA.L -4(A5),A0
    BRA.S   .tail_fill_next

.tail_fill_loop:
    MOVE.B  D1,(A0)+

.tail_fill_next:
    SUBQ.L  #1,D0
    BCC.S   .tail_fill_loop

    MOVEA.L -4(A5),A0
    MOVE.L  -30(A5),D0
    CLR.B   0(A0,D0.L)
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -38(A5),-(A7)
    MOVE.L  -34(A5),-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _LADFUNC_DisplayTextPackedPens

    LEA     20(A7),A7

.free_buffer:
    MOVE.L  -22(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     824.W
    PEA     _Global_STR_LADFUNC_C_15
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.return:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======