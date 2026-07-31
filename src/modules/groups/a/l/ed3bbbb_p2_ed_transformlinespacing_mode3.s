    XDEF    _ED_TransformLineSpacing_Mode3


;------------------------------------------------------------------------------
; FUNC: _ED_TransformLineSpacing_Mode3   (Transform line spacing mode 3uncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A7/D0/D1/D2/D6/D7
; CALLS:
;   _ESQIFF_JMPTBL_MATH_Mulu32, _ESQFUNC_JMPTBL_STRING_CopyPadNul
; READS:
;   _ED_EditCursorOffset, _ED_ViewportOffset
; WRITES:
;   (none observed)
; DESC:
;   Rearranges line buffers according to a spacing rule (mode 3).
; NOTES:
;   Uses local buffers on the stack for processing.
;------------------------------------------------------------------------------
_ED_TransformLineSpacing_Mode3:
    LINK.W  A5,#-92
    MOVEM.L D2/D6-D7,-(A7)
    MOVE.L  _ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     _ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferScratch,A0
    ADDA.L  D0,A0
    PEA     40.W
    MOVE.L  A0,-(A7)
    PEA     -49(A5)
    JSR     _ESQFUNC_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    MOVE.L  _ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     _ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferLive,A0
    ADDA.L  D0,A0
    MOVEQ   #39,D0
    LEA     -90(A5),A1

.copy_line_chars:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,.copy_line_chars

    MOVEQ   #0,D7

.scan_leading_spaces:
    MOVEQ   #40,D0
    CMP.L   D0,D7
    BGE.S   .after_leading_spaces

    MOVEQ   #32,D0
    CMP.B   -49(A5,D7.L),D0
    BNE.S   .after_leading_spaces

    LEA     _ED_EditBufferLive,A0
    ADDA.L  _ED_EditCursorOffset,A0
    MOVE.B  (A0),-90(A5,D7.L)
    ADDQ.L  #1,D7
    BRA.S   .scan_leading_spaces

.after_leading_spaces:
    MOVEQ   #0,D6

.scan_trailing_spaces:
    MOVEQ   #40,D0
    CMP.L   D0,D6
    BGE.S   .after_trailing_spaces

    MOVEQ   #39,D0
    MOVE.L  D0,D1
    SUB.L   D6,D1
    MOVEQ   #32,D2
    CMP.B   -49(A5,D1.L),D2
    BNE.S   .after_trailing_spaces

    SUB.L   D6,D0
    LEA     _ED_EditBufferLive,A0
    ADDA.L  _ED_EditCursorOffset,A0
    MOVE.B  (A0),-90(A5,D0.L)
    ADDQ.L  #1,D6
    BRA.S   .scan_trailing_spaces

.after_trailing_spaces:
    MOVE.L  D6,D0
    SUBQ.L  #1,D0
    CMP.L   D0,D7
    BGE.W   .case_swap_spacing

    MOVE.L  D6,D0
    SUB.L   D7,D0
    TST.L   D0
    BPL.S   .compute_half_gap

    ADDQ.L  #1,D0

.compute_half_gap:
    ASR.L   #1,D0
    MOVE.L  D0,D7
    MOVE.L  _ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     _ESQIFF_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D7,D0
    LEA     _ED_EditBufferScratch,A0
    ADDA.L  D0,A0
    MOVEQ   #40,D0
    SUB.L   D7,D0
    LEA     -49(A5),A1
    BRA.S   .copy_prefix_check

.copy_prefix_loop:
    MOVE.B  (A1)+,(A0)+

.copy_prefix_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_prefix_loop

    MOVE.L  _ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     _ESQIFF_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D7,D0
    LEA     _ED_EditBufferLive,A0
    ADDA.L  D0,A0
    MOVEQ   #40,D0
    SUB.L   D7,D0
    LEA     -90(A5),A1
    BRA.S   .copy_attrs_check

.copy_attrs_loop:
    MOVE.B  (A1)+,(A0)+

.copy_attrs_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_attrs_loop

    MOVE.L  _ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     _ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferScratch,A0
    ADDA.L  D0,A0
    MOVEQ   #40,D0
    SUB.L   D7,D0
    LEA     -49(A5),A1
    ADDA.L  D0,A1
    MOVE.L  D7,D0
    BRA.S   .copy_suffix_check

.copy_suffix_loop:
    MOVE.B  (A1)+,(A0)+

.copy_suffix_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_suffix_loop

    MOVE.L  _ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     _ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferLive,A0
    ADDA.L  D0,A0
    MOVEQ   #40,D0
    SUB.L   D7,D0
    LEA     -90(A5),A1
    ADDA.L  D0,A1
    MOVE.L  D7,D0
    BRA.S   .copy_tail_check

.copy_tail_loop:
    MOVE.B  (A1)+,(A0)+

.copy_tail_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_tail_loop

    BRA.W   .return

.case_swap_spacing:
    CMP.L   D6,D7
    BLE.W   .return

    MOVE.L  D7,D0
    SUB.L   D6,D0
    ADDQ.L  #1,D0
    TST.L   D0
    BPL.S   .compute_half_gap_alt

    ADDQ.L  #1,D0

.compute_half_gap_alt:
    ASR.L   #1,D0
    MOVE.L  D0,D7
    MOVE.L  _ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     _ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferScratch,A0
    ADDA.L  D0,A0
    LEA     -49(A5),A1
    ADDA.L  D7,A1
    MOVEQ   #40,D0
    SUB.L   D7,D0
    BRA.S   .copy_prefix2_check

.copy_prefix2_loop:
    MOVE.B  (A1)+,(A0)+

.copy_prefix2_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_prefix2_loop

    MOVE.L  _ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     _ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferLive,A0
    ADDA.L  D0,A0
    LEA     -90(A5),A1
    ADDA.L  D7,A1
    MOVEQ   #40,D0
    SUB.L   D7,D0
    BRA.S   .copy_attrs2_check

.copy_attrs2_loop:
    MOVE.B  (A1)+,(A0)+

.copy_attrs2_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_attrs2_loop

    MOVE.L  _ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     _ESQIFF_JMPTBL_MATH_Mulu32(PC)

    SUB.L   D7,D0
    LEA     _ED_LineTransformSuffixScratchBuffer,A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    LEA     -49(A5),A1
    BRA.S   .copy_suffix2_check

.copy_suffix2_loop:
    MOVE.B  (A1)+,(A0)+

.copy_suffix2_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_suffix2_loop

    MOVE.L  _ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     _ESQIFF_JMPTBL_MATH_Mulu32(PC)

    SUB.L   D7,D0
    LEA     _ED_LineTransformTailScratchBuffer,A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    LEA     -90(A5),A1
    BRA.S   .copy_tail2_check

.copy_tail2_loop:
    MOVE.B  (A1)+,(A0)+

.copy_tail2_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_tail2_loop

.return:
    MOVEM.L (A7)+,D2/D6-D7
    UNLK    A5
    RTS

;!======