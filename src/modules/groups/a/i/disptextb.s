    XDEF    DISPTEXT_ComputeVisibleLineCount
    XDEF    DISPTEXT_GetTotalLineCount
    XDEF    DISPTEXT_HasMultipleLines
    XDEF    DISPTEXT_IsCurrentLineLast
    XDEF    DISPTEXT_IsLastLineSelected
    XDEF    DISPTEXT_MeasureCurrentLineLength
    XDEF    DISPTEXT_RenderCurrentLine

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
;   _DISPTEXT_FinalizeLineTable, _GROUP_AG_JMPTBL_MATH_Mulu32, _GROUP_AI_JMPTBL_STR_FindCharPtr
; READS:
;   _DISPTEXT_TargetLineIndex/21D6/21DC/21D3, _NEWGRID_RowHeightPx
; WRITES:
;   (none observed)
; DESC:
;   Computes a derived line count with optional prefix adjustments.
; NOTES:
;   Uses booleanize pattern on _DISPTEXT_ControlMarkersEnabledFlag.
;------------------------------------------------------------------------------
DISPTEXT_ComputeVisibleLineCount:
    LINK.W  A5,#-12
    MOVEM.L D5-D7,-(A7)
    MOVE.L  8(A5),D7
    BSR.W   _DISPTEXT_FinalizeLineTable

    MOVEQ   #0,D0
    MOVE.W  _DISPTEXT_TargetLineIndex,D0
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
    MOVE.W  _NEWGRID_RowHeightPx,D1
    MOVE.L  D6,D0
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

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
    TST.W   _DISPTEXT_ControlMarkersEnabledFlag
    BEQ.S   .return

    MOVE.W  _DISPTEXT_TargetLineIndex,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ASL.L   #2,D1
    LEA     _DISPTEXT_TextBufferPtr,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-12(A5)
    BEQ.S   .return

    PEA     19.W
    MOVE.L  A1,-(A7)
    JSR     _GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .return

    PEA     20.W
    MOVE.L  -12(A5),-(A7)
    JSR     _GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

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
;   D0: _DISPTEXT_TargetLineIndex
; CLOBBERS:
;   D0
; CALLS:
;   _DISPTEXT_FinalizeLineTable
; READS:
;   _DISPTEXT_TargetLineIndex
; WRITES:
;   (none observed)
; DESC:
;   Returns the total number of lines after ensuring state is current.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISPTEXT_GetTotalLineCount:
    BSR.W   _DISPTEXT_FinalizeLineTable

    MOVEQ   #0,D0
    MOVE.W  _DISPTEXT_TargetLineIndex,D0
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
;   _DISPTEXT_FinalizeLineTable
; READS:
;   _DISPTEXT_TargetLineIndex/21D6
; WRITES:
;   (none observed)
; DESC:
;   Returns true when more than one line is available.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISPTEXT_HasMultipleLines:
    BSR.W   _DISPTEXT_FinalizeLineTable

    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    BNE.S   .return_false

    MOVE.W  _DISPTEXT_TargetLineIndex,D0
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
;   _DISPTEXT_FinalizeLineTable
; READS:
;   _DISPTEXT_TargetLineIndex/21D6
; WRITES:
;   (none observed)
; DESC:
;   Returns true if current line index is the last line.
; NOTES:
;   Booleanize pattern: SEQ/NEG/EXT.
;------------------------------------------------------------------------------
DISPTEXT_IsLastLineSelected:
    MOVE.L  D2,-(A7)
    BSR.W   _DISPTEXT_FinalizeLineTable

    MOVEQ   #0,D0
    MOVE.W  _DISPTEXT_TargetLineIndex,D0
    SUBQ.L  #1,D0
    MOVEQ   #0,D1
    MOVE.W  _DISPTEXT_CurrentLineIndex,D1
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
;   _DISPTEXT_FinalizeLineTable
; READS:
;   _DISPTEXT_TargetLineIndex/21D6
; WRITES:
;   (none observed)
; DESC:
;   Returns true if _DISPTEXT_CurrentLineIndex equals _DISPTEXT_TargetLineIndex.
; NOTES:
;   Booleanize pattern: SEQ/NEG/EXT.
;------------------------------------------------------------------------------
DISPTEXT_IsCurrentLineLast:
    MOVE.L  D2,-(A7)
    BSR.W   _DISPTEXT_FinalizeLineTable

    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    MOVE.W  _DISPTEXT_TargetLineIndex,D1
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
;   _DISPTEXT_FinalizeLineTable, _LVOTextLength
; READS:
;   _DISPTEXT_LinePtrTable/21D6/21D7
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
    BSR.W   _DISPTEXT_FinalizeLineTable

    MOVEQ   #0,D0
    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    ASL.L   #2,D0
    LEA     _DISPTEXT_LinePtrTable,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    ADD.L   D0,D0
    LEA     _DISPTEXT_LineLengthTable,A1
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
;   _DISPTEXT_FinalizeLineTable, _LVOSetAPen, _LVOSetDrMd, _LVOMove, _LVOText, _GROUP_AI_JMPTBL_STR_FindCharPtr, GROUP_AI_JMPTBL_TLIBA1_DrawTextWithInsetSegments
; READS:
;   _DISPTEXT_LinePtrTable/21D6/21D7/21D9/21DC/21B1/21B2/21D8
; WRITES:
;   _DISPTEXT_CurrentLineIndex, _DISPTEXT_ControlMarkerXOffsetPx
; DESC:
;   Draws the current line at the given position, honoring highlight markers.
; NOTES:
;   Uses 0x13/0x14 control markers when _DISPTEXT_ControlMarkersEnabledFlag set.
;------------------------------------------------------------------------------
DISPTEXT_RenderCurrentLine:
    LINK.W  A5,#-12
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    BSR.W   _DISPTEXT_FinalizeLineTable

    MOVEQ   #0,D0
    MOVE.L  D0,_DISPTEXT_ControlMarkerXOffsetPx
    MOVE.L  _DISPTEXT_LineWidthPx,D1
    TST.L   D1
    BLE.W   .return

    MOVE.W  _DISPTEXT_CurrentLineIndex,D1
    MOVE.W  _DISPTEXT_TargetLineIndex,D2
    CMP.W   D2,D1
    BCC.W   .return

    MOVEQ   #0,D2
    MOVE.W  D1,D2
    ASL.L   #2,D2
    LEA     _DISPTEXT_LinePtrTable,A0
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
    LEA     _DISPTEXT_LineLengthTable,A0
    ADDA.L  D3,A0
    MOVEQ   #0,D4
    MOVE.W  (A0),D4
    TST.L   D4
    BLE.W   .return

    LEA     _DISPTEXT_LinePenTable,A0
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
    TST.W   _DISPTEXT_ControlMarkersEnabledFlag
    BEQ.S   .draw_plain

    PEA     19.W
    MOVE.L  A0,-(A7)
    JSR     _GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .draw_plain

    PEA     20.W
    MOVE.L  -6(A5),-(A7)
    JSR     _GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .draw_plain

    MOVEQ   #0,D0
    MOVE.B  DISPTEXT_InsetNibbleSecondary,D0
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
    MOVE.L  D0,_DISPTEXT_ControlMarkerXOffsetPx
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
    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DISPTEXT_CurrentLineIndex

.return:
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS
