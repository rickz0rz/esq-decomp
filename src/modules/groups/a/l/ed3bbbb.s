    XDEF    _ED_ApplyActiveFlagToAdData
    XDEF    ED_CommitCurrentAdEdits
    XDEF    ED_DrawAdEditingScreen
    XDEF    ED_DrawEditHelpText
    XDEF    ED_LoadCurrentAdIntoBuffers
    XDEF    ED_NextAdNumber
    XDEF    ED_PrevAdNumber
    XDEF    ED_RedrawAllRows
    XDEF    ED_RedrawRow
    XDEF    ED_TransformLineSpacing_Mode1
    XDEF    ED_TransformLineSpacing_Mode2
    XDEF    ED_TransformLineSpacing_Mode3
    XDEF    ED_UpdateActiveInactiveIndicator
    XDEF    _ED_UpdateAdNumberDisplay

;------------------------------------------------------------------------------
; FUNC: _ED_UpdateAdNumberDisplay   (Update ad number displayuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A7/D0/D1
; CALLS:
;   GROUP_AM_JMPTBL_WDISP_SPrintf, DISPLIB_DisplayTextAtPosition,
;   ED_UpdateActiveInactiveIndicator
; READS:
;   _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER, ED_AdRecordPtrTable
; WRITES:
;   ED_AdActiveFlag, ED_ViewportOffset, ED_AdDisplayResetFlag, ED_AdDisplayStateLatchBlockB, ED_ActiveIndicatorCachedState, ED_AdDisplayStateLatchA
; DESC:
;   Displays the current ad number and resets editing state for the ad.
; NOTES:
;   Initializes ED_AdActiveFlag based on the ad's active flag.
;   Local display buffer is 40 bytes (-40(A5)..-1(A5)).
;------------------------------------------------------------------------------
_ED_UpdateAdNumberDisplay:

.adLabel = -40

    LINK.W  A5,#-40

    MOVE.L  _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,-(A7)
    PEA     Global_STR_AD_NUMBER_FORMATTED
    PEA     .adLabel(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     .adLabel(A5)
    PEA     180.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     28(A7),A7
    MOVEQ   #0,D0
    MOVE.L  D0,ED_AdActiveFlag
    MOVE.L  _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,D1
    ASL.L   #2,D1
    LEA     ED_AdRecordPtrTable,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    MOVE.W  (A1),D1
    TST.W   D1
    BLE.S   .after_active_check

    MOVEQ   #1,D1
    MOVE.L  D1,ED_AdActiveFlag

.after_active_check:
    MOVEQ   #1,D1
    MOVE.L  D1,ED_AdDisplayResetFlag
    MOVE.L  D0,ED_ViewportOffset
    MOVEQ   #-1,D0
    MOVE.L  D0,ED_AdDisplayStateLatchBlockB
    MOVE.L  D0,ED_ActiveIndicatorCachedState
    MOVE.L  D0,ED_AdDisplayStateLatchA
    BSR.W   ED_UpdateActiveInactiveIndicator

    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _ED_ApplyActiveFlagToAdData   (Apply active flag to ad datauncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A2/A7/D0/D1/D2
; CALLS:
;   (none)
; READS:
;   ED_AdActiveFlag, _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER, ED_AdRecordPtrTable
; WRITES:
;   Ad data (first word / word+2) via ED_AdRecordPtrTable
; DESC:
;   Writes the active/inactive flag for the current ad into its data record.
; NOTES:
;   Clears both words when inactive; sets word0=1 and word2=$30 when active.
;------------------------------------------------------------------------------
_ED_ApplyActiveFlagToAdData:
    MOVEM.L D2/A2,-(A7)

    TST.L   ED_AdActiveFlag
    BNE.S   .set_active

    MOVE.L  _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    MOVE.L  D0,D1
    ASL.L   #2,D1
    LEA     ED_AdRecordPtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVEA.L (A1),A2
    MOVEQ   #0,D2
    MOVE.W  D2,(A2)
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVEA.L (A1),A2
    MOVE.W  D2,2(A2)
    BRA.S   .return

.set_active:
    MOVE.L  _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    ASL.L   #2,D0
    LEA     ED_AdRecordPtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    MOVE.W  #1,(A2)
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.W  #$30,2(A1)

.return:
    MOVEM.L (A7)+,D2/A2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_RedrawAllRows   (Redraw all rowsuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D2/D3/D7
; CALLS:
;   ED_DrawCursorChar, GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble, ESQIFF_JMPTBL_MATH_Mulu32, _LVOSetAPen, _LVORectFill
; READS:
;   ED_EditCursorOffset, ED_BlockOffset, ED_TextLimit, ED_EditBufferLive
; WRITES:
;   ED_EditCursorOffset
; DESC:
;   Redraws all rows using the current buffer contents.
; NOTES:
;   Restores ED_EditCursorOffset to its original value after redraw.
;------------------------------------------------------------------------------
ED_RedrawAllRows:
    MOVEM.L D2-D3/D7,-(A7)

    MOVE.L  ED_EditCursorOffset,D7
    MOVEQ   #0,D0
    MOVE.B  ED_EditBufferLive,D0
    MOVE.L  D0,-(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D0
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.L  ED_TextLimit,D0
    MOVEQ   #30,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #68,D1
    ADD.L   D1,D0
    MOVE.L  D0,D3
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #640,D2
    JSR     _LVORectFill(A6)

    CLR.L   ED_EditCursorOffset

.redraw_loop:
    MOVE.L  ED_EditCursorOffset,D0
    CMP.L   ED_BlockOffset,D0
    BGE.S   .return

    BSR.W   ED_DrawCursorChar

    ADDQ.L  #1,ED_EditCursorOffset
    BRA.S   .redraw_loop

.return:
    MOVE.L  D7,ED_EditCursorOffset
    MOVEM.L (A7)+,D2-D3/D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_RedrawRow   (Redraw a rowuncertain)
; ARGS:
;   stack +4: u32 rowIndex
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D6/D7
; CALLS:
;   ED_DrawCursorChar, ESQIFF_JMPTBL_MATH_Mulu32, _LVOSetAPen, _LVOSetBPen
; READS:
;   ED_EditCursorOffset, ED_BlockOffset, ED_TextLimit
; WRITES:
;   ED_EditCursorOffset
; DESC:
;   Redraws a single row of text based on the given row index.
; NOTES:
;   Temporarily updates ED_EditCursorOffset to walk the row range.
;------------------------------------------------------------------------------
ED_RedrawRow:
    MOVEM.L D6-D7,-(A7)

    MOVE.L  12(A7),D7
    MOVE.L  ED_EditCursorOffset,D6
    MOVE.L  D7,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,ED_EditCursorOffset

.row_loop:
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  ED_EditCursorOffset,D1
    CMP.L   D0,D1
    BGE.S   .row_done

    BSR.W   ED_DrawCursorChar

    ADDQ.L  #1,ED_EditCursorOffset
    BRA.S   .row_loop

.row_done:
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    MOVE.L  D6,ED_EditCursorOffset
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_UpdateActiveInactiveIndicator   (Update active/inactive indicatoruncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   _LVOSetAPen, _LVORectFill, _LVOSetDrMd, DISPLIB_DisplayTextAtPosition
; READS:
;   ED_AdActiveFlag, ED_ActiveIndicatorCachedState, Global_REF_RASTPORT_1
; WRITES:
;   ED_ActiveIndicatorCachedState
; DESC:
;   Updates the active/inactive indicator when the flag changes.
; NOTES:
;   Draws two rectangles and the ACTIVE/INACTIVE label.
;------------------------------------------------------------------------------
ED_UpdateActiveInactiveIndicator:
    MOVEM.L D2-D7,-(A7)

    MOVE.L  ED_AdActiveFlag,D0
    MOVE.L  ED_ActiveIndicatorCachedState,D1
    CMP.L   D0,D1
    BEQ.W   .after_indicator_update

    SUBQ.L  #1,D0
    BNE.S   .select_inactive

    MOVEQ   #110,D7
    NOT.B   D7
    MOVE.L  #265,D6
    MOVEQ   #40,D5
    MOVEQ   #65,D4
    ADD.L   D4,D4
    BRA.S   .draw_indicator

.select_inactive:
    MOVEQ   #40,D7
    MOVEQ   #65,D6
    ADD.L   D6,D6
    MOVEQ   #110,D5
    NOT.B   D5
    MOVE.L  #265,D4

.draw_indicator:
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.L  D7,D0
    MOVE.L  D6,D2
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #68,D1
    MOVEQ   #98,D3
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D5,D0
    MOVE.L  D4,D2
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #68,D1
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     Global_STR_ACTIVE_INACTIVE
    PEA     90.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVE.L  ED_AdActiveFlag,ED_ActiveIndicatorCachedState

.after_indicator_update:
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    MOVEM.L (A7)+,D2-D7
    RTS

;!======

; draw ad editing screen (editing ad)
;------------------------------------------------------------------------------
; FUNC: ED_DrawAdEditingScreen   (Draw ad editing screenuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D2/D3
; CALLS:
;   ED_DrawHelpPanels, SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE,
;   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR,
;   GROUP_AM_JMPTBL_WDISP_SPrintf, DISPLIB_DisplayTextAtPosition,
;   ESQIFF_JMPTBL_MATH_Mulu32, _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
; READS:
;   ED_TextLimit, _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,
;   Global_REF_BOOL_IS_LINE_OR_PAGE, Global_REF_BOOL_IS_TEXT_OR_CURSOR
; WRITES:
;   (none)
; DESC:
;   Draws the ad editing screen header and status indicators.
; NOTES:
;   Uses a 41-byte local printf buffer (-41(A5)..-1(A5)).
;------------------------------------------------------------------------------
ED_DrawAdEditingScreen:
    LINK.W  A5,#-44
    MOVEM.L D2-D3,-(A7)

.printfResult   = -41

    PEA     6.W
    BSR.W   ED_DrawHelpPanels

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     Global_STR_PUSH_ESC_TO_MAKE_ANOTHER_SELECTION
    PEA     330.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_PUSH_HELP_FOR_OTHER_EDIT_FUNCTIONS
    PEA     360.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_LINE_MODE_ON_TEXT_COLOR_MODE
    PEA     390.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  Global_REF_BOOL_IS_LINE_OR_PAGE,(A7)
    BSR.W   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE

    MOVE.L  Global_REF_BOOL_IS_TEXT_OR_CURSOR,(A7)
    BSR.W   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #8,D0
    SUB.L   ED_TextLimit,D0
    MOVEQ   #30,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  #302,D1
    SUB.L   D0,D1
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #640,D2
    MOVE.L  #308,D3
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    JSR     _LVOSetBPen(A6)

    MOVE.L  _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,(A7)
    PEA     Global_STR_EDITING_AD_NUMBER_FORMATTED_1
    PEA     .printfResult(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     .printfResult(A5)
    PEA     300.W
    PEA     190.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     76(A7),A7
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    MOVEM.L (A7)+,D2-D3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_TransformLineSpacing_Mode1   (Transform line spacing mode 1uncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A7/D0/D1/D2/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_MATH_Mulu32, ESQFUNC_JMPTBL_STRING_CopyPadNul
; READS:
;   ED_EditCursorOffset, ED_ViewportOffset
; WRITES:
;   (none observed)
; DESC:
;   Rearranges line buffers according to a spacing rule (mode 1).
; NOTES:
;   Uses local buffers on the stack for processing.
;------------------------------------------------------------------------------
ED_TransformLineSpacing_Mode1:
    LINK.W  A5,#-92
    MOVEM.L D2/D6-D7,-(A7)

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferScratch,A0
    ADDA.L  D0,A0
    PEA     40.W
    MOVE.L  A0,-(A7)
    PEA     -49(A5)
    JSR     ESQFUNC_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferLive,A0
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

    LEA     ED_EditBufferLive,A0
    ADDA.L  ED_EditCursorOffset,A0
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
    LEA     ED_EditBufferLive,A0
    ADDA.L  ED_EditCursorOffset,A0
    MOVE.B  (A0),-90(A5,D0.L)
    ADDQ.L  #1,D6
    BRA.S   .scan_trailing_spaces

.after_space_scan:
    MOVEQ   #40,D0
    CMP.L   D0,D7
    BGE.W   .return

    MOVE.L  ED_ViewportOffset,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferScratch,A0
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

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferLive,A0
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

    MOVE.L  ED_ViewportOffset,D0
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

    MOVE.L  ED_ViewportOffset,D0
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
; FUNC: ED_TransformLineSpacing_Mode2   (Transform line spacing mode 2uncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A7/D0/D1/D2/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_MATH_Mulu32, ESQFUNC_JMPTBL_STRING_CopyPadNul
; READS:
;   ED_EditCursorOffset, ED_ViewportOffset
; WRITES:
;   (none observed)
; DESC:
;   Rearranges line buffers according to a spacing rule (mode 2).
; NOTES:
;   Uses local buffers on the stack for processing.
;------------------------------------------------------------------------------
ED_TransformLineSpacing_Mode2:
    LINK.W  A5,#-92
    MOVEM.L D2/D6-D7,-(A7)
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferScratch,A0
    ADDA.L  D0,A0
    PEA     40.W
    MOVE.L  A0,-(A7)
    PEA     -49(A5)
    JSR     ESQFUNC_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferLive,A0
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
    LEA     ED_EditBufferLive,A0
    ADDA.L  ED_EditCursorOffset,A0
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

    LEA     ED_EditBufferLive,A0
    ADDA.L  ED_EditCursorOffset,A0
    MOVE.B  (A0),-90(A5,D6.L)
    ADDQ.L  #1,D6
    BRA.S   .scan_left_spaces

.after_left_spaces:
    MOVEQ   #40,D0
    CMP.L   D0,D7
    BGE.W   .return

    MOVE.L  ED_ViewportOffset,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D7,D0
    LEA     ED_EditBufferScratch,A0
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

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D7,D0
    LEA     ED_EditBufferLive,A0
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

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferScratch,A0
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

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferLive,A0
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
; FUNC: ED_TransformLineSpacing_Mode3   (Transform line spacing mode 3uncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A7/D0/D1/D2/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_MATH_Mulu32, ESQFUNC_JMPTBL_STRING_CopyPadNul
; READS:
;   ED_EditCursorOffset, ED_ViewportOffset
; WRITES:
;   (none observed)
; DESC:
;   Rearranges line buffers according to a spacing rule (mode 3).
; NOTES:
;   Uses local buffers on the stack for processing.
;------------------------------------------------------------------------------
ED_TransformLineSpacing_Mode3:
    LINK.W  A5,#-92
    MOVEM.L D2/D6-D7,-(A7)
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferScratch,A0
    ADDA.L  D0,A0
    PEA     40.W
    MOVE.L  A0,-(A7)
    PEA     -49(A5)
    JSR     ESQFUNC_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferLive,A0
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

    LEA     ED_EditBufferLive,A0
    ADDA.L  ED_EditCursorOffset,A0
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
    LEA     ED_EditBufferLive,A0
    ADDA.L  ED_EditCursorOffset,A0
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
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D7,D0
    LEA     ED_EditBufferScratch,A0
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

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D7,D0
    LEA     ED_EditBufferLive,A0
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

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferScratch,A0
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

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferLive,A0
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
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferScratch,A0
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

    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     ED_EditBufferLive,A0
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

    MOVE.L  ED_ViewportOffset,D0
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

    MOVE.L  ED_ViewportOffset,D0
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
; FUNC: ED_LoadCurrentAdIntoBuffers   (Load current ad into buffersuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D2/D3/D7
; CALLS:
;   GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault, GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte, ED_RedrawAllRows, ED_DrawCurrentColorIndicator,
;   ED_RedrawCursorChar,
;   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE,
;   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR,
;   GROUP_AM_JMPTBL_WDISP_SPrintf, DISPLIB_DisplayTextAtPosition,
;   ESQIFF_JMPTBL_MATH_Mulu32, _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd, _LVORectFill
; READS:
;   _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER, ED_BlockOffset, ED_TextLimit
; WRITES:
;   ED_EditCursorOffset, ED_ViewportOffset, ED_AdDisplayResetFlag, Global_REF_BOOL_IS_LINE_OR_PAGE,
;   Global_REF_BOOL_IS_TEXT_OR_CURSOR
; DESC:
;   Loads the current ad into edit buffers and refreshes the screen.
; NOTES:
;   Pads buffers to ED_BlockOffset and redraws the header/status areas.
;   Uses a 44-byte local printf target (-44(A5)..-1(A5)).
;------------------------------------------------------------------------------
ED_LoadCurrentAdIntoBuffers:

.editingAdLabel = -44

    LINK.W  A5,#-48
    MOVEM.L D2-D3/D7,-(A7)
    MOVE.L  _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    SUBQ.L  #1,D0
    PEA     ED_EditBufferLive
    PEA     ED_EditBufferScratch
    MOVE.L  D0,-(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault(PC)

    LEA     12(A7),A7
    LEA     ED_EditBufferScratch,A0
    MOVEA.L A0,A1

.find_string_end:
    TST.B   (A1)+
    BNE.S   .find_string_end

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D7
    MOVE.L  ED_BlockOffset,D0
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

    LEA     ED_EditBufferLive,A0
    ADDA.L  D7,A0
    PEA     1.W
    PEA     2.W
    MOVE.L  A0,20(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  ED_BlockOffset,D0
    SUB.L   D7,D0
    MOVEA.L 12(A7),A0
    BRA.S   .fill_attr_check

.fill_attr_loop:
    MOVE.B  D1,(A0)+

.fill_attr_check:
    SUBQ.L  #1,D0
    BCC.S   .fill_attr_loop

.after_pad:
    LEA     ED_EditBufferScratch,A0
    ADDA.L  ED_BlockOffset,A0
    CLR.B   (A0)
    MOVEQ   #1,D0
    MOVE.L  D0,ED_AdDisplayResetFlag
    BSR.W   ED_RedrawAllRows

    MOVEQ   #0,D0
    MOVE.L  D0,ED_EditCursorOffset
    MOVE.L  D0,ED_ViewportOffset
    MOVE.L  D0,Global_REF_BOOL_IS_LINE_OR_PAGE
    MOVE.L  D0,-(A7)
    BSR.W   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE

    MOVEQ   #1,D0
    MOVE.L  D0,Global_REF_BOOL_IS_TEXT_OR_CURSOR
    MOVE.L  D0,(A7)
    BSR.W   SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #8,D0
    SUB.L   ED_TextLimit,D0
    MOVEQ   #30,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  #302,D1
    SUB.L   D0,D1
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #640,D2
    MOVE.L  #308,D3
    JSR     _LVORectFill(A6)

    MOVEQ   #0,D0
    MOVE.B  ED_EditBufferLive,D0
    MOVE.L  D0,(A7)
    BSR.W   ED_DrawCurrentColorIndicator

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    JSR     _LVOSetBPen(A6)

    MOVE.L  _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,(A7)
    PEA     Global_STR_EDITING_AD_NUMBER_FORMATTED_2
    PEA     .editingAdLabel(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     .editingAdLabel(A5)
    PEA     300.W
    PEA     190.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    ; Set drawing mode to 1
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    ; Set B pen to 2
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    BSR.W   ED_RedrawCursorChar

    MOVEM.L -60(A5),D2-D3/D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_CommitCurrentAdEdits   (Commit current ad editsuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A7/D0
; CALLS:
;   GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex
; READS:
;   _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
; WRITES:
;   (none)
; DESC:
;   Commits the current ad buffers to storage.
; NOTES:
;   Calls GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex with (adNumber-1).
;------------------------------------------------------------------------------
ED_CommitCurrentAdEdits:
    MOVE.L  _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    SUBQ.L  #1,D0
    PEA     ED_EditBufferLive
    PEA     ED_EditBufferScratch
    MOVE.L  D0,-(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex(PC)

    LEA     12(A7),A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_NextAdNumber   (Advance to next ad numberuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0
; CALLS:
;   ED_CommitCurrentAdEdits, ED_LoadCurrentAdIntoBuffers
; READS:
;   _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER, _ED_MaxAdNumber
; WRITES:
;   _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
; DESC:
;   Commits current edits then advances to the next ad.
; NOTES:
;   No-op if already at _ED_MaxAdNumber.
;------------------------------------------------------------------------------
ED_NextAdNumber:
    MOVE.L  _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    CMP.L   _ED_MaxAdNumber,D0
    BGE.S   .return

    BSR.S   ED_CommitCurrentAdEdits

    ADDQ.L  #1,_Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BSR.W   ED_LoadCurrentAdIntoBuffers

.return:
    RTS

;!======

; Decrement the current ad number being edited
;------------------------------------------------------------------------------
; FUNC: ED_PrevAdNumber   (Go to previous ad numberuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   (none)
; CALLS:
;   ED_CommitCurrentAdEdits, ED_LoadCurrentAdIntoBuffers
; READS:
;   _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
; WRITES:
;   _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
; DESC:
;   Commits current edits then moves to the previous ad.
; NOTES:
;   No-op when current ad number is 1.
;------------------------------------------------------------------------------
ED_PrevAdNumber:
    CMPI.L  #$1,_Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BLE.S   .return

    BSR.S   ED_CommitCurrentAdEdits

    SUBQ.L  #1,_Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BSR.W   ED_LoadCurrentAdIntoBuffers

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_DrawEditHelpText   (Draw edit help textuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D2/D3
; CALLS:
;   _ED_DrawBottomHelpBarBackground, DISPLIB_DisplayTextAtPosition,
;   _LVOSetAPen, _LVOSetDrMd, _LVORectFill
; READS:
;   Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the help text for editing operations.
; NOTES:
;   Uses a fixed list of help strings.
;------------------------------------------------------------------------------
ED_DrawEditHelpText:
    MOVEM.L D2-D3,-(A7)

    BSR.W   _ED_DrawBottomHelpBarBackground

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVEQ   #68,D1
    MOVE.L  #$280,D2
    MOVE.L  #$165,D3
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #$166,D1
    MOVE.L  #$1ad,D3
    JSR     _LVORectFill(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     ED2_STR_PUSH_ANY_KEY_TO_CONTINUE_DOT
    PEA     390.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     ED2_STR_STAR_STAR_LINE_SLASH_PAGE_COMMANDS_S
    PEA     90.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     ED2_STR_F1_COLON_HOME_F6_COLON_CLEAR
    PEA     120.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     ED2_STR_F2_COLON_LINE_SLASH_PAGE_MODE_F7_COL
    PEA     150.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     ED2_CMD_F3_COLON_CENTER_F8_COLON_DELETE_LINE
    PEA     180.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     80(A7),A7
    PEA     ED2_STR_F4_COLON_LEFT_JUSTIFY_F9_COLON_APPLY
    PEA     210.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     ED2_STR_F5_COLON_RIGHT_JUSTIFY_F10_COLON_INS
    PEA     240.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_SHIFT_RIGHT_NEXT_AD_DEL_DELETE_CHAR
    PEA     270.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_SHIFT_LEFT_PREV_AD_CTRLC_COLOR_MODE
    PEA     300.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_CTRLF_FOREGROUND_CTRLB_BACKGROUND
    PEA     330.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     80(A7),A7

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEM.L (A7)+,D2-D3
    RTS

;!======

    ; Alignment
    ALIGN_WORD
