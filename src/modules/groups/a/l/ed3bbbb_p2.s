    XDEF    _ED_DrawAdEditingScreen
    XDEF    _ED_LoadCurrentAdIntoBuffers
    XDEF    _ED_TransformLineSpacing_Mode1
    XDEF    _ED_TransformLineSpacing_Mode2
    XDEF    _ED_TransformLineSpacing_Mode3


; draw ad editing screen (editing ad)
;------------------------------------------------------------------------------
; FUNC: _ED_DrawAdEditingScreen   (Draw ad editing screenuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D2/D3
; CALLS:
;   _ED_DrawHelpPanels, SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE,
;   _SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR,
;   _GROUP_AM_JMPTBL_WDISP_SPrintf, _DISPLIB_DisplayTextAtPosition,
;   ESQIFF_JMPTBL_MATH_Mulu32, _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
; READS:
;   _ED_TextLimit, _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,
;   _Global_REF_BOOL_IS_LINE_OR_PAGE, _Global_REF_BOOL_IS_TEXT_OR_CURSOR
; WRITES:
;   (none)
; DESC:
;   Draws the ad editing screen header and status indicators.
; NOTES:
;   Uses a 41-byte local printf buffer (-41(A5)..-1(A5)).
;------------------------------------------------------------------------------
_ED_DrawAdEditingScreen:
    LINK.W  A5,#-44
    MOVEM.L D2-D3,-(A7)

.printfResult   = -41

    PEA     6.W
    BSR.W   _ED_DrawHelpPanels

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     Global_STR_PUSH_ESC_TO_MAKE_ANOTHER_SELECTION
    PEA     330.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_PUSH_HELP_FOR_OTHER_EDIT_FUNCTIONS
    PEA     360.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_LINE_MODE_ON_TEXT_COLOR_MODE
    PEA     390.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  _Global_REF_BOOL_IS_LINE_OR_PAGE,(A7)
    BSR.W   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE

    MOVE.L  _Global_REF_BOOL_IS_TEXT_OR_CURSOR,(A7)
    BSR.W   _SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #8,D0
    SUB.L   _ED_TextLimit,D0
    MOVEQ   #30,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  #302,D1
    SUB.L   D0,D1
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #640,D2
    MOVE.L  #308,D3
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    JSR     _LVOSetBPen(A6)

    MOVE.L  _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,(A7)
    PEA     Global_STR_EDITING_AD_NUMBER_FORMATTED_1
    PEA     .printfResult(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     .printfResult(A5)
    PEA     300.W
    PEA     190.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     76(A7),A7
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    MOVEM.L (A7)+,D2-D3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _ED_TransformLineSpacing_Mode1   (Transform line spacing mode 1uncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A7/D0/D1/D2/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_MATH_Mulu32, ESQFUNC_JMPTBL_STRING_CopyPadNul
; READS:
;   _ED_EditCursorOffset, _ED_ViewportOffset
; WRITES:
;   (none observed)
; DESC:
;   Rearranges line buffers according to a spacing rule (mode 1).
; NOTES:
;   Uses local buffers on the stack for processing.
;------------------------------------------------------------------------------
_ED_TransformLineSpacing_Mode1:
    LINK.W  A5,#-92
    MOVEM.L D2/D6-D7,-(A7)

    MOVE.L  _ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferScratch,A0
    ADDA.L  D0,A0
    PEA     40.W
    MOVE.L  A0,-(A7)
    PEA     -49(A5)
    JSR     ESQFUNC_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    MOVE.L  _ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

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
    BGE.S   .after_space_scan

    MOVEQ   #39,D0
    MOVE.L  D0,D1
    SUB.L   D6,D1
    MOVEQ   #32,D2
    CMP.B   -49(A5,D1.L),D2
    BNE.S   .after_space_scan

    SUB.L   D6,D0
    LEA     _ED_EditBufferLive,A0
    ADDA.L  _ED_EditCursorOffset,A0
    MOVE.B  (A0),-90(A5,D0.L)
    ADDQ.L  #1,D6
    BRA.S   .scan_trailing_spaces

.after_space_scan:
    MOVEQ   #40,D0
    CMP.L   D0,D7
    BGE.W   .return

    MOVE.L  _ED_ViewportOffset,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferScratch,A0
    ADDA.L  D0,A0
    LEA     -49(A5),A1
    ADDA.L  D7,A1
    MOVEQ   #40,D0
    SUB.L   D7,D0
    BRA.S   .copy_prefix_check

.copy_prefix_loop:
    MOVE.B  (A1)+,(A0)+

.copy_prefix_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_prefix_loop

    MOVE.L  _ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferLive,A0
    ADDA.L  D0,A0
    LEA     -90(A5),A1
    ADDA.L  D7,A1
    MOVEQ   #40,D0
    SUB.L   D7,D0
    BRA.S   .copy_attrs_check

.copy_attrs_loop:
    MOVE.B  (A1)+,(A0)+

.copy_attrs_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_attrs_loop

    MOVE.L  _ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    SUB.L   D7,D0
    LEA     ED_LineTransformSuffixScratchBuffer,A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    LEA     -49(A5),A1
    BRA.S   .copy_suffix_check

.copy_suffix_loop:
    MOVE.B  (A1)+,(A0)+

.copy_suffix_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_suffix_loop

    MOVE.L  _ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    SUB.L   D7,D0
    LEA     ED_LineTransformTailScratchBuffer,A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    LEA     -90(A5),A1
    BRA.S   .copy_tail_check

.copy_tail_loop:
    MOVE.B  (A1)+,(A0)+

.copy_tail_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_tail_loop

.return:
    MOVEM.L (A7)+,D2/D6-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _ED_TransformLineSpacing_Mode2   (Transform line spacing mode 2uncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A7/D0/D1/D2/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_MATH_Mulu32, ESQFUNC_JMPTBL_STRING_CopyPadNul
; READS:
;   _ED_EditCursorOffset, _ED_ViewportOffset
; WRITES:
;   (none observed)
; DESC:
;   Rearranges line buffers according to a spacing rule (mode 2).
; NOTES:
;   Uses local buffers on the stack for processing.
;------------------------------------------------------------------------------
_ED_TransformLineSpacing_Mode2:
    LINK.W  A5,#-92
    MOVEM.L D2/D6-D7,-(A7)
    MOVE.L  _ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferScratch,A0
    ADDA.L  D0,A0
    PEA     40.W
    MOVE.L  A0,-(A7)
    PEA     -49(A5)
    JSR     ESQFUNC_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    MOVE.L  _ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferLive,A0
    ADDA.L  D0,A0
    MOVEQ   #39,D0
    LEA     -90(A5),A1

.copy_line_chars:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,.copy_line_chars
    MOVEQ   #0,D7

.scan_right_spaces:
    MOVEQ   #40,D0
    CMP.L   D0,D7
    BGE.S   .after_right_spaces

    MOVEQ   #39,D0
    MOVE.L  D0,D1
    SUB.L   D7,D1
    MOVEQ   #32,D2
    CMP.B   -49(A5,D1.L),D2
    BNE.S   .after_right_spaces

    SUB.L   D7,D0
    LEA     _ED_EditBufferLive,A0
    ADDA.L  _ED_EditCursorOffset,A0
    MOVE.B  (A0),-90(A5,D0.L)
    ADDQ.L  #1,D7
    BRA.S   .scan_right_spaces

.after_right_spaces:
    MOVEQ   #0,D6

.scan_left_spaces:
    MOVEQ   #40,D0
    CMP.L   D0,D6
    BGE.S   .after_left_spaces

    MOVEQ   #32,D0
    CMP.B   -49(A5,D6.L),D0
    BNE.S   .after_left_spaces

    LEA     _ED_EditBufferLive,A0
    ADDA.L  _ED_EditCursorOffset,A0
    MOVE.B  (A0),-90(A5,D6.L)
    ADDQ.L  #1,D6
    BRA.S   .scan_left_spaces

.after_left_spaces:
    MOVEQ   #40,D0
    CMP.L   D0,D7
    BGE.W   .return

    MOVE.L  _ED_ViewportOffset,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D7,D0
    LEA     _ED_EditBufferScratch,A0
    ADDA.L  D0,A0
    MOVEQ   #40,D0
    SUB.L   D7,D0
    LEA     -49(A5),A1
    BRA.S   .copy_line_check

.copy_line_loop:
    MOVE.B  (A1)+,(A0)+

.copy_line_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_line_loop

    MOVE.L  _ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

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
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferScratch,A0
    ADDA.L  D0,A0
    MOVEQ   #40,D0
    SUB.L   D7,D0
    LEA     -49(A5),A1
    ADDA.L  D0,A1
    MOVE.L  D7,D0
    BRA.S   .copy_tail_line_check

.copy_tail_line_loop:
    MOVE.B  (A1)+,(A0)+

.copy_tail_line_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_tail_line_loop

    MOVE.L  _ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferLive,A0
    ADDA.L  D0,A0
    MOVEQ   #40,D0
    SUB.L   D7,D0
    LEA     -90(A5),A1
    ADDA.L  D0,A1
    MOVE.L  D7,D0
    BRA.S   .copy_tail_attrs_check

.copy_tail_attrs_loop:
    MOVE.B  (A1)+,(A0)+

.copy_tail_attrs_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_tail_attrs_loop

.return:
    MOVEM.L (A7)+,D2/D6-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _ED_TransformLineSpacing_Mode3   (Transform line spacing mode 3uncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A7/D0/D1/D2/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_MATH_Mulu32, ESQFUNC_JMPTBL_STRING_CopyPadNul
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
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     _ED_EditBufferScratch,A0
    ADDA.L  D0,A0
    PEA     40.W
    MOVE.L  A0,-(A7)
    PEA     -49(A5)
    JSR     ESQFUNC_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    MOVE.L  _ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

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
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

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
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

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
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

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
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

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
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

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
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

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
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    SUB.L   D7,D0
    LEA     ED_LineTransformSuffixScratchBuffer,A0
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
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    SUB.L   D7,D0
    LEA     ED_LineTransformTailScratchBuffer,A0
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

;------------------------------------------------------------------------------
; FUNC: _ED_LoadCurrentAdIntoBuffers   (Load current ad into buffersuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D2/D3/D7
; CALLS:
;   GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault, GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte, _ED_RedrawAllRows, _ED_DrawCurrentColorIndicator,
;   _ED_RedrawCursorChar,
;   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE,
;   _SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR,
;   _GROUP_AM_JMPTBL_WDISP_SPrintf, _DISPLIB_DisplayTextAtPosition,
;   ESQIFF_JMPTBL_MATH_Mulu32, _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd, _LVORectFill
; READS:
;   _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER, _ED_BlockOffset, _ED_TextLimit
; WRITES:
;   _ED_EditCursorOffset, _ED_ViewportOffset, _ED_AdDisplayResetFlag, _Global_REF_BOOL_IS_LINE_OR_PAGE,
;   _Global_REF_BOOL_IS_TEXT_OR_CURSOR
; DESC:
;   Loads the current ad into edit buffers and refreshes the screen.
; NOTES:
;   Pads buffers to _ED_BlockOffset and redraws the header/status areas.
;   Uses a 44-byte local printf target (-44(A5)..-1(A5)).
;------------------------------------------------------------------------------
_ED_LoadCurrentAdIntoBuffers:

.editingAdLabel = -44

    LINK.W  A5,#-48
    MOVEM.L D2-D3/D7,-(A7)
    MOVE.L  _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    SUBQ.L  #1,D0
    PEA     _ED_EditBufferLive
    PEA     _ED_EditBufferScratch
    MOVE.L  D0,-(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault(PC)

    LEA     12(A7),A7
    LEA     _ED_EditBufferScratch,A0
    MOVEA.L A0,A1

.find_string_end:
    TST.B   (A1)+
    BNE.S   .find_string_end

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D7
    MOVE.L  _ED_BlockOffset,D0
    CMP.L   D0,D7
    BGE.S   .after_pad

    ADDA.L  D7,A0
    SUB.L   D7,D0
    MOVEQ   #32,D1
    BRA.S   .pad_spaces_check

.pad_spaces_loop:
    MOVE.B  D1,(A0)+

.pad_spaces_check:
    SUBQ.L  #1,D0
    BCC.S   .pad_spaces_loop

    LEA     _ED_EditBufferLive,A0
    ADDA.L  D7,A0
    PEA     1.W
    PEA     2.W
    MOVE.L  A0,20(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  _ED_BlockOffset,D0
    SUB.L   D7,D0
    MOVEA.L 12(A7),A0
    BRA.S   .fill_attr_check

.fill_attr_loop:
    MOVE.B  D1,(A0)+

.fill_attr_check:
    SUBQ.L  #1,D0
    BCC.S   .fill_attr_loop

.after_pad:
    LEA     _ED_EditBufferScratch,A0
    ADDA.L  _ED_BlockOffset,A0
    CLR.B   (A0)
    MOVEQ   #1,D0
    MOVE.L  D0,_ED_AdDisplayResetFlag
    BSR.W   _ED_RedrawAllRows

    MOVEQ   #0,D0
    MOVE.L  D0,_ED_EditCursorOffset
    MOVE.L  D0,_ED_ViewportOffset
    MOVE.L  D0,_Global_REF_BOOL_IS_LINE_OR_PAGE
    MOVE.L  D0,-(A7)
    BSR.W   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE

    MOVEQ   #1,D0
    MOVE.L  D0,_Global_REF_BOOL_IS_TEXT_OR_CURSOR
    MOVE.L  D0,(A7)
    BSR.W   _SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #8,D0
    SUB.L   _ED_TextLimit,D0
    MOVEQ   #30,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  #302,D1
    SUB.L   D0,D1
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #640,D2
    MOVE.L  #308,D3
    JSR     _LVORectFill(A6)

    MOVEQ   #0,D0
    MOVE.B  _ED_EditBufferLive,D0
    MOVE.L  D0,(A7)
    BSR.W   _ED_DrawCurrentColorIndicator

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    JSR     _LVOSetBPen(A6)

    MOVE.L  _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,(A7)
    PEA     Global_STR_EDITING_AD_NUMBER_FORMATTED_2
    PEA     .editingAdLabel(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     .editingAdLabel(A5)
    PEA     300.W
    PEA     190.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    ; Set drawing mode to 1
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    ; Set B pen to 2
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    BSR.W   _ED_RedrawCursorChar

    MOVEM.L -60(A5),D2-D3/D7
    UNLK    A5
    RTS

;!======