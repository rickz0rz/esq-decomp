    XDEF    _NEWGRID_DrawShowtimesPrompt


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_DrawShowtimesPrompt   (Build and render centered showtimes prompt text)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: A2 = output buffer
;   stack +16: D7 = mode selector
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _NEWGRID2_JMPTBL_STR_SkipClass3Chars, _NEWGRID2_JMPTBL_STRING_AppendN, _PARSEINI_JMPTBL_STRING_AppendAtNull,
;   _NEWGRID_DrawGridFrame, _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight, _LVOSetAPen, _LVOSetDrMd,
;   _LVOTextLength, _LVOMove, _LVOText, _NEWGRID_ValidateSelectionCode
; READS:
;   _SCRIPT_PtrSportsOnPrefix, _SCRIPT_PtrSummaryOfPrefix, _SCRIPT_PtrChannelSuffix, _NEWGRID_RowHeightPx, _NEWGRID_ColumnStartXPx, _NEWGRID_ColumnWidthPx
; WRITES:
;   output buffer contents, 32(A3), 52(A3)
; DESC:
;   Builds a prompt string and centers it inside a grid frame.
;------------------------------------------------------------------------------
_NEWGRID_DrawShowtimesPrompt:
    LINK.W  A5,#-168
    MOVEM.L D2/D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7
    MOVE.L  A2,D0
    BEQ.W   .return

    LEA     19(A2),A0
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-4(A5)
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    LEA     1(A2),A0
    MOVE.L  A0,(A7)
    MOVE.L  D0,-4(A5)
    MOVE.L  A0,-8(A5)
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-8(A5)
    TST.L   D7
    BNE.S   .copy_prompt_b

    MOVEA.L _SCRIPT_PtrSummaryOfPrefix,A0
    LEA     -136(A5),A1

.copy_prompt_a:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_prompt_a

    BRA.S   .prompt_done

.copy_prompt_b:
    MOVEA.L _SCRIPT_PtrSportsOnPrefix,A0
    LEA     -136(A5),A1

.copy_prompt_b_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_prompt_b_loop

.prompt_done:
    MOVEA.L -4(A5),A0

.measure_prompt:
    TST.B   (A0)+
    BNE.S   .measure_prompt

    SUBQ.L  #1,A0
    SUBA.L  -4(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     -136(A5)
    JSR     _NEWGRID2_JMPTBL_STRING_AppendN(PC)

    LEA     12(A7),A7
    TST.L   -8(A5)
    BEQ.S   .draw_frame

    MOVEA.L -8(A5),A0
    TST.B   (A0)
    BEQ.S   .draw_frame

    MOVE.L  _SCRIPT_PtrChannelSuffix,-(A7)
    PEA     -136(A5)
    JSR     _PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    TST.W   _Global_WORD_SELECT_CODE_IS_RAVESC
    BEQ.S   .append_suffix

    MOVEA.L -8(A5),A0
    LEA     -146(A5),A1

.copy_suffix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_suffix

    CLR.B   -144(A5)
    PEA     -146(A5)
    PEA     -136(A5)
    JSR     _PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    PEA     _NEWGRID_ShowtimeRangeDash
    PEA     -136(A5)
    JSR     _PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    MOVEA.L -8(A5),A0
    ADDQ.L  #2,A0
    MOVE.L  A0,(A7)
    PEA     -136(A5)
    JSR     _PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     20(A7),A7
    BRA.S   .draw_frame

.append_suffix:
    MOVE.L  -8(A5),-(A7)
    PEA     -136(A5)
    JSR     _PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.draw_frame:
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #6,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,-(A7)
    MOVEQ   #6,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID_DrawGridFrame(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    PEA     33.W
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    PEA     33.W
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #3,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVE.W  _NEWGRID_ColumnWidthPx,D1
    MULU    #3,D1
    LEA     60(A3),A1
    LEA     -136(A5),A6
    MOVE.L  A0,80(A7)
    MOVEA.L A6,A0

.measure_text:
    TST.B   (A0)+
    BNE.S   .measure_text

    SUBQ.L  #1,A0
    SUBA.L  A6,A0
    MOVE.L  D0,84(A7)
    MOVE.L  D1,88(A7)
    MOVE.L  A0,96(A7)
    MOVEA.L A6,A0
    MOVE.L  96(A7),D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  88(A7),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .center_x

    ADDQ.L  #1,D1

.center_x:
    ASR.L   #1,D1
    MOVE.L  84(A7),D0
    ADD.L   D1,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    MOVEQ   #34,D2
    SUB.L   D1,D2
    TST.L   D2
    BPL.S   .center_y

    ADDQ.L  #1,D2

.center_y:
    ASR.L   #1,D2
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D2
    SUBQ.L  #1,D2
    MOVE.L  D2,D1
    MOVEA.L 80(A7),A1
    JSR     _LVOMove(A6)

    LEA     60(A3),A0
    LEA     -136(A5),A1
    MOVEA.L A1,A6

.draw_text:
    TST.B   (A6)+
    BNE.S   .draw_text

    SUBQ.L  #1,A6
    SUBA.L  A1,A6
    MOVEA.L A0,A1
    MOVE.L  A6,D0
    LEA     -136(A5),A0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

    MOVEQ   #17,D0
    MOVE.W  D0,52(A3)
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,32(A3)
    PEA     67.W
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ValidateSelectionCode

    LEA     68(A7),A7

.return:
    MOVEM.L (A7)+,D2/D7/A2-A3/A6
    UNLK    A5
    RTS

;!======