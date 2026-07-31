    XDEF    _LADFUNC_ReflowEntryBuffers


;------------------------------------------------------------------------------
; FUNC: _LADFUNC_ReflowEntryBuffers   (Reflow entry buffersuncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +8: arg_3 (via 12(A5))
;   stack +47: arg_4 (via 51(A5))
;   stack +96: arg_5 (via 100(A5))
;   stack +100: arg_6 (via 104(A5))
;   stack +104: arg_7 (via 108(A5))
;   stack +108: arg_8 (via 112(A5))
;   stack +112: arg_9 (via 116(A5))
;   stack +116: arg_10 (via 120(A5))
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   _NEWGRID_JMPTBL_MEMORY_AllocateMemory, _NEWGRID_JMPTBL_MEMORY_DeallocateMemory,
;   _NEWGRID_JMPTBL_MATH_DivS32
; READS:
;   _ED_TextLimit
; WRITES:
;   outText/outAttr buffers
; DESC:
;   Copies and reflows entry text/attr buffers into fixed-width rows.
; NOTES:
;   Honors control bytes 24/25/26 and line breaks.
;------------------------------------------------------------------------------
_LADFUNC_ReflowEntryBuffers:
    LINK.W  A5,#-120
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEA.L A3,A0

.scan_text_end:
    TST.B   (A0)+
    BNE.S   .scan_text_end

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D0
    MOVE.L  D0,-116(A5)
    ADDQ.L  #1,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     1025.W
    PEA     _Global_STR_LADFUNC_C_20
    JSR     _NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    MOVE.L  -116(A5),-(A7)
    PEA     1026.W
    PEA     _Global_STR_LADFUNC_C_21
    MOVE.L  D0,-6(A5)
    JSR     _NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     28(A7),A7
    MOVE.L  D0,-10(A5)
    TST.L   -6(A5)
    BEQ.W   .cleanup

    TST.L   D0
    BEQ.W   .cleanup

    MOVEA.L A3,A0
    MOVEA.L -6(A5),A1

.copy_text_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_text_loop

    MOVE.L  -116(A5),D0
    MOVEA.L A2,A0
    MOVEA.L -10(A5),A1
    BRA.S   .copy_attr_next

.copy_attr_loop:
    MOVE.B  (A0)+,(A1)+

.copy_attr_next:
    SUBQ.L  #1,D0
    BCC.S   .copy_attr_loop

    MOVEQ   #0,D7
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D5
    MOVE.L  D0,-100(A5)
    MOVE.L  D0,-104(A5)
    MOVE.L  D0,-112(A5)

.row_loop:
    CMP.L   _ED_TextLimit,D5
    BGE.W   .finish_all

.scan_row:
    MOVEA.L -6(A5),A0
    MOVE.L  -100(A5),D0
    TST.B   0(A0,D0.L)
    BEQ.W   .finalize_line

    MOVE.L  -104(A5),D1
    MOVEQ   #40,D2
    CMP.L   D2,D1
    BGE.W   .finalize_line

    MOVE.B  0(A0,D0.L),D2
    MOVEQ   #10,D3
    CMP.B   D3,D2
    BEQ.S   .skip_linebreak

    MOVEQ   #13,D3
    CMP.B   D3,D2
    BNE.S   .check_control_start

.skip_linebreak:
    ADDQ.L  #1,-100(A5)
    BRA.S   .scan_row

.check_control_start:
    TST.B   D7
    BNE.S   .check_control_mid

    MOVE.B  0(A0,D0.L),D2
    MOVEQ   #24,D3
    CMP.B   D3,D2
    BEQ.S   .set_control_mode

    MOVEQ   #25,D4
    CMP.B   D4,D2
    BEQ.S   .set_control_mode

    MOVEQ   #26,D2
    CMP.B   0(A0,D0.L),D2
    BNE.S   .set_default_mode

.set_control_mode:
    MOVE.B  0(A0,D0.L),D7
    ADDQ.L  #1,-100(A5)
    MOVEA.L -10(A5),A1
    MOVE.B  0(A1,D0.L),D6
    BRA.S   .scan_row

.set_default_mode:
    MOVE.L  D4,D7
    MOVEA.L -10(A5),A1
    MOVE.B  0(A1,D0.L),D6
    BRA.S   .scan_row

.check_control_mid:
    MOVE.B  0(A0,D0.L),D2
    MOVEQ   #24,D3
    CMP.B   D3,D2
    BEQ.S   .finalize_line

    MOVEQ   #25,D3
    CMP.B   D3,D2
    BEQ.S   .finalize_line

    MOVEQ   #26,D2
    CMP.B   0(A0,D0.L),D2
    BNE.S   .emit_char_to_line

    BRA.S   .finalize_line

.emit_char_to_line:
    MOVE.B  0(A0,D0.L),-51(A5,D1.L)
    ADDQ.L  #1,-104(A5)
    ADDQ.L  #1,-100(A5)
    MOVEA.L -10(A5),A0
    MOVE.B  0(A0,D0.L),-91(A5,D1.L)
    BRA.W   .scan_row

.finalize_line:
    MOVE.L  -104(A5),D0
    CLR.B   -51(A5,D0.L)
    LEA     -51(A5),A0
    MOVEA.L A0,A1

.scan_line_len:
    TST.B   (A1)+
    BNE.S   .scan_line_len

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEQ   #40,D1
    SUB.L   D0,D1
    MOVEM.L D1,-120(A5)
    MOVEQ   #24,D0
    CMP.B   D0,D7
    BNE.S   .indent_for_26

    MOVEQ   #2,D0
    MOVE.L  D0,-104(A5)
    BRA.S   .indent_ready

.indent_for_26:
    MOVEQ   #26,D0
    CMP.B   D0,D7
    BNE.S   .indent_default

    MOVEQ   #1,D0
    MOVE.L  D0,-104(A5)
    BRA.S   .indent_ready

.indent_default:
    MOVEQ   #0,D0
    MOVE.L  D0,-104(A5)

.indent_ready:
    MOVE.L  -104(A5),D0
    TST.L   D0
    BLE.S   .copy_line_to_output

    TST.L   D1
    BLE.S   .copy_line_to_output

    CLR.L   -108(A5)

.indent_loop:
    MOVE.L  -120(A5),D0
    MOVE.L  -104(A5),D1
    JSR     _NEWGRID_JMPTBL_MATH_DivS32(PC)

    MOVE.L  -108(A5),D1
    CMP.L   D0,D1
    BGE.S   .after_indent

    MOVE.L  -112(A5),D0
    MOVE.B  #$20,0(A3,D0.L)
    MOVE.B  D6,0(A2,D0.L)
    ADDQ.L  #1,-108(A5)
    ADDQ.L  #1,-112(A5)
    BRA.S   .indent_loop

.after_indent:
    MOVE.L  -120(A5),D0
    MOVE.L  -104(A5),D1
    JSR     _NEWGRID_JMPTBL_MATH_DivS32(PC)

    SUB.L   D0,-120(A5)

.copy_line_to_output:
    CLR.L   -108(A5)

.copy_line_loop:
    MOVE.L  -108(A5),D0
    TST.B   -51(A5,D0.L)
    BEQ.S   .tail_spaces

    MOVE.L  -112(A5),D1
    MOVE.B  -51(A5,D0.L),0(A3,D1.L)
    MOVE.B  -91(A5,D0.L),0(A2,D1.L)
    ADDQ.L  #1,-108(A5)
    ADDQ.L  #1,-112(A5)
    BRA.S   .copy_line_loop

.tail_spaces:
    MOVE.L  -120(A5),D0
    TST.L   D0
    BLE.S   .next_row

    CLR.L   -108(A5)

.tail_space_loop:
    MOVE.L  -108(A5),D0
    CMP.L   -120(A5),D0
    BGE.S   .next_row

    MOVE.L  -112(A5),D0
    MOVE.B  #$20,0(A3,D0.L)
    MOVE.B  D6,0(A2,D0.L)
    ADDQ.L  #1,-108(A5)
    ADDQ.L  #1,-112(A5)
    BRA.S   .tail_space_loop

.next_row:
    ADDQ.L  #1,D5
    CLR.L   -104(A5)
    MOVEQ   #0,D7
    BRA.W   .row_loop

.finish_all:
    MOVE.L  -112(A5),D0
    CLR.B   0(A3,D0.L)

.cleanup:
    TST.L   -6(A5)
    BEQ.S   .free_attr

    MOVE.L  -116(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -6(A5),-(A7)
    PEA     1146.W
    PEA     _Global_STR_LADFUNC_C_22
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.free_attr:
    TST.L   -10(A5)
    BEQ.S   .return

    MOVE.L  -116(A5),-(A7)
    MOVE.L  -10(A5),-(A7)
    PEA     1148.W
    PEA     _Global_STR_LADFUNC_C_23
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.return:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======